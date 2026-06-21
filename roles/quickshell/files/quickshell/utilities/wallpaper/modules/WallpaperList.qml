import "../backend"
import QtQuick
import Quickshell
import qs.theme

Item {
    id: wallpaperList

    property real wallWindowWidth
    property real wallWindowHeight
    property string selectedFile

    implicitWidth: wallWindowWidth
    implicitHeight: wallWindowHeight

    WallpaperListAllFiles {
        id: wallpaperListAllFiles
    }

    ListView {
        id: grid
        model: wallpaperListAllFiles.wallModel
        orientation: ListView.Horizontal
        spacing: 10
        clip: true
        anchors {
            fill: parent
            topMargin: wallpaperList.implicitHeight / 6
            leftMargin: 20
            rightMargin: 50
        }
        delegate: Rectangle {
            readonly property string cacheDir: Quickshell.env("XDG_CACHE_HOME") || (homeDir + "/.cache")
            readonly property string cacheFilePath: cacheDir + "/quickshell/thumbs/" + model.fileBaseName + ".jpg"
            width: 310
            height: 170
            border.color: wallpaperMouseArea.hovered ? "cyan" : "transparent"
            border.width: 3
            radius: 10
            WallpaperCacheThumbnails {
                id: wallpaperCacheThumbnails
                importFilePath: model.filePath
                importCacheFilePath: cacheFilePath
            }
            Image {
                anchors.fill: parent
                source: "file://" + cacheFilePath
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                onStatusChanged: {
                    if (status === Image.Error)
                        source = model.fileUrl;
                }
            }
            HoverHandler {
                id: wallpaperMouseArea
                cursorShape: Qt.PointingHandCursor
            }
            TapHandler {
                gesturePolicy: TapHandler.ReleaseWithinBounds
                onTapped: wallpaperList.selectedFile = model.filePath
            }
            Behavior on border.color {
                ColorAnimation { duration: 150 }
            }
        }
    }

    WallpaperSelected {
        id: wallpaperSelected

        wallFile: wallpaperList.selectedFile
    }

}
