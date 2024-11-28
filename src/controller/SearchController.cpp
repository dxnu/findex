#include "SearchController.h"

#include <QDebug>

SearchController::SearchController(QObject* parent)
    : QObject(parent)
{
    qDebug() << "SearchModel created:" << this;
    searchModel_ = new SearchModel(this);
}

SearchController::~SearchController()
{
    qDebug() << "SearchController destroyed:" << this;
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
