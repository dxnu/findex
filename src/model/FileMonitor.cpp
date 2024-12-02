#include "FileMonitor.h"

#include <QDebug>

FileMonitor::FileMonitor(QObject *parent)
    : QObject(parent) {}

void FileMonitor::setFilePath(const QString& filePath)
{
    if (filePath == filePath_)
        return;

    filePath_ = filePath;

    // Watch the file for changes
    QStringList files = watcher_.files();
    if (!files.isEmpty()) {
        watcher_.removePaths(files);
    }
    if (!filePath_.isEmpty()) {
        watcher_.addPath(filePath_);
        connect(&watcher_, &QFileSystemWatcher::fileChanged, this, &FileMonitor::onFileChanged);
    }

    readFile();
}

void FileMonitor::onFileChanged() {
    qDebug() << "File changed: " << filePath_;
    readFile();
}

void FileMonitor::readFile()
{
    QFile file(filePath_);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        fileContent_ = in.readAll();
        file.close();
        emit fileContentChanged();
    } else {
        qWarning() << "Unable to open file: " << filePath_;
        fileContent_.clear();
        emit fileContentChanged();
    }
}