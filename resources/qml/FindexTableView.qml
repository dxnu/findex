import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Rectangle {
    y: searchBar.height + 10
    width: mainWindow.width
    height: mainWindow.height - searchBar.height - mainWindow.menuBar.height - mainWindow.footer.height - 10
    color: Material.background

    HorizontalHeaderView {
        id: horizontalHeader
        anchors.left: fileTableView.left
        anchors.top: parent.top
        syncView: fileTableView
        clip: true
        visible: true
        boundsBehavior: Flickable.StopAtBounds

        delegate: Rectangle {
            implicitWidth: 100 // placehoder value
            implicitHeight: 25
            color: Material.background
            Text {
                text: model.display
                color: materialStyleHelper.color
                font.bold: true
                leftPadding: 10
            }
        }
    }

    SelectionRectangle {
        target: fileTableView
    }

    TableView {
        id: fileTableView
        anchors.left: parent.left
        anchors.top: horizontalHeader.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        boundsBehavior: Flickable.StopAtBounds

        // keyNavigationWraps: true
        columnSpacing: 1
        clip: true
        focus: true

        // columnWidthProvider: function(column) { return 100; }
        // rowHeightProvider: function(row) { return 50; }

        // TableViewColumn { title: "Name"; role: "fileName"; width: 100 }
        delegate: Rectangle {
            implicitWidth: 100 // placehoder value
            implicitHeight: 30
            color: {
                if (currentTheme === "dark") {
                    return selected ? materialStyleHelper.selectionColor : (row % 2 === 0 ? "#333333" : "#252525")
                }

                return selected ? materialStyleHelper.selectionColor : (row % 2 === 0 ? "#F8F8F8" : "#EDEDED")
            }
            Text {
                font.pixelSize: 14
                text: display
                width: parent.width
                elide: Text.ElideRight
                color: materialStyleHelper.color
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
            }

            Menu {
                id: tabviewContextMenu
                MenuItem {
                    text: "Open"
                    implicitHeight: 35
                    onTriggered: Qt.openUrlExternally("file://" + model.fullPath + "/" + model.fileName)
                }
                MenuItem {
                    text: "Copy path"
                    implicitHeight: 35
                    onTriggered: clipboardManager.copy(model.fullPath)
                }
                MenuItem {
                    text: "Copy full path"
                    implicitHeight: 35
                    onTriggered: clipboardManager.copy(model.fullPath + "/" + model.fileName)
                }
            }

            function selectClickedIndex() {
                fileTableView.selectionModel.select(
                    fileTableView.model.index(row, 0),
                    ItemSelectionModel.ClearAndSelect | ItemSelectionModel.Rows
                )
            }

            MouseArea {
                anchors.fill: parent
                Timer {
                    id: clickTimer
                    interval: 200
                    onTriggered: selectClickedIndex()
                }
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: (mouse) => {
                    if (mouse.button === Qt.RightButton) {
                        selectClickedIndex()
                        tabviewContextMenu.popup()
                    } else if (mouse.button === Qt.LeftButton) {
                        if (clickTimer.running) {
                            // double click
                            selectClickedIndex()
                            Qt.openUrlExternally("file://" + model.fullPath + "/" + model.fileName)
                            clickTimer.stop()
                        } else {
                            // single click
                            clickTimer.restart()
                        }
                    }
                }
            }

            required property int column
            required property int row
            required property bool selected
        }

        // columnWidthProvider: function(column) {
        //     if (column === 0) return parent.width * 0.2;
        //     if (column === 1) return parent.width * 0.5;
        //     if (column === 2) return parent.width * 0.15;
        //     return parent.width * 0.075;
        // }
        resizableColumns: true

        // function getColumnWidth(column) {
        //     console.log("column: " + column);
        //     switch (column) {
        //         case 0: return mainWindow.width * 0.2;
        //         case 1: return mainWindow.width * 0.5;
        //         case 2: return mainWindow.width * 0.15;
        //         default: return mainWindow.width * 0.075;
        //     }
        // }

        function resizeColumnWidth() {
            setColumnWidth(0, mainWindow.width * 0.2);
            setColumnWidth(1, mainWindow.width * 0.5);
            setColumnWidth(2, mainWindow.width * 0.15);
            setColumnWidth(3, mainWindow.width * 0.075);
            setColumnWidth(4, mainWindow.width * 0.075);
        }

        Component.onCompleted: {
            resizeColumnWidth()
        }

        model: searchController.model()
        selectionModel: ItemSelectionModel { model: fileTableView.model }
        // selectionBehavior: TableView.SelectRows

        ScrollBar.vertical: ScrollBar {}
        ScrollBar.horizontal: ScrollBar {}
    }

    TextField {
        id: materialStyleHelper
        visible: false
    }

    Text {
        id: tipsText
        anchors.centerIn: parent
        text: "No more results"
        color: materialStyleHelper.color
        visible: false
    }

    Connections {
        target: mainWindow
        function onWidthChanged() {
            fileTableView.resizeColumnWidth()
        }
    }

    Connections {
        target: searchController.model()
        function onDataStatusChanged(empty) {
            tipsText.visible = empty
            horizontalHeader.visible = !empty
        }
    }
}
