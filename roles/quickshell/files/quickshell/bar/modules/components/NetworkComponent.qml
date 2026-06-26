import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking
import qs.theme

// --- Internet Module ---
Row {
    id: internetModule
    spacing: 8

    readonly property var currentWifiDevice: Networking.devices.values[0] ?? null
    readonly property bool hasNetwork: currentWifiDevice !== null && (currentWifiDevice.networks?.values?.length ?? 0) > 0
    readonly property bool isConnected: hasNetwork ? currentWifiDevice.connected : false
    readonly property string networkName: hasNetwork ? (currentWifiDevice.networks.values[0].name ?? "Disconnected") : "Disconnected"
    readonly property real networkConnectionStrength: hasNetwork ? currentWifiDevice.networks.values[0].signalStrength : 0
    readonly property int networkConnectionType: hasNetwork ? currentWifiDevice.type : -1
    readonly property string networkTypeString: hasNetwork ? DeviceType.toString(networkConnectionType) : ""

    Text {
        id: internetIcon
        anchors.verticalCenter: parent.verticalCenter
        font {
            family: Layout.fontFamily
            pixelSize: 16
        }
        color: parent.isConnected ? WalColors.color14 : WalColors.color11

        text: {
            if (parent.networkTypeString == "Wifi") {
                if (parent.networkConnectionStrength >= 0.8)
                    return " 󰤨";
                if (parent.networkConnectionStrength >= 0.6)
                    return " 󰤥";
                if (parent.networkConnectionStrength >= 0.4)
                    return " 󰤢";
                if (parent.networkConnectionStrength >= 0.2)
                    return " 󰤟";
                return " 󰤯";
            }
            if (parent.networkTypeString == "Wired") {
                return " 󰈀";
            }
            return "";
        }
    }

    Text {
        id: networkLabel
        anchors.verticalCenter: parent.verticalCenter
        color: WalColors.foreground
        font {
            family: "Google Sans Medium"
            pixelSize: 16
        }
        text: {
            if (networkMouseArea.hovered) {
                if (parent.networkTypeString == "Wifi") {
                    return parent.networkName;
                }
                if (parent.networkTypeString == "Wired") {
                    return "Wired";
                }
            }
            return "";
        }
    }

    HoverHandler {
        id: networkMouseArea
        cursorShape: Qt.PointingHandCursor
    }

    Process {
        id: wifiTui

        command: ["kitty", "--class", "impala-wifi", "-e", "impala"]
    }

    TapHandler {
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: wifiTui.running = true
    }
}