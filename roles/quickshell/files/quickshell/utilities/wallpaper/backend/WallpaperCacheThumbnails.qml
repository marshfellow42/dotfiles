import QtQuick
import Quickshell
import Quickshell.Io

Item {
    property string importFilePath
    property string importCacheFilePath

    FileView {
        id: cacheCheck
        path: importCacheFilePath
        preload: false
    }

    Process {
        id: magickCache
        command: ["magick", importFilePath, "-thumbnail", "640x360", importCacheFilePath]
        running: !cacheCheck.loaded
    }
}