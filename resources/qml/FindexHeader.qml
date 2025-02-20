import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

ToolBar {
    background: Rectangle {
        color: "red"  // 设置背景颜色 (蓝色)
    }
    RowLayout {
        anchors.fill: parent

        FindexMenuBar {
            anchors.fill: parent
        }

        Button {
            id: gridViewButton
            text: "\ue9b0"
            contentItem: Text {
                text: gridViewButton.text
                font.family: materialIcons.name
                font.pixelSize: 20
                color: gridViewButton.hovered ? "#000000" : "#666666"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                implicitWidth: 30
                implicitHeight: 40
                color: gridViewButton.hovered ? "#d6d6d6" : "#ffffff"
                radius: 10
            }
            onClicked: {
                if (mainWindow.currentView !== "grid")
                    mainWindow.currentView = "grid"
            }
        }
    }
}