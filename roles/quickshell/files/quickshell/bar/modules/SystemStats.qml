import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import Quickshell.Networking
import qs.theme

/**
 * A unified system status indicator for Audio (Pipewire) and Power (UPower).
 */
Rectangle {
    id: root

    // --- Layout Configuration ---
    implicitWidth: contentLayout.width + 30
    implicitHeight: contentLayout.height + 18
    color: Theme.surface_container
    radius: height / 2

    // --- Audio State Management ---
    readonly property var activeSink: Pipewire.defaultAudioSink
    readonly property bool isMuted: activeSink?.audio?.muted ?? true
    readonly property real volumeLevel: activeSink?.audio?.volume ?? 0.0

    /** Ensures Pipewire sink stays reactive to external system changes. */
    PwObjectTracker {
        objects: root.activeSink ? [root.activeSink] : []
    }

    Row {
        id: contentLayout
        anchors.centerIn: parent
        spacing: 16

        // --- Internet Module ---
        Row {
            id: internetModule
            spacing: 8

            readonly property var currentWifiDevice: Networking.devices.values[0]
            readonly property bool isConnected: currentWifiDevice.connected
            readonly property string networkName: currentWifiDevice.networks.values[0].name ?? "Disconnected"
            readonly property int networkConnectionState: currentWifiDevice.networks.values[0].state
            readonly property int networkConnectionType: currentWifiDevice.type
            readonly property string networkTypeString: DeviceType.toString(networkConnectionType)

            Text {
                id: internetIcon
                anchors.verticalCenter: parent.verticalCenter
                font {
                    family: "JetBrainsMono Nerd Font"
                    pixelSize: 16
                }
                color: parent.isConnected ? Theme.primary : Theme.critical

                text: {
                    if (parent.networkTypeString == "Wifi") {
                        if (parent.networkConnectionState == 4)
                            return "󰤨";
                        if (parent.networkConnectionState == 3)
                            return "󰤥";
                        if (parent.networkConnectionState == 2)
                            return "󰤢";
                        if (parent.networkConnectionState == 1)
                            return "󰤟";
                        return "󰤯";
                    }
                    if (parent.networkTypeString == "Wired") {
                        return "󰈀";
                    }
                }
            }

            Text {
                id: networkLabel
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.on_surface
                font {
                    family: "Google Sans Medium"
                    pixelSize: 16
                }
                text: {
                    if (parent.networkTypeString == "Wifi") {
                        return parent.networkName;
                    }
                    if (parent.networkTypeString == "Wired") {
                        return "Wired";
                    }
                }
            }
        }

        // --- Separator ---
        Rectangle {
            width: 1
            height: 16
            color: Theme.outline_variant
            anchors.verticalCenter: parent.verticalCenter
        }

        // --- Audio Module ---
        Row {
            id: volumeModule
            spacing: 8

            Text {
                id: volumeIcon
                anchors.verticalCenter: parent.verticalCenter
                font {
                    family: "JetBrainsMono Nerd Font"
                    pixelSize: 16
                }
                color: root.isMuted ? Theme.critical : Theme.primary

                text: {
                    if (!root.activeSink?.audio)
                        return ""; // No device
                    if (root.isMuted)
                        return "";
                    if (root.volumeLevel >= 0.6)
                        return ""; // High
                    if (root.volumeLevel >= 0.3)
                        return ""; // Mid
                    return "";
                }
            }

            Text {
                id: volumeLabel
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.on_surface
                font {
                    family: "Google Sans Medium"
                    pixelSize: 16
                }
                text: root.activeSink?.audio ? Math.round(root.volumeLevel * 100) + "%" : "--%"
            }

            TapHandler {
                onTapped: if (root.activeSink?.audio)
                    root.activeSink.audio.muted = !root.isMuted
                cursorShape: Qt.PointingHandCursor
            }
        }

        // --- Separator ---
        Rectangle {
            visible: batteryModule.isVisible
            width: 1
            height: 16
            color: Theme.outline_variant
            anchors.verticalCenter: parent.verticalCenter
        }

        // --- Battery Module ---
        Row {
            id: batteryModule
            spacing: 8

            // Internal logic to keep UI bindings clean
            readonly property bool isVisible: UPower.displayDevice?.isPresent ?? false
            readonly property real capacity: (UPower.displayDevice?.percentage ?? 0) * 100
            readonly property bool isCharging: !UPower.onBattery

            visible: isVisible

            Text {
                id: batteryIcon
                anchors.verticalCenter: parent.verticalCenter
                font {
                    family: "JetBrainsMono Nerd Font"
                    pixelSize: 16
                }

                // Color logic: Alert user if charging (active state) or critically low
                color: (batteryModule.isCharging && batteryModule.capacity < 100) || batteryModule.capacity <= 20 ? Theme.critical : Theme.primary

                text: {
                    if (batteryModule.isCharging && batteryModule.capacity < 100)
                        return "";

                    // Capacity breakpoints
                    if (batteryModule.capacity == 100)
                        return "󰁹";
                    if (batteryModule.capacity >= 90)
                        return "󰂂";
                    if (batteryModule.capacity >= 80)
                        return "󰂁";
                    if (batteryModule.capacity >= 70)
                        return "󰂀";
                    if (batteryModule.capacity >= 60)
                        return "󰁿";
                    if (batteryModule.capacity >= 50)
                        return "󰁾";
                    if (batteryModule.capacity >= 40)
                        return "󰁽";
                    if (batteryModule.capacity >= 30)
                        return "󰁼";
                    if (batteryModule.capacity >= 20)
                        return "󰁻";
                    if (batteryModule.capacity >= 10)
                        return "󰁺";
                    return "󰂃";
                }
            }

            Text {
                id: batteryLabel
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.on_surface
                font {
                    family: "Google Sans Medium"
                    pixelSize: 16
                }
                text: Math.round(batteryModule.capacity) + "%"
            }
        }
    }
}
