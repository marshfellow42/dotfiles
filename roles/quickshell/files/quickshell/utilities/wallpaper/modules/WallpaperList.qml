import QtQuick
import Quickshell
import "../backend"
import qs.theme

Item {
    id: wallpaperList

    property real wallWindowWidth
    property real wallWindowHeight

    implicitWidth: wallWindowWidth
    implicitHeight: wallWindowHeight

    property string selectedFile

    WallpaperListAllFiles {
        id: wallpaperListAllFiles
    }

    GridView {
        id: grid

        anchors {
            fill: parent
            topMargin: wallpaperList.implicitHeight / 5.5
            leftMargin: 20
            rightMargin: 20
        }
        
        model: wallpaperListAllFiles.wallModel
        cellWidth: 320
        cellHeight: 180
        clip: true

        delegate: Rectangle {
            readonly property string cacheDir: Quickshell.env("XDG_CACHE_HOME") || (homeDir + "/.cache")
            readonly property string cacheFilePath: cacheDir + "/quickshell/thumbs/" + model.fileBaseName + ".jpg"

            WallpaperCacheThumbnails {
                id: wallpaperCacheThumbnails
                importFilePath: model.filePath
                importCacheFilePath: cacheFilePath
            }
        
            width: grid.cellWidth - 10
            height: grid.cellHeight - 10
            border.color: wallpaperMouseArea.hovered ? "cyan" : "transparent"
            border.width: 3
            radius: 10

            Behavior on border.color {
                ColorAnimation { duration: 150 }
            }

            Image {
                anchors.fill: parent
                source: "file://" + cacheFilePath
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                onStatusChanged: {
                    if (status === Image.Error) {
                        source = model.fileUrl
                    }
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
        }
    }

    WallpaperSelected {
        id: wallpaperSelected
        wallFile: wallpaperList.selectedFile
    }
}