import QtQuick

Item {
    id: root

    property var form: null
    property string label: ""
    property var labelWidth: undefined
    property string labelAlign: ""
    property string labelPlacement: ""
    property bool required: false
    property var showRequireMark: undefined
    property string requireMarkPlacement: ""
    property string feedback: ""
    property string message: ""
    property var showFeedback: undefined
    property var showLabel: undefined
    property string status: "default" // default | warning | error | success
    property string size: ""
    property bool disabled: false
    property bool forceFullWidth: false

    readonly property bool _brisaOwnLabelWidth: root.labelWidth !== undefined
    readonly property bool _brisaOwnLabelAlign: root.labelAlign.length > 0
    readonly property bool _brisaOwnLabelPlacement: root.labelPlacement.length > 0
    readonly property bool _brisaOwnShowRequireMark: root.showRequireMark !== undefined
    readonly property bool _brisaOwnRequireMarkPlacement: root.requireMarkPlacement.length > 0
    readonly property bool _brisaOwnShowFeedback: root.showFeedback !== undefined
    readonly property bool _brisaOwnShowLabel: root.showLabel !== undefined
    readonly property bool _brisaOwnSize: root.size.length > 0
    readonly property bool _brisaOwnDisabled: root.disabled

    Theme { id: theme }

    readonly property string mergedSize: {
        if (root.size.length)
            return root.size
        if (root.form && root.form.size)
            return root.form.size
        return "medium"
    }
    readonly property string mergedLabelPlacement: {
        if (root.labelPlacement.length)
            return root.labelPlacement
        if (root.form && root.form.labelPlacement)
            return root.form.labelPlacement
        return "top"
    }
    readonly property string mergedLabelAlign: {
        if (root.labelAlign.length)
            return root.labelAlign
        if (root.form && root.form.labelAlign)
            return root.form.labelAlign
        return mergedLabelPlacement === "left" ? "right" : "left"
    }
    readonly property bool mergedShowRequireMark: {
        if (root.showRequireMark !== undefined)
            return root.showRequireMark
        if (root.form && root.form.showRequireMark !== undefined)
            return root.form.showRequireMark
        return true
    }
    readonly property string mergedRequireMarkPlacement: {
        if (root.requireMarkPlacement.length)
            return root.requireMarkPlacement
        if (root.form && root.form.requireMarkPlacement)
            return root.form.requireMarkPlacement
        return "right"
    }
    readonly property bool mergedShowFeedback: {
        if (root._brisaOwnShowFeedback)
            return root.showFeedback
        if (root.form)
            return root.form.showFeedback
        return true
    }
    readonly property bool mergedShowLabel: {
        if (root.showLabel !== undefined)
            return root.showLabel
        if (root.form && root.form.showLabel !== undefined)
            return root.form.showLabel
        return true
    }
    readonly property string mergedFeedbackText: root.feedback.length > 0 ? root.feedback : root.message
    readonly property int blankHeight: mergedSize === "small" ? theme.heightSmall : mergedSize === "large" ? theme.heightLarge : theme.heightMedium
    readonly property int feedbackHeight: mergedSize === "small"
        ? theme.formFeedbackHeightSmall
        : mergedSize === "large"
            ? theme.formFeedbackHeightLarge
            : theme.formFeedbackHeightMedium
    readonly property int feedbackFontSize: mergedSize === "small"
        ? theme.formFeedbackFontSizeSmall
        : mergedSize === "large"
            ? theme.formFeedbackFontSizeLarge
            : theme.formFeedbackFontSizeMedium
    readonly property int labelFontSize: mergedLabelPlacement === "top"
        ? (mergedSize === "small" ? theme.formLabelFontSizeTopSmall : mergedSize === "large" ? theme.formLabelFontSizeTopLarge : theme.formLabelFontSizeTopMedium)
        : (mergedSize === "small" ? theme.formLabelFontSizeLeftSmall : mergedSize === "large" ? theme.formLabelFontSizeLeftLarge : theme.formLabelFontSizeLeftMedium)
    readonly property int labelHeight: mergedSize === "small" ? theme.formLabelHeightSmall : mergedSize === "large" ? theme.formLabelHeightLarge : theme.formLabelHeightMedium
    readonly property real numericLabelWidth: {
        if (mergedLabelPlacement === "top")
            return 0
        if (root.labelWidth === "auto")
            return root.form ? root.form.autoLabelWidth : labelRow.implicitWidth
        if (root.labelWidth !== undefined && root.labelWidth !== null)
            return Number(root.labelWidth)
        if (root.form) {
            if (root.form.labelWidth === "auto")
                return root.form.autoLabelWidth
            if (root.form.labelWidth !== undefined && root.form.labelWidth !== null)
                return Number(root.form.labelWidth)
        }
        return 90
    }
    readonly property real labelMeasureWidth: labelRow.implicitWidth + 12
    readonly property bool inlineMode: root.form ? root.form.inline : false
    readonly property bool hasVisibleLabel: root.mergedShowLabel && root.label.length > 0
    readonly property real effectiveLabelWidth: mergedLabelPlacement === "left" && hasVisibleLabel ? numericLabelWidth : 0
    readonly property int labelGap: mergedLabelPlacement === "left" && hasVisibleLabel ? 12 : 0
    readonly property bool hasVisibleFeedback: mergedShowFeedback && mergedFeedbackText.length > 0
    readonly property bool hasControlContent: blankSlot.childrenRect.width > 0 || blankSlot.childrenRect.height > 0
    readonly property real blankContentWidth: {
        if (inlineMode)
            return Math.max(blankHeight, blankSlot.childrenRect.width)
        return blankSlot.implicitWidth
    }
    readonly property real blankContentHeight: {
        if (inlineMode && hasControlContent)
            return Math.max(blankHeight, blankSlot.childrenRect.height)
        return Math.max(blankHeight, blankSlot.childrenRect.height)
    }
    readonly property color feedbackColor: {
        if (root.status === "error")
            return theme.errorColor
        if (root.status === "warning")
            return theme.warningColor
        return theme.textColor3
    }

    implicitWidth: mergedLabelPlacement === "left"
        ? (effectiveLabelWidth + labelGap + blankContentWidth)
        : Math.max(labelBlock.implicitWidth, blankContentWidth)
    implicitHeight: layoutColumn.implicitHeight

    default property alias content: blankSlot.data

    Column {
        id: layoutColumn
        width: parent.width
        spacing: 0

        Item {
            id: topSection
            width: parent.width
            height: mergedLabelPlacement === "left"
                ? Math.max(labelBlock.height, blankSlot.height)
                : labelBlock.height + blankSlot.height

            Item {
                id: labelBlock
                visible: hasVisibleLabel
                width: mergedLabelPlacement === "left" ? effectiveLabelWidth : parent.width
                height: hasVisibleLabel
                    ? (mergedLabelPlacement === "left" ? blankHeight : labelHeight)
                    : 0
                x: 0
                y: 0

                Item {
                    anchors.fill: parent
                    anchors.leftMargin: mergedLabelPlacement === "top" ? theme.formLabelPaddingTopHorizontal : 0
                    anchors.rightMargin: mergedLabelPlacement === "left" ? theme.formLabelPaddingLeftRight : 0
                    anchors.bottomMargin: mergedLabelPlacement === "top" ? theme.formLabelPaddingTopBottom : 0

                    Row {
                        id: labelRow
                        spacing: 4
                        anchors.verticalCenter: mergedLabelPlacement === "left" ? parent.verticalCenter : undefined
                        anchors.top: mergedLabelPlacement === "top" ? parent.top : undefined
                        anchors.left: mergedLabelAlign === "left" ? parent.left : undefined
                        anchors.right: mergedLabelAlign === "right" ? parent.right : undefined
                        layoutDirection: mergedRequireMarkPlacement === "left" ? Qt.RightToLeft : Qt.LeftToRight

                        Text {
                            text: root.label
                            color: theme.textColor1
                            font.pixelSize: root.labelFontSize
                            font.family: theme.fontFamily
                            font.weight: 400
                            horizontalAlignment: mergedLabelAlign === "right" ? Text.AlignRight : Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            text: mergedShowRequireMark && root.required ? "*" : ""
                            visible: mergedShowRequireMark && root.required
                            color: theme.errorColor
                            font.pixelSize: root.labelFontSize
                            font.family: theme.fontFamily
                        }
                    }

                    Text {
                        visible: mergedShowRequireMark && root.required && mergedRequireMarkPlacement === "right-hanging"
                        text: "*"
                        color: theme.errorColor
                        font.pixelSize: root.labelFontSize
                        font.family: theme.fontFamily
                        anchors.left: labelRow.right
                        anchors.leftMargin: 2
                        anchors.top: labelRow.top
                    }
                }
            }

            Item {
                id: blankSlot
                width: inlineMode
                    ? blankContentWidth
                    : (mergedLabelPlacement === "left" ? parent.width - effectiveLabelWidth - labelGap : parent.width)
                implicitWidth: width
                height: blankContentHeight
                x: mergedLabelPlacement === "left" ? effectiveLabelWidth + labelGap : 0
                y: mergedLabelPlacement === "left" ? 0 : labelBlock.height
            }
        }

        Item {
            id: feedbackWrap
            width: parent.width
            height: {
                if (!mergedShowFeedback)
                    return 0
                if (inlineMode && !hasVisibleFeedback)
                    return 0
                return Math.max(feedbackHeight, feedbackText.implicitHeight + (mergedFeedbackText.length > 0 ? theme.formFeedbackPaddingTop : 0))
            }
            visible: mergedShowFeedback && (!inlineMode || hasVisibleFeedback)

            Text {
                id: feedbackText
                visible: hasVisibleFeedback
                x: mergedLabelPlacement === "left"
                    ? effectiveLabelWidth + labelGap + theme.formFeedbackPaddingLeft
                    : theme.formFeedbackPaddingLeft
                y: mergedFeedbackText.length > 0 ? theme.formFeedbackPaddingTop : 0
                width: parent.width - x
                text: mergedFeedbackText
                color: feedbackColor
                font.pixelSize: feedbackFontSize
                font.family: theme.fontFamily
                wrapMode: Text.Wrap
                opacity: visible ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }
        }
    }
}
