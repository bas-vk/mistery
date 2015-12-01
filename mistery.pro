TEMPLATE = app

QT += qml quick webengine widgets webenginewidgets webchannel
CONFIG += c++11

SOURCES += main.cpp \
    ipcprovider.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    constants.js

HEADERS += \
    ipcprovider.h

