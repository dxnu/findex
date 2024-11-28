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

Q_INVOKABLE void SearchController::search(const QString &path, const QString &keywords, int offset, int max_count)
{
    searchModel_->search(path, keywords, offset, max_count);
}

Q_INVOKABLE void SearchController::clear()
{
    searchModel_->clear();
}
