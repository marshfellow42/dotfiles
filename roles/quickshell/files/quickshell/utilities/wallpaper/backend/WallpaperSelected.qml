import QtQuick
import Quickshell
import Quickshell.Io

Item {
    property string wallFile

    onWallFileChanged: {
        let file = wallFile;
        awwwProc.command = ["awww", "img", "--transition-type", "center", "--transition-duration", "2", file];
        walProc.command = ["wal", "--cols16", "-n", "-s", "-t", "-i", file];
        awwwProc.startDetached();
        walProc.startDetached();
    }

    Process {
        id: awwwProc
    }

    Process {
        id: walProc
    }

    Process {
        id: hyprProc

        command: ["hyprctl", "reload"]
        running: true
    }

}
