import QtQuick 2.0
import QtQuick.Controls 2.3

MenuBar {
    id: root

    Menu {
        title: qsTr("File")
        Action {
            text: qsTr("New")
            shortcut: "Ctrl+N"
        }
    }
    
    Menu { title: qsTr("Edit") }
    
    Menu { title: qsTr("View") }

    Menu {
        title: qsTr("Help")
        Action {
            text: qsTr("&About")
            onTriggered: {
                var factory = Qt.createComponent("AboutWindow.qml")
                var aboutWindow = factory.createObject(root)
                aboutWindow.show()
            }
        }
    }

    delegate: MenuBarItem {
        id: menuBarItem

        contentItem: Text {
            text: menuBarItem.text
            font: menuBarItem.font
            opacity: enabled ? 1.0 : 0.3
            color: menuBarItem.highlighted ? "#ffffff" : "#21be2b"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            // elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 40
            implicitHeight: root.height
            opacity: enabled ? 1 : 0.3
            color: menuBarItem.highlighted ? "#21be2b" : "transparent"
        }
    }

    background: Rectangle {
        implicitWidth: 40
        implicitHeight: root.height
        color: "#ffffff"

        Rectangle {
            color: "#21be2b"
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
        }
    }
}