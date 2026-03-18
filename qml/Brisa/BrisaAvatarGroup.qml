import QtQuick

Item {
    id: root

    default property alias avatars: stagingHost.data

    property var size: "medium"
    property int max: 0
    property bool vertical: false
    property bool expandOnHover: false
    property Component rest: null
    property int overlap: {
        if (typeof size === "number")
            return Math.round(Math.max(8, Number(size) * 0.32))
        switch (String(size)) {
        case "small":
            return 10
        case "large":
            return 14
        default:
            return 12
        }
    }
    property int expandedGap: 6
    property bool bordered: true
    property int borderWidth: 2
    property color borderColor: theme.baseColor
    property var overflowColor: undefined
    property var overflowTextColor: undefined

    readonly property bool expanded: hoverArea.containsMouse && expandOnHover
    readonly property int totalCount: avatarCount()
    readonly property int visibleCount: max > 0 ? Math.min(totalCount, max) : totalCount
    readonly property int overflowCount: Math.max(0, totalCount - visibleCount)
    property var restOptions: []
    readonly property color resolvedOverflowColor: overflowColor !== undefined
        ? overflowColor
        : (theme.dark ? Qt.rgba(255, 255, 255, 0.18) : "#64748b")
    readonly property color resolvedOverflowTextColor: overflowTextColor !== undefined
        ? overflowTextColor
        : "#ffffff"

    implicitWidth: vertical ? layout.implicitWidth : layout.implicitWidth
    implicitHeight: vertical ? layout.implicitHeight : layout.implicitHeight

    Theme {
        id: theme
    }

    function avatarCount() {
        if (!layout)
            return 0
        var count = 0
        for (var i = 0; i < layout.children.length; ++i) {
            var child = layout.children[i]
            if (!child || child.__avatarOverflowMarker === true)
                continue
            count += 1
        }
        return count
    }

    function syncAvatars() {
        if (!layout)
            return
        var logicalIndex = 0
        var visibleIndex = 0
        var hidden = []
        for (var i = 0; i < layout.children.length; ++i) {
            var child = layout.children[i]
            if (!child || child.__avatarOverflowMarker === true)
                continue
            var visible = root.max <= 0 || logicalIndex < root.max
            child.visible = visible
            if (child.hasOwnProperty("size"))
                child.size = root.size
            if (child.hasOwnProperty("bordered"))
                child.bordered = root.bordered
            if (child.hasOwnProperty("borderWidth"))
                child.borderWidth = root.borderWidth
            if (child.hasOwnProperty("borderColor"))
                child.borderColor = root.borderColor
            if (visible) {
                child.z = root.visibleCount - visibleIndex + (root.overflowCount > 0 ? 1 : 0)
                visibleIndex += 1
            } else {
                hidden.push({
                    src: child.src,
                    name: child.name,
                    text: child.text,
                    round: child.round,
                    color: child.color
                })
            }
            logicalIndex += 1
        }
        restOptions = hidden
        overflowSlot.visible = root.overflowCount > 0
        applyRestItem()
        if (overflowSlot.visible)
            overflowSlot.z = 0
    }

    function applyRestItem() {
        if (!restLoader.item)
            return
        if (restLoader.item.hasOwnProperty("rest"))
            restLoader.item.rest = root.overflowCount
        if (restLoader.item.hasOwnProperty("options"))
            restLoader.item.options = root.restOptions
    }

    function adoptStagedChildren() {
        if (!layout)
            return
        for (var i = stagingHost.children.length - 1; i >= 0; --i) {
            var child = stagingHost.children[i]
            if (!child)
                continue
            child.parent = layout
        }
        overflowSlot.parent = layout
    }

    onSizeChanged: syncAvatars()
    onMaxChanged: syncAvatars()
    onVerticalChanged: syncAvatars()
    onBorderedChanged: syncAvatars()
    onBorderWidthChanged: syncAvatars()
    onBorderColorChanged: syncAvatars()
    onOverflowColorChanged: syncAvatars()
    onOverflowTextColorChanged: syncAvatars()
    onRestOptionsChanged: applyRestItem()
    Component.onCompleted: syncAvatars()

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: root.expandOnHover
        acceptedButtons: Qt.NoButton
    }

    Loader {
        id: directionLayout
        anchors.fill: parent
        sourceComponent: root.vertical ? verticalLayoutComponent : horizontalLayoutComponent
    }

    property alias layout: directionLayout.item

    Component {
        id: horizontalLayoutComponent

        Row {
            spacing: root.expanded ? root.expandedGap : -root.overlap

            move: Transition {
                NumberAnimation { properties: "x,y"; duration: 180; easing.type: Easing.OutCubic }
            }

            Behavior on spacing {
                NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }
        }
    }

    Component {
        id: verticalLayoutComponent

        Column {
            spacing: root.expanded ? root.expandedGap : -root.overlap

            move: Transition {
                NumberAnimation { properties: "x,y"; duration: 180; easing.type: Easing.OutCubic }
            }

            Behavior on spacing {
                NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }
        }
    }

    Item {
        id: stagingHost
        visible: false
        onChildrenChanged: Qt.callLater(root.adoptStagedChildren)
    }

    Item {
        id: overflowSlot
        parent: stagingHost
        property bool __avatarOverflowMarker: true
        width: defaultOverflowAvatar.resolvedSize
        height: defaultOverflowAvatar.resolvedSize
        visible: root.overflowCount > 0

        Loader {
            id: restLoader
            anchors.fill: parent
            active: root.rest !== null
            visible: active
            sourceComponent: root.rest
            onLoaded: root.applyRestItem()
        }

        BrisaAvatar {
            id: defaultOverflowAvatar
            anchors.fill: parent
            visible: root.rest === null
            size: root.size
            bordered: root.bordered
            borderWidth: root.borderWidth
            borderColor: root.borderColor
            color: root.resolvedOverflowColor
            textColor: root.resolvedOverflowTextColor
            text: "+" + root.overflowCount
        }
    }

    onLayoutChanged: {
        if (!layout)
            return
        adoptStagedChildren()
        syncAvatars()
    }
}
