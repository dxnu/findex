#ifndef SEARCH_MODEL_H_
#define SEARCH_MODEL_H_

#include <QAbstractListModel>
#include <QStringList>

struct FileRecord {
    QString file_name;
    QString full_path;
};

class SearchModel : public QAbstractListModel {
    Q_OBJECT
public:
    enum FileRecordRoles {
        FileNameRole = Qt::UserRole + 1,
        FullPathRole
    };

    explicit SearchModel(QObject* parent = nullptr);

    void search(const QString& path, const QString& keywords, int offset, int maxCount);

    void addFileRecord(FileRecord record);
    void deleteFileRecord(int index);

    void clear();

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;

    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    QList<FileRecord> records_;
};

#endif // SEARCH_MODEL_H_