#ifndef SEARCH_CONTROLLER_H_
#define SEARCH_CONTROLLER_H_

#include <QObject>

#include "model/SearchModel.h"

class SearchController : public QObject
{
    Q_OBJECT
public:
    explicit SearchController(QObject* parent = nullptr);
    ~SearchController();

    Q_INVOKABLE SearchModel* model() const;

    Q_INVOKABLE void search(const QString& path, const QString& keywords, int offset, int maxCount);
    
    Q_INVOKABLE void clear();

    Q_INVOKABLE void indexFilesInDirectory(const QString& directoryPath) const;

private:
    SearchModel* searchModel_;
};

#endif // SEARCH_CONTROLLER_H_