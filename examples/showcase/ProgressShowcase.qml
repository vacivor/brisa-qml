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
            text: "Progress"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI inspired progress with line, circle, dashboard, processing and status variants."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Basic"

            Column {
                width: parent.width
                spacing: 16

                BrisaProgress { width: parent.width; percentage: 30 }
                BrisaProgress { width: parent.width; percentage: 60 }
                BrisaProgress { width: parent.width; percentage: 90 }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Status"

            Column {
                width: parent.width
                spacing: 16

                BrisaProgress { width: parent.width; percentage: 72; status: "default" }
                BrisaProgress { width: parent.width; percentage: 100; status: "success" }
                BrisaProgress { width: parent.width; percentage: 58; status: "warning"; color: theme.warningColor }
                BrisaProgress { width: parent.width; percentage: 64; status: "error" }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Processing"

            Column {
                width: parent.width
                spacing: 16

                BrisaProgress { width: parent.width; percentage: 66; processing: true }
                BrisaProgress { width: parent.width; percentage: 42; processing: true; color: theme.primaryColor }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Inside Indicator"

            Column {
                width: parent.width
                spacing: 16

                BrisaProgress {
                    width: parent.width
                    percentage: 48
                    indicatorPlacement: "inside"
                    lineHeight: 16
                    borderRadius: 10
                    fillBorderRadius: 10
                }

                BrisaProgress {
                    width: parent.width
                    percentage: 100
                    status: "success"
                    indicatorPlacement: "inside"
                    lineHeight: 16
                    borderRadius: 10
                    fillBorderRadius: 10
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Circle And Dashboard"

            RowLayout {
                width: parent.width
                spacing: 24

                BrisaProgress {
                    type: "circle"
                    percentage: 72
                }

                BrisaProgress {
                    type: "circle"
                    percentage: 100
                    status: "success"
                }

                BrisaProgress {
                    type: "dashboard"
                    percentage: 58
                    color: theme.warningColor
                }

                BrisaProgress {
                    type: "dashboard"
                    percentage: 64
                    status: "error"
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Custom Height And Color"

            Column {
                width: parent.width
                spacing: 16

                BrisaProgress {
                    width: parent.width
                    percentage: 54
                    color: theme.primaryColor
                    lineHeight: 10
                }

                BrisaProgress {
                    width: parent.width
                    percentage: 84
                    color: theme.infoColor
                    lineHeight: 12
                    railColor: Qt.rgba(theme.infoColor.r, theme.infoColor.g, theme.infoColor.b, 0.14)
                }
            }
        }
    }
}
