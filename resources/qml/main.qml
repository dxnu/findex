import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0
import "qrc:js/utils.js" as Utils

ApplicationWindow {
    id: mainWindow
    width: 1400
    height: 800
    visible: true
    title: qsTr("findex")
    // flags: Qt.FramelessWindowHint

    property string currentView: "grid"

    FontLoader {
        id: materialIcons
        source: "qrc:/fonts/MaterialSymbolsOutlined-Light.ttf"
    }
    FontLoader {
        id: materialFilled
        source: "qrc:/fonts/MaterialSymbolsOutlined_Filled-Regular.ttf"
    }

    FindexTitleBar {
        id: titleBar
        anchors.top: parent.top
        width: parent.width
        height: 50
        // onSearchCompleted: {
        //     // outputText.text = result.join("\n")
        // }
    }

    Loader {
        id: viewLoader
        Layout.fillWidth: true
        Layout.fillHeight: true

        sourceComponent: currentView === "grid" ? gridView :
                         currentView === "list" ? listView :
                         treeView
    }

    Component {
        id: gridView
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
                            text: "\ue2c7"
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
                        text: Utils.truncateTextToFit(model.file_name, 15)
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
                                    fileTextEdit.text = model.file_name
                                    fileTextEdit.selectAll()
                                } else {
                                    fileTextEdit.text = Utils.truncateTextToFit(model.file_name, 15)
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

    Component {
        id: listView
        ListView {
            id: fileListView
            y: titleBar.height
            width: mainWindow.width
            height: mainWindow.height
            focus: true

            model: searchController.model()

            delegate: ItemDelegate {
                id: control
                implicitWidth: parent.width
                implicitHeight: 40
                text: model.file_name

                contentItem: Text {
                    text: control.text
                    font: control.font
                    color: control.enabled ? (control.down ? "#f2fdff" : "#f2fdff") : "#f2fdff"
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.Wrap
                }

                background: Rectangle {
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    opacity: 0.6
                    color: control.highlighted ? (control.hovered ? "#50616d" : "#3d3b4f")
                                            : (control.hovered ? "#50616d" : "#758a99")
                }

                highlighted: ListView.isCurrentItem

                onClicked: {
                    fileListView.forceActiveFocus()
                    fileListView.currentIndex = model.index
                }
            }
        }
    }

    // Component {
    //     id: treeView
    //     TreeView {
    //         y: titleBar.height
    //         width: mainWindow.width
    //         height: mainWindow.height
    //         model: fileModel
    //         delegate: Item {
    //             RowLayout {
    //                 spacing: 5
    //                 Text {
    //                     text: model.fileName
    //                     font.pixelSize: 16
    //                 }
    //             }
    //         }
    //     }
    // }

    // FindexMenuBar {
    //     id: menuBar
    //     width: parent.width
    //     height: 35
    //     // background: Rectangle {
    //     //     color: "pink"
    //     // }
    // }

    // FindexSearchBox {
    //     id: searchBox
    //     anchors.top: menuBar.bottom
    //     anchors.left: parent.left
    //     width: parent.width
    //     height: 45
    //     onSearchCompleted: {
    //         // console.log("Search result:", result);
    //         outputText.text = result.join("\n")
    //     }
    // }

    // Text {
    //     id: outputText
    //     y: 100
    //     width: parent.width
    //     height: 600
    //     wrapMode: Text.WordWrap
    //     text: "This is a long line of text that will wrap to the next line."
    // }

    // ListView {
    //     y: 100
    //     width: 400
    //     height: 300
    //     model: ListModel {
    //         ListElement { name: "Alice"; age: 25; gender: "Female" }
    //         ListElement { name: "Bob"; age: 30; gender: "Male" }
    //         ListElement { name: "Carol"; age: 28; gender: "Female" }
    //     }

    //     delegate: Row {
    //         spacing: 10
    //         Text { text: name; width: 100 }
    //         Text { text: age; width: 50 }
    //         Text { text: gender; width: 100 }
    //     }
    // }

    // TableView {
    //     id: tableView
    //     anchors.fill: parent
    //     columnSpacing: 5
    //     rowSpacing: 5

    //     model: ListModel {
    //         ListElement { name: "Alice"; age: 25; country: "USA" }
    //         ListElement { name: "Bob"; age: 30; country: "UK" }
    //         ListElement { name: "Charlie"; age: 35; country: "Canada" }
    //     }

    //     TableViewColumn {
    //         role: "name"
    //         title: "Name"
    //         width: 100
    //     }

    //     TableViewColumn {
    //         role: "age"
    //         title: "Age"
    //         width: 50
    //     }

    //     TableViewColumn {
    //         role: "country"
    //         title: "Country"
    //         width: 100
    //     }
    // }

    footer: Rectangle {
        height: 40
        width: parent.width
        color: "lightgray"
        Text {
            font.family: materialIcons.name
            anchors.centerIn: parent
            text: "\ue5d2"
        }
    }
}