import QtQuick

Item {
    function open(path) {
        Qt.openUrlExternally("file://" + path)
    }
}