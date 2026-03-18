import QtQuick

Item {
    id: root

    property string text: ""
    property string type: "default" // default | primary | info | success | warning | error
    property string size: "medium" // tiny | small | medium | large
    property bool round: false
    property bool closable: false
    property bool disabled: false
    property bool bordered: true
    property bool strong: false

    signal clicked()
    signal close()

    Theme { id: theme }

    readonly property int tagHeight: {
        switch (size) {
        case "tiny":
            return 18
        case "small":
            return 22
        case "large":
            return 30
        default:
            return 26
        }
    }
    readonly property int tagFontSize: {
        switch (size) {
        case "tiny":
            return 12
        case "small":
            return 12
        case "large":
            return 14
        default:
            return 12
        }
    }
    readonly property int closeSize: {
        switch (size) {
        case "tiny":
            return 16
        case "small":
            return 16
        case "large":
            return 18
        default:
            return 18
        }
    }
    readonly property int closeIconSize: {
        switch (size) {
        case "tiny":
            return 12
        case "small":
            return 12
        case "large":
            return 14
        default:
            return 14
        }
    }
    readonly property int paddingLeft: round ? Math.round(tagHeight / 2) : 7
    readonly property int paddingRight: {
        if (closable) return round ? Math.round(tagHeight / 4) : 0
        return round ? Math.round(tagHeight / 2) : 7
    }
    readonly property int radiusValue: round ? tagHeight / 2 : theme.borderRadius
    readonly property color typeColor: theme.colorForType(type)
    readonly property color textColor: {
        if (type === "default") return theme.textColor2
        return strong ? theme.baseColor : typeColor
    }
    readonly property color backgroundColor: {
        if (strong && type !== "default") return typeColor
        if (type === "default") return theme.dark ? Qt.rgba(1, 1, 1, 0.06) : "#fafafc"
        return Qt.rgba(typeColor.r, typeColor.g, typeColor.b, theme.dark ? 0.18 : 0.12)
    }
    readonly property color borderColorResolved: {
        if (!bordered) return "transparent"
        if (type === "default") return theme.borderColor
        return Qt.rgba(typeColor.r, typeColor.g, typeColor.b, theme.dark ? (type === "warning" ? 0.46 : 0.38) : (type === "warning" ? 0.35 : 0.28))
    }
    readonly property bool hovered: hover.hovered
    property bool closePressed: false
    readonly property color closeIconColor: root.textColor

    implicitHeight: tagHeight
    implicitWidth: Math.max(tagHeight, contentRow.implicitWidth + paddingLeft + paddingRight)
    opacity: disabled ? theme.opacityDisabled : 1

    BrisaRoundRect {
        anchors.fill: parent
        fillColor: root.backgroundColor
        strokeWidth: root.bordered ? 1 : 0
        strokeColor: root.borderColorResolved
        radiusTL: radiusValue
        radiusTR: radiusValue
        radiusBR: radiusValue
        radiusBL: radiusValue
    }

    HoverHandler {
        id: hover
        enabled: !root.disabled
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        enabled: !root.disabled
        onTapped: root.clicked()
    }

    Row {
        id: contentRow
        x: paddingLeft
        y: Math.round((root.height - height) / 2)
        spacing: closable ? 4 : 0

        Text {
            text: root.text
            color: root.textColor
            font.pixelSize: tagFontSize
            font.family: theme.fontFamily
            font.weight: root.strong ? Font.Medium : Font.Normal
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            visible: root.closable
            width: closeSize
            height: closeSize

            Rectangle {
                anchors.centerIn: parent
                width: closeSize
                height: closeSize
                radius: theme.borderRadius
                color: closePressed
                    ? (type === "default"
                        ? theme.buttonColor2Pressed
                        : Qt.rgba(typeColor.r, typeColor.g, typeColor.b, theme.dark ? 0.26 : 0.18))
                    : (closeHover.hovered
                        ? (type === "default"
                            ? theme.buttonColor2Hover
                            : Qt.rgba(typeColor.r, typeColor.g, typeColor.b, theme.dark ? 0.2 : 0.12))
                        : "transparent")
            }

            Image {
                anchors.centerIn: parent
                width: closeIconSize
                height: closeIconSize
                source: theme.svgClose(closeIconColor, closeIconSize)
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            HoverHandler {
                id: closeHover
                enabled: root.closable && !root.disabled
                cursorShape: Qt.PointingHandCursor
            }

            MouseArea {
                anchors.fill: parent
                enabled: root.closable && !root.disabled
                onPressed: closePressed = true
                onReleased: closePressed = false
                onCanceled: closePressed = false
                onClicked: function(mouse) {
                    mouse.accepted = true
                    root.close()
                }
            }
        }
    }
}
