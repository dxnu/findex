import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0

Rectangle {
    id: titleRect
    width: parent.width
    height: parent.height
    // color: "red"

    // signal searchCompleted(var result)

    RowLayout {
        id: searchRowLayout
        anchors.right: viewRowLayout.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 20
        spacing: 20

        Rectangle {
            id: searchRect
            implicitWidth: 0.8 * (titleRect.width - viewRowLayout.width - basicRowLayout.width)
            implicitHeight: titleRect.height - 20
            radius: 20
            border.color: "red"
            border.width: 1
            visible: false

            SequentialAnimation {
                id: showAnimation
                running: searchRect.visible
                loops: 1

                // PropertyAnimation {
                //     target: searchRect
                //     property: "x"
                //     from: 0
                //     to: searchRect.width
                //     duration: 600
                //     easing.type: Easing.InOutQuad
                // }

                PropertyAnimation {
                    target: searchRect
                    property: "opacity"
                    from: 0.0
                    to: 1.0
                    duration: 1000
                }
            }

            Text {
                font.family: materialIcons.name
                font.pixelSize: 20
                text: "\ue8b6"

                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }

            TextField {
                id: searchTextField
                background: null
                selectByMouse: true
                
                anchors.fill: parent
                anchors.leftMargin: 30

                onFocusChanged: {
                    if(activeFocus) {
                        searchRect.border.color = "green"
                    } else {
                        searchRect.border.color = "red"
                    }
                }

                // onAccepted: {
                //     if (text.length > 0) {
                //         var result = searchController.search("", searchTextField.text, 0, 10)
                //         searchCompleted(result)
                //     }
                // }

                onTextChanged: {
                    if (text.length > 0) {
                        searchController.clear()
                        searchController.search("", searchTextField.text, 0, 300)
                        // var result = searchController.search("", searchTextField.text, 0, 10)
                        // searchCompleted(result)
                    }
                }
            }
        }

        Button {
            id: searchButton
            font.family: materialIcons.name
            font.pixelSize: 20
            text: "\ue8b6"
            background: Rectangle {
                implicitWidth: titleRect.height - 20
                implicitHeight: titleRect.height - 20
                color: searchButton.hovered ? "#d6d6d6" : "#ffffff"
                radius: 10
            }
            onClicked: {
                if (searchButton.text === "\ue8b6") {
                    searchButton.text = "\uf02f"
                    if (!searchRect.visible) {
                        searchRect.visible = true
                        searchTextField.forceActiveFocus()
                    }
                } else {
                    searchButton.text = "\ue8b6"
                }
            }
        }
    }

    RowLayout {
        id: viewRowLayout
        anchors.right: basicRowLayout.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 50
        spacing: 1

        Button {
            id: gridViewButton
            font.family: materialIcons.name
            font.pixelSize: 20
            text: "\ue9b0"
            background: Rectangle {
                implicitWidth: titleRect.height - 20
                implicitHeight: titleRect.height - 20
                color: gridViewButton.hovered ? "#d6d6d6" : "#ffffff"
                radius: 10
            }
            onClicked: mainWindow.currentView = "grid"
        }

        Button {
            id: listViewButton
            font.family: materialIcons.name
            font.pixelSize: 20
            text: "\ue9b9"
            background: Rectangle {
                implicitWidth: titleRect.height - 20
                implicitHeight: titleRect.height - 20
                color: listViewButton.hovered ? "#d6d6d6" : "#ffffff"
                radius: 10
            }
            onClicked: mainWindow.currentView = "list"
        }

        Button {
            id: treeViewButton
            font.family: materialIcons.name
            font.pixelSize: 20
            text: "\ue97a"
            background: Rectangle {
                implicitWidth: titleRect.height - 20
                implicitHeight: titleRect.height - 20
                color: treeViewButton.hovered ? "#d6d6d6" : "#ffffff"
                radius: 10
            }
            onClicked: mainWindow.currentView = "tree"
        }
    }

    // Minimum, Maximum, Close, etc.
    RowLayout {
        id: basicRowLayout
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Button {
            id: settingButton
            font.family: materialIcons.name
            font.pixelSize: 20
            text: "\ue5d2"
            background: Rectangle {
                implicitWidth: 50
                implicitHeight: titleRect.height
                color: settingButton.hovered ? "#d6d6d6" : "#ffffff"
            }
            onClicked: settingMenu.open()
        }

        Button {
            id: minimumButton
            font.family: materialIcons.name
            font.pixelSize: 20
            text: "\ue15b"
            background: Rectangle {
                implicitWidth: 50
                implicitHeight: titleRect.height
                color: minimumButton.hovered ? "#d6d6d6" : "#ffffff"
            }
            onClicked: mainWindow.showMinimized()
        }

        Button {
            id: maximumButton
            font.family: materialIcons.name
            font.pixelSize: 20
            text: mainWindow.visibility === Window.Maximized ? "\ue5d1" : "\ue3c0"
            background: Rectangle {
                implicitWidth: 50
                implicitHeight: titleRect.height
                color: maximumButton.hovered ? "#d6d6d6" : "#ffffff"
            }
            onClicked: mainWindow.visibility === Window.Maximized ? mainWindow.showNormal() : mainWindow.showMaximized()
        }

        Button {
            id: closeButton
            font.family: materialIcons.name
            font.pixelSize: 20
            text: "\ue5cd"
            background: Rectangle {
                implicitWidth: 50
                implicitHeight: titleRect.height
                color: closeButton.hovered ? "#d6d6d6" : "#ffffff"
            }
            onClicked: mainWindow.close()
        }
    }

    // Popup {
    //     id: settingPopup
    //     x: basicRowLayout.x + settingButton.x
    //     y: basicRowLayout.y + settingButton.height
    //     width: 100
    //     height: 150
    //     // modal: true
    //     focus: true
    //     closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    //     background: Rectangle {
    //         color: "#cccccc"
    //         radius: 10
    //         border.color: "pink"
    //         border.width: 1
    //     }

    //     ColumnLayout {
    //         anchors.fill: parent
    //         Button {
    //             text: qsTr("About")
    //             Layout.preferredWidth: parent.width
    //             // onClicked: 
    //         }
    //     }
    // }

    Menu {
        id: settingMenu
        x: basicRowLayout.x + settingButton.x
        y: basicRowLayout.y + settingButton.height
        width: 150
        background: Item {
            width: settingMenu.width
            height: settingMenu.height

            // DropShadow {
            //     anchors.fill: backgroundRect
            //     source: backgroundRect
            //     horizontalOffset: 0
            //     verticalOffset: 4
            //     radius: 10
            //     color: "black"
            //     samples: 16
            //     opacity: 0.2
            // }

            Rectangle {
                id: backgroundRect
                anchors.fill: parent
                color: "white"
                border.color: "#cccccc"
                border.width: 1
                radius: 10
            }
        }

        MenuItem {
            text: "新建窗口"
            onTriggered: console.log("新建窗口")
        }
        MenuItem {
            text: "新建标签页"
            onTriggered: console.log("新建标签页")
        }

        MenuSeparator {}

        MenuItem {
            text: "连接到服务器"
            onTriggered: console.log("连接到服务器")
        }
        MenuItem {
            text: "设置共享密钥"
            onTriggered: console.log("设置共享密钥")
        }

        MenuSeparator {}

        MenuItem {
            text: "设置"
            onTriggered: console.log("设置")
        }

        Menu {
            title: "主题"
            MenuItem {
                text: "主题 1"
                onTriggered: console.log("主题 1")
            }
            MenuItem {
                text: "主题 2"
                onTriggered: console.log("主题 2")
            }
        }

        MenuSeparator {}

        MenuItem {
            text: "帮助"
            onTriggered: console.log("帮助")
        }
        MenuItem {
            text: qsTr("About")
            onTriggered: {
                // var factory = Qt.createComponent("AboutWindow.qml");
                // var aboutWindow = factory.createObject(mainWindow);
                // aboutWindow.visible = true
                aboutWindow.show()
            }
        }
    }

    Window {
        id: aboutWindow
        width: 400
        height: 250
        visible: false
        modality: Qt.ApplicationModal
        flags: Qt.Window | Qt.WindowMinimizeButtonHint | Qt.WindowCloseButtonHint
    }
}