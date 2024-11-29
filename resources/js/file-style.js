function getIcon(fileType) {
    if (fileType === SearchModel.Directory)
        return "\ue2c7";
    else
        return "\ue873";
}

function getColor(fileType) {
    if (fileType === SearchModel.Directory)
        return "#5985E1";
    else
        return "#5985E1";
}