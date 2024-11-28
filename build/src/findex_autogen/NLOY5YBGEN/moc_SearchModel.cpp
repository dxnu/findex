/****************************************************************************
** Meta object code from reading C++ file 'SearchModel.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.11.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../src/model/SearchModel.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'SearchModel.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.11.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_SearchModel_t {
    QByteArrayData data[7];
    char stringdata0[63];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_SearchModel_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_SearchModel_t qt_meta_stringdata_SearchModel = {
    {
QT_MOC_LITERAL(0, 0, 11), // "SearchModel"
QT_MOC_LITERAL(1, 12, 8), // "FileType"
QT_MOC_LITERAL(2, 21, 7), // "Unknown"
QT_MOC_LITERAL(3, 29, 4), // "File"
QT_MOC_LITERAL(4, 34, 9), // "Directory"
QT_MOC_LITERAL(5, 44, 7), // "Symlink"
QT_MOC_LITERAL(6, 52, 10) // "Executable"

    },
    "SearchModel\0FileType\0Unknown\0File\0"
    "Directory\0Symlink\0Executable"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_SearchModel[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       0,    0, // properties
       1,   14, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // enums: name, flags, count, data
       1, 0x0,    5,   18,

 // enum data: key, value
       2, uint(SearchModel::Unknown),
       3, uint(SearchModel::File),
       4, uint(SearchModel::Directory),
       5, uint(SearchModel::Symlink),
       6, uint(SearchModel::Executable),

       0        // eod
};

void SearchModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    Q_UNUSED(_o);
    Q_UNUSED(_id);
    Q_UNUSED(_c);
    Q_UNUSED(_a);
}

QT_INIT_METAOBJECT const QMetaObject SearchModel::staticMetaObject = {
    { &QAbstractListModel::staticMetaObject, qt_meta_stringdata_SearchModel.data,
      qt_meta_data_SearchModel,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *SearchModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SearchModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_SearchModel.stringdata0))
        return static_cast<void*>(this);
    return QAbstractListModel::qt_metacast(_clname);
}

int SearchModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QAbstractListModel::qt_metacall(_c, _id, _a);
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
