#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QLocale>
#include <QTranslator>
#include <QDebug>

#include "controller/FileController.h"
#include "controller/SearchController.h"
#include "model/FileMonitor.h"

int main(int argc, char *argv[])
{
    qDebug() << "Qt Version:" << QT_VERSION_STR;
    QGuiApplication app(argc, argv);

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString& locale : uiLanguages) {
        // const QString baseName = "findex_" + QLocale(locale).name();
        if (translator.load(":/translations/findex_zh_CN"/* + baseName*/)) {
            qDebug() << "load translator";
            app.installTranslator(&translator);
            break;
        }
    }

    QQmlApplicationEngine engine;
    qmlRegisterType<SearchModel>("com.search.model", 1, 0, "SearchModel");
    SearchController* searchController = new SearchController(&engine);
    FileController* fileController = new FileController(&engine);
    FileMonitor* logFileMonitor = new FileMonitor(&engine);

    QQmlContext* context = engine.rootContext();
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