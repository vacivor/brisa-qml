import QtQuick

Item {
    id: root

    property bool __isBrisaBreadcrumbItem: true
    property bool __brisaBreadcrumbConnected: false
    property string label: ""
    property string href: ""
    property bool clickable: true
    property int index: -1
    property bool showSeparator: true
    property string separator: ""
    property Component icon: null
    property bool active: false
    property bool last: false
    property color separatorColor: theme.textColor3
    property color itemTextColor: theme.textColor3
    property color itemTextColorHover: theme.textColor2
    property color itemTextColorPressed: theme.textColor2
    property color itemTextColorActive: theme.textColor2
    property color itemColorHover: theme.buttonColor2Hover
    property color itemColorPressed: theme.buttonColor2Pressed
    property int itemBorderRadius: theme.borderRadius
    property int itemPadding: 4
    property real itemLineHeight: 1.25
    property real fontWeightActive: Font.Normal
    property string inheritedSeparator: "/"

    signal click(int index, string label)

    readonly property string resolvedSeparator: root.separator.length > 0 ? root.separator : root.inheritedSeparator
    readonly property bool clickableResolved: root.clickable && !root.last

    implicitWidth: itemRow.implicitWidth
    implicitHeight: itemRow.implicitHeight

    Theme {
        id: theme
    }

    function currentVisualColor() {
        if (root.last)
            return root.itemTextColorActive
        if ((hoverHandler.hovered || mouseArea.containsMouse) && root.clickableResolved) {
            if (mouseArea.pressed)
                return root.itemTextColorPressed
            return root.itemTextColorHover
        }
        return root.itemTextColor
    }

    function applyIconColor() {
        if (!iconLoader.item)
            return
        var color = currentVisualColor()
        if (iconLoader.item.hasOwnProperty("iconColor"))
            iconLoader.item.iconColor = color
        if (iconLoader.item.hasOwnProperty("color"))
            iconLoader.item.color = color
    }

    Row {
        id: itemRow
        spacing: 0

        Row {
            spacing: 0
            height: Math.max(linkBackground.height, iconLoader.height)

            Item {
                id: linkBackground
                width: linkRow.implicitWidth + root.itemPadding * 2
                height: Math.max(
                    24,
                    Math.round(theme.fontSizeMedium * root.itemLineHeight) + root.itemPadding * 2
                )

                Rectangle {
                    anchors.fill: parent
                    radius: root.itemBorderRadius
                    color: mouseArea.pressed
                        ? root.itemColorPressed
                        : (hoverHandler.hovered && root.clickableResolved ? root.itemColorHover : "transparent")

                    Behavior on color {
                        ColorAnimation { duration: 220; easing.type: Easing.OutCubic }
                    }
                }

                Row {
                    id: linkRow
                    anchors.centerIn: parent
                    spacing: iconLoader.visible ? 4 : 0

                    Item {
                        width: iconLoader.visible ? 18 : 0
                        height: Math.max(linkText.implicitHeight, 18)

                        Loader {
                            id: iconLoader
                            anchors.centerIn: parent
                            visible: sourceComponent !== null
                            width: visible ? 18 : 0
                            height: visible ? 18 : 0
                            sourceComponent: root.icon
                            onLoaded: root.applyIconColor()
                        }
                    }

                    Text {
                        id: linkText
                        text: root.label
                        color: root.currentVisualColor()
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSizeMedium
                        font.weight: root.last ? root.fontWeightActive : Font.Normal
                        verticalAlignment: Text.AlignVCenter
                        height: Math.round(theme.fontSizeMedium * root.itemLineHeight)
                        renderType: Text.NativeRendering

                        Behavior on color {
                            ColorAnimation { duration: 220; easing.type: Easing.OutCubic }
                        }
                    }
                }

                HoverHandler {
                    id: hoverHandler
                    enabled: root.clickableResolved
                    cursorShape: root.clickableResolved ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onHoveredChanged: root.applyIconColor()
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    enabled: root.clickableResolved
                    hoverEnabled: true
                    cursorShape: root.clickableResolved ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: root.click(root.index, root.label)
                    onPressedChanged: root.applyIconColor()
                }
            }
        }

        Text {
            visible: root.showSeparator && !root.last
            text: root.resolvedSeparator
            color: root.separatorColor
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSizeMedium
            verticalAlignment: Text.AlignVCenter
            height: linkBackground.height
            renderType: Text.NativeRendering
            leftPadding: 8
            rightPadding: 8

            Behavior on color {
                ColorAnimation { duration: 220; easing.type: Easing.OutCubic }
            }
        }
    }

    onLastChanged: applyIconColor()
    onItemTextColorChanged: applyIconColor()
    onItemTextColorHoverChanged: applyIconColor()
    onItemTextColorPressedChanged: applyIconColor()
    onItemTextColorActiveChanged: applyIconColor()
}
