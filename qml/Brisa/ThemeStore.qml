pragma Singleton

import QtQuick

QtObject {
    id: root

    property string mode: "light"
    readonly property bool dark: mode === "dark"

    function toggle() {
        mode = dark ? "light" : "dark"
    }
}
