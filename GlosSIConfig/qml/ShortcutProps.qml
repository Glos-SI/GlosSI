﻿/*
Copyright 2021-2022 Peter Repukat - FlatspotSoftware

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts 6.2
import QtQuick.Controls.Material 6.2
import QtQuick.Dialogs 6.2


Item {
    id: propsContent
    anchors.fill: parent

    property alias fileDialog: fileDialog
    property alias uwpSelectDialog: uwpSelectDialog
    signal cancel()
    signal done(var shortcut)

    property var shortcutInfo: ({})

    function resetInfo() {
        shortcutInfo = ({
            "controller": {
                "maxControllers": 1,
                "emulateDS4": false,
                "allowDesktopConfig": false
            },
            "devices": {
                "hideDevices": true,
                "realDeviceIds": false
            },
            "icon": null,
            "launch": {
                "closeOnExit": true,
                "launch": false,
                "launchAppArgs": null,
                "launchPath": null,
                "waitForChildProcs": true
            },
            "name": null,
            "version": 1,
            "window": {
                "disableOverlay": false,
                "maxFps": null,
                "scale": null,
                "windowMode": false
            },
            "extendedLogging": false
        })
    }
	
    Component.onCompleted: function() {
        resetInfo()
    }

    onShortcutInfoChanged: function() {
	    if (!shortcutInfo) {
            return;
        }
	    if (nameInput) { // basic info (not in collapsible container)
            nameInput.text = shortcutInfo.name || ""
			launchApp.checked = shortcutInfo.launch.launch
            pathInput.text = shortcutInfo.launch.launchPath || ""
            argsInput.text = shortcutInfo.launch.launchAppArgs || ""
		}
		if (advancedTargetSettings) { // advanced settings (collapsible container)
            advancedTargetSettings.shortcutInfo = shortcutInfo;
        }
    }

    Flickable {
        id: flickable
        anchors.margins: 0
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true
        ScrollBar.vertical: ScrollBar {

        }
        contentWidth: propscolumn.width
        contentHeight: propscolumn.height
        flickableDirection: Flickable.VerticalFlick


        Column {
            id: propscolumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 32
            spacing: 4

            Item {
                id: topspacing
                width: 1
                height: 32
            }

            Item {
                id: namewrapper
                width: parent.width / 3
                height: 64
                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    id: nameLabel
                    font.bold: true
                    text: qsTr("Name")
                }
                FluentTextInput {
                    width: parent.width
                    anchors.top: nameLabel.bottom
                    anchors.topMargin: 4
                    id: nameInput
                    placeholderText: qsTr("...")
                    text: shortcutInfo.name
                    onTextChanged: shortcutInfo.name = text
                    validator: RegularExpressionValidator { regularExpression: /([0-z]|\s|.)+/gm }
                }
            }
            Item {
                width: 1
                height: 8
            }
            RPane {
                width: parent.width
                radius: 4
		        Material.elevation: 32
                bgOpacity: 0.97
                Column {
                    width: parent.width
                    height: parent.height
                    spacing: 4
                    Row {
                        spacing: 32
                        width: parent.width
                        CheckBox {
                            id: launchApp
                            text: qsTr("Launch app")
                            checked: shortcutInfo ? shortcutInfo.launch.launch : false
                            onCheckedChanged: function() {
                                shortcutInfo.launch.launch = checked
                                if (checked) {
                                    if (closeOnExit) {
                                        closeOnExit.enabled = true;
                                        if (closeOnExit.checked) {
                                            waitForChildren.enabled = true;
                                        }
                                    }
                                    allowDesktopConfig.enabled = true;
                                } else {
                                    waitForChildren.enabled = false;
                                    closeOnExit.enabled = false;
                                    allowDesktopConfig.enabled = false;
                                }
                            }
                        }
                    }
                    Item {
                        width: 1
                        height: 8
                    }
                    RowLayout {
                        id: launchlayout
                        spacing: 4
                        anchors.left: parent.left
						anchors.right: parent.right
						anchors.leftMargin: 32
						anchors.rightMargin: 32
                        Image {
                            id: maybeIcon
                            source: shortcutInfo.icon
                                ? shortcutInfo.icon.endsWith(".exe")
                                    ? "image://exe/" + shortcutInfo.icon
                                    : "file:///" + shortcutInfo.icon
                                : ''
                            Layout.preferredWidth: 48
                            Layout.preferredHeight: 48
                            visible: shortcutInfo.icon
                            Layout.alignment: Qt.AlignVCenter
                        }
                        Item {
                            Layout.preferredWidth: 8
                            Layout.preferredHeight: 8
                            visible: shortcutInfo.icon
                        }
                        Item {
                            Layout.preferredWidth: parent.width / 2
                            Layout.fillWidth: true
                            height: 64
                            Label {
                                anchors.left: parent.left
                                anchors.leftMargin: 4
                                id: pathLabel
                                font.bold: true
                                text: qsTr("Path")
                            }
                            FluentTextInput {
                                width: parent.width
                                anchors.top: pathLabel.bottom
                                anchors.topMargin: 4
                                id: pathInput
                                placeholderText: qsTr("...")
                                enabled: launchApp.checked
                                text: shortcutInfo.launch.launchPath || ""
                                onTextChanged: shortcutInfo.launch.launchPath = text
                            }
                        }
                        Button {
                            Layout.preferredWidth: 64
                            Layout.alignment: Qt.AlignBottom
                            text: qsTr("...")
                            onClicked: fileDialog.open();
                        }
                        Button {
                            Layout.preferredWidth: 64
                            Layout.alignment: Qt.AlignBottom
                            text: qsTr("UWP")
                            visible: uiModel.isWindows
                            onClicked: uwpSelectDialog.open();
                        }
                        Item {
                            height: 1
                            Layout.preferredWidth: 12
                        }
                        Item {
                            Layout.preferredWidth: parent.width / 2.5
                            height: 64
                            Label {
                                anchors.left: parent.left
                                anchors.leftMargin: 4
                                id: argslabel
                                font.bold: true
                                text: qsTr("Launch Arguments")
                            }
                            FluentTextInput {
                                width: parent.width
                                anchors.top: argslabel.bottom
                                anchors.topMargin: 4
                                id: argsInput
                                enabled: launchApp.checked
                                text: shortcutInfo.launch.launchAppArgs
                                onTextChanged: shortcutInfo.launch.launchAppArgs = text
                            }
                        }
                    }
                }
            }
            Item {
                width: 1
                height: 8
            }

			AdvancedTargetSettings {
                id: advancedTargetSettings
            }

            Item {
                id: bottomspacing
                width: 1
                height: 32
            }
        }
    }

    Row {
        spacing: 8
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 24
        anchors.bottomMargin: 16
        Button {
            text: qsTr("Cancel")
            onClicked: function() {
                resetInfo();
                cancel()
            }
        }
        Button {
            text: qsTr("💾 Save")
            highlighted: true
            enabled: nameInput.acceptableInput
            onClicked: function() {
                done(shortcutInfo)
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: qsTr("Please choose a Program to Launch")
        nameFilters: uiModel.isWindows ? ["Executable files (*.exe *.bat *.ps1)"] : []
        onAccepted: {
            if (fileDialog.selectedFile != null) {
                pathInput.text = fileDialog.selectedFile.toString().replace("file:///", "")
                if (nameInput.text == "") {
                    nameInput.text = pathInput.text.replace(/.*(\\|\/)/,"").replace(/\.[0-z]*$/, "")
                    shortcutInfo.icon = nameInput.text
                }
                launchApp.checked = true
            }
        }
        onRejected: {
           
        }
    }

    UWPSelectDialog {
        id: uwpSelectDialog
        onConfirmed: function(modelData) {
            if (nameInput.text == "") {
                    nameInput.text = modelData.AppName
            }
            if (modelData.IconPath) {
                shortcutInfo.icon = modelData.IconPath
            }
            pathInput.text = modelData.AppUMId
            launchApp.checked = true
        }
    }

    InfoDialog {
        id: helpInfoDialog
        titleText: qsTr("")
        text: qsTr("")
        extraButton: false
        extraButtonText: qsTr("")
        onConfirmedExtra: function(data) {
        }
    }

}
