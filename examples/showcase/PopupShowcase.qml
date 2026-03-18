import QtQuick

Item {
    id: root
    width: 900
    implicitHeight: column.implicitHeight

    Theme { id: theme }

    Column {
        id: column
        width: parent.width
        spacing: 20

        Text {
            text: "Popups"
            color: theme.textColor1
            font.family: "Space Grotesk"
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Tooltip and popover aligned with naive-ui light."
            color: theme.textColor3
            font.family: "Space Grotesk"
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Tooltip"
            Column {
                spacing: 12

                Row {
                    spacing: 12
                    BrisaButton {
                        id: tipBtn
                        text: "Hover Me"
                    }
                    BrisaTooltip {
                        target: tipBtn
                        open: tipHover.hovered
                        placement: "top"
                        text: "Naive UI style tooltip"
                    }
                    HoverHandler { id: tipHover; target: tipBtn }
                }

                Row {
                    spacing: 12
                    BrisaButton {
                        id: tipBtn2
                        text: "Bottom"
                    }
                    BrisaTooltip {
                        target: tipBtn2
                        open: tipHover2.hovered
                        placement: "bottom"
                        text: "Bottom tooltip"
                    }
                    HoverHandler { id: tipHover2; target: tipBtn2 }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Popover"
            Column {
                spacing: 12
                BrisaButton {
                    id: popBtn
                    text: "Toggle Popover"
                    onClicked: popOpen = !popOpen
                }

                BrisaPopover {
                    id: popover
                    target: popBtn
                    open: popOpen
                    placement: "bottom-start"
                    onCloseRequested: popOpen = false
                    Column {
                        spacing: 8
                        Text {
                            text: "Popover Title"
                            color: theme.textColor1
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            font.family: "Space Grotesk"
                        }
                        Text {
                            text: "Short content aligned to naive-ui spacing."
                            color: theme.textColor2
                            font.pixelSize: 12
                            font.family: "Space Grotesk"
                            wrapMode: Text.Wrap
                        }
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Popconfirm"
            Column {
                spacing: 12
                BrisaButton {
                    id: confirmBtn
                    text: "Delete"
                    type: "error"
                    onClicked: confirmOpen = !confirmOpen
                }

                BrisaPopconfirm {
                    target: confirmBtn
                    open: confirmOpen
                    placement: "top"
                    title: "Delete Item"
                    confirmText: "Delete"
                    cancelText: "Cancel"
                    type: "error"
                    onCloseRequested: confirmOpen = false
                    onConfirmed: confirmOpen = false
                    onCancelled: confirmOpen = false
                    Text {
                        text: "This action cannot be undone."
                        color: theme.textColor2
                        font.pixelSize: 12
                        font.family: "Space Grotesk"
                        wrapMode: Text.Wrap
                        lineHeightMode: Text.FixedHeight
                        lineHeight: 18
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Popselect"
            Column {
                spacing: 12
                BrisaButton {
                    id: selectBtn
                    text: popValue === "" ? "Choose Member" : popValue
                    onClicked: selectOpen = !selectOpen
                }

                BrisaPopselect {
                    target: selectBtn
                    open: selectOpen
                    placement: "bottom-start"
                    value: popValue
                    options: [
                        { label: "James", value: "James" },
                        { label: "Olivia", value: "Olivia" },
                        { label: "Isabella", value: "Isabella" },
                        { label: "Ava", value: "Ava", disabled: true }
                    ]
                    onUpdateValue: function(value) { popValue = value }
                    onCloseRequested: selectOpen = false
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Dropdown"
            Column {
                spacing: 12
                BrisaButton {
                    id: dropdownBtn
                    text: "Open Dropdown"
                    onClicked: dropOpen = !dropOpen
                }

                BrisaDropdown {
                    target: dropdownBtn
                    open: dropOpen
                    placement: "bottom-start"
                    model: [
                        { key: "profile", label: "Profile" },
                        { key: "billing", label: "Billing" },
                        { type: "divider" },
                        { type: "group", label: "Team" },
                        { key: "members", label: "Members" },
                        { key: "settings", label: "Settings" },
                        { key: "logout", label: "Log out", disabled: true }
                    ]
                    onSelected: function(key) {
                        selectedKey = key
                    }
                    onCloseRequested: dropOpen = false
                }

                Text {
                    text: "Selected: " + (selectedKey === "" ? "-" : selectedKey)
                    color: theme.textColor3
                    font.pixelSize: 12
                    font.family: "Space Grotesk"
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Modal"
            Column {
                spacing: 12
                BrisaButton {
                    id: modalBtn
                    text: "Open Modal"
                    type: "primary"
                    onClicked: modalOpen = true
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Message"
            Column {
                spacing: 12
                Row {
                    spacing: 8
                    BrisaButton { text: "Info"; onClicked: messageBus.push("This is an info message.", "info") }
                    BrisaButton { text: "Success"; type: "success"; onClicked: messageBus.push("Success message.", "success") }
                    BrisaButton { text: "Warning"; type: "warning"; onClicked: messageBus.push("Warning message.", "warning") }
                    BrisaButton { text: "Error"; type: "error"; onClicked: messageBus.push("Error message.", "error") }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Notification"
            Column {
                spacing: 12
                Row {
                    spacing: 8
                    BrisaButton { text: "Info"; onClicked: notificationBus.push("Info", "This is an info notification.", "info") }
                    BrisaButton { text: "Success"; type: "success"; onClicked: notificationBus.push("Success", "Everything looks good.", "success") }
                    BrisaButton { text: "Warning"; type: "warning"; onClicked: notificationBus.push("Warning", "Check your settings.", "warning") }
                    BrisaButton { text: "Error"; type: "error"; onClicked: notificationBus.push("Error", "Something went wrong.", "error") }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Dialog"
            Column {
                spacing: 12
                BrisaButton {
                    text: "Open Dialog"
                    type: "primary"
                    onClicked: dialogOpen = true
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Drawer"
            Column {
                spacing: 12
                Row {
                    spacing: 8
                    BrisaButton {
                        text: "Right"
                        onClicked: {
                            drawerPlacement = "right"
                            drawerOpen = true
                        }
                    }
                    BrisaButton {
                        text: "Left"
                        onClicked: {
                            drawerPlacement = "left"
                            drawerOpen = true
                        }
                    }
                    BrisaButton {
                        text: "Bottom"
                        onClicked: {
                            drawerPlacement = "bottom"
                            drawerOpen = true
                        }
                    }
                }
            }
        }
    }

    property bool popOpen: false
    property bool confirmOpen: false
    property bool selectOpen: false
    property bool dropOpen: false
    property string selectedKey: ""
    property string popValue: ""
    property bool modalOpen: false
    property bool dialogOpen: false
    property bool drawerOpen: false
    property string drawerPlacement: "right"

    BrisaModal {
        open: modalOpen
        title: "Brisa Modal"
        onClosed: modalOpen = false
        Column {
            spacing: 8
            Text {
                text: "This is a modal aligned with naive-ui light."
                color: theme.textColor2
                font.pixelSize: 13
                font.family: "Space Grotesk"
                wrapMode: Text.Wrap
            }
            Text {
                text: "You can put any content here."
                color: theme.textColor2
                font.pixelSize: 12
                font.family: "Space Grotesk"
            }
        }
        footer: [
            Row {
                spacing: 8
                anchors.right: parent ? parent.right : undefined
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                BrisaButton { text: "Cancel"; onClicked: modalOpen = false }
                BrisaButton { text: "Confirm"; type: "primary"; onClicked: modalOpen = false }
            }
        ]
    }

    BrisaMessageBus {
        id: messageBus
        anchors.fill: parent
    }

    BrisaNotificationBus {
        id: notificationBus
        anchors.fill: parent
    }

    BrisaDialog {
        open: dialogOpen
        title: "Delete Item"
        message: "Are you sure you want to delete this item? This action cannot be undone."
        confirmText: "Delete"
        cancelText: "Cancel"
        onClosed: dialogOpen = false
        onConfirmed: dialogOpen = false
        onCancelled: dialogOpen = false
    }

    BrisaDrawer {
        open: drawerOpen
        overlayParent: root.Window.window ? root.Window.window.contentItem : root
        title: "Brisa Drawer"
        placement: drawerPlacement
        onClosed: drawerOpen = false
        Column {
            spacing: 8
            Text {
                text: "Drawer content aligned with naive-ui light."
                color: theme.textColor2
                font.pixelSize: 13
                font.family: "Space Grotesk"
                wrapMode: Text.Wrap
            }
            Text {
                text: "Place any content here."
                color: theme.textColor2
                font.pixelSize: 12
                font.family: "Space Grotesk"
            }
            BrisaList {
                width: parent.width
                bordered: false
                hoverable: true

                BrisaListItem {
                    title: "Stability"
                    description: "No critical incidents reported in the last 24 hours."
                    extra: "Healthy"
                }
                BrisaListItem {
                    title: "Deployments"
                    description: "2 releases are waiting for approval."
                    extra: "Review"
                }
                BrisaListItem {
                    title: "Alerts"
                    description: "On-call coverage confirmed through next week."
                    extra: "Ready"
                    showDivider: false
                }
            }
        }
        footer: [
            Row {
                spacing: 8
                anchors.right: parent ? parent.right : undefined
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                BrisaButton { text: "Cancel"; onClicked: drawerOpen = false }
                BrisaButton { text: "Apply"; type: "primary"; onClicked: drawerOpen = false }
            }
        ]
    }
}
