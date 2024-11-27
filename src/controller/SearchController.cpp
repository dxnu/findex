#include "SearchController.h"

SearchController::SearchController(QObject* parent)
    : QObject(parent)
{
    searchModel_ = new SearchModel();
}

Q_INVOKABLE SearchModel *SearchController::model() const
{
    return searchModel_;
}

Q_INVOKABLE QStringList SearchController::search(const QString &path, const QString &keywords, int offset, int max_count)
{
    return searchModel_->search(path, keywords, offset, max_count);
}
