import QtQuick

Item {
    id: root

    property var node: ({})
    property var treeSelect: null
    property int depth: 0
    property bool isLast: false
    property var ancestorLastStates: []

    readonly property var childrenList: treeSelect ? treeSelect.childrenFor(node) : []
    readonly property bool hasChildren: childrenList.length > 0
    readonly property bool expanded: treeSelect ? treeSelect.isNodeExpanded(node) : false
    readonly property bool selected: treeSelect ? treeSelect.isNodeSelected(node) : false
    readonly property bool checked: treeSelect ? treeSelect.isNodeChecked(node) : false
    readonly property bool indeterminate: treeSelect ? treeSelect.isNodeIndeterminate(node) : false
    readonly property bool disabled: treeSelect ? treeSelect.nodeDisabled(node) : false
    readonly property int nodeHeight: treeSelect ? treeSelect.nodeHeight : 28
    readonly property int indent: treeSelect ? treeSelect.indent : 28
    readonly property int labelLeft: depth * indent
    readonly property int branchCenterX: labelLeft + 13
    readonly property color labelColor: disabled ? theme.textColorDisabled : theme.textColor1
    readonly property bool hovered: treeSelect && treeSelect.hoveredKey === treeSelect.nodeKey(node)
    readonly property color activeColor: rowMouse.pressed
        ? (treeSelect ? treeSelect.nodeColorPressed : Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.18))
        : (selected
            ? (treeSelect ? treeSelect.nodeColorActive : Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.12))
            : (hovered ? (treeSelect ? treeSelect.nodeColorHover : theme.hoverColor) : "transparent"))
    readonly property color lineColor: theme.dividerColor

    implicitWidth: parent ? parent.width : 240
    implicitHeight: nodeHeight

    Theme { id: theme }

    Repeater {
        model: treeSelect && treeSelect.showLine ? root.ancestorLastStates.length : 0

        Rectangle {
            visible: !root.ancestorLastStates[index]
            x: Math.round(index * root.indent + 13)
            y: treeSelect ? treeSelect.lineOffsetTop : 3
            width: 1
            height: Math.max(0, root.height - (treeSelect ? treeSelect.lineOffsetTop : 3) - (treeSelect ? treeSelect.lineOffsetBottom : 3))
            color: root.lineColor
        }
    }

    Rectangle {
        visible: treeSelect && treeSelect.showLine && root.depth > 0
        x: Math.round(root.branchCenterX)
        y: treeSelect.lineOffsetTop
        width: 1
        height: root.isLast
            ? Math.max(0, Math.round(root.height / 2) - treeSelect.lineOffsetTop)
            : Math.max(0, root.height - treeSelect.lineOffsetTop - treeSelect.lineOffsetBottom)
        color: root.lineColor
    }

    Rectangle {
        visible: treeSelect && treeSelect.showLine && root.depth > 0
        x: Math.round(root.branchCenterX)
        y: Math.round(root.height / 2)
        width: 9
        height: 1
        color: root.lineColor
    }

    Rectangle {
        x: labelLeft
        y: 1
        width: parent.width - labelLeft
        height: parent.height - 2
        radius: theme.borderRadius
        color: activeColor
    }

    Item {
        id: contentRow
        x: labelLeft
        width: parent.width - labelLeft
        height: parent.height

        Item {
            id: switcherWrap
            width: 24
            height: parent.height

            Image {
                visible: hasChildren
                anchors.centerIn: parent
                width: 14
                height: 14
                source: theme.svgChevronRight(disabled ? theme.iconColorDisabled : theme.textColor3, 14)
                rotation: expanded ? 90 : 0
                fillMode: Image.PreserveAspectFit
                smooth: true

                Behavior on rotation {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }

            MouseArea {
                id: switcherMouse
                anchors.fill: parent
                enabled: hasChildren && !disabled
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onEntered: treeSelect.hoveredKey = treeSelect.nodeKey(node)
                onExited: if (treeSelect.hoveredKey === treeSelect.nodeKey(node)) treeSelect.hoveredKey = null
                onClicked: treeSelect.toggleExpanded(node)
            }
        }

        Item {
            id: checkWrap
            x: switcherWrap.width
            width: treeSelect && treeSelect.checkable ? 24 : 0
            height: parent.height
            visible: width > 0
            z: 3

            BrisaCheckbox {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 1
                checked: root.checked
                indeterminate: root.indeterminate
                disabled: root.disabled
                passive: true
            }

            MouseArea {
                anchors.fill: parent
                enabled: treeSelect && treeSelect.checkable && !disabled
                hoverEnabled: true
                z: 4
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onEntered: treeSelect.hoveredKey = treeSelect.nodeKey(node)
                onExited: if (treeSelect.hoveredKey === treeSelect.nodeKey(node)) treeSelect.hoveredKey = null
                onClicked: function(mouse) {
                    mouse.accepted = true
                    treeSelect.toggleChecked(node)
                }
            }
        }

        Text {
            id: labelText
            x: switcherWrap.width + checkWrap.width + 4
            width: parent.width - x - 6
            anchors.verticalCenter: parent.verticalCenter
            text: treeSelect ? treeSelect.nodeLabel(node) : ""
            color: labelColor
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSizeMedium
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            id: rowMouse
            x: switcherWrap.width + checkWrap.width
            y: 0
            width: parent.width - x
            height: parent.height
            enabled: !disabled
            hoverEnabled: true
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onEntered: treeSelect.hoveredKey = treeSelect.nodeKey(node)
            onExited: if (treeSelect.hoveredKey === treeSelect.nodeKey(node)) treeSelect.hoveredKey = null
            onClicked: treeSelect.handleNodeClick(node)
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: !disabled
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
        onEntered: if (treeSelect) treeSelect.hoveredKey = treeSelect.nodeKey(node)
        onExited: if (treeSelect && treeSelect.hoveredKey === treeSelect.nodeKey(node)) treeSelect.hoveredKey = null
    }
}
