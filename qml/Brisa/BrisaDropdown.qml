import QtQuick

BrisaPopover {
    id: root
    property var model: []
    property string size: "medium" // small | medium | large | huge
    property string activeKey: ""
    showArrow: false
    property int optionHeight: theme.heightFor(size) - 2
    property int optionFontSize: theme.fontSizeFor(size) - 1
    property int optionPaddingX: 12
    property int optionInset: 4
    property int groupHeight: optionHeight - 4
    property int minWidth: 160

    signal selected(string key)

    paddingX: 4
    paddingY: 4
    popupHeight: contentColumn.implicitHeight + paddingY * 2
    outsideClosable: true
    blocksUnderlay: true

    popupWidth: Math.max(minWidth, contentColumn.implicitWidth + paddingX * 2)

    Column {
        id: contentColumn
        spacing: 0

        Repeater {
            model: root.model
            delegate: Item {
                id: row
                width: Math.max(0, root.popupWidth - root.paddingX * 2)
                height: {
                    if (!modelData) return 0
                    if (modelData.type === "divider") return 1 + 8
                    if (modelData.type === "group") return root.groupHeight
                    return root.optionHeight
                }

                Rectangle {
                    visible: modelData && modelData.type === "divider"
                    height: 1
                    width: Math.max(0, parent.width - root.optionInset * 2)
                    color: theme.dividerColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: root.optionInset
                }

                Text {
                    visible: modelData && modelData.type === "group"
                    text: modelData.label || ""
                    color: theme.textColor3
                    font.pixelSize: root.optionFontSize - 1
                    font.weight: Font.Medium
                    font.family: "Space Grotesk"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: root.optionPaddingX
                }

                Item {
                    id: optionBody
                    visible: !modelData || (modelData.type !== "divider" && modelData.type !== "group")
                    anchors.fill: parent

                    property bool hovered: hoverHandler.hovered
                    property bool disabled: modelData ? (modelData.disabled === true) : false
                    property bool active: modelData ? (String(modelData.key) === String(root.activeKey)) : false

                    Rectangle {
                        anchors.fill: parent
                        anchors.leftMargin: root.optionInset
                        anchors.rightMargin: root.optionInset
                        radius: theme.borderRadius
                        color: optionBody.active
                            ? Qt.rgba(theme.primaryColor.r, theme.primaryColor.g, theme.primaryColor.b, 0.1)
                            : (optionBody.hovered ? Qt.rgba(0, 0, 0, 0.03) : "transparent")
                    }

                    Row {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height
                        anchors.leftMargin: root.optionPaddingX
                        anchors.rightMargin: root.optionPaddingX
                        spacing: 6

                        Loader {
                            width: modelData && modelData.icon ? root.optionFontSize + 4 : 0
                            height: modelData && modelData.icon ? root.optionFontSize + 4 : 0
                            sourceComponent: modelData && modelData.icon ? modelData.icon : null
                            visible: !!(modelData && modelData.icon)
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: modelData ? (modelData.label || "") : ""
                            color: optionBody.disabled
                                ? theme.textColor3
                                : (optionBody.active ? theme.primaryColor : theme.textColor2)
                            font.pixelSize: root.optionFontSize
                            font.weight: optionBody.active ? Font.DemiBold : Font.Medium
                            font.family: "Space Grotesk"
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                            anchors.verticalCenter: parent.verticalCenter
                            lineHeightMode: Text.FixedHeight
                            lineHeight: root.optionHeight - 6
                            opacity: optionBody.disabled ? theme.opacityDisabled : 1
                        }
                    }

                    HoverHandler { id: hoverHandler; enabled: !optionBody.disabled; cursorShape: Qt.PointingHandCursor }
                    MouseArea {
                        anchors.fill: parent
                        enabled: !optionBody.disabled
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        propagateComposedEvents: false
                        onPressed: function(mouse) { mouse.accepted = true }
                        onClicked: {
                            root.activeKey = modelData.key
                            root.selected(modelData.key)
                            root.closeRequested()
                        }
                    }
                }
            }
        }
    }
}
