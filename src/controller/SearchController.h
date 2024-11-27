#ifndef SEARCH_CONTROLLER_H_
#define SEARCH_CONTROLLER_H_

#include <QObject>

#include "model/SearchModel.h"

class SearchController : public QObject
{
    Q_OBJECT
public:
    explicit SearchController(QObject* parent = nullptr);

    Q_INVOKABLE SearchModel* model() const;

    Q_INVOKABLE QStringList search(const QString& path, const QString& keywords, int offset, int max_count);

private:
    SearchModel* searchModel_;
};

#endif // SEARCH_CONTROLLER_H_