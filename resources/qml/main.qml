import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0
import "qrc:findex/js/view.js" as View

ApplicationWindow {
    id: mainWindow
    width: 1400
    height: 800
    minimumWidth: 1000
    minimumHeight: 600
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

        sourceComponent: View.loadView(currentView)
    }

    FindexGridView {
        id: gridView
    }

    FindexListView {
        id: listView
    }

    FindexLogView {
        id: logView
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

    footer: FindexFooter {
        id: findexFooter
    }

    Connections {
        target: searchController.model()
        onSearchCompleted: {
            findexFooter.query_stats = searchCount + " Results"
        }
    }
}