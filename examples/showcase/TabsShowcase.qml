import QtQuick
import QtQuick.Layouts

Item {
    id: root
    width: 900
    implicitHeight: column.implicitHeight

    Theme {
        id: theme
    }

    property var basicValue: "oasis"
    property var cardValue: "signin"
    property var cardClosableValue: 1
    property var cardClosablePanels: [1, 2, 3, 4, 5, 6]
    property var segmentValue: "track"
    property var sizeSmall: "alpha"
    property var sizeMedium: "alpha"
    property var sizeLarge: "alpha"
    property var disabledValue: "home"
    property string hoverValue: "daily"
    property string placementValue: "oasis"
    property string tabsPlacement: "left"
    property string tabsPlacementType: "card"

    Column {
        id: column
        width: parent.width
        spacing: 20

        function handleCardClose(name) {
            if (root.cardClosablePanels.length <= 1)
                return
            var removedIndex = -1
            var nextPanels = []
            for (var i = 0; i < root.cardClosablePanels.length; ++i) {
                if (root.cardClosablePanels[i] !== name)
                    nextPanels.push(root.cardClosablePanels[i])
                else
                    removedIndex = i
            }
            root.cardClosablePanels = nextPanels
            if (root.cardClosableValue === name) {
                var nextIndex = Math.min(nextPanels.length - 1, Math.max(0, removedIndex))
                root.cardClosableValue = nextPanels[Math.max(0, nextIndex)] || nextPanels[0]
            }
        }

        Text {
            text: "Tabs"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI inspired tabs with line, card and segment styles."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Basic"

            BrisaTabs {
                width: parent.width
                type: "line"
                animated: true
                value: root.basicValue
                onUpdateValue: function(v) { root.basicValue = v }

                BrisaTabPane {
                    name: "oasis"
                    tab: "Oasis"
                    Text {
                        text: "Wonderwall"
                        color: theme.textColor2
                        font.family: theme.fontFamily
                        font.pixelSize: 14
                    }
                }

                BrisaTabPane {
                    name: "beatles"
                    tab: "The Beatles"
                    Text {
                        text: "Hey Jude"
                        color: theme.textColor2
                        font.family: theme.fontFamily
                        font.pixelSize: 14
                    }
                }

                BrisaTabPane {
                    name: "jay"
                    tab: "Jay Chou"
                    Text {
                        text: "Qilixiang"
                        color: theme.textColor2
                        font.family: theme.fontFamily
                        font.pixelSize: 14
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Card"

            BrisaTabs {
                width: parent.width
                type: "card"
                size: "large"
                value: root.cardValue
                onUpdateValue: function(v) { root.cardValue = v }

                BrisaTabPane {
                    name: "signin"
                    tab: "Sign in"

                    Column {
                        width: parent.width
                        spacing: 12

                        BrisaInput {
                            width: parent.width
                            placeholder: "Username"
                        }
                        BrisaInput {
                            width: parent.width
                            type: "password"
                            placeholder: "Password"
                        }
                        BrisaButton {
                            text: "Sign In"
                            type: "primary"
                            secondary: true
                            strong: true
                            width: parent.width
                        }
                    }
                }

                BrisaTabPane {
                    name: "signup"
                    tab: "Sign up"

                    Column {
                        width: parent.width
                        spacing: 12

                        BrisaInput {
                            width: parent.width
                            placeholder: "Username"
                        }
                        BrisaInput {
                            width: parent.width
                            type: "password"
                            placeholder: "Password"
                        }
                        BrisaInput {
                            width: parent.width
                            type: "password"
                            placeholder: "Reenter Password"
                        }
                        BrisaButton {
                            text: "Create Account"
                            type: "primary"
                            secondary: true
                            strong: true
                            width: parent.width
                        }
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Closable Card"

            BrisaTabs {
                width: parent.width
                type: "card"
                closable: true
                value: root.cardClosableValue
                onUpdateValue: function(v) { root.cardClosableValue = v }
                onClose: function(name) { column.handleCardClose(name) }

                Repeater {
                    model: root.cardClosablePanels

                    delegate: BrisaTabPane {
                        required property var modelData
                        name: modelData
                        tab: String(modelData)

                        Text {
                            text: "Panel " + modelData
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                        }
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Segment"

            BrisaTabs {
                width: parent.width
                type: "segment"
                value: root.segmentValue
                onUpdateValue: function(v) { root.segmentValue = v }

                BrisaTabPane {
                    name: "track"
                    tab: "Track"
                    Text {
                        text: "Segment tabs share width and move with a capsule."
                        color: theme.textColor2
                        font.family: theme.fontFamily
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }
                }

                BrisaTabPane {
                    name: "mix"
                    tab: "Mix"
                    Text {
                        text: "Keep the interaction compact and slightly stronger."
                        color: theme.textColor2
                        font.family: theme.fontFamily
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }
                }

                BrisaTabPane {
                    name: "export"
                    tab: "Export"
                    Text {
                        text: "Useful for toggles that behave like segmented controls."
                        color: theme.textColor2
                        font.family: theme.fontFamily
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Size"

            Column {
                width: parent.width
                spacing: 16

                BrisaTabs {
                    width: parent.width
                    size: "small"
                    value: root.sizeSmall
                    onUpdateValue: function(v) { root.sizeSmall = v }

                    BrisaTabPane { name: "alpha"; tab: "Small"; Text { text: "Small tabs"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 } }
                    BrisaTabPane { name: "beta"; tab: "Archive"; Text { text: "Archive view"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 } }
                }

                BrisaTabs {
                    width: parent.width
                    size: "medium"
                    value: root.sizeMedium
                    onUpdateValue: function(v) { root.sizeMedium = v }

                    BrisaTabPane { name: "alpha"; tab: "Medium"; Text { text: "Medium tabs"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 } }
                    BrisaTabPane { name: "beta"; tab: "Archive"; Text { text: "Archive view"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 } }
                }

                BrisaTabs {
                    width: parent.width
                    size: "large"
                    value: root.sizeLarge
                    onUpdateValue: function(v) { root.sizeLarge = v }

                    BrisaTabPane { name: "alpha"; tab: "Large"; Text { text: "Large tabs"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 } }
                    BrisaTabPane { name: "beta"; tab: "Archive"; Text { text: "Archive view"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 } }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Disabled And Hover Trigger"

            Column {
                width: parent.width
                spacing: 16

                BrisaTabs {
                    width: parent.width
                    value: root.disabledValue
                    onUpdateValue: function(v) { root.disabledValue = v }

                    BrisaTabPane {
                        name: "home"
                        tab: "Home"
                        Text { text: "Enabled pane"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                    }

                    BrisaTabPane {
                        name: "archive"
                        tab: "Archive"
                        disabled: true
                        Text { text: "Disabled pane"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                    }

                    BrisaTabPane {
                        name: "shared"
                        tab: "Shared"
                        Text { text: "Another pane"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                    }
                }

                BrisaTabs {
                    width: parent.width
                    type: "bar"
                    trigger: "hover"
                    value: root.hoverValue
                    onUpdateValue: function(v) { root.hoverValue = v }

                    BrisaTabPane { name: "daily"; tab: "Daily"; Text { text: "Hover switches tabs here."; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 } }
                    BrisaTabPane { name: "weekly"; tab: "Weekly"; Text { text: "Hover another tab."; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 } }
                    BrisaTabPane { name: "monthly"; tab: "Monthly"; Text { text: "Bar style uses a cleaner nav line."; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 } }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Prefix And Suffix"

            BrisaTabs {
                width: parent.width
                value: "oasis"

                prefix: [
                    Text {
                        text: "Prefix"
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 13
                        font.weight: Font.Medium
                    }
                ]

                suffix: [
                    BrisaTag {
                        bordered: true
                        size: "small"
                        closable: false
                        text: "Suffix"
                    }
                ]

                BrisaTabPane {
                    name: "oasis"
                    tab: "Oasis"
                    Text { text: "Wonderwall"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                }
                BrisaTabPane {
                    name: "beatles"
                    tab: "The Beatles"
                    Text { text: "Hey Jude"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                }
                BrisaTabPane {
                    name: "jay"
                    tab: "Jay Chou"
                    Text { text: "Qilixiang"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Placement"

            Column {
                width: parent.width
                spacing: 16

                Row {
                    spacing: 8
                    BrisaButton { text: "Top"; secondary: root.tabsPlacement !== "top"; onClicked: root.tabsPlacement = "top" }
                    BrisaButton { text: "Bottom"; secondary: root.tabsPlacement !== "bottom"; onClicked: root.tabsPlacement = "bottom" }
                    BrisaButton { text: "Left"; secondary: root.tabsPlacement !== "left"; onClicked: root.tabsPlacement = "left" }
                    BrisaButton { text: "Right"; secondary: root.tabsPlacement !== "right"; onClicked: root.tabsPlacement = "right" }
                }

                Row {
                    spacing: 8
                    BrisaButton { text: "Card"; secondary: root.tabsPlacementType !== "card"; onClicked: root.tabsPlacementType = "card" }
                    BrisaButton { text: "Bar"; secondary: root.tabsPlacementType !== "bar"; onClicked: root.tabsPlacementType = "bar" }
                    BrisaButton { text: "Line"; secondary: root.tabsPlacementType !== "line"; onClicked: root.tabsPlacementType = "line" }
                }

                Item {
                    width: parent.width
                    height: root.tabsPlacement === "left" || root.tabsPlacement === "right" ? 260 : 180

                    BrisaTabs {
                        anchors.fill: parent
                        type: root.tabsPlacementType
                        placement: root.tabsPlacement
                        animated: true
                        value: root.placementValue
                        onUpdateValue: function(v) { root.placementValue = v }

                        BrisaTabPane {
                            name: "oasis"
                            tab: "Oasis"
                            Text { width: parent.width; wrapMode: Text.WordWrap; text: "Wonderwall"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                        }
                        BrisaTabPane {
                            name: "beatles"
                            tab: "The Beatles"
                            Text { width: parent.width; wrapMode: Text.WordWrap; text: "Hey Jude"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                        }
                        BrisaTabPane {
                            name: "jay"
                            tab: "Jay Chou"
                            Text { width: parent.width; wrapMode: Text.WordWrap; text: "Qilixiang"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                        }
                        BrisaTabPane {
                            name: "oasis-2"
                            tab: "Oasis 2"
                            Text { width: parent.width; wrapMode: Text.WordWrap; text: "Another track"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                        }
                    }
                }
            }
        }
    }
}
