import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Rectangle {
    width: parent.width
    height: 40
    color: "transparent"

    TextField {
        id: searchTextField
        anchors.fill: parent
        height: parent.height
        rightPadding: 40
        font.pixelSize: 14
        focus: true
        placeholderText: focus || text.length > 0 ? null : "输入文件名称，快速找你想要"
        selectByMouse: true

        background: Rectangle {
            color: "transparent"
            border.width: 1 // currentTheme === "dark" ? 1 : 2
            border.color: searchTextField.focus ? Material.color(Material.Pink) : Material.color(Material.Teal)

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.family: materialIcons.name
                font.pixelSize: 25
                text: "\ue8b6"
                color: Material.color(Material.Grey)
            }
        }

        onTextChanged: {
            if (text.length > 0) {
                searchController.clear()
                searchController.search("", text)
            }
        }
    }

    // RowLayout {
    //     anchors.fill: parent
    //     Rectangle {
    //         id: searchRect
    //         Layout.preferredWidth: parent.width * 0.8
    //         Layout.preferredHeight: parent.height - 10
    //         Layout.alignment: Qt.AlignHCenter
    //         color: "transparent"
    //         border.width: 1
    //         border.color: Material.color(Material.primary)

    //         // Text {
    //         //     font.family: materialIcons.name
    //         //     font.pixelSize: 25
    //         //     text: "\ue8b6"
    //         //     color: Material.color(Material.Grey)

    //         //     // anchors.right: parent.right
    //         //     // anchors.rightMargin: 10
    //         //     anchors.verticalCenter: parent.verticalCenter
    //         // }

    //         TextField {
    //             id: searchTextField
    //             anchors.fill: parent
    //             rightPadding: 40
    //             // background: null
    //             font.pixelSize: 14
    //             placeholderText: qsTr("输入文件名称，快速找你想要")
    //             selectByMouse: true

    //             background: Text {
    //                 anchors.right: parent.right
    //                 anchors.rightMargin: 10
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 font.family: materialIcons.name
    //                 font.pixelSize: 25
    //                 text: "\ue8b6"
    //                 color: Material.color(Material.Grey)
    //             }
    //         }

    //     }
    // }
}