#include "FileController.h"

#include <QDesktopServices>
#include <QUrl>

#include <QDebug>

FileController::FileController(QObject* parent)
    : QObject(parent) {}

bool FileController::openExternally(const QString& file)
{
    if (QDesktopServices::openUrl(QUrl::fromLocalFile(file))) {
        qDebug() << "Folder opened successfully:";
        return true;
    } else {
        qDebug() << "Failed to open folder:";
        return false;
    }
}