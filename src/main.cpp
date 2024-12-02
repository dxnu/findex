#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QLocale>
#include <QTranslator>
#include <QDebug>

#include "controller/SearchController.h"
#include "model/FileMonitor.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qDebug() << "Qt Version:" << QT_VERSION_STR;

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString& locale : uiLanguages) {
        const QString baseName = "findex_" + QLocale(locale).name();
        if (translator.load(":/translations/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    qmlRegisterType<SearchModel>("com.search.model", 1, 0, "SearchModel");
    SearchController* searchController = new SearchController(&engine);
    FileMonitor* logFileMonitor = new FileMonitor(&engine);

    QQmlContext* context = engine.rootContext();
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
