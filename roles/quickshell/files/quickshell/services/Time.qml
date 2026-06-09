pragma Singleton

import Quickshell
import QtQuick

/** Global time provider for shell components. */
Singleton {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    readonly property string time: Qt.formatDateTime(clock.date, " h:mm:ss  •  dd/MM/yyyy ")
}
