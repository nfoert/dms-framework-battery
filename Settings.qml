import QtQuick
import qs.Common
import qs.Modules.Plugins
import qs.Widgets

PluginSettings {
    id: root
    pluginId: "dmsFrameworkBattery"

    StyledText {
        width: parent.width
        text: "Settings"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    ToggleSetting {
        settingKey: "showTimeRemaining"
        label: "Show Time Remaining"
        description: "If the battery time remaining, or time to charge, should be shown in the bar widget"
        defaultValue: false
    }

    ToggleSetting {
        settingKey: "showWatts"
        label: "Show Watts Used"
        description: "If the wattage entering or exiting the battery should be shown in the bar widget"
        defaultValue: false
    }

    ToggleSetting {
        settingKey: "showChargeLimit"
        label: "Show Charge Limit"
        description: "If the charge limit functionality should be available"
        defaultValue: true
    }
}