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
            text: "Input Number"
            color: theme.textColor1
            font.family: "Space Grotesk"
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Numeric input with Naive UI light behavior."
            color: theme.textColor3
            font.family: "Space Grotesk"
            font.pixelSize: 12
        }

        ShowcaseSection {
            title: "Basic"
            subtitle: "Default value, disabled state, and size variants."
        }

        BrisaCard {
            width: parent.width
            title: "Basic"
            Column {
                width: parent.width
                spacing: 12
                BrisaInputNumber { width: parent.width; value: basicValue; clearable: true }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Disabled"
            Column {
                width: parent.width
                spacing: 12
                Row {
                    spacing: 12
                    BrisaButton {
                        text: disabledValue ? "Disabled: On" : "Disabled: Off"
                        onClicked: disabledValue = !disabledValue
                    }
                    BrisaInputNumber { width: 220; value: disabledNumber; disabled: disabledValue }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Sizes"
            Column {
                width: parent.width
                spacing: 12
                BrisaInputNumber { width: parent.width; value: sizeValue; size: "tiny" }
                BrisaInputNumber { width: parent.width; value: sizeValue; size: "small" }
                BrisaInputNumber { width: parent.width; value: sizeValue; size: "medium" }
                BrisaInputNumber { width: parent.width; value: sizeValue; size: "large" }
            }
        }

        ShowcaseSection {
            title: "Formatting"
            subtitle: "Formatting, precision, step, and boundaries."
        }

        BrisaCard {
            width: parent.width
            title: "Parse / Format"
            Column {
                width: parent.width
                spacing: 12
                BrisaInputNumber { width: parent.width; value: parseValueA; parse: parse; format: format }
                BrisaInputNumber { width: parent.width; value: parseValueB; parse: parseCurrency; format: formatCurrency }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Precision"
            Column {
                width: parent.width
                spacing: 12
                BrisaInputNumber { width: parent.width; clearable: true; precision: 2; value: precisionValueA }
                BrisaInputNumber { width: parent.width; clearable: true; precision: 0; value: precisionValueB }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Min / Max"
            Column {
                width: parent.width
                spacing: 12
                BrisaInputNumber { width: parent.width; value: minMaxValue; placeholder: "Min"; min: -3; max: 5 }
                BrisaInputNumber { width: parent.width; value: minMaxValue; placeholder: "Max"; min: -5; max: 3 }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Step"
            Column {
                width: parent.width
                spacing: 12
                BrisaInputNumber { width: parent.width; value: stepValue; step: 2 }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Validator"
            Column {
                width: parent.width
                spacing: 12
                BrisaInputNumber { width: parent.width; value: validatorValue; validator: validator }
            }
        }

        ShowcaseSection {
            title: "Affixes"
            subtitle: "Prefix, suffix, button placement, and custom icons."
        }

        BrisaCard {
            width: parent.width
            title: "Prefix / Suffix"
            Column {
                width: parent.width
                spacing: 12
                BrisaInputNumber {
                    width: parent.width
                    value: prefixValue
                    prefix: [ Text { text: "$"; color: theme.textColor3; anchors.verticalCenter: parent.verticalCenter } ]
                }
                BrisaInputNumber {
                    width: parent.width
                    value: prefixValue
                    suffix: [ Text { text: "%"; color: theme.textColor3; anchors.verticalCenter: parent.verticalCenter } ]
                }
                BrisaInputNumber {
                    width: parent.width
                    value: prefixValue
                    showButton: false
                    suffix: [ Text { text: "%"; color: theme.textColor3; anchors.verticalCenter: parent.verticalCenter } ]
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Button Placement"
            Column {
                width: parent.width
                spacing: 12
                BrisaInputNumber { width: parent.width; value: placementValue; buttonPlacement: "both" }
                BrisaInputNumber {
                    width: parent.width
                    value: placementValue
                    buttonPlacement: "both"
                    prefix: [ Text { text: "$"; color: theme.textColor3; anchors.verticalCenter: parent.verticalCenter } ]
                }
                BrisaInputNumber {
                    width: parent.width
                    value: placementValue
                    buttonPlacement: "both"
                    suffix: [ Text { text: "฿"; color: theme.textColor3; anchors.verticalCenter: parent.verticalCenter } ]
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Custom Icons"
            Column {
                width: parent.width
                spacing: 12
                BrisaInputNumber {
                    width: parent.width
                    value: iconValue
                    minusIconComponent: Component { Text { text: "▼"; color: theme.textColor2; font.pixelSize: 12 } }
                    addIconComponent: Component { Text { text: "▲"; color: theme.textColor2; font.pixelSize: 12 } }
                }
            }
        }

        ShowcaseSection {
            title: "States"
            subtitle: "Loading, visibility toggles, keyboard behavior, and status states."
        }

        BrisaCard {
            width: parent.width
            title: "Loading"
            Column {
                width: parent.width
                spacing: 12
                Row {
                    spacing: 12
                    BrisaButton {
                        text: loadingValue ? "Loading: On" : "Loading: Off"
                        onClicked: loadingValue = !loadingValue
                    }
                    BrisaInputNumber { width: 240; loading: loadingValue; clearable: true }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Show Button"
            Column {
                width: parent.width
                spacing: 12
                Row {
                    spacing: 12
                    BrisaButton {
                        text: showButtonValue ? "Show Button: On" : "Show Button: Off"
                        onClicked: showButtonValue = !showButtonValue
                    }
                    BrisaInputNumber { width: 240; value: showButtonNumber; showButton: showButtonValue }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Keyboard"
            Column {
                width: parent.width
                spacing: 12
                BrisaInputNumber { width: parent.width; keyboard: ({ ArrowUp: false, ArrowDown: false }) }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Status"
            Column {
                width: parent.width
                spacing: 12
                BrisaInputNumber { width: parent.width; status: "warning" }
                BrisaInputNumber { width: parent.width; status: "error" }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Update Timing"
            Column {
                width: parent.width
                spacing: 12
                BrisaInputNumber {
                    width: parent.width
                    value: updateTimingValue
                    updateValueOnInput: false
                    min: 20
                    max: 50
                    onUpdateValue: function(v) { updateTimingValue = v }
                }
                BrisaInputNumber {
                    width: parent.width
                    value: updateTimingValue
                    updateValueOnInput: true
                    min: 20
                    max: 50
                    onUpdateValue: function(v) { updateTimingValue = v }
                }
                Text { text: "value: " + updateTimingValue; color: theme.textColor3 }
            }
        }

        ShowcaseSection {
            title: "Events"
            subtitle: "Focus, blur, and update hooks for debugging interaction."
        }

        BrisaCard {
            width: parent.width
            title: "Events"
            Column {
                width: parent.width
                spacing: 12
                BrisaInputNumber {
                    width: parent.width
                    value: eventValue
                    onUpdateValue: function(v) { console.log("update:value", v) }
                    onFocusEvent: console.log("focus")
                    onBlurEvent: console.log("blur")
                }
            }
        }
    }

    property var basicValue: 0
    property var disabledNumber: 0
    property bool disabledValue: true
    property var parseValueA: 1075
    property var parseValueB: 1075
    property var precisionValueA: 0
    property var precisionValueB: 0
    property var eventValue: 0
    property var prefixValue: 0
    property var placementValue: 0
    property bool loadingValue: false
    property var minMaxValue: 0
    property var sizeValue: 0
    property var stepValue: 0
    property var validatorValue: 0
    property bool showButtonValue: true
    property var showButtonNumber: 0
    property var updateTimingValue: 35
    property var iconValue: 0

    function parse(input) {
        var nums = String(input).replace(/,/g, "").trim()
        if (/^\\d+(\\.(\\d+)?)?$/.test(nums)) return Number(nums)
        return nums === "" ? null : Number.NaN
    }

    function format(value) {
        if (value === null) return ""
        return Number(value).toLocaleString("en-US")
    }

    function parseCurrency(input) {
        var nums = String(input).replace(/(,|\\$|\\s)/g, "").trim()
        if (/^\\d+(\\.(\\d+)?)?$/.test(nums)) return Number(nums)
        return nums === "" ? null : Number.NaN
    }

    function formatCurrency(value) {
        if (value === null) return ""
        return Number(value).toLocaleString("en-US") + " $"
    }

    function validator(x) {
        return x > 0
    }
}
