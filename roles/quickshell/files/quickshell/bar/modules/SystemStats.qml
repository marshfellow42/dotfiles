import QtQuick
import qs.theme

/**
 * A unified system status indicator for Internet, Audio (Pipewire) and Power (UPower).
 */
Rectangle {
    id: root

    // --- Layout Configuration ---
    implicitWidth: contentLayout.width + 30
    implicitHeight: contentLayout.height + 18
    color: WalColors.background
    radius: height / Layout.cornerShape

    Row {
        id: contentLayout
        anchors.centerIn: parent
        spacing: 16

        NetworkModule {
            id: networkModule
        }

        // --- Separator ---
        Rectangle {
            width: 1
            height: 16
            color: Theme.outline_variant
            anchors.verticalCenter: parent.verticalCenter
        }

        VolumeModule {
            id: volumeModule
        }

        // --- Separator ---
        Rectangle {
            visible: batteryModule.isVisible
            width: 1
            height: 16
            color: Theme.outline_variant
            anchors.verticalCenter: parent.verticalCenter
        }

        BatteryModule {
            id: batteryModule
        }
    }
}
