import QtQuick
import QtQuick.Layouts

Item {
    id: root
    width: 900
    implicitHeight: contentColumn.implicitHeight
    property int gridGap: 16
    property bool collapsedDemo: false

    Component {
        id: chartIcon
        BrisaIcon {
            size: 18
            Text {
                property color iconColor: "#1f1f1f"
                text: "◔"
                color: iconColor
                font.family: "Space Grotesk"
                font.pixelSize: width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Component {
        id: teamIcon
        BrisaIcon {
            size: 18
            Text {
                property color iconColor: "#1f1f1f"
                text: "◉"
                color: iconColor
                font.family: "Space Grotesk"
                font.pixelSize: width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Component {
        id: fileIcon
        BrisaIcon {
            size: 18
            Text {
                property color iconColor: "#1f1f1f"
                text: "□"
                color: iconColor
                font.family: "Space Grotesk"
                font.pixelSize: width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Component {
        id: shieldIcon
        BrisaIcon {
            size: 18
            Text {
                property color iconColor: "#1f1f1f"
                text: "◇"
                color: iconColor
                font.family: "Space Grotesk"
                font.pixelSize: width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

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
            text: "Menu"
            color: "#0f172a"
            font.family: "Space Grotesk"
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI style menu with groups and nested items."
            color: "#64748b"
            font.family: "Space Grotesk"
            font.pixelSize: 12
        }

        Text {
            text: "Variants"
            color: "#0f172a"
            font.family: "Space Grotesk"
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }

        Row {
            spacing: 12

            Text {
                text: "Collapsed"
                color: "#334155"
                font.family: "Space Grotesk"
                font.pixelSize: 13
                verticalAlignment: Text.AlignVCenter
            }

            BrisaSwitch {
                value: root.collapsedDemo
                onUpdateValue: function(v) { root.collapsedDemo = v }
            }
        }

        GridLayout {
            width: parent.width
            columnSpacing: gridGap
            rowSpacing: gridGap
            columns: columnsFor(width, 300, columnSpacing)

            BrisaCard {
                Layout.preferredWidth: root.collapsedDemo ? 96 : 320
                Layout.fillWidth: false
                title: "Sidebar Menu"
                BrisaMenu {
                    width: parent.width
                    collapsed: root.collapsedDemo
                    items: [
                        { type: "group", label: "Overview", children: [
                            { key: "dashboard", label: "Dashboard", extra: "⌘1", icon: chartIcon },
                            { key: "activity", label: "Activity", extra: "12", icon: fileIcon }
                        ]},
                        { type: "group", label: "Workspace", children: [
                            { key: "projects", label: "Projects", icon: fileIcon },
                            { key: "members", label: "Members", icon: teamIcon, children: [
                                { key: "owners", label: "Owners", icon: teamIcon },
                                { key: "guests", label: "Guests", icon: teamIcon }
                            ]},
                            { key: "billing", label: "Billing", disabled: true, icon: shieldIcon }
                        ]},
                        { type: "group", label: "Settings", children: [
                            { key: "profile", label: "Profile", icon: fileIcon },
                            { key: "security", label: "Security", icon: shieldIcon }
                        ]}
                    ]
                    currentKey: "owners"
                }
            }

            BrisaCard {
                Layout.preferredWidth: root.collapsedDemo ? 96 : 320
                Layout.fillWidth: false
                title: "Long Labels"
                BrisaMenu {
                    width: parent.width
                    collapsed: root.collapsedDemo
                    items: [
                        { type: "group", label: "Documentation", children: [
                            { key: "guides", label: "Getting Started and Workspace Guides", extra: "23", icon: fileIcon },
                            { key: "release", label: "Release Notes and Migration Announcements", icon: chartIcon }
                        ]},
                        { type: "group", label: "Operations", children: [
                            { key: "incident", label: "Incident Escalation and On-call Policies", icon: shieldIcon },
                            { key: "compliance", label: "Compliance and Audit Reports", disabled: true, icon: fileIcon }
                        ]}
                    ]
                    currentKey: "guides"
                }
            }

            BrisaCard {
                Layout.preferredWidth: root.collapsedDemo ? 96 : 320
                Layout.fillWidth: false
                title: "Nested Structure"
                BrisaMenu {
                    width: parent.width
                    collapsed: root.collapsedDemo
                    items: [
                        { key: "workspace", label: "Workspace", icon: teamIcon, children: [
                            { key: "engineering", label: "Engineering", icon: chartIcon, children: [
                                { key: "frontend", label: "Frontend", icon: fileIcon },
                                { key: "backend", label: "Backend", icon: fileIcon }
                            ]},
                            { key: "design", label: "Design", icon: chartIcon, children: [
                                { key: "system", label: "Design System", icon: fileIcon },
                                { key: "research", label: "Research", icon: fileIcon }
                            ]}
                        ]},
                        { key: "archive", label: "Archive", disabled: true, icon: shieldIcon }
                    ]
                    currentKey: "system"
                }
            }

            BrisaCard {
                Layout.preferredWidth: root.collapsedDemo ? 96 : 320
                Layout.fillWidth: false
                title: "Dense Utility Menu"
                BrisaMenu {
                    width: parent.width
                    collapsed: root.collapsedDemo
                    items: [
                        { key: "overview", label: "Overview", extra: "A", icon: chartIcon },
                        { key: "inbox", label: "Inbox", extra: "9", icon: fileIcon },
                        { key: "mentions", label: "Mentions", extra: "3", icon: teamIcon },
                        { key: "drafts", label: "Drafts", icon: fileIcon },
                        { key: "trash", label: "Trash", disabled: true, icon: shieldIcon }
                    ]
                    currentKey: "inbox"
                }
            }

            BrisaCard {
                Layout.preferredWidth: root.collapsedDemo ? 96 : 320
                Layout.fillWidth: false
                title: "Icon Menu"
                BrisaMenu {
                    width: parent.width
                    collapsed: root.collapsedDemo
                    items: [
                        { key: "analytics", label: "Analytics", icon: chartIcon, extra: "New" },
                        { key: "documents", label: "Documents", icon: fileIcon },
                        { key: "community", label: "Community", icon: teamIcon },
                        { key: "security", label: "Security", icon: shieldIcon }
                    ]
                    currentKey: "analytics"
                }
            }

            BrisaCard {
                Layout.preferredWidth: root.collapsedDemo ? 96 : 320
                Layout.fillWidth: false
                title: "Indent Reference"
                BrisaMenu {
                    width: parent.width
                    collapsed: root.collapsedDemo
                    items: [
                        { type: "group", label: "Group Label", children: [
                            { key: "group-item", label: "Group Item" },
                            { key: "group-submenu", label: "Group Submenu", children: [
                                { key: "group-submenu-item", label: "Group Submenu Item" }
                            ]}
                        ]},
                        { key: "root-submenu", label: "Root Submenu", children: [
                            { key: "submenu-item", label: "Submenu Item" },
                            { key: "submenu-submenu", label: "Submenu Submenu", children: [
                                { key: "submenu-submenu-item", label: "Submenu Submenu Item" }
                            ]}
                        ]}
                    ]
                    currentKey: "submenu-submenu-item"
                }
            }
        }
    }
}
