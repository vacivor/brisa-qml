import QtQuick

Item {
    id: root
    width: 900
    implicitHeight: column.implicitHeight

    Theme { id: theme }

    property bool basicActive: false
    property bool iconActive: false
    property bool loadingActive: false
    property bool loadingState: false
    property string customValueState: "close"
    property string eventText: "No event yet"

    Column {
        id: column
        width: parent.width
        spacing: 20

        Text {
            text: "Switch"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Toggle switches aligned with Naive UI light."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Basic"

            Row {
                spacing: 16
                BrisaSwitch {
                    value: basicActive
                    onUpdateValue: function(v) { basicActive = v }
                }
                BrisaSwitch {
                    value: basicActive
                    disabled: true
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Size"

            Row {
                spacing: 16
                BrisaSwitch { size: "small" }
                BrisaSwitch { size: "medium" }
                BrisaSwitch { size: "large" }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Content"

            BrisaSwitch {
                checkedContent: checkedText
                uncheckedContent: uncheckedText
            }
        }

        BrisaCard {
            width: parent.width
            title: "Icon"

            Row {
                spacing: 16

                BrisaSwitch {
                    value: iconActive
                    onUpdateValue: function(v) { iconActive = v }
                    iconContent: thinkIcon
                }

                BrisaSwitch {
                    value: iconActive
                    size: "large"
                    onUpdateValue: function(v) { iconActive = v }
                    checkedIconContent: forwardIcon
                    uncheckedIconContent: backIcon
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Loading"

            Row {
                spacing: 16

                BrisaSwitch {
                    rubberBand: false
                    loading: true
                }

                BrisaSwitch {
                    rubberBand: false
                    value: loadingActive
                    loading: loadingState
                    onUpdateValue: function(v) {
                        loadingState = true
                        delayTimer.nextValue = v
                        delayTimer.restart()
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Shape"

            Row {
                spacing: 16
                BrisaSwitch { round: false }
                BrisaSwitch { }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Custom Rail Color"

            BrisaSwitch {
                railStyle: function(params) {
                    if (params.checked) {
                        return {
                            background: "#d03050"
                        }
                    }
                    return {
                        background: "#2080f0"
                    }
                }
                checkedContent: checkedWord
                uncheckedContent: uncheckedWord
            }
        }

        BrisaCard {
            width: parent.width
            title: "Custom Value"

            Row {
                spacing: 16

                BrisaSwitch {
                    value: customValueState
                    checkedValue: "open"
                    uncheckedValue: "close"
                    checkedContent: checkedWord
                    uncheckedContent: uncheckedWord
                    onUpdateValue: function(v) { customValueState = v }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "value: " + customValueState
                    color: theme.textColor2
                    font.pixelSize: 13
                    font.family: theme.fontFamily
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Event"

            Column {
                spacing: 12

                BrisaSwitch {
                    value: basicActive
                    onUpdateValue: function(v) {
                        basicActive = v
                        eventText = "update:value(" + v + ")"
                    }
                }

                Text {
                    text: eventText
                    color: theme.textColor3
                    font.pixelSize: 12
                    font.family: theme.fontFamily
                }
            }
        }
    }

    Timer {
        id: delayTimer
        interval: 1200
        repeat: false
        property bool nextValue: false
        onTriggered: {
            loadingActive = nextValue
            loadingState = false
        }
    }

    Component {
        id: checkedText
        Text {
            text: "Big wheels keep on turnin'"
            color: theme.switchTextColor
            font.pixelSize: 12
            font.family: theme.fontFamily
            font.weight: Font.DemiBold
        }
    }

    Component {
        id: uncheckedText
        Text {
            text: "Carry me home to see my kin"
            color: theme.switchTextColor
            font.pixelSize: 12
            font.family: theme.fontFamily
            font.weight: Font.DemiBold
        }
    }

    Component {
        id: checkedWord
        Text {
            text: "Checked"
            color: theme.switchTextColor
            font.pixelSize: 12
            font.family: theme.fontFamily
            font.weight: Font.DemiBold
        }
    }

    Component {
        id: uncheckedWord
        Text {
            text: "Unchecked"
            color: theme.switchTextColor
            font.pixelSize: 12
            font.family: theme.fontFamily
            font.weight: Font.DemiBold
        }
    }

    Component {
        id: thinkIcon
        BrisaIcon {
            size: 12
            color: theme.switchIconColor
            Text {
                property color iconColor: theme.switchIconColor
                text: "?"
                color: iconColor
                font.pixelSize: width
                font.family: theme.fontFamily
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Component {
        id: forwardIcon
        BrisaIcon {
            size: 13
            color: theme.switchIconColor
            Text {
                property color iconColor: theme.switchIconColor
                text: ">"
                color: iconColor
                font.pixelSize: width
                font.family: theme.fontFamily
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Component {
        id: backIcon
        BrisaIcon {
            size: 13
            color: theme.switchIconColor
            Text {
                property color iconColor: theme.switchIconColor
                text: "<"
                color: iconColor
                font.pixelSize: width
                font.family: theme.fontFamily
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
