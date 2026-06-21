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
    property var appsList   // <-- new: reference to the AppsList instance

    function forceSearchFocus() {
        searchInput.text = "";
        searchInput.forceActiveFocus();
    }

    implicitWidth: appSearchBarWidth
    implicitHeight: appSearchBarHeight

    Rectangle {
        id: appContainer
        anchors.fill: parent
        color: WalColors.color5
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
                text: ""
                font {
                    family: Layout.fontFamily
                    pixelSize: 24
                }
            }

            TextInput {
                id: searchInput
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - appSearchBarIcon.width - parent.spacing
                color: WalColors.foreground
                clip: true
                onTextChanged: appSearchBar.searchText = text

                Keys.onPressed: (event) => {
                    switch (event.key) {
                    case Qt.Key_Escape:
                        searchInput.focus = false;
                        launcher.visible = false;
                        event.accepted = true;
                        break;
                    case Qt.Key_Down:
                        if (appsList) appsList.selectNext();
                        event.accepted = true;
                        break;
                    case Qt.Key_Up:
                        if (appsList) appsList.selectPrevious();
                        event.accepted = true;
                        break;
                    case Qt.Key_Return:
                    case Qt.Key_Enter:
                        if (appsList) appsList.activateSelected();
                        event.accepted = true;
                        break;
                    }
                }

                font {
                    family: "Google Sans Medium"
                    pixelSize: 24
                }
            }
        }

        Text {
            anchors.left: appContainer.left
            anchors.leftMargin: 20 + appSearchBarIcon.width + 10
            anchors.verticalCenter: parent.verticalCenter
            text: "Search apps..."
            color: WalColors.foreground
            opacity: 0.4
            visible: searchInput.text.length === 0 && !searchInput.activeFocus
            font {
                family: "Google Sans Medium"
                pixelSize: 24
            }
        }
    }
}