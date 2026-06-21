import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "backend"
import "modules"
import qs.theme

PanelWindow {
    id: wallpaperWindow

    visible: false

    implicitWidth: Screen.desktopAvailableWidth
    implicitHeight: Screen.desktopAvailableHeight / 3
    
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "wallpaper_overlay"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    exclusiveZone: -1

    anchors {
        bottom: true
        left: true
        right: true
    }

    margins {
        bottom: 14
        left: 15
        right: 15
    }

    Rectangle {
        anchors.fill: parent
        color: WalColors.background
        radius: 12
    }

    WallpaperList {
        id: wallpaperList

        wallWindowWidth: wallpaperWindow.implicitWidth
        wallWindowHeight: wallpaperWindow.implicitHeight
    }

    IpcHandler {
        target: "wallpaperLauncher"

        function toggle() {
            wallpaperWindow.visible = !wallpaperWindow.visible;
        }
    }

    // Handler to escape the wallpaper pressing Esc
    Item {
        focus: true
        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape)
                wallpaperWindow.visible = !wallpaperWindow.visible;

        }
    }

}
