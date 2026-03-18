import QtQuick

Item {
    id: root
    property int size: 24
    property int borderRadius: 6
    property color color: theme.primaryColor
    property color iconColor: theme.baseColor
    default property alias data: contentHost.data

    implicitWidth: size
    implicitHeight: size
    width: implicitWidth
    height: implicitHeight

    Theme { id: theme }

    BrisaRoundRect {
        anchors.fill: parent
        fillColor: root.color
        strokeWidth: 0
        radiusTL: root.borderRadius
        radiusTR: root.borderRadius
        radiusBR: root.borderRadius
        radiusBL: root.borderRadius

        Behavior on fillColor {
            ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
        }
    }

    Item {
        id: contentHost
        anchors.centerIn: parent
        width: Math.round(root.size * 0.75)
        height: width

        onChildrenChanged: Qt.callLater(root.applyContentColor)
    }

    onIconColorChanged: applyContentColor()
    onColorChanged: applyContentColor()

    function applyContentColor() {
        for (var i = 0; i < contentHost.children.length; ++i) {
            var child = contentHost.children[i]
            if (!child) continue
            if (child.hasOwnProperty("iconColor")) child.iconColor = root.iconColor
            if (child.hasOwnProperty("color")) child.color = root.iconColor
            if (child.hasOwnProperty("textColor")) child.textColor = root.iconColor
            if (child.hasOwnProperty("width")) child.width = contentHost.width
            if (child.hasOwnProperty("height")) child.height = contentHost.height
        }
    }
}
