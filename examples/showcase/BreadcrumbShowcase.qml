import QtQuick
import QtQuick.Layouts

Item {
    id: root
    width: 900
    implicitHeight: column.implicitHeight

    Theme {
        id: theme
    }

    property string eventText: "No navigation yet"

    Component {
        id: homeIcon
        BrisaIcon {
            size: 16
            Text {
                property color iconColor: theme.textColor3
                text: "⌂"
                color: iconColor
                font.family: theme.fontFamily
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Component {
        id: folderIcon
        BrisaIcon {
            size: 16
            Text {
                property color iconColor: theme.textColor3
                text: "▣"
                color: iconColor
                font.family: theme.fontFamily
                font.pixelSize: 13
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Column {
        id: column
        width: parent.width
        spacing: 20

        Text {
            text: "Breadcrumb"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI style breadcrumb with link hover, active item, icons and separators."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Basic"

            BrisaBreadcrumb {
                onNavigate: function(index, label) { root.eventText = "navigate(" + index + ", " + label + ")" }

                BrisaBreadcrumbItem { label: "Home" }
                BrisaBreadcrumbItem { label: "Components" }
                BrisaBreadcrumbItem { label: "Breadcrumb" }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Custom Separator"

            BrisaBreadcrumb {
                separator: ">"

                BrisaBreadcrumbItem { label: "Workspace" }
                BrisaBreadcrumbItem { label: "Design System" }
                BrisaBreadcrumbItem { label: "Navigation" }
            }
        }

        BrisaCard {
            width: parent.width
            title: "With Icons"

            BrisaBreadcrumb {
                BrisaBreadcrumbItem { label: "Home"; icon: homeIcon }
                BrisaBreadcrumbItem { label: "Library"; icon: folderIcon }
                BrisaBreadcrumbItem { label: "Breadcrumb"; icon: folderIcon }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Event"

            Column {
                width: parent.width
                spacing: 12

                BrisaBreadcrumb {
                    onNavigate: function(index, label) { root.eventText = "navigate(" + index + ", " + label + ")" }

                    BrisaBreadcrumbItem { label: "Dashboard" }
                    BrisaBreadcrumbItem { label: "Analytics" }
                    BrisaBreadcrumbItem { label: "Retention" }
                }

                Text {
                    text: root.eventText
                    color: theme.textColor3
                    font.family: theme.fontFamily
                    font.pixelSize: 12
                }
            }
        }
    }
}
