import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Rectangle {
    width: parent.width
    height: 40
    color: "transparent"
    border.width: 1
    border.color: Material.color(Material.Teal)

    RowLayout {
        anchors.fill: parent
        Rectangle {
            id: searchRect
            Layout.preferredWidth: parent.width * 0.8
            Layout.preferredHeight: parent.height - 10
            Layout.alignment: Qt.AlignHCenter
            color: "transparent"
            border.width: 1
            border.color: Material.color(Material.primary)

            TextField {
                id: searchTextField
                anchors.fill: parent
                anchors.rightMargin: 50
                // background: null
                font.pixelSize: 14
                placeholderText: qsTr("输入文件名称，快速找你想要")
                selectByMouse: true
            }

            Text {
                font.family: materialIcons.name
                font.pixelSize: 25
                text: "\ue8b6"
                color: Material.color(Material.Grey)

                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}