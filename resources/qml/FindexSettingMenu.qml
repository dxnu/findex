import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.3

Menu {
    // x: basicRowLayout.x + settingButton.x
    y: parent.y + parent.height
    width: 150
    closePolicy: Popup.CloseOnPressOutsideParent
    background: Item {
        // width: parent.width
        // height: parent.height

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
            var factory = Qt.createComponent("AboutWindow.qml")
            if (factory.status === Component.Error) {
                console.log("Component status:", factory.status)
                console.log("Error loading component:", factory.errorString())
            } else {
                var aboutWindow = factory.createObject()
                aboutWindow.show()
            }
        }
    }
    onOpened: console.log("Menu opened")
    onClosed: console.log("Menu closed")

    function toggle() {
        opened ? close() : open()
    }
}

// Item {
//     Menu {
//         id: internalMenu
//         x: basicRowLayout.x + settingButton.x
//         y: basicRowLayout.y + settingButton.height
//         width: 150
//         closePolicy: Popup.CloseOnPressOutsideParent
//         background: Item {
//             width: settingMenu.width
//             height: settingMenu.height

//             // DropShadow {
//             //     anchors.fill: backgroundRect
//             //     source: backgroundRect
//             //     horizontalOffset: 0
//             //     verticalOffset: 4
//             //     radius: 10
//             //     color: "black"
//             //     samples: 16
//             //     opacity: 0.2
//             // }

//             Rectangle {
//                 id: backgroundRect
//                 anchors.fill: parent
//                 color: "white"
//                 border.color: "#cccccc"
//                 border.width: 1
//                 radius: 10
//             }
//         }

//         MenuItem {
//             text: "新建窗口"
//             onTriggered: console.log("新建窗口")
//         }
//         MenuItem {
//             text: "新建标签页"
//             onTriggered: console.log("新建标签页")
//         }

//         MenuSeparator {}

//         MenuItem {
//             text: "连接到服务器"
//             onTriggered: console.log("连接到服务器")
//         }
//         MenuItem {
//             text: "设置共享密钥"
//             onTriggered: console.log("设置共享密钥")
//         }

//         MenuSeparator {}

//         MenuItem {
//             text: "设置"
//             onTriggered: console.log("设置")
//         }

//         Menu {
//             title: "主题"
//             MenuItem {
//                 text: "主题 1"
//                 onTriggered: console.log("主题 1")
//             }
//             MenuItem {
//                 text: "主题 2"
//                 onTriggered: console.log("主题 2")
//             }
//         }

//         MenuSeparator {}

//         MenuItem {
//             text: "帮助"
//             onTriggered: console.log("帮助")
//         }
//         MenuItem {
//             text: qsTr("About")
//             onTriggered: {
//                 // var factory = Qt.createComponent("AboutWindow.qml");
//                 // var aboutWindow = factory.createObject(mainWindow);
//                 // aboutWindow.visible = true
//                 // aboutWindow.show()
//             }
//         }
//         onOpened: console.log("Menu opened")
//         onClosed: console.log("Menu closed")
//     }

//     function openMenu() {
//         internalMenu.open()
//     }

//     function closeMenu() {
//         internalMenu.close()
//     }

//     function toggleMenu() {
//         console.log("toggle menu")
//         internalMenu.opened ? internalMenu.close() : internalMenu.open()
//     }
// }


// Window {
//     id: aboutWindow
//     width: 400
//     height: 250
//     visible: false
//     modality: Qt.ApplicationModal
//     flags: Qt.Window | Qt.WindowMinimizeButtonHint | Qt.WindowCloseButtonHint
// }