import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property string title: ""
    property string titlePlacement: "center" // left | center | right
    property bool dashed: false
    property bool vertical: false
    property bool compact: false

    default property alias content: titleHost.data

    Theme { id: theme }

    readonly property bool hasTitle: title.length > 0 || titleHost.children.length > 0
    readonly property int titleSideMargin: 12
    readonly property int edgeShortWidth: 28
    readonly property int lineThickness: 1
    readonly property int titleHeight: titleRow.implicitHeight
    readonly property int contentHeight: Math.max(titleHeight, 16)
    readonly property int verticalHeight: 16
    readonly property int verticalInset: 8
    readonly property int dashWidth: 6
    readonly property int dashGap: 4
    readonly property int dashUnit: dashWidth + dashGap
    readonly property int titleTextImplicitWidth: titleTextItem.visible ? titleTextItem.implicitWidth : 0
    readonly property int titleContentWidth: titleHost.implicitWidth + titleTextImplicitWidth

    readonly property int compactHeight: hasTitle ? contentHeight : lineThickness

    implicitWidth: vertical ? (lineThickness + verticalInset * 2) : 160
    implicitHeight: vertical ? verticalHeight : (compact ? compactHeight : contentHeight + 48)

    Item {
        anchors.fill: parent
        visible: !root.vertical

        Rectangle {
            visible: !root.hasTitle && !root.dashed
            anchors.left: parent.left
            anchors.right: parent.right
            y: Math.round((parent.height - height) / 2)
            height: root.lineThickness
            color: theme.dividerColor
        }

        Item {
            visible: !root.hasTitle && root.dashed
            anchors.fill: parent
            Repeater {
                model: Math.max(0, Math.ceil(Math.max(0, parent.width) / root.dashUnit))
                delegate: Rectangle {
                    x: index * root.dashUnit
                    y: Math.round((parent.height - root.lineThickness) / 2)
                    width: Math.max(0, Math.min(root.dashWidth, parent.width - x))
                    height: root.lineThickness
                    color: theme.dividerColor
                    visible: width > 0
                }
            }
        }

        Item {
            id: titleLayout
            anchors.fill: parent
            visible: root.hasTitle

            Item {
                id: leftWrap
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: root.titlePlacement === "left"
                    ? Math.max(0, Math.min(root.edgeShortWidth, parent.width * 0.18))
                    : (root.titlePlacement === "right"
                        ? Math.max(0, parent.width - Math.max(0, Math.min(root.edgeShortWidth, parent.width * 0.18)) - titleRow.width - root.titleSideMargin * 2)
                        : Math.max(0, (parent.width - titleRow.width - root.titleSideMargin * 2) / 2))
                height: parent.height

                Rectangle {
                    visible: !root.dashed
                    y: Math.round((parent.height - height) / 2)
                    width: parent.width
                    height: root.lineThickness
                    color: theme.dividerColor
                }

                Item {
                    visible: root.dashed
                    anchors.fill: parent
                    Repeater {
                        model: Math.max(0, Math.ceil(Math.max(0, leftWrap.width) / root.dashUnit))
                        delegate: Rectangle {
                            x: index * root.dashUnit
                            y: Math.round((parent.height - root.lineThickness) / 2)
                            width: Math.max(0, Math.min(root.dashWidth, leftWrap.width - x))
                            height: root.lineThickness
                            color: theme.dividerColor
                            visible: width > 0
                        }
                    }
                }
            }

            Row {
                id: titleRow
                anchors.verticalCenter: parent.verticalCenter
                x: leftWrap.width + root.titleSideMargin
                spacing: 0
                height: Math.max(titleHost.implicitHeight, 16)
                width: root.titleContentWidth

                Item {
                    id: titleHost
                    implicitWidth: childrenRect.width
                    implicitHeight: childrenRect.height
                }

                DividerText {
                    id: titleTextItem
                    visible: root.title.length > 0
                    text: root.title
                    width: visible ? titleTextImplicitWidth : 0
                }
            }

            Item {
                id: rightWrap
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: Math.max(0, parent.width - leftWrap.width - titleRow.width - root.titleSideMargin * 2)
                height: parent.height

                Rectangle {
                    visible: !root.dashed
                    y: Math.round((parent.height - height) / 2)
                    width: parent.width
                    height: root.lineThickness
                    color: theme.dividerColor
                }

                Item {
                    visible: root.dashed
                    anchors.fill: parent
                    Repeater {
                        model: Math.max(0, Math.ceil(Math.max(0, rightWrap.width) / root.dashUnit))
                        delegate: Rectangle {
                            x: index * root.dashUnit
                            y: Math.round((parent.height - root.lineThickness) / 2)
                            width: Math.max(0, Math.min(root.dashWidth, rightWrap.width - x))
                            height: root.lineThickness
                            color: theme.dividerColor
                            visible: width > 0
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        visible: root.vertical
        width: 1
        height: root.verticalHeight
        anchors.centerIn: parent
        color: theme.dividerColor
        antialiasing: false
        opacity: 1
    }
    component DividerText: Text {
        color: theme.textColor1
        font.family: theme.fontFamily
        font.pixelSize: 14
        font.weight: Font.DemiBold
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.NoWrap
    }
}
