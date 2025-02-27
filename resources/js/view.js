function loadView(currentView) {
    const viewMap = {
        "table": "FindexTableView.qml",
        "grid": "FindexGridView.qml",
        "list": "FindexListView.qml",
        "log": "FindexLogView.qml"
    };

    return viewMap[currentView] || "FindexDefaultView.qml";
}