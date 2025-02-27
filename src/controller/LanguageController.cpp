#include "LanguageController.h"

#include "model/Translator.h"

LanguageController::LanguageController(QQmlEngine* engine)
    : translator_(new Translator(engine)) {}

bool LanguageController::switchLanguage(const QString& locale)
{
    return translator_->switchLanguage(locale);
}

void LanguageController::resetLanguage()
{
    translator_->resetLanguage();
}
