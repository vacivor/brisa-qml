import QtQuick

Item {
    id: root

    property var value: null
    property var defaultValue: null
    property string name: ""
    property string size: "medium"
    property bool disabled: false

    readonly property bool brisaRadioGroup: true
    property var internalValue: defaultValue
    readonly property var mergedValue: value !== null && value !== undefined ? value : internalValue

    signal updateValue(var value)

    implicitWidth: contentItem.childrenRect.width
    implicitHeight: contentItem.childrenRect.height

    Item {
        id: contentItem
        anchors.fill: parent
    }

    default property alias content: contentItem.data

    function isChecked(radioValue) {
        return mergedValue === radioValue
    }

    function updateGroupValue(radioValue) {
        if (root.value !== null && root.value !== undefined)
            root.value = radioValue
        else
            root.internalValue = radioValue
        root.updateValue(radioValue)
    }
}
