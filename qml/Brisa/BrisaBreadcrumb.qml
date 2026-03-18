import QtQuick

Item {
    id: root

    default property alias items: itemsHost.data

    property string separator: "/"
    property color itemTextColor: theme.textColor3
    property color itemTextColorHover: theme.textColor2
    property color itemTextColorPressed: theme.textColor2
    property color itemTextColorActive: theme.textColor2
    property color separatorColor: theme.textColor3
    property color itemColorHover: theme.buttonColor2Hover
    property color itemColorPressed: theme.buttonColor2Pressed
    property int itemBorderRadius: theme.borderRadius
    property int itemPadding: 4
    property real itemLineHeight: 1.25

    signal navigate(int index, string label)

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Theme {
        id: theme
    }

    function syncItems() {
        var nodes = []
        for (var i = 0; i < itemsHost.children.length; ++i) {
            var child = itemsHost.children[i]
            if (child && child.__isBrisaBreadcrumbItem === true)
                nodes.push(child)
        }
        for (var j = 0; j < nodes.length; ++j) {
            var item = nodes[j]
            item.parent = row
            item.index = j
            item.inheritedSeparator = root.separator
            item.separatorColor = root.separatorColor
            item.itemTextColor = root.itemTextColor
            item.itemTextColorHover = root.itemTextColorHover
            item.itemTextColorPressed = root.itemTextColorPressed
            item.itemTextColorActive = root.itemTextColorActive
            item.itemColorHover = root.itemColorHover
            item.itemColorPressed = root.itemColorPressed
            item.itemBorderRadius = root.itemBorderRadius
            item.itemPadding = root.itemPadding
            item.itemLineHeight = root.itemLineHeight
            item.last = j === nodes.length - 1
            item.clickable = item.clickable
            item.active = item.last
            if (!item.__brisaBreadcrumbConnected) {
                item.__brisaBreadcrumbConnected = true
                item.click.connect(function(index, label) {
                    root.navigate(index, label)
                })
            }
        }
    }

    Item {
        id: itemsHost
        visible: false
        onChildrenChanged: Qt.callLater(root.syncItems)
    }

    Row {
        id: row
        spacing: 0
    }

    Component.onCompleted: syncItems()
}
