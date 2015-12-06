import QtQuick 2.5
import QtQuick.Layouts 1.1

import "colors.js" as Styling

Item {
    id: topMenuItem
    property alias text: itemText.text

    signal clicked
    signal entered

    width: itemText.paintedWidth + 20

    FontLoader {
        source: "fontawesome-webfont.ttf"
    }

    function setActive(active) {
        itemText.color = active ? "#ffffff" : "#cccccc";
        itemMarker.color = active ? Styling.topMenu.markerColor : Styling.topMenu.backgroundColor;
    }

    ColumnLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.bottom: parent.bottom
        spacing: 0

        Text {
            id: itemText
            height: topMenuItem.height
            color: "#cccccc"
            Layout.alignment: Qt.AlignCenter

            font.capitalization: Font.AllUppercase
            font.family: "FontAwesome"
        }


        Rectangle {
            id: itemMarker
            height: Styling.topMenu.markerHeight
            width: topMenuItem.width
            color: Styling.topMenu.backgroundColor
            Layout.alignment: Qt.AlignCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: { parent.clicked() }
        onEntered: { parent.entered() }
    }
}
