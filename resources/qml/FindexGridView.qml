import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts 1.0
import com.search.model 1.0
import "qrc:findex/js/file-style.js" as FileStyle
import "qrc:findex/js/utils.js" as Utils

GridView {
    id: fileGridView
    y: searchBar.height + 10
    width: mainWindow.width
    height: mainWindow.height - searchBar.height - mainWindow.menuBar.height - mainWindow.footer.height - 10
    clip: true
    model: searchController.model()
    cellWidth: 100
    cellHeight: 120
    TapHandler { // 点击空白区域的事件，取消选中，当前版本太低不支持（>6.2）
        onTapped: {
            fileGridView.currentIndex = -1
        }
    }

    delegate: Item {
        width: fileGridView.cellWidth
        height: fileGridView.cellHeight

        Column {
            id: gridViewColumn
            anchors.fill: parent
            anchors.centerIn: parent
            spacing: 5
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 70
                height: 70
                color: index === fileGridView.currentIndex ? "lightgray"
                    : (fileGridViewMouseArea.containsMouse ? "lightgreen" : "#00000000")
                radius: 10

                ToolTip {
                    text: model.filePath + "/" + model.fileName
                    visible: fileGridViewMouseArea.containsMouse
                    x: parent.x
                    y: parent.y + parent.height + 5
                }
                
                Text {
                    anchors.centerIn: parent
                    font.family: materialFilled.name
                    font.pixelSize: 48
                    text: FileStyle.getIcon(model.fileType)
                    color: FileStyle.getColor(model.fileType)
                }

                FileActionsMenu { id: fileActionsMenu }

                MouseArea {
                    id: fileGridViewMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    Timer {
                        id: clickTimer
                        interval: 200
                        onTriggered: fileGridView.currentIndex = index
                    }

                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: (mouse) => { // external captured
                        if (mouse.button === Qt.RightButton) {
                            fileGridView.currentIndex = index
                            fileActionsMenu.popup()
                        } else if (mouse.button === Qt.LeftButton) {
                            if (clickTimer.running) {
                                // double clicked
                                fileGridView.currentIndex = index
                                fileManager.open(model.filePath + "/" + model.fileName)
                                clickTimer.stop()
                            } else {
                                // single clicked
                                clickTimer.restart()
                            }
                        }
                    }
                }
            }

            TextEdit {
                id: fileTextEdit
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                width: parent.width - 10
                font.pixelSize: 14
                text: Utils.truncateTextToFit(model.fileName, 15)
                color: materialStyleHelper.color
                readOnly: false
                selectByMouse: true
                wrapMode: TextEdit.Wrap

                // background: Rectangle {
                //     id: fileTextFieldBackground
                //     width: parent.width
                //     radius: 5
                //     color: "lightgray"
                //     border.color: "blue"
                //     border.width: 1
                // }
                Connections {
                    target: fileGridView
                    function onCurrentIndexChanged() {
                        // 此处存在优化的地方，每次选中后所有元素都得更新文本，即使没有任何变化
                        // console.log("Index: " + index + ", Current index: " + fileGridView.currentIndex);
                        // console.log("Model file_name: " + model.fileName);
                        if (index === fileGridView.currentIndex) {
                            fileTextEdit.text = model.fileName
                            fileTextEdit.selectAll()
                        } else {
                            fileTextEdit.text = Utils.truncateTextToFit(model.fileName, 15)
                            fileTextEdit.deselect()
                        }
                    }
                }
            }
        }
    }

    TextField {
        id: materialStyleHelper
        visible: false
    }
    
    ScrollBar.vertical: ScrollBar {}
    boundsBehavior: Flickable.StopAtBounds
}