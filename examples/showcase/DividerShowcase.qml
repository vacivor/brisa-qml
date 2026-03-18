import QtQuick

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
            text: "Divider"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Visual separators aligned with Naive UI light."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Basic"

            Column {
                width: parent.width
                spacing: 0

                Text {
                    text: "Oops"
                    color: theme.textColor2
                    font.family: theme.fontFamily
                    font.pixelSize: 14
                }

                BrisaDivider {
                    width: parent.width
                }

                Text {
                    text: "Oops"
                    color: theme.textColor2
                    font.family: theme.fontFamily
                    font.pixelSize: 14
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Title"

            Column {
                width: parent.width
                spacing: 0

                Text {
                    text: "Oops"
                    color: theme.textColor2
                    font.family: theme.fontFamily
                    font.pixelSize: 14
                }

                BrisaDivider {
                    width: parent.width
                    title: "Center"
                }

                Text {
                    text: "Oops"
                    color: theme.textColor2
                    font.family: theme.fontFamily
                    font.pixelSize: 14
                }

                BrisaDivider {
                    width: parent.width
                    titlePlacement: "left"
                    title: "Left"
                }

                Text {
                    text: "Oops"
                    color: theme.textColor2
                    font.family: theme.fontFamily
                    font.pixelSize: 14
                }

                BrisaDivider {
                    width: parent.width
                    titlePlacement: "right"
                    title: "Right"
                }

                Text {
                    text: "Oops"
                    color: theme.textColor2
                    font.family: theme.fontFamily
                    font.pixelSize: 14
                }

                BrisaDivider {
                    width: parent.width
                    dashed: true
                    title: "Dashed"
                }

                Text {
                    text: "Oops"
                    color: theme.textColor2
                    font.family: theme.fontFamily
                    font.pixelSize: 14
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Vertical"

            Row {
                spacing: 0

                Text {
                    text: "It is"
                    color: theme.textColor2
                    font.family: theme.fontFamily
                    font.pixelSize: 14
                }

                BrisaDivider {
                    vertical: true
                }

                Text {
                    text: "not clear"
                    color: theme.textColor2
                    font.family: theme.fontFamily
                    font.pixelSize: 14
                }

                BrisaDivider {
                    vertical: true
                }

                Text {
                    text: "to see, emmm..."
                    color: theme.textColor2
                    font.family: theme.fontFamily
                    font.pixelSize: 14
                }
            }
        }
    }
}
