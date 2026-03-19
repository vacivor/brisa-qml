import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls

ApplicationWindow {
    id: window
    width: 1280
    height: 860
    visible: true
    title: qsTr("Brisa QML Showcase")
    color: theme.appWindowColor

    Theme { id: theme }

    Rectangle {
        id: backdrop
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: theme.appBackdropStart }
            GradientStop { position: 0.5; color: theme.appBackdropMid }
            GradientStop { position: 1.0; color: theme.appBackdropEnd }
        }
    }

    Rectangle {
        id: vignette
        anchors.fill: parent
        color: "transparent"
        border.color: theme.appVignetteBorderColor
        border.width: 1
        radius: 18
        anchors.margins: 18
    }

    Rectangle {
        id: frame
        anchors.fill: parent
        anchors.margins: 24
        radius: 20
        color: theme.baseColor
        border.color: theme.borderColor
        border.width: 1
    }

    Item {
        id: contentHost
        anchors.fill: frame
        anchors.margins: 20

        RowLayout {
            id: layout
            anchors.fill: parent
            spacing: 18

            Item {
                id: sidebar
                width: 230
                Layout.preferredWidth: width
                Layout.fillHeight: true

                Column {
                    id: sidebarHeader
                    width: parent.width
                    spacing: 18

                    Text {
                        text: "Brisa"
                        color: theme.textColor1
                        font.family: "Space Grotesk"
                        font.pixelSize: 22
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: ThemeStore.dark ? "Dark components" : "Light components"
                        color: theme.textColor3
                        font.family: "Space Grotesk"
                        font.pixelSize: 11
                    }

                    BrisaButton {
                        text: ThemeStore.dark ? "Switch To Light" : "Switch To Dark"
                        type: "tertiary"
                        onClicked: ThemeStore.toggle()
                    }
                }

                Item {
                    id: sidebarViewport
                    anchors.top: sidebarHeader.bottom
                    anchors.topMargin: 18
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom

                    Flickable {
                        id: sidebarScroller
                        anchors.fill: parent
                        clip: true
                        contentWidth: width
                        contentHeight: menu.implicitHeight
                        interactive: false

                        BrisaMenu {
                            id: menu
                            width: sidebarScroller.width
                            items: [
                                { type: "group", label: "Layout", children: [
                                    { key: "layout", label: "Overview" },
                                    { key: "buttons", label: "Buttons" }
                                ]},
                                { type: "group", label: "Data Entry", children: [
                                    { key: "inputs", label: "Inputs" },
                                    { key: "input-number", label: "Input Number" },
                                    { key: "select", label: "Select" },
                                    { key: "tabs", label: "Tabs" },
                                    { key: "pagination", label: "Pagination" },
                                    { key: "progress", label: "Progress" },
                                    { key: "form", label: "Form" },
                                    { key: "switch", label: "Switch" },
                                    { key: "checkbox", label: "Checkbox" },
                                    { key: "radio", label: "Radio" },
                                    { key: "alert", label: "Alert" }
                                ]},
                                { type: "group", label: "Foundation", children: [
                                    { key: "avatar", label: "Avatar" },
                                    { key: "badge", label: "Badge" },
                                    { key: "breadcrumb", label: "Breadcrumb" },
                                    { key: "float-button", label: "Float Button" },
                                    { key: "icon", label: "Icon" },
                                    { key: "list", label: "List" },
                                    { key: "spin", label: "Spin" },
                                    { key: "empty", label: "Empty" },
                                    { key: "data-table", label: "Data Table" },
                                    { key: "divider", label: "Divider" },
                                    { key: "collapse", label: "Collapse" },
                                    { key: "tag", label: "Tag" },
                                    { key: "card", label: "Cards" },
                                    { key: "menu", label: "Menu" },
                                    { key: "popups", label: "Popups" }
                                ]}
                            ]
                            currentKey: "layout"
                            onActivated: scroller.contentY = 0
                        }
                    }

                    WheelHandler {
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                        onWheel: function(event) {
                            var dy = event.angleDelta.y
                            if (dy === 0) return
                            var range = Math.max(0, sidebarScroller.contentHeight - sidebarScroller.height)
                            if (range <= 0) {
                                event.accepted = false
                                return
                            }
                            sidebarScroller.contentY = Math.max(0, Math.min(range, sidebarScroller.contentY - dy))
                            event.accepted = true
                        }
                    }

                    BrisaScrollBar {
                        id: sidebarScrollBar
                        flickable: sidebarScroller
                    }
                }
            }

            Item {
                id: content
                Layout.fillWidth: true
                Layout.fillHeight: true

                Item {
                    id: focusSink
                    focus: true
                    visible: false
                }

                Flickable {
                    id: scroller
                    anchors.fill: parent
                    clip: true
                    interactive: false
                    contentWidth: width
                    contentHeight: pageLoader.item ? pageLoader.item.implicitHeight + 40 : 0

                    TapHandler {
                        acceptedButtons: Qt.LeftButton
                        onTapped: focusSink.forceActiveFocus()
                    }

                    Loader {
                        id: pageLoader
                        width: scroller.width
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        sourceComponent: {
                            switch (menu.currentKey) {
                            case "buttons":
                                return buttonPage
                            case "card":
                                return cardPage
                            case "avatar":
                                return avatarPage
                            case "divider":
                                return dividerPage
                            case "collapse":
                                return collapsePage
                            case "icon":
                                return iconPage
                            case "list":
                                return listPage
                            case "breadcrumb":
                                return breadcrumbPage
                            case "badge":
                                return badgePage
                            case "float-button":
                                return floatButtonPage
                            case "spin":
                                return spinPage
                            case "empty":
                                return emptyPage
                            case "data-table":
                                return dataTablePage
                            case "tag":
                                return tagPage
                            case "menu":
                                return menuPage
                            case "popups":
                                return popupsPage
                            case "inputs":
                                return inputsPage
                            case "input-number":
                                return inputNumberPage
                            case "select":
                                return selectPage
                            case "tabs":
                                return tabsPage
                            case "pagination":
                                return paginationPage
                            case "progress":
                                return progressPage
                            case "checkbox":
                                return checkboxPage
                            case "radio":
                                return radioPage
                            case "alert":
                                return alertPage
                            case "form":
                                return formPage
                            case "switch":
                                return switchPage
                            default:
                                return layoutPage
                            }
                        }
                    }
                }

                WheelHandler {
                    id: wheel
                    target: scroller
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                    onWheel: function(event) {
                        var dy = event.angleDelta.y
                        if (dy === 0) return
                        var range = Math.max(0, scroller.contentHeight - scroller.height)
                        if (range <= 0) {
                            event.accepted = false
                            return
                        }
                        scroller.contentY = Math.max(0, Math.min(range, scroller.contentY - dy))
                        event.accepted = true
                    }
                }

                BrisaScrollBar {
                    id: contentScrollBar
                    flickable: scroller
                }
            }
        }
    }

    Component { id: layoutPage; LayoutShowcase { width: pageLoader.width } }
    Component { id: buttonPage; ButtonShowcase { width: pageLoader.width } }
    Component { id: avatarPage; AvatarShowcase { width: pageLoader.width } }
    Component { id: badgePage; BadgeShowcase { width: pageLoader.width } }
    Component { id: inputsPage; InputShowcase { width: pageLoader.width } }
    Component { id: inputNumberPage; InputNumberShowcase { width: pageLoader.width } }
    Component { id: selectPage; SelectShowcase { width: pageLoader.width } }
    Component { id: tabsPage; TabsShowcase { width: pageLoader.width } }
    Component { id: paginationPage; PaginationShowcase { width: pageLoader.width } }
    Component { id: progressPage; ProgressShowcase { width: pageLoader.width } }
    Component { id: formPage; FormShowcase { width: pageLoader.width } }
    Component { id: switchPage; SwitchShowcase { width: pageLoader.width } }
    Component { id: checkboxPage; CheckboxShowcase { width: pageLoader.width } }
    Component { id: radioPage; RadioShowcase { width: pageLoader.width } }
    Component { id: alertPage; AlertShowcase { width: pageLoader.width } }
    Component { id: breadcrumbPage; BreadcrumbShowcase { width: pageLoader.width } }
    Component { id: floatButtonPage; FloatButtonShowcase { width: pageLoader.width } }
    Component { id: iconPage; IconShowcase { width: pageLoader.width } }
    Component { id: listPage; ListShowcase { width: pageLoader.width } }
    Component { id: spinPage; SpinShowcase { width: pageLoader.width } }
    Component { id: emptyPage; EmptyShowcase { width: pageLoader.width } }
    Component { id: dataTablePage; DataTableShowcase { width: pageLoader.width } }
    Component { id: dividerPage; DividerShowcase { width: pageLoader.width } }
    Component { id: collapsePage; CollapseShowcase { width: pageLoader.width } }
    Component { id: tagPage; TagShowcase { width: pageLoader.width } }
    Component { id: cardPage; CardShowcase { width: pageLoader.width } }
    Component { id: menuPage; MenuShowcase { width: pageLoader.width } }
    Component { id: popupsPage; PopupShowcase { width: pageLoader.width } }
}
