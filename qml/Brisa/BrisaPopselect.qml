import QtQuick

BrisaPopover {
    id: popselect
    property var options: []
    property var value: ""
    property var values: []
    property bool multiple: false
    property string size: "medium"
    property int optionHeight: theme.heightFor(size)
    property int optionFontSize: theme.fontSizeFor(size)
    property int optionPaddingLeft: theme.selectOptionPaddingLeft
    property int optionPaddingRight: theme.selectOptionPaddingRight
    property int optionInset: theme.selectOptionInset
    property int minWidth: 180
    property real popupWidthOverride: 0
    property string headerText: ""
    property string emptyText: ""

    signal updateValue(var value, var option)

    paddingX: 4
    paddingY: 4
    showArrow: false
    popupWidth: popupWidthOverride > 0
        ? popupWidthOverride
        : Math.max(minWidth, contentColumn.implicitWidth + paddingX * 2)

    Flickable {
        id: listScroll
        width: popselect.popupWidth
        height: Math.min(240, contentColumn.implicitHeight)
        contentHeight: contentColumn.implicitHeight
        clip: true
        interactive: contentColumn.implicitHeight > height

        WheelHandler {
            enabled: listScroll.contentHeight > listScroll.height + 1
                || listScroll.contentWidth > listScroll.width + 1
            target: listScroll
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onWheel: function(event) {
                var dy = event.angleDelta.y
                if (dy === 0) return
                var maxY = Math.max(0, listScroll.contentHeight - listScroll.height)
                if (maxY <= 0) {
                    event.accepted = false
                    return
                }
                var next = listScroll.contentY - dy
                listScroll.contentY = Math.max(0, Math.min(maxY, next))
                event.accepted = true
            }
        }

        Column {
            id: contentColumn
            width: listScroll.width
            spacing: 0

            Item {
                visible: headerText.length > 0
                width: Math.max(0, popselect.popupWidth - popselect.paddingX * 2)
                height: headerText.length > 0 ? 28 : 0

                Text {
                    text: popselect.headerText
                    color: theme.textColor3
                    font.pixelSize: 12
                    font.family: "Space Grotesk"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: popselect.optionPaddingLeft + popselect.optionInset
                }
            }

            Repeater {
                model: popselect.options
                delegate: Item {
                    id: row
                    width: Math.max(0, popselect.popupWidth - popselect.paddingX * 2)
                    height: popselect.optionHeight

                    property bool disabled: modelData ? (modelData.disabled === true) : false
                    property bool active: {
                        if (!modelData) return false
                        if (popselect.multiple) {
                            return Array.isArray(popselect.values) && popselect.values.indexOf(modelData.value) >= 0
                        }
                        return String(modelData.value) === String(popselect.value)
                    }

                    Rectangle {
                        anchors.fill: parent
                        anchors.leftMargin: popselect.optionInset
                        anchors.rightMargin: popselect.optionInset
                        radius: theme.borderRadius
                        color: hoverHandler.hovered ? theme.hoverColor : "transparent"
                    }

                    Item {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height
                        anchors.leftMargin: popselect.optionPaddingLeft
                        anchors.rightMargin: popselect.optionPaddingRight

                        Text {
                            id: label
                            text: modelData ? (modelData.label || "") : ""
                            color: row.disabled
                                ? theme.textColor3
                                : (row.active ? theme.primaryColor : theme.textColor2)
                            font.pixelSize: popselect.optionFontSize
                            font.weight: Font.Normal
                            font.family: "Space Grotesk"
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: check.left
                            anchors.rightMargin: theme.selectOptionCheckReserve - theme.selectOptionCheckSize
                            opacity: row.disabled ? theme.opacityDisabled : 1
                        }

                        Image {
                            id: check
                            width: theme.selectOptionCheckSize
                            height: theme.selectOptionCheckSize
                            opacity: row.active ? 1 : 0
                            source: theme.svgCheck(theme.primaryColor, theme.selectOptionCheckSize)
                            anchors.right: parent.right
                            anchors.rightMargin: Math.max(0, popselect.optionPaddingRight - 4)
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    HoverHandler { id: hoverHandler; enabled: !row.disabled; cursorShape: Qt.PointingHandCursor }
                    MouseArea {
                        anchors.fill: parent
                        enabled: !row.disabled
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        propagateComposedEvents: false
                        onPressed: function(mouse) { mouse.accepted = true }
                        onClicked: {
                            if (popselect.multiple) {
                                var arr = Array.isArray(popselect.values) ? popselect.values.slice(0) : []
                                var idx = arr.indexOf(modelData.value)
                                if (idx >= 0) arr.splice(idx, 1)
                                else arr.push(modelData.value)
                                popselect.values = arr
                                popselect.updateValue(arr, modelData)
                            } else {
                                popselect.value = modelData.value
                                popselect.updateValue(modelData.value, modelData)
                                popselect.closeRequested()
                            }
                        }
                    }
                }
            }

            Item {
                visible: popselect.options.length === 0
                width: Math.max(0, popselect.popupWidth - popselect.paddingX * 2)
                height: 36

                Text {
                    text: popselect.emptyText.length > 0 ? popselect.emptyText : "No data"
                    color: theme.textColor3
                    font.pixelSize: 12
                    font.family: "Space Grotesk"
                    anchors.centerIn: parent
                }
            }
        }
    }

    BrisaScrollBar {
        id: popupScrollBar
        flickable: listScroll
        visible: listScroll.contentHeight > listScroll.height
    }
}
