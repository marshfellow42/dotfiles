pragma Singleton
import QtQuick
import Quickshell

//* Global time provider for shell components.
Singleton {
    id: root

    readonly property alias clock: clock
    readonly property string time: Qt.formatDateTime(clock.date, " hh:mm:ss  •  dd/MM/yyyy ")

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

}
