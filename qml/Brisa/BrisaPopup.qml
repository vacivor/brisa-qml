import QtQuick
import QtQuick.Effects

Item {
    id: root
    width: 0
    height: 0
    implicitWidth: 0
    implicitHeight: 0

    property Item target: null
    property bool open: false
    property string placement: "bottom" // top|bottom|left|right + -start/-end
    property int offset: theme.popoverSpace
    property int edgePadding: 8
    property int paddingX: 14
    property int paddingY: 8
    property int arrowSize: theme.popoverArrowHeight
    property int arrowOffset: theme.popoverArrowOffset
    property int arrowOffsetVertical: theme.popoverArrowOffsetVertical
    property int arrowOverlap: 1
    property bool showArrow: true
    property bool flip: true
    property bool overlap: false
    property bool arrowPointToCenter: false
    property bool shadowEnabled: true
    property color shadowColor1: Qt.rgba(0, 0, 0, 0.12)
    property color shadowColor2: Qt.rgba(0, 0, 0, 0.06)
    property real shadowBlur1: 0.18
    property real shadowBlur2: 0.46
    property int shadowOffset1: 2
    property int shadowOffset2: 5
    property color backgroundColor: "#ffffff"
    property color borderColor: "transparent"
    property int borderWidth: 0
    property int radius: theme.borderRadius
    property int animationDuration: 150
    property real scaleClosed: 0.85
    property real popupWidth: 0
    property real popupHeight: 0
    property bool outsideClosable: false
    property bool blocksUnderlay: false
    property bool mounted: open
    property string resolvedPlacement: placement
    property real resolvedOffsetLeft: 0
    property real resolvedOffsetTop: 0

    signal closeRequested()

    default property alias content: contentColumn.children

    Theme { id: theme }

    readonly property Item overlayItem: root.Window.window
        ? root.Window.window.contentItem
        : null

    Item {
        id: overlayRoot
        parent: root.mounted && overlayItem ? overlayItem : null
        anchors.fill: parent
        visible: root.mounted
        enabled: root.mounted
        z: 3000
        property bool entered: false

        Component.onCompleted: Qt.callLater(function() { overlayRoot.entered = true })
        Component.onDestruction: overlayRoot.entered = false
    }

    Item {
        id: targetTracker
        parent: root.mounted && root.target && overlayItem ? overlayItem : null
        visible: false
        x: root.target ? root.target.mapToItem(overlayItem, 0, 0).x : 0
        y: root.target ? root.target.mapToItem(overlayItem, 0, 0).y : 0
        width: root.target ? root.target.width : 0
        height: root.target ? root.target.height : 0
        onXChanged: root.updatePosition()
        onYChanged: root.updatePosition()
        onWidthChanged: root.updatePosition()
        onHeightChanged: root.updatePosition()
    }

    Rectangle {
        id: overlayMask
        parent: overlayRoot
        anchors.fill: parent
        color: "transparent"
        visible: root.mounted
    }

    MouseArea {
        id: overlayBlocker
        parent: overlayRoot
        anchors.fill: parent
        enabled: root.open && (root.blocksUnderlay || root.outsideClosable)
        propagateComposedEvents: false
        acceptedButtons: Qt.AllButtons
        onClicked: function(mouse) {
            mouse.accepted = true
            if (root.outsideClosable) root.closeRequested()
        }
    }

    Item {
        id: panelWrap
        parent: overlayRoot
        readonly property real naturalContentWidth: contentColumn.implicitWidth
        readonly property real naturalContentHeight: contentColumn.implicitHeight
        width: root.popupWidth > 0 ? root.popupWidth : (naturalContentWidth + root.paddingX * 2)
        height: root.popupHeight > 0 ? root.popupHeight : (naturalContentHeight + root.paddingY * 2)
        opacity: root.open && overlayRoot.entered ? 1 : 0
        scale: root.open && overlayRoot.entered ? 1 : root.scaleClosed
        z: 1
        transformOrigin: root.originForPlacement(root.resolvedPlacement)

        Behavior on opacity { NumberAnimation { duration: root.animationDuration; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: root.animationDuration; easing.type: Easing.OutCubic } }
        onWidthChanged: {
            if (root.mounted && root.open)
                Qt.callLater(root.updatePosition)
        }
        onHeightChanged: {
            if (root.mounted && root.open)
                Qt.callLater(root.updatePosition)
        }

        Item {
            id: arrowLayer
            parent: panelWrap
            readonly property string basePlacement: root.basePlacement(root.resolvedPlacement)
            readonly property int diamondSize: Math.round(root.arrowSize * 1.414)
            width: root.showArrow
                ? ((basePlacement === "left" || basePlacement === "right")
                    ? theme.popoverSpaceArrow
                    : diamondSize + root.arrowSize)
                : 0
            height: root.showArrow
                ? ((basePlacement === "top" || basePlacement === "bottom")
                    ? theme.popoverSpaceArrow
                    : diamondSize + root.arrowSize)
                : 0
            visible: root.showArrow && root.mounted
            z: 0
            clip: true

            Rectangle {
                id: arrowDiamond
                width: arrowLayer.diamondSize
                height: arrowLayer.diamondSize
                color: root.backgroundColor
                border.color: root.borderColor
                border.width: root.borderWidth
                rotation: 45
                antialiasing: true
                x: {
                    if (arrowLayer.basePlacement === "left")
                        return -width / 2
                    if (arrowLayer.basePlacement === "right")
                        return arrowLayer.width - width / 2
                    return (arrowLayer.width - width) / 2
                }
                y: {
                    if (arrowLayer.basePlacement === "top")
                        return -height / 2
                    if (arrowLayer.basePlacement === "bottom")
                        return arrowLayer.height - height / 2
                    return (arrowLayer.height - height) / 2
                }
            }
        }

        Item {
            id: shadowLayer
            anchors.fill: parent
            visible: root.shadowEnabled
            z: -1

            MultiEffect {
                anchors.fill: parent
                source: surface
                shadowEnabled: root.shadowEnabled
                shadowColor: root.shadowColor1
                shadowBlur: root.shadowBlur1
                shadowHorizontalOffset: 0
                shadowVerticalOffset: root.shadowOffset1
                visible: root.shadowEnabled
            }
            MultiEffect {
                anchors.fill: parent
                source: surface
                shadowEnabled: root.shadowEnabled
                shadowColor: root.shadowColor2
                shadowBlur: root.shadowBlur2
                shadowHorizontalOffset: 0
                shadowVerticalOffset: root.shadowOffset2
                visible: root.shadowEnabled
            }
        }

        Rectangle {
            id: surface
            anchors.fill: parent
            color: root.backgroundColor
            radius: root.radius
            border.color: root.borderColor
            border.width: root.borderWidth
            antialiasing: true
            z: 0
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.ArrowCursor
            acceptedButtons: Qt.AllButtons
            hoverEnabled: true
            propagateComposedEvents: false
            onPressed: function(mouse) { mouse.accepted = true }
            z: 1
        }

        Item {
            id: contentWrap
            anchors.fill: parent
            anchors.margins: 0
            z: 2

            Column {
                id: contentColumn
                x: root.paddingX
                y: root.paddingY
                spacing: 0

                Binding on width {
                    when: root.popupWidth > 0
                    value: Math.max(0, contentWrap.width - root.paddingX * 2)
                }
            }
        }
    }

    function clamp(value, min, max) {
        return Math.max(min, Math.min(max, value))
    }

    function basePlacement(place) {
        var i = place.indexOf("-")
        return i >= 0 ? place.substring(0, i) : place
    }

    function alignmentForPlacement(place) {
        var i = place.indexOf("-")
        return i >= 0 ? place.substring(i + 1) : "center"
    }

    function arrowMarginForPlacement(place) {
        if (!root.showArrow || root.overlap)
            return 0
        return theme.popoverSpaceArrow
    }

    function panelDistance() {
        if (root.overlap)
            return 0
        if (!root.showArrow)
            return root.offset
        return Math.max(root.offset, theme.popoverSpaceArrow - 1)
    }

    function oppositePlacement(place) {
        var base = root.basePlacement(place)
        var align = root.alignmentForPlacement(place)
        var opposite = base
        if (base === "top") opposite = "bottom"
        else if (base === "bottom") opposite = "top"
        else if (base === "left") opposite = "right"
        else if (base === "right") opposite = "left"
        return align === "center" ? opposite : (opposite + "-" + align)
    }

    function computePanelPosition(place, tx, ty, tw, th, w, h) {
        var base = root.basePlacement(place)
        var align = root.alignmentForPlacement(place)
        var distance = root.panelDistance()
        var x = tx
        var y = ty

        if (base === "top") {
            x = tx + (tw - w) / 2
            y = ty - h - distance
        } else if (base === "bottom") {
            x = tx + (tw - w) / 2
            y = ty + th + distance
        } else if (base === "left") {
            x = tx - w - distance
            y = ty + (th - h) / 2
        } else if (base === "right") {
            x = tx + tw + distance
            y = ty + (th - h) / 2
        }

        if (align === "start") {
            if (base === "top" || base === "bottom")
                x = tx
            else
                y = ty
        } else if (align === "end") {
            if (base === "top" || base === "bottom")
                x = tx + tw - w
            else
                y = ty + th - h
        }

        return { x: x, y: y }
    }

    function wouldOverflow(place, x, y, w, h) {
        var base = root.basePlacement(place)
        if (base === "top")
            return y < root.edgePadding
        if (base === "bottom")
            return y + h > overlayItem.height - root.edgePadding
        if (base === "left")
            return x < root.edgePadding
        if (base === "right")
            return x + w > overlayItem.width - root.edgePadding
        return false
    }

    function desiredArrowPosition(base, align, tx, ty, tw, th, panelX, panelY, w, h, arrowSpan) {
        var arrowOffset = (base === "top" || base === "bottom")
            ? root.arrowOffset
            : root.arrowOffsetVertical
        var minPos = arrowOffset
        var maxPos = (base === "top" || base === "bottom")
            ? (w - arrowOffset - arrowSpan)
            : (h - arrowOffset - arrowSpan)

        if (base === "top" || base === "bottom") {
            if (root.arrowPointToCenter || align === "center")
                return clamp((tx + tw / 2) - panelX - arrowSpan / 2, minPos, maxPos)
            if (align === "start")
                return clamp(tx - panelX + theme.popoverArrowOffset - arrowSpan / 2, minPos, maxPos)
            return clamp(tx + tw - panelX - theme.popoverArrowOffset - arrowSpan / 2, minPos, maxPos)
        }

        if (root.arrowPointToCenter || align === "center")
            return clamp((ty + th / 2) - panelY - arrowSpan / 2, minPos, maxPos)
        if (align === "start")
            return clamp(ty - panelY + theme.popoverArrowOffsetVertical - arrowSpan / 2, minPos, maxPos)
        return clamp(ty + th - panelY - theme.popoverArrowOffsetVertical - arrowSpan / 2, minPos, maxPos)
    }

    function updatePosition() {
        if (!root.mounted || !root.target || !overlayItem) {
            root.resolvedPlacement = root.placement
            root.resolvedOffsetLeft = 0
            root.resolvedOffsetTop = 0
            return
        }
        var p = root.target.mapToItem(overlayItem, 0, 0)
        var tx = p.x
        var ty = p.y
        var tw = root.target.width
        var th = root.target.height
        var w = panelWrap.width
        var h = panelWrap.height
        var place = root.placement
        var pos = root.computePanelPosition(place, tx, ty, tw, th, w, h)
        if (root.flip && root.wouldOverflow(place, pos.x, pos.y, w, h)) {
            var flipped = root.oppositePlacement(place)
            var flippedPos = root.computePanelPosition(flipped, tx, ty, tw, th, w, h)
            if (!root.wouldOverflow(flipped, flippedPos.x, flippedPos.y, w, h)) {
                place = flipped
                pos = flippedPos
            }
        }

        var base = root.basePlacement(place)
        var align = root.alignmentForPlacement(place)
        var unclampedX = pos.x
        var unclampedY = pos.y
        var x = pos.x
        var y = pos.y
        root.resolvedPlacement = place

        x = clamp(x, root.edgePadding, overlayItem.width - w - root.edgePadding)
        y = clamp(y, root.edgePadding, overlayItem.height - h - root.edgePadding)
        root.resolvedOffsetLeft = x - unclampedX
        root.resolvedOffsetTop = y - unclampedY

        panelWrap.x = Math.round(x)
        panelWrap.y = Math.round(y)

        if (!root.showArrow) return
        var arrowSpan = (base === "top" || base === "bottom") ? arrowLayer.width : arrowLayer.height
        var seam = 1 - root.arrowOverlap
        if (base === "top") {
            arrowLayer.y = h - seam
            arrowLayer.x = root.desiredArrowPosition(base, align, tx, ty, tw, th, panelWrap.x, panelWrap.y, w, h, arrowSpan)
        } else if (base === "bottom") {
            arrowLayer.y = -arrowLayer.height + seam
            arrowLayer.x = root.desiredArrowPosition(base, align, tx, ty, tw, th, panelWrap.x, panelWrap.y, w, h, arrowSpan)
        } else if (base === "left") {
            arrowLayer.x = w - seam
            arrowLayer.y = root.desiredArrowPosition(base, align, tx, ty, tw, th, panelWrap.x, panelWrap.y, w, h, arrowSpan)
        } else if (base === "right") {
            arrowLayer.x = -arrowLayer.width + seam
            arrowLayer.y = root.desiredArrowPosition(base, align, tx, ty, tw, th, panelWrap.x, panelWrap.y, w, h, arrowSpan)
        }
    }

    function originForPlacement(place) {
        if (place.indexOf("top") === 0) return Item.Bottom
        if (place.indexOf("bottom") === 0) return Item.Top
        if (place.indexOf("left") === 0) return Item.Right
        if (place.indexOf("right") === 0) return Item.Left
        return Item.Center
    }

    onPlacementChanged: updatePosition()
    onResolvedPlacementChanged: updatePosition()

    onOpenChanged: {
        if (root.open) {
            destroyTimer.stop()
            root.mounted = true
            Qt.callLater(root.updatePosition)
        } else {
            destroyTimer.restart()
        }
    }

    onMountedChanged: {
        if (root.mounted)
            Qt.callLater(root.updatePosition)
    }

    Timer {
        id: followTimer
        interval: 16
        repeat: true
        running: root.mounted && root.open && !!root.target && !!overlayItem
        onTriggered: root.updatePosition()
    }

    Timer {
        id: destroyTimer
        interval: root.animationDuration
        repeat: false
        onTriggered: {
            if (!root.open)
                root.mounted = false
        }
    }
    onTargetChanged: updatePosition()

    Connections {
        target: overlayItem
        function onWidthChanged() { root.updatePosition() }
        function onHeightChanged() { root.updatePosition() }
    }

    Connections {
        target: root.target
        function onWidthChanged() { root.updatePosition() }
        function onHeightChanged() { root.updatePosition() }
        function onVisibleChanged() { root.updatePosition() }
    }
}
