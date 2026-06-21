import QtQuick
import qs.theme
import "components"

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

        NetworkComponent {
            id: networkComponent
        }

        // --- Separator ---
        Rectangle {
            width: 1
            height: 16
            color: Theme.outline_variant
            anchors.verticalCenter: parent.verticalCenter
        }

        VolumeComponent {
            id: volumeComponent
        }

        // --- Separator ---
        Rectangle {
            visible: batteryModule.isVisible
            width: 1
            height: 16
            color: Theme.outline_variant
            anchors.verticalCenter: parent.verticalCenter
        }

        BatteryComponent {
            id: batteryComponent
        }

    }

}
