import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: root
    width: 900
    implicitHeight: column.implicitHeight

    Theme { id: theme }

    Component {
        id: cubeIcon

        BrisaIconWrapper {
            size: 28
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
                    joinStyle: ShapePath.RoundJoin
                    startX: width * 0.5
                    startY: height * 0.08
                    PathLine { x: width * 0.86; y: height * 0.28 }
                    PathLine { x: width * 0.5; y: height * 0.48 }
                    PathLine { x: width * 0.14; y: height * 0.28 }
                    PathLine { x: width * 0.5; y: height * 0.08 }
                }

                ShapePath {
                    strokeColor: theme.infoColor
                    strokeWidth: 1.8
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    startX: width * 0.14
                    startY: height * 0.28
                    PathLine { x: width * 0.14; y: height * 0.72 }
                    PathLine { x: width * 0.5; y: height * 0.92 }
                    PathLine { x: width * 0.86; y: height * 0.72 }
                    PathLine { x: width * 0.86; y: height * 0.28 }
                }

                ShapePath {
                    strokeColor: theme.infoColor
                    strokeWidth: 1.8
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    startX: width * 0.5
                    startY: height * 0.48
                    PathLine { x: width * 0.5; y: height * 0.92 }
                }
            }
        }
    }

    Component {
        id: tokenIcon

        BrisaIconWrapper {
            size: 28
            color: Qt.rgba(theme.successColor.r, theme.successColor.g, theme.successColor.b, 0.10)
            iconColor: theme.successColor

            Rectangle {
                anchors.centerIn: parent
                width: 14
                height: 14
                radius: 7
                color: "transparent"
                border.width: 2
                border.color: theme.successColor
            }
        }
    }

    Component {
        id: activitySuffix

        Rectangle {
            width: 8
            height: 8
            radius: 4
            color: theme.successColor
        }
    }

    Component {
        id: actionsBody

        Row {
            spacing: 8

            BrisaButton {
                text: "Open"
                secondary: true
            }

            BrisaButton {
                text: "Share"
                tertiary: true
            }
        }
    }

    Column {
        id: column
        width: parent.width
        spacing: 20

        Text {
            text: "List"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI inspired list with clean spacing, subtle separators and richer list item layouts."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Basic"

            BrisaList {
                width: parent.width

                BrisaListItem {
                    title: "Design System"
                    description: "Foundations, tokens and shared motion decisions for the workspace."
                }

                BrisaListItem {
                    title: "Billing"
                    description: "Invoices, payment methods and monthly usage."
                }

                BrisaListItem {
                    title: "Security"
                    description: "Teams, roles, access logs and audit settings."
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "With Prefix And Extra"

            BrisaList {
                width: parent.width
                bordered: true
                hoverable: true

                BrisaListItem {
                    prefixComponent: cubeIcon
                    title: "Core Package"
                    description: "Base primitives used across every product surface."
                    extra: "Updated 2m ago"
                }

                BrisaListItem {
                    prefixComponent: tokenIcon
                    title: "Token Registry"
                    description: "Colors, spacing and semantic aliases synchronized with production."
                    extra: "Healthy"
                    suffixComponent: activitySuffix
                }

                BrisaListItem {
                    prefixComponent: cubeIcon
                    title: "Integrations"
                    description: "GitHub, Slack and OpenAI project bindings."
                    showArrow: true
                    clickable: true
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Interactive"

            BrisaList {
                width: parent.width
                bordered: true
                hoverable: true
                clickable: true

                BrisaListItem {
                    title: "Workspace Settings"
                    description: "Click to manage workspace metadata, locale and lifecycle configuration."
                    clickable: true
                    showArrow: true
                }

                BrisaListItem {
                    title: "Incident Feed"
                    description: "A denser, more operational row with clear status and navigation affordance."
                    clickable: true
                    extra: "12"
                    showArrow: true
                }

                BrisaListItem {
                    title: "Members"
                    description: "Disabled items keep hierarchy but stop interaction."
                    disabled: true
                    clickable: true
                    showArrow: true
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Header And Footer"

            BrisaList {
                width: parent.width
                bordered: true
                hoverable: true

                header: BrisaListItem {
                    section: true
                    title: "Recent Releases"
                    extra: "3 items"
                    showDivider: false
                }

                BrisaListItem {
                    title: "Version 2.4.0"
                    description: "Stability work, denser data table polish and animation tuning."
                    extra: "Today"
                }

                BrisaListItem {
                    title: "Version 2.3.8"
                    description: "Alert, Empty and Progress refinements."
                    extra: "Yesterday"
                }

                footer: BrisaListItem {
                    section: true
                    title: "View all releases"
                    showDivider: false
                    clickable: true
                    showArrow: true
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Borderless"

            BrisaList {
                width: parent.width
                bordered: false
                hoverable: true
                clickable: true

                BrisaListItem {
                    prefixComponent: cubeIcon
                    title: "API Tokens"
                    description: "Manage personal access tokens and service credentials."
                    showArrow: true
                }

                BrisaListItem {
                    prefixComponent: tokenIcon
                    title: "Environments"
                    description: "Preview, staging and production environments for every app."
                    extra: "4"
                    showArrow: true
                }

                BrisaListItem {
                    prefixComponent: cubeIcon
                    title: "Activity Stream"
                    description: "Operational feed with deployments, audits and incidents."
                    showArrow: true
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Sizes"

            RowLayout {
                width: parent.width
                spacing: 16

                BrisaList {
                    Layout.fillWidth: true
                    size: "small"
                    bordered: true
                    hoverable: true

                    BrisaListItem {
                        title: "Small Item"
                        description: "Tighter spacing for denser surfaces."
                        extra: "S"
                    }

                    BrisaListItem {
                        title: "Another Item"
                        description: "Useful for compact side panels."
                        showArrow: true
                    }
                }

                BrisaList {
                    Layout.fillWidth: true
                    size: "large"
                    bordered: true
                    hoverable: true

                    BrisaListItem {
                        title: "Large Item"
                        description: "A roomier rhythm closer to setting pages and summaries."
                        extra: "L"
                    }

                    BrisaListItem {
                        title: "Review Changes"
                        description: "The larger size makes icons and copy breathe more."
                        showArrow: true
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Section Tone"

            BrisaList {
                width: parent.width
                bordered: true
                hoverable: true

                header: BrisaListItem {
                    section: true
                    title: "Pinned"
                    extra: "Updated"
                    showDivider: false
                }

                BrisaListItem {
                    title: "Release Notes"
                    description: "A lighter section header should still read clearly against regular items."
                    extra: "Now"
                }

                BrisaListItem {
                    title: "Ops Digest"
                    description: "Useful to compare section hierarchy against normal item rows."
                    extra: "Today"
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Custom Body"

            BrisaList {
                width: parent.width
                bordered: false

                BrisaListItem {
                    title: "Release Candidate 2"
                    description: "Custom content can sit under the description while keeping the list rhythm."
                    bodyComponent: actionsBody
                    prefixComponent: cubeIcon
                }

                BrisaListItem {
                    title: "Migration Checklist"
                    description: "This row stays simpler so we can compare spacing and divider behavior."
                    prefixComponent: tokenIcon
                }
            }
        }
    }
}
