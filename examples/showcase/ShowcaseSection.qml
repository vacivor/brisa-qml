import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property string title: ""
    property string subtitle: ""

    Theme { id: theme }

    width: parent ? parent.width : 800
    height: subtitle.length > 0 ? 54 : 32

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 6

        Text {
            text: root.title
            color: theme.textColor1
            font.family: "Space Grotesk"
            font.pixelSize: 18
            font.weight: Font.DemiBold
            font.letterSpacing: 0.4
        }

        Text {
            visible: root.subtitle.length > 0
            text: root.subtitle
            color: theme.textColor3
            font.family: "Space Grotesk"
            font.pixelSize: 12
            font.weight: Font.Medium
        }
    }
}
