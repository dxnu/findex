import QtQuick
import QtQuick.Controls

Rectangle{
    y: titleBar.height
    width: mainWindow.width
    height: mainWindow.height - titleBar.height - mainWindow.footer.height

    HorizontalHeaderView {
        id: horizontalHeader
        anchors.left: fileTableView.left
        anchors.top: parent.top
        syncView: fileTableView
        clip: true
        boundsBehavior: Flickable.StopAtBounds
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
            // implicitWidth: 100
            implicitWidth: fileTableView.columnWidth(column)
            implicitHeight: 30
            // color: selected ? "#0078d7" : (row % 2 === 0 ? "#2b2b2b" : "#333333")
            color: selected ? "#0078d7" : (row % 2 === 0 ? "#F8F8F8" : "#EDEDED")
            Text {
                font.pixelSize: 14
                text: display
                width: parent.width
                elide: Text.ElideRight
                color: "black"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
            }

            required property int column
            required property int row
            required property bool selected
        }

        columnWidthProvider: function(column) {
            if (column === 0) return parent.width * 0.2;
            if (column === 1) return parent.width * 0.5;
            if (column === 2) return 200;
            return 100;
        }
        resizableColumns: true
        // Component.onCompleted: {
        //     fileTableView.setColumnWidth(0, mainWindow.width * 0.4);
        //     fileTableView.setColumnWidth(1, mainWindow.width * 0.4);
        //     fileTableView.setColumnWidth(2, 200);
        // }

        model: searchController.model()
        selectionModel: ItemSelectionModel {
            model: fileTableView.model
        }

        ScrollBar.vertical: ScrollBar {}
        ScrollBar.horizontal: ScrollBar {}
    }
}
