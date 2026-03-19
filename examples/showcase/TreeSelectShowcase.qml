import QtQuick
import QtQuick.Layouts

Item {
    id: root
    width: 900
    implicitHeight: contentColumn.implicitHeight

    property var singleValue: "Drive My Car"
    property var multiValue: ["Norwegian Wood"]
    property var checkboxValue: ["Norwegian Wood"]
    property var lineValue: "Drive My Car"
    property var expandedKeys: ["Rubber Soul"]
    property var compactValue: ["Michelle", "Get Back", "Across The Universe"]
    property var disabledValue: "Across The Universe"
    property var nestedCheckboxValue: ["Dreams"]

    property var options: [
        {
            label: "Rubber Soul",
            key: "Rubber Soul",
            children: [
                { label: "Everybody's Got Something to Hide Except Me and My Monkey", key: "Monkey" },
                { label: "Drive My Car", key: "Drive My Car", disabled: true },
                { label: "Norwegian Wood", key: "Norwegian Wood" },
                { label: "You Won't See", key: "You Won't See", disabled: true },
                { label: "Nowhere Man", key: "Nowhere Man" },
                { label: "Michelle", key: "Michelle" }
            ]
        },
        {
            label: "Let It Be",
            key: "Let It Be Album",
            children: [
                { label: "Two Of Us", key: "Two Of Us" },
                { label: "Dig A Pony", key: "Dig A Pony" },
                { label: "Across The Universe", key: "Across The Universe" },
                { label: "Let It Be", key: "Let It Be" },
                { label: "Get Back", key: "Get Back" }
            ]
        }
    ]
    property var emptyOptions: []
    property var nestedOptions: [
        {
            label: "Abbey Road",
            key: "Abbey Road",
            children: [
                {
                    label: "Side A",
                    key: "Side A",
                    children: [
                        { label: "Come Together", key: "Come Together" },
                        { label: "Something", key: "Something" },
                        { label: "Maxwell's Silver Hammer", key: "Maxwell's Silver Hammer", disabled: true }
                    ]
                },
                {
                    label: "Side B",
                    key: "Side B",
                    children: [
                        { label: "Here Comes The Sun", key: "Here Comes The Sun" },
                        { label: "Because", key: "Because" },
                        { label: "Golden Slumbers", key: "Golden Slumbers" }
                    ]
                }
            ]
        },
        {
            label: "Fleetwood Mac",
            key: "Fleetwood Mac",
            children: [
                {
                    label: "Rumours",
                    key: "Rumours",
                    children: [
                        { label: "Dreams", key: "Dreams" },
                        { label: "Go Your Own Way", key: "Go Your Own Way" },
                        { label: "The Chain", key: "The Chain" }
                    ]
                }
            ]
        }
    ]

    Theme { id: theme }

    Column {
        id: contentColumn
        width: parent.width
        spacing: 20

        Text {
            text: "Tree Select"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI style tree select with single, multiple, checkbox and filterable modes."
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

                Column {
                    width: parent.width
                    spacing: 10

                    BrisaTreeSelect {
                        width: parent.width
                        options: root.options
                        value: root.singleValue
                        clearable: true
                        defaultExpandedKeys: ["Rubber Soul"]
                        onUpdateValue: function(value) { root.singleValue = value }
                    }

                    Text {
                        text: "Value: " + String(root.singleValue)
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 12
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Multiple"

                Column {
                    width: parent.width
                    spacing: 10

                    BrisaTreeSelect {
                        width: parent.width
                        options: root.options
                        multiple: true
                        clearable: true
                        value: root.multiValue
                        onUpdateValue: function(value) { root.multiValue = value }
                    }

                    Text {
                        text: "Selected: " + root.multiValue.join(", ")
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 12
                        wrapMode: Text.Wrap
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Checkbox"

                Column {
                    width: parent.width
                    spacing: 10

                    BrisaTreeSelect {
                        width: parent.width
                        options: root.options
                        multiple: true
                        cascade: true
                        checkable: true
                        clearable: true
                        value: root.checkboxValue
                        onUpdateValue: function(value) { root.checkboxValue = value }
                    }

                    Text {
                        text: "Cascade: " + root.checkboxValue.join(", ")
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 12
                        wrapMode: Text.Wrap
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Three Level Checkbox"

                Column {
                    width: parent.width
                    spacing: 10

                    BrisaTreeSelect {
                        width: parent.width
                        options: root.nestedOptions
                        multiple: true
                        cascade: true
                        checkable: true
                        clearable: true
                        showLine: true
                        defaultExpandedKeys: ["Abbey Road", "Side A", "Fleetwood Mac", "Rumours"]
                        value: root.nestedCheckboxValue
                        onUpdateValue: function(value) { root.nestedCheckboxValue = value }
                    }

                    Text {
                        text: "Cascade: " + root.nestedCheckboxValue.join(", ")
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 12
                        wrapMode: Text.Wrap
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Filterable"

                BrisaTreeSelect {
                    width: parent.width
                    options: root.options
                    filterable: true
                    clearable: true
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Show Line"

                Column {
                    width: parent.width
                    spacing: 10

                    BrisaTreeSelect {
                        width: parent.width
                        options: root.options
                        showLine: true
                        defaultExpandAll: true
                        value: root.lineValue
                        onUpdateValue: function(value) { root.lineValue = value }
                    }

                    Text {
                        text: "Selected: " + String(root.lineValue)
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 12
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Controlled Expanded"

                Column {
                    width: parent.width
                    spacing: 10

                    BrisaTreeSelect {
                        width: parent.width
                        options: root.options
                        filterable: true
                        expandedKeys: root.expandedKeys
                        defaultValue: "Michelle"
                        onUpdateExpandedKeys: function(keys) { root.expandedKeys = keys }
                    }

                    Text {
                        text: "Expanded: " + root.expandedKeys.join(", ")
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 12
                        wrapMode: Text.Wrap
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Dense Tags"

                Column {
                    width: parent.width
                    spacing: 10

                    BrisaTreeSelect {
                        width: parent.width
                        options: root.options
                        multiple: true
                        clearable: true
                        value: root.compactValue
                        onUpdateValue: function(value) { root.compactValue = value }
                    }

                    Text {
                        text: "Wrap stress case"
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 12
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Disabled"

                BrisaTreeSelect {
                    width: parent.width
                    options: root.options
                    disabled: true
                    clearable: true
                    value: root.disabledValue
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Empty"

                BrisaTreeSelect {
                    width: parent.width
                    options: root.emptyOptions
                    filterable: true
                    emptyText: "No matching nodes"
                }
            }
        }
    }
}
