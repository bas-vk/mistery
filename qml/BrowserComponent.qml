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
                runJavaScript("var scrpt = document.createElement('script'); scrpt.setAttribute('type','text/javascript'); scrpt.setAttribute('src','qrc:/resources/dapps/qtwebchannel.js'); document.head.appendChild(scrpt);")
                runJavaScript("var scrpt = document.createElement('script'); scrpt.setAttribute('type','text/javascript'); scrpt.setAttribute('src','qrc:/resources/dapps/misteryProvider.js'); document.head.appendChild(scrpt);")
                runJavaScript("var scrpt = document.createElement('script'); scrpt.setAttribute('type','text/javascript'); scrpt.setAttribute('src','qrc:/resources/dapps/web3.js'); document.head.appendChild(scrpt);")

                runJavaScript("var web3 = new Web3(); web3.setProvider(new MisteryProvider());", function(err) {
                 console.log("err: ", err)
                }
                    )
                console.log("set mistery provider for browser: ", parent.url)
            }
        }
    }
}
