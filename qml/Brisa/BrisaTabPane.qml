import QtQuick

Item {
    id: root

    property bool __isBrisaTabPane: true
    property var name
    property string tab: ""
    property bool disabled: false
    property bool closable: false
    property string displayDirective: "if-needed"
    property Component tabContent: null

    default property alias content: contentHost.data

    implicitWidth: parent ? parent.width : contentHost.childrenRect.width
    implicitHeight: Math.max(0, contentHost.childrenRect.height)

    Item {
        id: contentHost
        width: parent.width
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }
}
