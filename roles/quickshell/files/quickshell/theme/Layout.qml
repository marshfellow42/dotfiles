pragma Singleton
import QtQuick

QtObject {
    // ── General ──────────────────────────────
    // A nerd font is required
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property string backgroundColor: WalColors.background
    // The locale follows the ISO 639-1 language codes
    readonly property string locale: "en"
    readonly property int cornerShape: 2
    // ── Top Bar ───────────────────────────────
    readonly property int topBarHeight: 60
    readonly property int topBarBottomMargin: -15
}
