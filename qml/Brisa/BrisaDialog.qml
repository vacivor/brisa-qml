import QtQuick

BrisaModal {
    id: root
    property string message: ""
    property string confirmText: "Confirm"
    property string cancelText: "Cancel"
    property bool showCancel: true
    closable: true
    useBuiltinHeader: false
    showHeaderDivider: false
    showFooterDivider: false
    widthHint: 446
    maxWidth: 446
    paddingX: 28
    paddingY: 20
    bodyTopPadding: 16
    bodyBottomPadding: 0
    headerGap: 0
    footerGap: 0
    footerHeight: 56
    closeButtonTopMargin: 20
    closeButtonRightMargin: 26
    property int actionSpacing: 12
    readonly property int titleRightReservedWidth: root.closable ? (root.closeButtonRightMargin + 22 + 12) : 0
    property int titleLineHeight: 26
    property string closeReason: ""
    property int titleBottomGap: 8
    property int contentBottomGap: 16
    property int titleVisualOffset: 2
    property int messageVisualOffset: 1
    property int messageFontSize: 14
    property int messageLineHeight: 22
    maskClosable: true

    signal confirmed()
    signal cancelled()

    onClosed: {
        if (root.closeReason === "confirm") {
            root.closeReason = ""
            return
        }
        if (root.closeReason !== "cancel")
            cancelled()
        root.closeReason = ""
    }

    Column {
        spacing: 0
        anchors.left: parent ? parent.left : undefined
        anchors.right: parent ? parent.right : undefined
        width: parent ? parent.width : implicitWidth

        Item {
            visible: root.title.length > 0
            width: parent ? Math.max(0, parent.width - root.titleRightReservedWidth) : 0
            height: visible ? titleText.implicitHeight + root.titleVisualOffset : 0

            Text {
                id: titleText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: root.titleVisualOffset
                text: root.title
            color: theme.textColor1
            font.pixelSize: 18
            font.weight: Font.DemiBold
            font.family: theme.fontFamily
            wrapMode: Text.Wrap
            lineHeightMode: Text.FixedHeight
            lineHeight: root.titleLineHeight
            }
        }

        Item {
            width: 1
            height: root.title.length > 0 && root.message.length > 0 ? root.titleBottomGap : 0
            visible: height > 0
        }

        Item {
            visible: root.message.length > 0
            width: parent ? parent.width : 0
            height: visible ? messageText.implicitHeight + root.messageVisualOffset : 0

            Text {
                id: messageText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: root.messageVisualOffset
                text: root.message
            color: theme.textColor2
            font.pixelSize: root.messageFontSize
            font.family: theme.fontFamily
            font.weight: Font.Normal
            lineHeightMode: Text.FixedHeight
            lineHeight: root.messageLineHeight
            wrapMode: Text.Wrap
            }
        }

        Item {
            width: 1
            height: root.message.length > 0 ? root.contentBottomGap : 0
            visible: height > 0
        }
    }

    footer: [
        Item {
            anchors.fill: parent ? parent : undefined

            Row {
                spacing: root.actionSpacing
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height

                BrisaButton {
                    text: root.cancelText
                    visible: root.showCancel
                    onClicked: {
                        root.closeReason = "cancel"
                        root.cancelled()
                        root.closed()
                    }
                }
                BrisaButton {
                    text: root.confirmText
                    type: "primary"
                    onClicked: {
                        root.closeReason = "confirm"
                        root.confirmed()
                        root.closed()
                    }
                }
            }
        }
    ]
}
