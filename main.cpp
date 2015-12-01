#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngine/QtWebEngine>
#include <QtWebChannel/QtWebChannel>

#include "ipcprovider.h"

int main(int argc, char *argv[])
{
#ifdef QT_DEBUG
    qputenv("QTWEBENGINE_REMOTE_DEBUGGING", "3333");
#endif

    QGuiApplication app(argc, argv);
    QtWebEngine::initialize();

    qmlRegisterType<IPCProvider, 1>("world.ether", 1, 0, "IPCProvider");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/resources/qml/MisteryWindow.qml")));

    return app.exec();
}
