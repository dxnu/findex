#ifndef FILE_CONTROLLER_H
#define FILE_CONTROLLER_H

#include <QObject>

class FileController : public QObject
{
    Q_OBJECT

public:
    explicit FileController(QObject* parent = nullptr);

    Q_INVOKABLE bool openExternally(const QString& file);
};

#endif // FILE_CONTROLLER_H