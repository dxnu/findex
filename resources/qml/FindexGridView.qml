import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0
import com.search.model 1.0
import "qrc:js/utils.js" as Utils

Component {
    GridView {
        id: fileGridView
        y: titleBar.height
        width: mainWindow.width
        height: mainWindow.height
        model: searchController.model()
        cellWidth: 100
        cellHeight: 120
        // TapHandler { // 点击空白区域的事件，取消选中，当前版本太低不支持（>6.2）
        //     onTapped: {
        //         console.log("out clicked!")
        //         gridView.currentIndex = -1
        //     }
        // }
        // MouseArea {
        //     anchors.fill: parent
        //     onClicked: {
        //         const clickedIndex = fileGridView.indexAt(mouse.x, mouse.y) // -1: empty space value: clicked index
        //         fileGridView.currentIndex = clickedIndex
        //     }
        // }
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

                    Text {
                        anchors.centerIn: parent
                        font.family: materialFilled.name
                        font.pixelSize: 48
                        text: model.fileType === SearchModel.Directory ? "\ue2c7" : "\ue873"
                        color: "#5985E1"
                    }

                    MouseArea {
                        id: fileGridViewMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: { // external captured
                            fileGridView.currentIndex = index
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
                        onCurrentIndexChanged: {
                            if (index === fileGridView.currentIndex) {
                                fileTextEdit.text = model.fileName
                                fileTextEdit.selectAll()
                            } else if (index !== -1) {
                                fileTextEdit.text = Utils.truncateTextToFit(model.fileName, 15)
                                fileTextEdit.deselect()
                            }
                        }
                    }
                }

                // TextField {
                //     id: fileTextField
                //     anchors.horizontalCenter: parent.horizontalCenter
                //     horizontalAlignment: Text.AlignHCenter
                //     width: parent.width - 10
                //     font.pixelSize: 14
                //     text: Utils.truncateTextToFit(model.file_name, 15)
                //     readOnly: true
                //     selectByMouse: true
                //     wrapMode: TextInput.Wrap

                //     background: Rectangle {
                //         id: fileTextFieldBackground
                //         width: parent.width
                //         radius: 5
                //         color: "lightgray"
                //         border.color: "blue"
                //         border.width: 1
                //     }

                //     Connections {
                //         target: fileGridView
                //         onCurrentIndexChanged: {
                //             if (index === fileGridView.currentIndex) {
                //                 fileTextField.text = model.file_name
                //                 fileTextField.selectAll()
                //             } else {
                //                 fileTextField.text = Utils.truncateTextToFit(model.file_name, 15)
                //                 fileTextField.deselect()
                //             }
                //         }
                //     }
                // }
            }
        }
    }
}