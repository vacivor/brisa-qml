import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: root
    width: 920
    implicitHeight: contentColumn.implicitHeight

    Theme { id: theme }

    property int metricMinWidth: 248
    property int panelGap: 16
    property int narrowBreakpoint: 620
    property int splitBreakpoint: 860
    property int mixedWideBreakpoint: 900
    property int innerSectionGap: 18

    function columnsFor(width, minWidth, spacing) {
        if (width <= 0)
            return 1
        var cols = Math.floor((width + spacing) / (minWidth + spacing))
        return Math.max(1, cols)
    }

    Component {
        id: trendUpIcon

        Item {
            implicitWidth: 16
            implicitHeight: 16

            Shape {
                anchors.fill: parent
                antialiasing: true

                ShapePath {
                    strokeColor: theme.successColor
                    strokeWidth: 1.8
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin
                    startX: 2
                    startY: 11
                    PathLine { x: 6; y: 7 }
                    PathLine { x: 9; y: 10 }
                    PathLine { x: 14; y: 4 }
                }
            }
        }
    }

    Component {
        id: trendDownIcon

        Item {
            implicitWidth: 16
            implicitHeight: 16

            Shape {
                anchors.fill: parent
                antialiasing: true

                ShapePath {
                    strokeColor: theme.warningColor
                    strokeWidth: 1.8
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin
                    startX: 2
                    startY: 5
                    PathLine { x: 6; y: 9 }
                    PathLine { x: 9; y: 6 }
                    PathLine { x: 14; y: 12 }
                }
            }
        }
    }

    Component {
        id: pulseIcon

        BrisaIconWrapper {
            size: 30
            color: Qt.rgba(theme.infoColor.r, theme.infoColor.g, theme.infoColor.b, 0.10)
            iconColor: theme.infoColor

            Shape {
                anchors.fill: parent
                anchors.margins: 7
                antialiasing: true

                ShapePath {
                    strokeColor: theme.infoColor
                    strokeWidth: 1.8
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin
                    startX: 0
                    startY: height * 0.58
                    PathLine { x: width * 0.20; y: height * 0.58 }
                    PathLine { x: width * 0.34; y: height * 0.24 }
                    PathLine { x: width * 0.50; y: height * 0.78 }
                    PathLine { x: width * 0.68; y: height * 0.42 }
                    PathLine { x: width; y: height * 0.42 }
                }
            }
        }
    }

    Component {
        id: cubeIcon

        BrisaIconWrapper {
            size: 30
            color: Qt.rgba(theme.successColor.r, theme.successColor.g, theme.successColor.b, 0.10)
            iconColor: theme.successColor

            Shape {
                anchors.fill: parent
                anchors.margins: 8
                antialiasing: true

                ShapePath {
                    strokeColor: theme.successColor
                    strokeWidth: 1.8
                    fillColor: "transparent"
                    joinStyle: ShapePath.RoundJoin
                    startX: width * 0.5
                    startY: height * 0.04
                    PathLine { x: width * 0.90; y: height * 0.24 }
                    PathLine { x: width * 0.5; y: height * 0.46 }
                    PathLine { x: width * 0.10; y: height * 0.24 }
                    PathLine { x: width * 0.5; y: height * 0.04 }
                }

                ShapePath {
                    strokeColor: theme.successColor
                    strokeWidth: 1.8
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    startX: width * 0.10
                    startY: height * 0.24
                    PathLine { x: width * 0.10; y: height * 0.74 }
                    PathLine { x: width * 0.50; y: height * 0.96 }
                    PathLine { x: width * 0.90; y: height * 0.74 }
                    PathLine { x: width * 0.90; y: height * 0.24 }
                }
            }
        }
    }

    Component {
        id: layerIcon

        BrisaIconWrapper {
            size: 30
            color: Qt.rgba(theme.warningColor.r, theme.warningColor.g, theme.warningColor.b, 0.10)
            iconColor: theme.warningColor

            Shape {
                anchors.fill: parent
                anchors.margins: 7
                antialiasing: true

                ShapePath {
                    strokeColor: theme.warningColor
                    strokeWidth: 1.8
                    fillColor: "transparent"
                    joinStyle: ShapePath.RoundJoin
                    startX: width * 0.50
                    startY: height * 0.08
                    PathLine { x: width * 0.92; y: height * 0.28 }
                    PathLine { x: width * 0.50; y: height * 0.48 }
                    PathLine { x: width * 0.08; y: height * 0.28 }
                    PathLine { x: width * 0.50; y: height * 0.08 }
                }

                ShapePath {
                    strokeColor: Qt.rgba(theme.warningColor.r, theme.warningColor.g, theme.warningColor.b, 0.75)
                    strokeWidth: 1.8
                    fillColor: "transparent"
                    joinStyle: ShapePath.RoundJoin
                    startX: width * 0.50
                    startY: height * 0.34
                    PathLine { x: width * 0.86; y: height * 0.52 }
                    PathLine { x: width * 0.50; y: height * 0.70 }
                    PathLine { x: width * 0.14; y: height * 0.52 }
                    PathLine { x: width * 0.50; y: height * 0.34 }
                }
            }
        }
    }

    Column {
        id: contentColumn
        width: parent.width
        spacing: 24

        Text {
            text: "Layout"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Responsive dashboard composition, split panels and list-heavy management views tuned to the Brisa light system."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        ShowcaseSection {
            width: parent.width
            title: "Metric Grid"
            subtitle: "A flexible top row that keeps each card legible as the viewport changes."
        }

        GridLayout {
            width: parent.width
            columnSpacing: root.panelGap
            rowSpacing: root.panelGap
            columns: columnsFor(width, root.metricMinWidth, columnSpacing)

            BrisaCard {
                Layout.fillWidth: true
                Layout.minimumWidth: root.metricMinWidth
                Layout.minimumHeight: 166
                hoverable: true
                title: "Active Users"

                Column {
                    width: parent.width
                    spacing: 12

                    Row {
                        spacing: 8

                        Text {
                            text: "12,480"
                            color: theme.textColor1
                            font.family: theme.fontFamily
                            font.pixelSize: 26
                            font.weight: Font.DemiBold
                        }

                        Loader {
                            anchors.verticalCenter: parent.verticalCenter
                            sourceComponent: trendUpIcon
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "+6.4%"
                            color: theme.successColor
                            font.family: theme.fontFamily
                            font.pixelSize: 12
                            font.weight: Font.Medium
                        }
                    }

                    Text {
                        text: "Peak day: Thu · strongest growth in onboarding and team invites."
                        width: parent.width
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 12
                        lineHeightMode: Text.FixedHeight
                        lineHeight: 18
                        wrapMode: Text.Wrap
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Qt.rgba(theme.dividerColor.r, theme.dividerColor.g, theme.dividerColor.b, 0.75)
                    }

                    Row {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "vs last week"
                            color: theme.textColor3
                            font.family: theme.fontFamily
                            font.pixelSize: 11
                        }

                        Text {
                            text: "+782"
                            color: theme.successColor
                            font.family: theme.fontFamily
                            font.pixelSize: 11
                            font.weight: Font.Medium
                        }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                Layout.minimumWidth: root.metricMinWidth
                Layout.minimumHeight: 166
                hoverable: true
                title: "Revenue"

                Column {
                    width: parent.width
                    spacing: 12

                    Row {
                        spacing: 8

                        Text {
                            text: "$84,932"
                            color: theme.textColor1
                            font.family: theme.fontFamily
                            font.pixelSize: 26
                            font.weight: Font.DemiBold
                        }

                        Loader {
                            anchors.verticalCenter: parent.verticalCenter
                            sourceComponent: trendUpIcon
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "+3.2%"
                            color: theme.infoColor
                            font.family: theme.fontFamily
                            font.pixelSize: 12
                            font.weight: Font.Medium
                        }
                    }

                    Text {
                        text: "Top plan: Pro · renewals remain steady with stronger expansion revenue."
                        width: parent.width
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 12
                        lineHeightMode: Text.FixedHeight
                        lineHeight: 18
                        wrapMode: Text.Wrap
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Qt.rgba(theme.dividerColor.r, theme.dividerColor.g, theme.dividerColor.b, 0.75)
                    }

                    Row {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "ARR mix"
                            color: theme.textColor3
                            font.family: theme.fontFamily
                            font.pixelSize: 11
                        }

                        Text {
                            text: "Pro 61%"
                            color: theme.infoColor
                            font.family: theme.fontFamily
                            font.pixelSize: 11
                            font.weight: Font.Medium
                        }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                Layout.minimumWidth: root.metricMinWidth
                Layout.minimumHeight: 166
                hoverable: true
                title: "Latency"

                Column {
                    width: parent.width
                    spacing: 12

                    Row {
                        spacing: 8

                        Text {
                            text: "124ms"
                            color: theme.textColor1
                            font.family: theme.fontFamily
                            font.pixelSize: 26
                            font.weight: Font.DemiBold
                        }

                        Loader {
                            anchors.verticalCenter: parent.verticalCenter
                            sourceComponent: trendDownIcon
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "-12ms"
                            color: theme.successColor
                            font.family: theme.fontFamily
                            font.pixelSize: 12
                            font.weight: Font.Medium
                        }
                    }

                    Text {
                        text: "Region: APAC · edge cache warmups reduced p95 response variance."
                        width: parent.width
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 12
                        lineHeightMode: Text.FixedHeight
                        lineHeight: 18
                        wrapMode: Text.Wrap
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Qt.rgba(theme.dividerColor.r, theme.dividerColor.g, theme.dividerColor.b, 0.75)
                    }

                    Row {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "tail p99"
                            color: theme.textColor3
                            font.family: theme.fontFamily
                            font.pixelSize: 11
                        }

                        Text {
                            text: "341ms"
                            color: theme.successColor
                            font.family: theme.fontFamily
                            font.pixelSize: 11
                            font.weight: Font.Medium
                        }
                    }
                }
            }
        }

        ShowcaseSection {
            width: parent.width
            title: "Workbench Split"
            subtitle: "A realistic operations shell with a compact summary rail and a denser working area."
        }

        Item {
            width: parent.width
            height: splitLayout.implicitHeight

            GridLayout {
                id: splitLayout
                anchors.fill: parent
                columns: width >= root.splitBreakpoint ? 2 : 1
                columnSpacing: root.panelGap
                rowSpacing: root.panelGap

                BrisaCard {
                    Layout.fillWidth: true
                    Layout.preferredWidth: splitLayout.columns > 1 ? 288 : splitLayout.width
                    title: "Workspace Summary"
                    hoverable: true

                    Column {
                        width: parent.width
                        spacing: root.innerSectionGap

                        BrisaList {
                            width: parent.width
                            bordered: false

                            BrisaListItem {
                                prefixComponent: pulseIcon
                                title: "Stability"
                                description: "Incidents are down across the last 7 days."
                                extra: "Healthy"
                            }

                            BrisaListItem {
                                prefixComponent: cubeIcon
                                title: "Packages"
                                description: "3 core packages changed after design token updates."
                                extra: "3"
                            }

                            BrisaListItem {
                                prefixComponent: layerIcon
                                title: "Environments"
                                description: "Preview, staging and production remain in sync."
                                extra: "Synced"
                                showDivider: false
                            }
                        }
                    }
                }

                BrisaCard {
                    Layout.fillWidth: true
                    Layout.minimumHeight: splitLayout.columns > 1 ? 332 : -1
                    title: "Release Readiness"
                    hoverable: true

                    Column {
                        width: parent.width
                        spacing: root.innerSectionGap

                        RowLayout {
                            width: parent.width
                            spacing: 16

                            BrisaProgress {
                                Layout.fillWidth: true
                                percentage: 82
                                status: "default"
                            }

                            Text {
                                text: "82%"
                                color: theme.textColor1
                                font.family: theme.fontFamily
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                            }
                        }

                        BrisaList {
                            width: parent.width
                            bordered: false
                            hoverable: true

                            BrisaListItem {
                                title: "QA Sweep"
                                description: "Regression checks passed on the latest build candidate."
                                extra: "Done"
                            }

                            BrisaListItem {
                                title: "Changelog"
                                description: "Release notes still need one more review from platform ops."
                                extra: "Review"
                            }

                            BrisaListItem {
                                title: "Comms"
                                description: "Customer-facing release messaging is staged and ready."
                                extra: "Ready"
                                showDivider: false
                            }
                        }
                    }
                }
            }
        }

        ShowcaseSection {
            width: parent.width
            title: "Mixed Density"
            subtitle: "A denser timeline block paired with a lighter planning surface."
        }

        Item {
            width: parent.width
            height: mixedLayout.implicitHeight

            GridLayout {
                id: mixedLayout
                anchors.fill: parent
                columns: width >= root.mixedWideBreakpoint ? 3 : (width >= root.narrowBreakpoint ? 2 : 1)
                columnSpacing: root.panelGap
                rowSpacing: root.panelGap

                BrisaCard {
                    Layout.fillWidth: true
                    Layout.columnSpan: mixedLayout.columns >= 3 ? 2 : 1
                    Layout.minimumHeight: mixedLayout.columns >= 3 ? 322 : -1
                    title: "Recent Activity"
                    hoverable: true

                    BrisaList {
                        width: parent.width
                        bordered: false
                        hoverable: true

                        header: BrisaListItem {
                            section: true
                            title: "Today"
                            extra: "6 events"
                            showDivider: false
                        }

                        BrisaListItem {
                            title: "New workspace created"
                            description: "The Growth team spun up a fresh workspace for funnel experiments."
                            extra: "2m ago"
                        }

                        BrisaListItem {
                            title: "Billing updated"
                            description: "Plan limits and trial conversions were synchronized successfully."
                            extra: "18m ago"
                        }

                        BrisaListItem {
                            title: "3 integrations connected"
                            description: "GitHub, Slack and Linear were linked to the release workspace."
                            extra: "1h ago"
                            showDivider: false
                        }
                    }
                }

                BrisaCard {
                    Layout.fillWidth: true
                    Layout.minimumHeight: mixedLayout.columns >= 3 ? 322 : -1
                    title: "Plan"
                    hoverable: true

                    Column {
                        width: parent.width
                        spacing: root.innerSectionGap

                        BrisaAlert {
                            width: parent.width
                            type: "info"
                            bordered: false
                            title: "2 reviews remain"
                            content: "The release can move after docs and QA sign-off."
                        }

                        BrisaList {
                            width: parent.width
                            bordered: false

                            BrisaListItem {
                                title: "Docs Review"
                                extra: "Today"
                                showArrow: true
                                clickable: true
                            }

                            BrisaListItem {
                                title: "Launch Checklist"
                                extra: "Tomorrow"
                                showArrow: true
                                clickable: true
                                showDivider: false
                            }
                        }
                    }
                }
            }
        }
    }
}
