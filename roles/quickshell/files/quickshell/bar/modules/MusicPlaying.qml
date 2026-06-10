import QtQuick
import Quickshell.Services.Mpris
import Quickshell.Widgets
import qs.theme

Rectangle {
    id: root

    // --- Layout Configuration ---
    implicitWidth: contentLayout.width + 30
    implicitHeight: contentLayout.height + 18
    color: Theme.surface_container
    radius: height / 2

    // Only visible if there's a player available
    visible: Mpris.players.values.length > 0 

    Row {
        id: contentLayout
        anchors.centerIn: parent
        spacing: 16

        // --- Music Module ---
        Row {
            id: musicModule
            spacing: 8
        
            readonly property var currentMusicPlayer: Mpris.players.values[0]
            readonly property bool isPlayingMusic: currentMusicPlayer.isPlaying
            readonly property string trackTitle: currentMusicPlayer.trackTitle
            readonly property string trackArtUrl: currentMusicPlayer.trackArtUrl
            readonly property string trackAlbum: currentMusicPlayer.trackAlbum

            Item {
                id: playPauseWrapper
                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                
                Text {
                    id: musicPlayingLabel
                    anchors.centerIn: parent
                    color: Theme.on_surface
                    font {
                        family: "Google Sans Medium"
                        pixelSize: 16
                    }
                    text: {
                        if (musicModule.isPlayingMusic)
                            return "";
                        return "";
                    }
                }
            }

            IconImage {
                id: albumArt
                implicitSize: 24

                source: parent.trackArtUrl
                asynchronous: true
            }

            Item {
                id: textContainer
                width: 225 // Adjust this value to set the maximum width of your text area
                height: musicPlaying.height
                clip: true
                anchors.verticalCenter: parent.verticalCenter

                // Define your fixed speed here (pixels per second)
                readonly property real scrollSpeed: 20

                Text {
                    id: musicPlaying
                    color: Theme.on_surface
                    font {
                        family: "Google Sans Medium"
                        pixelSize: 16
                    }
                    text: `${musicModule.trackTitle} - ${musicModule.trackAlbum}`

                    onTextChanged: {
                        marqueeAnimation.stop();
                        x = 0;
                        if (musicPlaying.width > textContainer.width) {
                            marqueeAnimation.start();
                        }
                    }
                }

                SequentialAnimation {
                    id: marqueeAnimation
                    loops: Animation.Infinite
                    running: musicPlaying.width > textContainer.width

                    // Pause briefly at the start before scrolling
                    PauseAnimation { duration: 5000 }

                    // Scroll to the end of the text
                    NumberAnimation {
                        target: musicPlaying
                        property: "x"
                        to: textContainer.width - musicPlaying.width
                        duration: ((musicPlaying.width - textContainer.width) / textContainer.scrollSpeed) * 1000
                        easing.type: Easing.InOutQuad
                    }

                    // Pause briefly at the end before returning
                    PauseAnimation { duration: 5000 }

                    // Scroll back to the beginning
                    NumberAnimation {
                        target: musicPlaying
                        property: "x"
                        to: 0
                        duration: ((musicPlaying.width - textContainer.width) / textContainer.scrollSpeed) * 1000
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        TapHandler {
            onTapped: {
                const player = musicModule.currentMusicPlayer;
                
                // 1. Ensure the player exists
                // 2. Ensure the documentation's requirement 'canTogglePlaying' is true
                if (player && player.canTogglePlaying) {
                    
                    // Toggle the boolean state directly on the player
                    player.isPlaying = !player.isPlaying;
                }
            }
        }

        HoverHandler {
            id: musicMouseArea
            cursorShape: Qt.PointingHandCursor
        }
    }
}