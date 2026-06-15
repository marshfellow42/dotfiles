import QtQuick
import Quickshell
import Quickshell.Io

Item {
    property string wallFile

    onWallFileChanged: {
        let file = wallFile
        
        awwwProc.command = ["awww", "img", file, "--transition-type", "grow", "--transition-pos", "0.5,0.5", "--transition-duration", "0.8"]
        walProc.command = ["wal", "--cols16", "-i", file]
        
        awwwProc.startDetached()
        walProc.startDetached()
    }

    Process {
        id: awwwProc
    }

    Process {
        id: walProc
        onExited: (code, status) => {
            if (code === 0) hyprProc.start()
        }
    }

    Process {
        id: hyprProc
        command: ["hyprctl", "reload"]
        running: true
    }
}