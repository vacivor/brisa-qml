import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: root
    width: 900
    implicitHeight: column.implicitHeight

    Theme { id: theme }

    Component {
        id: ringIcon
        Item {
            id: ringRoot
            property color iconColor: theme.textColor1

            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: "transparent"
                border.color: ringRoot.iconColor
                border.width: Math.max(1.5, width * 0.1)
                antialiasing: true
            }

            Rectangle {
                width: Math.max(4, parent.width * 0.24)
                height: width
                radius: width / 2
                color: ringRoot.iconColor
                antialiasing: true
                anchors.centerIn: parent
            }
        }
    }

    Component {
        id: sparkleIcon
        Item {
            id: sparkleRoot
            property color iconColor: theme.textColor1

            Shape {
                id: sparkleShape
                anchors.fill: parent
                antialiasing: true

                ShapePath {
                    strokeColor: sparkleRoot.iconColor
                    strokeWidth: Math.max(1.8, sparkleShape.width * 0.12)
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin

                    startX: sparkleShape.width * 0.5
                    startY: sparkleShape.height * 0.12

                    PathLine {
                        x: sparkleShape.width * 0.5
                        y: sparkleShape.height * 0.88
                    }
                }

                ShapePath {
                    strokeColor: sparkleRoot.iconColor
                    strokeWidth: Math.max(1.8, sparkleShape.width * 0.12)
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin

                    startX: sparkleShape.width * 0.12
                    startY: sparkleShape.height * 0.5

                    PathLine {
                        x: sparkleShape.width * 0.88
                        y: sparkleShape.height * 0.5
                    }
                }

                ShapePath {
                    strokeColor: sparkleRoot.iconColor
                    strokeWidth: Math.max(1.4, sparkleShape.width * 0.09)
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin

                    startX: sparkleShape.width * 0.26
                    startY: sparkleShape.height * 0.26

                    PathLine {
                        x: sparkleShape.width * 0.74
                        y: sparkleShape.height * 0.74
                    }
                }

                ShapePath {
                    strokeColor: sparkleRoot.iconColor
                    strokeWidth: Math.max(1.4, sparkleShape.width * 0.09)
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin

                    startX: sparkleShape.width * 0.74
                    startY: sparkleShape.height * 0.26

                    PathLine {
                        x: sparkleShape.width * 0.26
                        y: sparkleShape.height * 0.74
                    }
                }
            }
        }
    }

    Component {
        id: plusIcon
        Item {
            id: plusRoot
            property color iconColor: theme.textColor1

            Shape {
                id: plusShape
                anchors.fill: parent
                antialiasing: true

                ShapePath {
                    strokeColor: plusRoot.iconColor
                    strokeWidth: Math.max(1.8, plusShape.width * 0.12)
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin

                    startX: plusShape.width * 0.5
                    startY: plusShape.height * 0.2

                    PathLine {
                        x: plusShape.width * 0.5
                        y: plusShape.height * 0.8
                    }
                }

                ShapePath {
                    strokeColor: plusRoot.iconColor
                    strokeWidth: Math.max(1.8, plusShape.width * 0.12)
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin

                    startX: plusShape.width * 0.2
                    startY: plusShape.height * 0.5

                    PathLine {
                        x: plusShape.width * 0.8
                        y: plusShape.height * 0.5
                    }
                }
            }
        }
    }

    Component {
        id: checkIcon
        Item {
            id: checkRoot
            property color iconColor: theme.baseColor

            Image {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                source: theme.svgCheck(checkRoot.iconColor, Math.max(width, height))
                smooth: true
                mipmap: true
            }
        }
    }

    Component {
        id: dotIcon
        Item {
            property color iconColor: theme.textColor1

            Rectangle {
                width: Math.max(4, parent.width * 0.28)
                height: width
                radius: width / 2
                anchors.centerIn: parent
                color: parent.iconColor
                antialiasing: true
            }
        }
    }

    Column {
        id: column
        width: parent.width
        spacing: 20

        Text {
            text: "Icon"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Inline icons and icon wrappers aligned with Naive UI light."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Inline"

            Column {
                width: parent.width
                spacing: 14

                Row {
                    spacing: 10

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Realtime metrics"
                        color: theme.textColor1
                        font.family: theme.fontFamily
                        font.pixelSize: 16
                    }

                    BrisaIcon {
                        anchors.verticalCenter: parent.verticalCenter
                        size: 16
                        depth: 3
                        component: dotIcon
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Synced with workspace"
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 16
                    }
                }

                Flow {
                    width: parent.width
                    spacing: 14

                    Repeater {
                        model: [16, 20, 24, 32, 40]
                        delegate: BrisaIcon {
                            size: modelData
                            component: sparkleIcon
                        }
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Basic"

            Flow {
                width: parent.width
                spacing: 18

                BrisaIcon {
                    size: 40
                    component: sparkleIcon
                }
                BrisaIcon {
                    size: 40
                    color: "#0e7a0d"
                    component: sparkleIcon
                }
                BrisaIcon {
                    size: 40
                    component: ringIcon
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Component"

            Flow {
                width: parent.width
                spacing: 18

                BrisaIcon {
                    size: 24
                    component: ringIcon
                }

                BrisaIcon {
                    size: 32
                    color: theme.primaryColor
                    component: ringIcon
                }

                BrisaIcon {
                    size: 40
                    depth: 2
                    component: ringIcon
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Depth"

            Flow {
                width: parent.width
                spacing: 18

                Repeater {
                    model: [1, 2, 3, 4, 5]
                    delegate: BrisaIcon {
                        size: 40
                        depth: modelData
                        component: sparkleIcon
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Custom Icon"

            Flow {
                width: parent.width
                spacing: 18

                BrisaIcon {
                    size: 40
                    component: plusIcon
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Icon Wrapper"

            Flow {
                width: parent.width
                spacing: 18

                BrisaIconWrapper {
                    size: 24
                    borderRadius: 10

                    BrisaIcon {
                        anchors.centerIn: parent
                        size: 18
                        component: checkIcon
                    }
                }

                BrisaIconWrapper {
                    size: 28
                    borderRadius: 12
                    color: theme.infoColor

                    BrisaIcon {
                        anchors.centerIn: parent
                        size: 18
                        Text {
                            property color iconColor: theme.baseColor
                            text: "i"
                            color: iconColor
                            font.family: theme.fontFamily
                            font.pixelSize: width
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                BrisaIconWrapper {
                    size: 32
                    borderRadius: 16
                    color: Qt.rgba(theme.warningColor.r, theme.warningColor.g, theme.warningColor.b, 0.14)
                    iconColor: theme.warningColor

                    BrisaIcon {
                        anchors.centerIn: parent
                        size: 18
                        Text {
                            property color iconColor: theme.warningColor
                            text: "!"
                            color: iconColor
                            font.family: theme.fontFamily
                            font.pixelSize: width
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }
    }
}
