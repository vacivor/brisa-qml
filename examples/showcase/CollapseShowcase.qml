import QtQuick
import QtQuick.Layouts

Item {
    id: root
    width: 900
    implicitHeight: contentColumn.implicitHeight

    property var openNames: ["overview", "runtime"]
    property var accordionValue: "roadmap"
    property string lastHeaderClick: ""

    Theme { id: theme }

    Column {
        id: contentColumn
        width: parent.width
        spacing: 18

        Text {
            text: "Collapse"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI style collapse panels with accordion, embedded surfaces, and header extras."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        GridLayout {
            width: parent.width
            columns: width > 760 ? 2 : 1
            columnSpacing: 16
            rowSpacing: 16

            BrisaCard {
                Layout.fillWidth: true
                title: "Basic"

                BrisaCollapse {
                    width: parent.width
                    value: root.openNames
                    onUpdateValue: function(v) { root.openNames = v }

                    BrisaCollapseItem {
                        name: "overview"
                        title: "Overview"
                        extra: "Always relevant"

                        Text {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            text: "Collapse is useful when you want dense sections without losing scan-ability. The header stays compact, and the content keeps the same inner rhythm as the rest of the system."
                        }
                    }

                    BrisaCollapseItem {
                        name: "runtime"
                        title: "Runtime Details"
                        extra: "3 fields"

                        Column {
                            width: parent.width
                            spacing: 10

                            Text { text: "Version 1.4.12"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                            Text { text: "Region Shanghai"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                            Text { text: "Last deploy 4 minutes ago"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                        }
                    }

                    BrisaCollapseItem {
                        name: "security"
                        title: "Security Review"
                        disabled: true
                        extra: "Locked"

                        Text { text: "Disabled panels stay visible but non-interactive." }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Accordion"

                BrisaCollapse {
                    width: parent.width
                    accordion: true
                    value: root.accordionValue
                    onUpdateValue: function(v) { root.accordionValue = v }

                    BrisaCollapseItem {
                        name: "roadmap"
                        title: "Roadmap"

                        Text {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            text: "Accordion mode keeps the page tighter by allowing only one open section at a time."
                        }
                    }

                    BrisaCollapseItem {
                        name: "integrations"
                        title: "Integrations"
                        extra: "12"

                        Column {
                            width: parent.width
                            spacing: 8
                            Text { text: "GitHub"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                            Text { text: "Slack"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                            Text { text: "Datadog"; color: theme.textColor2; font.family: theme.fontFamily; font.pixelSize: 14 }
                        }
                    }

                    BrisaCollapseItem {
                        name: "notes"
                        title: "Operator Notes"
                        extra: "Draft"

                        Text {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            text: "Headers can carry lightweight metadata without inflating the vertical rhythm."
                        }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Embedded"

                BrisaCollapse {
                    width: parent.width
                    embedded: true
                    bordered: false
                    defaultValue: ["cache"]

                    BrisaCollapseItem {
                        name: "cache"
                        title: "Cache Layer"

                        Text {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            text: "Embedded collapse feels softer and works well inside cards, drawers, or setup flows."
                        }
                    }

                    BrisaCollapseItem {
                        name: "storage"
                        title: "Storage"
                        extra: "Object"

                        Text {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            text: "The header uses a subtle fill instead of a hard outer border when embedded."
                        }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Header Extra"

                BrisaCollapse {
                    width: parent.width
                    defaultValue: ["build"]

                    BrisaCollapseItem {
                        name: "build"
                        title: "Build Queue"

                        headerExtra: [
                            BrisaTag { type: "success"; bordered: false; text: "Healthy" }
                        ]

                        Text {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            text: "Header extra content can expose inline status without changing the open/close affordance."
                        }
                    }

                    BrisaCollapseItem {
                        name: "deploy"
                        title: "Deploy Train"
                        extra: "Paused"

                        headerExtra: [
                            BrisaTag { type: "warning"; bordered: false; text: "Review" }
                        ]

                        Text {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            text: "The extra slot is intended for low-friction actions or status pills."
                        }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Size And Arrow"

                Column {
                    width: parent.width
                    spacing: 12

                    BrisaCollapse {
                        width: parent.width
                        size: "small"
                        defaultValue: ["compact"]

                        BrisaCollapseItem {
                            name: "compact"
                            title: "Small"

                            Text {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                color: theme.textColor2
                                font.family: theme.fontFamily
                                font.pixelSize: 14
                                text: "Small size trims header and content padding for denser layouts."
                            }
                        }
                    }

                    BrisaCollapse {
                        width: parent.width
                        size: "large"
                        defaultValue: ["manual"]

                        BrisaCollapseItem {
                            name: "manual"
                            title: "Manual Section"
                            displayArrow: false
                            extra: "No Arrow"

                            Text {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                color: theme.textColor2
                                font.family: theme.fontFamily
                                font.pixelSize: 14
                                text: "Arrow visibility can be disabled when the surrounding context already implies the section state."
                            }
                        }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Default Expanded"

                BrisaCollapse {
                    width: parent.width

                    BrisaCollapseItem {
                        name: "alpha"
                        title: "Alpha"
                        defaultExpanded: true

                        Text {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            text: "Multiple panels can start expanded in uncontrolled mode."
                        }
                    }

                    BrisaCollapseItem {
                        name: "beta"
                        title: "Beta"
                        defaultExpanded: true

                        Text {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            text: "This section opens by default as well, without requiring a defaultValue array."
                        }
                    }

                    BrisaCollapseItem {
                        name: "gamma"
                        title: "Gamma"

                        Text {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            text: "Sections without defaultExpanded stay collapsed."
                        }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Trigger Areas"

                Column {
                    width: parent.width
                    spacing: 12

                    BrisaCollapse {
                        width: parent.width
                        triggerAreas: ["arrow"]

                        BrisaCollapseItem {
                            name: "trigger-arrow"
                            title: "Only Arrow Triggers"
                            extra: "Main disabled"

                            headerExtra: [
                                BrisaTag { type: "info"; bordered: false; text: "Extra" }
                            ]

                            Text {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                color: theme.textColor2
                                font.family: theme.fontFamily
                                font.pixelSize: 14
                                text: "This matches Naive UI trigger-areas behavior: only the arrow toggles the panel."
                            }
                        }
                    }

                    BrisaCollapse {
                        width: parent.width
                        triggerAreas: ["main", "extra"]

                        BrisaCollapseItem {
                            name: "trigger-main-extra"
                            title: "Main And Extra Trigger"
                            extra: "Clickable"

                            headerExtra: [
                                BrisaTag { type: "success"; bordered: false; text: "Open" }
                            ]

                            Text {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                color: theme.textColor2
                                font.family: theme.fontFamily
                                font.pixelSize: 14
                                text: "This excludes the arrow from triggering and keeps main plus extra active."
                            }
                        }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Display Directive"

                Column {
                    width: parent.width
                    spacing: 12

                    BrisaCollapse {
                        width: parent.width
                        displayDirective: "if"

                        BrisaCollapseItem {
                            name: "directive-if"
                            title: "If"

                            Text {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                color: theme.textColor2
                                font.family: theme.fontFamily
                                font.pixelSize: 14
                                text: "Collapsed content is removed when displayDirective is if."
                            }
                        }
                    }

                    BrisaCollapse {
                        width: parent.width
                        displayDirective: "show"

                        BrisaCollapseItem {
                            name: "directive-show"
                            title: "Show"

                            Text {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                color: theme.textColor2
                                font.family: theme.fontFamily
                                font.pixelSize: 14
                                text: "Collapsed content stays mounted when displayDirective is show."
                            }
                        }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Header Click"

                Column {
                    width: parent.width
                    spacing: 10

                    BrisaCollapse {
                        width: parent.width
                        onItemHeaderClick: function(info) {
                            root.lastHeaderClick = info.name + ":" + (info.expanded ? "open" : "close")
                        }

                        BrisaCollapseItem {
                            name: "header-click"
                            title: "Emit Header Click"

                            Text {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                color: theme.textColor2
                                font.family: theme.fontFamily
                                font.pixelSize: 14
                                text: "This mirrors Naive UI on-item-header-click."
                            }
                        }
                    }

                    Text {
                        text: root.lastHeaderClick.length > 0
                            ? ("Last: " + root.lastHeaderClick)
                            : "No header click emitted yet."
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 12
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Arrow Placement"

                Column {
                    width: parent.width
                    spacing: 12

                    BrisaCollapse {
                        width: parent.width
                        defaultValue: ["left-arrow"]

                        BrisaCollapseItem {
                            name: "left-arrow"
                            title: "Left Arrow"
                            extra: "Default"

                            Text {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                color: theme.textColor2
                                font.family: theme.fontFamily
                                font.pixelSize: 14
                                text: "The default placement keeps the arrow on the left, which is closer to Naive UI collapse headers."
                            }
                        }
                    }

                    BrisaCollapse {
                        width: parent.width
                        arrowPlacement: "right"
                        defaultValue: ["right-arrow"]

                        BrisaCollapseItem {
                            name: "right-arrow"
                            title: "Right Arrow"
                            extra: "Optional"

                            Text {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                color: theme.textColor2
                                font.family: theme.fontFamily
                                font.pixelSize: 14
                                text: "Right placement remains available when the surrounding layout needs a trailing disclosure indicator."
                            }
                        }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Right Arrow Cases"

                BrisaCollapse {
                    width: parent.width
                    arrowPlacement: "right"
                    defaultValue: ["right-meta-extra", "right-long"]

                    BrisaCollapseItem {
                        name: "right-meta-extra"
                        title: "Right Arrow With Meta And Header Extra"
                        extra: "Meta"

                        headerExtra: [
                            BrisaTag { type: "info"; bordered: false; text: "Header Extra" }
                        ]

                        Text {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            text: "This case verifies the trailing layout when meta text, header extra, and the right arrow all exist at the same time."
                        }
                    }

                    BrisaCollapseItem {
                        name: "right-long"
                        title: "A Long Title For Right Arrow Layout Validation That Should Still Leave Room For Trailing Affixes"
                        extra: "18 items"

                        headerExtra: [
                            BrisaTag { type: "warning"; bordered: false; text: "Needs Review" }
                        ]

                        Text {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            text: "This case is intended to expose premature title truncation or incorrect spacing on the trailing side."
                        }
                    }

                    BrisaCollapseItem {
                        name: "right-no-meta"
                        title: "Right Arrow With Header Extra Only"

                        headerExtra: [
                            BrisaTag { type: "success"; bordered: false; text: "Green" }
                        ]

                        Text {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            text: "This isolates the case where the right arrow and header extra coexist without meta text in between."
                        }
                    }

                    BrisaCollapseItem {
                        name: "right-no-arrow"
                        title: "Right Placement Without Arrow"
                        displayArrow: false
                        extra: "No Arrow"

                        headerExtra: [
                            BrisaTag { type: "default"; bordered: false; text: "Tag" }
                        ]

                        Text {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            text: "This confirms the trailing layout does not leave a ghost gap when arrow placement is right but the arrow is hidden."
                        }
                    }
                }
            }
        }
    }
}
