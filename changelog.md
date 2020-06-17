
# Changelog

## Version 1.0.0
  - Initial release

## Version 1.0.1
  - Fixed bug with `plist.gui.Combobox` accidently using `gui.Slider` instead of `gui.Combobox`
  - Added priority plugin
    - `Normal` priority, doesn't change anything
    - `Friendly` priority, doesn't attack the player with ragebot
    - `Priority` priority, prefers player over other enemies or attacks teammate.

## Version 1.0.2
  - Fixed error in `SettingsWrapper.set`
  - Added `Button` and `Editbox` to `plist.gui`
  - Resetting names now on map change

## Version 1.0.3
  - Added description for window toggler
  - Added force baim/safepoint
  - Added per player esp
  - Removed team check for LBY Override
  - Fixed multiple errors with empty userlists
  - Fixed issue with visible userlist desyncing with the internal

## Version 1.1.0
  - Moved into a tab from a window
  - Added a `Clear` button to clear playerlist and settings
  - Added resolver `on`/`off` combobox and moved LBY override into it as `manual`
  - Moved `Force BAIM` and `Force Safepoint` into a multibox
  - Added descriptions
  - Added updater (a groupbox will appear above the playerlist when there's an update)
  - Player settings are now disabled when there're no players
  - Fixed bug in `plist.gui.Button` crashing AIMWARE
  - Added `plist.gui.Multibox` and `plist.gui.Multibox_Checkbox`
  - Increased override lby range

## Version 1.1.1
  - Fixed bug in manual resolver

## Version 1.1.2
  - Added `plist.gui.Delete`, for deleting old gui objects after unloading an extension
  - Renamed internal naming from `plugin` to `extension`
  - Added `plist.GetSelected`, `plist.GetSelectedIndex` and `plist.GetSelectedUserID`
  - Updater now uses minified version by default

## Version 1.2.0
  - Added possibility to switch between tab and window mode
  - Resets player list on server change now too (was only map change before)
  - Adjusted height of updater groupbox
  - Changed LBY Override range back from 180 to 58
  - Added `Name`, `Chams`, `Health` and `Ammo` to ESPy
  - Added `plist.gui.Multibox_Colorpicker`

## Version 1.2.1
  - Fixed crash after a while of using per player chams (caching of materials failed)
  - Clicking on "Open Changelog" in updater will now jump to the version
  - Made changes to the code to make the minified version a one-liner again