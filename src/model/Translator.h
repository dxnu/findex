#ifndef TRANSLATOR_H
#define TRNASLATOR_H

#include <QObject>
#include <QTranslator>
#include <QQmlEngine>

class Translator : public QObject {
    Q_OBJECT
public:
    explicit Translator(QQmlEngine* engine);

    bool switchLanguage(const QString& locale);

    void resetLanguage();

private:
    QQmlEngine* engine_;
    QTranslator* translator_;
};

#endif // TRNASLATOR_H