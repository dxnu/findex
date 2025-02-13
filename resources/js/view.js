function loadView(currentView) {
    if (currentView === "grid") return "FindexGridView.qml";
    else if (currentView === "list") return "FindexListView.qml";
    else if (currentView === "table") return "FindexTableView.qml";
    else if (currentView === "default") return "FindexDefaultView.qml";
    // else if (currentView === "tree") return treeView;
    else return "FindexLogView.qml";
    // currentView === "grid" ? gridView :
    //                      currentView === "list" ? listView :
    //                      treeView
}