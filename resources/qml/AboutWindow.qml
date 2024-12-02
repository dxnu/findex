import QtQuick.Window 2.0

Window {
    id: aboutWindow
    width: 400
    height: 250
    visible: false
    title: "\u0020"
    // modality: Qt.ApplicationModal
    flags: Qt.Window /*| Qt.WindowMinimizeButtonHint*/ | Qt.WindowCloseButtonHint | Qt.WindowStaysOnTopHint
}