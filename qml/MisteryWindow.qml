import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.2

import "colors.js" as Styling
import "fontawesome.js" as FontAwesome

ApplicationWindow {
    id: applicationWindow
    visible: true

    height: Screen.height * 0.75
    width: Screen.width * 0.75

    property var browserTabs: []
    property var browsers: []

    Component.onCompleted: {
        setX(Screen.width / 2 - width / 2)
        setY(Screen.height / 2 - height / 2)

        browserTabs = [walletBrowserMenuItem, chainBrowserMenuItem, accountDAppMenuItem]
        browsers = [walletBrowser, chainBrowser, accountDAppBrowser]

        setActiveTab(2)
    }

    FontLoader {
        id: fontAwesomeFontLoader
        source: "fontawesome-webfont.ttf"
    }

    Rectangle {
        id: mainPanel

        anchors.fill: parent
        color: "black"

        property bool menu_shown: false

        Rectangle {
            id: sideMenu
            anchors.fill: parent
            color: Styling.sidebarMenu.backgroundColor
            opacity: mainPanel.menu_shown ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 300 } }

            ListView {
                anchors { fill: parent; margins: 22 }
                model: 8
                delegate: Item {
                    height: Styling.sidebarMenu.itemHeight
                    width: parent.width;
                    Text {
                        anchors { left: parent.left; leftMargin: 12; verticalCenter: parent.verticalCenter }
                        color: "white"
                        font.pixelSize: 12
                        text: "This is menu #" + index
                    }

                    Rectangle {
                        height: 2;
                        width: parent.width * 0.7;
                        color: "gray";
                        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
                    }
                }
            }
        }

        Rectangle {
            id: defaultView
            anchors.fill: parent
            color: "white"

            transform: Translate {
                id: game_translate_
                x: 0
                Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutQuad } }
            }

            Rectangle {
                id: menu_bar_
                anchors.top: parent.top
                width: parent.width
                height: Styling.topMenu.height
                color: Styling.topMenu.backgroundColor

                Row {
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }

                    spacing: 20

                    TopMenuItem {
                        id: menuMenuItem
                        text: FontAwesome.Icon.List
                        height: Styling.topMenu.height
                        visible: true

                        onClicked: mainPanel.onMenu()
                    }

                    TopMenuItem {
                        id: walletBrowserMenuItem
                        text: 'wallet'
                        height: Styling.topMenu.height
                        onEntered: setActiveTab(0)
                    }

                    TopMenuItem {
                        id: chainBrowserMenuItem
                        text: 'chain'
                        height: Styling.topMenu.height
                        onEntered: setActiveTab(1)
                    }

                    TopMenuItem {
                        id: accountDAppMenuItem
                        text: 'accounts'
                        height: Styling.topMenu.height
                        onEntered: setActiveTab(2)
                    }
                }
            }

            BrowserComponent {
                id: walletBrowser
                visible: false
                anchors {
                    top: menu_bar_.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    margins: 0
                }
                url: "http://ethereum-dapp-wallet.meteor.com/"
            }

            BrowserComponent {
                id: chainBrowser
                visible: false
                anchors {
                    top: menu_bar_.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    margins: 0
                }
                url: "http://etherchain.org"
            }

            BrowserComponent {
                id: accountDAppBrowser
                visible: false
                anchors {
                    top: menu_bar_.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    margins: 0
                }
                url: "qrc:/account-dapp/index.html"
            }
        }

        /* this functions toggles the menu and starts the animation */
        function onMenu() {
            game_translate_.x = mainPanel.menu_shown ? 0 : 200
            mainPanel.menu_shown = !mainPanel.menu_shown;
        }
    }

    function setActiveTab(index) {
        for (var i = 0; i < browsers.length; i++) {
            browsers[i].visible = (i == index)
            browserTabs[i].setActive(i == index)
        }
    }
}
