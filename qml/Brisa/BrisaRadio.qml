import QtQuick

FocusScope {
    id: root

    property string name: ""
    property var value: "on"
    property var checked: undefined
    property bool defaultChecked: false
    property bool disabled: false
    property string label: ""
    property string size: ""
    property var group: null

    property bool internalChecked: defaultChecked

    signal updateChecked(bool checked)
    signal clicked(var value)

    Theme { id: theme }

    readonly property var resolvedGroup: group ? group : findGroup(parent)
    readonly property string mergedSize: {
        if (root.size && root.size.length)
            return root.size
        if (resolvedGroup && resolvedGroup.size)
            return resolvedGroup.size
        return "medium"
    }
    readonly property string mergedName: {
        if (root.name.length)
            return root.name
        if (resolvedGroup && resolvedGroup.name)
            return resolvedGroup.name
        return ""
    }
    readonly property int indicatorSize: theme.radioSizeFor(mergedSize)
    readonly property bool renderSafeChecked: {
        if (resolvedGroup)
            return resolvedGroup.isChecked(root.value)
        return root.checked !== undefined ? root.checked : root.internalChecked
    }
    readonly property bool mergedDisabled: root.disabled || (resolvedGroup ? resolvedGroup.disabled : false)

    implicitWidth: contentRow.implicitWidth
    implicitHeight: Math.max(indicatorSize, labelText.implicitHeight)
    activeFocusOnTab: true

    function findGroup(item) {
        var current = item
        while (current) {
            if (current.brisaRadioGroup === true)
                return current
            current = current.parent
        }
        return null
    }

    function toggle() {
        if (mergedDisabled || renderSafeChecked)
            return
        if (resolvedGroup)
            resolvedGroup.updateGroupValue(root.value)
        else if (root.checked !== undefined)
            root.checked = true
        else
            root.internalChecked = true
        root.updateChecked(true)
        root.clicked(root.value)
    }

    Keys.onPressed: function(event) {
        if (mergedDisabled)
            return
        if (event.key === Qt.Key_Space || event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            toggle()
            event.accepted = true
        }
    }

    Row {
        id: contentRow
        spacing: 0
        anchors.fill: parent

        Item {
            id: dotWrap
            width: indicatorSize
            height: root.height

            Rectangle {
                anchors.centerIn: dot
                width: dot.width + 4
                height: dot.height + 4
                radius: width / 2
                color: "transparent"
                border.width: 2
                border.color: Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.2)
                visible: root.activeFocus && !dotMouse.pressed && !root.mergedDisabled
            }

            Rectangle {
                id: dot
                width: indicatorSize
                height: indicatorSize
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                radius: width / 2
                color: root.mergedDisabled ? theme.radioColorDisabled : (root.renderSafeChecked ? theme.radioColorActive : theme.radioColor)
                border.width: 1
                border.color: "transparent"

                layer.enabled: true
                layer.smooth: true

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.width: 1
                    border.color: root.mergedDisabled
                        ? theme.borderColor
                        : ((dotMouse.containsMouse || root.renderSafeChecked) ? theme.primaryColor : theme.borderColor)
                }

                Rectangle {
                    width: Math.max(6, parent.width - 8)
                    height: width
                    radius: width / 2
                    anchors.centerIn: parent
                    color: root.mergedDisabled ? theme.radioDotColorDisabled : theme.radioDotColorActive
                    opacity: root.renderSafeChecked ? 1 : 0
                    scale: root.renderSafeChecked ? 1 : 0.8

                    Behavior on opacity {
                        NumberAnimation { duration: theme.transitionDuration; easing.type: Easing.OutCubic }
                    }
                    Behavior on scale {
                        NumberAnimation { duration: theme.transitionDuration; easing.type: Easing.OutCubic }
                    }
                }
            }

            MouseArea {
                id: dotMouse
                anchors.fill: parent
                enabled: !root.mergedDisabled
                hoverEnabled: true
                cursorShape: root.mergedDisabled ? Qt.ArrowCursor : Qt.PointingHandCursor
                onClicked: {
                    root.forceActiveFocus()
                    root.toggle()
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
