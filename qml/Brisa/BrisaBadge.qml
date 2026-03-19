import QtQuick

Item {
    id: root

    property var value: undefined
    property int max: -1
    property bool dot: false
    property string type: "default" // default | error | info | success | warning
    property bool show: true
    property bool showZero: false
    property bool processing: false
    property var color: undefined
    property var offset: undefined

    default property alias content: contentHost.data
    property alias badgeContent: valueHost.data

    Theme { id: theme }

    readonly property bool hasContent: contentHost.children.length > 0
    readonly property bool rawMode: !hasContent
    readonly property bool hasCustomBadgeContent: valueHost.children.length > 0
    readonly property bool hasValue: value !== undefined && value !== null && String(value).length > 0
    readonly property real numericValue: Number(value)
    readonly property bool numericComparable: !isNaN(numericValue)
    readonly property bool zeroHidden: !showZero && numericComparable && numericValue <= 0
    readonly property bool showBadge: show && (dot || hasCustomBadgeContent || (hasValue && !zeroHidden))
    readonly property color resolvedColor: color !== undefined ? color : colorForType(type)
    readonly property string displayValue: formattedValue()
    readonly property int badgeHeight: dot ? 8 : 18
    readonly property int badgeMinWidth: dot ? 8 : 18
    readonly property int badgeRadius: dot ? 4 : 9
    readonly property int horizontalPadding: dot ? 0 : 6
    readonly property int valueFontSize: 12
    readonly property real offsetX: parseOffsetEntry(0)
    readonly property real offsetY: parseOffsetEntry(1)
    readonly property real badgeWidth: {
        if (dot)
            return 8
        if (hasCustomBadgeContent)
            return Math.max(badgeMinWidth, valueHost.childrenRect.width + horizontalPadding * 2)
        return Math.max(badgeMinWidth, valueText.implicitWidth + horizontalPadding * 2)
    }
    readonly property real badgeX: {
        if (rawMode)
            return offsetX
        if (dot)
            return contentHost.width - 8 + offsetX
        return contentHost.width - badgeWidth / 2 + offsetX
    }
    readonly property real badgeY: {
        if (rawMode)
            return offsetY
        if (dot)
            return 0 + offsetY
        return -badgeHeight / 2 + offsetY
    }

    implicitWidth: rawMode
        ? (showBadge ? badgeWidth : 0)
        : contentHost.childrenRect.width
    implicitHeight: rawMode
        ? (showBadge ? badgeHeight : 0)
        : contentHost.childrenRect.height

    function colorForType(kind) {
        switch (String(kind)) {
        case "info":
            return theme.infoColor
        case "success":
            return theme.successColor
        case "warning":
            return theme.warningColor
        case "error":
            return theme.errorColor
        default:
            return theme.errorColor
        }
    }

    function formattedValue() {
        if (!hasValue)
            return ""
        if (max >= 0 && numericComparable && numericValue > max)
            return String(max) + "+"
        return String(value)
    }

    function parseOffsetEntry(index) {
        if (!offset || offset.length <= index)
            return 0
        var entry = offset[index]
        if (typeof entry === "number")
            return Number(entry)
        var stringValue = String(entry)
        if (stringValue.indexOf("px") > -1)
            return Number(stringValue.replace("px", ""))
        var parsed = Number(stringValue)
        return isNaN(parsed) ? 0 : parsed
    }

    Item {
        id: contentHost
        width: childrenRect.width
        height: childrenRect.height
    }

    Item {
        id: badgeWrap
        visible: showBadge
        x: badgeX
        y: badgeY
        width: badgeWidth
        height: badgeHeight
        z: 2
        opacity: showBadge ? 1 : 0
        scale: showBadge ? 1 : 0.85

        Behavior on opacity {
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }

        Rectangle {
            id: badgeSurface
            anchors.fill: parent
            radius: badgeRadius
            color: resolvedColor
        }

        Item {
            id: valueHost
            anchors.centerIn: parent
            width: childrenRect.width
            height: childrenRect.height
            visible: hasCustomBadgeContent
        }

        Text {
            id: valueText
            visible: !dot && !hasCustomBadgeContent
            anchors.centerIn: parent
            text: displayValue
            color: "#ffffff"
            font.family: theme.fontFamily
            font.pixelSize: valueFontSize
            font.weight: Font.Medium
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Rectangle {
            visible: processing
            anchors.fill: badgeSurface
            radius: badgeRadius
            color: "transparent"
            border.width: 1
            border.color: resolvedColor
            opacity: 0
            scale: 1

            SequentialAnimation on scale {
                loops: Animation.Infinite
                running: processing && showBadge
                NumberAnimation { from: 1; to: 1.9; duration: 2000; easing.type: Easing.OutCubic }
            }

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: processing && showBadge
                NumberAnimation { from: 0.6; to: 0; duration: 2000; easing.type: Easing.OutCubic }
            }
        }
    }
}
