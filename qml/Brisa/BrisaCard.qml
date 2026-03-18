import QtQuick
import QtQuick.Effects

Item {
    id: root

    property string title: ""
    property bool bordered: true
    property bool hoverable: false
    property bool embedded: false
    property string size: "medium" // small | medium | large | huge
    property bool contentSegmented: false
    property bool footerSegmented: false
    property bool actionSegmented: false
    property bool contentSoftSegmented: false
    property bool footerSoftSegmented: false
    property bool actionSoftSegmented: false
    property bool closable: false
    property bool contentScrollable: false
    property int contentScrollHeight: 0
    property bool showFooter: false
    property bool showAction: false

    default property alias content: contentHost.data
    property alias footer: footerInner.data
    property alias headerExtra: headerExtraRow.data
    property alias action: actionInner.data

    signal closed()

    Theme { id: theme }

    readonly property bool hasHeader: title.length > 0 || headerExtraRow.children.length > 0 || closable
    readonly property bool hasContent: contentHost.children.length > 0
    readonly property bool hasFooter: showFooter && footerInner.children.length > 0
    readonly property bool hasAction: showAction && actionInner.children.length > 0
    readonly property bool contentSoft: contentSegmented && contentSoftSegmented
    readonly property bool footerSoft: footerSegmented && footerSoftSegmented

    readonly property int paddingTop: size === "small" ? 12 : size === "large" ? 23 : size === "huge" ? 27 : 19
    readonly property int paddingBottom: size === "small" ? 12 : size === "large" ? 24 : size === "huge" ? 28 : 20
    readonly property int paddingLeft: size === "small" ? 16 : size === "large" ? 32 : size === "huge" ? 40 : 24
    readonly property int fontSize: 14
    readonly property int titleFontSize: size === "small" ? 16 : 18
    readonly property int closeSize: 22
    readonly property int closeIconSize: 18
    readonly property color cardColor: embedded ? theme.actionColor : theme.baseColor
    readonly property color effectiveBorderColor: theme.dividerColor
    readonly property color titleColor: theme.textColor1
    readonly property color textColor: theme.textColor2
    readonly property color closeIconColor: Qt.rgba(0, 0, 0, 0.52)
    readonly property color closeIconColorHover: Qt.rgba(0, 0, 0, 0.52)
    readonly property color closeIconColorPressed: Qt.rgba(0, 0, 0, 0.52)
    readonly property color closeHoverColor: Qt.rgba(0, 0, 0, 0.09)
    readonly property color closePressedColor: Qt.rgba(0, 0, 0, 0.13)

    readonly property int headerInnerHeight: Math.max(titleText.implicitHeight, headerExtraRow.implicitHeight, closable ? closeSize : 0)
    readonly property int contentTopPadding: contentSegmented ? paddingBottom : (hasHeader ? 0 : paddingBottom)
    readonly property int footerTopPadding: footerSegmented ? paddingBottom : ((hasHeader || hasContent) ? 0 : paddingBottom)
    readonly property int actionTopPadding: paddingBottom
    readonly property int actionBottomPadding: paddingBottom
    readonly property int scrollBarReserve: 0
    readonly property int contentViewportHeight: root.contentScrollable && root.contentScrollHeight > 0
        ? Math.max(0, root.contentScrollHeight + root.contentTopPadding + root.paddingBottom)
        : Math.max(0, contentHost.implicitHeight + root.contentTopPadding + root.paddingBottom)

    implicitWidth: 320
    implicitHeight: cardColumn.implicitHeight

    Column {
        id: contentHost
        parent: root
        width: parent ? parent.width : 0
        spacing: 0
    }

    function reparentContentHost() {
        if (root.contentScrollable) {
            contentHost.parent = scrollContentSlot
        } else {
            contentHost.parent = plainContentSlot
        }
    }

    Component.onCompleted: reparentContentHost()
    onContentScrollableChanged: reparentContentHost()

    Item {
        anchors.fill: parent

        Item {
            anchors.fill: shell
            visible: root.hoverable

            MultiEffect {
                anchors.fill: parent
                source: shell
                shadowEnabled: hoverHandler.hovered
                shadowColor: Qt.rgba(0, 0, 0, 0.08)
                shadowBlur: 0.08
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 1
                opacity: hoverHandler.hovered ? 1 : 0
                visible: true
                Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
            }

            MultiEffect {
                anchors.fill: parent
                source: shell
                shadowEnabled: hoverHandler.hovered
                shadowColor: Qt.rgba(0, 0, 0, 0.06)
                shadowBlur: 0.18
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 3
                opacity: hoverHandler.hovered ? 1 : 0
                visible: true
                Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
            }

            MultiEffect {
                anchors.fill: parent
                source: shell
                shadowEnabled: hoverHandler.hovered
                shadowColor: Qt.rgba(0, 0, 0, 0.04)
                shadowBlur: 0.34
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 5
                opacity: hoverHandler.hovered ? 1 : 0
                visible: true
                Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
            }
        }

        Rectangle {
            id: shell
            anchors.fill: parent
            radius: theme.borderRadius
            color: root.cardColor
            border.width: root.bordered ? 1 : 0
            border.color: root.bordered ? root.effectiveBorderColor : "transparent"

            Behavior on color {
                ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
            }
            Behavior on border.color {
                ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
            }
        }

        HoverHandler {
            id: hoverHandler
            enabled: root.hoverable
        }

        Column {
            id: cardColumn
            width: parent.width
            spacing: 0

            Item {
                id: headerSection
                width: parent.width
                implicitHeight: root.hasHeader ? (root.paddingTop + root.paddingBottom + root.headerInnerHeight) : 0
                height: implicitHeight
                visible: root.hasHeader

                Item {
                    x: root.paddingLeft
                    y: root.paddingTop
                    width: Math.max(0, parent.width - root.paddingLeft * 2)
                    height: Math.max(0, parent.height - root.paddingTop - root.paddingBottom)

                    Text {
                        id: titleText
                        visible: root.title.length > 0
                        text: root.title
                        color: root.titleColor
                        font.family: theme.fontFamily
                        font.pixelSize: root.titleFontSize
                        font.weight: Font.DemiBold
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: Math.max(0, parent.width - headerRight.width - (headerRight.visible ? 12 : 0))
                    }

                    Row {
                        id: headerRight
                        visible: headerExtraRow.children.length > 0 || root.closable
                        spacing: 0
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        Row {
                            id: headerExtraRow
                            spacing: 8
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Item {
                            width: headerExtraRow.children.length > 0 && root.closable ? 8 : 0
                            height: 1
                        }

                        Item {
                            width: root.closable ? root.closeSize : 0
                            height: root.closable ? root.closeSize : 0
                            visible: root.closable

                            Rectangle {
                                anchors.fill: parent
                                radius: theme.borderRadius
                                color: closeMouse.containsMouse
                                    ? (closeMouse.pressed ? root.closePressedColor : root.closeHoverColor)
                                    : "transparent"
                            }

                            Image {
                                anchors.centerIn: parent
                                width: root.closeIconSize
                                height: root.closeIconSize
                                source: theme.svgClose("#000000", root.closeIconSize)
                                opacity: closeMouse.containsMouse
                                    ? (closeMouse.pressed ? 0.7 : 0.52)
                                    : 0.52
                            }

                            MouseArea {
                                id: closeMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                preventStealing: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.closed()
                            }
                        }
                    }
                }
            }

            Item {
                id: contentSection
                width: parent.width
                implicitHeight: root.hasContent ? (contentDivider.visible ? 1 : 0) + contentViewport.height : 0
                height: implicitHeight
                visible: root.hasContent

                Rectangle {
                    id: contentDivider
                    visible: root.contentSegmented && root.hasHeader
                    x: root.contentSoft ? root.paddingLeft : 0
                    y: 0
                    width: root.contentSoft ? Math.max(0, parent.width - root.paddingLeft * 2) : Math.max(0, parent.width)
                    height: visible ? 1 : 0
                    color: root.effectiveBorderColor
                }

                Item {
                    id: contentViewport
                    x: 0
                    y: contentDivider.height
                    width: Math.max(0, parent.width)
                    height: root.contentViewportHeight
                    clip: root.contentScrollable

                    Item {
                        id: plainContentSlot
                        visible: !root.contentScrollable
                        x: root.paddingLeft
                        y: root.contentTopPadding
                        width: Math.max(0, parent.width - root.paddingLeft * 2 - root.scrollBarReserve)
                        height: contentHost.implicitHeight
                    }

                    Flickable {
                        id: contentFlick
                        anchors.fill: parent
                        visible: root.contentScrollable
                        acceptedButtons: Qt.NoButton
                        interactive: false
                        clip: root.contentScrollable
                        contentWidth: width
                        contentHeight: contentHost.implicitHeight + root.contentTopPadding + root.paddingBottom
                        boundsBehavior: Flickable.StopAtBounds

                        Item {
                            width: Math.max(0, parent.width)
                            height: parent.contentHeight

                            Item {
                                id: scrollContentSlot
                                x: root.paddingLeft
                                y: root.contentTopPadding
                                width: Math.max(0, parent.width - root.paddingLeft * 2 - root.scrollBarReserve)
                                height: contentHost.implicitHeight
                            }
                        }
                    }

                    WheelHandler {
                        enabled: root.contentScrollable && contentFlick.contentHeight > contentFlick.height
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                        onWheel: function(event) {
                            var range = Math.max(0, contentFlick.contentHeight - contentFlick.height)
                            if (range <= 0) {
                                event.accepted = false
                                return
                            }
                            contentFlick.contentY = Math.max(0, Math.min(range, contentFlick.contentY - event.angleDelta.y))
                            event.accepted = true
                        }
                    }

                    BrisaScrollBar {
                        id: cardContentScrollBar
                        flickable: contentFlick
                        visible: root.contentScrollable
                    }
                }
            }

            Item {
                id: footerSection
                width: parent.width
                implicitHeight: root.hasFooter ? (footerDivider.visible ? 1 : 0) + footerBody.height : 0
                height: implicitHeight
                visible: root.hasFooter

                Rectangle {
                    id: footerDivider
                    visible: root.footerSegmented && (root.hasHeader || root.hasContent)
                    x: root.footerSoft ? root.paddingLeft : 0
                    y: 0
                    width: root.footerSoft ? Math.max(0, parent.width - root.paddingLeft * 2) : Math.max(0, parent.width)
                    height: visible ? 1 : 0
                    color: root.effectiveBorderColor
                }

                Item {
                    id: footerBody
                    x: 0
                    y: footerDivider.height
                    width: Math.max(0, parent.width)
                    height: root.footerTopPadding + footerInner.implicitHeight + root.paddingBottom

                    Column {
                        id: footerInner
                        x: root.paddingLeft
                        y: root.footerTopPadding
                        width: Math.max(0, parent.width - root.paddingLeft * 2)
                        spacing: 0
                    }

                }
            }

            Item {
                id: actionSection
                width: parent.width
                implicitHeight: root.hasAction ? (actionDivider.visible ? 1 : 0) + actionBody.height : 0
                height: implicitHeight
                visible: root.hasAction

                Rectangle {
                    id: actionDivider
                    visible: root.actionSegmented && (root.hasHeader || root.hasContent || root.hasFooter)
                    x: root.actionSoft ? root.paddingLeft : 0
                    y: 0
                    width: root.actionSoft ? Math.max(0, parent.width - root.paddingLeft * 2) : Math.max(0, parent.width)
                    height: visible ? 1 : 0
                    color: root.effectiveBorderColor
                }

                Item {
                    id: actionBody
                    y: actionDivider.height
                    width: Math.max(0, parent.width)
                    height: root.actionTopPadding + actionInner.implicitHeight + root.actionBottomPadding

                    BrisaRoundRect {
                        anchors.fill: parent
                        fillColor: theme.actionColor
                        strokeWidth: 0
                        radiusTL: 0
                        radiusTR: 0
                        radiusBR: theme.borderRadius
                        radiusBL: theme.borderRadius
                    }

                    Column {
                        id: actionInner
                        x: root.paddingLeft
                        y: root.actionTopPadding
                        width: Math.max(0, parent.width - root.paddingLeft * 2)
                        spacing: 0
                    }

                }
            }
        }
    }
}
