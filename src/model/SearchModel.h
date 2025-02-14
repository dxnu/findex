#ifndef SEARCH_MODEL_H
#define SEARCH_MODEL_H

#include <memory>

#include <qqml.h>
#include <QAbstractListModel>
#include <QAbstractTableModel>
#include <QStringList>
#include <QtDBus>


class SearchModel : public QAbstractTableModel {
    Q_OBJECT
    QML_ELEMENT

public:
    enum FileRecordRoles {
        FileNameRole = Qt::UserRole + 1,
        FullPathRole,
        LastModifiedRole,
        SizeRole,
        FileTypeRole
    };
    enum FileType {
        Unknown,
        File,
        Directory,
        Symlink,
        Executable
    };
    Q_ENUM(FileType)

    struct FileRecord {
        QString fileName;
        QString fullPath;
        QString lastModified;
        // qint64 size;
        QString size;
        // FileType fileType;
        QString fileType;
    };

    explicit SearchModel(QObject* parent = nullptr);
    ~SearchModel();

    QString cacheDirectory() const;

    void search(const QString& path, const QString& keywords, int offset, int maxCount);
    void search(const QString& keywords);

    void indexFilesInDirectory(const QString& directoryPath) const;

    void addFileRecord(FileRecord record);
    void deleteFileRecord(int index);

    void clear();

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;

    int columnCount(const QModelIndex& parent = QModelIndex()) const override;

    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    void handleSearchResults(QDBusPendingCallWatcher* call);

    QString formatFileSize(qint64 size);
    QString enumToQString(FileType fileType);

signals:
    void searchCompleted(int searchCount);
    void searchResultsReady(const QStringList& results);

    void dataStatusChanged(bool empty);

private:
    QList<FileRecord> records_;
    std::unique_ptr<QDBusInterface> iface_;
    QDBusPendingCallWatcher* watcher_;
};

#endif // SEARCH_MODEL_H