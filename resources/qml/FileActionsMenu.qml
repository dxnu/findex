import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Menu {
    MenuItem {
        text: "Open File"
        implicitHeight: 35
        onTriggered: fileManager.open(model.filePath + "/" + model.fileName)
    }
    MenuItem {
        text: "Open Containing Folder"
        implicitHeight: 35
        onTriggered: fileManager.open(model.filePath)
    }
    MenuSeparator {}
    MenuItem {
        text: "Copy Name"
        implicitHeight: 35
        onTriggered: clipboardManager.copy(model.fileName)
    }
    MenuItem {
        text: "Copy Path"
        implicitHeight: 35
        onTriggered: clipboardManager.copy(model.filePath)
    }
    MenuItem {
        text: "Copy Full Path"
        implicitHeight: 35
        onTriggered: clipboardManager.copy(model.filePath + "/" + model.fileName)
    }
}