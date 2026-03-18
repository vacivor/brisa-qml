import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    property color fillColor: "transparent"
    property color strokeColor: "transparent"
    property real strokeWidth: 0

    property real radiusTL: 0
    property real radiusTR: 0
    property real radiusBR: 0
    property real radiusBL: 0

    width: parent ? parent.width : 0
    height: parent ? parent.height : 0

    antialiasing: true
    layer.enabled: true
    layer.samples: 4

    readonly property real inset: Math.max(0, root.strokeWidth * 0.5)
    readonly property real innerWidth: Math.max(0, root.width - root.strokeWidth)
    readonly property real innerHeight: Math.max(0, root.height - root.strokeWidth)
    readonly property real clampRadius: Math.min(innerWidth, innerHeight) / 2
    readonly property real rTL: Math.min(root.radiusTL, clampRadius)
    readonly property real rTR: Math.min(root.radiusTR, clampRadius)
    readonly property real rBR: Math.min(root.radiusBR, clampRadius)
    readonly property real rBL: Math.min(root.radiusBL, clampRadius)

    ShapePath {
        id: path
        strokeWidth: root.strokeWidth
        strokeColor: root.strokeColor
        fillColor: root.fillColor
        capStyle: ShapePath.RoundCap
        joinStyle: ShapePath.RoundJoin

        startX: root.inset + root.rTL
        startY: root.inset

        PathLine { x: root.inset + root.innerWidth - root.rTR; y: root.inset }
        PathArc {
            x: root.inset + root.innerWidth; y: root.inset + root.rTR
            radiusX: root.rTR; radiusY: root.rTR
            direction: PathArc.Clockwise
        }
        PathLine { x: root.inset + root.innerWidth; y: root.inset + root.innerHeight - root.rBR }
        PathArc {
            x: root.inset + root.innerWidth - root.rBR; y: root.inset + root.innerHeight
            radiusX: root.rBR; radiusY: root.rBR
            direction: PathArc.Clockwise
        }
        PathLine { x: root.inset + root.rBL; y: root.inset + root.innerHeight }
        PathArc {
            x: root.inset; y: root.inset + root.innerHeight - root.rBL
            radiusX: root.rBL; radiusY: root.rBL
            direction: PathArc.Clockwise
        }
        PathLine { x: root.inset; y: root.inset + root.rTL }
        PathArc {
            x: root.inset + root.rTL; y: root.inset
            radiusX: root.rTL; radiusY: root.rTL
            direction: PathArc.Clockwise
        }
    }
}
