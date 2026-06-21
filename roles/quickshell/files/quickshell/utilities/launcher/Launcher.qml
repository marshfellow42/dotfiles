import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "modules"
import qs.i18n
import qs.theme

PanelWindow {
    id: launcherWindow

    implicitWidth: 900
    implicitHeight: Screen.desktopAvailableHeight / 1.5
    color: "transparent"
    visible: false
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "launcher_overlay"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    exclusiveZone: -1
    onVisibleChanged: {
        if (visible)
            appsSearchBar.forceSearchFocus();

    }

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
            appsList: appsList   // forward declaration resolves fine in QML
        }
        AppsList {
            id: appsList
            launcherWindowWidth: launcherWindow.implicitWidth - 32
            launcherWindowHeight: launcherWindow.implicitHeight - appsSearchBar.appSearchBarHeight - 42
            searchQuery: appsSearchBar.searchText
        }

    }

    IpcHandler {
        function toggle() {
            launcherWindow.visible = !launcherWindow.visible;
        }

        target: "appLauncher"
    }

    Item {
        focus: true
        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape)
                launcherWindow.visible = !launcherWindow.visible;

        }
    }

}
