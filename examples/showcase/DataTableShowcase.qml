import QtQuick
import QtQuick.Layouts

Item {
    id: root
    width: 960
    implicitHeight: column.implicitHeight

    Theme { id: theme }

    property bool loadingState: true
    property bool remoteLoadingState: false
    property var remoteSortState: ({ columnKey: "", order: false })
    property int pagedPage: 1
    property int pagedPageSize: 10
    property var checkedKeys: ["Wade Warren"]

    property var columnsBasic: [
        { key: "name", title: "Name", minWidth: 160, sortable: true },
        { key: "age", title: "Age", width: 100, sortable: true, align: "right" },
        { key: "address", title: "Address", minWidth: 260 },
        { key: "role", title: "Role", minWidth: 140 }
    ]

    property var columnsWide: [
        { key: "name", title: "Name", minWidth: 180, sortable: true, fixed: "left" },
        { key: "company", title: "Company", minWidth: 220 },
        { key: "email", title: "Email", minWidth: 260 },
        { key: "city", title: "City", minWidth: 160 },
        { key: "score", title: "Score", width: 100, sortable: true, align: "right" }
    ]

    property var columnsFixed: [
        { key: "name", title: "Name", minWidth: 200, sortable: true, fixed: "left" },
        { key: "company", title: "Company", minWidth: 260 },
        { key: "email", title: "Email", minWidth: 320 },
        { key: "department", title: "Department", minWidth: 200 },
        { key: "city", title: "City", minWidth: 180 },
        { key: "score", title: "Score", width: 120, sortable: true, align: "right" }
    ]

    property var rowsBasic: [
        { name: "Eleanor Pena", age: 27, address: "45 Market Street, San Francisco", role: "Designer" },
        { name: "Wade Warren", age: 32, address: "12 Linden Avenue, Seattle", role: "Engineer" },
        { name: "Savannah Nguyen", age: 29, address: "96 Orchard Road, Singapore", role: "Researcher" },
        { name: "Cody Fisher", age: 35, address: "77 Hudson Yard, New York", role: "PM" }
    ]

    property var rowsWide: [
        { name: "Ava Chen", company: "Northwind Labs", email: "ava@northwind.dev", city: "Shanghai", score: 92 },
        { name: "Liam Park", company: "Signal Works", email: "liam@signal.works", city: "Seoul", score: 87 },
        { name: "Mia Harper", company: "Boreal Studio", email: "mia@boreal.studio", city: "Berlin", score: 95 },
        { name: "Noah Reed", company: "Atlas Metrics", email: "noah@atlas.io", city: "Austin", score: 89 },
        { name: "Emma Stone", company: "Kite Systems", email: "emma@kite.systems", city: "Tokyo", score: 90 }
    ]

    property var rowsPaged: [
        { name: "Ava Chen", company: "Northwind Labs", email: "ava@northwind.dev", city: "Shanghai", score: 92 },
        { name: "Liam Park", company: "Signal Works", email: "liam@signal.works", city: "Seoul", score: 87 },
        { name: "Mia Harper", company: "Boreal Studio", email: "mia@boreal.studio", city: "Berlin", score: 95 },
        { name: "Noah Reed", company: "Atlas Metrics", email: "noah@atlas.io", city: "Austin", score: 89 },
        { name: "Emma Stone", company: "Kite Systems", email: "emma@kite.systems", city: "Tokyo", score: 90 },
        { name: "Lucas Wu", company: "Frame Logic", email: "lucas@frame.logic", city: "Shenzhen", score: 91 },
        { name: "Chloe Lin", company: "Mosaic Cloud", email: "chloe@mosaic.cloud", city: "Singapore", score: 88 },
        { name: "Ethan Cole", company: "Nova Harbor", email: "ethan@novaharbor.io", city: "London", score: 86 },
        { name: "Sofia Kim", company: "Polar Axis", email: "sofia@polaraxis.com", city: "Busan", score: 93 },
        { name: "Mason Lee", company: "Quill Harbor", email: "mason@quillharbor.dev", city: "Taipei", score: 84 },
        { name: "Olivia Hart", company: "Bright Thread", email: "olivia@brightthread.io", city: "Sydney", score: 96 },
        { name: "Henry Moss", company: "Tangent Labs", email: "henry@tangentlabs.app", city: "Toronto", score: 85 },
        { name: "Grace Yu", company: "Summit Grid", email: "grace@summitgrid.ai", city: "Hong Kong", score: 94 },
        { name: "Jack Turner", company: "Cobalt Run", email: "jack@cobaltrun.dev", city: "Dublin", score: 82 },
        { name: "Ella Price", company: "Orbit Foundry", email: "ella@orbitfoundry.com", city: "Paris", score: 90 }
    ]

    property var rowsFixed: [
        { name: "Ava Chen", company: "Northwind Labs", email: "ava@northwind.dev", department: "Product Research", city: "Shanghai", score: 92 },
        { name: "Liam Park", company: "Signal Works", email: "liam@signal.works", department: "Platform", city: "Seoul", score: 87 },
        { name: "Mia Harper", company: "Boreal Studio", email: "mia@boreal.studio", department: "Design Systems", city: "Berlin", score: 95 },
        { name: "Noah Reed", company: "Atlas Metrics", email: "noah@atlas.io", department: "Data Infra", city: "Austin", score: 89 },
        { name: "Emma Stone", company: "Kite Systems", email: "emma@kite.systems", department: "Growth", city: "Tokyo", score: 90 },
        { name: "Lucas Wu", company: "Frame Logic", email: "lucas@frame.logic", department: "Security", city: "Shenzhen", score: 91 },
        { name: "Chloe Lin", company: "Mosaic Cloud", email: "chloe@mosaic.cloud", department: "Developer Experience", city: "Singapore", score: 88 },
        { name: "Ethan Cole", company: "Nova Harbor", email: "ethan@novaharbor.io", department: "Operations", city: "London", score: 86 }
    ]

    Column {
        id: column
        width: parent.width
        spacing: 20

        Text {
            text: "Data Table"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI inspired data table with sorting, loading, striped rows, fixed columns and pagination."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Basic"

            Item {
                width: parent.width
                height: 220

                BrisaDataTable {
                    anchors.fill: parent
                    columns: root.columnsBasic
                    rows: root.rowsBasic
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Striped"

            Item {
                width: parent.width
                height: 220

                BrisaDataTable {
                    anchors.fill: parent
                    striped: true
                    columns: root.columnsBasic
                    rows: root.rowsBasic
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Loading"

            Column {
                width: parent.width
                spacing: 12

                BrisaSwitch {
                    value: root.loadingState
                    onUpdateValue: function(v) { root.loadingState = v }
                }

                Item {
                    width: parent.width
                    height: 220

                    BrisaDataTable {
                        anchors.fill: parent
                        loading: root.loadingState
                        columns: root.columnsBasic
                        rows: root.rowsBasic
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Horizontal Scroll"

            Item {
                width: parent.width
                height: 240

                BrisaDataTable {
                    anchors.fill: parent
                    columns: root.columnsWide
                    rows: root.rowsWide
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Selection"

            Item {
                width: parent.width
                height: 240

                BrisaDataTable {
                    anchors.fill: parent
                    checkable: true
                    rowKeyField: "name"
                    checkedRowKeys: root.checkedKeys
                    columns: root.columnsBasic
                    rows: root.rowsBasic
                    onUpdateCheckedRowKeys: function(keys) { root.checkedKeys = keys }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Pagination"

            Item {
                width: parent.width
                height: 360

                BrisaDataTable {
                    anchors.fill: parent
                    columns: root.columnsWide
                    rows: root.rowsPaged
                    showPagination: true
                    page: root.pagedPage
                    pageSize: root.pagedPageSize
                    showSizePicker: true
                    showQuickJumper: true
                    onUpdatePage: function(v) { root.pagedPage = v }
                    onUpdatePageSize: function(v) { root.pagedPageSize = v }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Fixed Left Column"

            Item {
                width: parent.width
                height: 260

                BrisaDataTable {
                    anchors.fill: parent
                    columns: root.columnsFixed
                    rows: root.rowsFixed
                    checkable: true
                    rowKeyField: "email"
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Remote Sort And Empty"

            Column {
                width: parent.width
                spacing: 16

                Row {
                    spacing: 12

                    BrisaSwitch {
                        value: root.remoteLoadingState
                        onUpdateValue: function(v) { root.remoteLoadingState = v }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Simulate remote loading"
                        color: theme.textColor2
                        font.family: theme.fontFamily
                        font.pixelSize: 13
                    }
                }

                Item {
                    width: parent.width
                    height: 220

                    BrisaDataTable {
                        anchors.fill: parent
                        remote: true
                        loading: root.remoteLoadingState
                        sortState: root.remoteSortState
                        columns: root.columnsBasic
                        rows: root.rowsBasic
                        loadingText: "Fetching data"
                        onUpdateSortState: function(state) { root.remoteSortState = state }
                    }
                }

                Item {
                    width: parent.width
                    height: 200

                    BrisaDataTable {
                        anchors.fill: parent
                        columns: root.columnsBasic
                        rows: []
                        emptyText: "No records yet"
                        emptyDescription: "Try changing the filters or importing a new dataset."
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Size"

            Column {
                width: parent.width
                spacing: 16

                Item {
                    width: parent.width
                    height: 180

                    BrisaDataTable {
                        anchors.fill: parent
                        size: "small"
                        columns: root.columnsBasic
                        rows: root.rowsBasic
                    }
                }

                Item {
                    width: parent.width
                    height: 180

                    BrisaDataTable {
                        anchors.fill: parent
                        size: "medium"
                        columns: root.columnsBasic
                        rows: root.rowsBasic
                    }
                }

                Item {
                    width: parent.width
                    height: 180

                    BrisaDataTable {
                        anchors.fill: parent
                        size: "large"
                        columns: root.columnsBasic
                        rows: root.rowsBasic
                    }
                }
            }
        }
    }
}
