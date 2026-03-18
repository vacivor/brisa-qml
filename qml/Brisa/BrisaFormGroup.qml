import QtQuick

Item {
    id: root

    property var form: null
    property string title: ""
    property string description: ""
    property bool forceFullWidth: true

    Theme { id: theme }

    implicitWidth: column.implicitWidth
    implicitHeight: column.implicitHeight

    Column {
        id: column
        width: parent.width
        spacing: 12

        Item {
            width: parent.width
            height: (title.length > 0 || description.length > 0) ? headerColumn.implicitHeight : 0
            visible: title.length > 0 || description.length > 0

            Column {
                id: headerColumn
                width: parent.width
                spacing: 4

                Text {
                    visible: root.title.length > 0
                    text: root.title
                    color: theme.textColor1
                    font.pixelSize: 14
                    font.family: theme.fontFamily
                    font.weight: Font.Medium
                }

                Text {
                    visible: root.description.length > 0
                    text: root.description
                    color: theme.textColor3
                    font.pixelSize: 12
                    font.family: theme.fontFamily
                    wrapMode: Text.Wrap
                    width: parent.width
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: theme.dividerColor
            visible: headerColumn.visible
        }

        Column {
            id: contentColumn
            width: parent.width
            spacing: 14
        }
    }

    default property alias content: contentColumn.data

    function refreshChildren() {
        for (var i = 0; i < contentColumn.children.length; ++i) {
            var child = contentColumn.children[i]
            if (!child)
                continue
            if (child.hasOwnProperty("form"))
                child.form = root.form
            if (child.hasOwnProperty("width"))
                child.width = contentColumn.width
        }
    }

    onFormChanged: refreshChildren()
    onWidthChanged: refreshChildren()
    Connections {
        target: contentColumn
        function onChildrenChanged() { root.refreshChildren() }
    }
    Component.onCompleted: refreshChildren()
}
