import QtQuick

BrisaPopup {
    id: root

    property bool scrollable: false
    property int bodyMaxHeight: 0
    property int bodySpacing: 0
    property int sectionSpacing: 0

    default property alias content: bodyColumn.data
    property alias header: headerColumn.data
    property alias footer: footerColumn.data

    backgroundColor: theme.popoverColor
    borderColor: theme.borderColor
    borderWidth: 1
    radius: theme.borderRadius
    paddingX: 14
    paddingY: 8
    animationDuration: 150
    shadowEnabled: true
    showArrow: true
    scaleClosed: 0.85
    outsideClosable: true
    blocksUnderlay: true

    content: [
        Column {
            id: containerColumn
            readonly property real naturalWidth: Math.max(
                headerColumn.implicitWidth,
                bodyColumn.implicitWidth,
                footerColumn.implicitWidth
            )
            width: root.popupWidth > 0
                ? Math.max(0, root.popupWidth - root.paddingX * 2)
                : naturalWidth
            spacing: root.sectionSpacing

            Item {
                id: headerColumn
                visible: children.length > 0
                width: root.popupWidth > 0 ? parent.width : implicitWidth
                implicitWidth: childrenRect.width
                implicitHeight: childrenRect.height
            }

            Flickable {
                id: bodyFlick
                width: root.popupWidth > 0 ? parent.width : bodyColumn.implicitWidth
                height: {
                    if (!root.scrollable)
                        return bodyColumn.implicitHeight
                    if (root.bodyMaxHeight > 0)
                        return Math.min(root.bodyMaxHeight, bodyColumn.implicitHeight)
                    return Math.min(240, bodyColumn.implicitHeight)
                }
                contentWidth: width
                contentHeight: bodyColumn.implicitHeight
                clip: true
                interactive: root.scrollable && contentHeight > height
                boundsBehavior: Flickable.StopAtBounds

                WheelHandler {
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                    onWheel: function(event) {
                        if (!bodyFlick.interactive) {
                            event.accepted = false
                            return
                        }
                        var dy = event.angleDelta.y
                        if (dy === 0) {
                            event.accepted = false
                            return
                        }
                        var maxY = Math.max(0, bodyFlick.contentHeight - bodyFlick.height)
                        bodyFlick.contentY = Math.max(0, Math.min(maxY, bodyFlick.contentY - dy))
                        event.accepted = true
                    }
                }

                Item {
                    id: bodyColumn
                    width: (root.popupWidth > 0 || root.scrollable) ? bodyFlick.width : implicitWidth
                    implicitWidth: childrenRect.width
                    implicitHeight: childrenRect.height
                }
            }

            Item {
                id: footerColumn
                visible: children.length > 0
                width: root.popupWidth > 0 ? parent.width : implicitWidth
                implicitWidth: childrenRect.width
                implicitHeight: childrenRect.height
            }
        }
    ]

    BrisaScrollBar {
        flickable: bodyFlick
        visible: root.scrollable && bodyFlick.contentHeight > bodyFlick.height
    }
}
