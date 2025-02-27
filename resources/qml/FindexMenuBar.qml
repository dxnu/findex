import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Material

MenuBar {
    id: root

    Menu {
        title: qsTr("File")
        Action {
            text: qsTr("New")
            shortcut: "Ctrl+N"
            onTriggered: {
                languageController.switchLanguage("fr_FR")
            }
        }
    }

    Menu { title: qsTr("Edit") }
    
    Menu {
        title: qsTr("View")

        Action {
            text: qsTr("Grid")
            onTriggered: currentView = "grid"
        }

        Action {
            text: qsTr("Table")
            onTriggered: currentView = "table"
        }
    }

    Menu {
        title: qsTr("Help")

        Action {
            text: qsTr("Cache Directory")
            onTriggered: {
                var cacheDirectory = searchController.cacheDirectory();
                if (cacheDirectory) {
                    Qt.openUrlExternally("file://" + cacheDirectory);
                }
            }
        }
        
        MenuSeparator {}

        Menu {
            title: qsTr("Theme")
            MenuItem {
                text: qsTr("Dark")
                onTriggered: mainWindow.currentTheme = "dark"
            }
            MenuItem {
                text: qsTr("Light")
                onTriggered: mainWindow.currentTheme = "light"
            }
        }

        Action {
            text: qsTr("&About")
            onTriggered: {
                var factory = Qt.createComponent("AboutWindow.qml")
                var aboutWindow = factory.createObject(root)
                aboutWindow.show()
            }
        }
    }
}