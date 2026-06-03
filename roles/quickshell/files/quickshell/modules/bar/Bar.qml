import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.UPower

PanelWindow {
    id: panel

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 48

    margins {
        top: 4
        left: 4
        right: 4
    }

    Rectangle {
        id: bar
        anchors.fill: parent
        color: "#1a1a1a"
        radius: 0
        border.color: "#333333"
        border.width: 3

        Row {
            id: workspacesRow

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 16
            }

            spacing: 8

            Repeater {
                model: Hyprland.workspaces

                Rectangle {
                    width: 32
                    height: 24
                    radius: 4
                    color: modelData.active ? "#4a9eff" : "#333333"
                    border.color: "#555555"
                    border.width: 2

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + modelData.id + " })")
                    }

                    Text {
                        text: modelData.id
                        anchors.centerIn: parent
                        color: modelData.active ? "#ffffff" : "#cccccc"
                        font.pixelSize: 12
                        font.family: "Inter, sans-serif"
                    }
                }
            }

            Text {
                visible: Hyprland.workspaces.length === 0
                text: "No workspaces"
                color: "#ffffff"
                font.pixelSize: 12
            }
        }

        Row {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 16
            }

            spacing: 14

            Text {
                id: batteryDisplay
                
                text: UPower.displayDevice.isLaptopBattery 
                    ? Math.round(UPower.displayDevice.percentage * 100) + "%" 
                    : ""
                color: "#ffffff"
                font.pixelSize: 14
                font.family: "Inter, sans-serif"
                
                // 3. Aligns the battery text to the vertical center of the Row layout
                anchors.verticalCenter: parent.verticalCenter 
            }

            Canvas {
                id: batteryIcon
                width: 24
                height: 14
                anchors.verticalCenter: parent.verticalCenter

                property real percentage: UPower.displayDevice.isLaptopBattery ? UPower.displayDevice.percentage : 0.0

                onPercentageChanged: requestPaint()

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();

                    // Style configuration
                    ctx.strokeStyle = "#ffffff";
                    ctx.fillStyle = "#ffffff";
                    ctx.lineWidth = 1.5;

                    // Dimensions
                    var tipWidth = 2;
                    var tipHeight = 5;
                    var bodyX = tipWidth; // Shift body right to leave room for the left tip
                    var bodyWidth = width - tipWidth;
                    var bodyHeight = height;

                    // 1. Draw the battery tip on the left side
                    var tipX = 0;
                    var tipY = (bodyHeight - tipHeight) / 2;
                    ctx.fillRect(tipX, tipY, tipWidth, tipHeight);

                    // 2. Draw the main outer frame (Battery body shifted right)
                    ctx.strokeRect(bodyX + 0.75, 0.75, bodyWidth - 1.5, bodyHeight - 1.5);

                    // 3. Draw the inner dynamic fluid fill (Drains/fills from right to left)
                    var maxFillWidth = bodyWidth - 5; // Interior padding width
                    var fillWidth = maxFillWidth * percentage;
                    var fillHeight = bodyHeight - 5;
                    
                    // Calculate X starting point from the right edge so it empties leftward
                    var fillX = (bodyX + bodyWidth - 2.5) - fillWidth; 
                    var fillY = 2.5;

                    if (fillWidth > 0) {
                        ctx.fillRect(fillX, fillY, fillWidth, fillHeight);
                    }
                }
            }

            Text {
                id: timeDisplay

                SystemClock {
                    id: clock
                    precision: SystemClock.Seconds
                }

                text: Qt.formatDateTime(clock.date, "hh:mm:ss\ndd/MM/yyyy")
                color: "#ffffff"
                font.pixelSize: 14
                font.family: "Inter, sans-serif"

                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}