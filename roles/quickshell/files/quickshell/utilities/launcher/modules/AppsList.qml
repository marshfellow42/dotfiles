import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.theme

Item {
    id: appLauncherList

    property real launcherWindowWidth
    property real launcherWindowHeight
    property string searchQuery

    implicitWidth: launcherWindowWidth
    implicitHeight: launcherWindowHeight

    readonly property var allDesktopApps: DesktopEntries.applications.values
    readonly property var nameSortedDesktopApps: allDesktopApps.sort((a, b) => a.name.localeCompare(b.name));
    readonly property var filteredApps: nameSortedDesktopApps.filter(app =>
        app.name.toLowerCase().includes(searchQuery.toLowerCase())
    )

    ListView {
        id: appLauncherListView
        anchors.fill: parent
        model: filteredApps
        spacing: 15

        delegate: Rectangle {
            id: appContainer
            implicitWidth: appLauncherList.implicitWidth
            implicitHeight: 70
            color: WalColors.color10
            border.color: "pink"
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
                        if (!modelData.icon || modelData.icon === "") {
                            return "image://icon/application-x-executable"
                        }
                        if (modelData.icon.startsWith("/")) {
                            return "file://" + modelData.icon
                        }
                        return "image://icon/" + modelData.icon
                    }
                    onStatusChanged: {
                        if (status === Image.Error)
                            source = "image://icon/application-x-executable"
                    }
                }

                Text {
                    id: appName
                    verticalAlignment: Text.AlignVCenter
                    height: appContainer.height
                    color: WalColors.foreground
                    font {
                        family: "Google Sans Medium"
                        pixelSize: 24
                    }
                    text: modelData.name
                }
            }

            HoverHandler {
                id: appContainerMouseArea
                cursorShape: Qt.PointingHandCursor
            }

            TapHandler {
                gesturePolicy: TapHandler.ReleaseWithinBounds
                onTapped: {
                    modelData.execute()
                    launcherWindow.visible = !launcherWindow.visible;
                }
            }
        }
    }
}