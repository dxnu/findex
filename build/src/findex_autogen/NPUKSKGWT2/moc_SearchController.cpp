/****************************************************************************
** Meta object code from reading C++ file 'SearchController.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.11.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../src/controller/SearchController.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'SearchController.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.11.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_SearchController_t {
    QByteArrayData data[9];
    char stringdata0[75];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_SearchController_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_SearchController_t qt_meta_stringdata_SearchController = {
    {
QT_MOC_LITERAL(0, 0, 16), // "SearchController"
QT_MOC_LITERAL(1, 17, 5), // "model"
QT_MOC_LITERAL(2, 23, 12), // "SearchModel*"
QT_MOC_LITERAL(3, 36, 0), // ""
QT_MOC_LITERAL(4, 37, 6), // "search"
QT_MOC_LITERAL(5, 44, 4), // "path"
QT_MOC_LITERAL(6, 49, 8), // "keywords"
QT_MOC_LITERAL(7, 58, 6), // "offset"
QT_MOC_LITERAL(8, 65, 9) // "max_count"

    },
    "SearchController\0model\0SearchModel*\0"
    "\0search\0path\0keywords\0offset\0max_count"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_SearchController[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       2,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    0,   24,    3, 0x02 /* Public */,
       4,    4,   25,    3, 0x02 /* Public */,

 // methods: parameters
    0x80000000 | 2,
    QMetaType::QStringList, QMetaType::QString, QMetaType::QString, QMetaType::Int, QMetaType::Int,    5,    6,    7,    8,

       0        // eod
};

void SearchController::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        SearchController *_t = static_cast<SearchController *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: { SearchModel* _r = _t->model();
            if (_a[0]) *reinterpret_cast< SearchModel**>(_a[0]) = std::move(_r); }  break;
        case 1: { QStringList _r = _t->search((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3])),(*reinterpret_cast< int(*)>(_a[4])));
            if (_a[0]) *reinterpret_cast< QStringList*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject SearchController::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_SearchController.data,
      qt_meta_data_SearchController,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *SearchController::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SearchController::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_SearchController.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int SearchController::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 2)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 2)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 2;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
