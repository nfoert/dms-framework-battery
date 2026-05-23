import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins
import qs.Services
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Io

PluginComponent {
    id: root

    layerNamespacePlugin: "dmsFrameworkBattery"

    property var iconName: BatteryService.getBatteryIcon()

    property var isActive: BatteryService.batteryAvailable && (BatteryService.isCharging || BatteryService.isPluggedIn)
    property var batteryPercent: BatteryService.batteryLevel
    property int chargeLimit: SettingsData.batteryChargeLimit

    property var statsModel: [
        {
            label: "Health",
            value: BatteryService.batteryHealth
        },
        {
            label: "Capacity",
            value: BatteryService.batteryCapacity.toFixed(1) + " Wh"
        },
        {
            label: "Watts",
            value: BatteryService.changeRate.toFixed(1) + " W"
        }
    ]

    function setProfile(profile) {
        if (typeof PowerProfiles === "undefined") {
            ToastService.showError(I18n.tr("power-profiles-daemon not available"));
            return;
        }
        PowerProfiles.profile = profile;
        if (PowerProfiles.profile !== profile) {
            ToastService.showError(I18n.tr("Failed to set power profile"));
        }
    }

    function isActiveProfile(profile) {
        if (typeof PowerProfiles === "undefined") {
            return false;
        }

        return PowerProfiles.profile === profile;
    }

    function setChargeLimit(limit) {
        chargeLimit = limit

        SettingsData.set("batteryChargeLimit", limit);
        SettingsData.saveSettings();

        setHardwareChargeLimit(limit);
    }

    function setHardwareChargeLimit(limit) {
        var process = chargeLimitProcessComponent.createObject(root, {
            limit: limit
        });

        process.running = true;
    }

    Component {
        id: chargeLimitProcessComponent

        Process {
            property int limit: 100

            command: [
                "pkexec",
                "ectool",
                "fwchargelimit",
                limit.toString()
            ]

            stdout: SplitParser {
                onRead: line => console.log("ectool:", line)
            }

            stderr: SplitParser {
                onRead: line => {
                    if (line.trim()) {
                        ToastService.showError("ectool error", line)
                    }
                }
            }

            onExited: (exitCode) => {
                if (exitCode !== 0) {
                    ToastService.showError("Failed to set charge limit (" + exitCode + ")")
                }
                destroy()
            }
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS

            DankIcon {
                name: BatteryService.getBatteryIcon()
                size: Theme.iconSizeSmall
                color: Theme.primary
            }

            StyledText {
                text: BatteryService.batteryLevel + "%"
                font.pixelSize: Theme.fontSizeSmall
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS

            DankIcon {
                name: BatteryService.getBatteryIcon()
                size: Theme.iconSizeSmall
                color: Theme.primary
            }

            StyledText {
                text: BatteryService.batteryLevel + "%"
                font.pixelSize: Theme.fontSizeSmall
            }
        }
    }

    popoutContent: Component {
        PopoutComponent {
            id: popoutColumn

            Item {
                width: parent.width
                implicitHeight: content.implicitHeight + Theme.spacingL * 2

                Column {
                    id: content
                    anchors.margins: Theme.spacingL
                    anchors.fill: parent
                    spacing: Theme.spacingL

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        DankIcon {
                            id: batteryIcon
                            name: BatteryService.getBatteryIcon()
                            size: Theme.iconSizeLarge
                            color: Theme.primary
                        }

                        Column {
                            id: batteryInfo

                            spacing: Theme.spacingXS

                            width: parent.width - batteryIcon.width - closeButton.width - Theme.spacingM * 4

                            Row {
                                spacing: Theme.spacingS

                                StyledText {
                                    text: BatteryService.batteryLevel + "%"
                                    font.pixelSize: Theme.fontSizeLarge
                                    font.weight: Font.Bold
                                }

                                StyledText {
                                    text: BatteryService.batteryStatus
                                    font.pixelSize: Theme.fontSizeLarge

                                    elide: Text.ElideRight
                                    width: batteryInfo.width - 80
                                }
                            }

                            StyledText {
                                text: BatteryService.formatTimeRemaining() + " remaining"
                                font.pixelSize: Theme.fontSizeSmall
                                opacity: 0.7

                                visible: BatteryService.batteryAvailable

                                elide: Text.ElideRight
                                width: batteryInfo.width
                            }
                        }

                        Item {
                            width: 1
                            height: 1
                        }

                        DankActionButton {
                            id: closeButton

                            iconName: "Close"


                            onClicked: root.closePopout()
                        }
                    }

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        Repeater {
                            model: statsModel

                            StyledRect {
                                width: Math.max(
                                    90,
                                    (parent.width - Theme.spacingM * 2) / 3
                                )

                                implicitHeight: 90

                                color: Theme.surfaceContainerHighest
                                radius: Theme.cornerRadius

                                border.width: 1
                                border.color: Theme.surfaceContainerHigh

                                Column {
                                    anchors.centerIn: parent
                                    spacing: Theme.spacingXS

                                    StyledText {
                                        text: modelData.label
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.primary
                                    }

                                    StyledText {
                                        text: modelData.value
                                        font.pixelSize: Theme.fontSizeLarge
                                        font.weight: Font.Bold
                                    }
                                }
                            }
                        }
                    }

                    DankButtonGroup {
                        id: profileButtonGroup

                        property var profileModel: (typeof PowerProfiles !== "undefined") ? [PowerProfile.PowerSaver, PowerProfile.Balanced].concat(PowerProfiles.hasPerformanceProfile ? [PowerProfile.Performance] : []) : [PowerProfile.PowerSaver, PowerProfile.Balanced, PowerProfile.Performance]
                        property int currentProfileIndex: {
                            if (typeof PowerProfiles === "undefined")
                                return 1;
                            return profileModel.findIndex(profile => root.isActiveProfile(profile));
                        }

                        model: profileModel.map(profile => Theme.getPowerProfileLabel(profile))
                        currentIndex: currentProfileIndex
                        selectionMode: "single"
                        onSelectionChanged: (index, selected) => {
                            if (!selected)
                                return;
                            root.setProfile(profileModel[index]);
                        }
                    }
                    

                    Column {
                        spacing: Theme.spacingL

                        Row {
                            DankIcon {
                                name: "battery_change"
                                size: Theme.iconSize
                            }

                        StyledText {
                            text: "Charge limit"
                                font.pixelSize: Theme.fontSizeMedium
                                font.weight: Font.Bold
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        DankButtonGroup {
                            property var limitModel: [60, 75, 80, 90, 100]
                            property int currentLimitIndex: limitModel.indexOf(root.chargeLimit)

                            model: limitModel.map(limit => limit + "%")
                            currentIndex: currentLimitIndex
                            selectionMode: "single"
                            onSelectionChanged: (index, selected) => {
                                if (!selected) return;

                                root.setChargeLimit(limitModel[index]);
                            }
                        }
                    }
                }
            }
        }
    }

    popoutWidth: 400
    popoutHeight: 500
}