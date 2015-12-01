import QtQuick 2.1
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

import "constants.js" as Constants
import "fontawesome.js" as FontAwesome

ApplicationWindow {
    id: applicationWindow
    visible: true

    height: Screen.height * 0.75
    width: Screen.width * 0.75

    Component.onCompleted: {
        setX(Screen.width / 2 - width / 2)
        setY(Screen.height / 2 - height / 2)

        setActiveTab(testBrowser);
    }

    FontLoader {
        id: fontAwesomeFontLoader
        source: "fontawesome-webfont.ttf"
    }

    Rectangle {
        id: topBar
        color: Constants.TopBarColor
        anchors.left: applicationWindow.left
        anchors.right: applicationWindow.right

        height: Constants.TopBarHeight
        width: applicationWindow.width

        Row { // The "Row" type lays out its child items in a horizontal line
            anchors.left: parent.left
            anchors.right: parent.right

            spacing: 20 // Places 20px of space between items

            TopMenuItem {
                id: menuMenuItem
                text: FontAwesome.Icon.List
                height: topBar.height
                //onEntered: { setActiveTab(blockChainBrowser) }
            }
            TopMenuItem {
                id: testBrowserMenuItem
                text: 'test'
                height: topBar.height
                onEntered: { setActiveTab(testBrowser) }
            }
            TopMenuItem {
                id: browserMenuItem
                text: 'browse'
                height: topBar.height
                onEntered: { setActiveTab(browserBrowser) }
            }
            TopMenuItem {
                id: dappStoreMenuItem
                text: 'DApp store'
                height: topBar.height
                onEntered: { setActiveTab(dappStoreBrowser) }
            }
            TopMenuItem {
                id: walletMenuItem
                text: 'walleth'
                height: topBar.height
                onEntered: { setActiveTab(walletBrowser) }
            }
            TopMenuItem {
                id: blockChainMenuItem
                text: 'blockchain'
                height: topBar.height
                onEntered: { setActiveTab(blockChainBrowser) }
            }
            TopMenuItem {
                id: rumourMenuItem
                text: 'rumour'
                height: topBar.height
                onEntered: { setActiveTab(rumourBrowser) }
            }
        }
    }

    BrowserComponent {
        id: testBrowser
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        visible: false
        url: "qrc:/resources/dapps/test.html"
    }

    BrowserComponent {
        id: browserBrowser
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        visible: false
        url: "http://google.com/"
    }

    BrowserComponent {
        id: dappStoreBrowser
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        visible: false
        url: "http://dappstore.io/"
    }

    BrowserComponent {
        id: walletBrowser
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        visible: false
        url: "http://ethereum-dapp-wallet.meteor.com/"
    }

    BrowserComponent {
        id: blockChainBrowser
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        visible: false
        url: "http://etherchain.org"
    }

    BrowserComponent {
        id: rumourBrowser
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        visible: false
        url: "http://nos.nl"
    }

    function setActiveTab(browser) {
        testBrowser.visible = false;
        testBrowserMenuItem.setActive(false);

        walletBrowser.visible = false;
        walletMenuItem.setActive(false);

        blockChainMenuItem.setActive(false);
        blockChainBrowser.visible = false;

        dappStoreMenuItem.setActive(false);
        dappStoreBrowser.visible = false;

        browserMenuItem.setActive(false);
        browserBrowser.visible = false;

        rumourMenuItem.setActive(false);
        rumourBrowser.visible = false;

        if (testBrowser == browser) {
            testBrowserMenuItem.setActive(true);
            testBrowser.visible = true;
        }

        if (walletBrowser == browser) {
            walletMenuItem.setActive(true);
            walletBrowser.visible = true;
        }

        if (blockChainBrowser == browser) {
            blockChainMenuItem.setActive(true);
            blockChainBrowser.visible = true;
        }

        if (dappStoreBrowser == browser) {
            dappStoreMenuItem.setActive(true);
            dappStoreBrowser.visible = true;
        }

        if (browserBrowser == browser) {
            browserMenuItem.setActive(true);
            browserBrowser.visible = true;
        }

        if (rumourBrowser == browser) {
            rumourMenuItem.setActive(true);
            rumourBrowser.visible = true;
        }
    }

    statusBar: StatusBar {
        RowLayout {
            anchors.fill: parent
            Label {
                text: FontAwesome.Icon.Cube + " #12345"
            }
            Label {
                text:  "Read Only"
            }
        }
    }
}

