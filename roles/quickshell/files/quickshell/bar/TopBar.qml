import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import "modules"
import qs.theme
import qs.services

Variants {
    id: root
    model: Quickshell.screens
    delegate: PanelWindow {
        id: mainBar
        required property var modelData
        screen: modelData

        // --- Layer Shell Configuration ---
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-topbar"

        // --- Fullscreen Detection Logic ---
        readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen)
        visible: !FullscreenState.isFullscreen(monitor)

        // --- Geometry & Positioning ---
        anchors {
            top: true
            left: true
            right: true
        }

        color: "transparent"
        implicitHeight: Layout.topBarHeight

        // --- Core Modules ---
        Workspaces {
            id: workspaceModule
            targetMonitor: modelData.name
            anchors {
                left: parent.left
                leftMargin: 15
                verticalCenter: parent.verticalCenter
            }
        }
        Row {
            id: rightModules
            
            anchors {
                right: parent.right
                rightMargin: 15
                verticalCenter: parent.verticalCenter
            }

            spacing: 10

            SystemStats {
                id: statusModule
            }

            Calendar {
                id: calendarModule
            }
        }
    }
}
