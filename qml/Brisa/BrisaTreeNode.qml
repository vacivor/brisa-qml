import QtQuick

Item {
    id: root

    property var node: ({})
    property var tree: null
    property int depth: 0
    property bool isLast: false
    property var ancestorLastStates: []

    readonly property var childrenList: tree ? tree.childrenFor(node) : []
    readonly property bool hasChildren: childrenList.length > 0
    readonly property bool expanded: tree ? tree.isNodeExpanded(node) : false
    readonly property bool selected: tree ? tree.isNodeSelected(node) : false
    readonly property bool checked: tree ? tree.isNodeChecked(node) : false
    readonly property bool indeterminate: tree ? tree.isNodeIndeterminate(node) : false
    readonly property bool disabled: tree ? tree.nodeDisabled(node) : false
    readonly property int nodeHeight: 30
    readonly property int indent: tree ? tree.indent : 24
    readonly property int labelLeft: depth * indent
    readonly property int branchCenterX: labelLeft + 10
    readonly property color labelColor: disabled ? theme.textColorDisabled : theme.textColor2
    readonly property color hoverColor: tree && tree.hoveredKey === tree.nodeKey(node)
        ? theme.hoverColor
        : "transparent"
    readonly property color activeColor: selected
        ? Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, theme.dark ? 0.12 : 0.1)
        : hoverColor
    readonly property color lineColor: theme.dividerColor

    implicitWidth: parent ? parent.width : 240
    implicitHeight: nodeHeight

    Theme { id: theme }

    Repeater {
        model: tree && tree.showLine ? root.ancestorLastStates.length : 0

        Rectangle {
            visible: !root.ancestorLastStates[index]
            x: Math.round(index * root.indent + 9)
            y: 0
            width: 1
            height: root.height
            color: root.lineColor
        }
    }

    Rectangle {
        visible: tree && tree.showLine && root.depth > 0
        x: Math.round(root.branchCenterX)
        y: 0
        width: 1
        height: root.isLast ? Math.round(root.height / 2) : root.height
        color: root.lineColor
    }

    Rectangle {
        visible: tree && tree.showLine && root.depth > 0
        x: Math.round(root.branchCenterX)
        y: Math.round(root.height / 2)
        width: 12
        height: 1
        color: root.lineColor
    }

    Rectangle {
        x: tree && tree.blockLine ? 0 : 4
        y: 3
        width: tree && tree.blockLine ? root.width : Math.max(0, root.width - 8)
        height: Math.max(0, root.height - 6)
        radius: theme.borderRadius
        color: activeColor
    }

    Item {
        x: labelLeft
        width: Math.max(0, root.width - labelLeft)
        height: root.height

        Item {
            id: switcherWrap
            width: 20
            height: root.height

            Image {
                visible: hasChildren
                anchors.centerIn: parent
                width: 16
                height: 16
                source: theme.svgChevronRight(disabled ? theme.iconColorDisabled : theme.textColor3, 16)
                rotation: expanded ? 90 : 0
                fillMode: Image.PreserveAspectFit
                smooth: true

                Behavior on rotation {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: hasChildren && !disabled
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onEntered: tree.hoveredKey = tree.nodeKey(node)
                onExited: if (tree.hoveredKey === tree.nodeKey(node)) tree.hoveredKey = null
                onClicked: tree.toggleExpanded(node)
            }
        }

        Item {
            id: checkWrap
            x: switcherWrap.width
            width: tree && tree.checkable ? 24 : 0
            height: root.height
            visible: width > 0

            BrisaCheckbox {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                checked: checked
                indeterminate: indeterminate
                disabled: disabled
                onUpdateChecked: function() { tree.toggleChecked(node) }
            }
        }

        Text {
            id: labelText
            x: switcherWrap.width + checkWrap.width + 2
            width: Math.max(0, root.width - labelLeft - x - 8)
            anchors.verticalCenter: parent.verticalCenter
            text: tree ? tree.nodeLabel(node) : ""
            color: selected ? theme.primaryColor : labelColor
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSizeMedium
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            x: switcherWrap.width + checkWrap.width
            y: 0
            width: Math.max(0, root.width - labelLeft - x)
            height: root.height
            enabled: !disabled
            hoverEnabled: true
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onEntered: tree.hoveredKey = tree.nodeKey(node)
            onExited: if (tree.hoveredKey === tree.nodeKey(node)) tree.hoveredKey = null
            onClicked: tree.handleNodeClick(node)
        }
    }
}
