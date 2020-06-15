
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

This lua adds a public api available under `plist`, which can be used to make extensions.

> **NOTE:** Documentation can be found in the [Github Wiki](https://github.com/Le0Developer/playerlist/wiki#api).

### Example Extension

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

## Credits

This program includes source from:
  - [PlayerList](https://aimware.net/forum/thread/136420) by [Zerdos](https://aimware.net/forum/user/119901) [GITHUB](https://github.com/zer420/Player-List) Affected code: Prioritizing players.
  - [Per Player ESP](https://aimware.net/forum/thread/109067) by [Cheeseot](https://aimware.net/forum/user/215088) Affected code: Per Player ESP

I'm also thanking:
  - The amazing people from the unofficial AIMWARE discord server.
