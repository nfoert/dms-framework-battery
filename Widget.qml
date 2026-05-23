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
                }
            }
        }
    }

    popoutWidth: 400
    popoutHeight: 500
}