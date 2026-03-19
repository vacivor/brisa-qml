import QtQuick

Item {
    id: root
    width: 900
    implicitHeight: contentColumn.implicitHeight
    height: implicitHeight

    property var selectedKeys: ["Michelle"]
    property var multiSelectedKeys: ["Norwegian Wood", "Across The Universe"]
    property var checkedKeys: ["Norwegian Wood"]
    property bool showLine: true
    property string pattern: ""
    property var threeLevelCheckedKeys: ["Dreams"]
    property var strategyCheckedKeys: ["Dreams"]
    property string checkStrategy: "all"

    property var nodes: [
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

    property var nestedNodes: [
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
        width: root.width
        spacing: 20

        Text {
            text: "Tree"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI style tree with selection, checkbox, filter and connection lines."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: contentColumn.width
            title: "Basic"

            Column {
                width: parent.width
                spacing: 10

                BrisaTree {
                    width: parent.width
                    nodes: root.nodes
                    blockLine: true
                    expandOnClick: true
                    selectedKeys: root.selectedKeys
                    defaultExpandedKeys: ["Rubber Soul"]
                    onUpdateSelectedKeys: function(keys) { root.selectedKeys = keys }
                }

                Text {
                    text: "Selected: " + root.selectedKeys.join(", ")
                    color: theme.textColor3
                    font.family: theme.fontFamily
                    font.pixelSize: 12
                }
            }
        }

        BrisaCard {
            width: contentColumn.width
            title: "Multiple"

            Column {
                width: parent.width
                spacing: 10

                BrisaTree {
                    width: parent.width
                    nodes: root.nodes
                    blockLine: true
                    multiple: true
                    selectedKeys: root.multiSelectedKeys
                    defaultExpandedKeys: ["Rubber Soul", "Let It Be Album"]
                    onUpdateSelectedKeys: function(keys) { root.multiSelectedKeys = keys }
                }

                Text {
                    text: "Selected: " + root.multiSelectedKeys.join(", ")
                    color: theme.textColor3
                    font.family: theme.fontFamily
                    font.pixelSize: 12
                    wrapMode: Text.Wrap
                }
            }
        }

        BrisaCard {
            width: contentColumn.width
            title: "Checkable"

            Column {
                width: parent.width
                spacing: 10

                BrisaTree {
                    width: parent.width
                    nodes: root.nodes
                    blockLine: true
                    checkable: true
                    cascade: true
                    expandOnClick: true
                    checkedKeys: root.checkedKeys
                    defaultExpandedKeys: ["Rubber Soul"]
                    onUpdateCheckedKeys: function(keys) { root.checkedKeys = keys }
                }

                Text {
                    text: "Checked: " + root.checkedKeys.join(", ")
                    color: theme.textColor3
                    font.family: theme.fontFamily
                    font.pixelSize: 12
                    wrapMode: Text.Wrap
                }
            }
        }

        BrisaCard {
            width: contentColumn.width
            title: "Show Line"

            Column {
                width: parent.width
                spacing: 10

                BrisaSwitch {
                    value: root.showLine
                    onUpdateValue: function(value) { root.showLine = value }
                }

                BrisaTree {
                    width: parent.width
                    nodes: root.nodes
                    showLine: root.showLine
                    blockLine: true
                    expandOnClick: true
                    defaultExpandedKeys: ["Rubber Soul", "Let It Be Album"]
                }
            }
        }

        BrisaCard {
            width: contentColumn.width
            title: "Three Level"

            Column {
                width: parent.width
                spacing: 10

                BrisaTree {
                    width: parent.width
                    nodes: root.nestedNodes
                    blockLine: true
                    checkable: true
                    cascade: true
                    showLine: true
                    checkedKeys: root.threeLevelCheckedKeys
                    defaultExpandedKeys: ["Abbey Road", "Side A", "Fleetwood Mac", "Rumours"]
                    onUpdateCheckedKeys: function(keys) { root.threeLevelCheckedKeys = keys }
                }

                Text {
                    text: "Checked: " + root.threeLevelCheckedKeys.join(", ")
                    color: theme.textColor3
                    font.family: theme.fontFamily
                    font.pixelSize: 12
                    wrapMode: Text.Wrap
                }
            }
        }

        BrisaCard {
            width: contentColumn.width
            title: "Check Strategy"

            Column {
                width: parent.width
                spacing: 10

                Row {
                    spacing: 8

                    Repeater {
                        model: ["all", "parent", "child"]

                        delegate: BrisaButton {
                            text: modelData
                            size: "small"
                            type: root.checkStrategy === modelData ? "primary" : "default"
                            onClicked: root.checkStrategy = modelData
                        }
                    }
                }

                BrisaTree {
                    width: parent.width
                    nodes: root.nestedNodes
                    blockLine: true
                    checkable: true
                    cascade: true
                    showLine: true
                    checkStrategy: root.checkStrategy
                    checkedKeys: root.strategyCheckedKeys
                    defaultExpandedKeys: ["Abbey Road", "Side A", "Fleetwood Mac", "Rumours"]
                    onUpdateCheckedKeys: function(keys) { root.strategyCheckedKeys = keys }
                }

                Text {
                    text: "Strategy: " + root.checkStrategy + " | Checked: " + root.strategyCheckedKeys.join(", ")
                    color: theme.textColor3
                    font.family: theme.fontFamily
                    font.pixelSize: 12
                    wrapMode: Text.Wrap
                }
            }
        }

        BrisaCard {
            width: contentColumn.width
            title: "Filter"

            Column {
                width: parent.width
                spacing: 10

                BrisaInput {
                    width: parent.width
                    text: root.pattern
                    placeholder: "Search songs"
                    clearable: true
                    externalTextBinding: true
                    onInputEvent: function(value) { root.pattern = value }
                }

                BrisaTree {
                    width: parent.width
                    nodes: root.nodes
                    pattern: root.pattern
                    blockLine: true
                    showLine: true
                    expandOnClick: true
                    defaultExpandedKeys: ["Rubber Soul", "Let It Be Album"]
                }
            }
        }

        BrisaCard {
            width: contentColumn.width
            title: "Disabled"

            BrisaTree {
                width: parent.width
                nodes: root.nodes
                disabled: true
                blockLine: true
                defaultExpandedKeys: ["Rubber Soul"]
                selectedKeys: root.selectedKeys
            }
        }
    }
}
