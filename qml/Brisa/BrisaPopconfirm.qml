import QtQuick

BrisaPopover {
    id: root
    property string title: ""
    property string confirmText: "Confirm"
    property string cancelText: "Cancel"
    property bool showCancel: true
    property bool showIcon: true
    property string type: "warning" // default | primary | success | warning | error
    property int maxWidth: 0
    property int defaultMaxWidth: 320
    property real contentWidthOverride: 0

    signal confirmed()
    signal cancelled()

    default property alias content: contentSlot.data
    property alias icon: iconSlot.data
    property alias action: actionSlot.data

    paddingX: 14
    paddingY: 8
    showArrow: true
    bodySpacing: 0
    sectionSpacing: 8
    popupWidth: {
        var bodyWidth = bodyRow.implicitWidth
        var actionWidth = footerRow.implicitWidth
        var contentWidth = Math.max(bodyWidth, actionWidth)
        var padded = contentWidth + paddingX * 2
        var widthLimit = maxWidth > 0 ? maxWidth : defaultMaxWidth
        return Math.min(widthLimit, padded)
    }

    Row {
        id: bodyRow
        spacing: 10
        width: contentWrap.implicitWidth

        Item {
            width: root.showIcon ? 20 : 0
            height: root.showIcon ? 20 : 0
            visible: root.showIcon
            anchors.top: parent.top

            Item {
                id: iconSlot
                anchors.fill: parent
            }

            Rectangle {
                anchors.fill: parent
                radius: 10
                color: Qt.rgba(iconColor().r, iconColor().g, iconColor().b, 0.16)
                visible: iconSlot.children.length === 0
            }

            Text {
                text: "!"
                color: iconColor()
                font.pixelSize: 12
                font.weight: Font.DemiBold
                font.family: "Space Grotesk"
                anchors.centerIn: parent
                visible: iconSlot.children.length === 0
            }
        }

        Column {
            id: contentWrap
            spacing: 4
            readonly property real naturalWidth: Math.max(
                titleText.implicitWidth,
                contentSlot.implicitWidth
            )
            width: root.contentWidthOverride > 0 ? root.contentWidthOverride : naturalWidth

            Text {
                id: titleText
                text: root.title
                visible: root.title.length > 0
                color: theme.textColor1
                font.pixelSize: 13
                font.weight: Font.DemiBold
                font.family: "Space Grotesk"
            }

            Column {
                id: contentSlot
                spacing: 4
                width: root.contentWidthOverride > 0 ? parent.width : implicitWidth
            }
        }
    }

    footer: [
        Row {
            id: footerRow
            spacing: 8
            width: Math.max(bodyRow.implicitWidth, buttonRow.implicitWidth)
            visible: actionSlot.children.length > 0 || root.confirmText !== "" || root.cancelText !== ""

            Item { id: actionSlot }

            Item {
                width: Math.max(0, footerRow.width - buttonRow.implicitWidth)
                height: 1
                visible: actionSlot.children.length === 0
            }

            Row {
                id: buttonRow
                spacing: 8
                visible: actionSlot.children.length === 0

                BrisaButton {
                    text: root.cancelText
                    visible: root.showCancel && root.cancelText !== ""
                    size: "small"
                    onClicked: {
                        root.cancelled()
                        root.closeRequested()
                    }
                }

                BrisaButton {
                    text: root.confirmText
                    visible: root.confirmText !== ""
                    size: "small"
                    type: root.type === "default" ? "primary" : root.type
                    onClicked: {
                        root.confirmed()
                        root.closeRequested()
                    }
                }
            }
        }
    ]

    function iconColor() {
        if (root.type === "primary") return theme.primaryColor
        if (root.type === "success") return theme.successColor
        if (root.type === "error") return theme.errorColor
        if (root.type === "warning") return theme.warningColor
        return theme.warningColor
    }

    function updateLayout() {
        var iconWidth = root.showIcon ? 30 : 0
        var targetWidth = Math.max(120, root.popupWidth - root.paddingX * 2 - iconWidth)
        root.contentWidthOverride = targetWidth
        for (var i = 0; i < contentSlot.children.length; i++) {
            var child = contentSlot.children[i]
            if (child && child.wrapMode !== undefined) {
                child.width = root.contentWidthOverride
            }
        }
        if (root.contentWidthOverride <= 0) {
            root.contentWidthOverride = 0
            for (var j = 0; j < contentSlot.children.length; j++) {
                var c = contentSlot.children[j]
                if (c && c.wrapMode !== undefined) {
                    c.width = c.implicitWidth
                }
            }
        }
    }

    onPopupWidthChanged: updateLayout()
    onOpenChanged: Qt.callLater(updateLayout)
    Component.onCompleted: updateLayout()

    onShowIconChanged: updateLayout()
    onVisibleChanged: Qt.callLater(updateLayout)
}
