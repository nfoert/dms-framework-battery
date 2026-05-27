# dms-framework-battery

This plugin replaces the existing battery widget for DankBar. This adds the same features, as well as adding the ability to dynamically change the battery charge limit on Framework laptops.

## Features
- Bar shows battery precentage and icon
    - Be able to show time remaining and wattage used
- When clicked, show more details
    - Battery percent
    - Battery state
    - Battery time remaining
    - Battery wattage used
    - Battery health
    - Battery capacity
    - Set PPD profile
    - Set framework charge limit, with presets (60, 75, 80, 90, 100)

## Development
```bash
git clone https://github.com/nfoert/dms-framework-battery
cd dms-framework-battery
ln -s . ~/.config/DankMaterialShell/plugins/dmsFrameworkBattery 
```

Enable the plugin in your settings, add it to your bar widgets, then reload it after making changes with:
```bash
dms ipc call plugins reload dmsFrameworkBattery
```

## To-Do
- [x] Get custom charge limit working
- [x] Fix remaining showing when plugged in
- [x] Adjust icon colors for charging / discharging / low battery
- [x] Use `RowLayout` and `ColumnLayout`
- [x] Fix text alignment in stat cards
- [x] Add widget settings for showing time remaining and wattage used
- [x] Hide remaining for both the bar widget and inside the component if it's zero
- [x] Hide wattage on the bar widget if it's zero
- [x] Wattage seems to always show `-` instead of `+` when plugged in
- [ ] Only set the DMS settings for charge limit if the request to set the hardware charge limit succeeded
- [ ] Add button for fetching the current hardware charge limit