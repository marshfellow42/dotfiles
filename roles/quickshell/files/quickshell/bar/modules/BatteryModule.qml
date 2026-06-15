import QtQuick
import Quickshell.Services.UPower
import qs.theme

// --- Battery Module ---
Row {
    id: batteryModule
    spacing: 8

    // Internal logic to keep UI bindings clean
    readonly property bool isVisible: UPower.displayDevice?.isPresent ?? false
    readonly property real capacity: (UPower.displayDevice?.percentage ?? 0) * 100
    readonly property bool isCharging: !UPower.onBattery

    visible: isVisible

    Item {
        id: batteryIconWrapper
        implicitWidth: 12
        implicitHeight: 12
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: batteryIcon
            anchors.verticalCenter: parent.verticalCenter
            font {
                family: Layout.fontFamily
                pixelSize: 16
            }

            color: batteryModule.capacity <= 20 ? WalColors.color11 : WalColors.color14

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
    }

    Text {
        id: batteryLabel
        anchors.verticalCenter: parent.verticalCenter
        color: WalColors.foreground
        font {
            family: "Google Sans Medium"
            pixelSize: 16
        }
        text: Math.round(batteryModule.capacity) + "% "
    }
}