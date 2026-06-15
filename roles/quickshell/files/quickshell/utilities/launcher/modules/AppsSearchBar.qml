import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.theme

Item {
    id: appSearchBar
    property real appSearchBarWidth
    property real appSearchBarHeight
    property string searchText
    property var launcher

    implicitWidth: appSearchBarWidth
    implicitHeight: 60

    Rectangle {
        id: appContainer
        anchors.fill: parent
        border.color: searchInput.activeFocus ? WalColors.color14 : "pink"
        border.width: 3
        radius: 10

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            spacing: 10

            Text {
                id: appSearchBarIcon
                anchors.verticalCenter: parent.verticalCenter
                color: WalColors.color14
                font {
                    family: Layout.fontFamily
                    pixelSize: 24
                }
                text: ""
            }

            TextInput {
                id: searchInput
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - appSearchBarIcon.width - parent.spacing
                color: WalColors.foreground
                font {
                    family: "Google Sans Medium"
                    pixelSize: 24
                }
                clip: true
                onTextChanged: appSearchBar.searchText = text   // ← sync to property
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Escape) {
                        searchInput.text = ""
                        searchInput.focus = false
                        launcher.visible = !launcher.visible
                    }
                }
            }
        }

        // Placeholder text
        Text {
            anchors.left: appContainer.left
            anchors.leftMargin: 20 + appSearchBarIcon.width + 10
            anchors.verticalCenter: parent.verticalCenter
            text: "Search apps..."
            color: WalColors.foreground
            opacity: 0.4
            font {
                family: "Google Sans Medium"
                pixelSize: 24
            }
            visible: searchInput.text.length === 0 && !searchInput.activeFocus
        }
    }

    function forceSearchFocus() {
        searchInput.forceActiveFocus()
    }
}