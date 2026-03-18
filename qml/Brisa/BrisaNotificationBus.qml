import QtQuick
import QtQuick.Effects

Item {
    id: root
    property int topOffset: 24
    property int rightOffset: 24
    property int gap: 12
    property int maxWidth: 360

    Theme { id: theme }

    ListModel { id: items }

    readonly property Item overlayItem: root.Window.window
        ? root.Window.window.contentItem
        : (root.parent ? root.parent : null)

    Item {
        id: overlayRoot
        parent: overlayItem
        anchors.fill: parent

        Column {
            id: stack
            anchors.top: parent.top
            anchors.topMargin: root.topOffset
            anchors.right: parent.right
            anchors.rightMargin: root.rightOffset
            spacing: root.gap

        Repeater {
            model: items
            delegate: Item {
                width: root.maxWidth
                implicitHeight: contentColumn.implicitHeight + 32
                height: implicitHeight
                opacity: model.opacity
                scale: model.scale
                property real lift: model.opacity < 1 ? -8 : 0

                transform: Translate { y: lift }

                Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                Behavior on scale { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                Behavior on lift { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

                BrisaRoundRect {
                    id: bubble
                    anchors.fill: parent
                    fillColor: theme.baseColor
                    strokeColor: theme.borderColor
                    strokeWidth: 1
                    radiusTL: theme.borderRadius
                    radiusTR: theme.borderRadius
                    radiusBR: theme.borderRadius
                    radiusBL: theme.borderRadius
                }

                MultiEffect {
                    anchors.fill: bubble
                    source: bubble
                    shadowEnabled: true
                    shadowColor: Qt.rgba(0, 0, 0, 0.12)
                    shadowBlur: 0.35
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 6
                }

                Column {
                    id: contentColumn
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 4

                    Item {
                        width: parent.width
                        height: 22

                        Row {
                            anchors.left: parent.left
                            spacing: 6

                            Item {
                                width: 16
                                height: 16
                                anchors.verticalCenter: parent.verticalCenter
                                Rectangle {
                                    anchors.fill: parent
                                    radius: 8
                                    color: Qt.rgba(model.color.r, model.color.g, model.color.b, 0.16)
                                }
                                Text {
                                    text: model.icon
                                    color: model.color
                                    font.pixelSize: 11
                                    font.weight: Font.DemiBold
                                    font.family: "Space Grotesk"
                                    anchors.centerIn: parent
                                }
                            }

                            Text {
                                text: model.title
                                color: theme.textColor1
                                font.pixelSize: 14
                                font.weight: Font.DemiBold
                                font.family: "Space Grotesk"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Item {
                            id: closeButton
                            width: 20
                            height: 20
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            Rectangle {
                                anchors.fill: parent
                                radius: 3
                                color: closeHover.hovered ? theme.hoverColor : "transparent"
                            }
                            Text {
                                text: "\u00D7"
                                color: theme.textColor3
                                font.pixelSize: 16
                                anchors.centerIn: parent
                            }
                            HoverHandler { id: closeHover; cursorShape: Qt.PointingHandCursor }
                            TapHandler {
                                onTapped: {
                                    var current = indexById(model.uid)
                                    if (current >= 0) items.remove(current)
                                }
                            }
                        }
                    }

                    Text {
                        text: model.text
                        color: theme.textColor2
                        font.pixelSize: 13
                        font.family: "Space Grotesk"
                        wrapMode: Text.Wrap
                        lineHeightMode: Text.FixedHeight
                        lineHeight: 20
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.AllButtons
                    hoverEnabled: true
                    propagateComposedEvents: false
                    preventStealing: true
                    onPressed: function(mouse) { mouse.accepted = true }
                    onReleased: function(mouse) { mouse.accepted = true }
                    onClicked: function(mouse) { mouse.accepted = true }
                }
            }
        }
    }
    }

    function iconForType(type) {
        switch (type) {
        case "success":
            return "\u2713"
        case "warning":
            return "!"
        case "error":
            return "\u00D7"
        case "info":
        default:
            return "i"
        }
    }

    function colorForType(type) {
        switch (type) {
        case "success":
            return theme.successColor
        case "warning":
            return theme.warningColor
        case "error":
            return theme.errorColor
        case "info":
        default:
            return theme.infoColor
        }
    }

    function indexById(uid) {
        for (var i = 0; i < items.count; i++) {
            if (items.get(i).uid === uid) return i
        }
        return -1
    }

    function push(title, text, type) {
        var color = colorForType(type)
        var uid = Date.now() + Math.random()
        items.append({
            uid: uid,
            title: title,
            text: text,
            color: color,
            icon: iconForType(type),
            opacity: 0,
            scale: 0.98
        })
        var idx = items.count - 1
        items.setProperty(idx, "opacity", 1)
        items.setProperty(idx, "scale", 1)

        var timer = Qt.createQmlObject('import QtQuick; Timer { interval: 4500; repeat: false }', root, "notiTimer")
        timer.triggered.connect(function() {
            var current = indexById(uid)
            if (current < 0) return
            items.setProperty(current, "opacity", 0)
            items.setProperty(current, "scale", 0.98)
            var removeTimer = Qt.createQmlObject('import QtQuick; Timer { interval: 180; repeat: false }', root, "notiRemove")
            removeTimer.triggered.connect(function() {
                var removeIndex = indexById(uid)
                if (removeIndex < 0) return
                items.remove(removeIndex)
            })
            removeTimer.start()
        })
        timer.start()
    }
}
