import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.theme

Item {
    id: appLauncherList
    property real launcherWindowWidth
    property real launcherWindowHeight
    property string searchQuery

    readonly property var allDesktopApps: DesktopEntries.applications.values
    readonly property var nameSortedDesktopApps: allDesktopApps.sort((a, b) => {
        return a.name.localeCompare(b.name);
    })
    readonly property var filteredApps: nameSortedDesktopApps.filter((app) => {
        return app.name.toLowerCase().includes(searchQuery.toLowerCase());
    })

    onFilteredAppsChanged: appLauncherListView.currentIndex = filteredApps.length > 0 ? 0 : -1

    implicitWidth: launcherWindowWidth
    implicitHeight: launcherWindowHeight

    // --- called from AppsSearchBar's Keys.onPressed ---
    function selectNext() {
        if (filteredApps.length === 0) return;
        appLauncherListView.currentIndex = (appLauncherListView.currentIndex + 1) % filteredApps.length;
    }
    function selectPrevious() {
        if (filteredApps.length === 0) return;
        appLauncherListView.currentIndex =
            (appLauncherListView.currentIndex - 1 + filteredApps.length) % filteredApps.length;
    }
    function activateSelected() {
        if (appLauncherListView.currentIndex < 0) return;
        const app = filteredApps[appLauncherListView.currentIndex];
        if (app) {
            app.execute();
            launcherWindow.visible = false;
        }
    }
    // ---------------------------------------------------

    ListView {
        id: appLauncherListView
        anchors.fill: parent
        model: filteredApps
        spacing: 15
        currentIndex: -1
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 80

        delegate: Rectangle {
            id: appContainer
            implicitWidth: appLauncherList.implicitWidth
            implicitHeight: 70
            color: ListView.isCurrentItem ? WalColors.color12 : WalColors.color10
            border.color: ListView.isCurrentItem ? "pink" : "transparent"
            border.width: 3
            radius: 10

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 20
                spacing: 12

                IconImage {
                    id: appIcon
                    implicitSize: 24
                    anchors.verticalCenter: parent.verticalCenter
                    asynchronous: true
                    source: {
                        if (!modelData.icon || modelData.icon === "")
                            return "image://icon/application-x-executable";
                        if (modelData.icon.startsWith("/"))
                            return "file://" + modelData.icon;
                        return "image://icon/" + modelData.icon;
                    }
                    onStatusChanged: {
                        if (status === Image.Error)
                            source = "image://icon/application-x-executable";
                    }
                }

                Text {
                    id: appName
                    verticalAlignment: Text.AlignVCenter
                    height: appContainer.height
                    color: WalColors.foreground
                    text: modelData.name
                    font {
                        family: "Google Sans Medium"
                        pixelSize: 24
                    }
                }
            }

            HoverHandler {
                id: appContainerMouseArea
                cursorShape: Qt.PointingHandCursor
                onHoveredChanged: if (hovered) appLauncherListView.currentIndex = index
            }

            TapHandler {
                gesturePolicy: TapHandler.ReleaseWithinBounds
                onTapped: {
                    modelData.execute();
                    launcherWindow.visible = false;
                }
            }
        }
    }
}