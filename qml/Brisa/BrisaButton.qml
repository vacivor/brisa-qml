import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property string text: ""
    property string type: "default" // default | tertiary | primary | info | success | warning | error
    property string size: "medium" // tiny | small | medium | large
    property bool ghost: false
    property bool textButton: false // legacy alias
    property bool textStyle: false
    property bool dashed: false
    property bool block: false
    property bool round: false
    property bool circle: false
    property bool disabled: false
    property bool loading: false
    property bool secondary: false
    property bool tertiary: false
    property bool quaternary: false
    property bool strong: false
    property bool bordered: true
    property bool focusable: true
    property bool keyboard: true
    property string groupPosition: "single" // single | first | middle | last
    property bool groupVertical: false
    property string groupSize: ""

    property var color: null // custom color
    property var textColor: null // custom text color

    property url iconSource: ""
    property int iconSize: 0
    property Component iconComponent: null
    property string iconPlacement: "left" // left | right

    signal clicked()

    Theme { id: theme }

    readonly property bool isText: textStyle || textButton
    readonly property string mergedSize: groupSize !== "" ? groupSize : size
    readonly property int buttonHeight: theme.heightFor(mergedSize)
    readonly property int fontSize: theme.fontSizeFor(mergedSize)
    readonly property int paddingX: theme.paddingFor(mergedSize)
    readonly property int paddingRoundX: theme.paddingRoundFor(mergedSize)
    readonly property int iconSizeResolved: iconSize > 0 ? iconSize : theme.iconSizeFor(mergedSize)
    readonly property int iconMargin: theme.iconMarginFor(mergedSize)
    readonly property int iconMarginEffective: root.text.length > 0 ? iconMargin : 0
    readonly property bool inGroup: groupPosition !== "single"
    readonly property int baseRadius: (circle || round) ? buttonHeight : theme.borderRadius
    readonly property int radiusValue: isText ? 0 : baseRadius
    readonly property int radiusTL: {
        if (!inGroup) return radiusValue
        if (groupVertical) return (groupPosition === "first" || groupPosition === "single") ? radiusValue : 0
        return (groupPosition === "first" || groupPosition === "single") ? radiusValue : 0
    }
    readonly property int radiusTR: {
        if (!inGroup) return radiusValue
        if (groupVertical) return (groupPosition === "first" || groupPosition === "single") ? radiusValue : 0
        return (groupPosition === "last" || groupPosition === "single") ? radiusValue : 0
    }
    readonly property int radiusBR: {
        if (!inGroup) return radiusValue
        if (groupVertical) return (groupPosition === "last" || groupPosition === "single") ? radiusValue : 0
        return (groupPosition === "last" || groupPosition === "single") ? radiusValue : 0
    }
    readonly property int radiusBL: {
        if (!inGroup) return radiusValue
        if (groupVertical) return (groupPosition === "last" || groupPosition === "single") ? radiusValue : 0
        return (groupPosition === "first" || groupPosition === "single") ? radiusValue : 0
    }

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed || enterPressed
    readonly property bool focused: root.activeFocus

    property bool enterPressed: false

    readonly property bool iconVisible: iconComponent !== null || iconSource.toString().length > 0
    readonly property int spinnerSize: Math.round(buttonHeight * 0.55)
    readonly property int iconSlot: loading ? spinnerSize : (iconVisible ? iconSizeResolved : 0)
    readonly property int contentHeight: Math.max(label.implicitHeight, iconSlot)

    readonly property int contentPaddingX: isText ? 0 : (round ? paddingRoundX : paddingX)
    readonly property int labelWidth: Math.ceil(label.paintedWidth)
    readonly property int contentWidth: labelWidth + (iconSlot > 0 ? iconSlot + iconMarginEffective : 0)

    implicitHeight: isText ? contentHeight : buttonHeight
    implicitWidth: {
        if (isText) {
            return contentWidth
        }
        if (circle) {
            return buttonHeight
        }
        return Math.max(buttonHeight, contentWidth + contentPaddingX * 2)
    }

    width: implicitWidth
    Layout.fillWidth: root.block
    Layout.preferredWidth: implicitWidth
    Layout.minimumWidth: implicitWidth
    Layout.maximumWidth: root.block ? 100000 : implicitWidth
    Layout.preferredHeight: implicitHeight
    Layout.minimumHeight: implicitHeight
    Layout.maximumHeight: implicitHeight
    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

    Binding {
        target: root
        property: "width"
        value: parent ? parent.width : implicitWidth
        when: root.block && parent
    }

    opacity: disabled ? theme.opacityDisabled : 1
    clip: false
    focus: focusable && !disabled

    HoverHandler {
        id: hoverHandler
        enabled: !root.disabled
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
    }

    TapHandler {
        id: tapHandler
        enabled: !root.disabled && !root.loading
        grabPermissions: PointerHandler.TakeOverForbidden
        onTapped: {
            root.clicked()
            if (waveEnabled) {
                wave.play()
            }
        }
    }

    Keys.onPressed: function(event) {
        if (!root.keyboard || root.loading || root.disabled) {
            return
        }
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            enterPressed = true
            event.accepted = true
        }
    }

    Keys.onReleased: function(event) {
        if (!root.keyboard || root.loading || root.disabled) {
            return
        }
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            enterPressed = false
            root.clicked()
            if (waveEnabled) {
                wave.trigger()
            }
            event.accepted = true
        }
    }

    BrisaRoundRect {
        id: background
        anchors.fill: parent
        fillColor: currentBackground
        strokeWidth: 0
        radiusTL: root.radiusTL
        radiusTR: root.radiusTR
        radiusBR: root.radiusBR
        radiusBL: root.radiusBL
    }

    BrisaRoundRect {
        id: pressOverlay
        anchors.fill: background
        fillColor: "#00000000"
        strokeWidth: 0
        radiusTL: root.radiusTL
        radiusTR: root.radiusTR
        radiusBR: root.radiusBR
        radiusBL: root.radiusBL
        visible: false
        Behavior on fillColor {
            ColorAnimation { duration: theme.transitionDurationFast; easing.type: Easing.OutCubic }
        }
    }

    BrisaWave {
        id: wave
        anchors.fill: parent
        color: rippleColor
        duration: theme.rippleDuration
        waveOpacity: theme.waveOpacity
        radiusTL: root.radiusTL
        radiusTR: root.radiusTR
        radiusBR: root.radiusBR
        radiusBL: root.radiusBL
        z: 2
        visible: waveEnabled
    }

    onPressedChanged: dashedBorder.requestPaint()

    BrisaRoundRect {
        id: borderLayer
        anchors.fill: background
        fillColor: "transparent"
        strokeWidth: showBaseBorder ? 1 : 0
        strokeColor: baseBorderColor
        radiusTL: root.radiusTL
        radiusTR: root.radiusTR
        radiusBR: root.radiusBR
        radiusBL: root.radiusBL
        visible: showBaseBorder
        z: 1
    }


    BrisaRoundRect {
        id: stateBorder
        x: stateBorderInsetLeft
        y: stateBorderInsetTop
        width: background.width - stateBorderInsetLeft
        height: background.height - stateBorderInsetTop
        fillColor: "transparent"
        strokeWidth: showBorder && !root.dashed ? 1 : 0
        strokeColor: stateBorderColor
        radiusTL: root.radiusTL
        radiusTR: root.radiusTR
        radiusBR: root.radiusBR
        radiusBL: root.radiusBL
        visible: showBorder && !root.dashed
        opacity: stateActive ? 1 : 0
        z: 3
        Behavior on opacity {
            NumberAnimation { duration: theme.transitionDurationFast; easing.type: Easing.OutCubic }
        }
    }

    // Group borders follow Naive UI: full borders overlap via group spacing.

    Canvas {
        id: dashedBorder
        anchors.fill: background
        visible: showBorder && root.dashed && !inGroup
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.save()
            ctx.translate(0.5, 0.5)
            ctx.setLineDash([6, 5])
            ctx.lineWidth = 1
            ctx.strokeStyle = dashedBorderColor
            ctx.beginPath()
            var w = width - 1
            var h = height - 1
            var maxR = Math.min(w, h) / 2
            var rtl = Math.min(root.radiusTL, maxR)
            var rtr = Math.min(root.radiusTR, maxR)
            var rbr = Math.min(root.radiusBR, maxR)
            var rbl = Math.min(root.radiusBL, maxR)
            ctx.moveTo(rtl, 0)
            ctx.lineTo(w - rtr, 0)
            ctx.quadraticCurveTo(w, 0, w, rtr)
            ctx.lineTo(w, h - rbr)
            ctx.quadraticCurveTo(w, h, w - rbr, h)
            ctx.lineTo(rbl, h)
            ctx.quadraticCurveTo(0, h, 0, h - rbl)
            ctx.lineTo(0, rtl)
            ctx.quadraticCurveTo(0, 0, rtl, 0)
            ctx.closePath()
            ctx.stroke()
            ctx.restore()
        }
    }

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: iconSlot > 0 ? iconMarginEffective : 0
        layoutDirection: root.iconPlacement === "right" ? Qt.RightToLeft : Qt.LeftToRight

        IconSwitch {
            id: iconSwitch
            size: root.loading ? root.spinnerSize : root.iconSizeResolved
            active: root.loading || root.iconVisible
            showFirst: !root.loading
            first: root.iconComponent !== null ? iconComponentWrapper : (root.iconVisible ? iconImageWrapper : null)
            second: spinnerWrapper
        }

        Text {
            id: label
            text: root.text
            color: currentTextColor
            font.pixelSize: root.fontSize
            font.weight: root.strong ? Font.DemiBold : Font.Normal
            font.family: theme.fontFamily
            font.letterSpacing: 0
            opacity: root.loading ? 0.6 : 1
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            visible: root.text.length > 0
            Behavior on opacity {
                NumberAnimation { duration: theme.transitionDurationFast; easing.type: Easing.OutCubic }
            }
        }
    }

    Component {
        id: spinnerWrapper
        LoadingSpinner {
            size: root.spinnerSize
            stroke: currentTextColor
            strokeWidth: typeof root.size === "number" ? theme.spinStrokeWidthMedium : theme.spinStrokeWidthFor(root.size)
            radius: 100
            scale: 1
            Behavior on stroke {
                ColorAnimation { duration: theme.transitionDuration; easing.type: Easing.OutCubic }
            }
        }
    }

    Component {
        id: iconComponentWrapper
        Item {
            width: root.iconSizeResolved
            height: root.iconSizeResolved
            property color iconColor: currentTextColor
            function applyColor() {
                if (!iconLoader.item) return
                if (iconLoader.item.hasOwnProperty("color")) iconLoader.item.color = iconColor
                if (iconLoader.item.hasOwnProperty("iconColor")) iconLoader.item.iconColor = iconColor
                if (iconLoader.item.hasOwnProperty("textColor")) iconLoader.item.textColor = iconColor
            }
            onIconColorChanged: applyColor()
            Loader {
                id: iconLoader
                anchors.fill: parent
                sourceComponent: root.iconComponent
                onLoaded: parent.applyColor()
            }
        }
    }

    Component {
        id: iconImageWrapper
        Image {
            source: root.iconSource
            width: root.iconSizeResolved
            height: root.iconSizeResolved
            fillMode: Image.PreserveAspectFit
            smooth: true
        }
    }

    property bool warnedConflict: false

    function checkConflict() {
        if (!warnedConflict && (dashed || ghost || isText) && isLeveled) {
            console.warn("BrisaButton: 'dashed', 'ghost' and 'text' cannot be used with 'secondary', 'tertiary' or 'quaternary'.")
            warnedConflict = true
        }
    }

    Component.onCompleted: checkConflict()
    onDashedChanged: checkConflict()
    onGhostChanged: checkConflict()
    onTextStyleChanged: checkConflict()
    onTextButtonChanged: checkConflict()
    onSecondaryChanged: checkConflict()
    onTertiaryChanged: checkConflict()
    onQuaternaryChanged: checkConflict()

    readonly property bool showBorder: {
        return !root.isText
            && !isLeveled
            && (!root.color || root.ghost || root.dashed)
            && root.bordered
    }
    readonly property bool showBaseBorder: showBorder && !root.dashed
    readonly property bool stateActive: root.hovered || root.pressed || root.focused
    readonly property bool waveEnabled: !isLeveled
        && !root.isText
        && !root.disabled
        && !root.loading
    z: stateActive ? 2 : 0

    readonly property color baseTypeColor: theme.colorForType(effectiveType)
    readonly property color baseTypeHover: theme.colorHoverForType(effectiveType)
    readonly property color baseTypePressed: theme.colorPressedForType(effectiveType)

    readonly property var resolvedTextColor: root.textColor !== null ? root.textColor : null
    readonly property var resolvedColor: root.color !== null ? root.color : null

    readonly property color backgroundColor: {
        if (root.isText) return "#00000000"
        if (root.ghost || root.dashed) return "#00000000"
        if (levelSecondary) {
            if (effectiveType === "default") return theme.buttonColor2
            return Qt.rgba(typeTextColor.r, typeTextColor.g, typeTextColor.b, secondaryOpacity)
        }
        if (levelTertiary) {
            return theme.buttonColor2
        }
        if (levelQuaternary) {
            return "#00000000"
        }
        if (resolvedColor !== null) return resolvedColor
        if (effectiveType === "default") return "#00000000"
        return baseTypeColor
    }

    readonly property color backgroundHover: {
        if (root.isText) return "#00000000"
        if (root.ghost || root.dashed) return "#00000000"
        if (levelSecondary) {
            if (effectiveType === "default") return theme.buttonColor2Hover
            return Qt.rgba(typeTextColor.r, typeTextColor.g, typeTextColor.b, secondaryOpacityHover)
        }
        if (levelTertiary) {
            return theme.buttonColor2Hover
        }
        if (levelQuaternary) {
            return theme.buttonColor2Hover
        }
        if (resolvedColor !== null) return createHoverColor(resolvedColor)
        if (effectiveType === "default") return theme.baseColor
        return baseTypeHover
    }

    readonly property color backgroundPressed: {
        if (root.isText) return "#00000000"
        if (root.ghost || root.dashed) return "#00000000"
        if (levelSecondary) {
            if (effectiveType === "default") return theme.buttonColor2Pressed
            return Qt.rgba(typeTextColor.r, typeTextColor.g, typeTextColor.b, secondaryOpacityPressed)
        }
        if (levelTertiary) {
            return theme.buttonColor2Pressed
        }
        if (levelQuaternary) {
            return theme.buttonColor2Pressed
        }
        if (resolvedColor !== null) return createPressedColor(resolvedColor)
        if (effectiveType === "default") return theme.baseColor
        return baseTypePressed
    }

    readonly property color backgroundFocus: backgroundHover

    readonly property color backgroundDisabled: {
        if (root.isText) return "#00000000"
        if (root.ghost || root.dashed) return "#00000000"
        if (levelSecondary) {
            if (effectiveType === "default") return theme.buttonColor2
            return Qt.rgba(typeTextColor.r, typeTextColor.g, typeTextColor.b, secondaryOpacity)
        }
        if (levelTertiary) {
            return theme.buttonColor2
        }
        if (levelQuaternary) {
            return "#00000000"
        }
        if (resolvedColor !== null) return resolvedColor
        if (effectiveType === "default") return "#00000000"
        return baseTypeColor
    }

    readonly property color typeTextColor: {
        if (resolvedColor !== null) return resolvedColor
        if (mergedTypeIsDefault) {
            if (levelTertiary) return theme.textColor3
            return theme.textColor2
        }
        return baseTypeColor
    }

    readonly property real secondaryOpacity: 0.16
    readonly property real secondaryOpacityHover: 0.22
    readonly property real secondaryOpacityPressed: 0.28
    readonly property real tertiaryOpacity: 0.12
    readonly property real tertiaryOpacityHover: 0.18
    readonly property real tertiaryOpacityPressed: 0.24
    readonly property real quaternaryOpacity: 0.06
    readonly property real quaternaryOpacityHover: 0.12
    readonly property real quaternaryOpacityPressed: 0.18
    readonly property bool typeIsTertiary: root.type === "tertiary"
    readonly property bool mergedTypeIsDefault: root.type === "default" || typeIsTertiary
    readonly property bool levelSecondary: root.secondary
    readonly property bool levelTertiary: root.tertiary
    readonly property bool levelQuaternary: root.quaternary
    readonly property bool isLeveled: levelSecondary || levelTertiary || levelQuaternary
    readonly property string effectiveType: {
        if (typeIsTertiary) {
            return "default"
        }
        return root.type
    }

    readonly property color textColorNormal: {
        if (root.isText) {
            if (resolvedTextColor !== null) return resolvedTextColor
            if (resolvedColor !== null) return resolvedColor
            if (mergedTypeIsDefault) return typeIsTertiary ? theme.textColor3 : theme.textColor2
            return baseTypeColor
        }
        if (root.ghost || root.dashed) {
            if (resolvedTextColor !== null) return resolvedTextColor
            if (resolvedColor !== null) return resolvedColor
            if (mergedTypeIsDefault) return theme.textColor2
            return baseTypeColor
        }
        if (isLeveled) {
            if (resolvedColor !== null) return resolvedColor
            return typeTextColor
        }
        if (resolvedTextColor !== null) return resolvedTextColor
        if (resolvedColor !== null) return theme.baseColor
        if (mergedTypeIsDefault) return typeIsTertiary ? theme.textColor3 : theme.textColor2
        return theme.baseColor
    }

    readonly property color textColorHover: {
        if (resolvedTextColor !== null) {
            if (root.isText || root.ghost || root.dashed) return createHoverColor(resolvedTextColor)
            return resolvedTextColor
        }
        if (root.isText) {
            if (resolvedColor !== null) return createHoverColor(resolvedColor)
            return effectiveType === "default" ? theme.primaryColorHover : baseTypeHover
        }
        if (root.ghost || root.dashed) {
            if (resolvedColor !== null) return createHoverColor(resolvedColor)
            return effectiveType === "default" ? theme.primaryColorHover : baseTypeHover
        }
        return textColorNormal
    }

    readonly property color textColorPressed: {
        if (resolvedTextColor !== null) {
            if (root.isText || root.ghost || root.dashed) return createPressedColor(resolvedTextColor)
            return resolvedTextColor
        }
        if (root.isText) {
            if (resolvedColor !== null) return createPressedColor(resolvedColor)
            return effectiveType === "default" ? theme.primaryColorPressed : baseTypePressed
        }
        if (root.ghost || root.dashed) {
            if (resolvedColor !== null) return createPressedColor(resolvedColor)
            return effectiveType === "default" ? theme.primaryColorPressed : baseTypePressed
        }
        return textColorNormal
    }

    readonly property color textColorFocus: {
        if (resolvedTextColor !== null && !(root.isText || root.ghost || root.dashed))
            return resolvedTextColor
        return textColorHover
    }
    readonly property color textColorDisabled: {
        if (resolvedTextColor !== null) return resolvedTextColor
        if (root.isText) {
            return theme.textColor2
        }
        if (root.ghost || root.dashed) {
            return mergedTypeIsDefault ? theme.textColor2 : baseTypeColor
        }
        if (isLeveled) {
            if (resolvedColor !== null) return resolvedColor
            return typeTextColor
        }
        if (mergedTypeIsDefault) {
            return typeIsTertiary ? theme.textColor3 : theme.textColor2
        }
        return theme.baseColor
    }

    readonly property color baseBorderColor: {
        if (!showBorder) return "#00000000"
        if (resolvedColor !== null) return resolvedColor
        if (effectiveType === "default") return theme.borderColor
        return baseTypeColor
    }

    readonly property color borderHoverColor: {
        if (resolvedColor !== null) return createHoverColor(resolvedColor)
        if (effectiveType === "default") return theme.primaryColorHover
        return baseTypeHover
    }

    readonly property color borderPressedColor: {
        if (resolvedColor !== null) return createPressedColor(resolvedColor)
        if (effectiveType === "default") return theme.primaryColorPressed
        return baseTypePressed
    }

    readonly property color borderFocusColor: borderHoverColor
    readonly property color borderDisabledColor: {
        if (resolvedColor !== null) return resolvedColor
        if (effectiveType === "default") return theme.borderColor
        return baseTypeColor
    }

    readonly property color currentBackground: {
        if (root.disabled) return backgroundDisabled
        if (root.pressed) return backgroundPressed
        if (root.focused) return backgroundFocus
        if (root.hovered) return backgroundHover
        return backgroundColor
    }

    readonly property color currentTextColor: {
        if (root.disabled) return textColorDisabled
        if (root.pressed) return textColorPressed
        if (root.focused) return textColorFocus
        if (root.hovered) return textColorHover
        return textColorNormal
    }

    readonly property color stateBorderColor: {
        if (root.disabled) return borderDisabledColor
        if (root.pressed) return borderPressedColor
        if (root.focused) return borderFocusColor
        if (root.hovered) return borderHoverColor
        return "#00000000"
    }

    readonly property bool groupTypeLinked: root.inGroup
        && root.ghost
        && (effectiveType === "primary"
            || effectiveType === "info"
            || effectiveType === "success"
            || effectiveType === "warning"
            || effectiveType === "error")
    readonly property int stateBorderInsetLeft: groupTypeLinked && !groupVertical && groupPosition !== "first" ? -1 : 0
    readonly property int stateBorderInsetTop: groupTypeLinked && groupVertical && groupPosition !== "first" ? -1 : 0

    readonly property color dashedBorderColor: {
        if (root.disabled) return borderDisabledColor
        if (root.pressed) return borderPressedColor
        if (root.focused) return borderFocusColor
        if (root.hovered) return borderHoverColor
        return baseBorderColor
    }

    readonly property color rippleColor: {
        if (resolvedColor !== null) return resolvedColor
        if (mergedTypeIsDefault) return theme.primaryColor
        return baseTypeColor
    }

    function createHoverColor(color) {
        return Qt.lighter(color, 1.08)
    }

    function createPressedColor(color) {
        return Qt.darker(color, 1.12)
    }

    onHoveredChanged: dashedBorder.requestPaint()
    onFocusedChanged: dashedBorder.requestPaint()
}
