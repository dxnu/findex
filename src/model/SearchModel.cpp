#include "SearchModel.h"

#include <QtConcurrent/QtConcurrent>
#include <QThreadPool>
#include <QDebug>

SearchModel::SearchModel(QObject* parent)
    : QAbstractTableModel(parent), watcher_(nullptr)
{
    qDebug() << "SearchModel created:" << this;
    if (QDBusConnection::systemBus().isConnected()) {
        iface_ = std::make_unique<QDBusInterface>("com.deepin.anything",
                                                  "/com/deepin/anything",
                                                  "com.deepin.anything",
                                                  QDBusConnection::systemBus());
    }
}

SearchModel::~SearchModel()
{
    qDebug() << "SearchModel destroyed:" << this;
}

QString SearchModel::cacheDirectory() const
{
    if (iface_->isValid()) {
        QDBusReply<QString> reply = iface_->call("cache_directory");
        return reply.value();
    }
    return {};
}

void SearchModel::search(const QString& path, const QString& keywords, int offset, int maxCount)
{
    auto trimmedKeywords = keywords.trimmed();
    if (trimmedKeywords.isEmpty()) {
        return;
    }

    // if (iface_->isValid()) {
    //     QtConcurrent::run([=] {
    //         QDBusReply<QStringList> results = iface_->call("search", path, trimmedKeywords, offset, maxCount);
    //         if (results.isValid()) {
    //             emit searchResultsReady(results.value());
    //         } else {
    //             qCritical() << "Call to search failed:" << qPrintable(results.error().message());
    //         }
    //     });
    // }

    if (iface_->isValid()) {
        QThreadPool::globalInstance()->start([=] {
            uint32_t startOffset = 0;
            uint32_t endOffset = 0;
            QStringList allResults;
            qint64 kMaxTime = 0;
            do {
                QList<QVariant> argumentList { maxCount, kMaxTime, startOffset, endOffset, path, trimmedKeywords, true };
                const QDBusPendingReply<QStringList, uint, uint>& reply = 
                    iface_->asyncCallWithArgumentList("search", argumentList);
                auto results = reply.argumentAt<0>();
                if (reply.error().type() != QDBusError::NoError) {
                    qCritical() << "deepin-anything search failed:"
                                << QDBusError::errorString(reply.error().type())
                                << reply.error().message();
                    startOffset = endOffset = 0;
                    continue;
                }

                startOffset = reply.argumentAt<1>();
                endOffset = reply.argumentAt<2>();

                allResults << results;
            } while (startOffset < endOffset);

            emit searchResultsReady(allResults);  
        });
    }
}

void SearchModel::search(const QString& keywords)
{
    qDebug() << "search: " << keywords;

    if (watcher_) {
        disconnect(watcher_, &QDBusPendingCallWatcher::finished, this, &SearchModel::handleSearchResults);
        watcher_->deleteLater();
        watcher_ = nullptr;   
    }

    auto trimmedKeywords = keywords.trimmed();
    if (trimmedKeywords.isEmpty()) {
        return;
    }

    QString type = "type:";
    int index = trimmedKeywords.indexOf(type);
    if (index != -1) {
        int start = index + type.length();
        int end = trimmedKeywords.indexOf(' ', start);
        if (end == -1) end = trimmedKeywords.length();
        auto realType = trimmedKeywords.mid(start, end - start);
        trimmedKeywords.remove(type + realType);
        trimmedKeywords = trimmedKeywords.trimmed();
        type = realType;
    }

    if (iface_->isValid()) {
        auto pendingCall = type == "type:"
            ? iface_->asyncCall("search", trimmedKeywords)
            : iface_->asyncCall("search", trimmedKeywords, type);
        watcher_ = new QDBusPendingCallWatcher(pendingCall, this);
        connect(watcher_, &QDBusPendingCallWatcher::finished, this, &SearchModel::handleSearchResults);
    }
}

