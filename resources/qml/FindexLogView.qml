import QtQuick 2.0
import QtQuick.Controls 2.3

ScrollView {
    id: logScrollView
    y: searchBar.height + 10
    width: mainWindow.width
    height: mainWindow.height - searchBar.height - mainWindow.menuBar.height - mainWindow.footer.height - 10
    clip: true
    TextArea {
        id: logTextArea
        text: logFileMonitor.fileContent
        readOnly: true
        wrapMode: TextEdit.NoWrap
        selectByMouse: true
        font.pixelSize: 14
        padding: 10

        onTextChanged: Qt.callLater(logScrollView.scrollToBottom)

        Menu {
            id: logContextMenu
            MenuItem {
                text: "Copy"
                onTriggered: {
                    logTextArea.selectAll()
                    logTextArea.copy()
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            onPressed: {
                if (mouse.button === Qt.RightButton) {
                    logContextMenu.popup()
                }
            }
        }
    }

    function scrollToBottom() {
        logScrollView.ScrollBar.vertical.position = 1.0 - logScrollView.ScrollBar.vertical.size
    }

    Component.onCompleted: logScrollView.scrollToBottom()
}