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
        anchors.left: parent.left
        anchors.right: viewRowLayout.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 20
        anchors.leftMargin: 20
        spacing: 20

        Rectangle {
            id: searchRect
            Layout.alignment: Qt.AlignRight
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
                        findexFooter.query_stats = "Searching...";
                        searchController.clear()
                        searchController.search(searchTextField.text)
                        // searchController.search("", searchTextField.text, 0, 10000)
                        // searchCompleted(result)
                    } /*else { // 
                        searchController.clear()
                    }*/
                }
            }
        }

        Button {
            id: searchButton
            Layout.alignment: Qt.AlignRight
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
            onClicked: {
                if (mainWindow.currentView !== "grid")
                    mainWindow.currentView = "grid"
            }
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

        Button {
            id: logButton
            font.family: materialIcons.name
            font.pixelSize: 20
            text: "\ue0a8" // e104
            background: Rectangle {
                implicitWidth: titleRect.height - 20
                implicitHeight: titleRect.height - 20
                color: logButton.hovered ? "#d6d6d6" : "#ffffff"
                radius: 10
            }
            onClicked: {
                logFileMonitor.setFilePath("/data/home/dxnu/.cache/findex/findex.log")
                mainWindow.currentView = "log"
            }
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Log View")
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
            onClicked: settingMenu.toggle()

            FindexSettingMenu {
                id: settingMenu
            }
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
            text: mainWindow.visibility === Window.Maximized ? "\ue65b" : "\ue3c0" // f743/e3e0
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
}