import QtQuick

Item {
    id: root

    default property alias items: itemsColumn.data

    property var value: undefined
    property var defaultValue: undefined
    property bool accordion: false
    property bool bordered: true
    property bool embedded: false
    property bool animated: true
    property bool showDividers: true
    property string size: "medium" // small | medium | large
    property string arrowPlacement: "left" // left | right
    property string displayDirective: "if" // if | show
    property var triggerAreas: ["main", "arrow", "extra"]

    property var itemData: []
    property var uncontrolledValue: undefined
    readonly property var currentValue: value !== undefined ? value : uncontrolledValue

    readonly property int headerHorizontalPadding: 0
    readonly property int contentHorizontalPadding: 0
    readonly property int itemMarginTop: size === "small" ? 12 : size === "large" ? 18 : 16
    readonly property int headerTopPadding: size === "small" ? 12 : size === "large" ? 18 : 16
    readonly property int headerBottomPadding: 0
    readonly property int contentTopPadding: size === "small" ? 12 : size === "large" ? 18 : 16
    readonly property int contentBottomPadding: 0
    readonly property int arrowSize: 16
    readonly property int arrowGap: 4
    readonly property int titleFontSize: size === "large" ? 15 : 14
    readonly property int extraFontSize: titleFontSize
    readonly property int headerExtraGap: 8

    signal updateValue(var value)
    signal itemHeaderClick(var data)

    implicitWidth: 320
    implicitHeight: itemsColumn.implicitHeight

    Theme {
        id: theme
    }

    function normalizedValue() {
        if (root.currentValue === undefined || root.currentValue === null)
            return []
        if (root.accordion) {
            if (Array.isArray(root.currentValue))
                return root.currentValue.length > 0 ? [root.currentValue[0]] : []
            return root.currentValue === "" ? [] : [root.currentValue]
        }
        if (Array.isArray(root.currentValue))
            return root.currentValue
        return [root.currentValue]
    }

    function firstExpandedItem() {
        for (var i = 0; i < itemData.length; ++i) {
            if (itemData[i].defaultExpanded && !itemData[i].disabled)
                return itemData[i].name
        }
        return undefined
    }

    function expandedItemsFromDefaults() {
        var names = []
        for (var i = 0; i < itemData.length; ++i) {
            if (itemData[i].defaultExpanded && !itemData[i].disabled)
                names.push(itemData[i].name)
        }
        return names
    }

    function initializeUncontrolledValue() {
        if (root.value !== undefined)
            return
        if (root.defaultValue !== undefined) {
            if (root.accordion) {
                uncontrolledValue = Array.isArray(root.defaultValue)
                    ? (root.defaultValue.length > 0 ? root.defaultValue[0] : undefined)
                    : root.defaultValue
            } else {
                uncontrolledValue = Array.isArray(root.defaultValue) ? root.defaultValue : [root.defaultValue]
            }
            return
        }
        uncontrolledValue = root.accordion ? firstExpandedItem() : expandedItemsFromDefaults()
    }

    function syncItems() {
        var collected = []
        for (var i = 0; i < itemsColumn.children.length; ++i) {
            var child = itemsColumn.children[i]
            if (child && child.__isBrisaCollapseItem === true)
                collected.push(child)
        }
        itemData = collected

        for (var j = 0; j < itemData.length; ++j) {
            var item = itemData[j]
            item.collapse = root
            item.width = Qt.binding(function() { return root.width })
        }

        if (root.currentValue === undefined)
            initializeUncontrolledValue()

        updateItems()
    }

    function updateItems() {
        var activeNames = normalizedValue()
        for (var i = 0; i < itemData.length; ++i) {
            var item = itemData[i]
            item.first = i === 0
            item.last = i === itemData.length - 1
            item.expanded = activeNames.indexOf(item.name) >= 0
        }
    }

    function toggleItem(name, event) {
        if (name === undefined || name === null)
            return
        var nextValue
        var activeNames = normalizedValue()
        var index = activeNames.indexOf(name)
        var willExpand

        if (root.accordion) {
            willExpand = index < 0
            nextValue = willExpand ? name : undefined
        } else {
            nextValue = activeNames.slice()
            if (index >= 0)
                nextValue.splice(index, 1)
            else
                nextValue.push(name)
            willExpand = index < 0
        }

        if (root.value === undefined)
            uncontrolledValue = nextValue
        root.updateValue(nextValue)
        root.itemHeaderClick({
            name: name,
            expanded: willExpand,
            event: event
        })
        updateItems()
    }

    onCurrentValueChanged: updateItems()
    Component.onCompleted: syncItems()
    onDefaultValueChanged: {
        initializeUncontrolledValue()
        updateItems()
    }
    onAccordionChanged: {
        initializeUncontrolledValue()
        updateItems()
    }

    Column {
        id: itemsColumn
        width: parent.width
        spacing: 0
        onChildrenChanged: root.syncItems()
    }
}
