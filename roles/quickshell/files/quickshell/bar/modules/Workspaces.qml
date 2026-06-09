import QtQuick
import Quickshell.Hyprland
import qs.theme

/**
 * A pill-style workspace switcher
 */
Rectangle {
    id: root

    // --- Configuration ---
    property string targetMonitor: ""

    readonly property int animDurationShort: 150
    readonly property int animDurationLong: 200
    readonly property int dotHeight: 20
    readonly property int spacingAmount: 10

    // --- Styling ---
    implicitWidth: mainLayout.width + 30
    implicitHeight: mainLayout.height + 18
    color: Theme.surface_container
    radius: height / 2

    Row {
        id: mainLayout
        anchors.centerIn: parent
        spacing: root.spacingAmount

        Repeater {
            model: Hyprland.workspaces

            delegate: Rectangle {
                id: workspaceDot

                // Only show workspaces belonging to the assigned monitor
                visible: modelData.id >= 1 && modelData.monitor?.name === root.targetMonitor

                // Dynamic width based on workspace state
                width: {
                    if (!visible)
                        return 0;
                    if (modelData.focused || modelData.active)
                        return 40;
                    if (dotMouseArea.hovered)
                        return 32;
                    return 24;
                }

                height: root.dotHeight
                radius: height / 2

                // State-driven color selection
                color: {
                    if (modelData.focused)
                        return Theme.primary ?? "#ffffff";
                    return dotMouseArea.hovered ? "#666666" : "#4c4c4c";
                }

                // Smooth transitions for interaction states
                Behavior on width {
                    NumberAnimation {
                        duration: root.animDurationLong
                        easing.type: Easing.OutBack
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: root.animDurationShort
                    }
                }

                Text {
                    id: numberIndicator
                    text: modelData.id
                    anchors.centerIn: parent
                    
                    // Uses a contrasting color based on focus state
                    color: modelData.focused ? (Theme.on_primary ?? "#000000") : "#ffffff"
                    font.pixelSize: 11
                    font.bold: true

                    // Only show the number when the workspace is active, focused, or hovered
                    // opacity: (modelData.focused || modelData.active || dotMouseArea.hovered) ? 1.0 : 0.0

                    Behavior on opacity {
                        NumberAnimation { duration: root.animDurationShort }
                    }
                    Behavior on color {
                        ColorAnimation { duration: root.animDurationShort }
                    }
                }

                // Interaction Handlers
                TapHandler {
                    onTapped: modelData.activate()
                }

                HoverHandler {
                    id: dotMouseArea
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}
