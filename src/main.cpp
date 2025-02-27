#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

#include "controller/FileController.h"
#include "controller/LanguageController.h"
#include "controller/SearchController.h"
#include "model/FileMonitor.h"


int main(int argc, char *argv[])
{
    qDebug() << "Qt Version:" << QT_VERSION_STR;
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<SearchModel>("com.search.model", 1, 0, "SearchModel");
    LanguageController* languageController = new LanguageController(&engine);
    SearchController* searchController = new SearchController(&engine);
    FileController* fileController = new FileController(&engine);
    FileMonitor* logFileMonitor = new FileMonitor(&engine);

    QQmlContext* context = engine.rootContext();
    context->setContextProperty("languageController", languageController);
    context->setContextProperty("fileController", fileController);
    context->setContextProperty("searchController", searchController);
    context->setContextProperty("logFileMonitor", logFileMonitor);

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}