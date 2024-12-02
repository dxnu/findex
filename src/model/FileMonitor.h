#ifndef FILEMONITOR_H
#define FILEMONITOR_H

#include <QObject>
#include <QFile>
#include <QFileSystemWatcher>

class FileMonitor : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString fileContent READ fileContent NOTIFY fileContentChanged)

public:
    explicit FileMonitor(QObject *parent = nullptr);

    QString fileContent() const { return fileContent_; }

    Q_INVOKABLE void setFilePath(const QString &filePath);

signals:
    void fileContentChanged();

private slots:
    void onFileChanged();

private:
    void readFile();

    QString filePath_;
    QString fileContent_;
    QFileSystemWatcher watcher_;
};

#endif // FILEMONITOR_H