import QtQuick

Item {
    id: root

    default property alias items: buttonsColumn.data

    property var leftInset: undefined
    property var rightInset: undefined
    property var topInset: undefined
    property var bottomInset: undefined
    property string shape: "circle" // circle | square
    property string position: "fixed" // relative | absolute | fixed
    property var buttonData: []
    property int maxButtonWidth: 40

    Theme { id: theme }

    implicitWidth: groupShell.implicitWidth
    implicitHeight: groupShell.implicitHeight

    anchors.left: leftInset !== undefined ? parent.left : undefined
    anchors.right: rightInset !== undefined ? parent.right : undefined
    anchors.top: topInset !== undefined ? parent.top : undefined
    anchors.bottom: bottomInset !== undefined ? parent.bottom : undefined
    anchors.leftMargin: leftInset !== undefined ? Number(leftInset) : 0
    anchors.rightMargin: rightInset !== undefined ? Number(rightInset) : 0
    anchors.topMargin: topInset !== undefined ? Number(topInset) : 0
    anchors.bottomMargin: bottomInset !== undefined ? Number(bottomInset) : 0

    function syncButtons() {
        var collected = []
        var maxWidth = 40
        for (var i = 0; i < buttonsColumn.children.length; ++i) {
            var child = buttonsColumn.children[i]
            if (child && child.__isBrisaFloatButton === true) {
                collected.push(child)
                maxWidth = Math.max(maxWidth, Math.ceil(child.implicitWidth))
            }
        }
        buttonData = collected
        maxButtonWidth = maxWidth

        for (var j = 0; j < buttonData.length; ++j) {
            var button = buttonData[j]
            button._group = root
            button._groupIndex = j
            button._groupCount = buttonData.length
            if (root.shape === "square") {
                button.width = Qt.binding(function() { return root.maxButtonWidth })
            } else {
                button.width = Qt.binding((function(target) {
                    return function() { return target.implicitWidth }
                })(button))
            }
        }
    }

    Item {
        id: groupShell
        implicitWidth: shape === "square" ? Math.max(40, buttonsColumn.childrenRect.width) : buttonsColumn.implicitWidth
        implicitHeight: buttonsColumn.implicitHeight

        Rectangle {
            visible: root.shape === "square"
            x: 0
            y: 2
            width: buttonsColumn.width
            height: buttonsColumn.height
            radius: theme.borderRadius
            color: Qt.rgba(0, 0, 0, 0.12)
        }

        Rectangle {
            visible: root.shape === "square"
            width: buttonsColumn.width
            height: buttonsColumn.height
            radius: theme.borderRadius
            color: theme.popoverColor
            border.width: 1
            border.color: theme.borderColor
        }

        Column {
            id: buttonsColumn
            spacing: root.shape === "circle" ? 16 : 0
            onChildrenChanged: root.syncButtons()
        }
    }

    Component.onCompleted: syncButtons()
    onShapeChanged: syncButtons()
}
