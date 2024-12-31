import QtQuick 2.0
import QtQuick.Controls 2.3

Rectangle {
    height: 40
    width: parent.width
    color: "lightgray"

    property string query_stats: "No Search Performed"

    Rectangle {
        width: parent.width
        height: 1
        color: "lightgray"
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        // anchors.leftMargin: 10
        spacing: 10

        Text {
            anchors.verticalCenter: parent.verticalCenter
            font.family: materialIcons.name
            font.pixelSize: 20
            text: "\ue4fc"
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: query_stats
        }
    }
}