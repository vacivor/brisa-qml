import QtQuick
import brisa_qml

QtObject {
    id: theme

    readonly property bool dark: ThemeStore.dark
    property string fontFamily: "Space Grotesk"

    // Common colors from naive-ui light
    property color baseColor: dark ? "#18181c" : "#ffffff"
    property color appWindowColor: dark ? "#111317" : "#f3f5f9"
    property color appBackdropStart: dark ? "#12161c" : "#f8fafc"
    property color appBackdropMid: dark ? "#151b22" : "#eef2f7"
    property color appBackdropEnd: dark ? "#10151b" : "#e6ebf3"
    property color appVignetteBorderColor: dark ? Qt.rgba(255, 255, 255, 0.08) : "#ffffff"
    property color textColor1: dark ? "#f3f5f7" : "#1f2225"
    property color textColor2: dark ? "#d7d9dd" : "#333639"
    property color textColor3: dark ? "#8e949c" : "#767c82"
    property color textColorDisabled: dark ? "#5f6670" : "#c2c2c8"
    property color hoverColor: dark ? "#2a2d33" : "#f3f3f5"
    property color borderColor: dark ? "#2e333b" : "#e0e0e6"
    property color dividerColor: dark ? "#2a2f36" : "#efeff5"
    property color actionColor: dark ? "#23262b" : "#fafafc"
    property color popoverColor: dark ? "#23262b" : "#ffffff"
    property color tooltipColor: dark ? "#f3f5f7" : "#1f1f1f"
    property color tooltipTextColor: dark ? "#1f1f1f" : "#ffffff"
    property color modalColor: dark ? "#23262b" : "#ffffff"
    property color modalMaskColor: Qt.rgba(0, 0, 0, dark ? 0.55 : 0.4)
    property color drawerMaskColor: Qt.rgba(0, 0, 0, dark ? 0.45 : 0.3)
    property color inputColor: dark ? "#1f2126" : "#ffffff"
    property color inputColorDisabled: dark ? "#25282e" : "#fafafc"
    property color placeholderColor: dark ? "#666d77" : "#c0c4cc"
    property color placeholderColorDisabled: dark ? "#545a63" : "#d2d6dc"
    property color clearColor: dark ? "#6f7680" : "#c2c4cc"
    property color clearColorHover: dark ? "#9298a1" : "#a8adb6"
    property color clearColorPressed: dark ? "#b3b8bf" : "#8f96a1"
    property color iconColor: dark ? "#a6acb5" : "#676c72"
    property color iconColorDisabled: dark ? "#5d646d" : "#c2c7cc"
    property color iconColorHover: dark ? "#c2c7cf" : "#5e6369"
    property color iconColorPressed: dark ? "#eceff3" : "#4a4f55"
    property color scrollbarColor: dark ? Qt.rgba(255, 255, 255, 0.18) : Qt.rgba(0, 0, 0, 0.22)
    property color scrollbarColorHover: dark ? Qt.rgba(255, 255, 255, 0.28) : Qt.rgba(0, 0, 0, 0.34)
    property color scrollbarRailColor: "transparent"

    property color primaryColor: "#18a058"
    property color primaryColorHover: "#36ad6a"
    property color primaryColorPressed: "#0c7a43"
    property color cursorColor: "#18a058"

    property color infoColor: "#2080f0"
    property color infoColorHover: "#4098fc"
    property color infoColorPressed: "#1060c9"

    property color successColor: "#18a058"
    property color successColorHover: "#36ad6a"
    property color successColorPressed: "#0c7a43"

    property color warningColor: "#f0a020"
    property color warningColorHover: "#fcb040"
    property color warningColorPressed: "#c97c10"

    property color errorColor: "#d03050"
    property color errorColorHover: "#de576d"
    property color errorColorPressed: "#ab1f3f"

    property real opacityDisabled: 0.5

    // Secondary/tertiary/quaternary button surfaces
    property color buttonColor2: dark ? Qt.rgba(255, 255, 255, 0.08) : Qt.rgba(46 / 255, 51 / 255, 56 / 255, 0.05)
    property color buttonColor2Hover: dark ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(46 / 255, 51 / 255, 56 / 255, 0.09)
    property color buttonColor2Pressed: dark ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(46 / 255, 51 / 255, 56 / 255, 0.13)

    // Sizes (px)
    property int heightTiny: 22
    property int heightSmall: 28
    property int heightMedium: 34
    property int heightLarge: 40

    property int fontSizeTiny: 12
    property int fontSizeSmall: 14
    property int fontSizeMedium: 14
    property int fontSizeLarge: 15

    property int paddingTiny: 6
    property int paddingSmall: 10
    property int paddingMedium: 14
    property int paddingLarge: 18

    property int paddingRoundTiny: 10
    property int paddingRoundSmall: 14
    property int paddingRoundMedium: 18
    property int paddingRoundLarge: 22

    property int iconSizeTiny: 14
    property int iconSizeSmall: 18
    property int iconSizeMedium: 18
    property int iconSizeLarge: 20

    property int iconMarginTiny: 6
    property int iconMarginSmall: 6
    property int iconMarginMedium: 6
    property int iconMarginLarge: 6

    property int selectionPaddingSingleLeft: 12
    property int selectionPaddingSingleRight: 26
    property int selectionPaddingMultipleTop: 3
    property int selectionPaddingMultipleRight: 26
    property int selectionPaddingMultipleBottom: 0
    property int selectionPaddingMultipleLeft: 12
    property int selectionClearSize: 16
    property int selectionArrowSize: 16
    property int selectionSuffixRight: 10
    property int selectionTagGap: 4
    property int selectionInputTagBottomMargin: 3
    property int selectionInputTagHeightOffset: 6
    property int selectOptionInset: 4
    property int selectOptionPaddingLeft: 12
    property int selectOptionPaddingRight: 12
    property int selectOptionCheckReserve: 20
    property int selectOptionCheckSize: 16

    property int checkboxSizeSmall: 14
    property int checkboxSizeMedium: 16
    property int checkboxSizeLarge: 18
    property int radioSizeSmall: 14
    property int radioSizeMedium: 16
    property int radioSizeLarge: 18
    property int choiceLabelPadding: 8
    property int choiceLabelFontWeight: 400
    property color radioColor: baseColor
    property color radioColorActive: "#00000000"
    property color radioColorDisabled: inputColorDisabled
    property color radioDotColorActive: primaryColor
    property color radioDotColorDisabled: borderColor
    property color checkboxColor: baseColor
    property color checkboxColorChecked: primaryColor
    property color checkboxColorDisabled: inputColorDisabled
    property color checkboxColorDisabledChecked: inputColorDisabled
    property color checkboxCheckMarkColor: baseColor
    property color checkboxCheckMarkColorDisabled: theme.textColorDisabled
    property color checkboxCheckMarkColorDisabledChecked: theme.textColorDisabled
    property int formFeedbackHeightSmall: 24
    property int formFeedbackHeightMedium: 24
    property int formFeedbackHeightLarge: 26
    property int formFeedbackFontSizeSmall: 13
    property int formFeedbackFontSizeMedium: 14
    property int formFeedbackFontSizeLarge: 14
    property int formLabelFontSizeLeftSmall: 14
    property int formLabelFontSizeLeftMedium: 14
    property int formLabelFontSizeLeftLarge: 15
    property int formLabelFontSizeTopSmall: 13
    property int formLabelFontSizeTopMedium: 14
    property int formLabelFontSizeTopLarge: 14
    property int formLabelHeightSmall: 24
    property int formLabelHeightMedium: 26
    property int formLabelHeightLarge: 28
    property int formLabelPaddingTopHorizontal: 2
    property int formLabelPaddingTopBottom: 6
    property int formLabelPaddingLeftRight: 12
    property int formFeedbackPaddingLeft: 2
    property int formFeedbackPaddingTop: 4
    property int formInlineItemGap: 18
    property int switchButtonHeightSmall: 14
    property int switchButtonHeightMedium: 18
    property int switchButtonHeightLarge: 22
    property int switchButtonWidthSmall: 14
    property int switchButtonWidthMedium: 18
    property int switchButtonWidthLarge: 22
    property int switchButtonWidthPressedSmall: 20
    property int switchButtonWidthPressedMedium: 24
    property int switchButtonWidthPressedLarge: 28
    property int switchRailHeightSmall: 18
    property int switchRailHeightMedium: 22
    property int switchRailHeightLarge: 26
    property int switchRailWidthSmall: 32
    property int switchRailWidthMedium: 40
    property int switchRailWidthLarge: 48
    property color switchRailColor: dark ? Qt.rgba(255, 255, 255, 0.22) : Qt.rgba(0, 0, 0, 0.14)
    property color switchRailColorActive: primaryColor
    property color switchButtonColor: "#ffffff"
    property color switchLoadingColor: primaryColor
    property color switchTextColor: "#ffffff"
    property color switchIconColor: textColor3
    property int switchLoadingSizeSmall: 8
    property int switchLoadingSizeMedium: 10
    property int switchLoadingSizeLarge: 12
    property int spinStrokeWidthSmall: 20
    property int spinStrokeWidthMedium: 18
    property int spinStrokeWidthLarge: 16
    property int scrollbarSize: 5
    property int scrollbarBorderRadius: 5
    property int scrollbarInsetMain: 4
    property int scrollbarInsetCross: 2
    property int popoverSpace: 6
    property int popoverSpaceArrow: 10
    property int popoverArrowHeight: 6
    property int popoverArrowOffset: 10
    property int popoverArrowOffsetVertical: 10

    property int borderRadius: 3

    property int rippleDuration: 600
    property real waveOpacity: 0.6
    property int transitionDuration: 180
    property int transitionDurationFast: 120

    function colorForType(type) {
        switch (type) {
        case "primary":
            return primaryColor
        case "info":
            return infoColor
        case "success":
            return successColor
        case "warning":
            return warningColor
        case "error":
            return errorColor
        default:
            return "#00000000"
        }
    }

    function colorHoverForType(type) {
        switch (type) {
        case "primary":
            return primaryColorHover
        case "info":
            return infoColorHover
        case "success":
            return successColorHover
        case "warning":
            return warningColorHover
        case "error":
            return errorColorHover
        default:
            return "#00000000"
        }
    }

    function colorPressedForType(type) {
        switch (type) {
        case "primary":
            return primaryColorPressed
        case "info":
            return infoColorPressed
        case "success":
            return successColorPressed
        case "warning":
            return warningColorPressed
        case "error":
            return errorColorPressed
        default:
            return "#00000000"
        }
    }

    function heightFor(size) {
        switch (size) {
        case "tiny":
            return heightTiny
        case "small":
            return heightSmall
        case "large":
            return heightLarge
        default:
            return heightMedium
        }
    }

    function fontSizeFor(size) {
        switch (size) {
        case "tiny":
            return fontSizeTiny
        case "small":
            return fontSizeSmall
        case "large":
            return fontSizeLarge
        default:
            return fontSizeMedium
        }
    }

    function paddingFor(size) {
        switch (size) {
        case "tiny":
            return paddingTiny
        case "small":
            return paddingSmall
        case "large":
            return paddingLarge
        default:
            return paddingMedium
        }
    }

    function switchLoadingSizeFor(size) {
        switch (size) {
        case "small":
            return switchLoadingSizeSmall
        case "large":
            return switchLoadingSizeLarge
        default:
            return switchLoadingSizeMedium
        }
    }

    function spinStrokeWidthFor(size) {
        switch (size) {
        case "small":
            return spinStrokeWidthSmall
        case "large":
            return spinStrokeWidthLarge
        default:
            return spinStrokeWidthMedium
        }
    }

    function paddingRoundFor(size) {
        switch (size) {
        case "tiny":
            return paddingRoundTiny
        case "small":
            return paddingRoundSmall
        case "large":
            return paddingRoundLarge
        default:
            return paddingRoundMedium
        }
    }

    function cursorColorFor(status) {
        if (status === "error") return errorColor
        if (status === "warning") return warningColor
        if (status === "open") return primaryColor
        return cursorColor
    }

    function svgChevronDown(color, size) {
        var c = String(color)
        if (c.indexOf("#") === 0) c = c.slice(1)
        c = "%23" + c
        var s = size || 12
        return "data:image/svg+xml;utf8," +
            "<svg xmlns='http://www.w3.org/2000/svg' width='" + s + "' height='" + s + "' viewBox='0 0 12 12' fill='none'>" +
            "<path d='M2.5 4.25L6 7.75L9.5 4.25' stroke='" + c + "' stroke-width='1.4' stroke-linecap='round' stroke-linejoin='round'/>" +
            "</svg>"
    }

    function svgChevronLeft(color, size) {
        var c = String(color)
        if (c.indexOf("#") === 0) c = c.slice(1)
        c = "%23" + c
        var s = size || 12
        return "data:image/svg+xml;utf8," +
            "<svg xmlns='http://www.w3.org/2000/svg' width='" + s + "' height='" + s + "' viewBox='0 0 12 12' fill='none'>" +
            "<path d='M7.75 2.5L4.25 6L7.75 9.5' stroke='" + c + "' stroke-width='1.4' stroke-linecap='round' stroke-linejoin='round'/>" +
            "</svg>"
    }

    function svgChevronRight(color, size) {
        var c = String(color)
        if (c.indexOf("#") === 0) c = c.slice(1)
        c = "%23" + c
        var s = size || 12
        return "data:image/svg+xml;utf8," +
            "<svg xmlns='http://www.w3.org/2000/svg' width='" + s + "' height='" + s + "' viewBox='0 0 12 12' fill='none'>" +
            "<path d='M4.25 2.5L7.75 6L4.25 9.5' stroke='" + c + "' stroke-width='1.4' stroke-linecap='round' stroke-linejoin='round'/>" +
            "</svg>"
    }

    function svgCheck(color, size) {
        var c = String(color)
        if (c.indexOf("#") === 0) c = c.slice(1)
        c = "%23" + c
        var s = size || 12
        return "data:image/svg+xml;utf8," +
            "<svg xmlns='http://www.w3.org/2000/svg' width='" + s + "' height='" + s + "' viewBox='0 0 12 12' fill='none'>" +
            "<path d='M2.4 6.2L5 8.6L9.6 3.8' stroke='" + c + "' stroke-width='1.6' stroke-linecap='round' stroke-linejoin='round'/>" +
            "</svg>"
    }

    function svgClose(color, size) {
        var c = String(color)
        if (c.indexOf("#") === 0) c = c.slice(1)
        c = "%23" + c
        var s = size || 12
        return "data:image/svg+xml;utf8," +
            "<svg xmlns='http://www.w3.org/2000/svg' width='" + s + "' height='" + s + "' viewBox='0 0 12 12' fill='none'>" +
            "<path d='M2.75 2.75L9.25 9.25M9.25 2.75L2.75 9.25' stroke='" + c + "' stroke-width='1.35' stroke-linecap='round' stroke-linejoin='round'/>" +
            "</svg>"
    }

    function svgPlus(color, size) {
        var c = String(color)
        if (c.indexOf("#") === 0) c = c.slice(1)
        c = "%23" + c
        var s = size || 12
        return "data:image/svg+xml;utf8," +
            "<svg xmlns='http://www.w3.org/2000/svg' width='" + s + "' height='" + s + "' viewBox='0 0 12 12' fill='none'>" +
            "<path d='M6 2.75V9.25M2.75 6H9.25' stroke='" + c + "' stroke-width='1.35' stroke-linecap='round' stroke-linejoin='round'/>" +
            "</svg>"
    }

    function svgClear(color, size) {
        var c = String(color)
        if (c.indexOf("#") === 0) c = c.slice(1)
        c = "%23" + c
        var s = size || 16
        return "data:image/svg+xml;utf8," +
            "<svg xmlns='http://www.w3.org/2000/svg' width='" + s + "' height='" + s + "' viewBox='0 0 16 16' fill='none'>" +
            "<path fill='" + c + "' fill-rule='evenodd' d='M8 2c3.3137 0 6 2.6863 6 6s-2.6863 6-6 6-6-2.6863-6-6 2.6863-6 6-6Zm-1.4657 3.8386c-.1949-.135-.4643-.1157-.6379.0578l-.0579.0693c-.135.1948-.1157.4642.0579.6378L7.293 8l-1.3966 1.3964-.0579.0693c-.135.1948-.1157.4642.0579.6378l.0692.0579c.1949.135.4643.1157.6379-.0579L8 8.707l1.3964 1.3964.0693.0579c.1948.135.4642.1157.6378-.0579l.0579-.0692c.135-.1949.1157-.4643-.0579-.6379L8.707 8l1.3964-1.3964.0579-.0693c.135-.1948.1157-.4642-.0579-.6378l-.0692-.0579c-.1949-.135-.4643-.1157-.6379.0579L8 7.293 6.6036 5.8964Z' clip-rule='evenodd'/>" +
            "</svg>"
    }

    function svgCheckboxCheck(color, size) {
        var c = String(color)
        if (c.indexOf("#") === 0) c = c.slice(1)
        c = "%23" + c
        var s = size || 12
        return "data:image/svg+xml;utf8," +
            "<svg xmlns='http://www.w3.org/2000/svg' width='" + s + "' height='" + s + "' viewBox='0 0 64 64' fill='none'>" +
            "<path d='M50.42 16.76 22.34 39.45l-8.1-11.46c-1.12-1.58-3.3-1.96-4.88-.84-1.58 1.12-1.95 3.3-.84 4.88l10.26 14.51c.56.79 1.42 1.31 2.38 1.45.16.02.32.03.48.03.8 0 1.57-.27 2.2-.78l30.99-25.03c1.5-1.21 1.74-3.42.52-4.92-1.22-1.51-3.42-1.74-4.93-.53Z' fill='" + c + "'/>" +
            "</svg>"
    }

    function svgCheckboxLine(color, size) {
        var c = String(color)
        if (c.indexOf("#") === 0) c = c.slice(1)
        c = "%23" + c
        var s = size || 12
        return "data:image/svg+xml;utf8," +
            "<svg xmlns='http://www.w3.org/2000/svg' width='" + s + "' height='" + s + "' viewBox='0 0 100 100' fill='none'>" +
            "<path d='M80.2 55.5H21.4c-2.8 0-5.1-2.5-5.1-5.5s2.3-5.5 5.1-5.5h58.7c2.8 0 5.1 2.5 5.1 5.5s-2.3 5.5-5.1 5.5Z' fill='" + c + "'/>" +
            "</svg>"
    }

    function svgEmpty(color, size) {
        var c = String(color)
        if (c.indexOf("#") === 0) c = c.slice(1)
        c = "%23" + c
        var s = size || 40
        return "data:image/svg+xml;utf8," +
            "<svg xmlns='http://www.w3.org/2000/svg' width='" + s + "' height='" + s + "' viewBox='0 0 28 28' fill='none'>" +
            "<path d='M26 7.5C26 11.0899 23.0899 14 19.5 14C15.9101 14 13 11.0899 13 7.5C13 3.91015 15.9101 1 19.5 1C23.0899 1 26 3.91015 26 7.5ZM16.8536 4.14645C16.6583 3.95118 16.3417 3.95118 16.1464 4.14645C15.9512 4.34171 15.9512 4.65829 16.1464 4.85355L18.7929 7.5L16.1464 10.1464C15.9512 10.3417 15.9512 10.6583 16.1464 10.8536C16.3417 11.0488 16.6583 11.0488 16.8536 10.8536L19.5 8.20711L22.1464 10.8536C22.3417 11.0488 22.6583 11.0488 22.8536 10.8536C23.0488 10.6583 23.0488 10.3417 22.8536 10.1464L20.2071 7.5L22.8536 4.85355C23.0488 4.65829 23.0488 4.34171 22.8536 4.14645C22.6583 3.95118 22.3417 3.95118 22.1464 4.14645L19.5 6.79289L16.8536 4.14645Z' fill='" + c + "'/>" +
            "<path d='M25 22.75V12.5991C24.5572 13.0765 24.053 13.4961 23.5 13.8454V16H17.5L17.3982 16.0068C17.0322 16.0565 16.75 16.3703 16.75 16.75C16.75 18.2688 15.5188 19.5 14 19.5C12.4812 19.5 11.25 18.2688 11.25 16.75L11.2432 16.6482C11.1935 16.2822 10.8797 16 10.5 16H4.5V7.25C4.5 6.2835 5.2835 5.5 6.25 5.5H12.2696C12.4146 4.97463 12.6153 4.47237 12.865 4H6.25C4.45507 4 3 5.45507 3 7.25V22.75C3 24.5449 4.45507 26 6.25 26H21.75C23.5449 26 25 24.5449 25 22.75ZM4.5 22.75V17.5H9.81597L9.85751 17.7041C10.2905 19.5919 11.9808 21 14 21L14.215 20.9947C16.2095 20.8953 17.842 19.4209 18.184 17.5H23.5V22.75C23.5 23.7165 22.7165 24.5 21.75 24.5H6.25C5.2835 24.5 4.5 23.7165 4.5 22.75Z' fill='" + c + "'/>" +
            "</svg>"
    }


    function svgEye(color, size) {
        var c = String(color)
        if (c.indexOf("#") === 0) c = c.slice(1)
        c = "%23" + c
        var s = size || 16
        return "data:image/svg+xml;utf8," +
            "<svg xmlns='http://www.w3.org/2000/svg' width='" + s + "' height='" + s + "' viewBox='0 0 16 16' fill='none'>" +
            "<path d='M1.333 8c1.067-2.133 3.467-4 6.667-4s5.6 1.867 6.667 4c-1.067 2.133-3.467 4-6.667 4S2.4 10.133 1.333 8Z' stroke='" + c + "' stroke-width='1.25' stroke-linecap='round' stroke-linejoin='round'/>" +
            "<path d='M8 10.333A2.333 2.333 0 1 0 8 5.667a2.333 2.333 0 0 0 0 4.666Z' stroke='" + c + "' stroke-width='1.25' stroke-linecap='round' stroke-linejoin='round'/>" +
            "</svg>"
    }

    function svgEyeOff(color, size) {
        var c = String(color)
        if (c.indexOf("#") === 0) c = c.slice(1)
        c = "%23" + c
        var s = size || 16
        return "data:image/svg+xml;utf8," +
            "<svg xmlns='http://www.w3.org/2000/svg' width='" + s + "' height='" + s + "' viewBox='0 0 16 16' fill='none'>" +
            "<path d='M6.437 4.212A7.592 7.592 0 0 1 8 4c3.2 0 5.6 1.867 6.667 4-.42.84-1.024 1.64-1.789 2.293M9.14 9.149A1.667 1.667 0 0 1 6.85 6.86' stroke='" + c + "' stroke-width='1.25' stroke-linecap='round' stroke-linejoin='round'/>" +
            "<path d='M4.204 5.207C2.957 5.953 2.01 6.961 1.333 8c1.067 2.133 3.467 4 6.667 4 1.26 0 2.391-.289 3.386-.791' stroke='" + c + "' stroke-width='1.25' stroke-linecap='round' stroke-linejoin='round'/>" +
            "<path d='M2.667 2.667 13.333 13.333' stroke='" + c + "' stroke-width='1.25' stroke-linecap='round' stroke-linejoin='round'/>" +
            "</svg>"
    }

    function checkboxSizeFor(size) {
        switch (size) {
        case "small":
            return checkboxSizeSmall
        case "large":
            return checkboxSizeLarge
        default:
            return checkboxSizeMedium
        }
    }

    function radioSizeFor(size) {
        switch (size) {
        case "small":
            return radioSizeSmall
        case "large":
            return radioSizeLarge
        default:
            return radioSizeMedium
        }
    }

    function switchButtonHeightFor(size) {
        switch (size) {
        case "small":
            return switchButtonHeightSmall
        case "large":
            return switchButtonHeightLarge
        default:
            return switchButtonHeightMedium
        }
    }

    function switchButtonWidthFor(size) {
        switch (size) {
        case "small":
            return switchButtonWidthSmall
        case "large":
            return switchButtonWidthLarge
        default:
            return switchButtonWidthMedium
        }
    }

    function switchButtonWidthPressedFor(size) {
        switch (size) {
        case "small":
            return switchButtonWidthPressedSmall
        case "large":
            return switchButtonWidthPressedLarge
        default:
            return switchButtonWidthPressedMedium
        }
    }

    function switchRailHeightFor(size) {
        switch (size) {
        case "small":
            return switchRailHeightSmall
        case "large":
            return switchRailHeightLarge
        default:
            return switchRailHeightMedium
        }
    }

    function switchRailWidthFor(size) {
        switch (size) {
        case "small":
            return switchRailWidthSmall
        case "large":
            return switchRailWidthLarge
        default:
            return switchRailWidthMedium
        }
    }

    function iconSizeFor(size) {
        switch (size) {
        case "tiny":
            return iconSizeTiny
        case "small":
            return iconSizeSmall
        case "large":
            return iconSizeLarge
        default:
            return iconSizeMedium
        }
    }

    function iconMarginFor(size) {
        switch (size) {
        case "tiny":
            return iconMarginTiny
        case "small":
            return iconMarginSmall
        case "large":
            return iconMarginLarge
        default:
            return iconMarginMedium
        }
    }
}
