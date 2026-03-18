import QtQuick

Item {
    id: root

    property bool bordered: true
    property bool showDividers: true
    property bool hoverable: false
    property bool clickable: false
    property string size: "medium" // small | medium | large

    default property alias content: contentColumn.data
    property alias header: headerColumn.data
    property alias footer: footerColumn.data

    Theme { id: theme }

    readonly property bool hasHeader: headerColumn.children.length > 0
    readonly property bool hasFooter: footerColumn.children.length > 0
    readonly property int horizontalPadding: bordered && hoverable ? 20 : 0
    readonly property int verticalPadding: size === "small" ? 10 : size === "large" ? 14 : 12

    function syncItems() {
        function syncColumnItems(column, isContent) {
            var visualItems = []
            for (var i = 0; i < column.children.length; ++i) {
                var child = column.children[i]
                if (!child || !child.__isBrisaListItem)
                    continue
                visualItems.push(child)
            }
            for (var j = 0; j < visualItems.length; ++j) {
                visualItems[j].list = root
                visualItems[j].last = isContent ? (j === visualItems.length - 1) : true
                visualItems[j].width = column.width
            }
        }
        syncColumnItems(headerColumn, false)
        syncColumnItems(contentColumn, true)
        syncColumnItems(footerColumn, false)
    }

    implicitWidth: 320
    implicitHeight: shell.implicitHeight

    onWidthChanged: Qt.callLater(syncItems)

    Rectangle {
        id: shell
        anchors.fill: parent
        implicitHeight: innerColumn.implicitHeight
        radius: theme.borderRadius
        color: theme.baseColor
        border.width: root.bordered ? 1 : 0
        border.color: theme.dividerColor
        antialiasing: true
    }

    Column {
        id: innerColumn
        width: parent.width
        spacing: 0

        Column {
            id: headerColumn
            width: parent.width
            spacing: 0
            visible: root.hasHeader

            onChildrenChanged: Qt.callLater(root.syncItems)
        }

        Rectangle {
            visible: root.hasHeader
            width: parent.width
            height: 1
            color: theme.dividerColor
        }

        Column {
            id: contentColumn
            width: parent.width
            spacing: 0

            onChildrenChanged: Qt.callLater(root.syncItems)
        }

        Rectangle {
            visible: root.hasFooter
            width: parent.width
            height: 1
            color: theme.dividerColor
        }

        Column {
            id: footerColumn
            width: parent.width
            spacing: 0
            visible: root.hasFooter

            onChildrenChanged: Qt.callLater(root.syncItems)
        }
    }
}
