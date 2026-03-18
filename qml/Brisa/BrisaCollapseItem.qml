import QtQuick

Item {
    id: root

    property bool __isBrisaCollapseItem: true
    property var name
    property string title: ""
    property string extra: ""
    property bool disabled: false
    property bool displayArrow: true
    property bool defaultExpanded: false
    property var collapse: null
    property bool expanded: false
    property bool first: false
    property bool last: false
    property bool onceExpanded: false

    default property alias content: contentHost.data
    property alias headerExtra: headerExtraHost.data

    implicitWidth: parent ? parent.width : 320
    implicitHeight: itemTopMargin + headerHeight + contentWrap.height

    readonly property bool interactive: !disabled && collapse
    readonly property int itemTopMargin: first ? 0 : (collapse ? collapse.itemMarginTop : 16)
    readonly property int headerHorizontalPadding: collapse ? collapse.headerHorizontalPadding : 0
    readonly property int contentHorizontalPadding: collapse ? collapse.contentHorizontalPadding : 0
    readonly property int contentTopPadding: collapse ? collapse.contentTopPadding : 16
    readonly property int headerTopPadding: first ? 0 : (collapse ? collapse.headerTopPadding : 16)
    readonly property int headerBottomPadding: collapse ? collapse.headerBottomPadding : 0
    readonly property int contentBottomPadding: collapse ? collapse.contentBottomPadding : 0
    readonly property int arrowSize: collapse ? collapse.arrowSize : 16
    readonly property int arrowGap: collapse ? collapse.arrowGap : 4
    readonly property int titleFontSize: collapse ? collapse.titleFontSize : 14
    readonly property int extraFontSize: collapse ? collapse.extraFontSize : 14
    readonly property int headerExtraGap: collapse ? collapse.headerExtraGap : 8
    readonly property bool arrowOnLeft: !collapse || collapse.arrowPlacement !== "right"
    readonly property bool arrowVisible: displayArrow
    readonly property bool hasExtraText: extra.length > 0
    readonly property bool hasHeaderExtra: headerExtraHost.childrenRect.width > 0 && headerExtraHost.childrenRect.height > 0
    readonly property bool useShowDirective: collapse && collapse.displayDirective === "show"
    readonly property bool shouldRenderContent: useShowDirective ? (onceExpanded || expanded) : expanded
    readonly property int embeddedInsetX: collapse && collapse.embedded ? 8 : 0
    readonly property int embeddedInsetTop: collapse && collapse.embedded ? 6 : 0
    readonly property int embeddedInsetBottom: collapse && collapse.embedded ? 2 : 0
    readonly property int headerContentHeight: Math.max(titleText.implicitHeight, arrowVisible ? arrowSize : 0, headerExtraHost.childrenRect.height)
    readonly property int headerHeight: headerTopPadding + headerContentHeight + headerBottomPadding
    readonly property int affixGap: hasExtraText ? 8 : 0
    readonly property int mainGap: hasHeaderExtra ? headerExtraGap : 0
    readonly property int headerExtraWidth: hasHeaderExtra ? headerExtraHost.childrenRect.width : 0
    readonly property int arrowSpace: arrowVisible ? (arrowSize + arrowGap) : 0
    readonly property int headerMainWidth: Math.max(0, header.width - headerExtraWidth - mainGap)
    readonly property int titleBlockWidth: Math.max(0, headerMainWidth - arrowSpace)
    readonly property int titleTextWidth: Math.max(0, titleBlockWidth - (hasExtraText ? extraText.implicitWidth + affixGap : 0))
    readonly property real expandedHeight: contentTopPadding + contentHost.childrenRect.height + contentBottomPadding
    readonly property color titleColor: disabled ? theme.textColorDisabled : theme.textColor1
    readonly property color extraColor: disabled ? theme.textColorDisabled : theme.textColor3
    readonly property color arrowColor: disabled ? theme.textColorDisabled : theme.textColor2
    readonly property color dividerColor: collapse && collapse.embedded
        ? Qt.rgba(theme.dividerColor.r, theme.dividerColor.g, theme.dividerColor.b, 0.55)
        : theme.dividerColor
    readonly property color embeddedFillColor: {
        var clearBase = Qt.rgba(theme.baseColor.r, theme.baseColor.g, theme.baseColor.b, 0)
        if (!collapse || !collapse.embedded)
            return clearBase
        if (expanded)
            return theme.baseColor
        return clearBase
    }

    Theme {
        id: theme
    }

    function handleToggle(area, event) {
        if (!interactive || triggerAreas.indexOf(area) < 0)
            return
        collapse.toggleItem(name, event)
    }

    readonly property var triggerAreas: collapse ? collapse.triggerAreas : ["main", "arrow", "extra"]

    onExpandedChanged: {
        if (expanded)
            onceExpanded = true
    }

    Rectangle {
        visible: collapse && collapse.embedded
        x: embeddedInsetX
        y: itemTopMargin + embeddedInsetTop
        width: parent.width - embeddedInsetX * 2
        height: headerHeight - embeddedInsetTop - embeddedInsetBottom
        radius: theme.borderRadius
        color: embeddedFillColor
    }

    Rectangle {
        visible: !first && collapse && collapse.showDividers && !collapse.embedded
        x: embeddedInsetX
        y: itemTopMargin
        width: parent.width - embeddedInsetX * 2
        height: 1
        color: dividerColor
    }

    Item {
        id: header
        x: headerHorizontalPadding
        y: itemTopMargin
        width: Math.max(0, parent.width - headerHorizontalPadding * 2)
        height: headerHeight

        Item {
            id: headerMain
            x: 0
            y: headerTopPadding
            width: headerMainWidth
            height: headerContentHeight

            Item {
                id: arrowWrapLeading
                visible: arrowVisible && arrowOnLeft
                x: 0
                y: Math.round((parent.height - arrowSize) / 2)
                width: arrowSize
                height: arrowSize

                MouseArea {
                    id: arrowLeadingMouseArea
                    anchors.fill: parent
                    enabled: interactive && triggerAreas.indexOf("arrow") >= 0
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: function(mouse) { root.handleToggle("arrow", mouse) }
                }

                Image {
                    anchors.fill: parent
                    source: theme.svgChevronRight(arrowColor, arrowSize)
                    rotation: expanded ? 90 : 0
                    fillMode: Image.PreserveAspectFit
                    smooth: true

                    Behavior on rotation {
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }
                }
            }

            Item {
                id: titleBlock
                x: arrowOnLeft ? arrowSpace : 0
                width: titleBlockWidth
                height: parent.height

                MouseArea {
                    id: mainMouseArea
                    anchors.fill: parent
                    enabled: interactive && triggerAreas.indexOf("main") >= 0
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: function(mouse) { root.handleToggle("main", mouse) }
                }

                Text {
                    id: titleText
                    width: titleTextWidth
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.title
                    color: titleColor
                    font.family: theme.fontFamily
                    font.pixelSize: titleFontSize
                    font.weight: Font.Normal
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: extraText
                    visible: hasExtraText
                    anchors.left: titleText.right
                    anchors.leftMargin: affixGap
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.extra
                    color: extraColor
                    font.family: theme.fontFamily
                    font.pixelSize: extraFontSize
                    font.weight: Font.Normal
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Item {
                id: arrowWrapTrailing
                visible: arrowVisible && !arrowOnLeft
                x: headerMainWidth - arrowSize
                y: Math.round((parent.height - arrowSize) / 2)
                width: arrowSize
                height: arrowSize

                MouseArea {
                    id: arrowTrailingMouseArea
                    anchors.fill: parent
                    enabled: interactive && triggerAreas.indexOf("arrow") >= 0
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: function(mouse) { root.handleToggle("arrow", mouse) }
                }

                Image {
                    anchors.fill: parent
                    source: theme.svgChevronRight(arrowColor, arrowSize)
                    rotation: expanded ? 90 : 0
                    fillMode: Image.PreserveAspectFit
                    smooth: true

                    Behavior on rotation {
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }
                }
            }
        }

        Item {
            id: headerExtraWrap
            visible: hasHeaderExtra
            x: header.width - headerExtraWidth
            y: headerTopPadding + Math.round((headerContentHeight - headerExtraHost.childrenRect.height) / 2)
            width: headerExtraWidth
            height: headerExtraHost.childrenRect.height

            MouseArea {
                id: extraMouseArea
                anchors.fill: parent
                enabled: interactive && triggerAreas.indexOf("extra") >= 0
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: function(mouse) { root.handleToggle("extra", mouse) }
            }

            Item {
                id: headerExtraHost
                width: childrenRect.width
                height: childrenRect.height
            }
        }
    }

    Item {
        id: contentWrap
        y: itemTopMargin + headerHeight
        width: parent.width
        height: shouldRenderContent && expanded ? expandedHeight : 0
        clip: true
        visible: shouldRenderContent

        Behavior on height {
            enabled: collapse ? collapse.animated : true
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }

        Item {
            id: contentInner
            x: contentHorizontalPadding
            y: 0
            width: Math.max(0, parent.width - contentHorizontalPadding * 2)
            height: expandedHeight
            opacity: expanded ? 1 : 0
            visible: shouldRenderContent

            Behavior on opacity {
                enabled: collapse ? collapse.animated : true
                NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
            }

            Item {
                id: contentHost
                y: contentTopPadding
                width: parent.width
                implicitWidth: childrenRect.width
                implicitHeight: childrenRect.height
            }
        }
    }
}
