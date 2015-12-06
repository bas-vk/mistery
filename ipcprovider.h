#ifndef IPCPROVIDER_H
#define IPCPROVIDER_H

#include <QObject>
#include <QJsonObject>
#include <QLocalSocket>

class IPCProvider : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(bool isConnected READ connected NOTIFY isConnectedChanged);

public:
    explicit IPCProvider(QObject *parent = 0);
    virtual ~IPCProvider();

    // Send a request to the Ethereum node.
    Q_INVOKABLE void send(const QString& request);

    // Indication if the ipc provider is connected to a node.
    bool connected() const;

signals:
    // is fired each time the provider receives a chunck of data. It's up to the receiver
    // to dechunck the data.
    void message(const QString& chunck);

    // fired when the connection to the node is established, lost or restored.
    void isConnectedChanged();

private slots:
    void socketConnected();
    void socketDisconnected();
    void socketError(QLocalSocket::LocalSocketError);
    void readResponse();

private:
    // try to (re)connect to the Ethereum node
    void connectToNode();

    bool _isConnected; // keeps track if the connection to the node is open
    QLocalSocket* _socket;
};

#endif // IPCPROVIDER_H
