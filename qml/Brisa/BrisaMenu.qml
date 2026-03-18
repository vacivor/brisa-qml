import QtQuick

Item {
    id: root
    property var items: []
    property string currentKey: ""
    property bool collapsed: false
    property int collapsedWidth: 48
    property int itemHeight: 42
    property int indent: 32
    property int rootIndent: 32
    property int radius: theme.borderRadius
    property int iconSize: 20
    property int collapsedIconSize: 24
    property color textColor: theme.textColor2
    property color mutedColor: theme.textColor3
    property color hoverColor: theme.hoverColor
    property color activeColor: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.1)
    property color activeCollapsedColor: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.12)
    property color activeTextColor: theme.primaryColor
    property color iconColor: theme.textColor1
    property color collapsedIconColor: theme.textColor1
    property color hoverTextColor: theme.textColor2
    property color groupTextColor: theme.textColor3
    readonly property color transparentHoverColor: Qt.rgba(hoverColor.r, hoverColor.g, hoverColor.b, 0)
    readonly property color transparentActiveColor: Qt.rgba(activeColor.r, activeColor.g, activeColor.b, 0)
    property int horizontalInset: 8
    property int contentRightPadding: 18
    property int iconGap: 8
    property int itemTopGap: 6
    property int motionDuration: 200
    property bool disabled: false
    property bool debug: false
    readonly property int collapsedPaddingLeft: Math.round(collapsedWidth / 2 - collapsedIconSize / 2)

    signal activated(string key)

    implicitWidth: collapsed ? collapsedWidth : 220
    implicitHeight: menuColumn.implicitHeight

    Theme { id: theme }


    Column {
        id: menuColumn
        width: parent.width
        spacing: 0

        Repeater {
            id: topLevelRepeater
            model: root.items
            delegate: Loader {
                width: menuColumn.width
                property var nodeData: modelData
                property int nodeLevel: 0
                property bool nodeInGroup: false
                property int nodePaddingLeftValue: root.mergedRootIndent()
                sourceComponent: menuNodeDelegateItem
                function syncItem() {
                    if (!item) return
                    item.nodeData = nodeData
                    item.level = nodeLevel
                    item.inGroup = nodeInGroup
                    item.paddingLeftValue = nodePaddingLeftValue
                }
                onLoaded: syncItem()
                onNodeDataChanged: syncItem()
                onNodeLevelChanged: syncItem()
                onNodeInGroupChanged: syncItem()
                onNodePaddingLeftValueChanged: syncItem()
            }
        }
    }

    Component {
        id: menuNodeDelegateItem
        Item {
            id: nodeRoot
            property var nodeData: null
            property int level: 0
            property bool inGroup: false
            property int paddingLeftValue: root.rootIndent
            readonly property var node: nodeData
            property bool nodeDisabled: root.disabled || node.disabled === true
            property bool hasChildren: node.type !== "group" && node.children !== undefined && node.children !== null && node.children.length > 0
            property bool childActive: root.nodeHasActiveChild(node)
            property bool expanded: false
            property bool childrenMounted: false
            property bool animatingCollapse: false
            width: menuColumn.width
            implicitHeight: node.type === "group"
                ? groupColumn.implicitHeight
                : itemWrap.implicitHeight + submenuWrap.height
            height: implicitHeight

            Component.onCompleted: {
                if (hasChildren) {
                    expanded = node.expanded === true || childActive
                    childrenMounted = expanded && !root.collapsed
                }
            }

            onChildActiveChanged: {
                if (childActive && hasChildren) {
                    expanded = true
                    childrenMounted = !root.collapsed
                }
            }
            onExpandedChanged: syncSubmenu()

            Column {
                id: groupColumn
                width: parent.width
                spacing: root.collapsed ? 0 : 6
                visible: node.type === "group"

                Text {
                    text: node.label || ""
                    color: root.groupTextColor
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    font.letterSpacing: 0.2
                    font.family: "Space Grotesk"
                    height: root.collapsed ? 0 : 36
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width - nodeRoot.paddingLeftValue
                    x: nodeRoot.paddingLeftValue
                    opacity: root.collapsed ? 0 : 1

                    Behavior on opacity {
                        NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
                    }
                    Behavior on height {
                        NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
                    }
                }

                Column {
                    width: parent.width
                    spacing: 0

                    Repeater {
                        model: node.children || []
                        delegate: Loader {
                            width: groupColumn.width
                            property var nodeData: modelData
                            property int nodeLevel: nodeRoot.level
                            property bool nodeInGroup: true
                            property int nodePaddingLeftValue: root.groupChildPadding(nodeRoot.paddingLeftValue)
                            sourceComponent: menuNodeDelegateItem
                            function syncItem() {
                                if (!item) return
                                item.nodeData = nodeData
                                item.level = nodeLevel
                                item.inGroup = nodeInGroup
                                item.paddingLeftValue = nodePaddingLeftValue
                            }
                            onLoaded: syncItem()
                            onNodeDataChanged: syncItem()
                            onNodeLevelChanged: syncItem()
                            onNodeInGroupChanged: syncItem()
                            onNodePaddingLeftValueChanged: syncItem()
                        }
                    }
                }
            }

            Item {
                id: itemWrap
                width: parent.width
                height: root.itemHeight + root.itemTopGap
                implicitHeight: height
                visible: node.type !== "group"

                Item {
                    id: itemRow
                    anchors.top: parent.top
                    anchors.topMargin: root.itemTopGap
                    x: root.collapsed ? Math.round((parent.width - root.collapsedWidth) / 2) : 0
                    width: root.collapsed ? root.collapsedWidth : parent.width
                    height: root.itemHeight

                    property bool active: String(node.key) === String(root.currentKey)
                    property bool pressed: tapHandler.pressed

                    opacity: nodeRoot.nodeDisabled ? 0.45 : 1.0

                    BrisaRoundRect {
                        id: itemBackground
                        anchors.fill: parent
                        anchors.leftMargin: root.collapsed ? 4 : root.horizontalInset
                        anchors.rightMargin: root.collapsed ? 4 : root.horizontalInset
                        fillColor: itemRow.active
                            ? (root.collapsed ? root.activeCollapsedColor : root.activeColor)
                            : ((itemRow.pressed || hoverHandler.hovered) ? root.hoverColor : root.transparentHoverColor)
                        strokeWidth: 0
                        radiusTL: root.radius
                        radiusTR: root.radius
                        radiusBR: root.radius
                        radiusBL: root.radius
                    }

                    Row {
                        id: contentRow
                        anchors.fill: parent
                        anchors.leftMargin: root.collapsed ? root.collapsedPaddingLeft : nodeRoot.paddingLeftValue
                        anchors.rightMargin: root.collapsed ? root.collapsedPaddingLeft : root.contentRightPadding
                        spacing: root.collapsed ? 0 : (contentRow.hasIcon ? root.iconGap : 0)
                        height: parent.height

                        property bool hasIcon: node.icon !== undefined && node.icon !== null

                        Loader {
                            id: iconLoader
                            width: contentRow.hasIcon ? (root.collapsed ? root.collapsedIconSize : root.iconSize) : 0
                            height: parent.height
                            sourceComponent: node.icon ? node.icon : null
                            visible: contentRow.hasIcon
                            onLoaded: function() {
                                nodeRoot.applyIconColor()
                            }
                        }

                        Item {
                            visible: !root.collapsed
                            width: Math.max(
                                0,
                                parent.width
                                    - (contentRow.hasIcon ? root.iconSize + root.iconGap : 0)
                                    - (extraText.visible ? extraText.implicitWidth + 12 : 0)
                                    - (nodeRoot.hasChildren ? 22 : 0)
                            )
                            height: parent.height

                            Text {
                                anchors.fill: parent
                                text: node.label || ""
                                color: itemRow.active || nodeRoot.childActive
                                    ? root.activeTextColor
                                    : ((itemRow.pressed || hoverHandler.hovered) ? root.hoverTextColor : root.textColor)
                                font.pixelSize: theme.fontSizeMedium
                                font.weight: Font.Normal
                                font.family: "Space Grotesk"
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Text {
                            id: extraText
                            text: node.extra || ""
                            visible: !root.collapsed && text.length > 0
                            color: itemRow.active || nodeRoot.childActive
                                ? root.activeTextColor
                                : ((itemRow.pressed || hoverHandler.hovered) ? root.hoverTextColor : root.mutedColor)
                            font.pixelSize: 13
                            font.weight: Font.Normal
                            font.family: "Space Grotesk"
                            elide: Text.ElideRight
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                        }

                        Item {
                            width: !root.collapsed && nodeRoot.hasChildren ? 16 : 0
                            height: parent.height
                            visible: !root.collapsed && nodeRoot.hasChildren

                            Image {
                                anchors.centerIn: parent
                                width: 16
                                height: 16
                                source: theme.svgChevronDown(
                                    itemRow.active || nodeRoot.childActive
                                        ? root.activeTextColor
                                        : ((itemRow.pressed || hoverHandler.hovered) ? root.hoverTextColor : theme.textColor2),
                                    16
                                )
                                rotation: nodeRoot.expanded ? 0 : -90
                                Behavior on rotation {
                                    NumberAnimation { duration: 200; easing.type: Easing.InOutCubic }
                                }
                            }
                        }

                        Text {
                            text: "[" + String(node.key) + "] / current=" + String(root.currentKey)
                                + " / active=" + String(itemRow.active)
                                + " / hover=" + String(hoverHandler.hovered)
                            color: "#94a3b8"
                            font.pixelSize: 10
                            font.family: "Space Grotesk"
                            visible: root.debug
                        }
                    }

                    HoverHandler {
                        id: hoverHandler
                        enabled: !nodeRoot.nodeDisabled
                        cursorShape: nodeRoot.nodeDisabled ? Qt.ArrowCursor : Qt.PointingHandCursor
                        onHoveredChanged: nodeRoot.applyIconColor()
                    }

                    TapHandler {
                        id: tapHandler
                        enabled: !nodeRoot.nodeDisabled
                        onTapped: {
                            if (nodeRoot.hasChildren) {
                                if (root.collapsed) {
                                    return
                                }
                                nodeRoot.expanded = !nodeRoot.expanded
                            }
                            else {
                                root.currentKey = node.key
                                root.activated(node.key)
                            }
                        }
                    }
                }

            }

            Item {
                id: submenuWrap
                width: parent.width
                y: itemWrap.height
                readonly property real expandedHeight: childrenColumn.childrenRect.height
                height: 0
                clip: true
                visible: nodeRoot.hasChildren && (nodeRoot.childrenMounted || height > 0)

                onExpandedHeightChanged: {
                    if (nodeRoot.expanded && nodeRoot.childrenMounted && !nodeRoot.animatingCollapse) {
                        height = expandedHeight
                    }
                }

                Column {
                    id: childrenColumn
                    width: parent.width
                    spacing: 0
                    opacity: nodeRoot.expanded && !root.collapsed ? 1 : 0

                    Behavior on opacity {
                        NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
                    }

                    Repeater {
                        model: node.children || []
                        delegate: Loader {
                            width: childrenColumn.width
                            property var nodeData: modelData
                            property int nodeLevel: nodeRoot.level + 1
                            property bool nodeInGroup: nodeRoot.inGroup
                            property int nodePaddingLeftValue: root.submenuChildPadding(nodeRoot.paddingLeftValue, nodeRoot.inGroup)
                            sourceComponent: menuNodeDelegateItem
                            function syncItem() {
                                if (!item) return
                                item.nodeData = nodeData
                                item.level = nodeLevel
                                item.inGroup = nodeInGroup
                                item.paddingLeftValue = nodePaddingLeftValue
                            }
                            onLoaded: syncItem()
                            onNodeDataChanged: syncItem()
                            onNodeLevelChanged: syncItem()
                            onNodeInGroupChanged: syncItem()
                            onNodePaddingLeftValueChanged: syncItem()
                        }
                    }
                }

                Behavior on height {
                    NumberAnimation { duration: root.motionDuration; easing.type: Easing.InOutCubic }
                }

                Timer {
                    id: expandStartTimer
                    interval: 1
                    repeat: false
                    onTriggered: {
                        if (!nodeRoot.childrenMounted || root.collapsed || !nodeRoot.expanded)
                            return
                        submenuWrap.height = submenuWrap.expandedHeight
                        childrenColumn.opacity = 1
                    }
                }

                Timer {
                    id: collapseStartTimer
                    interval: 1
                    repeat: false
                    onTriggered: {
                        if (nodeRoot.expanded || root.collapsed)
                            return
                        submenuWrap.height = 0
                        childrenColumn.opacity = 0
                        collapseCleanupTimer.start()
                    }
                }

                Timer {
                    id: collapseCleanupTimer
                    interval: root.motionDuration
                    repeat: false
                    onTriggered: {
                        if (!nodeRoot.expanded) {
                            nodeRoot.animatingCollapse = false
                            nodeRoot.childrenMounted = false
                        }
                    }
                }
            }

            function applyIconColor() {
                if (!itemRow || !itemRow.visible) return
                if (!itemRow.iconLoader || !itemRow.iconLoader.item) return
                var color = root.collapsed
                    ? (itemRow.active ? root.activeTextColor : root.collapsedIconColor)
                    : (itemRow.active || nodeRoot.childActive
                    ? root.activeTextColor
                    : root.iconColor)
                if (itemRow.iconLoader.item.hasOwnProperty("iconColor")) itemRow.iconLoader.item.iconColor = color
                if (itemRow.iconLoader.item.hasOwnProperty("color")) itemRow.iconLoader.item.color = color
            }

            Connections {
                target: itemRow
                function onActiveChanged() { nodeRoot.applyIconColor() }
            }

            Connections {
                target: nodeRoot
                function onChildActiveChanged() { nodeRoot.applyIconColor() }
            }

            function syncSubmenu() {
                if (!hasChildren) return
                if (root.collapsed) {
                    animatingCollapse = false
                    expandStartTimer.stop()
                    collapseStartTimer.stop()
                    submenuWrap.height = 0
                    childrenColumn.opacity = 0
                    childrenMounted = false
                    collapseCleanupTimer.stop()
                    return
                }
                if (expanded) {
                    animatingCollapse = false
                    collapseStartTimer.stop()
                    collapseCleanupTimer.stop()
                    childrenMounted = true
                    childrenColumn.opacity = 0
                    submenuWrap.height = 0
                    expandStartTimer.restart()
                }
                else {
                    animatingCollapse = true
                    expandStartTimer.stop()
                    collapseCleanupTimer.stop()
                    submenuWrap.height = submenuWrap.expandedHeight
                    childrenColumn.opacity = 1
                    collapseStartTimer.restart()
                }
            }
        }
    }

    function mergedRootIndent() {
        return root.rootIndent > 0 ? root.rootIndent : root.indent
    }

    function groupChildPadding(parentPadding) {
        return parentPadding + Math.round(root.indent / 2)
    }

    function submenuChildPadding(parentPadding, inGroup) {
        return parentPadding + (inGroup ? Math.round(root.indent / 2) : root.indent)
    }

    function nodeHasActiveChild(node) {
        if (!node || !node.children) return false
        for (var i = 0; i < node.children.length; ++i) {
            var child = node.children[i]
            if (String(child.key) === String(root.currentKey)) return true
            if (nodeHasActiveChild(child)) return true
        }
        return false
    }

    onCollapsedChanged: {
        for (var i = 0; i < topLevelRepeater.count; ++i) {
            var loader = topLevelRepeater.itemAt(i)
            if (loader && loader.item && loader.item.hasOwnProperty("syncSubmenu")) {
                loader.item.syncSubmenu()
            }
        }
    }
}
