import QtQuick
import QtQuick.Effects

FocusScope {
    id: root

    property string size: "medium"
    property var value: undefined
    property bool loading: false
    property var defaultValue: false
    property bool disabled: false
    property bool round: true
    property var checkedValue: true
    property var uncheckedValue: false
    property bool rubberBand: true
    property var railStyle: null
    property Component checkedContent: null
    property Component uncheckedContent: null
    property Component iconContent: null
    property Component checkedIconContent: null
    property Component uncheckedIconContent: null

    property var internalValue: defaultValue
    property bool pressed: false
    property bool hovered: false

    signal updateValue(var value)

    Theme { id: theme }

    readonly property bool checked: (root.value !== undefined ? root.value : root.internalValue) === root.checkedValue
    readonly property int railHeight: theme.switchRailHeightFor(size)
    readonly property int baseRailWidth: theme.switchRailWidthFor(size)
    readonly property int buttonHeight: theme.switchButtonHeightFor(size)
    readonly property int buttonWidth: theme.switchButtonWidthFor(size)
    readonly property int buttonWidthPressed: theme.switchButtonWidthPressedFor(size)
    readonly property int offset: Math.round((railHeight - buttonHeight) / 2)
    readonly property int buttonPlaceholderWidth: Math.round(1.75 * railHeight)
    readonly property int railWidth: Math.max(
        baseRailWidth,
        checkedMeasure.implicitWidth,
        uncheckedMeasure.implicitWidth
    )
    readonly property int totalWidth: Math.max(railWidth, railWidth + buttonHeight - railHeight)
    readonly property int totalHeight: Math.max(railHeight, buttonHeight)
    readonly property bool effectiveRubberBand: rubberBand && !hasCustomIcon
    readonly property int activeButtonWidth: effectiveRubberBand && pressed ? buttonWidthPressed : buttonWidth
    readonly property int buttonX: checked
        ? totalWidth - activeButtonWidth - offset
        : offset
    readonly property color railColor: {
        var style = root.railStyle ? root.railStyle({ focused: root.activeFocus, checked: root.checked }) : null
        if (style && style.background)
            return style.background
        return checked ? theme.switchRailColorActive : theme.switchRailColor
    }
    readonly property color thumbIconColor: theme.switchIconColor
    readonly property bool hasCustomIcon: !!root.iconContent || !!(checked ? root.checkedIconContent : root.uncheckedIconContent)
    readonly property int contentSidePadding: Math.round(1.25 * railHeight - offset)
    readonly property int loadingSize: theme.switchLoadingSizeFor(size)

    implicitWidth: totalWidth
    implicitHeight: totalHeight
    activeFocusOnTab: true

    function commit(nextValue) {
        if (root.value !== undefined)
            root.value = nextValue
        else
            root.internalValue = nextValue
        root.updateValue(nextValue)
    }

    function toggle() {
        if (root.disabled || root.loading)
            return
        commit(checked ? uncheckedValue : checkedValue)
    }

    Keys.onPressed: function(event) {
        if (root.disabled || root.loading)
            return
        if (event.key === Qt.Key_Space) {
            root.pressed = true
            event.accepted = true
        }
    }

    Keys.onReleased: function(event) {
        if (root.disabled || root.loading)
            return
        if (event.key === Qt.Key_Space) {
            root.pressed = false
            root.toggle()
            event.accepted = true
        }
    }

    Rectangle {
        anchors.fill: rail
        radius: root.round ? height / 2 : theme.borderRadius
        color: "transparent"
        border.width: 2
        border.color: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.2)
        visible: root.activeFocus
    }

    Item {
        id: rail
        width: root.totalWidth
        height: root.totalHeight

        Item {
            id: measureLayer
            visible: false

            Row {
                id: checkedMeasure
                spacing: 0
                Item {
                    width: root.buttonPlaceholderWidth
                    height: root.railHeight
                }
                Loader {
                    active: !!root.checkedContent
                    sourceComponent: root.checkedContent
                }
            }

            Row {
                id: uncheckedMeasure
                spacing: 0
                Item {
                    width: root.buttonPlaceholderWidth
                    height: root.railHeight
                }
                Loader {
                    active: !!root.uncheckedContent
                    sourceComponent: root.uncheckedContent
                }
            }
        }

        Rectangle {
            id: railBackground
            x: 0
            y: Math.round((parent.height - root.railHeight) / 2)
            width: root.railWidth
            height: root.railHeight
            radius: root.round ? root.railHeight / 2 : theme.borderRadius
            color: root.railColor
            opacity: root.disabled ? theme.opacityDisabled : 1
            border.width: !root.round ? 1 : 0
            border.color: root.round ? "transparent" : (theme.dark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.08))

            Behavior on color {
                ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
            }
            Behavior on opacity {
                NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }
        }

        Item {
            id: thumbWrap
            x: root.buttonX
            y: root.offset
            width: root.activeButtonWidth
            height: root.buttonHeight
            opacity: root.disabled ? theme.opacityDisabled : 1
            clip: false

            Behavior on x {
                NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }
            Behavior on width {
                NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }

            Rectangle {
                id: thumbCore
                anchors.fill: parent
                radius: root.round ? height / 2 : theme.borderRadius
                color: theme.switchButtonColor
                scale: root.pressed ? 0.995 : 1

                Behavior on scale {
                    NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                }
            }

            MultiEffect {
                anchors.fill: thumbCore
                source: thumbCore
                shadowEnabled: true
                shadowBlur: root.hovered ? 0.3 : 0.25
                shadowColor: theme.dark ? Qt.rgba(0, 0, 0, root.hovered ? 0.42 : 0.36) : Qt.rgba(0, 0, 0, root.hovered ? 0.3 : 0.26)
                shadowVerticalOffset: root.hovered ? 1.2 : 1
                shadowHorizontalOffset: 0
            }

            IconSwitch {
                id: thumbState
                anchors.centerIn: parent
                size: Math.max(root.loadingSize, root.buttonWidth - 4)
                active: root.loading || root.hasCustomIcon
                showFirst: root.loading
                first: Component {
                    LoadingSpinner {
                        size: root.loadingSize
                        stroke: theme.switchLoadingColor
                        strokeWidth: theme.spinStrokeWidthFor(root.size)
                        radius: 100
                        scale: 1
                    }
                }
                second: Component {
                    Loader {
                        anchors.centerIn: parent
                        active: root.hasCustomIcon
                        sourceComponent: root.checked
                            ? (root.checkedIconContent ? root.checkedIconContent : root.iconContent)
                            : (root.uncheckedIconContent ? root.uncheckedIconContent : root.iconContent)
                    }
                }
            }

            Item {
                id: checkedTextWrap
                width: checkedLoader.implicitWidth
                clip: false
                x: parent.width - width - root.contentSidePadding
                height: root.railHeight
                anchors.verticalCenter: parent.verticalCenter
                visible: checkedLoader.active
                opacity: root.checked ? 1 : 0
                scale: root.checked ? 1 : 0.94

                Behavior on opacity {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }
                Behavior on scale {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }

                Loader {
                    id: checkedLoader
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    active: !!root.checkedContent
                    sourceComponent: root.checkedContent
                }
            }

            Item {
                id: uncheckedTextWrap
                x: root.contentSidePadding
                width: uncheckedLoader.implicitWidth
                height: root.railHeight
                anchors.verticalCenter: parent.verticalCenter
                clip: false
                visible: uncheckedLoader.active
                opacity: root.checked ? 0 : 1
                scale: root.checked ? 0.94 : 1

                Behavior on opacity {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }
                Behavior on scale {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }

                Loader {
                    id: uncheckedLoader
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    active: !!root.uncheckedContent
                    sourceComponent: root.uncheckedContent
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: !root.disabled
            hoverEnabled: true
            cursorShape: root.disabled ? Qt.ArrowCursor : (root.loading ? Qt.BusyCursor : Qt.PointingHandCursor)
            onEntered: root.hovered = true
            onExited: root.hovered = false
            onPressed: root.pressed = true
            onReleased: root.pressed = false
            onCanceled: root.pressed = false
            onClicked: {
                root.forceActiveFocus()
                root.toggle()
            }
        }
    }
}
