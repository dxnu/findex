#include "SearchModel.h"

#include <charconv>
#include <filesystem>

#include <sys/stat.h>  // For statx and struct statx
#include <fcntl.h>     // For AT_FDCWD

#include <QtConcurrent/QtConcurrent>
#include <QThreadPool>
#include <QDebug>
#include <QElapsedTimer>

SearchModel::SearchModel(QObject* parent)
    : QAbstractTableModel(parent), watcher_(nullptr)
{
    qDebug() << "SearchModel created:" << this;
    if (QDBusConnection::systemBus().isConnected()) {
        iface_ = std::make_unique<QDBusInterface>("com.deepin.anything",
                                                  "/com/deepin/anything",
                                                  "com.deepin.anything",
                                                  QDBusConnection::systemBus());
        connect(iface_.get(), SIGNAL(asyncSearchCompleted(QStringList)), this, SLOT(handleAsyncSearchResults(QStringList)));
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

void SearchModel::async_search(const QString& keywords)
{
    auto trimmedKeywords = keywords.trimmed();
    if (trimmedKeywords.isEmpty()) {
        return;
    }

    if (iface_->isValid()) {
        iface_->call("async_search", trimmedKeywords);
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
    if (index < 0 || index >= records_.size()) {
        return;
    }

    beginRemoveRows(QModelIndex(), index, index);
    records_.removeAt(index);
    endRemoveRows();
}

void SearchModel::clear()
{
    // QAbstractTableModel::beginResetModel();
    // records_.clear();
    // QAbstractTableModel::endResetModel();
    if (!records_.isEmpty()) {
        beginRemoveRows(QModelIndex(), 0, records_.size() - 1);
        records_.clear();
        endRemoveRows();
    }
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
    else if (role == FilePathRole)
        return record.filePath;
    else if (role == LastModifiedRole)
        return record.lastModified;
    else if (role == SizeRole)
        return record.size;
    else if (role == FileTypeRole)
        return record.fileType;
    else if (role == Qt::DisplayRole) {
        switch (index.column()) {
            case 0: return record.fileName;
            case 1: return record.filePath;
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
            return tr("Name");
        case 1:
            return tr("Path");
        case 2:
            return tr("Last Modified");
        case 3:
            return tr("Size");
        case 4:
            return tr("Type");
        default:
            return tr("Unknown");
        }
    }

    return QVariant();
}

QHash<int, QByteArray> SearchModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FileNameRole]     = "fileName";
    roles[FilePathRole]     = "filePath";
    roles[LastModifiedRole] = "lastModified";
    roles[SizeRole]         = "size";
    roles[FileTypeRole]     = "fileType";
    roles[Qt::DisplayRole]  = "display";
    return roles;
}

void SearchModel::handleAsyncSearchResults(const QStringList& results)
{
    qDebug() << "Received async search results: " << results.size();
    handleResults(results);
}

void SearchModel::handleSearchResults(QDBusPendingCallWatcher* call)
{
    qDebug() << "get results";
    QDBusPendingReply<QStringList> reply = *call;
    if (!reply.isValid()) {
        qCritical() << "Call to search failed:" << qPrintable(reply.error().message());
        return;
    }

    handleResults(reply.value());
    
    call->deleteLater();
    watcher_ = nullptr;
}

void SearchModel::handleResults(const QStringList& results)
{
    qDebug() << "begin of setting results";
    QElapsedTimer timer;
    timer.start();
    for (const auto& filePath : results) {
        QStringList list = filePath.split("<\\>");
        QFileInfo fileInfo(list[0]);

        addFileRecord({ fileInfo.fileName(), fileInfo.path(), 
            getFileLastWriteTime(list[0])/*fileInfo.lastModified().toString("yyyy-MM-dd HH:mm:ss")*/,
            getFileSize(list[0].toStdString()), list[1] });
    }

    emit searchCompleted(this->rowCount());
    emit dataStatusChanged(this->rowCount() == 0);

    qDebug() << "end of setting results";
    qint64 elapsed = timer.elapsed();
    qDebug() << "qDebug() took" << elapsed << "ms";
}

QString SearchModel::enumToQString(FileType fileType)
{
    QMetaEnum metaEnum = QMetaEnum::fromType<SearchModel::FileType>();
    return metaEnum.valueToKey(fileType);
}

QString SearchModel::getFileLastWriteTime(const QString& filePath) {
    struct statx statxbuf;
    // Use statx to retrieve file state; STATX_MTIME is used to obtain the last modification time.
    if (statx(AT_FDCWD, filePath.toStdString().c_str(), AT_STATX_SYNC_AS_STAT, STATX_MTIME, &statxbuf) != 0) {
        qCritical() << "Failed to get file last write time: " << filePath;
        return "-";
    }

    time_t last_write_time = statxbuf.stx_mtime.tv_sec;
    char time_string[std::size("yyyy-MM-dd HH:mm:ss")];
    std::strftime(std::data(time_string), std::size(time_string), "%F %T", std::localtime(&last_write_time));
    return time_string;
}

QString SearchModel::getFileSize(const std::filesystem::path& path) {
    namespace fs = std::filesystem;
    std::error_code ec;
    if (auto regular = fs::is_regular_file(path, ec); !ec) {
        if (auto size = fs::file_size(path, ec); !ec) {
            const double thresholds[] = {1, 1024.0, 1024.0 * 1024.0, 1024.0 * 1024.0 * 1024.0, 1024.0 * 1024.0 * 1024.0 * 1024.0};
            const char* units[] = { " bytes", " KB", " MB", " GB", " TB" };

            const size_t buf_size = 10;
            char buf[buf_size]{};
            for (int i = sizeof(thresholds) / sizeof(double) - 1; i >= 0; --i) {
                if (size >= thresholds[i]) {
                    auto [ptr, ec] = std::to_chars(buf, buf + buf_size, size / thresholds[i], std::chars_format::fixed, 1);
                    if (ec == std::errc{}) {
                        return QString::fromStdString(std::string(buf, ptr - buf) + units[i]);
                    }
                }
            }
        }
    }

    return "-";
}