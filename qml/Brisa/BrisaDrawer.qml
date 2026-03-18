import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    property bool open: false
    property Item overlayParent: null
    property string title: ""
    property bool closable: true
    property bool maskClosable: true
    property string placement: "right" // left | right | top | bottom
    property int size: 360
    property int paddingX: 24
    property int paddingY: 16
    property int animationDuration: 200
    property int closeButtonSize: 22
    property int closeButtonTopMargin: 16
    property int closeButtonSideMargin: 24
    property int headerHeight: 54
    property int footerHeight: 54
    property int titleFontSize: 18

    signal closed()

    default property alias content: bodyHost.data
    property alias footer: footerHost.data

    Theme { id: theme }

    readonly property Item overlayItem: root.overlayParent
        ? root.overlayParent
        : (root.parent ? root.parent : null)
    property bool mounted: open

    Column {
        id: bodyHost
        parent: root
        visible: false
        width: parent ? parent.width : 0
        spacing: 8
    }

    Item {
        id: footerHost
        parent: root
        visible: false
        width: parent ? parent.width : 0
        height: parent ? parent.height : 0
    }

    Loader {
        id: drawerLoader
        active: root.mounted && !!overlayItem
        asynchronous: false
        sourceComponent: drawerScene
    }

    Component {
        id: drawerScene

        Item {
            id: drawerRoot
            parent: overlayItem
            anchors.fill: parent
            z: 3000
            property bool entered: false

            Component.onCompleted: {
                bodyHost.parent = bodyColumn
                bodyHost.visible = true
                footerHost.parent = footerContent
                footerHost.visible = true
                Qt.callLater(function() { drawerRoot.entered = true })
            }

            Component.onDestruction: {
                bodyHost.parent = root
                bodyHost.visible = false
                footerHost.parent = root
                footerHost.visible = false
                drawerRoot.entered = false
            }

            Rectangle {
                anchors.fill: parent
                color: theme.drawerMaskColor
                opacity: root.open && drawerRoot.entered ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: root.animationDuration; easing.type: Easing.OutCubic } }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.ArrowCursor
                enabled: root.open
                propagateComposedEvents: false
                onPressed: function(mouse) { mouse.accepted = true }
                onClicked: function(mouse) {
                    mouse.accepted = true
                    if (root.maskClosable) root.closed()
                }
            }

            Item {
                id: panelWrap
                width: (root.placement === "left" || root.placement === "right") ? root.size : parent.width
                height: (root.placement === "top" || root.placement === "bottom") ? root.size : parent.height
                x: {
                    if (root.placement === "right") return root.open && drawerRoot.entered ? parent.width - width : parent.width
                    if (root.placement === "left") return root.open && drawerRoot.entered ? 0 : -width
                    return 0
                }
                y: {
                    if (root.placement === "bottom") return root.open && drawerRoot.entered ? parent.height - height : parent.height
                    if (root.placement === "top") return root.open && drawerRoot.entered ? 0 : -height
                    return 0
                }

                Behavior on x { NumberAnimation { duration: root.animationDuration; easing.type: Easing.OutCubic } }
                Behavior on y { NumberAnimation { duration: root.animationDuration; easing.type: Easing.OutCubic } }

                BrisaRoundRect {
                    id: panel
                    anchors.fill: parent
                    fillColor: theme.modalColor
                    strokeWidth: 0
                    radiusTL: root.placement === "bottom" || root.placement === "right" ? theme.borderRadius : 0
                    radiusTR: root.placement === "bottom" || root.placement === "left" ? theme.borderRadius : 0
                    radiusBR: root.placement === "top" || root.placement === "left" ? theme.borderRadius : 0
                    radiusBL: root.placement === "top" || root.placement === "right" ? theme.borderRadius : 0
                }

                MultiEffect {
                    anchors.fill: panel
                    source: panel
                    shadowEnabled: true
                    shadowColor: Qt.rgba(0, 0, 0, 0.12)
                    shadowBlur: 0.45
                    shadowHorizontalOffset: root.placement === "left" ? 6 : root.placement === "right" ? -6 : 0
                    shadowVerticalOffset: root.placement === "top" ? 6 : root.placement === "bottom" ? -6 : 0
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
                    anchors.fill: parent
                    z: 2

                    Item {
                        id: headerRow
                        width: parent.width
                        height: title.length > 0 ? root.headerHeight : 0
                        visible: height > 0
                        anchors.top: parent.top

                        Text {
                            text: root.title
                            color: theme.textColor1
                            font.pixelSize: root.titleFontSize
                            font.weight: Font.DemiBold
                            font.family: theme.fontFamily
                            anchors.left: parent.left
                            anchors.leftMargin: root.paddingX
                            anchors.right: parent.right
                            anchors.rightMargin: root.closable ? (root.closeButtonSideMargin + root.closeButtonSize + 6) : root.paddingX
                            anchors.verticalCenter: parent.verticalCenter
                            elide: Text.ElideRight
                        }

                        Item {
                            width: root.closable ? root.closeButtonSize : 0
                            height: root.closable ? root.closeButtonSize : 0
                            anchors.right: parent.right
                            anchors.rightMargin: root.closeButtonSideMargin
                            y: root.closeButtonTopMargin
                            visible: root.closable

                            Rectangle {
                                anchors.fill: parent
                                radius: theme.borderRadius
                                color: closeHover.hovered ? theme.hoverColor : "transparent"
                            }
                            Image {
                                anchors.centerIn: parent
                                width: 18
                                height: 18
                                source: theme.svgClose(closeHover.hovered ? theme.textColor2 : theme.textColor3, 18)
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }
                            HoverHandler { id: closeHover; cursorShape: Qt.PointingHandCursor }
                            TapHandler {
                                onTapped: {
                                    root.closed()
                                }
                            }
                        }
                    }

                    BrisaDivider {
                        id: headerDivider
                        visible: headerRow.visible
                        anchors.top: headerRow.bottom
                        width: parent.width
                        compact: true
                        height: visible ? implicitHeight : 0
                    }

                    Item {
                        id: footerRow
                        width: parent.width
                        height: footerRow.children.length > 0 ? root.footerHeight : 0
                        visible: height > 0
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right

                        Item {
                            id: footerContent
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: root.paddingX
                            anchors.rightMargin: root.paddingX
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height

                            Row {
                                id: footerDefaultRow
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 12
                            }
                        }
                    }

                    BrisaDivider {
                        id: footerDivider
                        visible: footerRow.visible
                        anchors.bottom: footerRow.top
                        width: parent.width
                        compact: true
                        height: visible ? implicitHeight : 0
                    }

                    Flickable {
                        id: bodyFlick
                        anchors.top: headerDivider.visible
                            ? headerDivider.bottom
                            : (headerRow.visible ? headerRow.bottom : parent.top)
                        anchors.bottom: footerDivider.visible
                            ? footerDivider.top
                            : (footerRow.visible ? footerRow.top : parent.bottom)
                        anchors.left: parent.left
                        anchors.right: parent.right
                        contentWidth: width
                        contentHeight: bodyColumn.implicitHeight + root.paddingY * 2
                        boundsBehavior: Flickable.StopAtBounds
                        clip: true

                        WheelHandler {
                            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                            onWheel: function(event) {
                                var dx = event.angleDelta.x
                                var dy = event.angleDelta.y
                                if ((event.modifiers & Qt.ShiftModifier) && dx === 0 && dy !== 0)
                                    dx = -dy
                                var rangeX = Math.max(0, bodyFlick.contentWidth - bodyFlick.width)
                                var rangeY = Math.max(0, bodyFlick.contentHeight - bodyFlick.height)
                                if (dx !== 0 && rangeX > 0) {
                                    bodyFlick.contentX = Math.max(0, Math.min(rangeX, bodyFlick.contentX - dx))
                                    event.accepted = true
                                    return
                                }
                                if (dy !== 0 && rangeY > 0) {
                                    bodyFlick.contentY = Math.max(0, Math.min(rangeY, bodyFlick.contentY - dy))
                                    event.accepted = true
                                    return
                                }
                                event.accepted = false
                            }
                        }

                        Column {
                            id: bodyColumn
                            width: Math.max(0, parent.width - root.paddingX * 2)
                            spacing: 8
                            x: root.paddingX
                            y: root.paddingY
                        }
                    }

                    BrisaScrollBar {
                        parent: bodyFlick
                        flickable: bodyFlick
                        z: 3
                    }
                }
            }
        }
    }

    onOpenChanged: {
        if (root.open) {
            destroyTimer.stop()
            root.mounted = true
        } else {
            destroyTimer.restart()
        }
    }

    Timer {
        id: destroyTimer
        interval: root.animationDuration
        repeat: false
        onTriggered: {
            if (!root.open) root.mounted = false
        }
    }
}
