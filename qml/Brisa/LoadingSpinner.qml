import QtQuick
import QtQuick.Shapes

Item {
    id: root
    property color color: "#1f2937"
    property color stroke: color
    property int size: 14
    property real strokeWidth: 28
    property real radius: 100
    property real scale: 1

    width: size
    height: size
    layer.enabled: true
    layer.smooth: true

    readonly property real strokePx: Math.max(1.1, root.size * ((root.strokeWidth / (root.radius * 2)) / Math.max(0.01, root.scale)))
    property real sweepDegrees: 275

    Item {
        id: containerRotator
        anchors.fill: parent

        NumberAnimation on rotation {
            from: 0
            to: 360
            duration: 3000
            loops: Animation.Infinite
            easing.type: Easing.Linear
            running: root.visible
        }

        Item {
            id: groupRotator
            anchors.fill: parent

            NumberAnimation on rotation {
                from: 0
                to: 270
                duration: 1600
                loops: Animation.Infinite
                easing.type: Easing.Linear
                running: root.visible
            }

            Item {
                id: arcRotator
                anchors.fill: parent

                SequentialAnimation on rotation {
                    running: root.visible
                    loops: Animation.Infinite
                    NumberAnimation { from: 0; to: 135; duration: 800; easing.type: Easing.Linear }
                    NumberAnimation { from: 135; to: 450; duration: 800; easing.type: Easing.Linear }
                }

                SequentialAnimation {
                    running: root.visible
                    loops: Animation.Infinite
                    NumberAnimation {
                        target: root
                        property: "sweepDegrees"
                        from: 275
                        to: 70
                        duration: 800
                        easing.type: Easing.InOutCubic
                    }
                    NumberAnimation {
                        target: root
                        property: "sweepDegrees"
                        from: 70
                        to: 275
                        duration: 800
                        easing.type: Easing.InOutCubic
                    }
                }

                Shape {
                    anchors.fill: parent
                    antialiasing: true
                    preferredRendererType: Shape.CurveRenderer

                    ShapePath {
                        strokeWidth: root.strokePx
                        strokeColor: root.stroke
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        joinStyle: ShapePath.RoundJoin

                        PathAngleArc {
                            centerX: root.width / 2
                            centerY: root.height / 2
                            radiusX: root.width / 2 - (root.strokePx / 2)
                            radiusY: root.height / 2 - (root.strokePx / 2)
                            startAngle: -90
                            sweepAngle: root.sweepDegrees
                        }
                    }

                    rotation: arcRotator.rotation
                }
            }
        }
    }
}
