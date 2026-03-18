import QtQuick

Item {
    id: root
    property string text: ""
    property string size: "medium"
    Theme { id: theme }

    readonly property int heightValue: theme.heightFor(size)
    readonly property int fontSize: theme.fontSizeFor(size)
    readonly property int paddingX: theme.paddingFor(size)

    implicitHeight: heightValue
    implicitWidth: Math.max(40, label.implicitWidth + paddingX * 2)

    BrisaRoundRect {
        anchors.fill: parent
        fillColor: theme.actionColor
        strokeWidth: 1
        strokeColor: theme.borderColor
        radiusTL: theme.borderRadius
        radiusTR: theme.borderRadius
        radiusBR: theme.borderRadius
        radiusBL: theme.borderRadius
    }

    Text {
        id: label
        text: root.text
        color: theme.textColor2
        font.pixelSize: root.fontSize
        font.family: "Space Grotesk"
        anchors.centerIn: parent
    }
}
