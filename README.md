
# Playerlist

This is inspired by [PlayerList by Zerdos](https://github.com/zer420/Player-List), the goal of this project is to make playerlist with a public api for expanding the lua.

This project is written in [Moonscript](https://moonscript.org), a language which compiles to lua.

## Building

### Dependencies
  - Install Lua5.1 ([Example windows builds](https://github.com/rjpcomputing/luaforwindows/releases/latest)) *preinstalled on mac and linux*
  - Install Moonscript from [here](https://moonscript.org/#installation)
  - Python 3.6+ from [here](https://www.python.org/downloads/)

### Building
  - Windows
    ```
    py build.py
    ```
  - Mac or Linux
    ```
    python3 build.py
    ```
  
  You can use `playerlist.lua` and `playerlist_minified.lua` as the luas used in your program.

## API

This project adds an interface at `plist`.

### plist.gui

This endpoint is used for adding gui object to the playerlist.
All guiobjects behave the same as in `gui`, but without parent as first argument and currently supported are `Checkbox`, `Slider`, `ColorPicker`, `Text`, `Combobox`.

### plist.GetByIndex(index)

Returns a settings wrapper for the settings of the player.

### plist.GetByUserID(userid)

Returns a settings wrapper for the settings of the player.

### Settings Wrapper

A settings wrapper table implements `set` and `get`.

- `wrapper.get(varname)`, returns the value of the setting.
- `wrapper.set(varname, value)`, sets the value of the setting.

varname is the same as when you created it with `plist.gui.X`

### Example

```lua
plist.gui.Checkbox("killsay", "Trashtalk when they die", false)

client.AllowListener("player_hurt")
callbacks.Register("FireGameEvent", function(Event)
  if Event:GetName() == "player_hurt" and Event:GetInt( "health" ) <= 0 then -- someone died
    local lp = entities.GetLocalPlayer()
    local lp_uid = client.GetPlayerInfo( lp:GetIndex() )[ "UserID" ]
    local victim_uid = Event:GetInt( "userid" )
    local attacker_uid = Event:GetInt( "attacker" )

    if lp_uid == attacker_uid and lp_uid ~= victim_uid then -- i killed someone and it's not myself
      local settings = plist.GetByUserID( victim_uid ) -- get plist info
      if settings.get( "killsay" ) then -- "killsay" is the varname
        client.ChatSay( "RIP." )
      end
    end

  end
end)
```
