import QtQuick

Item {
    id: root
    property string text: ""
    property string placeholder: ""
    property string type: "text" // text | textarea | password
    property string size: "medium" // tiny | small | medium | large
    property bool disabled: false
    property bool readOnly: false
    property bool round: false
    property bool clearable: false
    property var loading: undefined
    property bool showCount: false
    property int maxLength: 0
    property bool countGraphemes: false
    property bool pair: false
    property var pairValue: ["", ""]
    property var separator: "to"
    property var placeholderPair: ["From", "To"]
    property var autosize: false // bool | { minRows, maxRows }
    property string resize: "none" // none | vertical | both
    property string showPasswordOn: "click" // click | mousedown
    property bool passivelyActivated: false
    property var allowInput: null
    property bool focused: input.activeFocus
        || textarea.activeFocus
        || pairLeftInput.activeFocus
        || pairRightInput.activeFocus
    property string status: "default" // default | warning | error | open
    // When true, text is controlled externally and internal assignments should be skipped.
    property bool externalTextBinding: false
    property int horizontalAlignment: TextInput.AlignLeft
    // Optional layout overrides (use -1 to keep theme defaults).
    property int paddingLeftOverride: -1
    property int paddingRightOverride: -1
    property int contentSpacingOverride: -1
    property int textWidthOverride: -1

    property alias prefix: prefixSlot.data
    property alias suffix: suffixSlot.data
    property alias clearIcon: clearIconSlot.data
    property alias passwordVisibleIcon: passwordVisibleSlot.data
    property alias passwordInvisibleIcon: passwordInvisibleSlot.data

    signal accepted()
    signal editingFinished()
    signal textEdited()
    signal change(string value)
    signal inputEvent(string value)
    signal clearEvent()
    signal focusEvent()
    signal blurEvent()
    signal keyUp()
    signal keyDown(int key)

    function focusControl() {
        if (root.disabled) return
        if (root.pair) {
            pairLeftInput.forceActiveFocus()
            return
        }
        if (root.type === "textarea") {
            textarea.forceActiveFocus()
            return
        }
        input.forceActiveFocus()
    }

    function blurControl() {
        if (root.pair) {
            pairLeftInput.focus = false
            pairRightInput.focus = false
            return
        }
        if (root.type === "textarea") {
            textarea.focus = false
            return
        }
        input.focus = false
    }

    Theme { id: theme }

    readonly property bool hovered: hoverHandler.hovered
    readonly property int inputHeight: theme.heightFor(size)
    readonly property int fontSize: theme.fontSizeFor(size)
    readonly property int paddingX: theme.paddingFor(size)
    readonly property int effectivePaddingLeft: paddingLeftOverride >= 0 ? paddingLeftOverride : paddingX
    readonly property int effectivePaddingRight: paddingRightOverride >= 0 ? paddingRightOverride : paddingX
    readonly property int effectiveSpacing: contentSpacingOverride >= 0 ? contentSpacingOverride : 8
    readonly property int radiusValue: round ? inputHeight : theme.borderRadius
    readonly property int clearSize: 16
    readonly property int loadingSize: 14
    readonly property int textareaPaddingVertical: 6
    readonly property int suffixGap: 6
    readonly property int minTextareaWidth: 120
    readonly property int minTextareaHeight: inputHeight * 2
    readonly property bool loadingDefined: loading !== undefined && loading !== null
    readonly property bool loadingVisible: Boolean(loading)
    readonly property bool verticalResizeEnabled: root.resize === "vertical"
    readonly property bool bothResizeEnabled: root.resize === "both"
    readonly property bool resizeEnabled: root.type === "textarea"
        && !root.disabled
        && root.autosize === false
        && (verticalResizeEnabled || bothResizeEnabled)
    readonly property color baseColor: disabled ? theme.inputColorDisabled : theme.inputColor
    readonly property color borderColor: {
        if (disabled) return theme.borderColor
        if (status === "error") return theme.errorColor
        if (status === "warning") return theme.warningColor
        return theme.borderColor
    }
    readonly property color borderHover: {
        if (status === "open") return theme.primaryColorHover
        if (status === "error") return theme.errorColorHover
        if (status === "warning") return theme.warningColorHover
        return theme.primaryColorHover
    }
    readonly property color borderFocus: borderHover

    readonly property int contentHeight: root.type === "textarea" ? (textareaHeight + 10) : inputHeight
    implicitHeight: contentHeight
    implicitWidth: root.pair ? 260 : 200

    BrisaRoundRect {
        anchors.fill: parent
        fillColor: baseColor
        strokeWidth: 1
        strokeColor: (focused || hoverHandler.hovered) && !disabled ? borderFocus : borderColor
        radiusTL: radiusValue
        radiusTR: radiusValue
        radiusBR: radiusValue
        radiusBL: radiusValue
        Behavior on strokeColor {
            ColorAnimation { duration: theme.transitionDurationFast; easing.type: Easing.OutCubic }
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: -1
        color: "transparent"
        radius: radiusValue + 1
        border.width: (!disabled && (focused || status === "open")) ? 2 : 0
        border.color: (status === "error")
            ? Qt.rgba(theme.errorColor.r, theme.errorColor.g, theme.errorColor.b, 0.25)
            : (status === "warning")
                ? Qt.rgba(theme.warningColor.r, theme.warningColor.g, theme.warningColor.b, 0.25)
                : Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.2)
        visible: (!disabled && (focused || status === "open"))
    }

    HoverHandler {
        id: hoverHandler
        enabled: !disabled
        cursorShape: root.readOnly ? Qt.ArrowCursor : Qt.IBeamCursor
    }

    Item {
        id: contentWrap
        anchors.fill: parent
        anchors.leftMargin: effectivePaddingLeft
        anchors.rightMargin: effectivePaddingRight

        Row {
            id: inputRow
            anchors.fill: parent
            spacing: root.type === "textarea" ? effectiveSpacing : 0

            Item {
                id: prefixSlot
                visible: prefixSlot.children.length > 0
                implicitWidth: childrenRect.width
                implicitHeight: childrenRect.height
                width: visible ? implicitWidth : 0
                height: parent.height

                onChildrenChanged: repositionPrefixChildren()
            }

            TextInput {
                id: input
                visible: root.type !== "textarea" && !root.pair
                text: root.text
                echoMode: root.type === "password" && !passwordVisible ? TextInput.Password : TextInput.Normal
                onTextChanged: {
                    if (!acceptInput(text)) {
                        text = lastAcceptedText
                        return
                    }
                    lastAcceptedText = text
                    if (!root.externalTextBinding && root.text !== text) root.text = text
                    root.textEdited()
                    root.inputEvent(text)
                }
                onAccepted: root.accepted()
                onEditingFinished: {
                    root.editingFinished()
                    root.change(text)
                }
                onActiveFocusChanged: {
                    if (activeFocus) root.focusEvent()
                    else root.blurEvent()
                }
                readOnly: root.readOnly
                enabled: !root.disabled
                maximumLength: root.maxLength > 0 ? root.maxLength : 32767
                font.pixelSize: root.fontSize
                font.family: theme.fontFamily
                color: theme.textColor2
                selectionColor: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.2)
                selectedTextColor: theme.textColor1
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: root.horizontalAlignment
                cursorVisible: activeFocus
                cursorDelegate: Rectangle {
                    width: 1
                    color: theme.cursorColorFor(root.status)
                    height: Math.max(parent.cursorRectangle.height, parent.font.pixelSize)
                    y: parent.cursorRectangle.height > 0
                        ? parent.cursorRectangle.y + (parent.cursorRectangle.height - height) / 2
                        : 4
                    visible: parent.activeFocus
                }
                anchors.verticalCenter: parent.verticalCenter
                width: root.textWidthOverride >= 0
                    ? root.textWidthOverride
                    : Math.max(20, parent.width - prefixSlot.width - suffixSlot.width - clearSlot.width - passwordSlot.width - loadingSlot.width)
                height: root.inputHeight
                Keys.onReleased: root.keyUp()
                Keys.onPressed: function(event) { root.keyDown(event.key) }
            }

            Item {
                id: textareaViewport
                visible: root.type === "textarea" && !root.pair
                anchors.top: parent.top
                anchors.topMargin: textareaPaddingVertical
                width: Math.max(20, parent.width - prefixSlot.width - suffixSlot.width - clearSlot.width - loadingSlot.width)
                height: textareaHeight

                Flickable {
                    id: textareaFlick
                    anchors.fill: parent
                    clip: true
                    contentWidth: width
                    contentHeight: textarea.height
                    boundsBehavior: Flickable.StopAtBounds
                    interactive: contentHeight > height + 1

                    TextEdit {
                        id: textarea
                        width: Math.max(20, textareaFlick.width)
                        height: Math.max(textareaFlick.height, contentHeight)
                        text: root.text
                        onTextChanged: {
                            if (!acceptInput(text)) {
                                text = lastAcceptedText
                                return
                            }
                            lastAcceptedText = text
                            if (!root.externalTextBinding && root.text !== text) root.text = text
                            root.textEdited()
                            root.inputEvent(text)
                            updateTextareaHeight()
                        }
                        onCursorRectangleChanged: {
                            var top = cursorRectangle.y
                            var bottom = cursorRectangle.y + cursorRectangle.height
                            if (top < textareaFlick.contentY) {
                                textareaFlick.contentY = top
                            } else if (bottom > textareaFlick.contentY + textareaFlick.height) {
                                textareaFlick.contentY = bottom - textareaFlick.height
                            }
                        }
                        onWidthChanged: Qt.callLater(updateTextareaHeight)
                        readOnly: root.readOnly
                        enabled: !root.disabled
                        font.pixelSize: root.fontSize
                        font.family: theme.fontFamily
                        color: theme.textColor2
                        selectionColor: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.2)
                        selectedTextColor: theme.textColor1
                        wrapMode: TextEdit.Wrap
                        cursorVisible: activeFocus
                        cursorDelegate: Rectangle {
                            width: 1
                            color: theme.cursorColorFor(root.status)
                            height: Math.max(parent.cursorRectangle.height, parent.font.pixelSize)
                            y: parent.cursorRectangle.height > 0
                                ? parent.cursorRectangle.y + (parent.cursorRectangle.height - height) / 2
                                : 0
                            visible: parent.activeFocus
                        }
                        Keys.onReleased: root.keyUp()
                        Keys.onPressed: function(event) { root.keyDown(event.key) }
                    }
                }

            }

            Row {
                id: pairRow
                visible: root.pair
                spacing: 0
                height: parent.height
                width: Math.max(40, parent.width - prefixSlot.width - suffixSlot.width - clearSlot.width - loadingSlot.width)

                Item {
                    id: pairLeftWrap
                    width: Math.max(20, (pairRow.width - sepLabel.width) / 2)
                    height: parent.height

                    TextInput {
                        id: pairLeftInput
                        anchors.fill: parent
                        text: root.pairValue[0]
                        onTextChanged: {
                            root.pairValue[0] = text
                            root.inputEvent(text)
                        }
                        readOnly: root.readOnly
                        enabled: !root.disabled
                        font.pixelSize: root.fontSize
                        font.family: theme.fontFamily
                        color: theme.textColor2
                        selectionColor: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.2)
                        selectedTextColor: theme.textColor1
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: TextInput.AlignHCenter
                        cursorVisible: activeFocus
                        cursorDelegate: Rectangle {
                            width: 1
                            color: theme.cursorColorFor(root.status)
                            height: parent.contentHeight
                            y: (parent.height - height) / 2
                            visible: parent.activeFocus
                        }
                    }

                    Text {
                        text: pairPlaceholder(0)
                        visible: root.pair && pairLeftInput.text.length === 0
                        color: theme.placeholderColor
                        font.pixelSize: root.fontSize
                        font.family: theme.fontFamily
                        width: parent.width
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Text {
                    id: sepLabel
                    text: typeof root.separator === "string" ? root.separator : "to"
                    color: root.disabled ? theme.textColor3 : theme.textColor2
                    font.pixelSize: root.fontSize
                    font.family: theme.fontFamily
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                Item {
                    id: pairRightWrap
                    width: Math.max(20, (pairRow.width - sepLabel.width) / 2)
                    height: parent.height

                    TextInput {
                        id: pairRightInput
                        anchors.fill: parent
                        text: root.pairValue[1]
                        onTextChanged: {
                            root.pairValue[1] = text
                            root.inputEvent(text)
                        }
                        readOnly: root.readOnly
                        enabled: !root.disabled
                        font.pixelSize: root.fontSize
                        font.family: theme.fontFamily
                        color: theme.textColor2
                        selectionColor: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.2)
                        selectedTextColor: theme.textColor1
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: TextInput.AlignHCenter
                        cursorVisible: activeFocus
                        cursorDelegate: Rectangle {
                            width: 1
                            color: theme.cursorColorFor(root.status)
                            height: parent.contentHeight
                            y: (parent.height - height) / 2
                            visible: parent.activeFocus
                        }
                    }

                    Text {
                        text: pairPlaceholder(1)
                        visible: root.pair && pairRightInput.text.length === 0
                        color: theme.placeholderColor
                        font.pixelSize: root.fontSize
                        font.family: theme.fontFamily
                        width: parent.width
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            Item {
                id: clearSlot
                width: showClear ? clearSize : 0
                height: parent.height
                visible: showClear

                Item {
                    id: clearIconSlot
                    anchors.centerIn: parent
                    width: 16
                    height: 16
                    visible: clearIconSlot.children.length > 0
                }

                Image {
                    anchors.centerIn: parent
                    width: clearSize
                    height: clearSize
                    visible: clearIconSlot.children.length === 0
                    source: theme.svgClear(
                        clearPressed
                            ? theme.clearColorPressed
                            : (clearHover.hovered ? theme.clearColorHover : theme.clearColor),
                        clearSize)
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                HoverHandler { id: clearHover; enabled: showClear; cursorShape: Qt.PointingHandCursor }
                MouseArea {
                    anchors.fill: parent
                    enabled: showClear
                    cursorShape: Qt.PointingHandCursor
                    onPressed: clearPressed = true
                    onReleased: clearPressed = false
                    onCanceled: clearPressed = false
                    onClicked: {
                        if (root.pair) {
                            root.pairValue = ["", ""]
                            pairLeftInput.text = ""
                            pairRightInput.text = ""
                        } else {
                            input.text = ""
                            textarea.text = ""
                            root.text = ""
                        }
                        root.textEdited()
                        root.clearEvent()
                    }
                }
            }

            Item {
                id: passwordSlot
                width: root.type === "password" ? clearSize : 0
                height: parent.height
                visible: root.type === "password"

                Item {
                    id: passwordVisibleSlot
                    anchors.centerIn: parent
                    width: 16
                    height: 16
                    visible: passwordVisibleSlot.children.length > 0 && passwordVisible
                }
                Item {
                    id: passwordInvisibleSlot
                    anchors.centerIn: parent
                    width: 16
                    height: 16
                    visible: passwordInvisibleSlot.children.length > 0 && !passwordVisible
                }
                Image {
                    width: 16
                    height: 16
                    source: passwordVisible
                        ? theme.svgEye(theme.iconColor, 16)
                        : theme.svgEyeOff(theme.iconColor, 16)
                    anchors.centerIn: parent
                    visible: passwordVisibleSlot.children.length === 0 && passwordInvisibleSlot.children.length === 0
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }
                MouseArea {
                    anchors.fill: parent
                    enabled: !root.disabled
                    cursorShape: Qt.PointingHandCursor
                    onPressed: function() {
                        if (root.showPasswordOn === "mousedown") passwordVisible = true
                    }
                    onReleased: function() {
                        if (root.showPasswordOn === "mousedown") passwordVisible = false
                    }
                    onClicked: function() {
                        if (root.showPasswordOn === "click") passwordVisible = !passwordVisible
                    }
                }
            }

            Item {
                id: loadingSlot
                width: loadingDefined ? (loadingSize + ((suffixSlot.visible || showClear || root.type === "password") ? suffixGap : 0)) : 0
                height: parent.height
                visible: loadingDefined
                LoadingSpinner {
                    size: loadingSize
                    stroke: theme.primaryColor
                    strokeWidth: theme.spinStrokeWidthMedium
                    radius: 100
                    scale: 1
                    anchors.centerIn: parent
                    visible: loadingVisible
                }
            }
            Item {
                id: suffixSlot
                visible: suffixSlot.children.length > 0
                implicitWidth: childrenRect.width + ((showClear || root.type === "password" || loadingDefined) ? suffixGap : 0)
                implicitHeight: childrenRect.height
                width: visible ? implicitWidth : 0
                height: parent.height

                onChildrenChanged: repositionSuffixChildren()
            }
        }
    }

    Text {
        text: root.placeholder
        visible: !root.disabled
            && !root.pair
            && ((root.type === "textarea" ? textarea.text.length === 0 : input.text.length === 0))
            && root.type !== "textarea"
        color: theme.placeholderColor
        font.pixelSize: root.fontSize
        font.family: theme.fontFamily
        anchors.left: contentWrap.left
        anchors.leftMargin: prefixSlot.width
        anchors.right: contentWrap.right
        anchors.rightMargin: suffixSlot.width + clearSlot.width + passwordSlot.width + loadingSlot.width
        anchors.verticalCenter: contentWrap.verticalCenter
        height: root.inputHeight
        horizontalAlignment: root.horizontalAlignment === TextInput.AlignHCenter
            ? Text.AlignHCenter
            : (root.horizontalAlignment === TextInput.AlignRight ? Text.AlignRight : Text.AlignLeft)
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    Text {
        text: root.placeholder
        visible: root.disabled
            && !root.pair
            && ((root.type === "textarea" ? textarea.text.length === 0 : input.text.length === 0))
            && root.type !== "textarea"
        color: theme.placeholderColorDisabled
        font.pixelSize: root.fontSize
        font.family: theme.fontFamily
        anchors.left: contentWrap.left
        anchors.leftMargin: prefixSlot.width
        anchors.right: contentWrap.right
        anchors.rightMargin: suffixSlot.width + clearSlot.width + passwordSlot.width + loadingSlot.width
        anchors.verticalCenter: contentWrap.verticalCenter
        height: root.inputHeight
        horizontalAlignment: root.horizontalAlignment === TextInput.AlignHCenter
            ? Text.AlignHCenter
            : (root.horizontalAlignment === TextInput.AlignRight ? Text.AlignRight : Text.AlignLeft)
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    Text {
        text: root.placeholder
        visible: !root.disabled
            && !root.pair
            && root.type === "textarea"
            && textarea.text.length === 0
        color: theme.placeholderColor
        font.pixelSize: root.fontSize
        font.family: theme.fontFamily
        anchors.left: contentWrap.left
        anchors.leftMargin: prefixSlot.width
        anchors.right: contentWrap.right
        anchors.rightMargin: suffixSlot.width + clearSlot.width + loadingSlot.width
        anchors.top: contentWrap.top
        anchors.topMargin: textareaPaddingVertical
        elide: Text.ElideRight
    }

    Text {
        text: root.placeholder
        visible: root.disabled
            && !root.pair
            && root.type === "textarea"
            && textarea.text.length === 0
        color: theme.placeholderColorDisabled
        font.pixelSize: root.fontSize
        font.family: theme.fontFamily
        anchors.left: contentWrap.left
        anchors.leftMargin: prefixSlot.width
        anchors.right: contentWrap.right
        anchors.rightMargin: suffixSlot.width + clearSlot.width + loadingSlot.width
        anchors.top: contentWrap.top
        anchors.topMargin: textareaPaddingVertical
        elide: Text.ElideRight
    }

    Text {
        text: countText()
        visible: root.showCount
        color: theme.textColor3
        font.pixelSize: 11
        font.family: theme.fontFamily
        anchors.right: parent.right
        anchors.rightMargin: effectivePaddingRight
            + (root.resizeEnabled ? 18 : 0)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.type === "textarea" ? textareaPaddingVertical : 4
    }

    readonly property bool showClear: root.clearable
        && !root.disabled
        && !root.readOnly
        && (root.pair
            ? (String(root.pairValue[0] || "").length > 0 || String(root.pairValue[1] || "").length > 0)
            : root.text.length > 0)
        && (root.focused || root.hovered)

    readonly property int countValue: root.text.length
    property bool clearPressed: false
    property bool passwordVisible: false
    property string lastAcceptedText: ""
    property int textareaHeight: minTextareaHeight
    property bool textareaUserResized: false
    property int userTextareaHeight: 0

    function acceptInput(value) {
        if (root.maxLength > 0 && value.length > root.maxLength) return false
        if (root.allowInput && !root.allowInput(value)) return false
        return true
    }

    function pairPlaceholder(index) {
        if (!root.pair) return ""
        if (root.placeholderPair && root.placeholderPair.length > index) return root.placeholderPair[index]
        return index === 0 ? "From" : "To"
    }

    function countText() {
        if (!root.showCount) return ""
        return root.maxLength > 0 ? (countValue + "/" + root.maxLength) : String(countValue)
    }

    function updateTextareaHeight() {
        if (root.type !== "textarea") return
        if (textareaUserResized && userTextareaHeight > 0) {
            textareaHeight = Math.max(minTextareaHeight, userTextareaHeight)
            return
        }
        var rows = Math.max(2, Math.ceil(textarea.contentHeight / (root.fontSize + 6)))
        var minRows = 2
        var maxRows = 6
        if (typeof root.autosize === "object") {
            if (root.autosize.minRows) minRows = root.autosize.minRows
            if (root.autosize.maxRows) maxRows = root.autosize.maxRows
        } else if (root.autosize === true) {
            minRows = 2
            maxRows = 6
        } else {
            rows = 2
            minRows = 2
            maxRows = 2
        }
        rows = Math.max(minRows, Math.min(maxRows, rows))
        textareaHeight = rows * (root.fontSize + 8) + textareaPaddingVertical * 2
    }

    function repositionSlotChildren(slotItem) {
        for (var i = 0; i < slotItem.children.length; ++i) {
            var child = slotItem.children[i]
            if (!child || child === null) continue
            if (child.anchors && child.anchors.fill !== undefined) continue
            if (child.anchors && child.anchors.centerIn !== undefined) continue
            if (child.hasOwnProperty("y")) {
                child.y = Math.round((slotItem.height - child.height) / 2)
            }
        }
    }

    function repositionPrefixChildren() {
        repositionSlotChildren(prefixSlot)
    }

    function repositionSuffixChildren() {
        repositionSlotChildren(suffixSlot)
    }

    Component.onCompleted: updateTextareaHeight()
    onHeightChanged: {
        repositionPrefixChildren()
        repositionSuffixChildren()
    }

    Item {
        id: textareaScrollbarHost
        anchors.fill: parent
        visible: root.type === "textarea" && !root.pair

        BrisaScrollBar {
            id: textareaScrollBar
            flickable: textareaFlick
            margin: 4
            crossInset: 4
        }
    }

    Item {
        id: textareaResizeHandle
        width: 14
        height: 14
        visible: root.resizeEnabled
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 4
        anchors.bottomMargin: 4

        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                ctx.strokeStyle = Qt.rgba(0.55, 0.55, 0.55, 0.6)
                ctx.lineWidth = 1
                ctx.beginPath()
                ctx.moveTo(4, height - 2)
                ctx.lineTo(width - 2, 4)
                ctx.moveTo(8, height - 2)
                ctx.lineTo(width - 2, 8)
                ctx.stroke()
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: root.bothResizeEnabled ? Qt.SizeFDiagCursor : Qt.SizeVerCursor
            property real startSceneX: 0
            property real startSceneY: 0
            property real startWidth: 0
            property real startHeight: 0
            onPressed: function(mouse) {
                startSceneX = textareaResizeHandle.mapToItem(null, mouse.x, mouse.y).x
                startSceneY = textareaResizeHandle.mapToItem(null, mouse.x, mouse.y).y
                startWidth = Math.max(root.width, root.implicitWidth)
                startHeight = textareaHeight
                textareaUserResized = true
            }
            onPositionChanged: function(mouse) {
                var currentSceneX = textareaResizeHandle.mapToItem(null, mouse.x, mouse.y).x
                var currentSceneY = textareaResizeHandle.mapToItem(null, mouse.x, mouse.y).y
                if (root.bothResizeEnabled) {
                    root.width = Math.max(minTextareaWidth, startWidth + currentSceneX - startSceneX)
                }
                var deltaY = currentSceneY - startSceneY
                userTextareaHeight = Math.max(minTextareaHeight, startHeight + deltaY)
                textareaHeight = userTextareaHeight
            }
        }
    }
}
