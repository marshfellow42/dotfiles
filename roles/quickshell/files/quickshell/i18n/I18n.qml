pragma Singleton
import QtQuick
import qs.theme

QtObject {
    id: root

    property string locale: Layout.locale || "en"

    readonly property QtObject lang: {
        switch (locale) {
            case "pt": return Pt
            default:   return En
        }
    }
}