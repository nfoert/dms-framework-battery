import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins
import qs.Services
import Quickshell

PluginComponent {
    id: root

    layerNamespacePlugin: "dmsFrameworkBattery"

    property var iconName: BatteryService.getBatteryIcon()

    property var isActive: BatteryService.batteryAvailable && (BatteryService.isCharging || BatteryService.isPluggedIn)
    property var batteryPercent: BatteryService.batteryLevel

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS

            DankIcon {
                name: BatteryService.getBatteryIcon()
                size: Theme.iconSizeSmall
                color: Theme.primary

                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                text: BatteryService.batteryLevel + "%"
                font.pixelSize: Theme.fontSizeSmall

                anchors.verticalCenter: parent.verticalCenter
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

                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                text: BatteryService.batteryLevel + "%"
                font.pixelSize: Theme.fontSizeSmall

                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    popoutContent: Component {
        PopoutComponent {
            id: popoutColumn

            Item {
                width: parent.width
                height: root.popoutHeight
                        - popoutColumn.headerHeight
                        - popoutColumn.detailsHeight
                        - Theme.spacingXL

                Column {
                    anchors.fill: parent
                    spacing: Theme.spacingL

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        DankIcon {
                            name: BatteryService.getBatteryIcon()
                            size: Theme.iconSizeLarge
                            color: Theme.primary
                        }

                        Column {
                            spacing: Theme.spacingXS
                            // width: parent.width - Theme.iconSizeLarge - Theme.spacingM

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
                                }
                            }

                            StyledText {
                                text: BatteryService.formatTimeRemaining() + " remaining"
                                font.pixelSize: Theme.fontSizeSmall
                                opacity: 0.7
                                visible: !BatteryService.batteryAvailable
                            }
                        }

                        DankActionButton {
                            iconName: "Close"
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: {
                                root.closePopout()
                            }
                        }
                    }

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        Repeater {
                            model: 3

                            StyledRect {
                                width: (parent.width - Theme.spacingM * 2) / 3
                                height: 90
                                color: Theme.surfaceContainerHighest
                                radius: Theme.cornerRadius
                                border.width: 1
                                border.color: Theme.surfaceContainerHigh

                                Column {
                                    anchors.centerIn: parent
                                    spacing: Theme.spacingS

                                    StyledText {
                                        text: modelData === 0
                                            ? "Health"
                                            : modelData === 1
                                            ? "Capacity"
                                            : "Watts"

                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.primary
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    StyledText {
                                        text: modelData === 0
                                            ? BatteryService.batteryHealth
                                            : modelData === 1
                                            ? BatteryService.batteryCapacity.toFixed(1) + " Wh"
                                            : BatteryService.changeRate.toFixed(1) + " W"

                                        font.pixelSize: Theme.fontSizeLarge
                                        font.weight: Font.Bold
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
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