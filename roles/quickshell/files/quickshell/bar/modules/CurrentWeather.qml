import QtQuick
import Quickshell
import Quickshell.Io
import qs.theme
import qs.services

Rectangle {
    id: root

    // --- Layout Configuration ---
    implicitWidth: contentLayout.width + 30
    implicitHeight: contentLayout.height + 20
    color: WalColors.background
    radius: height / 2

    Item {
        id: contentLayout
        anchors.centerIn: parent
        width: currentWeather.implicitWidth
        height: currentWeather.implicitHeight
    
        Process {
            id: currentWeatherAPI

            command: {
                if ((Time.clock.hours <= 5) || (Time.clock.hours >= 18)) {
                    return ["curl", "wttr.is/?format=%m+%t"]
                }
                return ["curl", "wttr.is/?format=%c+%t"]
            }
            stdout: StdioCollector {
                onStreamFinished: {
                    currentWeather.text = this.text.replace(/\+/, "").trim()
                }
            }
        }

        Timer {
            id: weatherTimer
            interval: 30 * 60 * 1000   // 30 minutes in ms
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: currentWeatherAPI.running = true
        }

        Text {
            id: currentWeather
            anchors.centerIn: parent
            color: WalColors.foreground
            font {
                family: "Google Sans Medium"
                pixelSize: 16
            }
            text: "No weather"
        }
    }
}