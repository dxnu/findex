#include "SearchModel.h"

#include <QtDBus>

SearchModel::SearchModel(QObject* parent)
    : QAbstractListModel(parent) {}

void SearchModel::search(const QString& path, const QString& keywords, int offset, int maxCount)
{
    // qDebug() << path << "," << keywords << "," << offset << "," << max_count;
    if (!QDBusConnection::systemBus().isConnected()) {
        qCritical() << "Cannot connect to the D-Bus session bus.\n";
        return;
    }

    QDBusInterface iface("my.test.SAnything", "/my/test/OAnything", "my.test.IAnything", QDBusConnection::systemBus());
    if (iface.isValid()) {
        QDBusReply<QStringList> reply = iface.call("search", path, keywords, offset, maxCount);
        if (reply.isValid()) {
            for (const auto& filePath : reply.value()) {
                QFileInfo fileInfo(filePath);
                if (fileInfo.exists()) {
                    addFileRecord({
                        .file_name = fileInfo.fileName(),
                        .full_path = fileInfo.path()
                    });
                }
            }
        } else {
            qCritical() << "Call to search failed:" << qPrintable(reply.error().message());
        }
    }
}

void SearchModel::addFileRecord(FileRecord record)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    records_ << std::move(record);
    endInsertRows();
}

void SearchModel::deleteFileRecord(int index)
{
    QAbstractListModel::beginResetModel();
    records_.removeAt(index);
    QAbstractListModel::endResetModel();
}

void SearchModel::clear()
{
    QAbstractListModel::beginResetModel();
    records_.clear();
    QAbstractListModel::endResetModel();
}

int SearchModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return records_.count();
}

QVariant SearchModel::data(const QModelIndex& index, int role) const
{
    if(index.row() < 0 || index.row() >= records_.count())
        return QVariant();

    const FileRecord& record = records_[index.row()];
    if (role == FileNameRole)
        return record.file_name;
    else if (role == FullPathRole)
        return record.full_path;

    return QVariant();
}

QHash<int, QByteArray> SearchModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FileNameRole] = "file_name";
    roles[FullPathRole] = "full_path";
    return roles;
}
