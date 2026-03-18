import QtQuick
import QtQuick.Effects

Item {
    id: root
    property bool open: false
    property string title: ""
    property bool closable: true
    property bool useBuiltinHeader: true
    property bool maskClosable: true
    property bool showHeaderDivider: true
    property bool showFooterDivider: true
    property int widthHint: 520
    property int maxWidth: 720
    property int paddingX: 24
    property int paddingY: 24
    property int bodyTopPadding: paddingY
    property int bodyBottomPadding: paddingY
    property int headerGap: 8
    property int footerGap: 12
    property int animationDuration: 250
    property int headerHeight: 56
    property int footerHeight: 56
    property int closeButtonTopMargin: 20
    property int closeButtonRightMargin: 24
    property int titleFontSize: 18
    property bool mounted: open

    signal closed()

    default property alias content: bodyColumn.data
    property alias footer: footerContent.data

    Theme { id: theme }

    readonly property Item overlayItem: root.Window.window
        ? root.Window.window.contentItem
        : (root.parent ? root.parent : null)

    Item {
        id: modalRoot
        parent: root.mounted && overlayItem ? overlayItem : null
        visible: root.mounted
        enabled: root.mounted
        anchors.fill: parent
        z: 3000
        property bool entered: false

        Component.onCompleted: Qt.callLater(function() { modalRoot.entered = true })
        Component.onDestruction: modalRoot.entered = false

        Rectangle {
            id: mask
            anchors.fill: parent
            color: theme.modalMaskColor
            opacity: root.open && modalRoot.entered ? 1 : 0
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
            anchors.centerIn: parent
            width: Math.min(root.maxWidth, overlayItem ? (overlayItem.width - 32) : root.widthHint, root.widthHint)
            height: Math.min(layoutColumn.implicitHeight, overlayItem ? (overlayItem.height - 48) : layoutColumn.implicitHeight)
            scale: root.open && modalRoot.entered ? 1 : 0.5
            opacity: root.open && modalRoot.entered ? 1 : 0
            Behavior on scale { NumberAnimation { duration: root.animationDuration; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: root.animationDuration; easing.type: Easing.OutCubic } }

            BrisaRoundRect {
                id: panel
                anchors.fill: parent
                fillColor: theme.modalColor
                strokeColor: "transparent"
                strokeWidth: 0
                radiusTL: theme.borderRadius
                radiusTR: theme.borderRadius
                radiusBR: theme.borderRadius
                radiusBL: theme.borderRadius
            }

            MultiEffect {
                anchors.fill: panel
                source: panel
                shadowEnabled: true
                shadowColor: Qt.rgba(0, 0, 0, 0.12)
                shadowBlur: 0.45
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 8
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
                id: layoutColumn
                anchors.fill: parent
                anchors.margins: 0
                z: 2
                implicitHeight: headerRowHeight
                    + headerDividerHeight
                    + bodyFlick.contentHeight
                    + footerDividerHeight
                    + footerRowHeight

                readonly property int headerRowHeight: headerRow.visible ? headerRow.height : 0
                readonly property int headerDividerHeight: headerDivider.visible ? headerDivider.implicitHeight : 0
                readonly property int footerRowHeight: footerRow.visible ? footerRow.height : 0
                readonly property int footerDividerHeight: footerDivider.visible ? footerDivider.implicitHeight : 0

                Item {
                    id: headerRow
                    width: parent.width
                    height: root.useBuiltinHeader && title.length > 0 ? root.headerHeight : 0
                    visible: height > 0
                    anchors.top: parent.top

                    Text {
                        text: root.title
                        color: theme.textColor1
                        font.pixelSize: root.titleFontSize
                        font.weight: Font.DemiBold
                        font.family: "Space Grotesk"
                        anchors.left: parent.left
                        anchors.leftMargin: root.paddingX
                        anchors.right: parent.right
                        anchors.rightMargin: root.closable ? (root.closeButtonRightMargin + 22 + 6) : root.paddingX
                        anchors.verticalCenter: parent.verticalCenter
                        elide: Text.ElideRight
                    }
                }

                BrisaDivider {
                    id: headerDivider
                    visible: headerRow.visible && root.showHeaderDivider
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
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0

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
                    visible: footerRow.visible && root.showFooterDivider
                    anchors.bottom: footerRow.top
                    width: parent.width
                    compact: true
                    height: visible ? implicitHeight : 0
                }

                Item {
                    id: closeButton
                    width: root.closable ? 22 : 0
                    height: root.closable ? 22 : 0
                    anchors.right: parent.right
                    anchors.rightMargin: root.closeButtonRightMargin
                    y: headerRow.visible
                        ? Math.round((headerRow.height - height) / 2)
                        : root.closeButtonTopMargin
                    visible: root.closable
                    z: 3

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

                    HoverHandler {
                        id: closeHover
                        cursorShape: Qt.PointingHandCursor
                    }

                    TapHandler {
                        onTapped: root.closed()
                    }
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
                    contentHeight: bodyColumn.implicitHeight
                        + root.bodyTopPadding
                        + root.bodyBottomPadding
                        + (headerRow.visible ? root.headerGap : 0)
                        + (footerRow.visible ? root.footerGap : 0)
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
                        x: root.paddingX
                        y: headerRow.visible ? (root.headerGap + root.bodyTopPadding) : root.bodyTopPadding
                        width: Math.max(0, parent.width - root.paddingX * 2)
                        spacing: 14
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
            if (!root.open)
                root.mounted = false
        }
    }
}
