import QtQuick

Item {
    id: root
    property color color: "#18a058"
    property int duration: 360
    property real waveOpacity: 0.6
    property real spread: 4.5
    property int maxConcurrent: 3
    property real radiusTL: 0
    property real radiusTR: 0
    property real radiusBR: 0
    property real radiusBL: 0

    width: parent ? parent.width : 0
    height: parent ? parent.height : 0

    readonly property real scaleXTarget: width > 0 ? (width + spread * 2) / width : 1
    readonly property real scaleYTarget: height > 0 ? (height + spread * 2) / height : 1

    Repeater {
        id: pool
        model: root.maxConcurrent
        delegate: Item {
            id: inst
            anchors.fill: parent
            opacity: 0
            visible: false

            BrisaRoundRect {
                id: outline
                anchors.fill: parent
                fillColor: "transparent"
                strokeColor: root.color
                strokeWidth: 2
                radiusTL: root.radiusTL
                radiusTR: root.radiusTR
                radiusBR: root.radiusBR
                radiusBL: root.radiusBL
                transform: Scale {
                    id: scale
                    origin.x: outline.width / 2
                    origin.y: outline.height / 2
                    xScale: 1
                    yScale: 1
                }
            }

            ParallelAnimation {
                id: waveAnim
                NumberAnimation { target: inst; property: "opacity"; from: root.waveOpacity; to: 0; duration: root.duration }
                NumberAnimation { target: scale; property: "xScale"; from: 1; to: root.scaleXTarget; duration: root.duration }
                NumberAnimation { target: scale; property: "yScale"; from: 1; to: root.scaleYTarget; duration: root.duration }
                onStopped: inst.visible = false
            }

            function start() {
                inst.visible = true
                inst.opacity = root.waveOpacity
                scale.xScale = 1
                scale.yScale = 1
                waveAnim.restart()
            }
        }
    }

    property int _cursor: 0

    function play() {
        var idx = _cursor % pool.count
        var inst = pool.itemAt(idx)
        if (inst) inst.start()
        _cursor = _cursor + 1
    }
}
