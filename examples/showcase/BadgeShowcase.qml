import QtQuick
import QtQuick.Layouts

Item {
    id: root
    width: 900
    implicitHeight: contentColumn.implicitHeight

    property int badgeValue: 5
    property bool badgeVisible: true
    property int overflowValue: 101
    property int zeroValue: 0

    Theme { id: theme }

    Column {
        id: contentColumn
        width: parent.width
        spacing: 20

        Text {
            text: "Badge"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI style badge with value, dot, processing, overflow and offset."
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

                Row {
                    spacing: 24

                    BrisaBadge {
                        value: root.badgeValue
                        max: 15
                        BrisaAvatar { text: "A"; round: true }
                    }

                    BrisaBadge {
                        value: root.badgeValue
                        dot: true
                        BrisaAvatar { text: "B"; round: true }
                    }

                    BrisaButtonGroup {
                        BrisaButton {
                            text: "+"
                            onClicked: root.badgeValue = Math.min(16, root.badgeValue + 1)
                        }
                        BrisaButton {
                            text: "-"
                            onClicked: root.badgeValue = Math.max(0, root.badgeValue - 1)
                        }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Type"

                Row {
                    spacing: 24

                    BrisaBadge { dot: true; BrisaAvatar { text: "A"; round: true } }
                    BrisaBadge { dot: true; type: "error"; BrisaAvatar { text: "B"; round: true } }
                    BrisaBadge { dot: true; type: "info"; BrisaAvatar { text: "C"; round: true } }
                    BrisaBadge { dot: true; type: "success"; BrisaAvatar { text: "D"; round: true } }
                    BrisaBadge { dot: true; type: "warning"; BrisaAvatar { text: "E"; round: true } }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Custom Content"

                Row {
                    spacing: 24

                    BrisaBadge {
                        value: "new"
                        BrisaAvatar { text: "N"; round: true }
                    }

                    BrisaBadge {
                        value: "hot"
                        BrisaAvatar { text: "H"; round: true }
                    }

                    BrisaBadge {
                        processing: true
                        BrisaAvatar { text: "L"; round: true }
                        badgeContent: [
                            Image {
                                width: 12
                                height: 12
                                source: theme.svgClose("#ffffff", 12)
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }
                        ]
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Controlled Visibility"

                Row {
                    spacing: 24

                    BrisaBadge {
                        value: root.badgeValue
                        max: 15
                        show: root.badgeVisible
                        BrisaAvatar { text: "V"; round: true }
                    }

                    BrisaBadge {
                        value: root.badgeValue
                        dot: true
                        show: root.badgeVisible
                        BrisaAvatar { text: "D"; round: true }
                    }

                    BrisaSwitch {
                        value: root.badgeVisible
                        onUpdateValue: function(value) { root.badgeVisible = value }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Offset"

                Row {
                    spacing: 24

                    BrisaBadge {
                        value: root.badgeValue
                        max: 15
                        offset: [-17, 17]
                        BrisaAvatar { text: "O"; round: true }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Overflow"

                Row {
                    spacing: 24

                    BrisaBadge {
                        value: root.overflowValue
                        showZero: true
                        BrisaAvatar { text: "A"; round: true }
                    }

                    BrisaBadge {
                        value: root.overflowValue
                        max: 99
                        BrisaAvatar { text: "B"; round: true }
                    }

                    BrisaBadge {
                        value: root.overflowValue
                        showZero: true
                        max: 100
                        BrisaAvatar { text: "C"; round: true }
                    }

                    BrisaBadge {
                        value: root.overflowValue
                        showZero: true
                        max: 10
                        BrisaAvatar { text: "D"; round: true }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Show Zero"

                Row {
                    spacing: 24

                    BrisaBadge {
                        value: root.zeroValue
                        BrisaAvatar { text: "0"; round: true }
                    }

                    BrisaBadge {
                        value: root.zeroValue
                        showZero: true
                        BrisaAvatar { text: "0"; round: true }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Processing"

                Row {
                    spacing: 24

                    BrisaBadge {
                        dot: true
                        processing: true
                        BrisaAvatar { text: "P"; round: true }
                    }

                    BrisaBadge {
                        value: 20
                        processing: true
                        BrisaAvatar { text: "P"; round: true }
                    }

                    BrisaBadge {
                        dot: true
                        type: "info"
                        processing: true
                        BrisaAvatar { text: "I"; round: true }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Raw"

                Row {
                    spacing: 24

                    BrisaBadge {
                        value: root.badgeValue
                        max: 15
                    }

                    BrisaBadge {
                        value: root.badgeValue
                        dot: true
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Color"

                Row {
                    spacing: 24

                    BrisaBadge {
                        value: "15"
                        color: "grey"
                        BrisaAvatar { text: "G"; round: true }
                    }
                }
            }
        }
    }
}
