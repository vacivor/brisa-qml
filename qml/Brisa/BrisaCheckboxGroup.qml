import QtQuick

Item {
    id: root

    property var value: null
    property var defaultValue: null
    property int min: -1
    property int max: -1
    property string size: "medium"
    property bool disabled: false

    readonly property bool brisaCheckboxGroup: true
    property var internalValue: Array.isArray(defaultValue) ? defaultValue.slice() : []
    readonly property var mergedValue: Array.isArray(value) ? value : internalValue

    signal updateValue(var value, var meta)

    implicitWidth: contentItem.childrenRect.width
    implicitHeight: contentItem.childrenRect.height

    Item {
        id: contentItem
        anchors.fill: parent
    }

    default property alias content: contentItem.data

    function containsValue(checkboxValue) {
        return mergedValue.indexOf(checkboxValue) !== -1
    }

    function checkedCount() {
        return mergedValue.length
    }

    function isDisabledFor(checkboxValue, checked) {
        if (root.disabled)
            return true
        if (root.max >= 0 && !checked && checkedCount() >= root.max)
            return true
        if (root.min >= 0 && checked && checkedCount() <= root.min)
            return true
        return false
    }

    function toggleCheckbox(nextChecked, checkboxValue) {
        var next = mergedValue.slice()
        var index = next.indexOf(checkboxValue)
        if (nextChecked) {
            if (index === -1)
                next.push(checkboxValue)
        }
        else if (index !== -1) {
            next.splice(index, 1)
        }
        if (Array.isArray(root.value))
            root.value = next
        else
            root.internalValue = next
        root.updateValue(next, {
            actionType: nextChecked ? "check" : "uncheck",
            value: checkboxValue
        })
    }
}
