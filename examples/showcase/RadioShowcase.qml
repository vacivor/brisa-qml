import QtQuick

Item {
    id: root
    width: 900
    implicitHeight: column.implicitHeight

    Theme { id: theme }

    property string basicValue: ""
    property bool basicDisabled: true
    property string groupValue: ""
    property string sizeValueSmall: ""
    property string sizeValueMedium: ""
    property string sizeValueLarge: ""

    property var songs: [
        { value: "rock'n'roll star", label: "Rock'n'Roll Star" },
        { value: "shakermaker", label: "Shakermaker" },
        { value: "live forever", label: "Live Forever" },
        { value: "up in the sky", label: "Up in the Sky" },
        { value: "...", label: "..." }
    ]

    Column {
        id: column
        width: parent.width
        spacing: 20

        Text {
            text: "Radio"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Radios aligned to Naive UI light."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Basic"

            Flow {
                width: parent.width
                spacing: 16

                BrisaRadio {
                    value: "Definitely Maybe"
                    label: "Definitely Maybe"
                    checked: basicValue === value
                    name: "basic-demo"
                    onClicked: function(v) { basicValue = v }
                }

                BrisaRadio {
                    value: "Be Here Now"
                    label: "Be Here Now"
                    checked: basicValue === value
                    name: "basic-demo"
                    onClicked: function(v) { basicValue = v }
                }

                BrisaRadio {
                    value: "Be Here Now Disabled"
                    label: "Be Here Now"
                    checked: basicValue === value
                    disabled: basicDisabled
                    name: "basic-demo"
                    onClicked: function(v) { basicValue = v }
                }

                BrisaButton {
                    text: "Disabled"
                    size: "small"
                    onClicked: basicDisabled = !basicDisabled
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Group"

            BrisaRadioGroup {
                width: parent.width
                name: "radiogroup"
                value: groupValue
                onUpdateValue: function(v) { groupValue = v }

                Flow {
                    width: parent.width
                    spacing: 16

                    Repeater {
                        model: songs

                        BrisaRadio {
                            value: modelData.value
                            label: modelData.label
                        }
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

                BrisaRadioGroup {
                    width: parent.width
                    name: "radio-small"
                    size: "small"
                    value: sizeValueSmall
                    onUpdateValue: function(v) { sizeValueSmall = v }

                    Flow {
                        width: parent.width
                        spacing: 16

                        BrisaRadio { value: "small-a"; label: "small" }
                        BrisaRadio { value: "small-b"; label: "small disabled"; disabled: true }
                    }
                }

                BrisaRadioGroup {
                    width: parent.width
                    name: "radio-medium"
                    size: "medium"
                    value: sizeValueMedium
                    onUpdateValue: function(v) { sizeValueMedium = v }

                    Flow {
                        width: parent.width
                        spacing: 16

                        BrisaRadio { value: "medium-a"; label: "medium" }
                        BrisaRadio { value: "medium-b"; label: "medium disabled"; disabled: true }
                    }
                }

                BrisaRadioGroup {
                    width: parent.width
                    name: "radio-large"
                    size: "large"
                    value: sizeValueLarge
                    onUpdateValue: function(v) { sizeValueLarge = v }

                    Flow {
                        width: parent.width
                        spacing: 16

                        BrisaRadio { value: "large-a"; label: "large" }
                        BrisaRadio { value: "large-b"; label: "large disabled"; disabled: true }
                    }
                }
            }
        }
    }
}
