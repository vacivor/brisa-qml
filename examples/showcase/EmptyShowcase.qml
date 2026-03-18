import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: root
    width: 900
    implicitHeight: column.implicitHeight

    Theme { id: theme }

    Component {
        id: searchIcon

        Item {
            implicitWidth: 80
            implicitHeight: 80

            Rectangle {
                width: 58
                height: 46
                radius: 8
                x: 10
                y: 14
                color: Qt.rgba(1, 1, 1, 0.98)
                border.color: Qt.rgba(theme.textColor3.r, theme.textColor3.g, theme.textColor3.b, 0.16)
                border.width: 1
            }

            Rectangle {
                width: 18
                height: 5
                radius: 2
                x: 30
                y: 24
                color: Qt.rgba(theme.infoColor.r, theme.infoColor.g, theme.infoColor.b, 0.12)
            }

            Rectangle {
                width: 26
                height: 2
                radius: 1
                x: 26
                y: 35
                color: Qt.rgba(theme.textColor3.r, theme.textColor3.g, theme.textColor3.b, 0.18)
            }

            Rectangle {
                width: 18
                height: 2
                radius: 1
                x: 30
                y: 43
                color: Qt.rgba(theme.textColor3.r, theme.textColor3.g, theme.textColor3.b, 0.12)
            }

            Rectangle {
                width: 32
                height: 32
                radius: 16
                x: 40
                y: 34
                color: Qt.rgba(theme.infoColor.r, theme.infoColor.g, theme.infoColor.b, 0.08)
                border.color: Qt.rgba(theme.infoColor.r, theme.infoColor.g, theme.infoColor.b, 0.22)
                border.width: 1
                antialiasing: true
            }

            Shape {
                anchors.fill: parent
                antialiasing: true

                ShapePath {
                    strokeColor: theme.infoColor
                    strokeWidth: 3
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin
                    startX: 48
                    startY: 48
                    PathArc { x: 62; y: 48; radiusX: 7; radiusY: 7; useLargeArc: true }
                    PathArc { x: 48; y: 48; radiusX: 7; radiusY: 7; useLargeArc: true }
                }

                ShapePath {
                    strokeColor: theme.infoColor
                    strokeWidth: 3
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    startX: 60
                    startY: 60
                    PathLine { x: 68; y: 68 }
                }
            }

            Rectangle {
                width: 8
                height: 8
                radius: 4
                x: 16
                y: 54
                color: Qt.rgba(theme.warningColor.r, theme.warningColor.g, theme.warningColor.b, 0.10)
                border.color: Qt.rgba(theme.warningColor.r, theme.warningColor.g, theme.warningColor.b, 0.18)
                border.width: 1
                antialiasing: true
            }
        }
    }

    Component {
        id: actionSlot
        BrisaButton {
            text: "Create First Item"
            type: "primary"
        }
    }

    Column {
        id: column
        width: parent.width
        spacing: 20

        Text {
            text: "Empty"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI inspired empty state with soft illustration, description and optional action."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Basic"

            BrisaEmpty {
                width: parent.width
            }
        }

        BrisaCard {
            width: parent.width
            title: "Description"

            BrisaEmpty {
                width: parent.width
                title: "No Projects Yet"
                description: "Start by creating your first project, then invite teammates and connect data sources when you are ready."
                action: actionSlot
            }
        }

        BrisaCard {
            width: parent.width
            title: "Custom Icon"

            BrisaEmpty {
                width: parent.width
                title: "No Search Results"
                description: "We couldn't find anything matching your filters. Try a broader keyword or clear some conditions."
                iconComponent: searchIcon
            }
        }

        BrisaCard {
            width: parent.width
            title: "Sizes"

            RowLayout {
                width: parent.width
                spacing: 16

                BrisaCard {
                    Layout.fillWidth: true
                    embedded: true
                    title: "Small"

                    BrisaEmpty {
                        width: parent.width
                        size: "small"
                        title: "No Notifications"
                        description: "You're all caught up."
                    }
                }

                BrisaCard {
                    Layout.fillWidth: true
                    embedded: true
                    title: "Medium"

                    BrisaEmpty {
                        width: parent.width
                        size: "medium"
                        title: "No Drafts"
                        description: "Drafts you create will appear here."
                    }
                }

                BrisaCard {
                    Layout.fillWidth: true
                    embedded: true
                    title: "Large"

                    BrisaEmpty {
                        width: parent.width
                        size: "large"
                        title: "Nothing Scheduled"
                        description: "When events are added, this timeline will begin to populate."
                    }
                }
            }
        }
    }
}
