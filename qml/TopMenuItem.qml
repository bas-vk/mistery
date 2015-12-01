import QtQuick 2.0

Item {
    property alias text: itemText.text

    signal clicked
    signal entered

    width: itemText.paintedWidth + 20

    FontLoader {
        source: "fontawesome-webfont.ttf"
    }

    function setActive(active) {
        itemText.color = active ? "#ffffff" : "#cccccc";

    }

    Text {
        id: itemText
        color: "#cccccc"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.capitalization: Font.AllUppercase
        font.family: "FontAwesome"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: { parent.clicked() }
        onEntered: { parent.entered() }
    }
}
