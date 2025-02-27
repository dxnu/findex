#ifndef LANGUAGE_CONTROLLER_H
#define LANGUAGE_CONTROLLER_H

#include <QObject>

class Translator;
class QQmlEngine;

class LanguageController : public QObject
{
    Q_OBJECT
public:
    explicit LanguageController(QQmlEngine* engine);

    Q_INVOKABLE bool switchLanguage(const QString& locale);

    Q_INVOKABLE void resetLanguage();

private:
    Translator* translator_;
};

#endif // LANGUAGE_CONTROLLER_H