import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    property alias cfg_tempReaderURL: tempReaderURL.text
    property alias cfg_tempThreshold: tempThreshold.value
    property alias cfg_widgetLabel: widgetLabel.text
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

        RowLayout {
            SpinBox {
                id: tempThreshold
                minimumValue: 0
                maximumValue: 125
            }

            Text {
                text: "°C"
            }
        }

        Text {
            text: "Widget label:"
            Layout.alignment: Qt.AlignRight
        }

        TextField {
            id: widgetLabel
            Layout.fillWidth: true
        }

        Text {
            text: "Notification sound"
            font.weight: Font.Bold
            topPadding: 10
            Layout.columnSpan: 2
        }

        Text {
            text: "Enabled:"
            Layout.alignment: Qt.AlignRight
        }

        CheckBox {
            id: soundEnabled
        }

        Text {
            text: "Custom sound:"
            Layout.alignment: Qt.AlignRight
        }

        RowLayout {
            Layout.fillWidth: true

            TextField {
                id: soundURL
                enabled: soundEnabled.checked
                Layout.fillWidth: true
                placeholderText: "Path to WAV or MP3 file..."
            }

            Button {
                text: "Open"
                enabled: soundEnabled.checked
                onClicked: {
                    fileDialog.open();
                }
            }
        }

        FileDialog {
            id: fileDialog
            title: "Please choose a file"
            folder: shortcuts.home
            onAccepted: {
                soundURL.text = fileDialog.fileUrl;
            }
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

        RowLayout {
            SpinBox {
                id: notificationTimeout
                enabled: notificationEnabled.checked
                minimumValue: 1
                maximumValue: 3600
            }

            Text {
                text: "s"
            }
        }
    }
}
