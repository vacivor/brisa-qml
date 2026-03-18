import QtQuick

Canvas {
    id: root
    property color color: "#18a058"
    property real progress: 0
    property real centerX: width / 2
    property real centerY: height / 2
    property real radiusTL: 0
    property real radiusTR: 0
    property real radiusBR: 0
    property real radiusBL: 0
    property bool clipToBounds: true

    onProgressChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onCenterXChanged: requestPaint()
    onCenterYChanged: requestPaint()

    function trigger(x, y) {
        centerX = x
        centerY = y
        progress = 0
        rippleAnim.restart()
    }

    SequentialAnimation {
        id: rippleAnim
        PropertyAnimation {
            target: root
            property: "progress"
            from: 0
            to: 1
            duration: 320
            easing.type: Easing.OutCubic
        }
        ScriptAction { script: root.progress = 0 }
    }

    onPaint: {
        var ctx = getContext("2d")
        ctx.clearRect(0, 0, width, height)
        if (progress <= 0.001) return

        var w = width
        var h = height
        var maxR = Math.sqrt(w * w + h * h)
        var r = progress * maxR

        if (root.clipToBounds) {
            var rtl = Math.min(radiusTL, Math.min(w, h) / 2)
            var rtr = Math.min(radiusTR, Math.min(w, h) / 2)
            var rbr = Math.min(radiusBR, Math.min(w, h) / 2)
            var rbl = Math.min(radiusBL, Math.min(w, h) / 2)

            ctx.save()
            ctx.beginPath()
            ctx.moveTo(rtl, 0)
            ctx.lineTo(w - rtr, 0)
            ctx.quadraticCurveTo(w, 0, w, rtr)
            ctx.lineTo(w, h - rbr)
            ctx.quadraticCurveTo(w, h, w - rbr, h)
            ctx.lineTo(rbl, h)
            ctx.quadraticCurveTo(0, h, 0, h - rbl)
            ctx.lineTo(0, rtl)
            ctx.quadraticCurveTo(0, 0, rtl, 0)
            ctx.closePath()
            ctx.clip()
        }

        var baseAlpha = (1 - progress)
        var fillAlpha = 0.22 * baseAlpha

        var grad = ctx.createRadialGradient(centerX, centerY, 0, centerX, centerY, r)
        grad.addColorStop(0, Qt.rgba(color.r, color.g, color.b, fillAlpha))
        grad.addColorStop(0.6, Qt.rgba(color.r, color.g, color.b, fillAlpha * 0.45))
        grad.addColorStop(1, Qt.rgba(color.r, color.g, color.b, 0.0))
        ctx.fillStyle = grad
        ctx.beginPath()
        ctx.arc(centerX, centerY, r, 0, Math.PI * 2, false)
        ctx.closePath()
        ctx.fill()

        if (root.clipToBounds) {
            ctx.restore()
        }
    }
}
