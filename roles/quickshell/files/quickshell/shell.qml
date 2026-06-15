//@ pragma IconTheme Papirus

import Quickshell
import QtQuick
import "bar"
import qs.utilities.clipboard
import qs.utilities.emoji
import qs.utilities.launcher
import qs.utilities.wallpaper
import qs.popups
import qs.services

/** Main shell entry point; manages surface orchestration. */
ShellRoot {
    id: root

    // System status bar
    TopBar {
        id: topBar
    }

    // Floating notification overlay
    NotifPopup {
        id: notificationOverlay
    }

    // Clipboard
    Clipboard {
        id: clipboardWindow
    }

    // Emoji Picker
    EmojiPicker {
        id: emojiPickerWindow
    }

    // Application Launcher
    Launcher {
        id: launcherWindow
    }

    Wallpaper {
        id: wallpaperWindow
    }

    VolumePopup {
        id: volumePopupWindow
    }

    BrightnessPopup {
        id: brightnessPopupWindow
    }
}
