import QtQuick

Item {
    id: root
    width: 900
    implicitHeight: column.implicitHeight

    Theme { id: theme }

    property var basicChecked: false
    property bool basicDisabled: true
    property var checkboxCities: []
    property bool indeterminateChecked: false
    property bool indeterminateState: false

    Column {
        id: column
        width: parent.width
        spacing: 20

        Text {
            text: "Checkbox"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Checkboxes aligned to Naive UI light."
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

                BrisaCheckbox {
                    label: "Checkbox"
                    checked: basicChecked
                    onUpdateChecked: function(v) { basicChecked = v }
                }

                BrisaCheckbox {
                    checked: basicChecked
                    onUpdateChecked: function(v) { basicChecked = v }
                }

                BrisaCheckbox {
                    label: "Checkbox"
                    checked: basicChecked
                    disabled: basicDisabled
                    onUpdateChecked: function(v) { basicChecked = v }
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

            BrisaCheckboxGroup {
                width: parent.width
                value: checkboxCities
                onUpdateValue: function(v) { checkboxCities = v }

                Flow {
                    width: parent.width
                    spacing: 16

                    BrisaCheckbox { value: "Beijing"; label: "Beijing" }
                    BrisaCheckbox { value: "Shanghai"; label: "Shanghai" }
                    BrisaCheckbox { value: "Guangzhou"; label: "Guangzhou" }
                    BrisaCheckbox { value: "Shenzhen"; label: "Shenzhen" }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Indeterminate"

            Flow {
                width: parent.width
                spacing: 16

                BrisaCheckbox {
                    label: "Checkbox"
                    checked: indeterminateChecked
                    indeterminate: indeterminateState
                    onUpdateChecked: function(v) { indeterminateChecked = v }
                }

                BrisaCheckbox {
                    checked: indeterminateChecked
                    indeterminate: indeterminateState
                    onUpdateChecked: function(v) { indeterminateChecked = v }
                }

                BrisaCheckbox {
                    checked: indeterminateChecked
                    indeterminate: indeterminateState
                    disabled: true
                }

                BrisaButton {
                    text: indeterminateChecked ? "Checked" : "Unchecked"
                    size: "small"
                    onClicked: indeterminateChecked = !indeterminateChecked
                }

                BrisaButton {
                    text: indeterminateState ? "Indeterminate" : "Not indeterminate"
                    size: "small"
                    onClicked: indeterminateState = !indeterminateState
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Size"

            Flow {
                width: parent.width
                spacing: 16

                BrisaCheckbox { size: "small"; label: "small" }
                BrisaCheckbox { size: "medium"; label: "medium" }
                BrisaCheckbox { size: "large"; label: "large" }
            }
        }
    }
}
