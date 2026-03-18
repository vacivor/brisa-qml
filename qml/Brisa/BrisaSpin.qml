import QtQuick

Item {
    id: root

    property bool show: true
    property int delay: 0
    property var size: "medium" // small | medium | large | number
    property string description: ""
    property bool rotate: true
    property color color: theme.primaryColor
    property color textColor: theme.primaryColor
    property real opacitySpinning: theme.opacityDisabled
    property color overlayColor: Qt.rgba(theme.baseColor.r, theme.baseColor.g, theme.baseColor.b, 0.72)
    property real strokeWidth: typeof size === "number" ? theme.spinStrokeWidthMedium : theme.spinStrokeWidthFor(size)
    property real radius: 100
    property real scale: 1
    property Component iconComponent: null

    default property alias data: contentContainer.data
    property alias descriptionContent: descriptionSlot.data

    readonly property bool hasWrappedContent: contentContainer.children.length > 0
    readonly property bool hasCustomIcon: iconComponent !== null
    readonly property bool hasDescriptionSlot: descriptionSlot.children.length > 0
    readonly property int resolvedSize: typeof size === "number"
        ? Number(size)
        : (size === "small" ? theme.heightSmall : (size === "large" ? theme.heightLarge : theme.heightMedium))

    implicitWidth: hasWrappedContent ? Math.max(contentContainer.childrenRect.width, spinBody.implicitWidth) : spinBody.implicitWidth
    implicitHeight: hasWrappedContent ? Math.max(contentContainer.childrenRect.height, spinBody.implicitHeight) : spinBody.implicitHeight

    Theme { id: theme }

    Timer {
        id: delayTimer
        interval: Math.max(0, root.delay)
        repeat: false
        onTriggered: active = root.show
    }

    property bool active: false

    onShowChanged: syncActive()
    onDelayChanged: syncActive()
    Component.onCompleted: syncActive()

    Item {
        id: contentContainer
        anchors.fill: parent
        visible: root.hasWrappedContent
        opacity: root.active ? root.opacitySpinning : 1
        enabled: !root.active
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height

        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.InOutCubic }
        }
    }

    Item {
        id: overlay
        anchors.fill: parent
        visible: root.active || opacity > 0
        opacity: root.active ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }

        Rectangle {
            anchors.fill: parent
            color: root.overlayColor
            visible: root.hasWrappedContent

            Behavior on color {
                ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
            }
        }

        Item {
            id: spinBody
            anchors.centerIn: parent
            opacity: root.active ? 1 : 0
            scale: root.active ? 1 : 0.94
            width: Math.max(iconWrap.width, descriptionWrap.implicitWidth)
            height: iconWrap.height + (descriptionWrap.visible ? descriptionWrap.implicitHeight + 8 : 0)
            implicitWidth: width
            implicitHeight: height

            Behavior on opacity {
                NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }

            Behavior on scale {
                NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
            }

            Item {
                id: iconWrap
                width: root.resolvedSize
                height: root.resolvedSize
                anchors.horizontalCenter: parent.horizontalCenter

                LoadingSpinner {
                    anchors.centerIn: parent
                    visible: !root.hasCustomIcon
                    size: root.resolvedSize
                    stroke: root.color
                    strokeWidth: root.strokeWidth
                    radius: root.radius
                    scale: root.scale
                }

                Item {
                    id: iconSlot
                    anchors.centerIn: parent
                    width: root.resolvedSize
                    height: root.resolvedSize
                    visible: root.hasCustomIcon
                    rotation: root.rotate ? customIconRotation : 0

                    property real customIconRotation: 0

                    Loader {
                        anchors.fill: parent
                        sourceComponent: root.iconComponent
                    }

                    NumberAnimation on customIconRotation {
                        from: 0
                        to: 360
                        duration: 2000
                        loops: Animation.Infinite
                        easing.type: Easing.Linear
                        running: root.active && root.rotate && root.hasCustomIcon
                    }
                }
            }

            Item {
                id: descriptionWrap
                anchors.top: iconWrap.bottom
                anchors.topMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.description.length > 0 || root.hasDescriptionSlot
                implicitWidth: Math.max(descriptionText.implicitWidth, descriptionSlot.childrenRect.width)
                implicitHeight: Math.max(descriptionText.implicitHeight, descriptionSlot.childrenRect.height)

                Text {
                    id: descriptionText
                    anchors.centerIn: parent
                    visible: !root.hasDescriptionSlot && root.description.length > 0
                    text: root.description
                    color: root.textColor
                    font.family: theme.fontFamily
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                Item {
                    id: descriptionSlot
                    anchors.centerIn: parent
                    visible: root.hasDescriptionSlot
                    width: childrenRect.width
                    height: childrenRect.height
                }
            }
        }
    }

    function syncActive() {
        delayTimer.stop()
        if (show) {
            if (delay > 0) {
                active = false
                delayTimer.interval = delay
                delayTimer.start()
            } else {
                active = true
            }
        } else {
            active = false
        }
    }
}
