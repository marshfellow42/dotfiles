pragma Singleton
import QtQuick

QtObject {
    // ── Papéis de Parede ───────────────────────────────
    readonly property string wallSearchText: "Procurar papéis de parede..."

    // ── Lançador de Aplicativos ────────────────────────
    readonly property string appLauncherSearchText: "Procurar aplicativos..."

    // ── Brilho OSD ─────────────────────────────────────
    readonly property string lightOSDText: "Brilho"

    // ── Volume OSD ─────────────────────────────────────
    readonly property string volumeOSDText: "Volume"
}
