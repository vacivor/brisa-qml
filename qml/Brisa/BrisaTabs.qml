import QtQuick
import QtQuick.Layouts

Item {
    id: root

    default property alias panes: panesViewport.data
    property alias prefix: prefixHost.data
    property alias suffix: suffixHost.data

    property var value: undefined
    property var defaultValue: undefined
    property string type: "line" // line | bar | card | segment
    property string size: "medium"
    property string placement: "top" // top | bottom | left | right
    property bool animated: true
    property string trigger: "click" // click | hover
    property bool justifyContent: false
    property bool closable: false
    property real tabMinWidth: 80

    readonly property bool lineType: type === "line"
    readonly property bool barType: type === "bar"
    readonly property bool cardType: type === "card"
    readonly property bool segmentType: type === "segment"
    readonly property bool verticalPlacement: placement === "left" || placement === "right"
    readonly property bool leftPlacement: placement === "left"
    readonly property bool rightPlacement: placement === "right"
    readonly property bool bottomPlacement: placement === "bottom"
    readonly property bool topPlacement: placement === "top"
    readonly property color tabSurfaceColor: theme.dark ? "#25292f" : "#f7f7fa"

    property var paneData: []
    property var uncontrolledValue: undefined
    readonly property var currentValue: value !== undefined ? value : uncontrolledValue

    signal updateValue(var value)
    signal close(var name)

    implicitWidth: root.verticalPlacement
        ? navSection.implicitWidth + paneSection.implicitWidth
        : Math.max(navSection.implicitWidth, paneSection.implicitWidth)
    implicitHeight: root.verticalPlacement
        ? Math.max(navSection.implicitHeight, paneSection.implicitHeight)
        : navSection.implicitHeight + paneSection.implicitHeight

    Theme {
        id: theme
    }

    function tabFontSize() {
        if (root.size === "large") return 16
        return 14
    }

    function panePaddingTop() {
        if (root.size === "small") return 8
        if (root.size === "large") return 16
        return 12
    }

    function panePaddingSide() {
        if (root.size === "small") return 12
        if (root.size === "large") return 20
        return 16
    }

    function panePaddingVerticalTop() {
        if (root.size === "small") return 8
        if (root.size === "large") return 16
        return 12
    }

    function panePaddingVerticalBottom() {
        return 0
    }

    function horizontalTabPaddingY() {
        if (root.segmentType) {
            if (root.size === "small") return 4
            if (root.size === "large") return 8
            return 6
        }
        if (root.cardType) {
            if (root.size === "small") return 8
            if (root.size === "large") return 12
            return 10
        }
        if (root.barType) {
            if (root.size === "small") return 4
            if (root.size === "large") return 10
            return 6
        }
        if (root.size === "small") return 6
        if (root.size === "large") return 14
        return 10
    }

    function horizontalTabPaddingX() {
        if (root.segmentType) return 0
        if (root.cardType) {
            if (root.size === "small") return 16
            if (root.size === "large") return 24
            return 20
        }
        return 0
    }

    function verticalTabPaddingX() {
        if (root.segmentType) {
            if (root.size === "small") return 4
            if (root.size === "large") return 8
            return 6
        }
        if (root.cardType) {
            if (root.size === "small") return 12
            if (root.size === "large") return 20
            return 16
        }
        if (root.barType) {
            if (root.size === "small") return 12
            if (root.size === "large") return 20
            return 16
        }
        if (root.size === "small") return 12
        if (root.size === "large") return 20
        return 16
    }

    function verticalTabPaddingY() {
        if (root.segmentType) return 0
        if (root.cardType) {
            if (root.size === "small") return 8
            if (root.size === "large") return 12
            return 10
        }
        if (root.barType) {
            if (root.size === "small") return 6
            if (root.size === "large") return 10
            return 8
        }
        if (root.size === "small") return 6
        if (root.size === "large") return 10
        return 8
    }

    function tabGap() {
        if (root.segmentType) return 0
        if (root.cardType) return 4
        return 36
    }

    function tabGapVertical() {
        if (root.segmentType || root.cardType) return 4
        return 8
    }

    function tabHeight() {
        if (root.segmentType) {
            if (root.size === "small") return 28
            if (root.size === "large") return 40
            return 34
        }
        var fontSize = tabFontSize()
        return Math.round(fontSize * 1.5 + horizontalTabPaddingY() * 2)
    }

    function tabWidth() {
        if (root.segmentType) return 128
        if (root.cardType) {
            if (root.size === "small") return 112
            if (root.size === "large") return 144
            return 128
        }
        if (root.size === "small") return 120
        if (root.size === "large") return 156
        return 136
    }

    function tabTextColor(active, hovered, disabled) {
        if (disabled) return theme.textColorDisabled
        if (root.segmentType) {
            if (active || hovered) return theme.textColor2
            return theme.textColor1
        }
        if (root.cardType) {
            if (active) return theme.primaryColor
            if (hovered) return theme.textColor1
            return theme.textColor1
        }
        if (active || hovered) return theme.primaryColor
        return theme.textColor1
    }

    function inactiveTabOpacity(disabled, active) {
        if (disabled) return 0.6
        if (root.segmentType) return active ? 1 : 0.82
        if (root.cardType) return 1
        return 1
    }

    function firstEnabledPaneName() {
        for (var i = 0; i < paneData.length; ++i) {
            if (!paneData[i].disabled) return paneData[i].name
        }
        return undefined
    }

    function syncPanes() {
        var panes = []
        for (var i = 0; i < panesViewport.children.length; ++i) {
            var child = panesViewport.children[i]
            if (child && child.__isBrisaTabPane === true) panes.push(child)
        }
        paneData = panes
        if (root.currentValue === undefined && paneData.length > 0) {
            uncontrolledValue = root.defaultValue !== undefined ? root.defaultValue : firstEnabledPaneName()
        }
        updatePanes()
        Qt.callLater(updateIndicator)
    }

    function activateTab(name) {
        if (name === undefined || name === null) return
        if (root.value === undefined) uncontrolledValue = name
        root.updateValue(name)
        Qt.callLater(updateIndicator)
    }

    function updatePanes() {
        for (var i = 0; i < paneData.length; ++i) {
            var pane = paneData[i]
            var active = pane.name === root.currentValue
            pane.width = Qt.binding(function() { return panesViewport.width })
            pane.x = 0
            pane.y = 0
            pane.z = active ? 1 : 0
            if (root.animated) {
                pane.visible = true
                pane.opacity = active ? 1 : 0
                pane.enabled = active
            } else if (pane.displayDirective === "show") {
                pane.visible = true
                pane.opacity = active ? 1 : 0
                pane.enabled = active
            } else {
                pane.visible = active
                pane.opacity = 1
                pane.enabled = active
            }
        }
    }

    function updateIndicator() {
        if (root.cardType) return
        var activeDelegate = null
        if (root.verticalPlacement) {
            for (var j = 0; j < verticalTabRepeater.count; ++j) {
                var verticalItem = verticalTabRepeater.itemAt(j)
                if (verticalItem && verticalItem.pane && verticalItem.pane.name === root.currentValue) {
                    activeDelegate = verticalItem
                    break
                }
            }
        } else {
            for (var i = 0; i < tabRepeater.count; ++i) {
                var item = tabRepeater.itemAt(i)
                if (item && item.pane && item.pane.name === root.currentValue) {
                    activeDelegate = item
                    break
                }
            }
        }
        if (!activeDelegate) {
            activeBar.opacity = 0
            segmentCapsule.opacity = 0
            return
        }
        if (root.segmentType) {
            var segmentPosition = activeDelegate.mapToItem(navFrame, 0, 0)
            segmentCapsule.opacity = 1
            segmentCapsule.x = segmentPosition.x
            segmentCapsule.y = segmentPosition.y + Math.round((segmentRail.height - activeDelegate.height) / 2)
            segmentCapsule.width = activeDelegate.width
            segmentCapsule.height = activeDelegate.height
        } else {
            activeBar.opacity = 1
            if (root.verticalPlacement) {
                activeBar.x = root.leftPlacement ? navFrame.width - activeBar.width : 0
                activeBar.y = activeDelegate.y
                activeBar.height = activeDelegate.height
            } else {
                activeBar.x = activeDelegate.x
                activeBar.width = activeDelegate.width
            }
        }
    }

    onCurrentValueChanged: {
        updatePanes()
        Qt.callLater(updateIndicator)
    }

    onWidthChanged: Qt.callLater(updateIndicator)
    onTypeChanged: Qt.callLater(updateIndicator)
    onPlacementChanged: Qt.callLater(updateIndicator)

        Item {
            id: navSection
            x: root.rightPlacement ? paneSection.implicitWidth : 0
            y: root.bottomPlacement ? paneSection.implicitHeight : 0
            width: root.verticalPlacement ? navFrame.implicitWidth : root.width
            height: root.verticalPlacement ? root.height : navFrame.implicitHeight
            implicitWidth: navFrame.implicitWidth
            implicitHeight: navFrame.implicitHeight

        Item {
            id: navFrame
            width: root.verticalPlacement ? navBodyVertical.implicitWidth + (root.lineType || root.barType ? 1 : 0) : parent.width
            height: root.verticalPlacement ? parent.height : navBody.implicitHeight + (root.lineType ? 1 : 0)
            implicitWidth: width
            implicitHeight: root.verticalPlacement ? height : navBody.implicitHeight + (root.lineType ? 1 : 0)

            Rectangle {
                visible: root.lineType && !root.verticalPlacement
                x: 0
                y: root.bottomPlacement ? 0 : parent.height - 1
                width: parent.width
                height: 1
                color: theme.dividerColor
            }

            Rectangle {
                visible: root.lineType && root.verticalPlacement
                x: root.leftPlacement ? parent.width - 1 : 0
                y: 0
                width: 1
                height: parent.height
                color: theme.dividerColor
            }

            Rectangle {
                id: segmentRail
                visible: root.segmentType
                x: 0
                y: 0
                width: parent.width
                height: tabHeight() + 6
                radius: theme.borderRadius
                color: root.tabSurfaceColor
                border.color: theme.dark ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.02)
                border.width: 1
            }

            Rectangle {
                id: segmentCapsule
                visible: root.segmentType
                x: 3
                y: 3
                width: 0
                height: tabHeight()
                radius: theme.borderRadius
                color: theme.baseColor
                opacity: 0
                border.color: "transparent"
                layer.enabled: true
                layer.smooth: true
                z: 0
                scale: opacity > 0 ? 1 : 0.985

                Behavior on x {
                    enabled: root.animated
                    NumberAnimation { duration: 200; easing.type: Easing.InOutCubic }
                }
                Behavior on width {
                    enabled: root.animated
                    NumberAnimation { duration: 200; easing.type: Easing.InOutCubic }
                }
                Behavior on opacity {
                    enabled: root.animated
                    NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
                }
                Behavior on scale {
                    enabled: root.animated
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }
            }

            Row {
                id: navBody
                visible: !root.verticalPlacement
                width: parent.width
                spacing: 0

                Item {
                    id: prefixHost
                    visible: !root.verticalPlacement && children.length > 0
                    width: visible ? childrenRect.width + 16 : 0
                    height: tabRow.height
                }

                Item {
                    width: root.segmentType ? 3 : 0
                    height: 1
                }

                Row {
                    id: tabRow
                    width: root.segmentType
                        ? parent.width - prefixHost.width - suffixHost.width - (root.segmentType ? 6 : 0)
                        : Math.max(0, parent.width - prefixHost.width - suffixHost.width)
                    height: tabHeight() + (root.cardType ? 1 : 0)
                    spacing: root.justifyContent || root.segmentType ? 0 : tabGap()

                    Repeater {
                        id: tabRepeater
                        model: root.paneData

                        delegate: Item {
                            id: tabItem
                            required property var modelData
                            property var pane: modelData
                            property bool active: pane.name === root.currentValue
                            property bool hovered: tabHover.hovered
                            property bool disabled: pane.disabled
                            readonly property real textWidth: Math.ceil(labelText.implicitWidth)
                            readonly property bool showClose: root.cardType && (root.closable || pane.closable)
                            readonly property real baseWidth: root.segmentType
                                ? Math.max(0, (tabRow.width / Math.max(1, tabRepeater.count)))
                                : (textWidth + root.horizontalTabPaddingX() * 2 + (showClose ? 24 : 0))
                            width: root.segmentType
                                ? baseWidth
                                : (root.cardType ? Math.max(root.tabMinWidth, baseWidth) : textWidth)
                            height: tabHeight() + (root.cardType ? 1 : 0)

                            BrisaRoundRect {
                                anchors.fill: parent
                                radiusTL: root.cardType && !root.bottomPlacement ? theme.borderRadius : 0
                                radiusTR: root.cardType && !root.bottomPlacement ? theme.borderRadius : 0
                                radiusBL: root.cardType && root.bottomPlacement ? theme.borderRadius : 0
                                radiusBR: root.cardType && root.bottomPlacement ? theme.borderRadius : 0
                                fillColor: root.cardType
                                    ? (tabItem.active ? theme.baseColor : root.tabSurfaceColor)
                                    : "transparent"
                                strokeColor: root.cardType ? theme.dividerColor : "transparent"
                                strokeWidth: root.cardType ? 1 : 0

                                Behavior on fillColor {
                                    ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                                }
                            }

                            Rectangle {
                                visible: root.cardType && tabItem.active
                                x: 1
                                y: root.bottomPlacement ? 0 : parent.height - 1
                                width: parent.width - 2
                                height: 2
                                color: theme.baseColor
                            }

                            Text {
                                id: labelText
                                anchors.centerIn: parent
                                text: pane.tab || String(pane.name)
                                color: root.tabTextColor(tabItem.active, tabItem.hovered, tabItem.disabled)
                                opacity: root.inactiveTabOpacity(tabItem.disabled, tabItem.active)
                                font.family: theme.fontFamily
                                font.pixelSize: root.tabFontSize()
                                font.weight: root.segmentType && tabItem.active ? Font.DemiBold : Font.Normal
                                elide: Text.ElideRight

                                Behavior on color {
                                    ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                                }
                                Behavior on opacity {
                                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                                }
                            }

                            Item {
                                visible: tabItem.showClose
                                width: 18
                                height: 18
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 6

                                Rectangle {
                                    anchors.fill: parent
                                    radius: theme.borderRadius
                                    color: closePress.pressed
                                        ? (theme.dark ? Qt.rgba(1, 1, 1, 0.16) : Qt.rgba(0, 0, 0, 0.13))
                                        : (closeHover.hovered ? (theme.dark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.09)) : "transparent")

                                    Behavior on color {
                                        ColorAnimation { duration: 120; easing.type: Easing.OutCubic }
                                    }
                                }

                                Image {
                                    anchors.centerIn: parent
                                    width: 12
                                    height: 12
                                    source: theme.svgClose(theme.dark ? "#ffffff" : "#000000", 12)
                                    opacity: closePress.pressed ? (theme.dark ? 0.88 : 0.72) : (closeHover.hovered ? (theme.dark ? 0.8 : 0.6) : (theme.dark ? 0.68 : 0.52))

                                    Behavior on opacity {
                                        NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                                    }
                                }

                                HoverHandler {
                                    id: closeHover
                                    enabled: !tabItem.disabled
                                    cursorShape: Qt.PointingHandCursor
                                }

                                TapHandler {
                                    id: closePress
                                    enabled: !tabItem.disabled
                                    gesturePolicy: TapHandler.ReleaseWithinBounds
                                    onTapped: {
                                        root.close(tabItem.pane.name)
                                        eventPoint.accepted = true
                                    }
                                }
                            }

                            HoverHandler {
                                id: tabHover
                                enabled: !tabItem.disabled
                                cursorShape: tabItem.disabled ? Qt.ArrowCursor : Qt.PointingHandCursor
                            }

                            TapHandler {
                                enabled: !tabItem.disabled && root.trigger === "click"
                                onTapped: root.activateTab(tabItem.pane.name)
                            }

                            HoverHandler {
                                enabled: !tabItem.disabled && root.trigger === "hover"
                                onHoveredChanged: {
                                    if (hovered) root.activateTab(tabItem.pane.name)
                                }
                            }
                        }
                    }
                }

                Item {
                    width: root.segmentType ? 3 : 0
                    height: 1
                }

                Item {
                    id: suffixHost
                    visible: !root.verticalPlacement && children.length > 0
                    width: visible ? childrenRect.width + 16 : 0
                    height: tabRow.height
                }
            }

            Column {
                id: navBodyVertical
                visible: root.verticalPlacement
                width: root.tabWidth()
                height: parent.height
                spacing: 0

                Item {
                    visible: prefixVerticalHost.children.length > 0
                    width: parent.width
                    height: visible ? prefixVerticalHost.childrenRect.height + 12 : 0

                    Item {
                        id: prefixVerticalHost
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 0
                    }
                }

                Column {
                    id: tabColumn
                    width: parent.width
                    spacing: root.tabGapVertical()

                    Repeater {
                        id: verticalTabRepeater
                        model: root.paneData

                        delegate: Item {
                            id: tabItemVertical
                            required property var modelData
                            property var pane: modelData
                            property bool active: pane.name === root.currentValue
                            property bool hovered: tabHoverVertical.hovered
                            property bool disabled: pane.disabled
                            readonly property bool showClose: root.cardType && (root.closable || pane.closable)
                            width: parent.width
                            height: root.tabHeight()

                            BrisaRoundRect {
                                anchors.fill: parent
                                radiusTL: root.cardType && !root.rightPlacement ? theme.borderRadius : 0
                                radiusTR: root.cardType && root.rightPlacement ? theme.borderRadius : 0
                                radiusBL: root.cardType && !root.rightPlacement ? theme.borderRadius : 0
                                radiusBR: root.cardType && root.rightPlacement ? theme.borderRadius : 0
                                fillColor: root.cardType
                                    ? (tabItemVertical.active ? theme.baseColor : root.tabSurfaceColor)
                                    : "transparent"
                                strokeColor: root.cardType ? theme.dividerColor : "transparent"
                                strokeWidth: root.cardType ? 1 : 0

                                Behavior on fillColor {
                                    ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                                }
                            }

                                Row {
                                anchors.fill: parent
                                anchors.leftMargin: root.verticalTabPaddingX()
                                anchors.rightMargin: root.verticalTabPaddingX()
                                spacing: 6

                                Text {
                                    width: parent.width - (tabItemVertical.showClose ? 24 : 0)
                                    height: parent.height
                                    text: tabItemVertical.pane.tab || String(tabItemVertical.pane.name)
                                    color: root.tabTextColor(tabItemVertical.active, tabItemVertical.hovered, tabItemVertical.disabled)
                                    opacity: root.inactiveTabOpacity(tabItemVertical.disabled, tabItemVertical.active)
                                    font.family: theme.fontFamily
                                    font.pixelSize: root.tabFontSize()
                                    font.weight: root.segmentType && tabItemVertical.active ? Font.DemiBold : Font.Normal
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter

                                    Behavior on color {
                                        ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                                    }
                                    Behavior on opacity {
                                        NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                                    }
                                }

                                Item {
                                    visible: tabItemVertical.showClose
                                    width: 18
                                    height: parent.height

                                    Image {
                                        anchors.centerIn: parent
                                        width: 12
                                        height: 12
                                        source: theme.svgClose(theme.dark ? "#ffffff" : "#000000", 12)
                                        opacity: closePressVertical.pressed ? (theme.dark ? 0.88 : 0.72) : (closeHoverVertical.hovered ? (theme.dark ? 0.8 : 0.6) : (theme.dark ? 0.68 : 0.52))

                                        Behavior on opacity {
                                            NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                                        }
                                    }

                                    HoverHandler {
                                        id: closeHoverVertical
                                        enabled: !tabItemVertical.disabled
                                        cursorShape: Qt.PointingHandCursor
                                    }

                                    TapHandler {
                                        id: closePressVertical
                                        enabled: !tabItemVertical.disabled
                                        gesturePolicy: TapHandler.ReleaseWithinBounds
                                        onTapped: {
                                            root.close(tabItemVertical.pane.name)
                                            eventPoint.accepted = true
                                        }
                                    }
                                }
                            }

                            HoverHandler {
                                id: tabHoverVertical
                                enabled: !tabItemVertical.disabled
                                cursorShape: tabItemVertical.disabled ? Qt.ArrowCursor : Qt.PointingHandCursor
                            }

                            TapHandler {
                                enabled: !tabItemVertical.disabled && root.trigger === "click"
                                onTapped: root.activateTab(tabItemVertical.pane.name)
                            }

                            HoverHandler {
                                enabled: !tabItemVertical.disabled && root.trigger === "hover"
                                onHoveredChanged: {
                                    if (hovered) root.activateTab(tabItemVertical.pane.name)
                                }
                            }
                        }
                    }
                }

                Item {
                    visible: suffixVerticalHost.children.length > 0
                    width: parent.width
                    height: visible ? suffixVerticalHost.childrenRect.height + 12 : 0

                    Item {
                        id: suffixVerticalHost
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                    }
                }
            }

            Rectangle {
                id: activeBar
                visible: root.lineType || root.barType
                x: root.verticalPlacement
                    ? (root.leftPlacement ? navFrame.width - 2 : 0)
                    : 0
                y: root.verticalPlacement ? 0 : (root.bottomPlacement ? 0 : tabRow.height)
                width: root.verticalPlacement ? 2 : 0
                height: root.verticalPlacement ? 0 : 2
                radius: 1
                color: theme.primaryColor
                opacity: 0
                z: 2
                scale: opacity > 0 ? 1 : 0.92

                Behavior on x {
                    enabled: root.animated && !root.verticalPlacement
                    NumberAnimation { duration: 200; easing.type: Easing.InOutCubic }
                }
                Behavior on width {
                    enabled: root.animated && !root.verticalPlacement
                    NumberAnimation { duration: 200; easing.type: Easing.InOutCubic }
                }
                Behavior on y {
                    enabled: root.animated && root.verticalPlacement
                    NumberAnimation { duration: 200; easing.type: Easing.InOutCubic }
                }
                Behavior on height {
                    enabled: root.animated && root.verticalPlacement
                    NumberAnimation { duration: 200; easing.type: Easing.InOutCubic }
                }
                Behavior on opacity {
                    enabled: root.animated
                    NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                }
                Behavior on scale {
                    enabled: root.animated
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }
        }
    }

    Item {
        id: paneSection
        x: root.leftPlacement ? navSection.implicitWidth + panePaddingSide() : 0
        y: root.topPlacement ? navSection.implicitHeight : 0
        width: root.verticalPlacement ? Math.max(0, root.width - navSection.implicitWidth - panePaddingSide()) : root.width
        height: root.verticalPlacement ? root.height : implicitHeight
        implicitWidth: width
        implicitHeight: root.verticalPlacement ? height : panesViewport.implicitHeight + panePaddingTop()

        Item {
            id: panesViewport
            x: 0
            y: root.verticalPlacement ? panePaddingVerticalTop() : panePaddingTop()
            width: parent.width
            onChildrenChanged: root.syncPanes()
            implicitWidth: width
            implicitHeight: {
                for (var i = 0; i < root.paneData.length; ++i) {
                    if (root.paneData[i].name === root.currentValue) return root.paneData[i].implicitHeight
                }
                return 0
            }
        }

        Rectangle {
            visible: root.cardType && !root.verticalPlacement
            x: 0
            y: root.bottomPlacement ? 0 : -1
            width: parent.width
            height: 1
            color: theme.dividerColor
        }

        Rectangle {
            visible: root.cardType && root.verticalPlacement
            x: root.leftPlacement ? -1 : parent.width
            y: 0
            width: 1
            height: parent.height
            color: theme.dividerColor
        }
    }

    Behavior on implicitHeight {
        enabled: root.animated && !root.verticalPlacement
        NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
    }

    Item {
        visible: false
        Connections {
            target: panesViewport
            function onWidthChanged() { Qt.callLater(root.updateIndicator) }
        }
    }

    Component.onCompleted: syncPanes()
}
