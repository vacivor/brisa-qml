import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property var columns: []
    property var rows: []
    property string size: "medium"
    property bool bordered: true
    property bool singleLine: true
    property bool striped: false
    property bool loading: false
    property bool remote: false
    property bool checkable: false
    property bool showPagination: false
    property int page: 1
    property int defaultPage: 1
    property int pageSize: 10
    property int defaultPageSize: 10
    property var pageSizes: [10, 20, 30, 40]
    property bool showSizePicker: false
    property bool showQuickJumper: false
    property string loadingText: "Loading"
    property string emptyText: "No Data"
    property string emptyDescription: "There is no data to display right now."
    property color backgroundColor: theme.baseColor
    property var sortState: ({ columnKey: "", order: false })
    property var checkedRowKeys: undefined
    property var defaultCheckedRowKeys: []
    property string rowKeyField: "key"
    property int internalPage: defaultPage
    property int internalPageSize: defaultPageSize
    property var internalCheckedRowKeys: defaultCheckedRowKeys ? defaultCheckedRowKeys.slice() : []
    property int hoveredRowIndex: -1

    signal updateSortState(var state)
    signal updatePage(int page)
    signal updatePageSize(int pageSize)
    signal updateCheckedRowKeys(var keys)

    implicitWidth: tableWidth
    implicitHeight: headerHeight + Math.min(6, Math.max(1, displayData.length || 1)) * rowHeight

    Theme { id: theme }

    readonly property int tableFontSize: size === "small" ? theme.fontSizeSmall : (size === "large" ? theme.fontSizeLarge : theme.fontSizeMedium)
    readonly property int headerHeight: size === "small" ? 40 : (size === "large" ? 48 : 44)
    readonly property int rowHeight: size === "small" ? 38 : (size === "large" ? 46 : 42)
    readonly property int horizontalPadding: size === "small" ? 12 : 14
    readonly property int sorterSize: 12
    readonly property int selectionColumnWidth: 46
    readonly property int paginationHeight: root.showPagination ? (root.size === "small" ? 60 : (root.size === "large" ? 72 : 66)) : 0
    readonly property int mergedPage: page > 0 ? page : internalPage
    readonly property int mergedPageSize: pageSize > 0 ? pageSize : internalPageSize
    readonly property int totalItemCount: root.rows ? root.rows.length : 0
    readonly property var mergedCheckedRowKeys: checkedRowKeys !== undefined ? checkedRowKeys : internalCheckedRowKeys
    readonly property bool allPageRowsChecked: displayData.length > 0 && countCheckedInDisplay() === displayData.length
    readonly property bool somePageRowsChecked: countCheckedInDisplay() > 0 && !allPageRowsChecked
    readonly property var leftFixedColumns: computeLeftFixedColumns()
    readonly property var scrollColumns: computeScrollColumns()
    readonly property int leftFixedWidth: computeLeftFixedWidth()
    readonly property bool hasLeftOverlay: root.leftFixedWidth > 0
    readonly property int tableWidth: computeTableWidth()
    readonly property int scrollTableWidth: computeScrollTableWidth()
    readonly property var sortedData: computeSortedData()
    readonly property var displayData: computeDisplayData()
    readonly property color headerColor: theme.dark ? Qt.rgba(38 / 255, 41 / 255, 47 / 255, 1) : Qt.rgba(250 / 255, 250 / 255, 252 / 255, 1)
    readonly property color headerHoverColor: theme.dark ? Qt.rgba(46 / 255, 50 / 255, 57 / 255, 1) : Qt.rgba(245 / 255, 245 / 255, 247 / 255, 1)
    readonly property color headerSortingColor: theme.dark ? Qt.rgba(50 / 255, 54 / 255, 61 / 255, 1) : Qt.rgba(245 / 255, 245 / 255, 247 / 255, 1)
    readonly property color rowHoverColor: mixColor(root.backgroundColor, theme.dark ? Qt.rgba(43 / 255, 46 / 255, 53 / 255, 1) : Qt.rgba(250 / 255, 250 / 255, 252 / 255, 1), theme.dark ? 0.94 : 1)
    readonly property color stripedRowColor: mixColor(root.backgroundColor, theme.dark ? Qt.rgba(39 / 255, 42 / 255, 48 / 255, 1) : Qt.rgba(250 / 255, 250 / 255, 252 / 255, 1), theme.dark ? 0.6 : 0.72)
    readonly property color checkedRowColor: mixColor(root.backgroundColor, theme.primaryColor, theme.dark ? 0.14 : 0.08)
    readonly property color checkedRowHoverColor: mixColor(root.backgroundColor, theme.primaryColor, theme.dark ? 0.2 : 0.12)
    readonly property color fixedOverlayColor: root.backgroundColor
    readonly property color loadingOverlayColor: theme.dark ? Qt.rgba(root.backgroundColor.r, root.backgroundColor.g, root.backgroundColor.b, 0.78) : Qt.rgba(1, 1, 1, 0.72)
    readonly property color inactiveSorterColor: Qt.rgba(theme.iconColor.r, theme.iconColor.g, theme.iconColor.b, theme.dark ? 0.58 : 0.42)
    readonly property color fixedDividerColor: theme.dark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.05)
    readonly property bool leftOverlayShadowVisible: root.hasLeftOverlay && bodyFlick.contentX > 0.5
    readonly property int fixedShadowWidth: 12
    readonly property color fixedShadowColorStrong: theme.dark ? Qt.rgba(0, 0, 0, 0.34) : Qt.rgba(0, 0, 0, 0.08)
    readonly property color fixedShadowColorSoft: theme.dark ? Qt.rgba(0, 0, 0, 0.12) : Qt.rgba(0, 0, 0, 0.02)
    readonly property color stickyHeaderShadowColor: theme.dark ? Qt.rgba(0, 0, 0, 0.24) : Qt.rgba(0, 0, 0, 0.06)

    function computeTableWidth() {
        var sum = checkable ? selectionColumnWidth : 0
        for (var i = 0; i < columns.length; ++i) {
            var column = columns[i]
            sum += column.width !== undefined ? column.width : (column.minWidth !== undefined ? column.minWidth : 120)
        }
        return Math.max(width, sum)
    }

    function columnWidth(column) {
        return column.width !== undefined ? column.width : (column.minWidth !== undefined ? column.minWidth : 120)
    }

    function mixColor(base, tint, alpha) {
        var a = Math.max(0, Math.min(1, alpha))
        return Qt.rgba(
            base.r * (1 - a) + tint.r * a,
            base.g * (1 - a) + tint.g * a,
            base.b * (1 - a) + tint.b * a,
            1
        )
    }

    function rowFillColor(row, rowIndex, hovered) {
        if (isRowChecked(row, rowIndex))
            return hovered ? checkedRowHoverColor : checkedRowColor
        if (hovered)
            return rowHoverColor
        if (striped && (rowIndex % 2 === 1))
            return stripedRowColor
        return backgroundColor
    }

    function isSortingColumn(column) {
        return !!column && root.sortState.columnKey === column.key && !!root.sortState.order
    }

    function headerFillColor(column, hovered) {
        if (isSortingColumn(column))
            return headerSortingColor
        if (hovered && !!column && !!column.sortable)
            return headerHoverColor
        return headerColor
    }

    function sorterOpacity(column, order, branch) {
        if (!isSortingColumn(column))
            return 1
        if (order === branch)
            return 1
        return 0.28
    }

    function computeLeftFixedColumns() {
        var result = []
        for (var i = 0; i < columns.length; ++i) {
            if (columns[i] && columns[i].fixed === "left")
                result.push(columns[i])
        }
        return result
    }

    function computeScrollColumns() {
        var result = []
        for (var i = 0; i < columns.length; ++i) {
            var column = columns[i]
            if (!(column && column.fixed === "left"))
                result.push(column)
        }
        return result
    }

    function computeLeftFixedWidth() {
        var width = checkable ? selectionColumnWidth : 0
        for (var i = 0; i < leftFixedColumns.length; ++i)
            width += columnWidth(leftFixedColumns[i])
        return width
    }

    function computeScrollTableWidth() {
        var width = 0
        for (var i = 0; i < scrollColumns.length; ++i)
            width += columnWidth(scrollColumns[i])
        return width
    }

    function cellText(row, column) {
        if (!row || !column)
            return ""
        if (column.render !== undefined && typeof column.render === "function")
            return String(column.render(row, column))
        return row[column.key] !== undefined && row[column.key] !== null ? String(row[column.key]) : ""
    }

    function sortValue(row, column) {
        if (!row || !column)
            return ""
        return row[column.key]
    }

    function computeSortedData() {
        var result = rows ? rows.slice() : []
        if (remote)
            return result
        if (!sortState || !sortState.columnKey || !sortState.order)
            return result
        var activeColumn = null
        for (var i = 0; i < columns.length; ++i) {
            if (columns[i].key === sortState.columnKey) {
                activeColumn = columns[i]
                break
            }
        }
        if (!activeColumn)
            return result
        result.sort(function(a, b) {
            if (activeColumn.sorter && typeof activeColumn.sorter === "function")
                return activeColumn.sorter(a, b)
            var av = sortValue(a, activeColumn)
            var bv = sortValue(b, activeColumn)
            if (av === bv)
                return 0
            if (av === undefined || av === null)
                return -1
            if (bv === undefined || bv === null)
                return 1
            if (typeof av === "number" && typeof bv === "number")
                return av - bv
            return String(av).localeCompare(String(bv))
        })
        if (sortState.order === "descend")
            result.reverse()
        return result
    }

    function computeDisplayData() {
        var result = sortedData ? sortedData.slice() : []
        if (!showPagination)
            return result
        if (remote)
            return result
        var start = Math.max(0, (mergedPage - 1) * mergedPageSize)
        return result.slice(start, start + mergedPageSize)
    }

    function setPageValue(value) {
        var next = Math.max(1, value)
        if (page > 0)
            page = next
        else
            internalPage = next
        updatePage(next)
    }

    function setPageSizeValue(value) {
        var next = Math.max(1, value)
        if (pageSize > 0)
            pageSize = next
        else
            internalPageSize = next
        updatePageSize(next)
    }

    function rowKeyFor(row, index) {
        if (!row)
            return index
        if (row[rowKeyField] !== undefined)
            return row[rowKeyField]
        if (row.id !== undefined)
            return row.id
        return index
    }

    function isRowChecked(row, index) {
        var key = rowKeyFor(row, index)
        return mergedCheckedRowKeys.indexOf(key) >= 0
    }

    function setCheckedKeys(keys) {
        if (checkedRowKeys !== undefined)
            checkedRowKeys = keys
        else
            internalCheckedRowKeys = keys
        updateCheckedRowKeys(keys)
    }

    function toggleRowChecked(row, index, checked) {
        var key = rowKeyFor(row, index)
        var next = mergedCheckedRowKeys.slice()
        var existing = next.indexOf(key)
        if (checked && existing < 0)
            next.push(key)
        else if (!checked && existing >= 0)
            next.splice(existing, 1)
        setCheckedKeys(next)
    }

    function toggleAllDisplayRows(checked) {
        var next = mergedCheckedRowKeys.slice()
        for (var i = 0; i < displayData.length; ++i) {
            var key = rowKeyFor(displayData[i], i)
            var existing = next.indexOf(key)
            if (checked && existing < 0)
                next.push(key)
            else if (!checked && existing >= 0)
                next.splice(existing, 1)
        }
        setCheckedKeys(next)
    }

    function countCheckedInDisplay() {
        var count = 0
        for (var i = 0; i < displayData.length; ++i) {
            if (isRowChecked(displayData[i], i))
                count += 1
        }
        return count
    }

    function toggleSort(column) {
        if (!column || !column.sortable)
            return
        var nextOrder = "ascend"
        if (sortState.columnKey === column.key) {
            if (sortState.order === "ascend")
                nextOrder = "descend"
            else if (sortState.order === "descend")
                nextOrder = false
            else
                nextOrder = "ascend"
        }
        sortState = { columnKey: nextOrder ? column.key : "", order: nextOrder }
        updateSortState(sortState)
    }

    Rectangle {
        id: tableShell
        anchors.fill: parent
        radius: root.bordered ? theme.borderRadius : 0
        color: root.backgroundColor
        border.color: root.bordered ? theme.borderColor : "transparent"
        border.width: root.bordered ? 1 : 0
        clip: true

        Item {
            id: tableHeader
            width: parent.width
            height: root.headerHeight
            z: 2

            readonly property bool elevated: bodyFlick.contentY > 0

            Rectangle {
                anchors.fill: parent
                color: root.headerColor
            }

            Flickable {
                id: headerFlick
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: root.hasLeftOverlay ? root.leftFixedWidth : 0
                contentWidth: root.scrollTableWidth
                contentHeight: height
                interactive: false
                clip: true

                Row {
                    width: root.scrollTableWidth
                    height: parent.height
                    spacing: 0

                    Item {
                        visible: root.checkable && !root.hasLeftOverlay
                        width: root.checkable && !root.hasLeftOverlay ? root.selectionColumnWidth : 0
                        height: parent.height

                        Rectangle {
                            anchors.fill: parent
                            color: root.headerColor
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 1
                            color: theme.dividerColor
                        }

                        BrisaCheckbox {
                            anchors.centerIn: parent
                            size: root.size === "large" ? "large" : (root.size === "small" ? "small" : "medium")
                            checked: root.allPageRowsChecked
                            indeterminate: root.somePageRowsChecked
                            onUpdateChecked: function(v) { root.toggleAllDisplayRows(!!v) }
                        }

                        Rectangle {
                            visible: root.leftFixedColumns.length > 0
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            width: 1
                            color: root.fixedDividerColor
                        }
                    }

                    Repeater {
                        model: root.scrollColumns

                        delegate: Item {
                            required property var modelData
                            property var column: modelData
                            width: root.columnWidth(column)
                            height: parent.height

                            Rectangle {
                                anchors.fill: parent
                                color: root.headerFillColor(column, headerHover.hovered)

                                Behavior on color {
                                    ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                                }
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 1
                                color: theme.dividerColor
                            }

                            Item {
                                anchors.fill: parent
                                anchors.leftMargin: root.horizontalPadding
                                anchors.rightMargin: root.horizontalPadding

                                Row {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    spacing: 6

                                    Text {
                                        width: parent.width - (!!column.sortable ? root.sorterSize + 4 : 0)
                                        text: column.title !== undefined ? String(column.title) : ""
                                        color: theme.textColor1
                                        font.family: theme.fontFamily
                                        font.pixelSize: root.tableFontSize
                                        font.weight: Font.DemiBold
                                        elide: Text.ElideRight
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: column.align === "right"
                                            ? Text.AlignRight
                                            : (column.align === "center" ? Text.AlignHCenter : Text.AlignLeft)
                                    }

                                    Item {
                                        visible: !!column.sortable
                                        width: root.sorterSize
                                        height: root.sorterSize

                                        Image {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.top: parent.top
                                            width: root.sorterSize
                                            height: root.sorterSize
                                            source: theme.svgChevronDown(
                                                root.sortState.columnKey === column.key && root.sortState.order === "ascend"
                                                    ? theme.primaryColor
                                                    : root.inactiveSorterColor,
                                                root.sorterSize
                                            )
                                            rotation: 180
                                            opacity: root.sorterOpacity(column, "ascend", "ascend")
                                        }

                                        Image {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.bottom: parent.bottom
                                            width: root.sorterSize
                                            height: root.sorterSize
                                            source: theme.svgChevronDown(
                                                root.sortState.columnKey === column.key && root.sortState.order === "descend"
                                                    ? theme.primaryColor
                                                    : root.inactiveSorterColor,
                                                root.sorterSize
                                            )
                                            opacity: root.sorterOpacity(column, "descend", "descend")
                                        }
                                    }
                                }
                            }

                            HoverHandler {
                                id: headerHover
                                enabled: !!column.sortable
                                cursorShape: !!column.sortable ? Qt.PointingHandCursor : Qt.ArrowCursor
                            }

                            TapHandler {
                                enabled: !!column.sortable
                                onTapped: root.toggleSort(column)
                            }
                        }
                    }
                }
            }

            Item {
                visible: root.hasLeftOverlay
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: root.leftFixedWidth
                clip: true

                Rectangle {
                    anchors.fill: parent
                    color: root.headerColor
                }

                Rectangle {
                    anchors.fill: parent
                    color: root.fixedOverlayColor
                    opacity: 0
                }

                Row {
                    width: parent.width
                    height: parent.height
                    spacing: 0

                    Item {
                        visible: root.checkable
                        width: root.checkable ? root.selectionColumnWidth : 0
                        height: parent.height

                        Rectangle {
                            anchors.fill: parent
                            color: root.headerFillColor(null, false)
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 1
                            color: theme.dividerColor
                        }

                        BrisaCheckbox {
                            anchors.centerIn: parent
                            size: root.size === "large" ? "large" : (root.size === "small" ? "small" : "medium")
                            checked: root.allPageRowsChecked
                            indeterminate: root.somePageRowsChecked
                            onUpdateChecked: function(v) { root.toggleAllDisplayRows(!!v) }
                        }

                        Rectangle {
                            visible: root.leftFixedColumns.length > 0
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            width: 1
                            color: root.fixedDividerColor
                        }
                    }

                    Repeater {
                        model: root.leftFixedColumns

                        delegate: Item {
                            required property var modelData
                            property var column: modelData
                            width: root.columnWidth(column)
                            height: parent.height

                            Rectangle {
                                anchors.fill: parent
                                color: root.headerFillColor(column, fixedHeaderHover.hovered)

                                Behavior on color {
                                    ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                                }
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 1
                                color: theme.dividerColor
                            }

                            Item {
                                anchors.fill: parent
                                anchors.leftMargin: root.horizontalPadding
                                anchors.rightMargin: root.horizontalPadding

                                Row {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    spacing: 6

                                    Text {
                                        width: parent.width - (!!column.sortable ? root.sorterSize + 4 : 0)
                                        text: column.title !== undefined ? String(column.title) : ""
                                        color: theme.textColor1
                                        font.family: theme.fontFamily
                                        font.pixelSize: root.tableFontSize
                                        font.weight: Font.DemiBold
                                        elide: Text.ElideRight
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: column.align === "right"
                                            ? Text.AlignRight
                                            : (column.align === "center" ? Text.AlignHCenter : Text.AlignLeft)
                                    }

                                    Item {
                                        visible: !!column.sortable
                                        width: root.sorterSize
                                        height: root.sorterSize

                                        Image {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.top: parent.top
                                            width: root.sorterSize
                                            height: root.sorterSize
                                            source: theme.svgChevronDown(
                                                root.sortState.columnKey === column.key && root.sortState.order === "ascend"
                                                    ? theme.primaryColor
                                                    : root.inactiveSorterColor,
                                                root.sorterSize
                                            )
                                            rotation: 180
                                            opacity: root.sorterOpacity(column, "ascend", "ascend")
                                        }

                                        Image {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.bottom: parent.bottom
                                            width: root.sorterSize
                                            height: root.sorterSize
                                            source: theme.svgChevronDown(
                                                root.sortState.columnKey === column.key && root.sortState.order === "descend"
                                                    ? theme.primaryColor
                                                    : root.inactiveSorterColor,
                                                root.sorterSize
                                            )
                                            opacity: root.sorterOpacity(column, "descend", "descend")
                                        }
                                    }
                                }
                            }

                            HoverHandler {
                                id: fixedHeaderHover
                                enabled: !!column.sortable
                                cursorShape: !!column.sortable ? Qt.PointingHandCursor : Qt.ArrowCursor
                            }

                            TapHandler {
                                enabled: !!column.sortable
                                onTapped: root.toggleSort(column)
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    width: 1
                    color: root.fixedDividerColor
                }

            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: tableHeader.elevated ? (theme.dark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.08)) : theme.dividerColor

                Behavior on color {
                    ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }

            Rectangle {
                visible: tableHeader.elevated
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.bottom
                height: 10
                z: 1
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0.0; color: root.stickyHeaderShadowColor }
                    GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.0) }
                }
                opacity: tableHeader.elevated ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }

            Rectangle {
                visible: root.leftOverlayShadowVisible
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: root.leftFixedWidth
                width: root.fixedShadowWidth
                z: 3
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: root.fixedShadowColorStrong }
                    GradientStop { position: 0.55; color: root.fixedShadowColorSoft }
                    GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.0) }
                }
                opacity: root.leftOverlayShadowVisible ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }
        }

        Item {
            id: tableBodyViewport
            anchors.top: tableHeader.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: paginationWrap.visible ? paginationWrap.top : parent.bottom
            clip: true

            Flickable {
                id: bodyFlick
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: root.hasLeftOverlay ? root.leftFixedWidth : 0
                contentWidth: root.scrollTableWidth
                contentHeight: bodyColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                onContentXChanged: headerFlick.contentX = contentX

                WheelHandler {
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                    onWheel: function(event) {
                        var dx = event.angleDelta.x
                        var dy = event.angleDelta.y
                        if ((event.modifiers & Qt.ShiftModifier) && dx === 0 && dy !== 0)
                            dx = -dy
                        var rangeX = Math.max(0, bodyFlick.contentWidth - bodyFlick.width)
                        var rangeY = Math.max(0, bodyFlick.contentHeight - bodyFlick.height)
                        if (dx !== 0 && rangeX > 0) {
                            bodyFlick.contentX = Math.max(0, Math.min(rangeX, bodyFlick.contentX - dx))
                            event.accepted = true
                            return
                        }
                        if (dy !== 0 && rangeY > 0) {
                            bodyFlick.contentY = Math.max(0, Math.min(rangeY, bodyFlick.contentY - dy))
                            event.accepted = true
                            return
                        }
                        event.accepted = false
                    }
                }

                Column {
                    id: bodyColumn
                    width: root.scrollTableWidth
                    spacing: 0

                    Repeater {
                        model: root.displayData

                        delegate: Item {
                            required property var modelData
                            required property int index
                            property var rowData: modelData
                            property int rowIndex: index
                            property bool rowHovered: root.hoveredRowIndex === rowIndex
                            width: bodyColumn.width
                            height: root.rowHeight

                            Rectangle {
                                anchors.fill: parent
                                color: root.rowFillColor(rowData, rowIndex, rowHovered)

                                Behavior on color {
                                    ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                                }
                            }

                            Rectangle {
                                visible: root.singleLine
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 1
                                color: theme.dividerColor
                            }

                            Row {
                                anchors.fill: parent
                                spacing: 0

                                Item {
                                    visible: root.checkable && !root.hasLeftOverlay
                                    width: root.checkable && !root.hasLeftOverlay ? root.selectionColumnWidth : 0
                                    height: parent.height

                                    BrisaCheckbox {
                                        anchors.centerIn: parent
                                        size: root.size === "large" ? "large" : (root.size === "small" ? "small" : "medium")
                                        checked: root.isRowChecked(rowData, rowIndex)
                                        onUpdateChecked: function(v) { root.toggleRowChecked(rowData, rowIndex, !!v) }
                                    }

                                    Rectangle {
                                        visible: root.leftFixedColumns.length > 0
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        anchors.right: parent.right
                                        width: 1
                                        color: root.fixedDividerColor
                                    }
                                }

                                Repeater {
                                    model: root.scrollColumns

                                    delegate: Item {
                                        required property var modelData
                                        property var column: modelData
                                        width: root.columnWidth(column)
                                        height: parent.height

                                        Item {
                                            anchors.fill: parent
                                            anchors.leftMargin: root.horizontalPadding
                                            anchors.rightMargin: root.horizontalPadding

                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                width: parent.width
                                                text: root.cellText(rowData, column)
                                                color: theme.textColor2
                                                font.family: theme.fontFamily
                                                font.pixelSize: root.tableFontSize
                                                elide: Text.ElideRight
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: column.align === "right"
                                                    ? Text.AlignRight
                                                    : (column.align === "center" ? Text.AlignHCenter : Text.AlignLeft)
                                            }
                                        }
                                    }
                                }
                            }

                            HoverHandler {
                                id: rowHover
                                onHoveredChanged: {
                                    if (hovered)
                                        root.hoveredRowIndex = rowIndex
                                    else if (root.hoveredRowIndex === rowIndex)
                                        root.hoveredRowIndex = -1
                                }
                            }
                        }
                    }

                    Item {
                        visible: root.displayData.length === 0 && !root.loading
                        x: bodyFlick.contentX
                        width: tableBodyViewport.width
                        height: 176

                        Item {
                            anchors.centerIn: parent
                            width: Math.min(parent.width - root.horizontalPadding * 2, 360)
                            height: emptyState.implicitHeight

                            BrisaEmpty {
                                id: emptyState
                                anchors.fill: parent
                                size: root.size === "small" ? "small" : (root.size === "large" ? "large" : "medium")
                                title: root.emptyText
                                description: root.emptyDescription
                            }
                        }
                    }
                }
            }

            BrisaScrollBar {
                flickable: bodyFlick
            }

            BrisaScrollBar {
                flickable: bodyFlick
                orientation: "horizontal"
            }

            Rectangle {
                anchors.fill: parent
                visible: root.loading
                color: root.loadingOverlayColor
            }

            Column {
                anchors.centerIn: parent
                spacing: 10
                visible: root.loading

                LoadingSpinner {
                    anchors.horizontalCenter: parent.horizontalCenter
                    size: theme.heightSmall
                    color: theme.primaryColor
                    strokeWidth: theme.spinStrokeWidthSmall
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.loadingText
                    color: theme.textColor2
                    font.family: theme.fontFamily
                    font.pixelSize: 13
                    font.weight: Font.Medium
                }
            }

            Item {
                visible: root.hasLeftOverlay
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: root.leftFixedWidth
                clip: true

                Rectangle {
                    anchors.fill: parent
                    color: root.fixedOverlayColor
                }

                Column {
                    width: parent.width
                    y: -bodyFlick.contentY
                    spacing: 0

                    Repeater {
                        model: root.displayData

                        delegate: Item {
                            required property var modelData
                            required property int index
                            property var rowData: modelData
                            property int rowIndex: index
                            property bool rowHovered: root.hoveredRowIndex === rowIndex
                            width: parent.width
                            height: root.rowHeight

                            Rectangle {
                                anchors.fill: parent
                                color: root.rowFillColor(rowData, rowIndex, rowHovered)

                                Behavior on color {
                                    ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                                }
                            }

                            Rectangle {
                                visible: root.singleLine
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 1
                                color: theme.dividerColor
                            }

                            Row {
                                anchors.fill: parent
                                spacing: 0

                                Item {
                                    visible: root.checkable
                                    width: root.checkable ? root.selectionColumnWidth : 0
                                    height: parent.height

                                    BrisaCheckbox {
                                        anchors.centerIn: parent
                                        size: root.size === "large" ? "large" : (root.size === "small" ? "small" : "medium")
                                        checked: root.isRowChecked(rowData, rowIndex)
                                        onUpdateChecked: function(v) { root.toggleRowChecked(rowData, rowIndex, !!v) }
                                    }

                                    Rectangle {
                                        visible: root.leftFixedColumns.length > 0
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        anchors.right: parent.right
                                        width: 1
                                        color: root.fixedDividerColor
                                    }
                                }

                                Repeater {
                                    model: root.leftFixedColumns

                                    delegate: Item {
                                        required property var modelData
                                        property var column: modelData
                                        width: root.columnWidth(column)
                                        height: parent.height

                                        Item {
                                            anchors.fill: parent
                                            anchors.leftMargin: root.horizontalPadding
                                            anchors.rightMargin: root.horizontalPadding

                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                width: parent.width
                                                text: root.cellText(rowData, column)
                                                color: theme.textColor2
                                                font.family: theme.fontFamily
                                                font.pixelSize: root.tableFontSize
                                                elide: Text.ElideRight
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: column.align === "right"
                                                    ? Text.AlignRight
                                                    : (column.align === "center" ? Text.AlignHCenter : Text.AlignLeft)
                                            }
                                        }
                                    }
                                }
                            }

                            HoverHandler {
                                id: fixedRowHover
                                onHoveredChanged: {
                                    if (hovered)
                                        root.hoveredRowIndex = rowIndex
                                    else if (root.hoveredRowIndex === rowIndex)
                                        root.hoveredRowIndex = -1
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    width: 1
                    color: root.fixedDividerColor
                }

            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: tableHeader.elevated ? (theme.dark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.08)) : theme.dividerColor

                Behavior on color {
                    ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }

            Rectangle {
                visible: tableHeader.elevated
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.bottom
                height: 10
                z: 1
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0.0; color: root.stickyHeaderShadowColor }
                    GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.0) }
                }
                opacity: tableHeader.elevated ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }

            Rectangle {
                visible: root.leftOverlayShadowVisible
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: root.leftFixedWidth
                width: root.fixedShadowWidth
                z: 3
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: root.fixedShadowColorStrong }
                    GradientStop { position: 0.55; color: root.fixedShadowColorSoft }
                    GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.0) }
                }
                opacity: root.leftOverlayShadowVisible ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }
        }

        Rectangle {
            id: paginationWrap
            visible: root.showPagination
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: root.paginationHeight
            color: Qt.rgba(root.backgroundColor.r, root.backgroundColor.g, root.backgroundColor.b, theme.dark ? 0.94 : 0.88)

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 1
                color: theme.dark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.08)
            }

            Rectangle {
                visible: bodyFlick.contentHeight > bodyFlick.height && bodyFlick.contentY < Math.max(0, bodyFlick.contentHeight - bodyFlick.height)
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 10
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0.0; color: theme.dark ? Qt.rgba(0, 0, 0, 0.2) : Qt.rgba(0, 0, 0, 0.06) }
                    GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.0) }
                }
                opacity: 0.9
            }

            BrisaPagination {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: root.horizontalPadding
                anchors.rightMargin: root.horizontalPadding
                simple: false
                size: root.size === "small" ? "small" : (root.size === "large" ? "large" : "medium")
                page: root.mergedPage
                pageSize: root.mergedPageSize
                itemCount: root.remote ? root.totalItemCount : root.sortedData.length
                showSizePicker: root.showSizePicker
                showQuickJumper: root.showQuickJumper
                pageSizes: root.pageSizes
                onUpdatePage: function(v) { root.setPageValue(v) }
                onUpdatePageSize: function(v) {
                    root.setPageSizeValue(v)
                    root.setPageValue(1)
                }
            }
        }
    }
}
