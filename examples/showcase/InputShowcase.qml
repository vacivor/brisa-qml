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
            text: "Inputs"
            color: theme.textColor1
            font.family: "Space Grotesk"
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Input, input number, select, and form aligned with naive-ui light."
            color: theme.textColor3
            font.family: "Space Grotesk"
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Input"
            Column {
                spacing: 12
                BrisaInput { placeholder: "Basic Input" }
                BrisaInput { type: "textarea"; placeholder: "Basic Textarea"; autosize: true }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Sizes"
            Column {
                spacing: 12
                BrisaInput { size: "tiny"; placeholder: "Tiny Input" }
                BrisaInput { size: "small"; placeholder: "Small Input" }
                BrisaInput { placeholder: "Medium Input" }
                BrisaInput { size: "large"; placeholder: "Large Input" }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Round"
            Column {
                spacing: 12
                BrisaInput { size: "small"; round: true; placeholder: "Small" }
                BrisaInput { round: true; placeholder: "Medium" }
                BrisaInput { size: "large"; round: true; placeholder: "Large" }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Prefix / Suffix"
            Column {
                spacing: 12
                BrisaInput {
                    placeholder: "Flash"
                    prefix: [
                        Text { text: "⚡"; color: theme.textColor3; anchors.verticalCenter: parent.verticalCenter }
                    ]
                }
                BrisaInput {
                    round: true
                    placeholder: "1,400,000"
                    suffix: [
                        Text { text: "$"; color: theme.textColor3; anchors.verticalCenter: parent.verticalCenter }
                    ]
                }
                BrisaInput {
                    round: true
                    placeholder: "Flash"
                    suffix: [
                        Text { text: "⚡"; color: theme.textColor3; anchors.verticalCenter: parent.verticalCenter }
                    ]
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Loading"
            Column {
                spacing: 12
                BrisaInput { placeholder: "Basic Input"; loading: true }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Password"
            Column {
                spacing: 12
                BrisaInput { type: "password"; placeholder: "Password"; maxLength: 8 }
                BrisaInput { type: "password"; placeholder: "Custom Password Toggle Icon"; maxLength: 8 }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Disabled / Pair"
            Column {
                spacing: 12
                BrisaInput { size: "small"; round: true; placeholder: "Oops! It is disabled."; disabled: true }
                BrisaInput { type: "textarea"; size: "small"; round: true; placeholder: "Oops! It is disabled."; disabled: true }
                BrisaInput { pair: true; separator: "to"; clearable: true; disabled: true }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Clearable"
            Column {
                spacing: 12
                BrisaInput { placeholder: "Content is clearable"; clearable: true }
                BrisaInput { type: "password"; placeholder: "Content is clearable"; clearable: true }
                BrisaInput { type: "textarea"; placeholder: "Content is clearable"; round: true; clearable: true; autosize: true }
                BrisaInput { placeholder: "Custom clear icon"; round: true; clearable: true
                    clearIcon: [
                        Text { text: "🗑"; anchors.centerIn: parent }
                    ]
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Autosize"
            Column {
                spacing: 12
                BrisaInput { placeholder: "Autosizable"; autosize: true }
                BrisaInput { type: "textarea"; size: "small"; placeholder: "Autosizable"; autosize: ({ minRows: 3, maxRows: 5 }) }
                BrisaInput { type: "textarea"; placeholder: "Autosizable"; autosize: ({ minRows: 3 }) }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Resize"
            Column {
                spacing: 12

                BrisaInput {
                    width: 320
                    type: "textarea"
                    resize: "vertical"
                    autosize: false
                    text: "Vertical resize keeps width fixed and lets the unified lower-right handle adjust height."
                }

                BrisaInput {
                    width: 320
                    type: "textarea"
                    resize: "both"
                    autosize: false
                    text: "Both resize uses the same lower-right handle and updates width plus height together."
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Pair"
            Column {
                spacing: 12
                BrisaInput { pair: true; separator: "-"; clearable: true; placeholderPair: ["From", "To"] }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Input Group"
            Column {
                spacing: 12
                BrisaInputGroup {
                    BrisaInput { width: 200 }
                    BrisaInputNumber { width: 200 }
                    BrisaInput { width: 200 }
                }
                BrisaInputGroup {
                    BrisaInputGroupLabel { text: "https://www." }
                    BrisaInput { width: 200 }
                    BrisaInputGroupLabel { text: ".com" }
                }
                BrisaInputGroup {
                    BrisaSelect { width: 200; options: [ { label: "option", value: "option" } ] }
                    BrisaSelect { width: 200; options: [ { label: "option", value: "option" } ] }
                    BrisaSelect { width: 200; options: [ { label: "option", value: "option" } ] }
                }
                BrisaInputGroup {
                    BrisaButton { text: "Search"; type: "primary" }
                    BrisaInput { width: 240 }
                    BrisaButton { text: "Search"; type: "primary"; ghost: true }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Events"
            Column {
                spacing: 12
                BrisaInput {
                    placeholder: "Interact to trigger events"
                    onFocusEvent: console.log("[Event focus]")
                    onBlurEvent: console.log("[Event blur]")
                    onChange: function(v) { console.log("[Event change]", v) }
                    onKeyUp: console.log("[Event keyup]")
                    onInputEvent: function(v) { console.log("[Event input]", v) }
                }
                BrisaInput { type: "textarea"; placeholder: "Interact to trigger events"; autosize: true }
                BrisaInput { pair: true; separator: "to" }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Count"
            Column {
                spacing: 12
                BrisaInput { maxLength: 30; showCount: true; clearable: true }
                BrisaInput { text: "Yes"; maxLength: 30; showCount: true; clearable: true }
                BrisaInput { type: "textarea"; maxLength: 30; showCount: true; autosize: true }
                BrisaInput { type: "textarea"; text: "What?"; maxLength: 30; showCount: true; autosize: true }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Status"
            Column {
                spacing: 12
                BrisaInput { status: "warning" }
                BrisaInput { status: "error" }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Allow Input"
            Column {
                spacing: 12
                BrisaInput {
                    placeholder: "Only allow number"
                    allowInput: function(v) { return v === "" || /^\\d+$/.test(v) }
                }
                BrisaInput {
                    type: "textarea"
                    placeholder: "No leading or trailing space"
                    allowInput: function(v) { return !/\\s/.test(v) }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Input Number"
            Column {
                spacing: 12
                BrisaInputNumber { value: 12 }
                BrisaInputNumber { value: 3; step: 0.5; precision: 1 }
                BrisaInputNumber { value: 0; disabled: true }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Select"
            Column {
                spacing: 12
                BrisaSelect {
                    value: selected
                    options: [
                        { label: "Beijing", value: "Beijing" },
                        { label: "Shanghai", value: "Shanghai" },
                        { label: "Guangzhou", value: "Guangzhou" }
                    ]
                    onUpdateValue: function(v) { selected = v }
                }
                BrisaSelect {
                    disabled: true
                    placeholder: "Disabled"
                    options: [
                        { label: "A", value: "A" }
                    ]
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Form"
            Column {
                spacing: 12

                BrisaForm {
                    width: parent.width
                    labelPlacement: "left"
                    labelWidth: 90
                    BrisaFormItem {
                        label: "Name"
                        required: true
                        feedback: "Required field"
                        status: "warning"
                        BrisaInput { placeholder: "Input name" }
                    }
                    BrisaFormItem {
                        label: "Age"
                        BrisaInputNumber { value: 26 }
                    }
                    BrisaFormItem {
                        label: "City"
                        BrisaSelect {
                            value: city
                            options: [
                                { label: "Beijing", value: "Beijing" },
                                { label: "Shanghai", value: "Shanghai" }
                            ]
                            onUpdateValue: function(v) { city = v }
                        }
                    }
                    BrisaFormItem {
                        label: "Email"
                        feedback: "Please enter a valid email."
                        status: "warning"
                        BrisaInput { placeholder: "name@email.com" }
                    }
                }
            }
        }
    }

    property string selected: ""
    property string city: ""
}
