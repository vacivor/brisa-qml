import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property string type: "line" // line | circle | dashboard
    property real percentage: 0
    property bool processing: false
    property string status: "default" // default | success | warning | error
    property var color: undefined
    property color railColor: Qt.rgba(0, 0, 0, 0.06)
    property real strokeWidth: 8
    property real gapDegree: type === "dashboard" ? 75 : 0
    property real gapOffsetDegree: 0
    property string unit: "%"
    property bool showIndicator: true
    property string indicatorPlacement: "outside" // outside | inside
    property color indicatorTextColor: "transparent"
    property real lineHeight: 8
    property real borderRadius: lineHeight / 2
    property real fillBorderRadius: borderRadius

    implicitWidth: type === "line" ? lineContent.implicitWidth : circleBoxSize
    implicitHeight: type === "line" ? lineContent.implicitHeight : circleBoxSize

    Theme { id: theme }

    readonly property real clampedPercentage: Math.max(0, Math.min(100, percentage))
    readonly property bool isLine: type === "line"
    readonly property bool isCircle: type === "circle" || type === "dashboard"
    readonly property real indicatorGap: 14
    readonly property real lineTextWidth: 40
    readonly property real lineTextFontSize: theme.fontSizeSmall
    readonly property real circleTextFontSize: type === "dashboard" ? 24 : 28
    readonly property real iconSizeLine: 18
    readonly property real iconSizeCircle: type === "dashboard" ? 32 : 36
    readonly property real circleBoxSize: 120
    readonly property real circleStrokeWidth: type === "dashboard" ? Math.max(strokeWidth, 8) : strokeWidth
    readonly property real normalizedLineHeight: root.indicatorPlacement === "inside" ? Math.max(root.lineHeight, 16) : root.lineHeight
    readonly property real dashboardGapDegree: type === "dashboard" ? (gapDegree > 0 ? gapDegree : 75) : gapDegree
    readonly property real effectiveGapDegree: type === "dashboard" ? dashboardGapDegree : gapDegree
    readonly property color fillColor: {
        if (color !== undefined)
            return color
        switch (status) {
        case "success": return theme.successColor
        case "warning": return theme.warningColor
        case "error": return theme.errorColor
        default: return theme.infoColor
        }
    }
    readonly property color iconColor: fillColor
    readonly property color lineOuterTextColor: indicatorTextColor === "transparent" ? theme.textColor2 : indicatorTextColor
    readonly property color lineInnerTextColor: indicatorTextColor === "transparent" ? theme.baseColor : indicatorTextColor
    readonly property color circleTextColor: indicatorTextColor === "transparent" ? theme.textColor2 : indicatorTextColor
    readonly property bool showStatusIcon: status === "success" || status === "error"
    readonly property real arcSweepDegrees: (360 - effectiveGapDegree) * (clampedPercentage / 100)
    readonly property real arcStartDegrees: -90 + (type === "dashboard" ? effectiveGapDegree / 2 : 0) + gapOffsetDegree

    function statusIconSource(size) {
        if (status === "success")
            return theme.svgCheck(iconColor, size)
        if (status === "error")
            return theme.svgClose(iconColor, size)
        return ""
    }

    function indicatorText() {
        return Math.round(clampedPercentage) + unit
    }

    Row {
        id: lineContent
        visible: root.isLine
        spacing: root.indicatorPlacement === "outside" && root.showIndicator ? root.indicatorGap : 0
        anchors.fill: parent

        Item {
            id: lineGraphWrap
            implicitWidth: 240
            Layout.fillWidth: true
            Layout.preferredWidth: implicitWidth
            height: root.normalizedLineHeight

            Rectangle {
                id: lineRail
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: root.normalizedLineHeight
                radius: root.indicatorPlacement === "inside" ? 10 : root.borderRadius
                color: root.railColor
                clip: true

                Rectangle {
                    id: lineFill
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: root.clampedPercentage <= 0 ? 0 : Math.max(root.indicatorPlacement === "inside" ? root.normalizedLineHeight : 0, parent.width * (root.clampedPercentage / 100))
                    height: parent.height
                    radius: root.indicatorPlacement === "inside" ? 10 : root.fillBorderRadius
                    color: root.fillColor

                    Behavior on width {
                        NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
                    }

                    Rectangle {
                        id: shimmerBlock
                        visible: root.processing
                        width: Math.max(parent.width * 0.5, 48)
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        color: Qt.rgba(1, 1, 1, 0.22)
                        x: -width
                        radius: parent.radius
                        opacity: 0.9

                        SequentialAnimation on x {
                            running: root.processing && root.isLine && lineFill.width > 0
                            loops: Animation.Infinite
                            NumberAnimation {
                                from: -shimmerBlock.width
                                to: lineFill.width
                                duration: 1800
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    Text {
                        visible: root.showIndicator && root.indicatorPlacement === "inside" && !root.showStatusIcon
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        text: root.indicatorText()
                        color: root.lineInnerTextColor
                        font.family: theme.fontFamily
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        renderType: Text.NativeRendering
                        elide: Text.ElideLeft
                    }
                }
            }

            Image {
                visible: root.showIndicator && root.indicatorPlacement === "inside" && root.showStatusIcon
                anchors.verticalCenter: lineRail.verticalCenter
                x: Math.max(0, lineFill.x + lineFill.width - width - 8)
                width: root.iconSizeLine
                height: root.iconSizeLine
                source: root.statusIconSource(root.iconSizeLine)
            }
        }

        Item {
            visible: root.showIndicator && root.indicatorPlacement === "outside"
            width: root.showStatusIcon ? 30 : root.lineTextWidth
            height: Math.max(root.lineHeight, root.iconSizeLine)

            Text {
                visible: !root.showStatusIcon
                anchors.centerIn: parent
                text: root.indicatorText()
                color: root.lineOuterTextColor
                font.family: theme.fontFamily
                font.pixelSize: root.lineTextFontSize
                font.weight: Font.Medium
                renderType: Text.NativeRendering
            }

            Image {
                visible: root.showStatusIcon
                anchors.centerIn: parent
                width: root.iconSizeLine
                height: root.iconSizeLine
                source: root.statusIconSource(root.iconSizeLine)
            }
        }
    }

    Item {
        visible: root.isCircle
        width: root.circleBoxSize
        height: root.circleBoxSize

        Behavior on opacity {
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }

        Canvas {
            id: circleCanvas
            anchors.fill: parent
            antialiasing: true
            renderStrategy: Canvas.Threaded

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var w = width
                var h = height
                var cx = w / 2
                var cy = h / 2
                var radius = Math.max(0, Math.min(w, h) / 2 - root.circleStrokeWidth / 2 - 3)
                var start = root.arcStartDegrees * Math.PI / 180
                var total = (360 - root.effectiveGapDegree) * Math.PI / 180
                var end = start + total
                var progressEnd = start + total * (root.clampedPercentage / 100)

                ctx.lineCap = "round"
                ctx.lineWidth = root.circleStrokeWidth

                ctx.beginPath()
                ctx.strokeStyle = root.railColor
                ctx.arc(cx, cy, radius, start, end, false)
                ctx.stroke()

                if (root.clampedPercentage > 0) {
                    ctx.beginPath()
                    ctx.strokeStyle = root.fillColor
                    ctx.arc(cx, cy, radius, start, progressEnd, false)
                    ctx.stroke()
                }
            }

            Connections {
                target: root
                function onClampedPercentageChanged() { circleCanvas.requestPaint() }
                function onFillColorChanged() { circleCanvas.requestPaint() }
                function onRailColorChanged() { circleCanvas.requestPaint() }
                function onStrokeWidthChanged() { circleCanvas.requestPaint() }
                function onArcStartDegreesChanged() { circleCanvas.requestPaint() }
                function onEffectiveGapDegreeChanged() { circleCanvas.requestPaint() }
                function onTypeChanged() { circleCanvas.requestPaint() }
            }
        }

        Item {
            anchors.centerIn: parent
            width: parent.width * 0.6
            height: parent.height * 0.6

            Text {
                visible: root.showIndicator && !root.showStatusIcon
                anchors.centerIn: parent
                text: root.indicatorText()
                color: root.circleTextColor
                font.family: theme.fontFamily
                font.pixelSize: root.circleTextFontSize
                font.weight: Font.Medium
                renderType: Text.NativeRendering
            }

            Image {
                visible: root.showIndicator && root.showStatusIcon
                anchors.centerIn: parent
                width: root.iconSizeCircle
                height: root.iconSizeCircle
                source: root.statusIconSource(root.iconSizeCircle)
            }
        }
    }
}
