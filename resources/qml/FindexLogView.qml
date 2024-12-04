import QtQuick 2.0
import QtQuick.Controls 2.3

Component {
    ScrollView {
        id: logScrollView
        y: titleBar.height
        width: mainWindow.width
        height: mainWindow.height - titleBar.height - mainWindow.footer.height
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
}