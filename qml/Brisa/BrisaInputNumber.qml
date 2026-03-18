import QtQuick

Item {
    id: root
    property var value: 0
    property real min: -999999
    property real max: 999999
    property real step: 1
    property string size: "medium"
    property bool disabled: false
    property string placeholder: ""
    property int precision: 0
    property bool editable: true
    property bool showButton: true
    property string buttonPlacement: "right" // right | both
    property bool clearable: false
    property var loading: undefined
    property string status: "default" // default | warning | error | open
    property bool round: false
    property var parse: null
    property var format: null
    property var validator: null
    property bool updateValueOnInput: true
    property var keyboard: ({ ArrowUp: true, ArrowDown: true })
    property bool wheelEnabled: false
    property alias prefix: userPrefixSlot.data
    property alias suffix: userSuffixSlot.data
    property Component minusIconComponent: null
    property Component addIconComponent: null

    signal valueChangedByUser(var value)
    signal updateValue(var value)
    signal focusEvent()
    signal blurEvent()

    Theme { id: theme }

    readonly property int inputHeight: theme.heightFor(size)
    readonly property int fontSize: theme.fontSizeFor(size)
    readonly property bool readonlyMode: !root.editable
    readonly property int leftInsetForBoth: -1

    implicitHeight: inputHeight
    implicitWidth: 220

    BrisaInput {
        id: input
        anchors.fill: parent
        size: root.size
        disabled: root.disabled
        placeholder: root.placeholder
        round: root.round
        status: root.status
        loading: root.loading
        text: internalText
        readOnly: root.readonlyMode
        clearable: root.clearable && !root.readonlyMode
        contentSpacingOverride: 0
        paddingLeftOverride: (root.showButton && root.buttonPlacement === "both") ? leftInsetForBoth : -1
        paddingRightOverride: root.showButton ? (buttonInsetRight + suffixButtonWidth) : 6
        allowInput: function(v) {
            if (v === "" || v === "-" || v === "." || v === "-.") return true
            return /^-?\d*\.?\d*$/.test(v)
        }
        onEditingFinished: commitText()
        onBlurEvent: {
            commitText()
            root.blurEvent()
        }
        onClearEvent: {
            internalText = ""
            root.value = null
            editing = false
            root.valueChangedByUser(root.value)
            root.updateValue(root.value)
        }
        onFocusEvent: {
            editing = true
            root.focusEvent()
        }
        onInputEvent: function(value) {
            editing = true
            internalText = value
            if (root.updateValueOnInput) {
                commitText(true)
            }
        }
        onKeyDown: function(key) {
            if (key === Qt.Key_Up && root.keyboard.ArrowUp !== false) {
                stepBy(root.step)
            } else if (key === Qt.Key_Down && root.keyboard.ArrowDown !== false) {
                stepBy(-root.step)
            }
        }
        prefix: [
            Item {
                id: prefixWrap
                height: parent.height
                width: prefixWidth
                visible: prefixWidth > 0

                Item {
                    id: prefixButton
                    visible: root.showButton && root.buttonPlacement === "both"
                    width: visible ? buttonHitWidth : 0
                    height: parent.height
                    x: 0
                    z: 2

                    Item {
                        anchors.centerIn: parent
                        width: buttonSize
                        height: buttonSize

                        Rectangle {
                            anchors.fill: parent
                            radius: 4
                            color: "transparent"
                        }
                        Image {
                            anchors.centerIn: parent
                            width: iconSize
                            height: iconSize
                            source: svgIcon("minus", minusIconColor(prefixMinusArea.containsMouse, prefixMinusArea.pressed, minusable), iconSize)
                            visible: !root.minusIconComponent
                        }
                        Loader {
                            anchors.centerIn: parent
                            visible: root.minusIconComponent
                            sourceComponent: root.minusIconComponent
                        }
                    }

                    MouseArea {
                        id: prefixMinusArea
                        anchors.fill: parent
                        enabled: !root.disabled && !root.readonlyMode && minusable
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onPressAndHold: {
                            repeatTimer.repeatStep = -root.step
                            repeatTimer.interval = 120
                            repeatTimer.start()
                            accelTimer.start()
                        }
                        onCanceled: {
                            accelTimer.stop()
                            repeatTimer.stop()
                        }
                        onClicked: stepBy(-root.step)
                        onReleased: {
                            accelTimer.stop()
                            repeatTimer.stop()
                        }
                    }
                }

                Item {
                    id: userPrefixSlot
                    visible: userPrefixSlot.children.length > 0
                    implicitWidth: childrenRect.width
                    width: visible ? implicitWidth : 0
                    height: parent.height
                    x: prefixButton.width > 0 ? (prefixButton.width + (visible ? edgeGap : 0)) : 0
                }
            }
        ]
        suffix: [
            Item {
                id: suffixWrap
                height: parent.height
                width: suffixWidth
                visible: suffixWidth > 0

                Row {
                    id: suffixRow
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: suffixGap

                    Item {
                        id: userSuffixSlot
                        visible: suffixContentWidth > 0
                        width: suffixContentWidth
                        height: parent.height
                    }
                }
            }
        ]
    }

    Item {
        id: rightButtonsOverlay
        visible: root.showButton
        width: suffixButtonWidth
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: buttonInsetRight
        anchors.verticalCenter: parent.verticalCenter
        z: 2

        Row {
            anchors.fill: parent
            spacing: 0

            Item {
                id: rightMinusButton
                visible: root.buttonPlacement === "right"
                width: visible ? buttonHitWidth : 0
                height: parent.height

                Item {
                    anchors.centerIn: parent
                    width: buttonSize
                    height: buttonSize

                    Rectangle { anchors.fill: parent; radius: 4; color: "transparent" }
                    Image {
                        anchors.centerIn: parent
                        width: iconSize
                        height: iconSize
                        source: svgIcon("minus", minusIconColor(rightMinusArea.containsMouse, rightMinusArea.pressed, minusable), iconSize)
                        visible: !root.minusIconComponent
                    }
                    Loader { anchors.centerIn: parent; visible: root.minusIconComponent; sourceComponent: root.minusIconComponent }
                }

                MouseArea {
                    id: rightMinusArea
                    anchors.fill: parent
                    enabled: !root.disabled && !root.readonlyMode && minusable
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onPressAndHold: { repeatTimer.repeatStep = -root.step; repeatTimer.interval = 120; repeatTimer.start(); accelTimer.start() }
                    onCanceled: { accelTimer.stop(); repeatTimer.stop() }
                    onClicked: stepBy(-root.step)
                    onReleased: { accelTimer.stop(); repeatTimer.stop() }
                }
            }

            Item {
                id: plusButton
                width: buttonHitWidth
                height: parent.height

                Item {
                    anchors.centerIn: parent
                    width: buttonSize
                    height: buttonSize

                    Rectangle { anchors.fill: parent; radius: 4; color: "transparent" }
                    Image {
                        anchors.centerIn: parent
                        width: iconSize
                        height: iconSize
                        source: svgIcon("plus", plusIconColor(plusArea.containsMouse, plusArea.pressed, addable), iconSize)
                        visible: !root.addIconComponent
                    }
                    Loader { anchors.centerIn: parent; visible: root.addIconComponent; sourceComponent: root.addIconComponent }
                }

                MouseArea {
                    id: plusArea
                    anchors.fill: parent
                    enabled: !root.disabled && !root.readonlyMode && addable
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onPressAndHold: { repeatTimer.repeatStep = root.step; repeatTimer.interval = 120; repeatTimer.start(); accelTimer.start() }
                    onCanceled: { accelTimer.stop(); repeatTimer.stop() }
                    onClicked: stepBy(root.step)
                    onReleased: { accelTimer.stop(); repeatTimer.stop() }
                }
            }
        }
    }

    HoverHandler {
        id: rootHover
        enabled: !root.disabled
    }

    WheelHandler {
        enabled: root.wheelEnabled && !root.disabled
        onWheel: function(event) {
            if (event.angleDelta.y === 0) return
            var dir = event.angleDelta.y > 0 ? 1 : -1
            stepBy(dir * root.step)
            event.accepted = true
        }
    }

    Timer {
        id: repeatTimer
        interval: 120
        repeat: true
        running: false
        property real repeatStep: 0
        onTriggered: stepBy(repeatStep)
    }

    Timer {
        id: accelTimer
        interval: 600
        repeat: false
        onTriggered: {
            repeatTimer.interval = 60
        }
    }

    property bool editing: false
    property string internalText: formatValue(root.value)
    readonly property bool buttonsVisible: root.showButton
    readonly property bool addable: typeof root.value === "number"
        ? (root.value + root.step <= root.max + 0.0000001)
        : true
    readonly property bool minusable: typeof root.value === "number"
        ? (root.value - root.step >= root.min - 0.0000001)
        : true
    readonly property int buttonSize: 16
    readonly property int buttonHitWidth: 17
    readonly property int iconSize: 16
    readonly property int buttonInsetRight: 8
    readonly property int edgeGap: 8
    readonly property int suffixGap: 0
    readonly property int prefixWidth: {
        var bw = (root.showButton && root.buttonPlacement === "both") ? buttonHitWidth : 0
        var uw = userPrefixSlot.childrenRect.width
        return bw + (bw > 0 && uw > 0 ? edgeGap : 0) + uw
    }
    readonly property int suffixWidth: {
        return suffixContentWidth
    }
    readonly property int suffixContentWidth: {
        var uw = userSuffixSlot.childrenRect.width
        if (uw <= 0) return 0
        return uw + ((root.showButton && root.buttonPlacement === "right") ? edgeGap : 0)
    }
    readonly property int suffixButtonWidth: root.showButton
        ? (root.buttonPlacement === "right" ? 2 * buttonHitWidth : buttonHitWidth)
        : 0

    onValueChanged: {
        if (!editing) internalText = formatValue(root.value)
    }

    function commitText(isPassive) {
        var t = internalText
        if (t === "" || t === "-" || t === "." || t === "-.") {
            if (!isPassive) {
                internalText = formatValue(root.value)
                editing = false
            }
            return
        }
        var parsed = parseValue(t)
        if (parsed === null) {
            if (!isPassive) {
                internalText = formatValue(root.value)
                editing = false
            }
            return
        }
        if (isNaN(parsed)) {
            if (!isPassive) {
                internalText = formatValue(root.value)
                editing = false
            }
            return
        }
        if (root.validator && !root.validator(parsed)) {
            if (!isPassive) {
                internalText = formatValue(root.value)
                editing = false
            }
            return
        }
        var next = clamp(parsed)
        root.value = next
        if (!isPassive) {
            internalText = formatValue(next)
            editing = false
        }
        root.valueChangedByUser(root.value)
        root.updateValue(root.value)
    }

    function stepBy(delta) {
        if (root.disabled) return
        var base = typeof root.value === "number" ? root.value : 0
        var next = clamp(base + delta)
        if (root.validator && !root.validator(next)) return
        root.value = next
        internalText = formatValue(next)
        editing = false
        root.valueChangedByUser(root.value)
        root.updateValue(root.value)
    }

    function clamp(v) {
        return Math.max(min, Math.min(max, v))
    }

    function formatValue(v) {
        if (v === null || v === undefined || v === "") return ""
        if (root.format) return root.format(v)
        if (precision <= 0) return String(Math.round(Number(v)))
        return Number(v).toFixed(precision)
    }

    function parseValue(text) {
        if (root.parse) return root.parse(text)
        var n = Number(text)
        return isNaN(n) ? NaN : n
    }

    function svgIcon(kind, color, size) {
        var c = String(color)
        var s = size || 14
        var svg = ""
        if (kind === "plus") {
            svg = "<svg xmlns='http://www.w3.org/2000/svg' width='" + s + "' height='" + s + "' viewBox='0 0 16 16' fill='none'>"
                + "<path d='M8 3V13' stroke='" + c + "' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/>"
                + "<path d='M13 8H3' stroke='" + c + "' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/>"
                + "</svg>"
        } else {
            svg = "<svg xmlns='http://www.w3.org/2000/svg' width='" + s + "' height='" + s + "' viewBox='0 0 16 16' fill='none'>"
                + "<path d='M13 8H3' stroke='" + c + "' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/>"
                + "</svg>"
        }
        return "data:image/svg+xml;utf8," + encodeURIComponent(svg)
    }

    function minusIconColor(hovered, pressed, allowed) {
        if (!allowed || root.disabled || root.readonlyMode) return theme.iconColorDisabled
        if (pressed) return theme.primaryColorPressed
        if (hovered) return theme.primaryColorHover
        return theme.iconColor
    }

    function plusIconColor(hovered, pressed, allowed) {
        if (!allowed || root.disabled || root.readonlyMode) return theme.iconColorDisabled
        if (pressed) return theme.primaryColorPressed
        if (hovered) return theme.primaryColorHover
        return theme.iconColor
    }
}
