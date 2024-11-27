#ifndef SEARCH_MODEL_H_
#define SEARCH_MODEL_H_

#include <QObject>
#include <QStringList>

class SearchModel : public QObject {
    Q_OBJECT
public:
    explicit SearchModel(QObject* parent = nullptr);

    QStringList search(const QString& path, const QString& keywords, int offset, int maxCount);
};

#endif // SEARCH_MODEL_H_