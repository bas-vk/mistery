TEMPLATE = app

QT += qml quick webengine widgets webenginewidgets webchannel
CONFIG += c++11

SOURCES += main.cpp \
    ipcprovider.cpp \
    accountmanager.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    constants.js \
    dapps/account/index.html

HEADERS += \
    ipcprovider.h \
    accountmanager.h

