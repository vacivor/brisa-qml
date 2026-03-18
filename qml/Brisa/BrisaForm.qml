import QtQuick

Item {
    id: root

    property bool inline: false
    property var labelWidth: undefined
    property string labelAlign: ""
    property string labelPlacement: "top" // top | left
    property bool disabled: false
    property string size: "medium" // small | medium | large
    property var showRequireMark: undefined
    property string requireMarkPlacement: "right" // left | right | right-hanging
    property bool showFeedback: true
    property var showLabel: undefined
    property int itemSpacing: inline ? theme.formInlineItemGap : 14

    readonly property bool brisaForm: true
    property real autoLabelWidth: 0

    Theme { id: theme }

    implicitWidth: formFlow.implicitWidth
    implicitHeight: formFlow.implicitHeight

    Flow {
        id: formFlow
        anchors.fill: parent
        spacing: root.itemSpacing
    }

    default property alias content: formFlow.data

    function refreshChildren() {
        var maxLabel = 0
        for (var i = 0; i < formFlow.children.length; ++i) {
            var child = formFlow.children[i]
            if (!child)
                continue
            if (child.hasOwnProperty("form")) child.form = root
            if (child.hasOwnProperty("labelPlacement") && !child._brisaOwnLabelPlacement)
                child.labelPlacement = root.labelPlacement
            if (child.hasOwnProperty("labelAlign") && !child._brisaOwnLabelAlign)
                child.labelAlign = root.labelAlign
            if (child.hasOwnProperty("labelWidth") && !child._brisaOwnLabelWidth)
                child.labelWidth = root.labelWidth
            if (child.hasOwnProperty("size") && !child._brisaOwnSize)
                child.size = root.size
            if (child.hasOwnProperty("showRequireMark") && !child._brisaOwnShowRequireMark)
                child.showRequireMark = root.showRequireMark
            if (child.hasOwnProperty("requireMarkPlacement") && !child._brisaOwnRequireMarkPlacement)
                child.requireMarkPlacement = root.requireMarkPlacement
            if (child.hasOwnProperty("showFeedback") && !child._brisaOwnShowFeedback)
                child.showFeedback = root.showFeedback
            if (child.hasOwnProperty("showLabel") && !child._brisaOwnShowLabel)
                child.showLabel = root.showLabel
            if (child.hasOwnProperty("disabled") && !child._brisaOwnDisabled)
                child.disabled = root.disabled
            if (child.hasOwnProperty("width")) {
                if (root.inline && child.forceFullWidth !== true)
                    child.width = child.implicitWidth
                else
                    child.width = formFlow.width
            }
            if (child.hasOwnProperty("labelMeasureWidth"))
                maxLabel = Math.max(maxLabel, child.labelMeasureWidth)
        }
        root.autoLabelWidth = maxLabel
    }

    onWidthChanged: refreshChildren()
    onInlineChanged: refreshChildren()
    onLabelWidthChanged: refreshChildren()
    onLabelPlacementChanged: refreshChildren()
    onLabelAlignChanged: refreshChildren()
    onSizeChanged: refreshChildren()
    onShowRequireMarkChanged: refreshChildren()
    onRequireMarkPlacementChanged: refreshChildren()
    onShowFeedbackChanged: refreshChildren()
    onShowLabelChanged: refreshChildren()
    onDisabledChanged: refreshChildren()
    Connections {
        target: formFlow
        function onChildrenChanged() { root.refreshChildren() }
    }
    Component.onCompleted: refreshChildren()
}
