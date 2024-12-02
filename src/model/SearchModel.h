#ifndef SEARCH_MODEL_H
#define SEARCH_MODEL_H

#include <memory>

#include <QAbstractListModel>
#include <QStringList>
#include <QtDBus>


class SearchModel : public QAbstractListModel {
    Q_OBJECT
public:
    enum FileRecordRoles {
        FileNameRole = Qt::UserRole + 1,
        FullPathRole,
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
        FileType fileType;
    };

    explicit SearchModel(QObject* parent = nullptr);
    ~SearchModel();

    void search(const QString& path, const QString& keywords, int offset, int maxCount);
    void search(const QString& keywords);

    void indexFilesInDirectory(const QString& directoryPath) const;

    void addFileRecord(FileRecord record);
    void deleteFileRecord(int index);

    void clear();

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;

    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    void handleSearchResults(const QDBusReply<QStringList>& results);

private:
    QList<FileRecord> records_;
    std::unique_ptr<QDBusInterface> iface_;
};

#endif // SEARCH_MODEL_H