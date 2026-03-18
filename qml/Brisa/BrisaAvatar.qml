import QtQuick
import QtQuick.Effects

Item {
    id: root

    property var size: "medium" // small | medium | large | number
    property bool round: false
    property bool bordered: false
    property int borderWidth: 1
    property color borderColor: theme.baseColor
    property string src: ""
    property string fallbackSrc: ""
    property string objectFit: "fill" // fill | contain | cover | none | scale-down
    property string alt: ""
    property string text: ""
    property string name: ""
    property color color: fallbackPaletteColor()
    property color textColor: "#ffffff"
    property Component icon: fallbackIconComponent
    property Component placeholder: null
    property Component fallback: null

    property bool loadFailed: false
    property bool usingFallbackSrc: false

    readonly property int resolvedSize: {
        if (typeof size === "number")
            return Math.max(18, Number(size))
        switch (String(size)) {
        case "small":
            return 28
        case "large":
            return 40
        default:
            return 34
        }
    }
    readonly property real radius: round ? resolvedSize / 2 : theme.borderRadius
    readonly property string fallbackText: derivedText()
    readonly property int iconSize: Math.max(14, resolvedSize - 6)
    readonly property string currentImageSource: usingFallbackSrc ? fallbackSrc : src
    readonly property bool imageReady: currentImageSource.length > 0 && avatarImage.status === Image.Ready
    readonly property bool showPlaceholder: currentImageSource.length > 0
        && avatarImage.status === Image.Loading
        && !loadFailed
    readonly property real textScale: {
        if (fallbackTextNode.implicitWidth <= 0 || fallbackTextNode.implicitHeight <= 0)
            return 1
        var available = resolvedSize * 0.9
        return Math.min(
            available / fallbackTextNode.implicitWidth,
            available / fallbackTextNode.implicitHeight,
            1
        )
    }

    implicitWidth: resolvedSize
    implicitHeight: resolvedSize
    width: implicitWidth
    height: implicitHeight

    signal error(string source)

    Theme {
        id: theme
    }

    function initialsFrom(value) {
        var trimmed = String(value || "").trim()
        if (trimmed.length === 0)
            return ""
        var parts = trimmed.split(/\s+/)
        if (parts.length === 1)
            return parts[0]
        return (parts[0].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase()
    }

    function derivedText() {
        var explicitText = String(root.text || "").trim()
        if (explicitText.length > 0)
            return explicitText
        return initialsFrom(root.name || root.alt || "")
    }

    function fallbackPaletteColor() {
        var seed = String(root.name || root.text || root.alt || "avatar")
        var palette = [
            "#cfd3da",
            "#d7e3f4",
            "#dfebd7",
            "#f0e0c5",
            "#ead8de",
            "#d8e6e7"
        ]
        var acc = 0
        for (var i = 0; i < seed.length; ++i)
            acc = (acc + seed.charCodeAt(i) * (i + 3)) % palette.length
        return palette[acc]
    }

    function fillModeForObjectFit() {
        switch (root.objectFit) {
        case "contain":
            return Image.PreserveAspectFit
        case "cover":
            return Image.PreserveAspectCrop
        case "none":
            return Image.Pad
        case "scale-down":
            return Image.PreserveAspectFit
        default:
            return Image.Stretch
        }
    }

    onSrcChanged: {
        loadFailed = false
        usingFallbackSrc = false
    }

    onFallbackSrcChanged: {
        if (!src.length) {
            loadFailed = false
            usingFallbackSrc = false
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root.color
        border.width: root.bordered ? root.borderWidth : 0
        border.color: root.bordered ? root.borderColor : "transparent"
        antialiasing: true
    }

    Item {
        id: maskSource
        anchors.fill: parent
        visible: false

        Rectangle {
            anchors.fill: parent
            radius: root.radius
            color: "#ffffff"
            antialiasing: true
        }
    }

    Image {
        id: avatarImage
        anchors.fill: parent
        source: root.currentImageSource
        fillMode: root.fillModeForObjectFit()
        asynchronous: true
        cache: true
        visible: false
        sourceSize.width: root.resolvedSize * 2
        sourceSize.height: root.resolvedSize * 2

        onStatusChanged: {
            if (status === Image.Error) {
                if (!root.usingFallbackSrc && root.fallbackSrc.length > 0) {
                    root.usingFallbackSrc = true
                    return
                }
                root.loadFailed = true
                root.error(root.currentImageSource)
            } else if (status === Image.Ready) {
                root.loadFailed = false
            }
        }
    }

    MultiEffect {
        anchors.fill: parent
        source: avatarImage
        visible: root.imageReady
        autoPaddingEnabled: false
        maskEnabled: true
        maskSource: maskSource
    }

    Item {
        anchors.fill: parent
        visible: !root.imageReady

        Loader {
            anchors.fill: parent
            active: root.showPlaceholder && root.placeholder !== null
            visible: active
            sourceComponent: root.placeholder
        }

        Loader {
            anchors.fill: parent
            active: root.loadFailed && root.fallback !== null
            visible: active
            sourceComponent: root.fallback
        }

        Text {
            id: fallbackTextNode
            visible: root.fallbackText.length > 0
                && !root.showPlaceholder
                && !(root.loadFailed && root.fallback !== null)
            anchors.left: parent.left
            anchors.top: parent.top
            opacity: 0
            text: root.fallbackText
            color: root.textColor
            font.family: theme.fontFamily
            font.pixelSize: Math.max(12, Math.round(root.resolvedSize * 0.5))
            font.weight: Font.Normal
            wrapMode: Text.NoWrap
        }

        Text {
            visible: root.fallbackText.length > 0
                && !root.showPlaceholder
                && !(root.loadFailed && root.fallback !== null)
            anchors.centerIn: parent
            text: root.fallbackText
            color: root.textColor
            font.family: theme.fontFamily
            font.pixelSize: fallbackTextNode.font.pixelSize
            font.weight: fallbackTextNode.font.weight
            wrapMode: Text.NoWrap
            transformOrigin: Item.Center
            scale: root.textScale
        }

        Loader {
            visible: root.fallbackText.length === 0
                && !root.showPlaceholder
                && !(root.loadFailed && root.fallback !== null)
            anchors.centerIn: parent
            width: root.iconSize
            height: root.iconSize
            sourceComponent: root.icon

            onLoaded: {
                if (!item)
                    return
                if (item.hasOwnProperty("iconColor"))
                    item.iconColor = root.textColor
                if (item.hasOwnProperty("width"))
                    item.width = width
                if (item.hasOwnProperty("height"))
                    item.height = height
            }
        }
    }

    Component {
        id: fallbackIconComponent

        Item {
            property color iconColor: root.textColor

            Canvas {
                id: iconCanvas
                anchors.fill: parent
                antialiasing: true
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    var w = width
                    var h = height
                    var stroke = Math.max(1.5, Math.min(w, h) * 0.1)
                    ctx.strokeStyle = iconColor
                    ctx.lineWidth = stroke
                    ctx.lineCap = "round"
                    ctx.lineJoin = "round"
                    ctx.beginPath()
                    ctx.arc(w * 0.5, h * 0.34, Math.min(w, h) * 0.16, 0, Math.PI * 2)
                    ctx.stroke()
                    ctx.beginPath()
                    ctx.arc(w * 0.5, h * 0.8, Math.min(w, h) * 0.34, Math.PI, 0, false)
                    ctx.stroke()
                }
            }

            onIconColorChanged: iconCanvas.requestPaint()
        }
    }
}
