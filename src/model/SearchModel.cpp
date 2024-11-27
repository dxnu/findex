#include "SearchModel.h"

#include <QtDBus>

SearchModel::SearchModel(QObject* parent)
    : QObject(parent) {}

QStringList SearchModel::search(const QString& path, const QString& keywords, int offset, int maxCount)
{
    // qDebug() << path << "," << keywords << "," << offset << "," << max_count;
    if (!QDBusConnection::systemBus().isConnected()) {
        qCritical() << "Cannot connect to the D-Bus session bus.\n";
        return {};
    }

    QDBusInterface iface("my.test.SAnything", "/my/test/OAnything", "my.test.IAnything", QDBusConnection::systemBus());
    if (iface.isValid()) {
        QDBusReply<QStringList> reply = iface.call("search", path, keywords, offset, maxCount);
        if (reply.isValid()) {
            return reply.value();
        } else {
            qCritical() << "Call to search failed:" << qPrintable(reply.error().message());
        }
    }

    return {};
}