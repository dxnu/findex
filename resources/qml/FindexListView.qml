import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0

Component {
    ListView {
        id: fileListView
        y: titleBar.height
        
        width: mainWindow.width
        height: mainWindow.height
        // keyNavigationWraps: true
        clip: true
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

    // ScrollArea {
    //     id: listScrollBar

    //     orientation: Qt.Vertical
    //     height: fileListView.height;
    //     width: 8
    //     scrollArea: fileListView;
    //     anchors.right: fileListView.right
    // }
}