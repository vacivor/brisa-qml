import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: root

    property string type: "default" // default | info | success | warning | error
    property string title: ""
    property string content: ""
    property bool showIcon: true
    property bool bordered: true
    property bool closable: false
    property bool visibleAlert: true
    property var iconComponent: null
    property Component bodyComponent
    property bool leaveNotified: false

    signal closeRequested()
    signal afterLeave()

    implicitWidth: visibleAlert ? alertBody.implicitWidth : 0
    implicitHeight: animatedHeight
    height: animatedHeight
    clip: true

    Theme { id: theme }

    readonly property real alertFillAlpha: root.bordered ? 0.08 : 0.065
    readonly property color alertColor: {
        switch (type) {
        case "info": return Qt.rgba(theme.infoColor.r, theme.infoColor.g, theme.infoColor.b, root.alertFillAlpha)
        case "success": return Qt.rgba(theme.successColor.r, theme.successColor.g, theme.successColor.b, root.alertFillAlpha)
        case "warning": return Qt.rgba(theme.warningColor.r, theme.warningColor.g, theme.warningColor.b, root.bordered ? 0.08 : 0.07)
        case "error": return Qt.rgba(theme.errorColor.r, theme.errorColor.g, theme.errorColor.b, root.alertFillAlpha)
        default: return theme.actionColor
        }
    }
    readonly property color alertBorderColor: {
        switch (type) {
        case "info": return Qt.rgba(theme.infoColor.r, theme.infoColor.g, theme.infoColor.b, 0.25)
        case "success": return Qt.rgba(theme.successColor.r, theme.successColor.g, theme.successColor.b, 0.25)
        case "warning": return Qt.rgba(theme.warningColor.r, theme.warningColor.g, theme.warningColor.b, 0.33)
        case "error": return Qt.rgba(theme.errorColor.r, theme.errorColor.g, theme.errorColor.b, 0.25)
        default: return theme.dividerColor
        }
    }
    readonly property color iconColor: {
        switch (type) {
        case "info": return theme.infoColor
        case "success": return theme.successColor
        case "warning": return theme.warningColor
        case "error": return theme.errorColor
        default: return theme.textColor2
        }
    }
    readonly property color closeBgHover: Qt.rgba(0, 0, 0, 0.06)
    readonly property color closeBgPressed: Qt.rgba(0, 0, 0, 0.10)
    readonly property color closeIconColor: theme.closeIconColor ? theme.closeIconColor : theme.iconColor
    readonly property color closeIconColorHover: theme.closeIconColorHover ? theme.closeIconColorHover : theme.iconColorHover
    readonly property color closeIconColorPressed: theme.closeIconColorPressed ? theme.closeIconColorPressed : theme.iconColorPressed
    readonly property int iconSize: 20
    readonly property int closeSize: 22
    readonly property int horizontalPadding: 16
    readonly property int verticalPadding: 14
    readonly property int iconGap: 12
    readonly property int closeInset: 10
    readonly property int contentFontSize: theme.fontSizeSmall

    property real animatedHeight: visibleAlert ? alertBody.implicitHeight : 0

    Behavior on animatedHeight {
        NumberAnimation {
            duration: root.visibleAlert ? 240 : 190
            easing.type: root.visibleAlert ? Easing.OutCubic : Easing.InOutCubic
        }
    }

    onVisibleAlertChanged: {
        if (visibleAlert)
            leaveNotified = false
    }

    onAnimatedHeightChanged: {
        if (!visibleAlert && !leaveNotified && animatedHeight < 0.5) {
            leaveNotified = true
            afterLeave()
        }
    }

    Rectangle {
        id: alertBody
        visible: root.animatedHeight > 0 || opacity > 0
        width: parent ? parent.width : implicitWidth
        implicitHeight: bodyColumn.implicitHeight + root.verticalPadding * 2
        radius: theme.borderRadius
        antialiasing: true
        color: root.alertColor
        border.width: root.bordered ? 1 : 0
        border.color: root.alertBorderColor
        y: root.visibleAlert ? 0 : -4
        opacity: root.visibleAlert ? 1 : 0

        Behavior on color {
            ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
        }
        Behavior on border.color {
            ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
        }
        Behavior on y {
            NumberAnimation {
                duration: root.visibleAlert ? 220 : 150
                easing.type: root.visibleAlert ? Easing.OutCubic : Easing.InCubic
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: root.visibleAlert ? 180 : 120
                easing.type: root.visibleAlert ? Easing.OutCubic : Easing.InCubic
            }
        }

        Item {
            anchors.fill: parent

            Loader {
                visible: root.showIcon
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: root.horizontalPadding
                anchors.topMargin: root.verticalPadding + 1
                width: root.iconSize
                height: root.iconSize
                z: 1
                active: root.showIcon
                sourceComponent: root.iconComponent ? root.iconComponent : defaultIcon
            }

            Column {
                id: bodyColumn
                x: root.horizontalPadding + (root.showIcon ? root.iconSize + root.iconGap : 0)
                y: root.verticalPadding
                width: parent.width - x - root.horizontalPadding - (root.closable ? root.closeSize + root.closeInset + 6 : 0)
                spacing: root.title.length > 0 && (root.content.length > 0 || !!root.bodyComponent) ? 8 : 0

                Text {
                    visible: root.title.length > 0
                    width: parent.width
                    text: root.title
                    color: theme.textColor1
                    font.family: theme.fontFamily
                    font.pixelSize: 16
                    font.weight: Font.Medium
                    renderType: Text.NativeRendering
                    lineHeightMode: Text.FixedHeight
                    lineHeight: 20
                    wrapMode: Text.Wrap
                }

                Column {
                    width: parent.width
                    spacing: root.content.length > 0 && !!root.bodyComponent ? 10 : 0

                    Text {
                        visible: root.content.length > 0
                        width: parent.width
                        text: root.content
                        color: theme.textColor2
                        font.family: theme.fontFamily
                        font.pixelSize: root.contentFontSize
                        renderType: Text.NativeRendering
                        lineHeightMode: Text.FixedHeight
                        lineHeight: 20
                        wrapMode: Text.Wrap
                    }

                    Loader {
                        visible: !!root.bodyComponent
                        width: parent.width
                        active: !!root.bodyComponent
                        sourceComponent: root.bodyComponent
                    }
                }
            }

            Item {
                visible: root.closable
                width: root.closeSize
                height: root.closeSize
                z: 1
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: root.closeInset
                anchors.rightMargin: root.closeInset

                Rectangle {
                    anchors.fill: parent
                    radius: theme.borderRadius
        antialiasing: true
                    color: closeMouse.pressed ? root.closeBgPressed : (closeMouse.containsMouse ? root.closeBgHover : "transparent")

                    Behavior on color {
                        ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                    }
                }

                Image {
                    anchors.centerIn: parent
                    width: 15
                    height: 15
                    source: theme.svgClose(
                        closeMouse.pressed ? root.closeIconColorPressed : (closeMouse.containsMouse ? root.closeIconColorHover : root.closeIconColor),
                        15
                    )
                }

                MouseArea {
                    id: closeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.visibleAlert = false
                        root.closeRequested()
                    }
                }
            }
        }
    }

    Component {
        id: defaultIcon

        Item {
            implicitWidth: root.iconSize
            implicitHeight: root.iconSize

            Item {
                visible: root.type === "info" || root.type === "default"
                anchors.fill: parent

                Shape {
                    anchors.fill: parent
                    antialiasing: true

                    ShapePath {
                        strokeColor: root.iconColor
                        strokeWidth: 2
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        startX: width * 0.5
                        startY: height * 0.28
                        PathLine { x: width * 0.5; y: height * 0.60 }
                    }

                    ShapePath {
                        strokeColor: root.iconColor
                        strokeWidth: 2.5
                        startX: width * 0.5
                        startY: height * 0.14
                        PathLine { x: width * 0.5; y: height * 0.14 }
                    }
                }
            }

            Item {
                visible: root.type === "warning"
                anchors.fill: parent

                Shape {
                    anchors.fill: parent
                    antialiasing: true

                    ShapePath {
                        strokeColor: root.iconColor
                        strokeWidth: 2
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        joinStyle: ShapePath.RoundJoin
                        startX: width * 0.5
                        startY: height * 0.16
                        PathLine { x: width * 0.24; y: height * 0.76 }
                        PathLine { x: width * 0.76; y: height * 0.76 }
                        PathLine { x: width * 0.5; y: height * 0.18 }
                    }

                    ShapePath {
                        strokeColor: root.iconColor
                        strokeWidth: 2
                        capStyle: ShapePath.RoundCap
                        startX: width * 0.5
                        startY: height * 0.38
                        PathLine { x: width * 0.5; y: height * 0.56 }
                    }

                    ShapePath {
                        strokeColor: root.iconColor
                        strokeWidth: 2.5
                        startX: width * 0.5
                        startY: height * 0.66
                        PathLine { x: width * 0.5; y: height * 0.66 }
                    }
                }
            }

            Image {
                visible: root.type === "success"
                anchors.centerIn: parent
                width: parent.width - 1
                height: parent.height - 1
                source: theme.svgCheck(root.iconColor, root.iconSize)
            }

            Image {
                visible: root.type === "error"
                anchors.centerIn: parent
                width: parent.width - 1
                height: parent.height - 1
                source: theme.svgClose(root.iconColor, root.iconSize)
            }
        }
    }
}
