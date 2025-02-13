import QtQuick
import QtQuick.Controls

Rectangle {
    y: searchBar.height
    width: mainWindow.width
    height: mainWindow.height - searchBar.height - mainWindow.footer.height
    color: "green"
}