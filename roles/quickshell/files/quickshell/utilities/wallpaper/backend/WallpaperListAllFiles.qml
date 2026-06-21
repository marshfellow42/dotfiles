import Qt.labs.folderlistmodel
import QtQuick
import Quickshell

Item {
    property alias wallModel: folderModel
    readonly property string homeDir: Quickshell.env("HOME")
    readonly property string picturesDir: Quickshell.env("XDG_PICTURES_DIR") || (homeDir + "/Pictures")
    readonly property string wallDir: picturesDir + "/Wallpapers"

    FolderListModel {
        id: folderModel

        folder: "file://" + wallDir
        showDirs: false
        caseSensitive: false
        nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp", "*.gif"]
    }

}
