import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: root
    width: 900
    implicitHeight: column.implicitHeight

    Theme { id: theme }

    property bool wrappedSpinning: false
    property bool describedSpinning: true
    property bool delayedSpinning: false
    property bool customIconSpinning: true

    Column {
        id: column
        width: parent.width
        spacing: 20

        Text {
            text: "Spin"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Loading overlays and inline spinners aligned with Naive UI light."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Basic"

            Row {
                spacing: 20

                BrisaSpin { size: "small" }
                BrisaSpin { size: "medium" }
                BrisaSpin { size: "large" }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Inline"

            Row {
                spacing: 20

                BrisaSpin {
                    size: "small"
                    description: "Loading"
                }

                BrisaSpin {
                    size: "medium"
                    color: theme.infoColor
                    textColor: theme.infoColor
                    description: "Fetching"
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Wrap"

            Column {
                width: parent.width
                spacing: 12

                BrisaSpin {
                    width: parent.width
                    show: wrappedSpinning
                    overlayColor: Qt.rgba(theme.baseColor.r, theme.baseColor.g, theme.baseColor.b, 0.78)

                    BrisaCard {
                        width: parent.width
                        title: "Wrapped Content"
                        bordered: true
                        Text {
                            text: "Leave it till tomorrow to unpack my case. Honey disconnect the phone."
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }
                    }
                }

                BrisaButton {
                    text: wrappedSpinning ? "Stop Spin" : "Start Spin"
                    onClicked: wrappedSpinning = !wrappedSpinning
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Description"

            Column {
                width: parent.width
                spacing: 12

                BrisaSpin {
                    width: parent.width
                    show: describedSpinning
                    description: "You know how lucky you are."
                    overlayColor: Qt.rgba(theme.baseColor.r, theme.baseColor.g, theme.baseColor.b, 0.78)

                    BrisaCard {
                        width: parent.width
                        title: "Status"
                        bordered: true
                        Text {
                            text: "Spin can dim wrapped content and place description under the loader."
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }
                    }
                }

                BrisaButton {
                    text: describedSpinning ? "Hide Description Spin" : "Show Description Spin"
                    onClicked: describedSpinning = !describedSpinning
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Delay"

            Column {
                width: parent.width
                spacing: 12

                BrisaSpin {
                    width: parent.width
                    show: delayedSpinning
                    delay: 1000
                    overlayColor: Qt.rgba(theme.baseColor.r, theme.baseColor.g, theme.baseColor.b, 0.78)

                    BrisaCard {
                        width: parent.width
                        title: "Delayed Overlay"
                        bordered: true
                        Text {
                            text: "If loading ends before the delay finishes, the spinner never appears."
                            color: theme.textColor2
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }
                    }
                }

                Row {
                    spacing: 12

                    BrisaButton {
                        text: delayedSpinning ? "Stop Delayed Spin" : "Start Delayed Spin"
                        onClicked: delayedSpinning = !delayedSpinning
                    }

                    BrisaButton {
                        tertiary: true
                        text: "Quick Flash"
                        onClicked: {
                            delayedSpinning = true
                            quickStop.restart()
                        }
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Custom Icon"

            Column {
                width: parent.width
                spacing: 12

                BrisaSpin {
                    show: customIconSpinning
                    size: 34
                    color: theme.primaryColor
                    iconComponent: customSpinIcon
                    description: "Custom icon"
                }

                BrisaButton {
                    text: customIconSpinning ? "Stop Custom Spin" : "Start Custom Spin"
                    onClicked: customIconSpinning = !customIconSpinning
                }
            }
        }
    }

    Timer {
        id: quickStop
        interval: 300
        repeat: false
        onTriggered: delayedSpinning = false
    }

    Component {
        id: customSpinIcon
        BrisaIcon {
            size: 34
            color: theme.primaryColor

            Item {
                id: customSpinRoot
                property color iconColor: theme.primaryColor

                Shape {
                    id: customSpinShape
                    anchors.fill: parent
                    antialiasing: true

                    ShapePath {
                        strokeColor: customSpinRoot.iconColor
                        strokeWidth: Math.max(1.8, customSpinShape.width * 0.1)
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        joinStyle: ShapePath.RoundJoin

                        startX: customSpinShape.width * 0.5
                        startY: customSpinShape.height * 0.14

                        PathLine {
                            x: customSpinShape.width * 0.5
                            y: customSpinShape.height * 0.86
                        }
                    }

                    ShapePath {
                        strokeColor: customSpinRoot.iconColor
                        strokeWidth: Math.max(1.8, customSpinShape.width * 0.1)
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        joinStyle: ShapePath.RoundJoin

                        startX: customSpinShape.width * 0.14
                        startY: customSpinShape.height * 0.5

                        PathLine {
                            x: customSpinShape.width * 0.86
                            y: customSpinShape.height * 0.5
                        }
                    }

                    ShapePath {
                        strokeColor: customSpinRoot.iconColor
                        strokeWidth: Math.max(1.4, customSpinShape.width * 0.08)
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        joinStyle: ShapePath.RoundJoin

                        startX: customSpinShape.width * 0.26
                        startY: customSpinShape.height * 0.26

                        PathLine {
                            x: customSpinShape.width * 0.74
                            y: customSpinShape.height * 0.74
                        }
                    }

                    ShapePath {
                        strokeColor: customSpinRoot.iconColor
                        strokeWidth: Math.max(1.4, customSpinShape.width * 0.08)
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        joinStyle: ShapePath.RoundJoin

                        startX: customSpinShape.width * 0.74
                        startY: customSpinShape.height * 0.26

                        PathLine {
                            x: customSpinShape.width * 0.26
                            y: customSpinShape.height * 0.74
                        }
                    }
                }
            }
        }
    }
}
