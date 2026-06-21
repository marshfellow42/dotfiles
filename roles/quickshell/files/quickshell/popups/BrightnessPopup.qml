import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.i18n
import qs.theme

Variants {
    id: root

    model: Quickshell.screens

    delegate: PanelWindow {
        id: brightnessOsdPopup

        required property var modelData
        property real brightnessLevel: 0
        property bool isInitialized: false
        property bool showOsd: false

        function triggerOsd() {
            if (!isInitialized)
                return ;

            showOsd = true;
            hideTimer.restart();
        }

        screen: modelData
        implicitWidth: 380
        implicitHeight: 136
        color: "transparent"
        visible: showOsd
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "brightness_osd"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        onBrightnessLevelChanged: {
            triggerOsd();
        }

        anchors {
            bottom: true
        }

        margins {
            bottom: 70
        }

        Process {
            command: ["sh", "-c", "udevadm monitor --subsystem-match=backlight --udev"]
            running: true

            stdout: SplitParser {
                onRead: updateBrightness.running = true
            }

        }

        Process {
            id: updateBrightness

            command: ["sh", "-c", "brightnessctl -m"]
            running: true

            stdout: StdioCollector {
                onStreamFinished: {
                    let val = parseInt(this.text.split(",")[3].replace("%", ""));
                    if (!isNaN(val))
                        brightnessOsdPopup.brightnessLevel = val / 100;

                }
            }

        }

        Timer {
            id: initTimer

            interval: 1000
            running: true
            onTriggered: {
                brightnessOsdPopup.isInitialized = true;
            }
        }

        Timer {
            id: hideTimer

            interval: 2000
            onTriggered: {
                brightnessOsdPopup.showOsd = false;
            }
        }

        Item {
            anchors.fill: parent

            Rectangle {
                id: pill

                width: 250
                height: 78
                anchors.centerIn: parent
                radius: height / 2
                color: WalColors.background
                layer.enabled: true

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 22
                    anchors.rightMargin: 24
                    spacing: 16

                    Item {
                        id: brightnessIconWrapper

                        implicitWidth: 20
                        implicitHeight: 20
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: brightnessIcon

                            anchors.centerIn: parent
                            color: WalColors.color14
                            text: {
                                if (brightnessOsdPopup.brightnessLevel >= 0.7)
                                    return "󰃠";

                                if (brightnessOsdPopup.brightnessLevel >= 0.3)
                                    return "󰃟";

                                return "󰃞";
                            }

                            font {
                                family: Layout.fontFamily
                                pixelSize: 28
                            }

                        }

                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - brightnessIcon.width - parent.spacing - 6
                        spacing: 8

                        Item {
                            width: parent.width
                            height: brightnessLabel.implicitHeight

                            Text {
                                text: I18n.lang.lightOSDText
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                color: WalColors.foreground

                                font {
                                    family: "Google Sans Medium"
                                    pixelSize: 16
                                }

                            }

                            Text {
                                id: brightnessLabel

                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                color: WalColors.foreground
                                text: Math.round(brightnessOsdPopup.brightnessLevel * 100)

                                font {
                                    family: "Google Sans Medium"
                                    pixelSize: 16
                                }

                            }

                        }

                        Item {
                            readonly property real visualBrightness: Math.min(Math.max(brightnessOsdPopup.brightnessLevel, 0), 1)
                            readonly property int gap: 4

                            width: parent.width
                            height: 6

                            Rectangle {
                                id: activeTrack

                                x: 0
                                y: 0
                                height: parent.height
                                width: (parent.width - 4) * parent.visualBrightness
                                radius: height / 2
                                color: WalColors.color14

                                Behavior on width {
                                    SpringAnimation {
                                        spring: 11
                                        damping: 0.3
                                        mass: 1
                                    }

                                }

                            }

                            Item {
                                id: inactiveTrackContainer

                                x: activeTrack.width + parent.gap
                                y: 0
                                height: parent.height
                                width: Math.max(0, parent.width - activeTrack.width - parent.gap)
                                clip: true

                                Rectangle {
                                    anchors.right: parent.right
                                    height: parent.height
                                    width: Math.max(parent.width, height)
                                    radius: height / 2
                                    color: WalColors.color1

                                    Rectangle {
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.rightMargin: 1.5
                                        width: 5
                                        height: 5
                                        radius: 2.5
                                        color: WalColors.color14
                                    }

                                }

                            }

                        }

                    }

                }

                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowBlur: 1
                    shadowColor: "#40000000"
                    shadowVerticalOffset: 6
                }

            }

        }

    }

}
