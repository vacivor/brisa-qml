import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property bool __isBrisaListItem: true
    property var list: null
    property bool last: false

    property string title: ""
    property string description: ""
    property string extra: ""
    property bool clickable: false
    property bool disabled: false
    property bool showDivider: true
    property bool showArrow: false
    property Component prefixComponent
    property Component suffixComponent
    property Component bodyComponent
    property bool section: false

    signal clicked()

    Theme { id: theme }

    readonly property bool effectiveClickable: !root.disabled && (root.clickable || (!!root.list && root.list.clickable))
    readonly property int horizontalPadding: list ? list.horizontalPadding : 0
    readonly property int verticalPadding: list ? list.verticalPadding : 12
    readonly property int prefixGap: 20
    readonly property int suffixGap: 20
    readonly property int sectionInset: root.section ? 20 : 0
    readonly property int titleFontSize: root.section ? 13 : (root.list && root.list.size === "small" ? 13 : 14)
    readonly property int descriptionFontSize: root.list && root.list.size === "small" ? 13 : 14
    readonly property int extraFontSize: root.section ? 13 : (root.list && root.list.size === "large" ? 14 : 13)
    readonly property int descriptionLineHeight: root.list && root.list.size === "large" ? 22 : 20
    readonly property color titleColor: disabled ? theme.textColorDisabled : theme.textColor1
    readonly property color descriptionColor: disabled ? theme.textColorDisabled : theme.textColor3
    readonly property color extraColor: disabled ? theme.textColorDisabled : theme.textColor3
    readonly property color hoverColor: Qt.rgba(0, 0, 0, 0.022)
    readonly property color pressedColor: Qt.rgba(0, 0, 0, 0.042)
    readonly property bool hasPrefix: !!prefixComponent
    readonly property bool hasSuffix: !!suffixComponent || showArrow || extra.length > 0
    readonly property real contentAreaHeight: Math.max(0, root.height - divider.height)

    implicitHeight: Math.max(contentColumn.implicitHeight, prefixLoader.implicitHeight, suffixRow.implicitHeight)
        + verticalPadding * 2 + divider.height

    Rectangle {
        id: backgroundRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: root.contentAreaHeight
        radius: root.list && root.list.hoverable ? Math.max(theme.borderRadius, 4) : 0
        color: mouseArea.pressed ? root.pressedColor : (mouseArea.containsMouse ? root.hoverColor : "transparent")
        visible: root.list && root.list.hoverable

        Behavior on color {
            ColorAnimation { duration: 140; easing.type: Easing.OutCubic }
        }
    }

    Loader {
        id: prefixLoader
        active: root.hasPrefix
        anchors.left: parent.left
        anchors.leftMargin: root.horizontalPadding + root.sectionInset
        anchors.verticalCenter: backgroundRect.verticalCenter
        sourceComponent: root.prefixComponent
    }

    Column {
        id: contentColumn
        anchors.left: parent.left
        anchors.leftMargin: root.horizontalPadding + root.sectionInset + (root.hasPrefix ? prefixLoader.width + root.prefixGap : 0)
        anchors.right: suffixRow.left
        anchors.rightMargin: root.hasSuffix ? root.suffixGap : (root.horizontalPadding + root.sectionInset)
        anchors.top: parent.top
        anchors.topMargin: root.section ? 10 : root.verticalPadding
        spacing: root.title.length > 0 && (root.description.length > 0 || !!root.bodyComponent)
            ? (root.section ? 2 : (root.list && root.list.size === "large" ? 5 : 4))
            : 0

        Text {
            visible: root.title.length > 0
            width: parent.width
            text: root.title
            color: root.section ? theme.textColor3 : root.titleColor
            font.family: theme.fontFamily
            font.pixelSize: root.titleFontSize
            font.weight: root.section ? Font.Medium : Font.Normal
            renderType: Text.NativeRendering
            elide: Text.ElideRight
        }

        Column {
            width: parent.width
            spacing: root.description.length > 0 && !!root.bodyComponent ? 8 : 0

            Text {
                visible: root.description.length > 0
                width: parent.width
                text: root.description
                color: root.descriptionColor
                font.family: theme.fontFamily
                font.pixelSize: root.descriptionFontSize
                renderType: Text.NativeRendering
                wrapMode: Text.Wrap
                lineHeightMode: Text.FixedHeight
                lineHeight: root.descriptionLineHeight
            }

            Loader {
                active: !!root.bodyComponent
                visible: active
                width: parent.width
                sourceComponent: root.bodyComponent
            }
        }
    }

    Row {
        id: suffixRow
        anchors.right: parent.right
        anchors.rightMargin: root.horizontalPadding + root.sectionInset
        anchors.verticalCenter: backgroundRect.verticalCenter
        spacing: root.section ? 6 : 8

        Text {
            visible: root.extra.length > 0
            text: root.extra
            color: root.section ? theme.textColorDisabled : root.extraColor
            font.family: theme.fontFamily
            font.pixelSize: root.extraFontSize
            font.weight: root.section ? Font.Medium : Font.Normal
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
        }

        Loader {
            active: !!root.suffixComponent
            visible: active
            anchors.verticalCenter: undefined
            sourceComponent: root.suffixComponent
        }

        Image {
            visible: root.showArrow
            width: 14
            height: 14
            opacity: root.section ? 0.72 : 1
            source: theme.svgChevronRight(root.disabled ? theme.iconColorDisabled : (root.section ? theme.iconColorHover : theme.iconColor), 14)
        }
    }

    Rectangle {
        id: divider
        visible: root.showDivider && !root.last && !!root.list && root.list.showDividers
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        height: visible ? 1 : 0
        color: mouseArea.containsMouse ? "transparent" : theme.dividerColor

        Behavior on color {
            ColorAnimation { duration: 140; easing.type: Easing.OutCubic }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.effectiveClickable
        hoverEnabled: enabled
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }
}
