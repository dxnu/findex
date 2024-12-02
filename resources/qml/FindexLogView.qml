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
            text: logFileMonitor.fileContent
            readOnly: true
            wrapMode: Text.Wrap
            font.pixelSize: 14
            padding: 10

            onTextChanged: Qt.callLater(logScrollView.scrollToBottom)
        }

        function scrollToBottom() {
            logScrollView.ScrollBar.vertical.position = 1.0 - logScrollView.ScrollBar.vertical.size
        }

        Component.onCompleted: logScrollView.scrollToBottom()
    }
}