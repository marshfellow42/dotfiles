import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Mpris
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

        // This margin is important so that the gap between the window and the bar isn't too big
        margins {
            bottom: Layout.topBarBottomMargin
        }

        // --- Core Modules ---
        Row {
            id: leftModules
            
            anchors {
                left: parent.left
                leftMargin: 15
                verticalCenter: parent.verticalCenter
            }

            spacing: 10

            Workspaces {
                id: workspaceModule
                targetMonitor: modelData.name
            }

            MusicPlaying {
                id: musicModule
            }
        }

        Row {
            id: centerModules
            
            anchors {
                centerIn: parent
            }

            spacing: 10
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
