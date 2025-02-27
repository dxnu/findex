#include "Translator.h"

#include <QGuiApplication>

Translator::Translator(QQmlEngine* engine)
    : engine_(engine), translator_(new QTranslator(this))
{
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString& locale : uiLanguages) {
        if (switchLanguage(QLocale(locale).name())) {
            break;
        }
    }
}

bool Translator::switchLanguage(const QString& locale)
{
    if (translator_->load(":/translations/findex_" + locale)) {
        qApp->installTranslator(translator_);
        engine_->retranslate();
        return true;
    } else {
        qDebug() << "failed to load " << locale;
    }

    return false;
}

void Translator::resetLanguage()
{
    qDebug() << __func__;
    qApp->removeTranslator(translator_);
    engine_->retranslate();
}
