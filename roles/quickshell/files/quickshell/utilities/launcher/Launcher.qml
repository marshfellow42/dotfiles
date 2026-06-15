import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.i18n
import "modules"

PanelWindow {
    id: launcherWindow

    implicitWidth: 900
    implicitHeight: Screen.desktopAvailableHeight / 1.5
    color: "transparent"
    visible: false

    anchors {
        bottom: true
    }

    margins {
        bottom: Screen.desktopAvailableHeight / 6
    }

    Rectangle {
        anchors.fill: parent
        color: WalColors.background
        radius: 12
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "launcher_overlay"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    exclusiveZone: -1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10

        AppsSearchBar {
            id: appsSearchBar
            z: 1
            appSearchBarWidth: launcherWindow.implicitWidth - 32
            appSearchBarHeight: 60
            launcher: launcherWindow
        }

        AppsList {
            id: appsList
            launcherWindowWidth: launcherWindow.implicitWidth - 32
            launcherWindowHeight: launcherWindow.implicitHeight - appsSearchBar.appSearchBarHeight - 42
            searchQuery: appsSearchBar.searchText
        }
    }

    onVisibleChanged: {
        if (visible) appsSearchBar.forceSearchFocus()
    }

    IpcHandler {
        target: "appLauncher"
        function toggle() {
            launcherWindow.visible = !launcherWindow.visible
        }
    }

    Item {
        focus: true

        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape) {
                launcherWindow.visible = !launcherWindow.visible;
            }
        }
    }
}
