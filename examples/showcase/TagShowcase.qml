import QtQuick
import QtQuick.Layouts

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
            text: "Tag"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Lightweight labels aligned with Naive UI light."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Basic"
            Flow {
                width: parent.width
                spacing: 12
                BrisaTag { text: "Real Love" }
                BrisaTag { text: "Success"; type: "success" }
                BrisaTag { text: "Warning"; type: "warning" }
                BrisaTag { text: "Error"; type: "error" }
                BrisaTag { text: "Info"; type: "info" }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Closable"
            Flow {
                width: parent.width
                spacing: 12
                BrisaTag { text: "Default"; closable: true }
                BrisaTag { text: "Success"; type: "success"; closable: true }
                BrisaTag { text: "Warning"; type: "warning"; closable: true }
                BrisaTag { text: "Error"; type: "error"; closable: true }
                BrisaTag { text: "Info"; type: "info"; closable: true }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Sizes"
            Flow {
                width: parent.width
                spacing: 12
                BrisaTag { text: "Tiny"; size: "tiny"; closable: true }
                BrisaTag { text: "Small"; size: "small"; type: "success"; closable: true }
                BrisaTag { text: "Medium"; size: "medium"; type: "warning"; closable: true }
                BrisaTag { text: "Large"; size: "large"; type: "error"; closable: true }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Shape"
            Flow {
                width: parent.width
                spacing: 12
                BrisaTag { text: "Default"; round: true; closable: true }
                BrisaTag { text: "Success"; type: "success"; round: true; closable: true }
                BrisaTag { text: "Warning"; type: "warning"; round: true; closable: true }
                BrisaTag { text: "Error"; type: "error"; round: true; closable: true }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Borderless / Strong / Disabled"
            Flow {
                width: parent.width
                spacing: 12
                BrisaTag { text: "Borderless"; bordered: false }
                BrisaTag { text: "Strong"; type: "success"; strong: true }
                BrisaTag { text: "Disabled"; type: "info"; closable: true; disabled: true }
            }
        }
    }
}
