import QtQuick

Item {
    id: root
    width: 900
    implicitHeight: column.implicitHeight

    Theme { id: theme }

    property string leftName: ""
    property string leftAge: ""
    property string leftCity: ""
    property string topName: ""
    property string topEmail: ""
    property string topCity: ""
    property var topAmount: 120
    property bool topAgree: false
    property bool topEnabled: false
    property string topChannel: ""
    property string inlineName: ""
    property string inlineAge: ""
    property string inlinePhone: ""
    property bool formShowLabel: true
    property bool itemShowLabel: true
    property string itemOnlyValue: "It is not in a Form"

    Column {
        id: column
        width: parent.width
        spacing: 20

        Text {
            text: "Form"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Form layout and grouped sections aligned with Naive UI light."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Label Placement Left"

            Column {
                width: parent.width
                spacing: 12

                BrisaForm {
                    width: Math.min(parent.width, 640)
                    labelPlacement: "left"
                    labelWidth: "auto"
                    requireMarkPlacement: "right-hanging"
                    size: "medium"

                    BrisaFormItem {
                        label: "Name"
                        required: true
                        feedback: leftName.length === 0 ? "Please input your name" : ""
                        status: leftName.length === 0 ? "error" : "default"
                        BrisaInput {
                            text: leftName
                            placeholder: "Input Name"
                            onTextChanged: leftName = text
                        }
                    }

                    BrisaFormItem {
                        label: "Age"
                        BrisaInput {
                            text: leftAge
                            placeholder: "Input Age"
                            onTextChanged: leftAge = text
                        }
                    }

                    BrisaFormItem {
                        label: "City"
                        BrisaSelect {
                            value: leftCity
                            placeholder: "Select"
                            options: [
                                { label: "Beijing", value: "Beijing" },
                                { label: "Shanghai", value: "Shanghai" },
                                { label: "Guangzhou", value: "Guangzhou" }
                            ]
                            onUpdateValue: function(v) { leftCity = v }
                        }
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Label Placement Top"

            BrisaForm {
                width: parent.width
                labelPlacement: "top"
                size: "medium"

                BrisaFormGroup {
                    width: parent.width
                    title: "Account"
                    description: "Grouped fields with top labels."

                    BrisaFormItem {
                        label: "Name"
                        required: true
                        feedback: topName.length === 0 ? "Please input your name" : ""
                        status: topName.length === 0 ? "error" : "default"
                        BrisaInput {
                            text: topName
                            placeholder: "Input Name"
                            onTextChanged: topName = text
                        }
                    }

                    BrisaFormItem {
                        label: "Email"
                        feedback: "We only use this for updates."
                        status: "warning"
                        BrisaInput {
                            text: topEmail
                            placeholder: "name@email.com"
                            onTextChanged: topEmail = text
                        }
                    }

                    BrisaFormItem {
                        label: "City"
                        BrisaSelect {
                            value: topCity
                            placeholder: "Select City"
                            options: [
                                { label: "Beijing", value: "Beijing" },
                                { label: "Shanghai", value: "Shanghai" },
                                { label: "Shenzhen", value: "Shenzhen" }
                            ]
                            onUpdateValue: function(v) { topCity = v }
                        }
                    }

                    BrisaFormItem {
                        label: "Budget"
                        BrisaInputNumber {
                            value: topAmount
                            onUpdateValue: function(v) { topAmount = v }
                        }
                    }

                    BrisaFormItem {
                        label: "Switch"
                        BrisaSwitch {
                            value: topEnabled
                            onUpdateValue: function(v) { topEnabled = v }
                        }
                    }

                    BrisaFormItem {
                        label: "Channel"
                        BrisaRadioGroup {
                            width: parent.width
                            value: topChannel
                            onUpdateValue: function(v) { topChannel = v }

                            Flow {
                                width: parent.width
                                spacing: 16

                                BrisaRadio { value: "Email"; label: "Email" }
                                BrisaRadio { value: "Phone"; label: "Phone" }
                                BrisaRadio { value: "Message"; label: "Message" }
                            }
                        }
                    }

                    BrisaFormItem {
                        label: "Agreement"
                        BrisaCheckbox {
                            label: "I agree to the update policy"
                            checked: topAgree
                            onUpdateChecked: function(v) { topAgree = v }
                        }
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Inline"

            BrisaForm {
                width: parent.width
                inline: true
                labelPlacement: "left"
                labelWidth: 80
                size: "medium"

                BrisaFormItem {
                    label: "Name"
                    BrisaInput {
                        width: 180
                        text: inlineName
                        placeholder: "Input Name"
                        onTextChanged: inlineName = text
                    }
                }

                BrisaFormItem {
                    label: "Age"
                    BrisaInput {
                        width: 140
                        text: inlineAge
                        placeholder: "Input Age"
                        onTextChanged: inlineAge = text
                    }
                }

                BrisaFormItem {
                    label: "Phone"
                    BrisaInput {
                        width: 180
                        text: inlinePhone
                        placeholder: "Phone Number"
                        onTextChanged: inlinePhone = text
                    }
                }

                BrisaFormItem {
                    showLabel: false
                    BrisaButton {
                        text: "Validate"
                        type: "primary"
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Show / Hide Label"

            Column {
                width: parent.width
                spacing: 12

                Row {
                    spacing: 16

                    BrisaCheckbox {
                        label: "Form Label"
                        checked: formShowLabel
                        onUpdateChecked: function(v) { formShowLabel = v }
                    }

                    BrisaCheckbox {
                        label: "Item Label"
                        checked: itemShowLabel
                        onUpdateChecked: function(v) { itemShowLabel = v }
                    }
                }

                BrisaForm {
                    width: Math.min(parent.width, 560)
                    showLabel: formShowLabel
                    labelPlacement: "left"
                    labelWidth: 90

                    BrisaFormItem {
                        label: "Name"
                        showLabel: itemShowLabel
                        BrisaInput { placeholder: "Input Name" }
                    }

                    BrisaFormItem {
                        label: "Age"
                        BrisaInput { placeholder: "Input Age" }
                    }

                    BrisaFormItem {
                        label: "Phone"
                        BrisaInput { placeholder: "Input Phone" }
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Form Item Only"

            BrisaFormItem {
                width: Math.min(parent.width, 560)
                labelPlacement: "left"
                labelWidth: 120
                label: "This is a FormItem"
                feedback: itemOnlyValue === "It is not in a Form" ? "" : "It is not in a Form"
                status: itemOnlyValue === "It is not in a Form" ? "default" : "error"

                BrisaInput {
                    text: itemOnlyValue
                    onTextChanged: itemOnlyValue = text
                }
            }
        }
    }
}
