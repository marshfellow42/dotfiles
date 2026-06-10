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

    readonly property bool isVisible: Mpris.players.values.length > 0 ? true : false

    visible: isVisible

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

            Text {
                id: musicPlayingLabel
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.on_surface
                font {
                    family: "Google Sans Medium"
                    pixelSize: 16
                }
                text: {
                    if (parent.isPlayingMusic)
                        return "";
                    return "";
                }
            }

            IconImage {
                id: albumArt
                
                implicitSize: 24

                source: parent.trackArtUrl
                asynchronous: true
            }

            Text {
                id: musicPlaying
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.on_surface
                font {
                    family: "Google Sans Medium"
                    pixelSize: 16
                }
                text: {      
                    var fullText = `${parent.trackTitle} - ${parent.trackAlbum}`

                    var maxChars = 31; 

                    // 3. Truncate if it exceeds the limit
                    if (fullText.length > maxChars) {
                        return fullText.substring(0, maxChars) + "...";
                    }
                    
                    return fullText;
                }
            }
        }
    }
}