#include "ipcprovider.h"
#include <QDebug>
#include <QTextStream>
#include <QSysInfo>
#include <QStandardPaths>
#include <QDir>

IPCProvider::IPCProvider(QObject *parent) : QObject(parent), _isConnected(false), _socket(nullptr)
{
    _socket = new QLocalSocket;

    connect(_socket, SIGNAL(connected()), this, SLOT(socketConnected()));
    connect(_socket, SIGNAL(disconnected()), this, SLOT(socketDisconnected()));
    connect(_socket, SIGNAL(readyRead()), this, SLOT(readResponse()));
    connect(_socket, SIGNAL(error(QLocalSocket::LocalSocketError)), this, SLOT(socketError(QLocalSocket::LocalSocketError)));

    QString path;
    auto productType(QSysInfo::productType());
    if (productType == "windows") {
       path = "\\\\.\\pipe\\geth.ipc";
    } else if (productType == "osx") {
        path = QDir::homePath() + "/Library/Ethereum/geth.ipc";
    } else { // linux
        path = QDir::homePath() + "/.ethereum/geth.ipc";
    }

    qDebug() << "IPC endpoint: " << QStandardPaths::HomeLocation << " " << path;

    _socket->connectToServer(path);
}
IPCProvider::~IPCProvider() {
    if (_socket) {
        delete _socket;
    }
}

void IPCProvider::socketConnected() {
    _isConnected = true;
    emit isConnectedChanged();
}

void IPCProvider::socketDisconnected() {
    _isConnected = false;
    emit isConnectedChanged();
}

bool IPCProvider::connected() const {
    return _isConnected;
}

void IPCProvider::send(const QString& msg) {
    QTextStream ts(_socket);
    ts << msg;
}

void IPCProvider::readResponse() {
    QTextStream in(_socket);
    emit message(in.readAll());
}

void IPCProvider::socketError(QLocalSocket::LocalSocketError socketError) {
    switch (socketError) {
    case QLocalSocket::ServerNotFoundError:
        qDebug() << tr("The host was not found. Please check the host name and port settings.");
        break;
    case QLocalSocket::ConnectionRefusedError:
        qDebug() << tr("The connection was refused by the peer. Make sure the node is running, "
                       "and check that the endpoint is correct.");
        break;
    case QLocalSocket::PeerClosedError:
        break;
    default:
        qDebug() << tr("The following error occurred: ") << _socket->errorString();
    }
}

