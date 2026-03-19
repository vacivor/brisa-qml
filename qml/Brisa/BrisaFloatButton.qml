import QtQuick

Item {
    id: root

    property bool __isBrisaFloatButton: true
    property var leftInset: undefined
    property var rightInset: undefined
    property var topInset: undefined
    property var bottomInset: undefined
    property string shape: "circle" // circle | square
    property string position: "fixed" // relative | absolute | fixed
    property string type: "default" // default | primary
    property string menuTrigger: "" // "" | hover | click
    property var showMenu: undefined
    property bool _showMenuInternal: false
    property var _group: null
    property int _groupIndex: 0
    property int _groupCount: 1

    default property alias content: bodyContent.data
    property alias description: descriptionHost.data
    property alias menu: menuColumn.data

    signal clicked()
    signal updateShowMenu(bool value)

    Theme { id: theme }

    readonly property bool grouped: _group !== null
    readonly property string resolvedShape: grouped ? _group.shape : shape
    readonly property bool squareShape: resolvedShape === "square"
    readonly property bool squareGroup: grouped && resolvedShape === "square"
    readonly property bool circleGroup: grouped && resolvedShape === "circle"
    readonly property bool firstInGroup: _groupIndex === 0
    readonly property bool lastInGroup: _groupIndex === _groupCount - 1
    readonly property bool hasMenu: menuTrigger.length > 0 && menuColumn.children.length > 0
    readonly property bool currentShowMenu: showMenu !== undefined ? !!showMenu : _showMenuInternal
    readonly property bool hovered: buttonHover.hovered
    readonly property bool pressed: buttonTap.pressed
    readonly property color resolvedBackgroundColor: type === "primary" ? theme.primaryColor : theme.popoverColor
    readonly property color resolvedFillColor: {
        if (pressed)
            return type === "primary" ? theme.primaryColorPressed : theme.buttonColor2Pressed
        if (hovered)
            return type === "primary" ? theme.primaryColorHover : theme.buttonColor2Hover
        return "transparent"
    }
    readonly property color resolvedTextColor: type === "primary" ? "#ffffff" : theme.textColor2
    readonly property color borderColor: {
        if (squareGroup)
            return "transparent"
        if (type === "primary")
            return "transparent"
        return theme.borderColor
    }
    readonly property int squareRadius: theme.borderRadius
    readonly property int resolvedRadius: squareShape ? squareRadius : Math.max(width, height)
    readonly property real bodyScale: hasMenu && currentShowMenu ? 0.75 : 1.0
    readonly property real bodyOpacity: hasMenu && currentShowMenu ? 0.0 : 1.0
    readonly property real closeScale: hasMenu && currentShowMenu ? 1.0 : 0.75
    readonly property real closeOpacity: hasMenu && currentShowMenu ? 1.0 : 0.0
    readonly property real shadowOpacity: squareGroup ? 0 : (pressed ? 0.24 : hovered ? 0.24 : 0.16)

    implicitWidth: {
        var contentWidth = bodyColumn.implicitWidth + 8
        var baseWidth = Math.max(40, contentWidth)
        if (!squareShape)
            return Math.max(baseWidth, implicitHeight)
        return baseWidth
    }
    implicitHeight: Math.max(40, bodyColumn.implicitHeight + 8)
    width: implicitWidth
    height: implicitHeight
    clip: false

    anchors.left: !grouped && leftInset !== undefined ? parent.left : undefined
    anchors.right: !grouped && rightInset !== undefined ? parent.right : undefined
    anchors.top: !grouped && topInset !== undefined ? parent.top : undefined
    anchors.bottom: !grouped && bottomInset !== undefined ? parent.bottom : undefined
    anchors.leftMargin: leftInset !== undefined ? Number(leftInset) : 0
    anchors.rightMargin: rightInset !== undefined ? Number(rightInset) : 0
    anchors.topMargin: topInset !== undefined ? Number(topInset) : 0
    anchors.bottomMargin: bottomInset !== undefined ? Number(bottomInset) : 0

    function setMenuOpen(value) {
        if (!hasMenu)
            value = false
        if (showMenu === undefined)
            _showMenuInternal = value
        updateShowMenu(value)
    }

    function maybeCloseHoverMenu() {
        if (menuTrigger !== "hover")
            return
        if (buttonHover.hovered || menuHover.hovered)
            return
        setMenuOpen(false)
    }

    Timer {
        id: hoverCloseTimer
        interval: 40
        repeat: false
        onTriggered: root.maybeCloseHoverMenu()
    }

    Rectangle {
        visible: !squareGroup
        x: 0
        y: 2
        width: parent.width
        height: parent.height
        radius: resolvedRadius
        color: Qt.rgba(0, 0, 0, shadowOpacity)
        opacity: visible ? 1 : 0

        Behavior on color {
            ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
        }
    }

    Rectangle {
        id: surface
        anchors.fill: parent
        radius: squareGroup
            ? (firstInGroup || lastInGroup ? squareRadius : 0)
            : resolvedRadius
        topLeftRadius: squareGroup && !firstInGroup ? 0 : radius
        topRightRadius: squareGroup && !firstInGroup ? 0 : radius
        bottomLeftRadius: squareGroup && !lastInGroup ? 0 : radius
        bottomRightRadius: squareGroup && !lastInGroup ? 0 : radius
        color: squareGroup ? "transparent" : resolvedBackgroundColor
        border.width: squareGroup ? 0 : 1
        border.color: borderColor
    }

    Rectangle {
        id: fillLayer
        x: squareGroup ? 4 : 0
        y: squareGroup ? 4 : 0
        width: parent.width - (squareGroup ? 8 : 0)
        height: parent.height - (squareGroup ? 8 : 0)
        radius: squareGroup
            ? Math.max(0, squareRadius - 1)
            : resolvedRadius
        color: resolvedFillColor
        opacity: resolvedFillColor === "transparent" ? 0 : 1

        Behavior on color {
            ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
        }

        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.InOutCubic }
        }
    }

    Rectangle {
        visible: squareGroup && !lastInGroup
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: theme.borderColor
        opacity: 0.95
    }

    HoverHandler {
        id: buttonHover
        target: surface
        enabled: true
        cursorShape: Qt.PointingHandCursor
        onHoveredChanged: {
            if (root.menuTrigger === "hover" && root.hasMenu) {
                if (hovered)
                    root.setMenuOpen(true)
                else
                    hoverCloseTimer.restart()
            }
        }
    }

    TapHandler {
        id: buttonTap
        target: surface
        onTapped: {
            if (root.menuTrigger === "click" && root.hasMenu)
                root.setMenuOpen(!root.currentShowMenu)
            else
                root.clicked()
        }
    }

    Item {
        id: body
        anchors.fill: parent
        scale: bodyScale
        opacity: bodyOpacity

        Behavior on scale {
            NumberAnimation { duration: 300; easing.type: Easing.InOutCubic }
        }

        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.InOutCubic }
        }

        Column {
            id: bodyColumn
            anchors.centerIn: parent
            spacing: descriptionHost.children.length > 0 ? 2 : 0

            Item {
                id: bodyContent
                width: childrenRect.width
                height: childrenRect.height
            }

            Item {
                id: descriptionHost
                visible: children.length > 0
                width: childrenRect.width
                height: childrenRect.height
            }
        }
    }

    Item {
        id: closeLayer
        anchors.fill: parent
        scale: closeScale
        opacity: closeOpacity
        visible: hasMenu

        Behavior on scale {
            NumberAnimation { duration: 300; easing.type: Easing.InOutCubic }
        }

        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.InOutCubic }
        }

        Image {
            anchors.centerIn: parent
            width: 16
            height: 16
            source: theme.svgClose(root.resolvedTextColor, 16)
            fillMode: Image.PreserveAspectFit
            smooth: true
        }
    }

    Item {
        id: menuHost
        visible: hasMenu
        width: menuColumn.implicitWidth
        height: menuColumn.implicitHeight
        anchors.left: parent.left
        anchors.bottom: parent.top
        anchors.bottomMargin: currentShowMenu ? 12 : -8
        opacity: currentShowMenu ? 1 : 0
        z: 10

        Behavior on anchors.bottomMargin {
            NumberAnimation { duration: 300; easing.type: Easing.InOutCubic }
        }

        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.InOutCubic }
        }

        HoverHandler {
            id: menuHover
            target: menuColumn
            enabled: root.hasMenu
            onHoveredChanged: {
                if (root.menuTrigger === "hover") {
                    if (!hovered)
                        hoverCloseTimer.restart()
                }
            }
        }

        Column {
            id: menuColumn
            spacing: 16
        }
    }
}
