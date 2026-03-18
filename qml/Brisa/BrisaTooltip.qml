import QtQuick

BrisaPopover {
    id: root
    property string text: ""

    backgroundColor: theme.tooltipColor
    borderColor: "transparent"
    borderWidth: 0
    paddingX: 8
    paddingY: 6
    shadowEnabled: true
    shadowColor1: Qt.rgba(0, 0, 0, 0.18)
    shadowColor2: Qt.rgba(0, 0, 0, 0.08)
    shadowBlur1: 0.12
    shadowBlur2: 0.32
    shadowOffset1: 1
    shadowOffset2: 3
    showArrow: true
    scrollable: false
    outsideClosable: false
    blocksUnderlay: false

    Text {
        text: root.text
        color: theme.tooltipTextColor
        font.pixelSize: 11
        lineHeightMode: Text.FixedHeight
        lineHeight: 16
        font.family: "Space Grotesk"
        wrapMode: Text.Wrap
    }
}
