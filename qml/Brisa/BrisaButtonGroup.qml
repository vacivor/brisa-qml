import QtQuick

Item {
    id: root

    property string size: "" // tiny | small | medium | large
    property bool vertical: false
    property bool isButtonGroup: true

    default property alias content: container.data

    implicitWidth: layoutWidth
    implicitHeight: layoutHeight

    property real layoutWidth: 0
    property real layoutHeight: 0
    readonly property int overlap: 1

    Item {
        id: container
    }

    function buttonWidth(btn) {
        return btn.width > 0 ? btn.width : btn.implicitWidth
    }

    function buttonHeight(btn) {
        return btn.height > 0 ? btn.height : btn.implicitHeight
    }

    function updateButtons() {
        var list = []
        var children = container.children
        for (var i = 0; i < children.length; i++) {
            var child = children[i]
            if (!child || !child.hasOwnProperty("groupPosition") || child.visible === false)
                continue
            list.push(child)
        }

        var count = list.length
        var maxWidth = 0
        for (var j = 0; j < count; j++) {
            var probe = list[j]
            probe.groupVertical = root.vertical
            probe.groupSize = root.size
            if (count === 1) probe.groupPosition = "single"
            else if (j === 0) probe.groupPosition = "first"
            else if (j === count - 1) probe.groupPosition = "last"
            else probe.groupPosition = "middle"
            maxWidth = Math.max(maxWidth, buttonWidth(probe))
        }

        var cursor = 0
        var maxCross = 0
        for (var k = 0; k < count; k++) {
            var btn = list[k]
            if (root.vertical) {
                btn.width = maxWidth
                btn.x = 0
                btn.y = cursor
                cursor += buttonHeight(btn) - (k < count - 1 ? root.overlap : 0)
                maxCross = Math.max(maxCross, buttonWidth(btn))
            } else {
                btn.x = cursor
                btn.y = 0
                cursor += buttonWidth(btn) - (k < count - 1 ? root.overlap : 0)
                maxCross = Math.max(maxCross, buttonHeight(btn))
            }
        }

        root.layoutWidth = root.vertical ? maxCross : cursor
        root.layoutHeight = root.vertical ? cursor : maxCross
    }

    function requestRelayout() {
        Qt.callLater(root.updateButtons)
    }

    Connections {
        target: container
        function onChildrenChanged() { root.requestRelayout() }
    }

    Repeater {
        model: container.children
        delegate: Item {
            Connections {
                target: modelData
                function onImplicitWidthChanged() { root.requestRelayout() }
                function onImplicitHeightChanged() { root.requestRelayout() }
                function onWidthChanged() { root.requestRelayout() }
                function onHeightChanged() { root.requestRelayout() }
                function onVisibleChanged() { root.requestRelayout() }
            }
        }
    }

    onVerticalChanged: requestRelayout()
    onSizeChanged: requestRelayout()
    Component.onCompleted: requestRelayout()
}
