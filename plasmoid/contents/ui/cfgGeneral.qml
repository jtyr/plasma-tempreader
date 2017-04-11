import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    property alias cfg_tempReaderURL: tempReaderURL.text
    property alias cfg_tempThreshold: tempThreshold.value
    property alias cfg_soundEnabled: soundEnabled.checked
    property alias cfg_soundURL: soundURL.text
    property alias cfg_soundLoops: soundLoops.value
    property alias cfg_notificationEnabled: notificationEnabled.checked
    property alias cfg_notificationTimeout: notificationTimeout.value

    GridLayout {
        width: parent.width
        columns: 2

        Text {
            text: "Sensor endpoint:"
            Layout.alignment: Qt.AlignRight
        }

        TextField {
            id: tempReaderURL
            Layout.fillWidth: true
            placeholderText: "http://"
        }

        Text {
            text: "Threshold temperature:"
            Layout.alignment: Qt.AlignRight
        }

        SpinBox {
            id: tempThreshold
            minimumValue: 0
            maximumValue: 125
        }

        Text {
            text: "Notification sound"
            font.weight: Font.Bold
            topPadding: 10
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignLeft
        }

        Text {
            text: "Enabled:"
            Layout.alignment: Qt.AlignRight
        }

        CheckBox {
            id: soundEnabled
        }

        Text {
            text: "Custom file:"
            Layout.alignment: Qt.AlignRight
        }

        TextField {
            id: soundURL
            enabled: soundEnabled.checked
            Layout.fillWidth: true
            placeholderText: "Path to WAV or MP3 file..."
        }

        Text {
            text: "Loops:"
            Layout.alignment: Qt.AlignRight
        }

        SpinBox {
            id: soundLoops
            enabled: soundEnabled.checked
            minimumValue: 1
            maximumValue: 100
        }

        Text {
            text: "Notification message"
            font.weight: Font.Bold
            topPadding: 10
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignLeft
        }

        Text {
            text: "Enabled:"
            Layout.alignment: Qt.AlignRight
        }

        CheckBox {
            id: notificationEnabled
        }

        Text {
            text: "Timeout:"
            Layout.alignment: Qt.AlignRight
        }

        SpinBox {
            id: notificationTimeout
            enabled: notificationEnabled.checked
            minimumValue: 1
            maximumValue: 3600
        }
    }
}
