import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

Item {
    property bool checking: false
    property bool dialog_opened: false
    property int interval_long: 10000
    property int interval_short: 1000

    property string temp_url: Plasmoid.configuration.tempReaderURL
    property int target_temp: Plasmoid.configuration.targetTemp

    GridLayout {
        anchors.fill: parent

        Text {
            id: currentTemp
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: "???"
            font.weight: Font.Normal
            font.pointSize: 72
            padding: 10
            minimumPointSize: 10
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    MessageDialog {
        id: messageDialog
        title: "Temp Reader"
        text: "Target temperature of " + target_temp + " °C has been reached."
        onAccepted: {
            dialog_opened = false;
            currentTemp.color = "black";
            currentTemp.font.weight = Font.Normal;
        }
    }

    MouseArea {
        anchors.fill: parent;
        onClicked: {
            currentTemp.color = "gray";
            currentTemp.font.weight = Font.Normal;
            readData()
        }

        PlasmaCore.ToolTipArea {
            anchors.fill: parent
            subText: {
                "Current temperature: " + currentTemp.text + "\n" +
                "Target temperature: " + target_temp + " °C\n" +
                "Update interval: " + textTimer.interval/1000 + " s\n" +
                "URL: " + temp_url
            }
        }
    }

    Timer {
        id: textTimer
        interval: interval_long
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: readData()
    }

    function readData() {
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if (request.readyState == XMLHttpRequest.DONE) {
                if (request.status == 200) {
                    var j = JSON.parse(request.responseText);
                    var t = Number(j.temp).toFixed(1);

                    currentTemp.text = t + " °C";

                    if (t > target_temp) {
                        checking = true;
                        textTimer.interval = interval_short;
                        currentTemp.font.weight = Font.Bold;
                        currentTemp.color = "red";
                    } else if (t <= target_temp && checking) {
                        checking = false;
                        messageDialog.open();
                        dialog_opened = true;
                        textTimer.interval = interval_long;
                        currentTemp.color = "green";
                    } else if (! dialog_opened) {
                        currentTemp.color = "black";
                    }
                } else {
                    currentTemp.color = "gray";
                    currentTemp.font.weight = Font.Normal;
                }
            }
        }

        request.open("GET", temp_url);
        request.send();
    }
}
