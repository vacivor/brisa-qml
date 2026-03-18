import QtQuick
import QtQuick.Layouts

Item {
    id: root
    width: 900
    implicitHeight: contentColumn.implicitHeight

    property string lastErrorSource: ""

    readonly property string demoAvatarSource: "data:image/svg+xml;utf8," +
        "<svg xmlns='http://www.w3.org/2000/svg' width='96' height='96' viewBox='0 0 96 96' fill='none'>" +
        "<rect width='96' height='96' rx='24' fill='%235b8def'/>" +
        "<circle cx='48' cy='36' r='16' fill='%23dbeafe'/>" +
        "<path d='M24 86c4-16 17-24 24-24s20 8 24 24' fill='%23eff6ff'/>" +
        "</svg>"

    readonly property string wideAvatarSource: "data:image/svg+xml;utf8," +
        "<svg xmlns='http://www.w3.org/2000/svg' width='160' height='96' viewBox='0 0 160 96' fill='none'>" +
        "<rect width='160' height='96' rx='24' fill='%231e40af'/>" +
        "<circle cx='48' cy='42' r='18' fill='%23bfdbfe'/>" +
        "<path d='M24 88c6-20 21-30 36-30s30 10 36 30' fill='%23eff6ff'/>" +
        "<rect x='96' y='20' width='44' height='44' rx='12' fill='%2360a5fa'/>" +
        "</svg>"

    Theme { id: theme }

    Column {
        id: contentColumn
        width: parent.width
        spacing: 20

        Text {
            text: "Avatar"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI style avatar with size, round, color, fallback and group behavior."
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
                title: "Size"

                Row {
                    spacing: 12

                    BrisaAvatar { size: "small"; src: root.demoAvatarSource }
                    BrisaAvatar { size: "medium"; src: root.demoAvatarSource }
                    BrisaAvatar { size: "large"; src: root.demoAvatarSource }
                    BrisaAvatar { size: 48; src: root.demoAvatarSource }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Shape"

                Row {
                    spacing: 12

                    BrisaAvatar { round: true; size: "small"; src: root.demoAvatarSource }
                    BrisaAvatar { round: true; size: "medium"; src: root.demoAvatarSource }
                    BrisaAvatar { round: true; size: "large"; src: root.demoAvatarSource }
                    BrisaAvatar { round: true; size: 48; src: root.demoAvatarSource }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Bordered"

                Row {
                    spacing: 12

                    BrisaAvatar { bordered: true; src: root.demoAvatarSource }
                    BrisaAvatar { bordered: true; round: true; src: root.demoAvatarSource }
                    BrisaAvatar { bordered: true; text: "Oasis" }
                    BrisaAvatar { bordered: true; round: true; text: "Oasis" }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Color"

                Row {
                    spacing: 12

                    BrisaAvatar {
                        text: "M"
                        color: "red"
                        textColor: "yellow"
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Icon"

                Row {
                    spacing: 12

                    BrisaAvatar { }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Content Size"

                Row {
                    spacing: 12

                    BrisaAvatar { text: "Oasis" }
                    BrisaAvatar { round: true; text: "Oasis" }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Fallback"

                Row {
                    spacing: 12

                    BrisaAvatar {
                        round: true
                        size: "small"
                        fallbackSrc: root.demoAvatarSource
                        loadFailed: true
                        usingFallbackSrc: true
                    }

                    BrisaAvatar {
                        size: "large"
                        src: root.demoAvatarSource
                        placeholder: Rectangle {
                            color: theme.hoverColor
                            radius: theme.borderRadius
                        }
                    }

                    BrisaAvatar {
                        size: "large"
                        loadFailed: true
                        fallback: Rectangle {
                            color: theme.errorColor
                            radius: theme.borderRadius

                            Text {
                                anchors.centerIn: parent
                                text: "!"
                                color: "#ffffff"
                                font.family: theme.fontFamily
                                font.pixelSize: 18
                                font.weight: Font.DemiBold
                            }
                        }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Object Fit"

                Row {
                    spacing: 12

                    BrisaAvatar { size: 48; src: root.wideAvatarSource; objectFit: "fill" }
                    BrisaAvatar { size: 48; src: root.wideAvatarSource; objectFit: "contain" }
                    BrisaAvatar { size: 48; src: root.wideAvatarSource; objectFit: "cover" }
                    BrisaAvatar { size: 48; src: root.wideAvatarSource; objectFit: "none" }
                    BrisaAvatar { size: 48; src: root.wideAvatarSource; objectFit: "scale-down" }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Error Signal"

                Column {
                    width: parent.width
                    spacing: 10

                    BrisaAvatar {
                        id: errorAvatar
                        round: true
                        size: "large"
                        src: ""
                        onError: function(source) {
                            root.lastErrorSource = source
                        }
                    }

                    BrisaButton {
                        text: "Trigger Error"
                        type: "tertiary"
                        onClicked: errorAvatar.error("manual://demo")
                    }

                    Text {
                        width: parent.width
                        text: root.lastErrorSource.length > 0
                            ? ("Last error source: " + root.lastErrorSource)
                            : "No error emitted yet."
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 12
                        wrapMode: Text.Wrap
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Group"

                Column {
                    width: parent.width
                    spacing: 14

                    BrisaAvatarGroup {
                        size: 40
                        max: 3

                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Leonardo DiCaprio" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Jennifer Lawrence" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Audrey Hepburn" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Anne Hathaway" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Taylor Swift" }
                    }

                    BrisaAvatarGroup {
                        size: 40
                        max: 3
                        expandOnHover: true

                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Leonardo DiCaprio" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Jennifer Lawrence" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Audrey Hepburn" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Anne Hathaway" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Taylor Swift" }
                    }

                    Text {
                        text: "Hover the second group to expand hidden avatars."
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: 12
                    }

                    BrisaAvatarGroup {
                        size: 40
                        max: 3
                        rest: Component {
                            Item {
                                id: restItem
                                property int rest: 0
                                property var options: []
                                property bool open: false

                                width: 40
                                height: 40

                                BrisaAvatar {
                                    id: restAvatar
                                    anchors.fill: parent
                                    color: theme.textColor2
                                    text: "+" + parent.rest
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: parent.open = !parent.open
                                }

                                BrisaPopover {
                                    target: restAvatar
                                    open: restItem.open
                                    placement: "top"
                                    popupWidth: 180
                                    showArrow: true
                                    outsideClosable: true
                                    blocksUnderlay: true
                                    onCloseRequested: restItem.open = false

                                    Column {
                                        spacing: 0

                                        Repeater {
                                            model: restItem.options

                                            delegate: Rectangle {
                                                required property var modelData
                                                width: 156
                                                height: 40
                                                color: rowHover.containsMouse ? theme.hoverColor : "transparent"
                                                radius: theme.borderRadius

                                                Row {
                                                    anchors.fill: parent
                                                    anchors.leftMargin: 8
                                                    anchors.rightMargin: 8
                                                    spacing: 8

                                                    BrisaAvatar {
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        size: "small"
                                                        round: modelData.round
                                                        src: modelData.src || ""
                                                        name: modelData.name || ""
                                                        text: modelData.text || ""
                                                        color: modelData.color || theme.hoverColor
                                                    }

                                                    Text {
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        width: Math.max(0, parent.width - 36)
                                                        text: modelData.name || modelData.text || ""
                                                        color: theme.textColor2
                                                        font.family: theme.fontFamily
                                                        font.pixelSize: 12
                                                        elide: Text.ElideRight
                                                    }
                                                }

                                                MouseArea {
                                                    id: rowHover
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    acceptedButtons: Qt.NoButton
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Leonardo DiCaprio" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Jennifer Lawrence" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Audrey Hepburn" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Anne Hathaway" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Taylor Swift" }
                    }
                }
            }

            BrisaCard {
                Layout.fillWidth: true
                title: "Vertical Group"

                Column {
                    spacing: 12

                    BrisaAvatarGroup {
                        size: 40
                        max: 3
                        vertical: true

                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Leonardo DiCaprio" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Jennifer Lawrence" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Audrey Hepburn" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Anne Hathaway" }
                    }

                    BrisaAvatarGroup {
                        size: 40
                        max: 3
                        vertical: true
                        expandOnHover: true

                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Leonardo DiCaprio" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Jennifer Lawrence" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Audrey Hepburn" }
                        BrisaAvatar { round: true; src: root.demoAvatarSource; name: "Anne Hathaway" }
                    }
                }
            }
        }
    }
}
