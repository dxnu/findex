import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: mainWindow
    width: 1400
    height: 800
    visible: true
    title: qsTr("findex")
    // flags: Qt.FramelessWindowHint

    property string currentView: "list"

    FontLoader {
        id: materialIcons
        source: "qrc:/fonts/MaterialSymbolsOutlined-Light.ttf"
    }

    FindexTitleBar {
        id: titleBar
        anchors.top: parent.top
        width: parent.width
        height: 50
        onSearchCompleted: {
            // outputText.text = result.join("\n")
        }
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
            anchors.fill: parent
            model: fileModel
            cellWidth: 100
            cellHeight: 100
            delegate: Item {
                width: 100; height: 100
                Column {
                    anchors.centerIn: parent
                    spacing: 5
                    Image {
                        source: "folder.png" // 替换为实际的图标路径
                        width: 60; height: 60
                    }
                    Text {
                        text: model.fileName
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                    }
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

            model: fileModel

            delegate: ItemDelegate {
                id: control
                implicitWidth: parent.width
                implicitHeight: 40
                text: fileName

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
    //         anchors.fill: parent
    //         model: fileModel // 需要树状数据模型
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

    ListModel {
        id: fileModel
        ListElement { fileName: "File 1" }
        ListElement { fileName: "File 2" }
        ListElement { fileName: "File 3" }
    }

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