void SearchModel::indexFilesInDirectory(const QString& directoryPath) const
{
    if (iface_->isValid()) {
        iface_->call("index_files_in_directory", directoryPath);
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
    QAbstractTableModel::beginResetModel();
    records_.removeAt(index);
    QAbstractTableModel::endResetModel();
}

void SearchModel::clear()
{
    QAbstractTableModel::beginResetModel();
    records_.clear();
    QAbstractTableModel::endResetModel();
}

int SearchModel::rowCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent)
    return records_.count();
}

int SearchModel::columnCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent)
    return 5;
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
    else if (role == LastModifiedRole)
        return record.lastModified;
    else if (role == SizeRole)
        return record.size;
    else if (role == FileTypeRole)
        return record.fileType;
    else if (role == Qt::DisplayRole) {
        switch (index.column()) {
            case 0: return record.fileName;
            case 1: return record.fullPath;
            case 2: return record.lastModified;
            case 3: return record.size;
            case 4: return record.fileType;
            default: return QVariant();
        }
    }

    return QVariant();
}

QVariant SearchModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role != Qt::DisplayRole)
        return QVariant();
    
    if (orientation == Qt::Horizontal) {
        switch (section)
        {
        case 0:
            return "Name";
        case 1:
            return "Path";
        case 2:
            return "Last Modified";
        case 3:
            return "Size";
        case 4:
            return "Type";
        default:
            return "Unknown";
        }
    }

    return QVariant();
}

QHash<int, QByteArray> SearchModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FileNameRole]     = "fileName";
    roles[FullPathRole]     = "fullPath";
    roles[LastModifiedRole] = "lastModified";
    roles[SizeRole]         = "size";
    roles[FileTypeRole]     = "fileType";
    roles[Qt::DisplayRole]  = "display";
    return roles;
}

void SearchModel::handleSearchResults(QDBusPendingCallWatcher* call)
{
    QDBusPendingReply<QStringList> reply = *call;
    if (!reply.isValid()) {
        qCritical() << "Call to search failed:" << qPrintable(reply.error().message());
        return;
    }

    for (const auto& filePath : reply.value()) {
        // QString cleanFilePath = filePath;
        // cleanFilePath.remove("<span style='background-color:yellow'>");
        // cleanFilePath.remove("</span>");
        QFileInfo fileInfo(filePath);
        if (fileInfo.exists()) {
            FileType type;
            if (fileInfo.isDir()) type = FileType::Directory;
            else if (fileInfo.isFile()) type = FileType::File;
            else if (fileInfo.isSymLink()) type = FileType::Symlink;
            else if (fileInfo.isExecutable()) type = FileType::Executable;
            else type = FileType::Unknown;
            addFileRecord({ fileInfo.fileName()/*filePath.mid(filePath.lastIndexOf('/') + 1)*/, fileInfo.path(),
                fileInfo.lastModified().toString("yyyy-MM-dd HH:mm:ss"),
                formatFileSize(fileInfo.size()), enumToQString(type) });
        }
    }

    emit searchCompleted(this->rowCount());
    emit dataStatusChanged(this->rowCount() == 0);
    call->deleteLater();
    watcher_ = nullptr;
}

QString SearchModel::formatFileSize(qint64 size)
{
    const double KB = 1024.0;
    const double MB = KB * 1024.0;
    const double GB = MB * 1024.0;

    if (size < KB) {
        return QString::number(size) + " bytes";
    } else if (size < MB) {
        return QString::number(size / KB, 'f', 2) + " KB";
    } else if (size < GB) {
        return QString::number(size / MB, 'f', 2) + " MB";
    } else {
        return QString::number(size / GB, 'f', 2) + " GB";
    }
}

QString SearchModel::enumToQString(FileType fileType)
{
    QMetaEnum metaEnum = QMetaEnum::fromType<SearchModel::FileType>();
    return metaEnum.valueToKey(fileType);
}
