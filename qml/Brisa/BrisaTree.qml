import QtQuick

Rectangle {
    id: root

    property var nodes: []
    property var selectedKeys: undefined
    property var defaultSelectedKeys: []
    property var checkedKeys: undefined
    property var defaultCheckedKeys: []
    property var expandedKeys: undefined
    property var defaultExpandedKeys: []
    property bool defaultExpandAll: false
    property bool multiple: false
    property bool cascade: false
    property bool checkable: false
    property string checkStrategy: "all" // all | parent | child
    property bool selectable: true
    property bool cancelable: true
    property bool expandOnClick: false
    property bool showLine: false
    property bool blockLine: false
    property bool disabled: false
    property string pattern: ""
    property int indent: 28
    property string keyField: "key"
    property string labelField: "label"
    property string childrenField: "children"
    property string disabledField: "disabled"
    property string emptyText: "No Data"
    property var hoveredKey: null

    property var internalSelectedKeys: defaultSelectedKeys
    property var internalCheckedKeys: defaultCheckedKeys
    property var internalExpandedKeys: []

    signal updateSelectedKeys(var keys, var options, var meta)
    signal updateCheckedKeys(var keys, var options, var meta)
    signal updateExpandedKeys(var keys, var options, var meta)

    Theme { id: theme }

    readonly property var currentSelectedKeys: selectedKeys !== undefined ? selectedKeys : internalSelectedKeys
    readonly property var currentCheckedKeys: checkedKeys !== undefined ? checkedKeys : internalCheckedKeys
    readonly property var displayedCheckedKeys: resolvedCheckedKeys()
    readonly property var currentExpandedKeys: expandedKeys !== undefined ? expandedKeys : internalExpandedKeys
    readonly property var indeterminateKeys: checkable && cascade ? computeIndeterminateKeys(nodes, displayedCheckedKeys).keys : []
    readonly property var filteredNodes: pattern.length > 0 ? filterNodes(nodes, pattern) : nodes
    readonly property var visibleNodes: flattenVisibleNodes(filteredNodes)
    readonly property int menuPadding: 4
    readonly property int nodeHeight: 28
    readonly property int menuMaxHeight: Math.round(theme.heightMedium * 7.6)
    readonly property int lineOffsetTop: 3
    readonly property int lineOffsetBottom: 3
    readonly property color nodeColorHover: theme.hoverColor
    readonly property color nodeColorActive: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.12)
    readonly property color nodeColorPressed: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.18)

    implicitWidth: 240
    implicitHeight: Math.min(menuMaxHeight, contentColumn.implicitHeight + menuPadding * 2)
    height: implicitHeight
    color: "transparent"
    border.width: 0
    clip: true

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
        return root.disabled || !!(node && node[disabledField])
    }

    function findOptionByKey(list, key) {
        for (var i = 0; i < list.length; ++i) {
            var node = list[i]
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

    function flattenedKeys(list, into) {
        for (var i = 0; i < list.length; ++i) {
            var node = list[i]
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
        if (pattern.length > 0)
            return childrenFor(node).length > 0
        return isExpanded(node)
    }

    function toggleExpanded(node) {
        if (childrenFor(node).length === 0)
            return
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
        updateExpandedKeys(next, optionsForKeys(next), { node: node, action: action })
    }

    function isNodeSelected(node) {
        return currentSelectedKeys.indexOf(nodeKey(node)) >= 0
    }

    function commitSelectedKeys(nextKeys, meta) {
        if (selectedKeys === undefined)
            internalSelectedKeys = nextKeys
        updateSelectedKeys(nextKeys, optionsForKeys(nextKeys), meta)
    }

    function isNodeChecked(node) {
        return displayedCheckedKeys.indexOf(nodeKey(node)) >= 0
    }

    function isNodeIndeterminate(node) {
        return indeterminateKeys.indexOf(nodeKey(node)) >= 0
    }

    function commitCheckedKeys(nextKeys, meta) {
        if (checkedKeys === undefined)
            internalCheckedKeys = nextKeys
        updateCheckedKeys(nextKeys, optionsForKeys(nextKeys), meta)
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

    function computeIndeterminateKeys(list, checkedSet) {
        var result = []
        function walk(node) {
            var children = childrenFor(node)
            if (!children.length)
                return checkedSet.indexOf(nodeKey(node)) >= 0 ? 2 : 0
            var enabledChildren = []
            for (var j = 0; j < children.length; ++j) {
                if (!nodeDisabled(children[j]))
                    enabledChildren.push(children[j])
            }
            if (!enabledChildren.length)
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
        for (var i = 0; i < list.length; ++i)
            walk(list[i])
        return { keys: result }
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
            var children = childrenFor(node)
            if (!children.length)
                return containsKey(nodeKey(node)) ? 2 : 0
            var enabledChildren = []
            for (var j = 0; j < children.length; ++j) {
                if (!nodeDisabled(children[j]))
                    enabledChildren.push(children[j])
            }
            if (!enabledChildren.length)
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
        var raw = currentCheckedKeys.slice()
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
        commitCheckedKeys(publicKeys, meta)
    }

    function toggleChecked(node) {
        if (nodeDisabled(node))
            return
        var key = nodeKey(node)
        var next = currentCheckedKeys.slice()
        if (cascade && checkStrategy !== "all")
            next = displayedCheckedKeys.slice()
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
            commitCheckedValue(next, { node: node, action: shouldCheck ? "check" : "uncheck" })
            return
        }
        var index = next.indexOf(key)
        var action = "check"
        if (index >= 0) {
            next.splice(index, 1)
            action = "uncheck"
        } else {
            next.push(key)
        }
        commitCheckedValue(next, { node: node, action: action })
    }

    function handleNodeClick(node) {
        if (nodeDisabled(node))
            return
        if (expandOnClick && childrenFor(node).length > 0)
            toggleExpanded(node)
        if (checkable)
            return
        if (!selectable)
            return
        var key = nodeKey(node)
        if (multiple) {
            var next = currentSelectedKeys.slice()
            var index = next.indexOf(key)
            var action = "select"
            if (index >= 0) {
                next.splice(index, 1)
                action = "unselect"
            } else {
                next.push(key)
            }
            commitSelectedKeys(next, { node: node, action: action })
            return
        }
        if (isNodeSelected(node) && cancelable) {
            commitSelectedKeys([], { node: node, action: "unselect" })
            return
        }
        commitSelectedKeys([key], { node: node, action: "select" })
    }

    function filterNodes(list, patternValue) {
        var result = []
        var lower = String(patternValue).toLowerCase()
        for (var i = 0; i < list.length; ++i) {
            var node = list[i]
            var filteredChildren = filterNodes(childrenFor(node), patternValue)
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

    function flattenVisibleNodes(list) {
        var result = []
        function visit(nodesList, depth, ancestorLastStates) {
            for (var i = 0; i < nodesList.length; ++i) {
                var item = nodesList[i]
                var isLast = i === nodesList.length - 1
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
        visit(list, 0, [])
        return result
    }

    Component.onCompleted: initializeExpanded()
    onNodesChanged: initializeExpanded()
    onPatternChanged: hoveredKey = null

    Flickable {
        id: treeFlick
        x: root.menuPadding
        y: root.menuPadding
        width: Math.max(0, root.width - root.menuPadding * 2)
        height: Math.max(0, root.height - root.menuPadding * 2)
        contentWidth: width
        contentHeight: contentColumn.implicitHeight
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

        Column {
            id: contentColumn
            width: treeFlick.width
            spacing: 0

            Repeater {
                model: root.visibleNodes

                delegate: Rectangle {
                    id: row
                    width: contentColumn.width
                    height: root.nodeHeight
                    readonly property var ancestorStates: Array.isArray(modelData.ancestorLastStates) ? modelData.ancestorLastStates : []
                    readonly property int nodeDepth: modelData.depth || 0
                    readonly property bool nodeIsLast: !!modelData.isLast
                    color: root.blockLine
                        ? (rowMouse.pressed && !root.nodeDisabled(modelData.node)
                            ? root.nodeColorPressed
                            : ((rowMouse.containsMouse || switcherMouse.containsMouse) && !root.nodeDisabled(modelData.node)
                                ? root.nodeColorHover
                                : (root.isNodeSelected(modelData.node) ? root.nodeColorActive : "transparent")))
                        : "transparent"
                    radius: theme.borderRadius

                    Repeater {
                        model: root.showLine ? row.ancestorStates.length : 0

                        Rectangle {
                            visible: !row.ancestorStates[index]
                            x: Math.round(index * root.indent + 13)
                            y: root.lineOffsetTop
                            width: 1
                            height: Math.max(0, parent.height - root.lineOffsetTop - root.lineOffsetBottom)
                            color: theme.dividerColor
                        }
                    }

                    Rectangle {
                        visible: root.showLine && row.nodeDepth > 0
                        x: Math.round(row.nodeDepth * root.indent + 13)
                        y: root.lineOffsetTop
                        width: 1
                        height: row.nodeIsLast
                            ? Math.max(0, Math.round(parent.height / 2) - root.lineOffsetTop)
                            : Math.max(0, parent.height - root.lineOffsetTop - root.lineOffsetBottom)
                        color: theme.dividerColor
                    }

                    Rectangle {
                        visible: root.showLine && row.nodeDepth > 0
                        x: Math.round(row.nodeDepth * root.indent + 13)
                        y: Math.round(parent.height / 2)
                        width: 9
                        height: 1
                        color: theme.dividerColor
                    }

                    Item {
                        id: rowBody
                        x: row.nodeDepth * root.indent
                        width: Math.max(0, parent.width - x)
                        height: parent.height

                        Rectangle {
                            id: contentFill
                            x: 0
                            y: root.blockLine ? 0 : 1
                            width: contentWidth
                            height: root.blockLine ? row.height : Math.max(0, row.height - 2)
                            radius: theme.borderRadius
                            color: !root.blockLine
                                ? (rowMouse.pressed && !root.nodeDisabled(modelData.node)
                                    ? root.nodeColorPressed
                                    : ((rowMouse.containsMouse || switcherMouse.containsMouse) && !root.nodeDisabled(modelData.node)
                                        ? root.nodeColorHover
                                        : (root.isNodeSelected(modelData.node) ? root.nodeColorActive : "transparent")))
                                : "transparent"

                            readonly property int contentWidth: {
                                var base = switcherWrap.width + checkboxWrap.width + labelText.implicitWidth + 10
                                return Math.min(rowBody.width, Math.max(0, base))
                            }
                        }

                        Item {
                            id: switcherWrap
                            width: 24
                            height: parent.height

                            Image {
                                visible: root.childrenFor(modelData.node).length > 0
                                anchors.centerIn: parent
                                width: 14
                                height: 14
                                source: theme.svgChevronRight(
                                    root.nodeDisabled(modelData.node) ? theme.iconColorDisabled : theme.textColor3,
                                    14)
                                rotation: root.isNodeExpanded(modelData.node) ? 90 : 0
                                fillMode: Image.PreserveAspectFit
                                smooth: true

                                Behavior on rotation {
                                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                                }
                            }

                            MouseArea {
                                id: switcherMouse
                                anchors.fill: parent
                                enabled: root.childrenFor(modelData.node).length > 0 && !root.nodeDisabled(modelData.node)
                                hoverEnabled: true
                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onEntered: root.hoveredKey = root.nodeKey(modelData.node)
                                onExited: if (root.hoveredKey === root.nodeKey(modelData.node)) root.hoveredKey = null
                                onClicked: root.toggleExpanded(modelData.node)
                            }

                            MouseArea {
                                anchors.fill: parent
                                enabled: root.childrenFor(modelData.node).length === 0
                                hoverEnabled: true
                                acceptedButtons: Qt.NoButton
                                onEntered: root.hoveredKey = root.nodeKey(modelData.node)
                                onExited: if (root.hoveredKey === root.nodeKey(modelData.node)) root.hoveredKey = null
                            }
                        }

                        Text {
                            id: labelText
                            anchors.verticalCenter: parent.verticalCenter
                            x: switcherWrap.width + checkboxWrap.width + 4
                            width: Math.max(0, rowBody.width - x - 6)
                            text: root.nodeLabel(modelData.node)
                            color: root.nodeDisabled(modelData.node)
                                ? theme.textColorDisabled
                                : theme.textColor1
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            elide: Text.ElideRight
                        }

                        Item {
                            id: checkboxWrap
                            x: switcherWrap.width
                            width: root.checkable ? 24 : 0
                            height: parent.height
                            visible: width > 0
                            z: 3

                        BrisaCheckbox {
                            id: nodeCheckbox
                            anchors.left: parent.left
                            anchors.leftMargin: 1
                            anchors.verticalCenter: parent.verticalCenter
                            checked: root.isNodeChecked(modelData.node)
                            indeterminate: root.isNodeIndeterminate(modelData.node)
                            disabled: root.nodeDisabled(modelData.node)
                            passive: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: root.checkable && !root.nodeDisabled(modelData.node)
                            hoverEnabled: true
                            z: 4
                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                            onClicked: function(mouse) {
                                mouse.accepted = true
                                root.toggleChecked(modelData.node)
                            }
                        }
                    }
                    }

                    MouseArea {
                        id: rowMouse
                        x: rowBody.x + 24 + (root.checkable ? 24 : 0)
                        y: 0
                        width: Math.max(0, parent.width - x)
                        height: parent.height
                        hoverEnabled: true
                        enabled: !root.nodeDisabled(modelData.node)
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onEntered: root.hoveredKey = root.nodeKey(modelData.node)
                        onExited: if (root.hoveredKey === root.nodeKey(modelData.node)) root.hoveredKey = null
                        onClicked: root.handleNodeClick(modelData.node)
                    }
                }
            }

            Item {
                visible: root.visibleNodes.length === 0
                width: contentColumn.width
                height: visible ? 88 : 0

                BrisaEmpty {
                    anchors.centerIn: parent
                    description: root.emptyText
                    size: "small"
                }
            }
        }

        BrisaScrollBar {
            flickable: treeFlick
        }
    }
}
