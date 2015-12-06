import QtQuick 2.0
import QtWebEngine 1.1
import QtWebChannel 1.0
import world.ether 1.0

Item {
    id: tabComponent

    property alias url: webEngineView.url

    IPCProvider {
        id: misteryIPCProvider
        WebChannel.id: "misteryProvider"
    }

    WebEngineView {
        id: webEngineView
        focus: true
        anchors.fill: parent

        webChannel.registeredObjects: [misteryIPCProvider]

        onLoadingChanged: {
            console.log("onLoadingChanged: status=" + loadRequest.status);
            if (loadRequest.status == WebEngineView.LoadStartedStatus)
                console.log("Loading started...");
            if (loadRequest.status == WebEngineView.LoadFailedStatus) {
                console.log("Load failed! Error code: " + loadRequest.errorCode);

                if (loadRequest.errorCode === NetworkReply.OperationCanceledError)
                    console.log("Load cancelled by user");
            }

            if (loadRequest.status == WebEngineView.LoadSucceededStatus) {
                /*
                runJavaScript("web3 = new Web3(); web3.setProvider(new MisteryProvider());", function(err) {
                    if (err) {
                        console.log("err: ", err)
                    }
                })
                console.log("set mistery provider for browser: ", parent.url)
                */
            }
        }

        onJavaScriptConsoleMessage: {
            console.log(sourceID, ":", lineNumber, "(", level, ")", message);
        }
    }
}
