#include "SearchModel.h"

#include <QDebug>

SearchModel::SearchModel(QObject* parent)
    : QAbstractListModel(parent)
{
    qDebug() << "SearchModel created:" << this;
    if (QDBusConnection::systemBus().isConnected()) {
        iface_ = std::make_unique<QDBusInterface>("my.test.SAnything", "/my/test/OAnything", "my.test.IAnything", QDBusConnection::systemBus());
    }
}

SearchModel::~SearchModel()
{
    qDebug() << "SearchModel destroyed:" << this;
}

void SearchModel::search(const QString& path, const QString& keywords, int offset, int maxCount)
{
    auto trimmedKeywords = keywords.trimmed();
    if (trimmedKeywords.isEmpty()) {
        return;
    }

    if (iface_->isValid()) {
        QDBusReply<QStringList> results = iface_->call("search", path, trimmedKeywords, offset, maxCount);
        if (results.isValid()) {
            for (const auto& filePath : results.value()) {
                QFileInfo fileInfo(filePath);
                if (fileInfo.exists()) {
                    FileType type;
                    if (fileInfo.isDir()) type = FileType::Directory;
                    else if (fileInfo.isFile()) type = FileType::File;
                    else if (fileInfo.isSymLink()) type = FileType::Symlink;
                    else if (fileInfo.isExecutable()) type = FileType::Executable;
                    else type = FileType::Unknown;
                    addFileRecord({ fileInfo.fileName(), fileInfo.path(), type });
                }
            }
        } else {
            qCritical() << "Call to search failed:" << qPrintable(results.error().message());
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
        return record.fileName;
    else if (role == FullPathRole)
        return record.fullPath;

    return QVariant();
}

QHash<int, QByteArray> SearchModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FileNameRole] = "fileName";
    roles[FullPathRole] = "fullPath";
    return roles;
}