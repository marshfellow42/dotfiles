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
    implicitHeight: mainLayout.height + 22
    color: WalColors.background
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
                        return WalColors.color14
                    return dotMouseArea.hovered ? WalColors.color3 : WalColors.color2;
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
                    color: modelData.focused ? WalColors.background : WalColors.foreground
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
                    gesturePolicy: TapHandler.ReleaseWithinBounds
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
