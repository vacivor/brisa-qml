import QtQuick

Item {
    id: root
    property Flickable flickable
    property string orientation: "vertical" // vertical | horizontal
    property int thickness: theme.scrollbarSize
    property int hoverThickness: theme.scrollbarSize
    property int margin: theme.scrollbarInsetMain
    property int crossInset: theme.scrollbarInsetCross
    property int minThumb: 24
    property color trackColor: theme.scrollbarRailColor
    property color thumbColor: theme.scrollbarColor
    property color thumbHoverColor: theme.scrollbarColorHover
    property bool alwaysVisible: false
    property real dragOffset: 0
    property int hideDelay: 260
    readonly property bool vertical: orientation !== "horizontal"
    readonly property bool needed: root.flickable
        ? (vertical
            ? (root.flickable.contentHeight > root.flickable.height + 1)
            : (root.flickable.contentWidth > root.flickable.width + 1))
        : false
    readonly property bool activeNow: root.alwaysVisible
        || hoverArea.containsMouse
        || hoverArea.pressed
        || (vertical && flickableHover.hovered)
        || (root.flickable ? (vertical ? root.flickable.movingVertically : root.flickable.movingHorizontally) : false)
        || (root.flickable ? (vertical ? root.flickable.flickingVertically : root.flickable.flickingHorizontally) : false)
    property bool active: activeNow

    Theme { id: theme }

    anchors.right: vertical && parent ? parent.right : undefined
    anchors.top: vertical && parent ? parent.top : (parent ? undefined : undefined)
    anchors.bottom: vertical && parent ? parent.bottom : (parent ? parent.bottom : undefined)
    anchors.left: !vertical && parent ? parent.left : undefined
    anchors.rightMargin: vertical ? margin : crossInset
    anchors.leftMargin: vertical ? 0 : crossInset
    anchors.topMargin: vertical ? crossInset : 0
    anchors.bottomMargin: vertical ? crossInset : margin

    width: vertical ? (root.active ? hoverThickness : thickness) : Math.max(0, (parent ? parent.width : 0) - crossInset * 2)
    height: vertical ? Math.max(0, (parent ? parent.height : 0) - crossInset * 2) : (root.active ? hoverThickness : thickness)
    visible: root.needed
    opacity: root.active ? 1 : 0

    Behavior on opacity {
        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
    }
    Behavior on width {
        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
    }
    Behavior on height {
        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
    }

    onActiveNowChanged: {
        if (activeNow) {
            hideTimer.stop()
            active = true
        } else {
            hideTimer.restart()
        }
    }

    onNeededChanged: {
        if (!needed) {
            hideTimer.stop()
            active = false
        } else if (activeNow) {
            active = true
        }
    }

    Timer {
        id: hideTimer
        interval: root.hideDelay
        repeat: false
        onTriggered: {
            if (!root.activeNow)
                root.active = false
        }
    }

    HoverHandler {
        id: flickableHover
        parent: root.flickable
        enabled: !!root.flickable
    }

    Rectangle {
        id: thumb
        width: vertical ? parent.width : root.thumbExtent()
        height: vertical ? root.thumbExtent() : parent.height
        radius: theme.scrollbarBorderRadius
        color: hoverArea.containsMouse || hoverArea.pressed ? root.thumbHoverColor : root.thumbColor
        x: vertical ? 0 : root.thumbOffset()
        y: vertical ? root.thumbOffset() : 0

        Behavior on color {
            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        anchors.leftMargin: vertical ? -4 : 0
        anchors.rightMargin: vertical ? -4 : 0
        anchors.topMargin: vertical ? 0 : -4
        anchors.bottomMargin: vertical ? 0 : -4
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        enabled: root.visible
        onPressed: function(mouse) {
            dragOffset = vertical ? (mouse.y - thumb.y) : (mouse.x - thumb.x)
            applyDrag(vertical ? mouse.y : mouse.x)
        }
        onPositionChanged: function(mouse) {
            if (!pressed) return
            applyDrag(vertical ? mouse.y : mouse.x)
        }
    }

    function applyDrag(pointerPos) {
        if (!root.flickable) return
        if (vertical) {
            var track = root.height - thumb.height
            if (track <= 0) return
            var pos = Math.max(0, Math.min(track, pointerPos - dragOffset))
            var range = root.flickable.contentHeight - root.flickable.height
            root.flickable.contentY = range <= 0 ? 0 : (pos / track) * range
        } else {
            var trackX = root.width - thumb.width
            if (trackX <= 0) return
            var posX = Math.max(0, Math.min(trackX, pointerPos - dragOffset))
            var rangeX = root.flickable.contentWidth - root.flickable.width
            root.flickable.contentX = rangeX <= 0 ? 0 : (posX / trackX) * rangeX
        }
    }

    function thumbExtent() {
        if (!root.flickable)
            return 0
        var ratio = vertical ? root.flickable.visibleArea.heightRatio : root.flickable.visibleArea.widthRatio
        var size = vertical ? root.height : root.width
        if (ratio <= 0 || size <= 0)
            return 0
        return Math.max(root.minThumb, ratio * size)
    }

    function thumbOffset() {
        if (!root.flickable)
            return 0
        var extent = root.thumbExtent()
        var track = (vertical ? root.height : root.width) - extent
        if (track <= 0)
            return 0
        var viewport = vertical ? root.flickable.height : root.flickable.width
        var content = vertical ? root.flickable.contentHeight : root.flickable.contentWidth
        var range = content - viewport
        if (range <= 0)
            return 0
        var position = vertical ? root.flickable.contentY : root.flickable.contentX
        return (position / range) * track
    }
}
