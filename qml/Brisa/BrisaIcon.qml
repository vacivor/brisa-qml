import QtQuick

Item {
    id: root
    property var size: 20
    property var color: undefined
    property var depth: undefined
    property Component component: null
    default property alias data: contentHost.data

    readonly property color resolvedColor: color !== undefined ? color : theme.textColor1
    readonly property real resolvedOpacity: depthOpacity(depth)

    implicitWidth: Number(size)
    implicitHeight: Number(size)
    width: implicitWidth
    height: implicitHeight

    Theme { id: theme }

    Item {
        id: contentHost
        anchors.fill: parent
        visible: root.component === null
        opacity: root.resolvedOpacity

        onChildrenChanged: Qt.callLater(root.applyContentColor)

        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.InOutCubic }
        }
    }

    Loader {
        id: componentLoader
        anchors.fill: parent
        active: root.component !== null
        opacity: root.resolvedOpacity
        sourceComponent: root.component
        onLoaded: root.applyItem(item)

        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.InOutCubic }
        }
    }

    onResolvedColorChanged: applyContentColor()
    onWidthChanged: applyContentColor()
    onHeightChanged: applyContentColor()
    onComponentChanged: Qt.callLater(applyContentColor)

    function depthOpacity(value) {
        switch (String(value)) {
        case "1":
            return 0.82
        case "2":
            return 0.72
        case "3":
            return 0.38
        case "4":
            return 0.24
        case "5":
            return 0.18
        default:
            return 1.0
        }
    }

    function applyItem(target) {
        if (!target) return
        if (target.hasOwnProperty("iconColor")) target.iconColor = resolvedColor
        if (target.hasOwnProperty("color")) target.color = resolvedColor
        if (target.hasOwnProperty("textColor")) target.textColor = resolvedColor
        if (target.hasOwnProperty("width")) target.width = root.width
        if (target.hasOwnProperty("height")) target.height = root.height
    }

    function applyContentColor() {
        if (componentLoader.item) {
            applyItem(componentLoader.item)
            return
        }
        for (var i = 0; i < contentHost.children.length; ++i) {
            applyItem(contentHost.children[i])
        }
    }
}
