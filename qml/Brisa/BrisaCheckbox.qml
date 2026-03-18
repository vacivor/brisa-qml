import QtQuick

FocusScope {
    id: root

    property string size: ""
    property var checked: undefined
    property var defaultChecked: false
    property var value: undefined
    property bool disabled: false
    property bool indeterminate: false
    property string label: ""
    property bool focusable: true
    property var checkedValue: true
    property var uncheckedValue: false

    property var internalChecked: defaultChecked
    property var group: null

    signal updateChecked(var checked, var event)
    signal clicked(var checked, var event)

    Theme { id: theme }

    readonly property var resolvedGroup: group ? group : findGroup(parent)
    readonly property string mergedSize: {
        if (root.size && root.size.length)
            return root.size
        if (resolvedGroup && resolvedGroup.size)
            return resolvedGroup.size
        return "medium"
    }
    readonly property int indicatorSize: theme.checkboxSizeFor(mergedSize)
    readonly property bool hasLabel: label.length > 0 || labelText.text.length > 0
    readonly property bool renderedChecked: {
        if (resolvedGroup && value !== undefined)
            return resolvedGroup.containsValue(value)
        var state = root.checked !== undefined ? root.checked : root.internalChecked
        return state === root.checkedValue
    }
    readonly property bool mergedDisabled: {
        if (resolvedGroup && value !== undefined)
            return root.disabled || resolvedGroup.isDisabledFor(value, renderedChecked)
        return root.disabled || (resolvedGroup ? resolvedGroup.disabled : false)
    }
    readonly property color markColor: {
        if (mergedDisabled && renderedChecked)
            return theme.checkboxCheckMarkColorDisabledChecked
        if (mergedDisabled)
            return theme.checkboxCheckMarkColorDisabled
        return theme.checkboxCheckMarkColor
    }
    readonly property color boxColor: {
        if (mergedDisabled && renderedChecked)
            return theme.checkboxColorDisabledChecked
        if (mergedDisabled)
            return theme.checkboxColorDisabled
        if (renderedChecked || indeterminate)
            return theme.checkboxColorChecked
        return theme.checkboxColor
    }
    readonly property color borderColor: {
        if (mergedDisabled)
            return theme.borderColor
        if (renderedChecked || indeterminate || boxMouse.containsMouse)
            return theme.primaryColor
        return theme.borderColor
    }

    implicitWidth: contentRow.implicitWidth
    implicitHeight: Math.max(indicatorSize, labelText.implicitHeight)
    activeFocusOnTab: focusable

    function findGroup(item) {
        var current = item
        while (current) {
            if (current.brisaCheckboxGroup === true)
                return current
            current = current.parent
        }
        return null
    }

    function toggle(event) {
        if (mergedDisabled)
            return
        var nextChecked = !renderedChecked
        if (resolvedGroup && value !== undefined) {
            resolvedGroup.toggleCheckbox(nextChecked, value)
            root.updateChecked(nextChecked, event)
            root.clicked(nextChecked, event)
            return
        }
        var nextValue = nextChecked ? checkedValue : uncheckedValue
        if (root.checked !== undefined)
            root.checked = nextValue
        else
            root.internalChecked = nextValue
        root.updateChecked(nextValue, event)
        root.clicked(nextValue, event)
    }

    Keys.onPressed: function(event) {
        if (mergedDisabled)
            return
        if (event.key === Qt.Key_Space || event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            toggle(event)
            event.accepted = true
        }
    }

    Row {
        id: contentRow
        spacing: 0
        anchors.fill: parent

        Item {
            id: boxWrap
            width: indicatorSize
            height: root.height

            Rectangle {
                id: focusRing
                anchors.centerIn: box
                width: box.width + 4
                height: box.height + 4
                radius: box.radius + 2
                color: "transparent"
                border.width: 2
                border.color: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.3)
                visible: root.activeFocus && !boxMouse.pressed && !root.mergedDisabled
            }

            Rectangle {
                id: box
                width: indicatorSize
                height: indicatorSize
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                radius: theme.borderRadius
                color: boxColor

                Behavior on color {
                    ColorAnimation { duration: theme.transitionDuration }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.width: 1
                    border.color: root.borderColor

                    Behavior on border.color {
                        ColorAnimation { duration: theme.transitionDuration }
                    }
                }

                Item {
                    anchors.fill: parent
                    anchors.margins: 1

                    Image {
                        anchors.fill: parent
                        visible: root.renderedChecked
                        source: theme.svgCheckboxCheck(root.markColor, width)
                        smooth: true
                        mipmap: true
                        fillMode: Image.PreserveAspectFit
                        opacity: root.renderedChecked ? 1 : 0
                        scale: root.renderedChecked ? 1 : 0.5

                        Behavior on opacity {
                            NumberAnimation { duration: theme.transitionDuration; easing.type: Easing.OutCubic }
                        }
                        Behavior on scale {
                            NumberAnimation { duration: theme.transitionDuration; easing.type: Easing.OutCubic }
                        }
                    }

                    Image {
                        anchors.fill: parent
                        visible: root.indeterminate
                        source: theme.svgCheckboxLine(root.markColor, width)
                        smooth: true
                        mipmap: true
                        fillMode: Image.PreserveAspectFit
                        opacity: root.indeterminate ? 1 : 0
                        scale: root.indeterminate ? 1 : 0.5

                        Behavior on opacity {
                            NumberAnimation { duration: theme.transitionDuration; easing.type: Easing.OutCubic }
                        }
                        Behavior on scale {
                            NumberAnimation { duration: theme.transitionDuration; easing.type: Easing.OutCubic }
                        }
                    }
                }
            }

            MouseArea {
                id: boxMouse
                anchors.fill: parent
                enabled: !root.mergedDisabled
                hoverEnabled: true
                cursorShape: root.mergedDisabled ? Qt.ArrowCursor : Qt.PointingHandCursor
                onClicked: function(mouse) {
                    root.forceActiveFocus()
                    root.toggle(mouse)
                }
            }
        }

        Text {
            id: labelText
            visible: text.length > 0
            text: root.label
            height: root.height
            leftPadding: theme.choiceLabelPadding
            color: root.mergedDisabled ? theme.textColorDisabled : theme.textColor2
            font.pixelSize: theme.fontSizeFor(root.mergedSize)
            font.family: theme.fontFamily
            font.weight: theme.choiceLabelFontWeight
            lineHeight: 1.2
            verticalAlignment: Text.AlignVCenter
        }
    }
}
