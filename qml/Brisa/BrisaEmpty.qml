import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property string size: "medium"
    property string title: "No Data"
    property string description: "There is nothing to display right now."
    property var iconComponent: null
    property var action: null
    property bool showIcon: true

    implicitWidth: contentColumn.implicitWidth
    implicitHeight: contentColumn.implicitHeight

    Theme { id: theme }

    readonly property int iconSize: size === "tiny" ? 28 : (size === "small" ? 34 : (size === "large" ? 46 : (size === "huge" ? 52 : 40)))
    readonly property int titleFontSize: size === "large" ? 15 : (size === "huge" ? 16 : 14)
    readonly property int descriptionFontSize: size === "large" ? 15 : (size === "huge" ? 16 : 14)
    readonly property int topGap: size === "tiny" ? 10 : (size === "small" ? 12 : (size === "large" ? 16 : (size === "huge" ? 18 : 14)))
    readonly property int textGap: 8
    readonly property int actionGap: size === "tiny" ? 12 : (size === "huge" ? 18 : 16)
    readonly property int bodyWidth: size === "tiny" ? 220 : (size === "small" ? 260 : (size === "large" ? 320 : (size === "huge" ? 344 : 288)))

    Column {
        id: contentColumn
        anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
        width: Math.min(root.bodyWidth, parent ? parent.width : root.bodyWidth)
        spacing: root.topGap

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Item {
            visible: root.showIcon
            width: parent.width
            height: visible ? root.iconSize : 0

            Loader {
                anchors.centerIn: parent
                width: root.iconSize
                height: root.iconSize
                active: root.showIcon
                sourceComponent: root.iconComponent ? root.iconComponent : defaultIcon
            }
        }

        Column {
            width: parent.width
            spacing: root.textGap

            Text {
                visible: root.title.length > 0
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: root.title
                color: theme.textColor2
                font.family: theme.fontFamily
                font.pixelSize: root.titleFontSize
                font.weight: Font.Medium
                wrapMode: Text.Wrap
            }

            Text {
                visible: root.description.length > 0
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: root.description
                color: theme.textColor3
                font.family: theme.fontFamily
                font.pixelSize: root.descriptionFontSize
                lineHeightMode: Text.FixedHeight
                lineHeight: Math.round(root.descriptionFontSize * 1.5)
                wrapMode: Text.Wrap
            }
        }

        Item {
            visible: !!root.action
            width: parent.width
            height: visible ? actionLoader.implicitHeight + root.actionGap : 0

            Loader {
                id: actionLoader
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                active: !!root.action
                sourceComponent: root.action
            }
        }
    }

    Component {
        id: defaultIcon

        Item {
            implicitWidth: root.iconSize
            implicitHeight: root.iconSize

            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                smooth: true
                sourceSize.width: root.iconSize
                sourceSize.height: root.iconSize
                source: theme.svgEmpty(theme.textColorDisabled, root.iconSize)
            }
        }
    }
}
