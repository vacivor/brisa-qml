import QtQuick

Item {
    id: root
    property var options: []
    property var value: ""
    property string placeholder: "Select"
    property string size: "medium"
    property bool disabled: false
    property bool open: false
    property bool hovered: false
    property bool multiple: false
    property bool filterable: false
    property bool tag: false
    property bool clearable: false
    property bool showArrow: true
    property bool consistentMenuWidth: true
    property bool clearFilterAfterSelect: true
    property string emptyText: ""

    property string query: ""
    property var internalOptions: []

    signal updateValue(var value, var option)

    Theme { id: theme }

    readonly property int inputHeight: theme.heightFor(size)
    readonly property int multipleMinHeight: inputHeight
    readonly property int multipleContentHeight: multipleFlow.childrenRect.height > 0
        ? (multipleFlow.childrenRect.height
            + theme.selectionPaddingMultipleTop)
        : multipleMinHeight
    readonly property int availableTagsWidth: root.width - theme.selectionPaddingMultipleLeft - theme.selectionPaddingMultipleRight
    readonly property int suffixReserveWidth: Math.max(theme.selectionArrowSize, theme.selectionClearSize) + theme.selectionSuffixRight
    readonly property int singleOverlayLeft: theme.selectionPaddingSingleLeft
    readonly property int singleOverlayRight: root.suffixReserveWidth
    readonly property int multipleInputInlineWidth: {
        if (!(root.multiple && root.filterable)) return -1
        return Math.max(inputProbeMetrics.advanceWidth, Math.min(72, queryMetrics.advanceWidth + 2))
    }
    readonly property bool hasSingleSelection: !root.multiple
        && root.value !== ""
        && root.value !== null
        && root.value !== undefined
    implicitHeight: root.multiple ? Math.max(multipleMinHeight, multipleContentHeight) : inputHeight
    implicitWidth: 220

    TextMetrics {
        id: queryMetrics
        font.pixelSize: theme.fontSizeFor(root.size)
        font.family: theme.fontFamily
        text: root.query.length > 0 ? root.query : " "
    }

    TextMetrics {
        id: inputProbeMetrics
        font.pixelSize: theme.fontSizeFor(root.size)
        font.family: theme.fontFamily
        text: "M"
    }

    BrisaInput {
        id: input
        anchors.fill: parent
        size: root.size
        disabled: root.disabled
        readOnly: !root.filterable || !root.open
        externalTextBinding: root.filterable
        placeholder: (useSingleOverlay() || root.multiple) ? "" : placeholderText()
        text: root.multiple ? inputText() : ""
        clearable: false
        status: root.open ? "open" : "default"
        contentSpacingOverride: 0
        textWidthOverride: root.multiple ? 0 : -1
        paddingLeftOverride: root.multiple ? theme.selectionPaddingMultipleLeft : theme.selectionPaddingSingleLeft
        paddingRightOverride: root.multiple ? theme.selectionPaddingMultipleRight : theme.selectionPaddingSingleRight
        prefix: [
            Item {
                id: tagsWrap
                visible: root.multiple && selectedValues().length > 0
                height: root.multiple ? multipleFlow.childrenRect.height : parent.height
                width: Math.max(0, root.availableTagsWidth)
                y: root.multiple ? Math.max(theme.selectionPaddingMultipleTop, Math.round((root.inputHeight - multipleFlow.childrenRect.height) / 2)) : 0
                clip: true

                Flow {
                    id: multipleFlow
                    width: root.availableTagsWidth
                    height: childrenRect.height
                    flow: Flow.LeftToRight
                    spacing: 0
                    Repeater {
                        model: root.multiple ? selectedValues() : []
                        delegate: Item {
                            width: tagItem.implicitWidth + theme.selectionTagGap
                            height: tagItem.implicitHeight

                            BrisaTag {
                                id: tagItem
                                x: 0
                                y: Math.max(0, Math.round((parent.height - height) / 2))
                                text: root.labelFor(modelData)
                                size: tagSizeForSelect()
                                closable: !root.disabled
                                bordered: true
                                onClose: removeValue(modelData)
                            }
                        }
                    }

                    Item {
                        id: multiInputWrap
                        visible: root.filterable
                        width: root.filterable ? root.multipleInputInlineWidth : 0
                        height: root.inputHeight - theme.selectionInputTagHeightOffset

                        TextInput {
                            id: multiFilterInput
                            anchors.fill: parent
                            text: root.query
                            readOnly: root.disabled || !root.open
                            enabled: !root.disabled
                            clip: true
                            color: theme.textColor2
                            font.pixelSize: theme.fontSizeFor(root.size)
                            font.family: theme.fontFamily
                            verticalAlignment: Text.AlignVCenter
                            selectionColor: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.2)
                            selectedTextColor: theme.textColor1
                            cursorVisible: activeFocus
                            cursorDelegate: Rectangle {
                                width: 1
                                color: theme.cursorColorFor(root.open ? "open" : "default")
                                height: Math.max(parent.cursorRectangle.height, parent.font.pixelSize)
                                y: parent.cursorRectangle.height > 0
                                    ? parent.cursorRectangle.y + (parent.cursorRectangle.height - height) / 2
                                    : 4
                                visible: parent.activeFocus
                            }
                            onTextChanged: {
                                if (root.query !== text) root.query = text
                            }
                            Keys.onPressed: function(event) {
                                if (event.key === Qt.Key_Backspace && root.query.length === 0) {
                                    var values = selectedValues()
                                    if (values.length > 0) removeValue(values[values.length - 1])
                                    event.accepted = true
                                    return
                                }
                                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    if (!root.tag) return
                                    var q = root.query.trim()
                                    if (q.length === 0) return
                                    root.addTagValue(q)
                                    event.accepted = true
                                }
                            }
                        }
                    }
                }
            }
        ]
        onInputEvent: function(v) {
            if (!root.filterable) return
            root.query = v
            if (!root.open) root.open = true
        }
        onKeyDown: function(key) {
            if (!root.filterable) return
            if (root.multiple && key === Qt.Key_Backspace && root.query.length === 0) {
                var values = selectedValues()
                if (values.length > 0) removeValue(values[values.length - 1])
                return
            }
            if (key === Qt.Key_Return || key === Qt.Key_Enter) {
                if (!root.tag) return
                var q = root.query.trim()
                if (q.length === 0) return
                root.addTagValue(q)
            }
        }
        onFocusEvent: {
            if (root.filterable && !root.disabled) root.open = true
        }
    }

    Item {
        id: suffixWrap
        visible: root.showArrow
        width: Math.max(theme.selectionClearSize, theme.selectionArrowSize)
        height: Math.max(theme.selectionClearSize, theme.selectionArrowSize)
        anchors.right: parent.right
        anchors.rightMargin: theme.selectionSuffixRight
        anchors.verticalCenter: parent.verticalCenter
        z: 3

        MouseArea {
            anchors.fill: parent
            enabled: !showClear() && !root.disabled
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            propagateComposedEvents: false
            onClicked: root.open = !root.open
        }

        Item {
            id: clearWrap
            width: theme.selectionClearSize
            height: theme.selectionClearSize
            anchors.centerIn: parent
            opacity: showClear() ? 1 : 0
            scale: showClear() ? 1 : 0.85

            Behavior on opacity { NumberAnimation { duration: theme.transitionDurationFast; easing.type: Easing.OutCubic } }
            Behavior on scale { NumberAnimation { duration: theme.transitionDurationFast; easing.type: Easing.OutCubic } }

            Image {
                anchors.centerIn: parent
                width: theme.selectionClearSize
                height: theme.selectionClearSize
                source: theme.svgClear(
                    clearPressed
                        ? theme.clearColorPressed
                        : (clearHover.hovered ? theme.clearColorHover : theme.clearColor),
                    theme.selectionClearSize)
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            HoverHandler { id: clearHover; enabled: showClear(); cursorShape: Qt.PointingHandCursor }
            MouseArea {
                anchors.fill: parent
                enabled: showClear()
                cursorShape: Qt.PointingHandCursor
                onPressed: clearPressed = true
                onReleased: clearPressed = false
                onCanceled: clearPressed = false
                onClicked: clearSelection()
            }
        }

        Image {
            width: theme.selectionArrowSize
            height: theme.selectionArrowSize
            anchors.centerIn: parent
            source: theme.svgChevronDown(root.disabled
                ? theme.iconColorDisabled
                : (root.open
                    ? theme.primaryColor
                    : (root.hovered ? theme.iconColorHover : theme.iconColor)), theme.selectionArrowSize)
            rotation: root.open ? 180 : 0
            opacity: showClear() ? 0 : 1
            scale: showClear() ? 0.85 : 1
            transformOrigin: Item.Center
            Behavior on opacity { NumberAnimation { duration: theme.transitionDurationFast; easing.type: Easing.OutCubic } }
            Behavior on scale { NumberAnimation { duration: theme.transitionDurationFast; easing.type: Easing.OutCubic } }
            Behavior on rotation { NumberAnimation { duration: theme.transitionDurationFast; easing.type: Easing.OutCubic } }
        }
    }

    Item {
        anchors.fill: input
        anchors.leftMargin: root.multiple ? 0 : root.singleOverlayLeft
        anchors.rightMargin: root.multiple ? 0 : root.singleOverlayRight
        visible: !root.multiple && useSingleOverlay()
        z: 2

        TextInput {
            id: singleFilterInput
            anchors.fill: parent
            visible: root.filterable && root.open
            text: root.query
            readOnly: root.disabled
            enabled: !root.disabled
            clip: true
            color: theme.textColor2
            font.pixelSize: theme.fontSizeFor(root.size)
            font.family: theme.fontFamily
            verticalAlignment: Text.AlignVCenter
            selectionColor: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.2)
            selectedTextColor: theme.textColor1
            cursorVisible: activeFocus
            cursorDelegate: Rectangle {
                width: 1
                color: theme.cursorColorFor(root.open ? "open" : "default")
                height: Math.max(parent.cursorRectangle.height, parent.font.pixelSize)
                y: parent.cursorRectangle.height > 0
                    ? parent.cursorRectangle.y + (parent.cursorRectangle.height - height) / 2
                    : 4
                visible: parent.activeFocus
            }
            onTextChanged: {
                if (root.query !== text) root.query = text
            }
            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Backspace && root.query.length === 0) {
                    event.accepted = true
                    return
                }
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    if (!root.tag) return
                    var q = root.query.trim()
                    if (q.length === 0) return
                    root.addTagValue(q)
                    event.accepted = true
                }
            }
        }

        Text {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: displayText()
            visible: showSingleLabelOverlay()
            color: root.disabled ? theme.textColor3 : theme.textColor2
            opacity: root.disabled ? theme.opacityDisabled : 1
            font.pixelSize: theme.fontSizeFor(root.size)
            font.family: theme.fontFamily
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: singleOverlayPlaceholderText()
            visible: showSinglePlaceholderOverlay()
            color: root.disabled ? theme.placeholderColorDisabled : theme.placeholderColor
            font.pixelSize: theme.fontSizeFor(root.size)
            font.family: theme.fontFamily
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    Item {
        anchors.left: input.left
        anchors.right: input.right
        anchors.top: input.top
        anchors.bottom: input.bottom
        anchors.leftMargin: theme.selectionPaddingMultipleLeft
        anchors.rightMargin: theme.selectionPaddingMultipleRight
        visible: root.multiple && showMultiplePlaceholderOverlay()
        z: 1

        Text {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            y: Math.round(theme.selectionPaddingMultipleTop / 2)
            text: root.placeholder
            color: root.disabled ? theme.placeholderColorDisabled : theme.placeholderColor
            font.pixelSize: theme.fontSizeFor(root.size)
            font.family: theme.fontFamily
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    HoverHandler {
        enabled: !root.disabled
        onHoveredChanged: root.hovered = hovered
        cursorShape: Qt.PointingHandCursor
    }

    MouseArea {
        anchors.fill: parent
        enabled: !root.disabled
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        z: 2
        propagateComposedEvents: false
        onPressed: function(mouse) { mouse.accepted = true }
        onClicked: function(mouse) {
            if (root.isInClear(mouse)) return
            root.open = !root.open
        }
    }

    BrisaPopselect {
        id: pop
        target: root
        open: root.open
        placement: "bottom-start"
        size: root.size
        multiple: root.multiple
        value: root.value
        values: root.multiple ? selectedValues() : []
        popupWidthOverride: root.consistentMenuWidth ? root.width : 0
        emptyText: root.emptyText
        options: filteredOptions()
        onUpdateValue: function(v, option) {
            if (root.multiple) {
                root.value = v
                root.updateValue(v, option)
                if (root.clearFilterAfterSelect) root.query = ""
            } else {
                root.value = v
                root.updateValue(v, option)
                if (root.filterable && root.clearFilterAfterSelect) root.query = ""
                root.open = false
            }
        }
        onCloseRequested: root.open = false
    }

    property bool clearPressed: false

    Component.onCompleted: internalOptions = options
    onOptionsChanged: internalOptions = options
    onOpenChanged: {
        if (!root.filterable) return
        if (root.open) {
            focusTimer.restart()
        } else {
            if (root.multiple) {
                multiFilterInput.focus = false
            } else {
                singleFilterInput.focus = false
            }
            root.query = ""
        }
    }

    Timer {
        id: focusTimer
        interval: 0
        repeat: false
        onTriggered: {
            if (root.open && root.filterable && !root.disabled) {
                if (root.multiple) {
                    multiFilterInput.forceActiveFocus()
                } else {
                    singleFilterInput.forceActiveFocus()
                }
            }
        }
    }

    function selectedValues() {
        return Array.isArray(root.value) ? root.value : []
    }

    function labelFor(val) {
        var opts = internalOptions
        for (var i = 0; i < opts.length; i++) {
            if (String(opts[i].value) === String(val)) return opts[i].label
        }
        return String(val)
    }

    function displayText() {
        if (root.multiple) return ""
        var opts = internalOptions
        for (var i = 0; i < opts.length; i++) {
            if (String(opts[i].value) === String(root.value)) return opts[i].label
        }
        return ""
    }

    function inputText() {
        if (!root.filterable) return displayText()
        if (root.multiple) return root.query
        if (root.query.length > 0) return root.query
        return displayText()
    }

    function overlayInputText() {
        if (!root.filterable) return ""
        return root.query
    }

    function placeholderText() {
        if (root.multiple) {
            return selectedValues().length > 0 ? "" : root.placeholder
        }
        return root.placeholder
    }

    function useSingleOverlay() {
        return !root.multiple
    }

    function showSingleLabelOverlay() {
        return !root.filterable && hasSingleSelection
            || (root.filterable && !root.open && hasSingleSelection)
    }

    function singleOverlayPlaceholderText() {
        if (root.filterable && root.open && root.query.length === 0 && hasSingleSelection) {
            return displayText()
        }
        return root.placeholder
    }

    function showSinglePlaceholderOverlay() {
        if (root.multiple) return false
        if (!root.filterable) return !hasSingleSelection
        if (root.open) return root.query.length === 0
        return !hasSingleSelection
    }

    function showMultiplePlaceholderOverlay() {
        if (!root.multiple) return false
        if (selectedValues().length > 0) return false
        if (root.query.length > 0) return false
        return true
    }

    function filteredOptions() {
        if (!root.filterable || root.query.trim().length === 0) return internalOptions
        var q = root.query.trim().toLowerCase()
        var res = []
        for (var i = 0; i < internalOptions.length; i++) {
            var opt = internalOptions[i]
            var label = String(opt.label || "")
            if (label.toLowerCase().indexOf(q) !== -1) res.push(opt)
        }
        return res
    }

    function showClear() {
        if (!root.clearable || root.disabled) return false
        if (!root.hovered) return false
        if (root.multiple) return selectedValues().length > 0
        return root.value !== "" && root.value !== null && root.value !== undefined
    }

    function clearSelection() {
        if (root.multiple) {
            root.value = []
            root.updateValue(root.value, null)
        } else {
            root.value = ""
            root.updateValue(root.value, null)
        }
        root.query = ""
    }

    function addTagValue(label) {
        var opts = internalOptions.slice(0)
        var exists = false
        for (var i = 0; i < opts.length; i++) {
            if (String(opts[i].value) === String(label)) { exists = true; break }
        }
        if (!exists) {
            opts.push({ label: label, value: label })
            internalOptions = opts
        }
        if (root.multiple) {
            var arr = selectedValues().slice(0)
            if (arr.indexOf(label) === -1) arr.push(label)
            root.value = arr
            root.updateValue(arr, { label: label, value: label })
        } else {
            root.value = label
            root.updateValue(label, { label: label, value: label })
            root.open = false
        }
        root.query = ""
    }

    function removeValue(val) {
        if (!root.multiple) return
        var arr = selectedValues().slice(0)
        var idx = arr.indexOf(val)
        if (idx >= 0) arr.splice(idx, 1)
        root.value = arr
        root.updateValue(arr, null)
    }

    function isInClear(mouse) {
        if (!showClear() || !clearWrap.visible) return false
        var p = clearWrap.mapFromItem(root, mouse.x, mouse.y)
        return p.x >= 0 && p.y >= 0 && p.x <= clearWrap.width && p.y <= clearWrap.height
    }

    function tagSizeForSelect() {
        return root.size
    }
}
