import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtMultimedia 5.8

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

Item {
    property bool checking: false
    property bool dialog_opened: false
    property int interval_long: 10000
    property int interval_short: 1000

    property string temp_url: Plasmoid.configuration.tempReaderURL
    property int temp_threshold: Plasmoid.configuration.tempThreshold
    property string widget_label: Plasmoid.configuration.widgetLabel
    property bool sound_enabled: Plasmoid.configuration.soundEnabled
    property string sound_URL: Plasmoid.configuration.soundURL
    property int sound_loops: Plasmoid.configuration.soundLoops
    property bool notification_enabled: Plasmoid.configuration.notificationEnabled
    property int notification_timeout: Plasmoid.configuration.notificationTimeout

    GridLayout {
        anchors.fill: parent
        rows: 2
        columns: 1

        Text {
            id: widgetLabel
            Layout.fillWidth: true
            text: widget_label
            topPadding: 3
            horizontalAlignment: Text.AlignHCenter
            visible: (widget_label.length > 0) ? true : false
        }

        Text {
            id: currentTemp
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: "???"
            font.weight: Font.Normal
            font.pointSize: 256
            padding: 5
            minimumPointSize: 10
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    SoundEffect {
        id: soundEffect
        source: (sound_URL.length > 0) ? sound_URL : "../sounds/notif.wav"
        loops: sound_loops
    }

    PlasmaCore.DataSource {
        id: notificationDataSource
        engine: "notifications"
        connectedSources: ["org.freedesktop.Notifications"]
        onSourceRemoved: {
            resetWidget();
            soundEffect.stop();
        }
    }

    function createNotification() {
        var service = notificationDataSource.serviceForSource("notification");
        var operation = service.operationDescription("createNotification");

        operation.appName = "Notification Example";
        operation.appIcon = "tempreader";
        operation.summary = "Temp Reader";
        operation.body = "Temperature threshold of " + temp_threshold + " °C has been reached.";
        operation.expireTimeout = notification_timeout * 1000;

        service.startOperationCall(operation);
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
                "Threshold: " + temp_threshold + " °C\n" +
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

    function resetWidget() {
        dialog_opened = false;
        currentTemp.color = "black";
        currentTemp.font.weight = Font.Normal;
    }

    Timer {
        id: resetWidgetTimer
        interval: interval_long
        onTriggered: resetWidget()
    }

    function readData() {
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if (request.readyState == XMLHttpRequest.DONE) {
                if (request.status == 200) {
                    var j = JSON.parse(request.responseText);
                    var t = Number(j.temp).toFixed(1);

                    currentTemp.text = t + " °C";

                    if (t > temp_threshold) {
                        checking = true;
                        textTimer.interval = interval_short;
                        currentTemp.font.weight = Font.Bold;
                        currentTemp.color = "red";
                    } else if (t <= temp_threshold && checking) {
                        checking = false;

                        if (sound_enabled) {
                            soundEffect.play()
                        }

                        if (notification_enabled) {
                            createNotification()
                        } else {
                            resetWidgetTimer.start()
                        }

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
