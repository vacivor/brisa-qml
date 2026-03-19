import QtQuick

Item {
    id: root

    property var options: []
    property var nodes: options
    property var value: undefined
    property var defaultValue: null
    property string placeholder: "Please Select"
    property string size: "medium"
    property bool disabled: false
    property bool multiple: false
    property bool checkable: false
    property bool cascade: false
    property string checkStrategy: "all" // all | parent | child
    property bool clearable: false
    property bool filterable: false
    property bool clearFilterAfterSelect: true
    property bool showLine: false
    property bool defaultExpandAll: false
    property var defaultExpandedKeys: []
    property var expandedKeys: undefined
    property int indent: 28
    property string keyField: "key"
    property string labelField: "label"
    property string childrenField: "children"
    property string disabledField: "disabled"
    property string emptyText: "No Data"
    property bool open: false
    property string query: ""
    property var hoveredKey: null
    property bool focusingFilterAfterOpen: false

    property var internalValue: defaultValue
    property var internalExpandedKeys: []

    signal updateValue(var value, var option, var meta)
    signal updateExpandedKeys(var keys, var meta)

    Theme { id: theme }

    readonly property var currentValue: value !== undefined ? value : internalValue
    readonly property var currentExpandedKeys: expandedKeys !== undefined ? expandedKeys : internalExpandedKeys
    readonly property int controlHeight: theme.heightFor(size)
    readonly property bool isMultipleLike: multiple || checkable
    readonly property var selectedKeys: normalizedValue()
    readonly property var selectedOptions: optionsForKeys(selectedKeys)
    readonly property bool hasSelection: isMultipleLike ? selectedKeys.length > 0 : currentValue !== null && currentValue !== undefined && currentValue !== ""
    readonly property bool showingClear: clearable && hasSelection && !disabled && !open
    readonly property var checkedKeys: resolvedCheckedKeys()
    readonly property var indeterminateKeys: checkable && cascade ? computeIndeterminateKeys(nodes, checkedKeys).keys : []
    readonly property var filteredOptions: query.length > 0 ? filterOptions(nodes, query) : nodes
    readonly property var visibleNodes: flattenVisibleNodes(filteredOptions)
    readonly property int availableTagsWidth: root.width - theme.selectionPaddingMultipleLeft - theme.selectionPaddingMultipleRight
    readonly property int singleLabelWidth: root.width - theme.selectionPaddingSingleLeft - theme.selectionPaddingSingleRight
    readonly property int multipleContentHeight: tagsWrapItem.visible
        ? (tagsWrapItem.height + 4)
        : controlHeight
    readonly property int menuPadding: 4
    readonly property int menuMaxHeight: Math.round(controlHeight * 7.6)
    readonly property int nodeHeight: 28
    readonly property int lineOffsetTop: 3
    readonly property int lineOffsetBottom: 3
    readonly property color nodeColorHover: theme.hoverColor
    readonly property color nodeColorActive: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.12)
    readonly property color nodeColorPressed: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.18)

    implicitWidth: 240
    implicitHeight: isMultipleLike ? Math.max(controlHeight, multipleContentHeight) : controlHeight

    function normalizedValue() {
        if (currentValue === undefined || currentValue === null || currentValue === "")
            return []
        if (Array.isArray(currentValue))
            return currentValue.slice()
        return [currentValue]
    }

    function nodeKey(node) {
        return node ? node[keyField] : null
    }

    function nodeLabel(node) {
        return node ? String(node[labelField] || "") : ""
    }

    function childrenFor(node) {
        return node && node[childrenField] ? node[childrenField] : []
    }

    function nodeDisabled(node) {
        return !!(node && node[disabledField])
    }

    function findOptionByKey(nodes, key) {
        for (var i = 0; i < nodes.length; ++i) {
            var node = nodes[i]
            if (nodeKey(node) === key)
                return node
            var childHit = findOptionByKey(childrenFor(node), key)
            if (childHit)
                return childHit
        }
        return null
    }

    function optionsForKeys(keys) {
        var result = []
        for (var i = 0; i < keys.length; ++i)
            result.push(findOptionByKey(nodes, keys[i]))
        return result
    }

    function flattenedKeys(nodes, into) {
        for (var i = 0; i < nodes.length; ++i) {
            var node = nodes[i]
            into.push(nodeKey(node))
            flattenedKeys(childrenFor(node), into)
        }
    }

    function initializeExpanded() {
        if (expandedKeys !== undefined)
            return
        if (defaultExpandAll) {
            var all = []
            flattenedKeys(nodes, all)
            internalExpandedKeys = all
            return
        }
        internalExpandedKeys = Array.isArray(defaultExpandedKeys) ? defaultExpandedKeys.slice() : []
    }

    function isExpanded(node) {
        return currentExpandedKeys.indexOf(nodeKey(node)) >= 0
    }

    function isNodeExpanded(node) {
        if (query.length > 0)
            return childrenFor(node).length > 0
        return isExpanded(node)
    }

    function toggleExpanded(node) {
        var key = nodeKey(node)
        var next = currentExpandedKeys.slice()
        var index = next.indexOf(key)
        var action = "expand"
        if (index >= 0) {
            next.splice(index, 1)
            action = "collapse"
        } else {
            next.push(key)
        }
        if (expandedKeys === undefined)
            internalExpandedKeys = next
        updateExpandedKeys(next, { node: node, action: action })
    }

    function isNodeSelected(node) {
        return selectedKeys.indexOf(nodeKey(node)) >= 0
    }

    function gatherDescendantKeys(node, into, includeDisabled) {
        if (!node)
            return
        if (includeDisabled || !nodeDisabled(node))
            into.push(nodeKey(node))
        var list = childrenFor(node)
        for (var i = 0; i < list.length; ++i)
            gatherDescendantKeys(list[i], into, includeDisabled)
    }

    function computeIndeterminateKeys(nodes, checkedSet) {
        var result = []
        function walk(node) {
            var list = childrenFor(node)
            if (!list.length)
                return checkedSet.indexOf(nodeKey(node)) >= 0 ? 2 : 0
            var enabledChildren = []
            for (var j = 0; j < list.length; ++j) {
                if (!nodeDisabled(list[j]))
                    enabledChildren.push(list[j])
            }
            if (enabledChildren.length === 0)
                return checkedSet.indexOf(nodeKey(node)) >= 0 ? 2 : 0
            var checkedCount = 0
            var partial = false
            for (var i = 0; i < enabledChildren.length; ++i) {
                var state = walk(enabledChildren[i])
                if (state === 2) checkedCount += 1
                else if (state === 1) partial = true
            }
            if (checkedCount === enabledChildren.length)
                return checkedSet.indexOf(nodeKey(node)) >= 0 || cascade ? 2 : 0
            if (checkedCount > 0 || partial) {
                result.push(nodeKey(node))
                return 1
            }
            return checkedSet.indexOf(nodeKey(node)) >= 0 ? 2 : 0
        }
        for (var i = 0; i < nodes.length; ++i)
            walk(nodes[i])
        return { keys: result }
    }

    function isNodeChecked(node) {
        return checkedKeys.indexOf(nodeKey(node)) >= 0
    }

    function isNodeIndeterminate(node) {
        return indeterminateKeys.indexOf(nodeKey(node)) >= 0
    }

    function commitValue(nextValue, option, meta) {
        if (value === undefined)
            internalValue = nextValue
        updateValue(nextValue, option, meta)
    }

    onOpenChanged: {
        control.blurControl()
        if (!open && filterable && clearFilterAfterSelect)
            query = ""
    }

    function handleNodeClick(node) {
        if (disabled || nodeDisabled(node))
            return
        if (checkable) {
            toggleChecked(node)
            return
        }
        var key = nodeKey(node)
        if (multiple) {
            var next = selectedKeys.slice()
            var index = next.indexOf(key)
            var action = "select"
            if (index >= 0) {
                next.splice(index, 1)
                action = "unselect"
            } else {
                next.push(key)
            }
            commitValue(next, optionsForKeys(next), { node: node, action: action })
        } else {
            commitValue(key, node, { node: node, action: "select" })
            open = false
        }
        if (filterable && clearFilterAfterSelect)
            query = ""
    }

    function toggleChecked(node) {
        var key = nodeKey(node)
        var next = checkedKeys.slice()
        if (cascade) {
            var subtree = []
            gatherDescendantKeys(node, subtree, false)
            var shouldCheck = !root.isNodeChecked(node)
            for (var i = 0; i < subtree.length; ++i) {
                var idx = next.indexOf(subtree[i])
                if (shouldCheck && idx < 0)
                    next.push(subtree[i])
                if (!shouldCheck && idx >= 0)
                    next.splice(idx, 1)
            }
            next = normalizeCascadeCheckedKeys(next)
            commitCheckedValue(next, { node: node, action: shouldCheck ? "select" : "unselect" })
            return
        }
        var index = next.indexOf(key)
        var action = "select"
        if (index >= 0) {
            next.splice(index, 1)
            action = "unselect"
        } else {
            next.push(key)
        }
        commitCheckedValue(next, { node: node, action: action })
    }

    function normalizeCascadeCheckedKeys(keys) {
        var next = keys.slice()

        function containsKey(key) {
            return next.indexOf(key) >= 0
        }

        function addKey(key) {
            if (next.indexOf(key) < 0)
                next.push(key)
        }

        function removeKey(key) {
            var index = next.indexOf(key)
            if (index >= 0)
                next.splice(index, 1)
        }

        function walk(node) {
            var list = childrenFor(node)
            if (!list.length)
                return containsKey(nodeKey(node)) ? 2 : 0
            var enabledChildren = []
            for (var j = 0; j < list.length; ++j) {
                if (!nodeDisabled(list[j]))
                    enabledChildren.push(list[j])
            }
            if (enabledChildren.length === 0)
                return containsKey(nodeKey(node)) ? 2 : 0
            var checkedCount = 0
            var partial = false
            for (var i = 0; i < enabledChildren.length; ++i) {
                var state = walk(enabledChildren[i])
                if (state === 2)
                    checkedCount += 1
                else if (state === 1)
                    partial = true
            }
            if (checkedCount === enabledChildren.length) {
                addKey(nodeKey(node))
                return 2
            }
            removeKey(nodeKey(node))
            return (checkedCount > 0 || partial) ? 1 : 0
        }

        for (var i = 0; i < nodes.length; ++i)
            walk(nodes[i])
        return next
    }

    function applyCheckStrategy(keys) {
        if (!checkable)
            return keys.slice()
        var raw = keys.slice()
        if (checkStrategy === "child") {
            return raw.filter(function(key) {
                var option = findOptionByKey(nodes, key)
                return option && childrenFor(option).length === 0
            })
        }
        if (checkStrategy === "parent") {
            return compressParentStrategy(raw)
        }
        return raw
    }

    function compressParentStrategy(keys) {
        var raw = keys.slice()

        function containsKey(key) {
            return raw.indexOf(key) >= 0
        }

        function walk(node) {
            var children = childrenFor(node)
            if (!children.length) {
                return {
                    state: containsKey(nodeKey(node)) ? 2 : 0,
                    keys: containsKey(nodeKey(node)) ? [nodeKey(node)] : []
                }
            }
            var enabledChildren = []
            for (var j = 0; j < children.length; ++j) {
                if (!nodeDisabled(children[j]))
                    enabledChildren.push(children[j])
            }
            if (!enabledChildren.length) {
                return {
                    state: containsKey(nodeKey(node)) ? 2 : 0,
                    keys: containsKey(nodeKey(node)) ? [nodeKey(node)] : []
                }
            }
            var checkedCount = 0
            var partial = false
            var output = []
            for (var i = 0; i < enabledChildren.length; ++i) {
                var result = walk(enabledChildren[i])
                if (result.state === 2)
                    checkedCount += 1
                else if (result.state === 1)
                    partial = true
                output = output.concat(result.keys)
            }
            if (checkedCount === enabledChildren.length && containsKey(nodeKey(node))) {
                return { state: 2, keys: [nodeKey(node)] }
            }
            if (checkedCount > 0 || partial) {
                return { state: 1, keys: output }
            }
            return { state: 0, keys: [] }
        }

        var result = []
        for (var i = 0; i < nodes.length; ++i)
            result = result.concat(walk(nodes[i]).keys)
        return result
    }

    function resolvedCheckedKeys() {
        if (!checkable)
            return []
        var raw = selectedKeys.slice()
        if (!cascade)
            return raw
        if (checkStrategy === "all")
            return raw
        if (checkStrategy === "parent") {
            var expanded = []
            for (var i = 0; i < raw.length; ++i) {
                var option = findOptionByKey(nodes, raw[i])
                if (option)
                    gatherDescendantKeys(option, expanded, false)
            }
            return normalizeCascadeCheckedKeys(expanded)
        }
        return normalizeCascadeCheckedKeys(raw)
    }

    function commitCheckedValue(rawKeys, meta) {
        var publicKeys = applyCheckStrategy(rawKeys)
        commitValue(publicKeys, optionsForKeys(publicKeys), meta)
    }

    function clearSelection() {
        var next = isMultipleLike ? [] : null
        commitValue(next, isMultipleLike ? [] : null, { node: null, action: "clear" })
    }

    function filterOptions(nodes, pattern) {
        var result = []
        var lower = String(pattern).toLowerCase()
        for (var i = 0; i < nodes.length; ++i) {
            var node = nodes[i]
            var children = childrenFor(node)
            var filteredChildren = filterOptions(children, pattern)
            var selfMatch = nodeLabel(node).toLowerCase().indexOf(lower) >= 0
            if (selfMatch || filteredChildren.length > 0) {
                var clone = {}
                for (var key in node)
                    clone[key] = node[key]
                clone[childrenField] = filteredChildren
                result.push(clone)
            }
        }
        return result
    }

    function flattenVisibleNodes(nodes) {
        var result = []

        function visit(list, depth, ancestorLastStates) {
            for (var i = 0; i < list.length; ++i) {
                var item = list[i]
                var isLast = i === list.length - 1
                result.push({
                    node: item,
                    depth: depth,
                    isLast: isLast,
                    ancestorLastStates: ancestorLastStates.slice()
                })
                if (childrenFor(item).length > 0 && isNodeExpanded(item)) {
                    var nextStates = ancestorLastStates.slice()
                    nextStates.push(isLast)
                    visit(childrenFor(item), depth + 1, nextStates)
                }
            }
        }

        visit(nodes, 0, [])
        return result
    }

    function displayText() {
        if (!hasSelection)
            return ""
        if (isMultipleLike)
            return ""
        var option = selectedOptions.length > 0 ? selectedOptions[0] : null
        return option ? nodeLabel(option) : ""
    }

    function tagValues() {
        return selectedOptions.filter(function(item) { return item !== null })
    }

    Component.onCompleted: initializeExpanded()
    onOptionsChanged: initializeExpanded()
    onNodesChanged: initializeExpanded()
    onFilterableChanged: if (!filterable) query = ""
    onQueryChanged: hoveredKey = null

    BrisaInput {
        id: control
        anchors.fill: parent
        size: root.size
        disabled: root.disabled
        readOnly: true
        clearable: false
        placeholder: root.hasSelection ? "" : root.placeholder
        text: root.isMultipleLike ? "" : ""
        status: root.open ? "open" : "default"
        paddingLeftOverride: root.isMultipleLike ? theme.selectionPaddingMultipleLeft : theme.selectionPaddingSingleLeft
        paddingRightOverride: root.isMultipleLike ? theme.selectionPaddingMultipleRight : theme.selectionPaddingSingleRight
        prefix: [
            Item {
                visible: !root.isMultipleLike && root.hasSelection
                width: Math.max(0, root.singleLabelWidth)
                height: root.controlHeight

                Text {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.displayText()
                    color: theme.textColor2
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSizeFor(root.size)
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
            },
            Item {
                id: tagsWrapItem
                visible: root.isMultipleLike && root.tagValues().length > 0
                width: Math.max(0, root.availableTagsWidth)
                height: Math.max(root.controlHeight, tagsFlow.childrenRect.height)
                clip: true
                y: Math.round((parent.height - height) / 2)

                Flow {
                    id: tagsFlow
                    width: parent.width
                    y: Math.round((tagsWrapItem.height - childrenRect.height) / 2)
                    spacing: 2
                    Repeater {
                        model: root.tagValues()
                        delegate: BrisaTag {
                            text: root.nodeLabel(modelData)
                            size: "medium"
                            closable: !root.disabled
                            onClose: {
                                var next = root.selectedKeys.slice()
                                var idx = next.indexOf(root.nodeKey(modelData))
                                if (idx >= 0)
                                    next.splice(idx, 1)
                                if (root.checkable)
                                    root.commitCheckedValue(root.resolvedCheckedKeys().filter(function(key) { return key !== root.nodeKey(modelData) }), { node: modelData, action: "delete" })
                                else
                                    root.commitValue(next, root.optionsForKeys(next), { node: modelData, action: "delete" })
                            }
                        }
                    }
                }
            }
        ]
    }

    MouseArea {
        anchors.fill: control
        enabled: !root.disabled
        z: -1
        cursorShape: Qt.PointingHandCursor
        propagateComposedEvents: false
        onPressed: function(mouse) {
            var localX = mouse.x
            var clearLeft = control.width - theme.selectionSuffixRight - suffixWrap.width
            if (localX >= clearLeft) {
                mouse.accepted = false
                return
            }
            mouse.accepted = true
        }
        onClicked: function(mouse) {
            var localX = mouse.x
            var clearLeft = control.width - theme.selectionSuffixRight - suffixWrap.width
            if (localX >= clearLeft) {
                mouse.accepted = false
                return
            }
            control.blurControl()
            root.open = !root.open
            if (root.open && root.filterable)
                root.focusingFilterAfterOpen = true
        }
    }

    Item {
        id: suffixWrap
        width: Math.max(theme.selectionClearSize, theme.selectionArrowSize)
        height: width
        anchors.right: parent.right
        anchors.rightMargin: theme.selectionSuffixRight
        anchors.verticalCenter: parent.verticalCenter
        z: 3

        Item {
            visible: root.showingClear
            anchors.fill: parent
            Image {
                anchors.centerIn: parent
                width: theme.selectionClearSize
                height: theme.selectionClearSize
                source: theme.svgClear(theme.clearColor, theme.selectionClearSize)
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
            MouseArea {
                anchors.fill: parent
                enabled: root.showingClear
                cursorShape: Qt.PointingHandCursor
                onClicked: function(mouse) {
                    mouse.accepted = true
                    control.blurControl()
                    root.clearSelection()
                }
            }
        }

        Image {
            visible: !root.showingClear
            width: theme.selectionArrowSize
            height: theme.selectionArrowSize
            anchors.centerIn: parent
            source: theme.svgChevronDown(root.open ? theme.primaryColor : theme.iconColor, theme.selectionArrowSize)
            rotation: root.open ? 180 : 0
            fillMode: Image.PreserveAspectFit
            smooth: true

            Behavior on rotation {
                NumberAnimation { duration: theme.transitionDurationFast; easing.type: Easing.OutCubic }
            }
        }
    }

    BrisaPopup {
        id: popup
        target: control
        open: root.open
        placement: "bottom-start"
        showArrow: false
        outsideClosable: true
        blocksUnderlay: false
        paddingX: 0
        paddingY: 0
        backgroundColor: theme.popoverColor
        borderColor: theme.borderColor
        borderWidth: 1
        radius: theme.borderRadius
        popupWidth: root.width
        onCloseRequested: root.open = false
        onOpenChanged: {
            if (open && root.filterable)
                root.focusingFilterAfterOpen = true
        }

        content: [
            Column {
                width: popup.popupWidth
                spacing: 0

                Item {
                    visible: root.filterable
                    width: parent.width
                    height: visible ? 47 : 0

                    BrisaInput {
                        id: filterInput
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 8
                        size: root.size
                        placeholder: "Search"
                        text: root.query
                        externalTextBinding: true
                        onInputEvent: function(v) { root.query = v }
                        onVisibleChanged: {
                            if (visible && root.focusingFilterAfterOpen)
                                Qt.callLater(forceActiveFocus)
                        }
                        onActiveFocusChanged: if (activeFocus) root.focusingFilterAfterOpen = false
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 1
                        color: theme.dividerColor
                    }
                }

                Flickable {
                    id: treeFlick
                    width: parent.width
                    height: Math.min(root.menuMaxHeight, treeContent.implicitHeight + root.menuPadding * 2)
                    contentWidth: width
                    contentHeight: treeContent.implicitHeight + root.menuPadding * 2
                    clip: true
                    interactive: contentHeight > height
                    boundsBehavior: Flickable.StopAtBounds

                    WheelHandler {
                        enabled: treeFlick.contentHeight > treeFlick.height + 1 || treeFlick.contentWidth > treeFlick.width + 1
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                        onWheel: function(event) {
                            var dx = event.angleDelta.x
                            var dy = event.angleDelta.y
                            if ((event.modifiers & Qt.ShiftModifier) && dx === 0 && dy !== 0)
                                dx = -dy
                            var rangeX = Math.max(0, treeFlick.contentWidth - treeFlick.width)
                            var rangeY = Math.max(0, treeFlick.contentHeight - treeFlick.height)
                            if (dx !== 0 && rangeX > 0) {
                                treeFlick.contentX = Math.max(0, Math.min(rangeX, treeFlick.contentX - dx))
                                event.accepted = true
                                return
                            }
                            if (dy !== 0) {
                                if (rangeY > 0) {
                                    treeFlick.contentY = Math.max(0, Math.min(rangeY, treeFlick.contentY - dy))
                                    event.accepted = true
                                    return
                                }
                                event.accepted = false
                                return
                            }
                            event.accepted = false
                        }
                    }

                    Item {
                        id: treeContent
                        x: root.menuPadding
                        y: root.menuPadding
                        width: treeFlick.width - root.menuPadding * 2
                        implicitHeight: treeColumn.implicitHeight

                        Column {
                            id: treeColumn
                            width: treeContent.width
                            spacing: 0

                            Repeater {
                                model: root.visibleNodes
                                delegate: BrisaTreeSelectNode {
                                    width: treeColumn.width
                                    treeSelect: root
                                    node: modelData.node
                                    depth: modelData.depth
                                    isLast: modelData.isLast
                                    ancestorLastStates: modelData.ancestorLastStates
                                }
                            }

                            Item {
                                visible: root.visibleNodes.length === 0
                                width: parent.width
                                height: visible ? 88 : 0

                                BrisaEmpty {
                                    anchors.centerIn: parent
                                    size: "small"
                                    title: ""
                                    description: root.emptyText
                                }
                            }
                        }
                    }

                    BrisaScrollBar {
                        flickable: treeFlick
                    }
                }
            }
        ]
    }
}
