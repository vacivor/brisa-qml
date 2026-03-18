import QtQuick

Item {
    id: root
    property bool showFirst: true
    property Component first
    property Component second
    property int size: 18
    property bool active: true

    width: active ? size : 0
    height: active ? size : 0
    visible: active

    Loader {
        id: firstLoader
        anchors.centerIn: parent
        active: root.first !== null
        sourceComponent: root.first
        opacity: root.showFirst ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 140; easing.type: Easing.OutQuad } }
    }

    Loader {
        id: secondLoader
        anchors.centerIn: parent
        active: root.second !== null
        sourceComponent: root.second
        opacity: root.showFirst ? 0 : 1
        Behavior on opacity { NumberAnimation { duration: 140; easing.type: Easing.OutQuad } }
    }
}
