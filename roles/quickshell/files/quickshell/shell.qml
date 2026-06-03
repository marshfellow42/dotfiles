import QtQuick
import Quickshell
import "./modules/bar"

ShellRoot {
    id: root

    Loader {
        active: true
        source: "./modules/bar/Bar.qml"
    }
}