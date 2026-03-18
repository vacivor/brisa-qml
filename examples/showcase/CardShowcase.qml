import QtQuick
import QtQuick.Layouts

Item {
    id: root
    width: 900
    implicitHeight: contentColumn.implicitHeight
    property int gridGap: 16

    function columnsFor(width, minWidth, spacing) {
        if (width <= 0) return 1
        var cols = Math.floor((width + spacing) / (minWidth + spacing))
        return Math.max(1, cols)
    }

    Column {
        id: contentColumn
        width: parent.width
        spacing: 18

        Text {
            text: "Card"
            color: "#0f172a"
            font.family: "Space Grotesk"
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Surface containers with header, body, and footer."
            color: "#64748b"
            font.family: "Space Grotesk"
            font.pixelSize: 12
        }

        Text {
            text: "Size"
            color: "#0f172a"
            font.family: "Space Grotesk"
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }

        GridLayout {
            width: parent.width
            columnSpacing: gridGap
            rowSpacing: gridGap
            columns: columnsFor(width, 260, columnSpacing)

            BrisaCard {
                Layout.preferredWidth: 260
                Layout.fillWidth: false
                title: "Card"
                size: "small"
                Text { text: "Small card body"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            }

            BrisaCard {
                Layout.preferredWidth: 260
                Layout.fillWidth: false
                title: "Card"
                size: "medium"
                Text { text: "Medium card body"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            }

            BrisaCard {
                Layout.preferredWidth: 260
                Layout.fillWidth: false
                title: "Card"
                size: "large"
                Text { text: "Large card body"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            }

            BrisaCard {
                Layout.preferredWidth: 260
                Layout.fillWidth: false
                title: "Card"
                size: "huge"
                Text { text: "Huge card body"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            }
        }

        Text {
            text: "Style"
            color: "#0f172a"
            font.family: "Space Grotesk"
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }

        GridLayout {
            width: parent.width
            columnSpacing: gridGap
            rowSpacing: gridGap
            columns: columnsFor(width, 280, columnSpacing)

            BrisaCard {
                Layout.preferredWidth: 280
                Layout.fillWidth: false
                title: "Borderless"
                bordered: false
                Text { text: "bordered: false"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            }

            BrisaCard {
                Layout.preferredWidth: 280
                Layout.fillWidth: false
                title: "Embedded"
                embedded: true
                Text { text: "embedded: true"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            }

            BrisaCard {
                Layout.preferredWidth: 280
                Layout.fillWidth: false
                title: "Hoverable"
                hoverable: true
                Text { text: "hoverable: true"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            }

            BrisaCard {
                Layout.preferredWidth: 280
                Layout.fillWidth: false
                title: "Closable"
                closable: true
                onClosed: visible = false
                headerExtra: [
                    Text { text: "Extra"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
                ]
                Text { text: "closable: true"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            }
        }

        Text {
            text: "Segmented"
            color: "#0f172a"
            font.family: "Space Grotesk"
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }

        BrisaCard {
            width: parent.width
            title: "Card Segmented Demo"
            contentSegmented: true
            footerSegmented: true
            showFooter: true
            actionSegmented: true
            showAction: true
            headerExtra: [
                Text { text: "#header-extra"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            ]
            Text { text: "Card Content"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            footer: [
                Text { text: "#footer"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            ]
            action: [
                Text { text: "#action"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            ]
        }

        BrisaCard {
            width: parent.width
            title: "Card Soft Segmented Demo"
            contentSegmented: true
            footerSegmented: true
            showFooter: true
            actionSegmented: true
            showAction: true
            contentSoftSegmented: true
            footerSoftSegmented: true
            headerExtra: [
                Text { text: "#header-extra"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            ]
            Column {
                spacing: 6
                Text { text: "Card Content"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
                Text { text: "Soft segmented content keeps the section full width while the inner body is inset."; color: "#64748b"; font.pixelSize: 12; font.family: "Space Grotesk"; wrapMode: Text.WordWrap; width: parent ? parent.width : implicitWidth }
            }
            footer: [
                Text { text: "#footer"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            ]
            action: [
                Text { text: "#action"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            ]
        }

        Text {
            text: "Content Scrollable"
            color: "#0f172a"
            font.family: "Space Grotesk"
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }

        BrisaCard {
            width: parent.width
            title: "Scrollable Content"
            contentScrollable: true
            contentScrollHeight: 180
            headerExtra: [
                Text { text: "Overview"; color: "#64748b"; font.pixelSize: 13; font.family: "Space Grotesk" }
            ]
            Column {
                width: parent ? parent.width : implicitWidth
                spacing: 8
                Repeater {
                    model: 18
                    delegate: Text {
                        text: index === 0
                            ? "This card keeps the footer fixed while only the body scrolls."
                            : "Card content line " + index
                        color: "#333639"
                        font.pixelSize: 13
                        font.family: "Space Grotesk"
                        wrapMode: Text.WordWrap
                        width: parent ? parent.width : implicitWidth
                    }
                }
            }
            footer: [
                Text { text: "Footer remains visible"; color: "#333639"; font.pixelSize: 13; font.family: "Space Grotesk" }
            ]
            showFooter: true
            footerSegmented: true
        }
    }
}
