import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    property alias cfg_tempReaderURL: tempReaderURL.text
    property alias cfg_targetTemp: targetTemp.value

    GridLayout {
        columnSpacing: units.largeSpacing
        anchors.fill: parent
        columns: 2

        Text {
            text: "TempReader URL:"
            Layout.alignment: Qt.AlignRight
        }

        TextField {
            id: tempReaderURL
            Layout.fillWidth: true
            placeholderText: "http://"
        }

        Text {
            text: "Target temperature:"
            Layout.alignment: Qt.AlignRight
        }

        SpinBox {
            id: targetTemp
            minimumValue: 0
            maximumValue: 125
        }

        Text {
            text: ""
            Layout.fillHeight: true
        }
    }
}
