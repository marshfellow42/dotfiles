import QtQuick
import qs.services
import qs.theme
import qs.bar.widgets.calendar

Item {
    id: root

    implicitWidth: visualPill.implicitWidth
    implicitHeight: visualPill.implicitHeight

    Rectangle {
        id: visualPill
        anchors.centerIn: parent

        implicitWidth: timeLabel.implicitWidth + 32
        implicitHeight: timeLabel.implicitHeight + 16
        radius: height / 2

        color: WalColors.background

        // Tamed: Only scales down slightly when physically clicked
        scale: pillMouse.pressed ? 0.95 : 1.0

        // Snappy, non-bouncy transitions
        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            id: pillMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: calendarWidget.visible = !calendarWidget.visible
        }

        Text {
            id: timeLabel
            anchors.centerIn: parent
            text: Time.time

            color: WalColors.foreground

            font {
                family: "Google Sans"
                pointSize: 14
                weight: Font.Medium
            }
        }
    }

    CalendarWidget {
        id: calendarWidget
        visible: false
    }
}
