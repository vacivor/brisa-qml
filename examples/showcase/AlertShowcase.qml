import QtQuick
import QtQuick.Layouts

Item {
    id: root
    width: 900
    implicitHeight: column.implicitHeight

    Theme { id: theme }

    Component {
        id: actionSlot
        Row {
            spacing: 10
            BrisaButton { text: "Open Docs"; secondary: true }
            BrisaButton { text: "Dismiss" }
        }
    }

    Column {
        id: column
        width: parent.width
        spacing: 20

        Text {
            text: "Alert"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI inspired alert with status variants, borders, icons and closable behavior."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Basic"

            Column {
                width: parent.width
                spacing: 14

                BrisaAlert {
                    width: parent.width
                    title: "Default Alert"
                    content: "A friendly heads-up that keeps the message readable without stealing attention."
                }

                BrisaAlert {
                    width: parent.width
                    type: "info"
                    title: "Info Alert"
                    content: "This is an informational message about a product update."
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Status"

            Column {
                width: parent.width
                spacing: 14

                BrisaAlert {
                    width: parent.width
                    type: "success"
                    title: "Deployment Successful"
                    content: "All services are healthy and the latest release is now live."
                }

                BrisaAlert {
                    width: parent.width
                    type: "warning"
                    title: "Configuration Review Needed"
                    content: "One or more settings still use temporary defaults."
                }

                BrisaAlert {
                    width: parent.width
                    type: "error"
                    title: "Sync Failed"
                    content: "The server could not process your request. Please try again in a moment."
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Closable"

            Column {
                width: parent.width
                spacing: 14

                BrisaAlert {
                    width: parent.width
                    type: "info"
                    title: "Closable Alert"
                    content: "You can close this alert from the action in the top-right corner."
                    closable: true
                }

                BrisaAlert {
                    width: parent.width
                    type: "warning"
                    content: "This alert has no title, so the close affordance should still feel balanced."
                    closable: true
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Borderless And Custom Content"

            Column {
                width: parent.width
                spacing: 14

                BrisaAlert {
                    width: parent.width
                    type: "success"
                    bordered: false
                    title: "Borderless Alert"
                    content: "Useful when the background color already carries enough hierarchy."
                }

                BrisaAlert {
                    width: parent.width
                    type: "info"
                    title: "With Action"
                    content: "Pair secondary actions with clear alert content when the user may want to continue the workflow."
                    bodyComponent: actionSlot
                }
            }
        }
    }
}
