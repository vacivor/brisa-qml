import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property bool simple: false
    property int page: 1
    property int defaultPage: 1
    property int itemCount: 0
    property int pageCount: 0
    property bool showSizePicker: false
    property int pageSize: 10
    property int defaultPageSize: 10
    property var pageSizes: [10, 20, 30, 40]
    property bool showQuickJumper: false
    property string size: "medium" // small | medium | large
    property bool disabled: false
    property int pageSlot: 9
    property var prefix: null
    property var suffix: null

    property int internalPage: defaultPage
    property int internalPageSize: defaultPageSize
    property string jumperText: ""
    property string simpleJumperText: ""

    signal updatePage(int page)
    signal updatePageSize(int pageSize)

    Theme { id: theme }

    readonly property int mergedPage: page > 0 ? page : internalPage
    readonly property int mergedPageSize: pageSize > 0 ? pageSize : internalPageSize
    readonly property int mergedPageCount: {
        if (itemCount > 0)
            return Math.max(1, Math.ceil(itemCount / Math.max(1, mergedPageSize)))
        return Math.max(1, pageCount > 0 ? pageCount : 1)
    }
    readonly property int itemSize: size === "small" ? theme.heightTiny : (size === "large" ? theme.heightMedium : theme.heightSmall)
    readonly property int itemFontSize: size === "small" ? theme.fontSizeTiny : (size === "large" ? theme.fontSizeMedium : theme.fontSizeSmall)
    readonly property int iconSize: size === "small" ? 16 : 18
    readonly property int itemRadius: theme.borderRadius
    readonly property int quickJumperWidth: size === "small" ? 60 : (size === "large" ? 76 : 68)
    readonly property int sizePickerWidth: size === "small" ? 116 : (size === "large" ? 132 : 124)
    readonly property int prefixSuffixFontSize: size === "small" ? theme.fontSizeTiny : theme.fontSizeSmall
    readonly property color itemTextColor: theme.textColor2
    readonly property color itemTextColorHover: theme.primaryColorHover
    readonly property color itemTextColorPressed: theme.primaryColorPressed
    readonly property color itemTextColorActive: theme.primaryColor
    readonly property color itemTextColorDisabled: Qt.rgba(theme.textColorDisabled.r, theme.textColorDisabled.g, theme.textColorDisabled.b, 1)
    readonly property color itemColor: "transparent"
    readonly property color itemColorHover: "transparent"
    readonly property color itemColorPressed: "transparent"
    readonly property color itemColorActive: "transparent"
    readonly property color itemColorDisabled: theme.dark ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(242 / 255, 242 / 255, 245 / 255, 1)
    readonly property color itemBorderColor: "transparent"
    readonly property color itemBorderColorActive: theme.primaryColor
    readonly property color itemBorderColorDisabled: theme.dark ? Qt.rgba(1, 1, 1, 0.09) : Qt.rgba(224 / 255, 224 / 255, 230 / 255, 1)
    readonly property color buttonBorderColor: theme.dark ? Qt.rgba(1, 1, 1, 0.12) : theme.borderColor
    readonly property color buttonBorderColorHover: theme.dark ? Qt.rgba(1, 1, 1, 0.16) : theme.borderColor
    readonly property color buttonBorderColorPressed: theme.dark ? Qt.rgba(1, 1, 1, 0.2) : theme.borderColor
    readonly property real itemGap: 8
    readonly property real simpleGap: 6
    readonly property real quickJumperGap: 6
    readonly property string infoText: {
        if (simple)
            return "/ " + mergedPageCount
        return ""
    }
    readonly property var pageItems: createPageItems()

    implicitWidth: contentRow.implicitWidth
    implicitHeight: contentRow.implicitHeight

    onMergedPageChanged: {
        if (showQuickJumper)
            jumperText = ""
        simpleJumperText = String(mergedPage)
    }

    Component.onCompleted: simpleJumperText = String(mergedPage)

    function clampPage(value) {
        return Math.max(1, Math.min(mergedPageCount, value))
    }

    function setPage(value) {
        if (disabled)
            return
        var next = clampPage(value)
        if (next === mergedPage)
            return
        if (page > 0)
            page = next
        else
            internalPage = next
        updatePage(next)
    }

    function setPageSize(value) {
        if (disabled)
            return
        var next = Math.max(1, value)
        if (next === mergedPageSize)
            return
        if (pageSize > 0)
            pageSize = next
        else
            internalPageSize = next
        var nextPage = clampPage(mergedPage)
        if (page > 0)
            page = nextPage
        else
            internalPage = nextPage
        updatePageSize(next)
        updatePage(nextPage)
    }

    function createPageItems() {
        var count = mergedPageCount
        var current = mergedPage
        var slot = Math.max(5, pageSlot)
        if (count <= slot) {
            var full = []
            for (var i = 1; i <= count; ++i)
                full.push(i)
            return full
        }

        var result = [1]
        var remain = slot - 2
        var start = Math.max(2, current - Math.floor((remain - 1) / 2))
        var end = Math.min(count - 1, start + remain - 1)
        start = Math.max(2, end - remain + 1)

        if (start > 2)
            result.push("prev-more")
        for (var pageNo = start; pageNo <= end; ++pageNo)
            result.push(pageNo)
        if (end < count - 1)
            result.push("next-more")
        result.push(count)
        return result
    }

    function labelForSizeOption(option) {
        if (typeof option === "number")
            return option + " / page"
        if (option && option.label !== undefined)
            return String(option.label)
        if (option && option.value !== undefined)
            return String(option.value) + " / page"
        return ""
    }

    function valueForSizeOption(option) {
        if (typeof option === "number")
            return option
        if (option && option.value !== undefined)
            return Number(option.value)
        return 0
    }

    function fastStep(direction) {
        var step = Math.max(1, pageSlot - 2)
        setPage(mergedPage + direction * step)
    }

    function navIconColor(disabledState, hovered, pressed) {
        if (disabledState)
            return itemTextColorDisabled
        if (pressed)
            return itemTextColorPressed
        if (hovered)
            return itemTextColorHover
        return itemTextColor
    }

    Component {
        id: defaultPrevIcon
        BrisaIcon {
            size: root.iconSize
            color: root.disabled ? root.itemTextColorDisabled : root.itemTextColor
            component: Component {
                Item {
                    implicitWidth: root.iconSize
                    implicitHeight: root.iconSize
                    Image {
                        anchors.fill: parent
                        source: theme.svgChevronLeft(root.disabled ? root.itemTextColorDisabled : root.itemTextColor, root.iconSize)
                    }
                }
            }
        }
    }

    Component {
        id: defaultNextIcon
        BrisaIcon {
            size: root.iconSize
            color: root.disabled ? root.itemTextColorDisabled : root.itemTextColor
            component: Component {
                Item {
                    implicitWidth: root.iconSize
                    implicitHeight: root.iconSize
                    Image {
                        anchors.fill: parent
                        source: theme.svgChevronRight(root.disabled ? root.itemTextColorDisabled : root.itemTextColor, root.iconSize)
                    }
                }
            }
        }
    }

    Component {
        id: moreIcon
        Text {
            text: "..."
            color: root.disabled ? root.itemTextColorDisabled : root.itemTextColor
            font.family: theme.fontFamily
            font.pixelSize: root.itemFontSize
            font.weight: Font.Medium
        }
    }

    Row {
        id: contentRow
        spacing: root.simple ? root.simpleGap : root.itemGap
        anchors.verticalCenter: parent ? parent.verticalCenter : undefined

        Item {
            visible: !!root.prefix
            width: visible ? prefixLoader.implicitWidth : 0
            height: root.itemSize

            Loader {
                id: prefixLoader
                anchors.verticalCenter: parent.verticalCenter
                active: !!root.prefix
                sourceComponent: root.prefix
            }
        }

        Row {
            spacing: root.simple ? root.simpleGap : root.itemGap
            anchors.verticalCenter: parent.verticalCenter

            Repeater {
                model: root.simple ? ["prev", "simple-input", "info", "next"] : ["prev", "pages", "next"]

                delegate: Loader {
                    required property var modelData
                    sourceComponent: {
                        if (modelData === "info")
                            return infoItemComponent
                        if (modelData === "simple-input")
                            return simpleInputComponent
                        if (modelData === "pages")
                            return pagesComponent
                        return navItemComponent
                    }
                    onLoaded: {
                        if (item && (modelData === "prev" || modelData === "next"))
                            item.modelData = modelData
                    }
                }
            }
        }

        BrisaSelect {
            visible: root.showSizePicker
            width: root.sizePickerWidth
            height: root.itemSize
            size: root.size
            clearable: false
            value: root.mergedPageSize
            options: root.pageSizes.map(function(option) {
                return {
                    label: root.labelForSizeOption(option),
                    value: root.valueForSizeOption(option)
                }
            })
            onUpdateValue: function(v) { root.setPageSize(v) }
        }

        Row {
            visible: root.showQuickJumper
            spacing: root.quickJumperGap
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: "Goto"
                color: root.disabled ? root.itemTextColorDisabled : root.itemTextColor
                font.family: theme.fontFamily
                font.pixelSize: root.itemFontSize
                font.weight: Font.Medium
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                width: root.quickJumperWidth
                height: root.itemSize

                BrisaInput {
                    anchors.fill: parent
                    size: root.size
                    clearable: false
                    readOnly: root.disabled
                    text: root.jumperText
                    placeholder: ""
                    horizontalAlignment: TextInput.AlignHCenter
                    onTextChanged: root.jumperText = text
                    onAccepted: {
                        var parsed = parseInt(root.jumperText, 10)
                        if (!isNaN(parsed))
                            root.setPage(parsed)
                        root.jumperText = ""
                    }
                }
            }
        }

        Item {
            visible: !!root.suffix
            width: visible ? suffixLoader.implicitWidth : 0
            height: root.itemSize

            Loader {
                id: suffixLoader
                anchors.verticalCenter: parent.verticalCenter
                active: !!root.suffix
                sourceComponent: root.suffix
            }
        }
    }

    Component {
        id: navItemComponent

        Item {
            property var modelData
            readonly property bool isPrev: modelData === "prev"
            readonly property bool isDisabled: root.disabled || (isPrev ? root.mergedPage <= 1 : root.mergedPage >= root.mergedPageCount)
            width: root.itemSize
            height: root.itemSize

            Rectangle {
                anchors.fill: parent
                radius: root.itemRadius
                color: parent.isDisabled
                    ? root.itemColorDisabled
                    : (navMouse.pressed ? root.itemColorPressed : (navMouse.containsMouse ? root.itemColorHover : root.itemColor))
                border.width: 1
                border.color: parent.isDisabled
                    ? root.itemBorderColorDisabled
                    : (navMouse.pressed ? root.buttonBorderColorPressed : (navMouse.containsMouse ? root.buttonBorderColorHover : root.buttonBorderColor))

                Behavior on color {
                    ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
                Behavior on border.color {
                    ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }

            Item {
                anchors.centerIn: parent
                width: root.iconSize
                height: root.iconSize

                Image {
                    anchors.fill: parent
                    source: isPrev
                        ? theme.svgChevronLeft(root.navIconColor(parent.isDisabled, navMouse.containsMouse, navMouse.pressed), root.iconSize)
                        : theme.svgChevronRight(root.navIconColor(parent.isDisabled, navMouse.containsMouse, navMouse.pressed), root.iconSize)
                    opacity: parent.isDisabled ? (theme.dark ? 0.36 : 0.45) : 1
                }
            }

            MouseArea {
                id: navMouse
                anchors.fill: parent
                hoverEnabled: true
                enabled: !parent.isDisabled
                cursorShape: parent.isDisabled ? Qt.ArrowCursor : Qt.PointingHandCursor
                opacity: parent.isDisabled ? 0.92 : 1
                onClicked: root.setPage(root.mergedPage + (parent.isPrev ? -1 : 1))
            }
        }
    }

    Component {
        id: infoItemComponent

        Item {
            height: root.itemSize
            width: infoLabel.implicitWidth

            Text {
                id: infoLabel
                anchors.verticalCenter: parent.verticalCenter
                text: root.infoText
                color: root.disabled ? root.itemTextColorDisabled : root.itemTextColor
                font.family: theme.fontFamily
                font.pixelSize: root.itemFontSize
                font.weight: Font.Medium
            }
        }
    }

    Component {
        id: simpleInputComponent

        Item {
            width: root.quickJumperWidth - 4
            height: root.itemSize

            BrisaInput {
                anchors.fill: parent
                size: root.size
                clearable: false
                readOnly: root.disabled
                text: root.simpleJumperText
                placeholder: ""
                externalTextBinding: true
                horizontalAlignment: TextInput.AlignHCenter
                onTextChanged: root.simpleJumperText = text
                onAccepted: {
                    var parsed = parseInt(root.simpleJumperText, 10)
                    if (!isNaN(parsed))
                        root.setPage(parsed)
                    root.simpleJumperText = String(root.mergedPage)
                }
                onBlurEvent: root.simpleJumperText = String(root.mergedPage)
            }
        }
    }

    Component {
        id: pagesComponent

        Row {
            spacing: root.simple ? root.simpleGap : root.itemGap

            Repeater {
                model: root.pageItems

                delegate: Item {
                    required property var modelData
                    readonly property bool isNumber: typeof modelData === "number"
                    readonly property bool isActive: isNumber && modelData === root.mergedPage
                    readonly property bool isDisabled: root.disabled
                    width: root.itemSize
                    height: root.itemSize

                    Rectangle {
                        anchors.fill: parent
                        radius: root.itemRadius
                        color: isActive
                            ? root.itemColorActive
                            : (isDisabled
                                ? root.itemColor
                                : (pageMouse.pressed ? root.itemColorPressed : (pageMouse.containsMouse ? root.itemColorHover : root.itemColor)))
                        border.width: 1
                        border.color: isActive
                            ? root.itemBorderColorActive
                            : (isDisabled ? root.itemBorderColorDisabled : root.itemBorderColor)

                        Behavior on color {
                            ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                        }
                        Behavior on border.color {
                            ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                        }
                    }

                    Loader {
                        anchors.centerIn: parent
                        sourceComponent: isNumber ? numberLabel : moreIcon
                    }

                    MouseArea {
                        id: pageMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: !isDisabled
                        cursorShape: isDisabled ? Qt.ArrowCursor : Qt.PointingHandCursor
                        onClicked: {
                            if (isNumber)
                                root.setPage(modelData)
                            else if (modelData === "prev-more")
                                root.fastStep(-1)
                            else if (modelData === "next-more")
                                root.fastStep(1)
                        }
                    }

                    Component {
                        id: numberLabel
                        Text {
                            text: isNumber ? String(modelData) : "..."
                            color: isDisabled
                                ? root.itemTextColorDisabled
                                : (isActive
                                    ? root.itemTextColorActive
                                    : (pageMouse.pressed ? root.itemTextColorPressed : (pageMouse.containsMouse ? root.itemTextColorHover : root.itemTextColor)))
                            font.family: theme.fontFamily
                            font.pixelSize: root.itemFontSize
                            font.weight: isActive ? Font.DemiBold : Font.Normal
                        }
                    }
                }
            }
        }
    }
}
