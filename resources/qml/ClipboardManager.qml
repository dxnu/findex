import QtQuick
import QtQuick.Controls

Item {
    function copy(text) {
        clipboardHelper.text = text
        clipboardHelper.selectAll()
        clipboardHelper.copy()
    }

    TextArea {
        id: clipboardHelper
        visible: false
    }
}