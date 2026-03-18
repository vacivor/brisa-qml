import QtQuick
import QtQuick.Layouts

Item {
    id: root
    width: 1200
    implicitHeight: column.implicitHeight
    property int gridMin: 120

    function columnsFor(width, minWidth, spacing) {
        if (width <= 0) return 1
        var cols = Math.floor((width + spacing) / (minWidth + spacing))
        return Math.max(1, cols)
    }

    Component {
        id: cashIcon
        BrisaIcon {
            size: 16
            Text {
                text: "$"
                property color iconColor: "#1f1f1f"
                color: iconColor
                font.pixelSize: width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Component {
        id: trainIcon
        BrisaIcon {
            size: 16
            Text {
                text: "T"
                property color iconColor: "#1f1f1f"
                color: iconColor
                font.pixelSize: width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Component {
        id: loginIcon
        BrisaIcon {
            size: 16
            Text {
                text: "L"
                property color iconColor: "#1f1f1f"
                color: iconColor
                font.pixelSize: width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Column {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 28

        ShowcaseSection {
            title: "Button"
            subtitle: "Brisa button variants aligned with naive-ui light theme behavior."
        }

        ShowcaseSection { title: "Types" }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { text: "Default" }
            BrisaButton { text: "Tertiary"; type: "tertiary" }
            BrisaButton { text: "Primary"; type: "primary" }
            BrisaButton { text: "Info"; type: "info" }
            BrisaButton { text: "Success"; type: "success" }
            BrisaButton { text: "Warning"; type: "warning" }
            BrisaButton { text: "Error"; type: "error" }
        }

        ShowcaseSection { title: "Strong Secondary" }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { text: "Default"; strong: true; secondary: true }
            BrisaButton { text: "Tertiary"; strong: true; secondary: true; type: "tertiary" }
            BrisaButton { text: "Primary"; strong: true; secondary: true; type: "primary" }
            BrisaButton { text: "Info"; strong: true; secondary: true; type: "info" }
            BrisaButton { text: "Success"; strong: true; secondary: true; type: "success" }
            BrisaButton { text: "Warning"; strong: true; secondary: true; type: "warning" }
            BrisaButton { text: "Error"; strong: true; secondary: true; type: "error" }
        }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { text: "Default"; strong: true; secondary: true; round: true }
            BrisaButton { text: "Primary"; strong: true; secondary: true; round: true; type: "primary" }
            BrisaButton { text: "Info"; strong: true; secondary: true; round: true; type: "info" }
            BrisaButton { text: "Success"; strong: true; secondary: true; round: true; type: "success" }
            BrisaButton { text: "Warning"; strong: true; secondary: true; round: true; type: "warning" }
            BrisaButton { text: "Error"; strong: true; secondary: true; round: true; type: "error" }
        }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { strong: true; secondary: true; circle: true; iconComponent: cashIcon }
            BrisaButton { strong: true; secondary: true; circle: true; type: "primary"; iconComponent: cashIcon }
            BrisaButton { strong: true; secondary: true; circle: true; type: "info"; iconComponent: cashIcon }
            BrisaButton { strong: true; secondary: true; circle: true; type: "success"; iconComponent: cashIcon }
            BrisaButton { strong: true; secondary: true; circle: true; type: "warning"; iconComponent: cashIcon }
            BrisaButton { strong: true; secondary: true; circle: true; type: "error"; iconComponent: cashIcon }
        }

        ShowcaseSection { title: "Tertiary" }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { text: "Default"; tertiary: true }
            BrisaButton { text: "Primary"; tertiary: true; type: "primary" }
            BrisaButton { text: "Info"; tertiary: true; type: "info" }
            BrisaButton { text: "Success"; tertiary: true; type: "success" }
            BrisaButton { text: "Warning"; tertiary: true; type: "warning" }
            BrisaButton { text: "Error"; tertiary: true; type: "error" }
        }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { text: "Default"; tertiary: true; round: true }
            BrisaButton { text: "Primary"; tertiary: true; round: true; type: "primary" }
            BrisaButton { text: "Info"; tertiary: true; round: true; type: "info" }
            BrisaButton { text: "Success"; tertiary: true; round: true; type: "success" }
            BrisaButton { text: "Warning"; tertiary: true; round: true; type: "warning" }
            BrisaButton { text: "Error"; tertiary: true; round: true; type: "error" }
        }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { tertiary: true; circle: true; iconComponent: cashIcon }
            BrisaButton { tertiary: true; circle: true; type: "primary"; iconComponent: cashIcon }
            BrisaButton { tertiary: true; circle: true; type: "info"; iconComponent: cashIcon }
            BrisaButton { tertiary: true; circle: true; type: "success"; iconComponent: cashIcon }
            BrisaButton { tertiary: true; circle: true; type: "warning"; iconComponent: cashIcon }
            BrisaButton { tertiary: true; circle: true; type: "error"; iconComponent: cashIcon }
        }

        ShowcaseSection { title: "Quaternary" }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { text: "Default"; quaternary: true }
            BrisaButton { text: "Primary"; quaternary: true; type: "primary" }
            BrisaButton { text: "Info"; quaternary: true; type: "info" }
            BrisaButton { text: "Success"; quaternary: true; type: "success" }
            BrisaButton { text: "Warning"; quaternary: true; type: "warning" }
            BrisaButton { text: "Error"; quaternary: true; type: "error" }
        }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { text: "Default"; quaternary: true; round: true }
            BrisaButton { text: "Primary"; quaternary: true; round: true; type: "primary" }
            BrisaButton { text: "Info"; quaternary: true; round: true; type: "info" }
            BrisaButton { text: "Success"; quaternary: true; round: true; type: "success" }
            BrisaButton { text: "Warning"; quaternary: true; round: true; type: "warning" }
            BrisaButton { text: "Error"; quaternary: true; round: true; type: "error" }
        }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { quaternary: true; circle: true; iconComponent: cashIcon }
            BrisaButton { quaternary: true; circle: true; type: "primary"; iconComponent: cashIcon }
            BrisaButton { quaternary: true; circle: true; type: "info"; iconComponent: cashIcon }
            BrisaButton { quaternary: true; circle: true; type: "success"; iconComponent: cashIcon }
            BrisaButton { quaternary: true; circle: true; type: "warning"; iconComponent: cashIcon }
            BrisaButton { quaternary: true; circle: true; type: "error"; iconComponent: cashIcon }
        }

        ShowcaseSection { title: "Dashed" }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { text: "Default"; dashed: true }
            BrisaButton { text: "Primary"; type: "primary"; dashed: true }
            BrisaButton { text: "Info"; type: "info"; dashed: true }
            BrisaButton { text: "Success"; type: "success"; dashed: true }
            BrisaButton { text: "Warning"; type: "warning"; dashed: true }
            BrisaButton { text: "Error"; type: "error"; dashed: true }
        }

        ShowcaseSection { title: "Sizes" }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { text: "Small Small"; size: "tiny" }
            BrisaButton { text: "Small"; size: "small" }
            BrisaButton { text: "Not Small"; size: "medium" }
            BrisaButton { text: "Not Not Small"; size: "large" }
        }

        ShowcaseSection { title: "Text" }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton {
                textStyle: true
                iconComponent: trainIcon
                text: "The Engine is Still Spitting Smoke"
            }
            BrisaButton {
                textStyle: true
                type: "primary"
                text: "Anyway.News"
            }
        }

        ShowcaseSection { title: "Disabled" }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { text: "Disabled"; disabled: true }
        }

        ShowcaseSection { title: "Icons" }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { text: "+100$"; iconComponent: cashIcon }
            BrisaButton { text: "+100$"; iconPlacement: "right"; iconComponent: cashIcon }
        }

        ShowcaseSection { title: "Shapes" }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { circle: true; iconComponent: cashIcon }
            BrisaButton { text: "Round"; round: true }
            BrisaButton { text: "Rect" }
        }

        ShowcaseSection { title: "Ghost" }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { text: "Default"; ghost: true }
            BrisaButton { text: "Primary"; type: "primary"; ghost: true }
            BrisaButton { text: "Info"; type: "info"; ghost: true }
            BrisaButton { text: "Success"; type: "success"; ghost: true }
            BrisaButton { text: "Warning"; type: "warning"; ghost: true }
            BrisaButton { text: "Error"; type: "error"; ghost: true }
        }

        ShowcaseSection { title: "Custom Color" }

        GridLayout {
            columns: columnsFor(root.width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButton { text: "#8a2be2"; color: "#8a2be2"; iconComponent: cashIcon }
            BrisaButton { text: "#ff69b4"; color: "#ff69b4"; iconComponent: cashIcon }
            BrisaButton { text: "#8a2be2"; color: "#8a2be2"; ghost: true; iconComponent: cashIcon }
            BrisaButton { text: "#ff69b4"; color: "#ff69b4"; ghost: true; iconComponent: cashIcon }
            BrisaButton { text: "#8a2be2"; color: "#8a2be2"; textStyle: true; iconComponent: cashIcon }
            BrisaButton { text: "#ff69b4"; color: "#ff69b4"; textStyle: true; iconComponent: cashIcon }
        }

        ShowcaseSection { title: "Button Group" }

        GridLayout {
            columns: columnsFor(width, gridMin, columnSpacing)
            columnSpacing: 1
            rowSpacing: 1

            BrisaButtonGroup {
                vertical: true
                BrisaButton { text: "Live a"; round: true; iconComponent: loginIcon }
                BrisaButton { text: "Sufficient"; ghost: true; iconComponent: loginIcon }
                BrisaButton { text: "Life"; iconComponent: loginIcon }
            }

            BrisaButtonGroup {
                vertical: true
                size: "large"
                BrisaButton { text: "With"; iconComponent: loginIcon }
                BrisaButton { text: "Enough"; iconComponent: loginIcon }
                BrisaButton { text: "Happiness"; ghost: true; round: true; iconComponent: loginIcon }
            }

            BrisaButtonGroup {
                size: "small"
                BrisaButton { text: "Life"; round: true; iconComponent: loginIcon }
                BrisaButton { text: "Is"; iconComponent: loginIcon }
                BrisaButton { text: "Good"; iconComponent: loginIcon }
            }

            BrisaButtonGroup {
                BrisaButton { text: "Eat"; ghost: true; iconComponent: loginIcon }
                BrisaButton { text: "One More"; ghost: true; iconComponent: loginIcon }
                BrisaButton { text: "Apple"; round: true; iconComponent: loginIcon }
            }
        }
    }
}
