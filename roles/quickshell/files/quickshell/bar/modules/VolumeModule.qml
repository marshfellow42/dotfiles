import QtQuick
import Quickshell.Services.Pipewire
import qs.theme

// --- Audio Module ---
Row {
    id: volumeModule
    spacing: 8

    // --- Audio State Management ---
    readonly property var activeSink: Pipewire.defaultAudioSink
    readonly property bool isMuted: activeSink?.audio?.muted ?? true
    readonly property real volumeLevel: activeSink?.audio?.volume ?? 0.0

    // Ensures Pipewire sink stays reactive to external system changes.
    PwObjectTracker {
        objects: parent.activeSink ? [parent.activeSink] : []
    }

    Item {
        id: volumeModuleIconWrapper
        implicitWidth: 12
        implicitHeight: 12
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: volumeModuleIcon
            anchors.centerIn: parent
            font {
                family: Layout.fontFamily
                pixelSize: 16
            }
            color: volumeModule.isMuted ? WalColors.color11 : WalColors.color14

            text: {
                if (!volumeModule.activeSink?.audio)
                    return "󰸈"; // No device
                if (volumeModule.isMuted)
                    return "󰝟";
                if (volumeModule.volumeLevel >= 0.6)
                    return "󰕾"; // High
                if (volumeModule.volumeLevel >= 0.3)
                    return "󰖀"; // Mid
                return "󰕿";
            }
        }
    }

    Text {
        id: volumeLabel
        anchors.verticalCenter: parent.verticalCenter
        color: WalColors.foreground
        font {
            family: "Google Sans Medium"
            pixelSize: 17
        }
        text: parent.activeSink?.audio ? Math.round(parent.volumeLevel * 100) + "%" : "--%"
    }

    HoverHandler {
        id: audioMouseArea
        cursorShape: Qt.PointingHandCursor
    }

    // A handler to mute or unmute the volume with a mouse click
    TapHandler {
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: {
            if (parent.activeSink?.audio) {
                parent.activeSink.audio.muted = !parent.isMuted
            }
        }
    }

    // A handler to raise or lower the volume with the mouse scroll wheel
    WheelHandler {
        id: audioRotationArea
        rotationScale: 0.05
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: (event) => {
            if (!parent.activeSink?.audio) return;

            // Determine scroll direction (positive or negative steps)
            let step = event.angleDelta.y > 0 ? rotationScale : -rotationScale;
            
            // Calculate new volume bound between 0.0 and 1.0
            let newVolume = Math.min(1.0, Math.max(0.0, parent.volumeLevel + step));
            
            parent.activeSink.audio.volume = newVolume;
        }
    }
}