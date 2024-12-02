function loadView(currentView) {
    if (currentView === "grid") return gridView;
    else if (currentView === "list") return listView;
    else if (currentView === "tree") return treeView;
    else return logView;
    // currentView === "grid" ? gridView :
    //                      currentView === "list" ? listView :
    //                      treeView
}