import QtQuick

Item {
    id: root
    property int spacing: 12
    property int lineSpacing: 12
    property bool _layoutPending: false

    default property alias content: contentHost.data

    implicitWidth: contentHost.implicitWidth
    implicitHeight: contentHost.implicitHeight

    Item { id: contentHost }

    function requestRelayout() {
        if (_layoutPending) return
        _layoutPending = true
        Qt.callLater(function() {
            _layoutPending = false
            relayout()
        })
    }

    function relayout() {
        var available = root.width > 0 ? root.width : (parent ? parent.width : 0)
        var x = 0
        var y = 0
        var lineHeight = 0
        var maxWidth = 0
        var children = contentHost.children
        for (var i = 0; i < children.length; i++) {
            var child = children[i]
            if (!child || child.visible === false) continue
            var cw = child.implicitWidth > 0 ? child.implicitWidth : (child.width > 0 ? child.width : child.childrenRect.width)
            var ch = child.implicitHeight > 0 ? child.implicitHeight : (child.height > 0 ? child.height : child.childrenRect.height)
            if (available > 0 && x > 0 && x + cw > available) {
                x = 0
                y += lineHeight + root.lineSpacing
                lineHeight = 0
            }
            child.x = x
            child.y = y
            x += cw + root.spacing
            lineHeight = Math.max(lineHeight, ch)
            maxWidth = Math.max(maxWidth, x - root.spacing)
        }
        contentHost.implicitWidth = maxWidth
        contentHost.implicitHeight = y + lineHeight
    }

    onWidthChanged: requestRelayout()
    onSpacingChanged: requestRelayout()
    onLineSpacingChanged: requestRelayout()
    Connections {
        target: contentHost
        function onChildrenChanged() { root.requestRelayout() }
    }
    Component.onCompleted: requestRelayout()

    Repeater {
        model: contentHost.children
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
}
