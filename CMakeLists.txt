cmake_minimum_required(VERSION 3.14)

project(findex VERSION 0.1 LANGUAGES CXX)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick DBus LinguistTools)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick DBus LinguistTools)

set(TS_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/resources/translations/findex_zh_CN.ts
)

set(RC_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/resources/qml.qrc
)

add_compile_options(-fsanitize=address -g)
add_link_options(-fsanitize=address)

add_subdirectory(src)