#include "SearchController.h"

SearchController::SearchController(QObject* parent)
    : QObject(parent), searchModel_(new SearchModel(this)) {}

SearchModel* SearchController::model() const
{
    return searchModel_;
}

void SearchController::search(const QString& path, const QString& keywords, int offset, int max_count)
{
    searchModel_->search(path, keywords, offset, max_count);
}

void SearchController::search(const QString& path, const QString& keywords)
{
    searchModel_->search(path, keywords);
}

void SearchController::async_search(const QString& keywords)
{
    searchModel_->async_search(keywords);
}

int SearchController::size() const
{
    return searchModel_->rowCount();
}

bool SearchController::empty() const
{
    return size() == 0;
}

QString SearchController::cacheDirectory() const
{
    return searchModel_->cacheDirectory();
}

void SearchController::clear()
{
    searchModel_->clear();
}

void SearchController::indexFilesInDirectory(const QString& directoryPath) const
{
    searchModel_->indexFilesInDirectory(directoryPath);
}
