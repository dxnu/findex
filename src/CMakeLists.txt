set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

file(GLOB SOURCE_FILES *.cpp controller/*.cpp model/*.cpp)
# list(LENGTH SOURCE_FILES SRC_FILES_SIZE)
# message(STATUS "Found ${SRC_FILES_SIZE} source files of examples")
# foreach(source_file ${SOURCE_FILES})
#     message(STATUS " ${source_file}")
# endforeach()

set(PROJECT_SOURCES
    ${SOURCE_FILES}
    ${RC_FILES}
)

message(STATUS "SOURCES: ${PROJECT_SOURCES}")

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
    message(STATUS "Generated QM_FILES: ${QM_FILES}")
    qt_add_executable(findex
        ${PROJECT_SOURCES}
        ${QM_FILES}
    )
    message(STATUS "Qt Version: Qt6")
else()
    qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
    add_executable(findex
        ${PROJECT_SOURCES}
        ${QM_FILES}
    )
    message(STATUS "Qt Version: Qt5")
endif()

target_include_directories(findex PRIVATE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)
target_link_libraries(findex PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::DBus
    Qt${QT_VERSION_MAJOR}::Quick
)

# install(TARGETS findex DESTINATION bin)