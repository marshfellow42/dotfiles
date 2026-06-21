import QtQuick
import qs.theme
pragma Singleton

QtObject {
    id: root

    property string locale: Layout.locale || "en"
    readonly property QtObject lang: {
        switch (locale) {
        case "pt":
            return Pt;
        default:
            return En;
        }
    }
}
