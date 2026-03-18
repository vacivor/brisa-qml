import QtQuick

Item {
    id: root
    width: 900
    implicitHeight: column.implicitHeight

    Theme { id: theme }

    Column {
        id: column
        width: parent.width
        spacing: 20

        Text {
            text: "Select"
            color: theme.textColor1
            font.family: "Space Grotesk"
            font.pixelSize: 22
            font.weight: Font.DemiBold
        }

        Text {
            text: "Single-select aligned with Naive UI light."
            color: theme.textColor3
            font.family: "Space Grotesk"
            font.pixelSize: 12
        }

        BrisaCard {
            width: parent.width
            title: "Basic"
            Column {
                width: parent.width
                spacing: 12
                BrisaSelect { width: parent.width; value: basicValue; options: longOptions; clearable: true }
                BrisaSelect { width: parent.width; value: basicValue; options: longOptions; disabled: true }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Sizes"
            Column {
                spacing: 12
                BrisaSelect { value: sizeValue; options: baseOptions; size: "tiny" }
                BrisaSelect { value: sizeValue; options: baseOptions; size: "small" }
                BrisaSelect { value: sizeValue; options: baseOptions; size: "medium" }
                BrisaSelect { value: sizeValue; options: baseOptions; size: "large" }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Multiple"
            Column {
                width: parent.width
                spacing: 12
                BrisaSelect { width: parent.width; value: multiValue; options: longOptions; multiple: true; clearable: true }
                BrisaSelect { width: parent.width; value: multiValue; options: longOptions; multiple: true; disabled: true }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Placeholder"
            Column {
                spacing: 12
                BrisaSelect { value: placeholderValue; options: baseOptions; placeholder: "Please select a song" }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Filterable"
            Column {
                width: parent.width
                spacing: 12
                BrisaSelect {
                    width: parent.width
                    value: filterValue
                    options: longOptions
                    filterable: true
                    clearable: true
                    placeholder: "Please select a song"
                }
                BrisaSelect {
                    width: parent.width
                    value: filterMulti
                    options: longOptions
                    filterable: true
                    multiple: true
                    clearable: true
                    placeholder: "Please Select Songs"
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Responsive Width"
            Column {
                width: parent.width
                spacing: 12

                BrisaSelect {
                    width: parent.width
                    value: responsiveSingle
                    options: longOptions
                    clearable: true
                    placeholder: "Full width single select"
                }

                BrisaSelect {
                    width: parent.width
                    value: responsiveMulti
                    options: longOptions
                    multiple: true
                    clearable: true
                    filterable: true
                    placeholder: "Full width multiple select"
                }

                Item {
                    width: parent.width
                    height: responsiveRow.implicitHeight

                    Row {
                        id: responsiveRow
                        width: parent.width
                        spacing: 12

                        BrisaSelect {
                            width: Math.floor((parent.width - parent.spacing) * 0.38)
                            value: responsiveSingle
                            options: longOptions
                            clearable: true
                            placeholder: "Narrow"
                        }

                        BrisaSelect {
                            width: Math.floor((parent.width - parent.spacing) * 0.62)
                            value: responsiveWide
                            options: longOptions
                            filterable: true
                            clearable: true
                            placeholder: "Wider filterable select"
                        }
                    }
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Filterable (No Results)"
            Column {
                spacing: 12
                BrisaSelect {
                    value: filterValue
                    options: longOptions
                    filterable: true
                    clearable: true
                    placeholder: "Search Songs"
                    emptyText: "No data"
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Clearable"
            Column {
                spacing: 12
                BrisaSelect { value: basicValue; options: baseOptions; clearable: true }
                BrisaSelect { value: multiValue; options: baseOptions; clearable: true; multiple: true }
                BrisaSelect { value: filterValue; options: baseOptions; clearable: true; filterable: true; placeholder: "Filter and clear" }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Tag"
            Column {
                spacing: 12
                BrisaSelect { value: tagValue; options: longOptions; filterable: true; tag: true }
                BrisaSelect { value: tagValues; options: longOptions; filterable: true; tag: true; multiple: true }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Clear Filter"
            Column {
                spacing: 12
                BrisaSelect {
                    value: filterMulti
                    options: longOptions
                    filterable: true
                    multiple: true
                    clearFilterAfterSelect: false
                    placeholder: "Search Songs"
                }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Menu Width"
            Column {
                spacing: 12
                BrisaSelect { value: basicValue; options: longOptions; consistentMenuWidth: false }
                BrisaSelect { value: multiValue; options: longOptions; multiple: true; consistentMenuWidth: false }
            }
        }

        BrisaCard {
            width: parent.width
            title: "Events"
            Column {
                spacing: 12
                BrisaSelect {
                    value: eventValue
                    options: longOptions
                    onUpdateValue: function(v) { console.log("select update:value", v) }
                }
            }
        }
    }

    property var basicValue: "song1"
    property var sizeValue: "song2"
    property var placeholderValue: ""
    property var eventValue: ""
    property var filterValue: ""
    property var filterMulti: []
    property var tagValue: ""
    property var tagValues: []
    property var multiValue: ["song3"]
    property var responsiveSingle: "song11"
    property var responsiveWide: "song10"
    property var responsiveMulti: ["song1", "song4", "song11"]

    property var baseOptions: [
        { label: "Drive My Car", value: "song1" },
        { label: "Norwegian Wood", value: "song2" },
        { label: "You Won't See", value: "song3" },
        { label: "Nowhere Man", value: "song4" },
        { label: "Think For Yourself", value: "song5" },
        { label: "The Word", value: "song6" },
        { label: "Michelle", value: "song7" }
    ]

    property var longOptions: [
        {
            label: "Everybody's Got Something to Hide Except Me and My Monkey",
            value: "song0",
            disabled: true
        },
        { label: "Drive My Car", value: "song1" },
        { label: "Norwegian Wood", value: "song2" },
        { label: "You Won't See", value: "song3", disabled: true },
        { label: "Nowhere Man", value: "song4" },
        { label: "Think For Yourself", value: "song5" },
        { label: "The Word", value: "song6" },
        { label: "Michelle", value: "song7", disabled: true },
        { label: "What goes on", value: "song8" },
        { label: "Girl", value: "song9" },
        { label: "I'm looking through you", value: "song10" },
        { label: "In My Life", value: "song11" },
        { label: "Wait", value: "song12" }
    ]
}
