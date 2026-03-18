import QtQuick
import QtQuick.Layouts

Item {
    id: root
    width: 960
    implicitHeight: column.implicitHeight

    Theme { id: theme }

    property int basicPage: 2
    property int simplePage: 5
    property int sizedPage: 3
    property int pickerPage: 1
    property int pickerSize: 20
    property int disabledPage: 4

    Column {
        id: column
        width: parent.width
        spacing: 20

        Text {
            text: "Pagination"
            color: theme.textColor1
            font.family: theme.fontFamily
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Naive UI inspired pagination with line-level controls, size picker, quick jumper and simple mode."
            color: theme.textColor3
            font.family: theme.fontFamily
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Basic"

            BrisaPagination {
                page: root.basicPage
                itemCount: 120
                onUpdatePage: function(v) { root.basicPage = v }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Simple"

            BrisaPagination {
                simple: true
                page: root.simplePage
                itemCount: 180
                pageSize: 10
                onUpdatePage: function(v) { root.simplePage = v }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Simple Disabled"

            BrisaPagination {
                simple: true
                disabled: true
                page: 5
                itemCount: 180
                pageSize: 10
            }
        }

        BrisaCard {
            width: parent.width
            title: "Size Picker And Quick Jumper"

            BrisaPagination {
                page: root.pickerPage
                pageSize: root.pickerSize
                itemCount: 280
                showSizePicker: true
                showQuickJumper: true
                pageSizes: [10, 20, 30, 40]
                onUpdatePage: function(v) { root.pickerPage = v }
                onUpdatePageSize: function(v) { root.pickerSize = v }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Sizes"

            Column {
                width: parent.width
                spacing: 12

                BrisaPagination {
                    size: "small"
                    page: root.sizedPage
                    itemCount: 160
                    onUpdatePage: function(v) { root.sizedPage = v }
                }

                BrisaPagination {
                    size: "medium"
                    page: root.sizedPage
                    itemCount: 160
                    onUpdatePage: function(v) { root.sizedPage = v }
                }

                BrisaPagination {
                    size: "large"
                    page: root.sizedPage
                    itemCount: 160
                    onUpdatePage: function(v) { root.sizedPage = v }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Prefix And Suffix"

            BrisaPagination {
                page: 6
                itemCount: 280
                showSizePicker: true
                pageSize: 20
                prefix: Component {
                    Text {
                        text: "Total 280"
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSizeSmall
                        font.weight: Font.Medium
                        anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                    }
                }
                suffix: Component {
                    Text {
                        text: "Page 6"
                        color: theme.textColor3
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSizeSmall
                        font.weight: Font.Medium
                        anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Disabled"

            BrisaPagination {
                disabled: true
                page: root.disabledPage
                itemCount: 200
            }
        }
    }
}
