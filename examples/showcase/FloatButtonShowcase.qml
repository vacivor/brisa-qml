import QtQuick
import QtQuick.Layouts
import QtQuick.Window

Item {
    id: root
    width: 900
    implicitHeight: contentColumn.implicitHeight

    property bool clickMenuOpen: false
    property bool pageMenuOpen: false

    Theme { id: theme }

    Column {
        id: contentColumn
        width: parent.width
        spacing: 20

        Text {
            text: "Float Button"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI style floating action button with description, menu, tooltip and grouped variants."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        GridLayout {
            width: parent.width
            columns: width > 760 ? 2 : 1
            columnSpacing: 16
            rowSpacing: 16

            BrisaCard {
                Layout.fillWidth: true
                title: "Basic"

                Item {
                    width: parent.width
                    height: 180

                    BrisaFloatButton {
                        id: basicTopLeft
                        leftInset: 0
                        topInset: 0
                        Text { text: "$"; color: basicTopLeft.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 18; font.weight: Font.DemiBold }
                    }

                    BrisaFloatButton {
                        id: basicTopRight
                        rightInset: 0
                        topInset: 0
                        type: "primary"
                        Text { text: "$"; color: basicTopRight.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 18; font.weight: Font.DemiBold }
                    }

                    BrisaFloatButton {
                        id: basicBottomLeft
                        leftInset: 0
                        bottomInset: 0
                        shape: "square"
                        Text { text: "\u25A3"; color: basicBottomLeft.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 17; font.weight: Font.DemiBold }
                    }

                    BrisaFloatButton {
                        id: basicBottomRight
                        rightInset: 0
                        bottomInset: 0
                        shape: "square"
                        type: "primary"
                        Text { text: "\u25A3"; color: basicBottomRight.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 17; font.weight: Font.DemiBold }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Description"

                Item {
                    width: parent.width
                    height: 120

                    BrisaFloatButton {
                        id: descButtonOne
                        shape: "square"
                        leftInset: 0
                        topInset: 0
                        Text { text: "\u25A3"; color: descButtonOne.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 17; font.weight: Font.DemiBold }
                        description: [
                            Text {
                                text: "Docs"
                                color: descButtonOne.resolvedTextColor
                                font.family: theme.fontFamily
                                font.pixelSize: 12
                            }
                        ]
                    }

                    BrisaFloatButton {
                        id: descButtonTwo
                        shape: "square"
                        leftInset: 64
                        topInset: 0
                        description: [
                            Text {
                                text: "Docs"
                                color: descButtonTwo.resolvedTextColor
                                font.family: theme.fontFamily
                                font.pixelSize: 12
                            }
                        ]
                    }

                    BrisaFloatButton {
                        id: descButtonThree
                        shape: "square"
                        leftInset: 128
                        topInset: 0
                        width: 76
                        Text { text: "\u25A3"; color: descButtonThree.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 17; font.weight: Font.DemiBold }
                        description: [
                            Text {
                                text: "Long Docs"
                                color: descButtonThree.resolvedTextColor
                                font.family: theme.fontFamily
                                font.pixelSize: 12
                            }
                        ]
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Tooltip"

                Item {
                    width: parent.width
                    height: 88

                    BrisaFloatButton {
                        id: tooltipButton
                        position: "relative"
                        topInset: 0
                        leftInset: 0
                        Text { text: "$"; color: tooltipButton.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 18; font.weight: Font.DemiBold }
                    }

                    BrisaTooltip {
                        target: tooltipButton
                        open: tooltipHover.hovered
                        placement: "right"
                        text: "Financial shortcuts"
                    }

                    HoverHandler {
                        id: tooltipHover
                        target: tooltipButton
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Menu"

                Row {
                    spacing: 32

                    BrisaFloatButton {
                        id: hoverMenuButton
                        type: "primary"
                        position: "relative"
                        menuTrigger: "hover"
                        Image { width: 16; height: 16; source: theme.svgPlus(hoverMenuButton.resolvedTextColor, 16); fillMode: Image.PreserveAspectFit; smooth: true }

                        menu: [
                            BrisaFloatButton { id: hoverMenuItemOne; shape: "square"; type: "primary"; Text { text: "\u25A3"; color: hoverMenuItemOne.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 17; font.weight: Font.DemiBold } },
                            BrisaFloatButton { id: hoverMenuItemTwo; Text { text: "$"; color: hoverMenuItemTwo.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 18; font.weight: Font.DemiBold } },
                            BrisaFloatButton { id: hoverMenuItemThree; Text { text: "\u25A3"; color: hoverMenuItemThree.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 17; font.weight: Font.DemiBold } }
                        ]
                    }

                    BrisaFloatButton {
                        id: clickMenuButton
                        type: "primary"
                        position: "relative"
                        menuTrigger: "click"
                        showMenu: root.clickMenuOpen
                        onUpdateShowMenu: function(value) { root.clickMenuOpen = value }
                        Image { width: 16; height: 16; source: theme.svgPlus(clickMenuButton.resolvedTextColor, 16); fillMode: Image.PreserveAspectFit; smooth: true }

                        menu: [
                            BrisaFloatButton { id: clickMenuItemOne; shape: "square"; type: "primary"; Text { text: "\u25A3"; color: clickMenuItemOne.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 17; font.weight: Font.DemiBold } },
                            BrisaFloatButton { id: clickMenuItemTwo; Text { text: "$"; color: clickMenuItemTwo.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 18; font.weight: Font.DemiBold } },
                            BrisaFloatButton { id: clickMenuItemThree; Text { text: "\u25A3"; color: clickMenuItemThree.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 17; font.weight: Font.DemiBold } }
                        ]
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Group"

                Row {
                    spacing: 24

                    BrisaFloatButtonGroup {
                        position: "relative"
                        shape: "square"

                        BrisaFloatButton { id: squareGroupOne; Text { text: "$"; color: squareGroupOne.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 18; font.weight: Font.DemiBold } }
                        BrisaFloatButton { id: squareGroupTwo; Text { text: "\u25A3"; color: squareGroupTwo.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 17; font.weight: Font.DemiBold } }
                        BrisaFloatButton { id: squareGroupThree; Image { width: 16; height: 16; source: theme.svgPlus(squareGroupThree.resolvedTextColor, 16); fillMode: Image.PreserveAspectFit; smooth: true } }
                        BrisaFloatButton { id: squareGroupFour; Text { text: "$"; color: squareGroupFour.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 18; font.weight: Font.DemiBold } }
                    }

                    BrisaFloatButtonGroup {
                        position: "relative"
                        shape: "circle"

                        BrisaFloatButton { id: circleGroupOne; Text { text: "$"; color: circleGroupOne.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 18; font.weight: Font.DemiBold } }
                        BrisaFloatButton { id: circleGroupTwo; Text { text: "\u25A3"; color: circleGroupTwo.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 17; font.weight: Font.DemiBold } }
                        BrisaFloatButton { id: circleGroupThree; Image { width: 16; height: 16; source: theme.svgPlus(circleGroupThree.resolvedTextColor, 16); fillMode: Image.PreserveAspectFit; smooth: true } }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Type"

                Row {
                    spacing: 16

                    BrisaFloatButton {
                        id: typeButtonOne
                        position: "relative"
                        Text { text: "$"; color: typeButtonOne.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 18; font.weight: Font.DemiBold }
                    }

                    BrisaFloatButton {
                        id: typeButtonTwo
                        position: "relative"
                        type: "primary"
                        Text { text: "$"; color: typeButtonTwo.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 18; font.weight: Font.DemiBold }
                    }

                    BrisaFloatButton {
                        id: typeButtonThree
                        position: "relative"
                        shape: "square"
                        Text { text: "\u25A3"; color: typeButtonThree.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 17; font.weight: Font.DemiBold }
                    }

                    BrisaFloatButton {
                        id: typeButtonFour
                        position: "relative"
                        type: "primary"
                        shape: "square"
                        Text { text: "\u25A3"; color: typeButtonFour.resolvedTextColor; font.family: theme.fontFamily; font.pixelSize: 17; font.weight: Font.DemiBold }
                    }
                }
            }
        }
    }

    BrisaFloatButtonGroup {
        id: pageFloatGroup
        parent: root.Window.window ? root.Window.window.contentItem : root
        x: parent === root
            ? root.width - width - 18
            : root.mapToItem(parent, 0, 0).x + root.width - width - 18
        y: parent === root
            ? Math.max(24, root.implicitHeight - height - 18)
            : parent.height - height - 28
        shape: "circle"
        z: 3020

        BrisaFloatButton {
            id: pageFloatInfo
            Text {
                text: "$"
                color: pageFloatInfo.resolvedTextColor
                font.family: theme.fontFamily
                font.pixelSize: 18
                font.weight: Font.DemiBold
            }
        }

        BrisaFloatButton {
            id: pageFloatMenu
            type: "primary"
            menuTrigger: "click"
            showMenu: root.pageMenuOpen
            onUpdateShowMenu: function(value) { root.pageMenuOpen = value }

            Image {
                width: 16
                height: 16
                source: theme.svgPlus(pageFloatMenu.resolvedTextColor, 16)
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            menu: [
                BrisaFloatButton {
                    id: pageMenuItemOne
                    shape: "square"
                    type: "primary"
                    Text {
                        text: "\u25A3"
                        color: pageMenuItemOne.resolvedTextColor
                        font.family: theme.fontFamily
                        font.pixelSize: 17
                        font.weight: Font.DemiBold
                    }
                },
                BrisaFloatButton {
                    id: pageMenuItemTwo
                    Text {
                        text: "$"
                        color: pageMenuItemTwo.resolvedTextColor
                        font.family: theme.fontFamily
                        font.pixelSize: 18
                        font.weight: Font.DemiBold
                    }
                }
            ]
        }
    }
}
