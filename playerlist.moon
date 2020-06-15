
__author__ = "LeoDeveloper"
__version__ = "1.1.0"

-- we're using a random name for settings, so they don't get accidently saved in the config
-- and even if they did, it'll name no impact on the next session
randomname = ""
for i=1, 16
    rand = math.random 1, 16
    randomname ..= ("0123456789abcdef")\sub rand, rand

guiobjects = {}
guisettings = {}
playerlist = {}
playersettings = {}

MENU = gui.Reference"Menu"
LIST_WIDTH = 300
GUI_TAB = gui.Tab gui.Reference"Misc", "playerlist.#{randomname}", "Player List"

GUI_TAB_PLIST_POS = { x: 8, y: 8, w: LIST_WIDTH, h: 0 }
GUI_TAB_PLIST = gui.Groupbox GUI_TAB, "Select a player", GUI_TAB_PLIST_POS.x, GUI_TAB_PLIST_POS.y, GUI_TAB_PLIST_POS.w, GUI_TAB_PLIST_POS.h
GUI_TAB_PLIST_LIST = gui.Listbox GUI_TAB_PLIST, "players", 440
with gui.Button GUI_TAB_PLIST, "Clear", ->
        GUI_TAB_PLIST_LIST\SetOptions! -- reset displayed players
        playersettings = {}
        playerlist = {}
    \SetPosX 188
    \SetPosY -42
    \SetWidth 80

GUI_TAB_SET_POS = { x: GUI_TAB_PLIST_POS.x + GUI_TAB_PLIST_POS.w + 4, y: GUI_TAB_PLIST_POS.y, w: 618 - LIST_WIDTH, h: 0 }
GUI_TAB_SET = gui.Groupbox GUI_TAB, "Per Player Settings", GUI_TAB_SET_POS.x, GUI_TAB_SET_POS.y, GUI_TAB_SET_POS.w, GUI_TAB_SET_POS.h

setting_wrapper = (settings) ->
    {
        set: (varname, value) ->
            settings.settings[ varname ] = value
            -- if the player is currently selected, update it
            if #playerlist > 0 and playerlist[ GUI_TAB_PLIST_LIST\GetValue! + 1 ] == settings.info.uid
                guisettings[ varname ].set value
        get: (varname) ->
            settings.settings[ varname ]
    }

export plist = {
    -- custom gui library for adding your own shit :)
    gui: {
        Checkbox: ( varname, name, value ) ->
            checkbox = gui.Checkbox GUI_TAB_SET, "settings.#{varname}", name, value
            guisettings[ varname ] = {
                set: (value_) -> checkbox\SetValue value_
                get: -> checkbox\GetValue!
                default: value
            }
            for _, setting in pairs playersettings
                setting.settings[ varname ] = value
            table.insert guiobjects, checkbox
            checkbox

        Slider: ( varname, name, value, min, max, step ) ->
            slider = gui.Slider GUI_TAB_SET, "settings.#{varname}", name, value, min, max, step or 1
            guisettings[ varname ] = {
                set: (value_) -> slider\SetValue value_
                get: -> slider\GetValue!
                default: value
            }
            for _, setting in pairs playersettings
                setting.settings[ varname ] = value
            table.insert guiobjects, slider
            slider

        ColorPicker: ( varname, name, r, g, b, a ) ->
            colorpicker = gui.ColorPicker GUI_TAB_SET, "settings.#{varname}", r, g, b, a
            guisettings[ varname ] = {
                set: (value_) -> colorpicker\SetValue unpack value_
                get: -> {colorpicker\GetValue!}
                default: {r, g, b, a}
            }
            for _, setting in pairs playersettings
                setting.settings[ varname ] = {r, g, b, a}
            table.insert guiobjects, colorpicker
            colorpicker
                
        Text: ( varname, text ) ->
            text_ = gui.Text GUI_TAB_SET, text
            current_text = text
            guisettings[ varname ] = {
                set: (value_) ->
                    text_\SetText value_
                    current_text = value_
                get: -> current_text
                default: text
            }
            for _, setting in pairs playersettings
                setting.settings[ varname ] = text
            table.insert guiobjects, text
            text
                
        Combobox: ( varname, name, ... ) ->
            combobox = gui.Combobox GUI_TAB_SET, "settings.#{varname}", name, ...
            guisettings[ varname ] = {
                set: (value_) -> combobox\SetValue value_
                get: -> combobox\GetValue!
                default: 0
            }
            for _, setting in pairs playersettings
                setting.settings[ varname ] = 0
            table.insert guiobjects, combobox
            combobox
        
        Button: ( name, callback ) ->
            button = gui.Button GUI_TAB_SET, name, ->
                if #playerlist > 0
                    callback playerlist[ GUI_TAB_PLIST_LIST\GetValue! + 1 ]
                else
                    callback!
                return "__REMOVE_ME__"
            table.insert guiobjects, button
            button

        Editbox: ( varname, name ) ->
            editbox = gui.Editbox GUI_TAB_SET, varname, name
            guisettings[ varname ] = {
                set: (value_) -> editbox\SetValue value_
                get: -> editbox\GetValue!
                default: 0
            }
            for _, setting in pairs playersettings
                setting.settings[ varname ] = 0
            table.insert guiobjects, editbox
            editbox

        Multibox: ( name ) ->
            multibox = gui.Multibox GUI_TAB_SET, name
            table.insert guiobjects, multibox
            multibox

        Multibox_Checkbox: ( parent, varname, name, value ) ->
            checkbox = gui.Checkbox parent, "settings.#{varname}", name, value
            guisettings[ varname ] = {
                set: (value_) -> checkbox\SetValue value_
                get: -> checkbox\GetValue!
                default: value
            }
            for _, setting in pairs playersettings
                setting.settings[ varname ] = value
            checkbox

    }
    GetByUserID: (userid) -> setting_wrapper playersettings[ userid ]
    GetByIndex: (index) ->
        pinfo = client.GetPlayerInfo index
        if pinfo != nil
            return setting_wrapper playersettings[ pinfo[ "UserID" ] ]

        for _, info in pairs playersettings
            if info.info.index == index then return setting_wrapper info
}

selected_player = nil
callbacks.Register "Draw", "playerlist.callbacks.Draw", ->
    if not MENU\IsActive! then return
    if #playerlist == 0
        for guiobj in *guiobjects
            guiobj\SetDisabled true
        selected_player = nil
        return
    elseif selected_player == nil
        for guiobj in *guiobjects
            guiobj\SetDisabled false

    if selected_player != GUI_TAB_PLIST_LIST\GetValue!
        selected_player = GUI_TAB_PLIST_LIST\GetValue!

        set = playersettings[ playerlist[ GUI_TAB_PLIST_LIST\GetValue! + 1 ] ].settings
        for varname, wrap in pairs guisettings
            wrap.set set[ varname ]
    else
        set = playersettings[ playerlist[ GUI_TAB_PLIST_LIST\GetValue! + 1 ] ].settings
        for varname, wrap in pairs guisettings
            set[ varname ] = wrap.get!

last_map = nil
callbacks.Register "CreateMove", "playerlist.callbacks.CreateMove", (cmd) ->
    if engine.GetMapName! != last_map -- different server / map
        last_map = engine.GetMapName!
        GUI_TAB_PLIST_LIST\SetOptions! -- reset displayed players
        playersettings = {}
        playerlist = {}

    for player in *entities.FindByClass"CCSPlayer"
        uid = client.GetPlayerInfo( player\GetIndex! )[ "UserID" ]
        if playersettings[ uid ] == nil -- never seen the player
            table.insert playerlist, uid
            playersettings[ uid ] = {
                info: {
                    nickname: player\GetName!
                    uid: uid
                    index: player\GetIndex!
                }
                settings: {}
            }
            set = playersettings[ uid ].settings
            for varname, wrap in pairs guisettings
                set[ varname ] = wrap.default

            GUI_TAB_PLIST_LIST\SetOptions unpack [playersettings[ v ].info.nickname for _, v in ipairs playerlist]

        elseif playersettings[ uid ].info.nickname != player\GetName! -- changed name
            playersettings[ uid ].info.nickname = player\GetName!
            GUI_TAB_PLIST_LIST\SetOptions unpack [playersettings[ v ].info.nickname for _, v in ipairs playerlist]

-- updater
http.Get "https://raw.githubusercontent.com/Le0Developer/playerlist/master/version", (content) ->
    if not content then return
    if content == __version__ then return
    -- update, yay!
    UPD_HEIGHT = 190
    UPDATE = gui.Groupbox GUI_TAB, "Update Available", GUI_TAB_PLIST_POS.x, GUI_TAB_PLIST_POS.y, 618, UPD_HEIGHT
    text = gui.Text UPDATE, "Current version: #{__version__}\nLatest version: #{content}"
    minified = gui.Checkbox UPDATE, "updater.minified", "Download minified version", false
    local btn
    btn = with gui.Button UPDATE, "Update", ->
            text\SetText "Updating..."
            btn\SetDisabled true -- disable update button
            http.Get (if minified\GetValue! then "https://raw.githubusercontent.com/Le0Developer/playerlist/master/playerlist_minified.lua" else "https://raw.githubusercontent.com/Le0Developer/playerlist/master/playerlist.lua"), (luacode) ->
                if luacode
                    text\SetText "Saving..."
                    with file.Open GetScriptName!, "w"
                        \Write luacode
                        \Close!
                    text\SetText "Updated to version: #{content}.\nReload `#{GetScriptName!}` for changes to take effect."
                else
                    text\SetText "Failed."
                    btn\SetDisabled false -- enable button for retrying
            return "__REMOVE_ME__"
        \SetWidth 290
    with gui.Button UPDATE, "Open Changelog in Browser", ->
            panorama.RunScript "SteamOverlayAPI.OpenExternalBrowserURL( 'https://github.com/Le0Developer/playerlist/blob/master/changelog.md' );"
        \SetWidth 290
        \SetPosX 300
        \SetPosY 78

    -- move other boxes down
    GUI_TAB_PLIST_POS.y += UPD_HEIGHT
    GUI_TAB_PLIST\SetPosY GUI_TAB_PLIST_POS.y
    GUI_TAB_SET_POS.y += UPD_HEIGHT
    GUI_TAB_SET\SetPosY GUI_TAB_SET_POS.y

-- resolver plugin
with plist.gui.Combobox "resolver.type", "Resolver", "On", "Off", "Manual (LBY Override)"
    \SetDescription "Choose a resolver for this player."
with plist.gui.Slider "resolver.lby_override", "LBY Override Value", 0, -180, 180
    \SetDescription "The LBY value for resolving when using manual resolver."

callbacks.Register "AimbotTarget", "playerlist.plugins.Resolver.AimbotTarget", (entity) ->
    if not entity\GetIndex! then return -- idk why, but it sometimes just returns "nil"
    set = plist.GetByIndex entity\GetIndex!
    if set.get"resolver.type" == 0
        gui.SetValue "rbot.accuracy.posadj.resolver", true
    else
        gui.SetValue "rbot.accuracy.posadj.resolver", false

callbacks.Register "CreateMove", "playerlist.plugins.Resolver.CreateMove", (cmd) ->
    localplayer = entities.GetLocalPlayer!
    for player in *entities.FindByClass"CCSPlayer"
        if not player\IsAlive!
            continue
        
        set = plist.GetByIndex player\GetIndex!
        if set.get"resolver.type" == 2
            player\SetProp "m_flLowerBodyYawTarget", (player\GetProp"m_angEyeAngles".y + set.get"resolver.type" + 180) % 360 - 180

-- player priority plugin
priority_targetted_entity = nil
priority_targetting_priority = false
callbacks.Register "AimbotTarget", "playerlist.plugins.Priority.AimbotTarget", (entity) ->
    if not entity\GetIndex! then return -- idk why, but it sometimes just returns "nil"
	if priority_targetted_entity and entity\GetIndex! != priority_targetted_entity\GetIndex!
		if priority_targetting_priority
			-- reset lock cuz we're attacking someone else
			--print("switchting to something different than priority target (lock off)", priority_targetted_entity)
			gui.SetValue "rbot.aim.target.lock", false
		priority_targetted_entity = entity
		priority_targetting_priority = false
	elseif priority_targetting_priority
		-- reset fov because we're already locking
		--print("targetting priority target (fov off)", priority_targetted_entity)
		gui.SetValue "rbot.aim.target.fov", 180

with plist.gui.Combobox "targetmode", "Targetmode", "Normal", "Friendly", "Priority"
    \SetDescription "Mode for targetting. NOTE: Priority on teammates attack them."

priority_lock_fov = 3
priority_friendly_affected = {}
callbacks.Register "CreateMove", "playerlist.plugins.Priority.CreateMove", (cmd) ->
    localplayer = entities.GetLocalPlayer!
    for player in *entities.FindByClass"CCSPlayer"
        if not player\IsAlive!
            continue
			
		set = plist.GetByIndex player\GetIndex!
        uid = client.GetPlayerInfo( player\GetIndex! )[ "UserID" ]
		if set.get"targetmode" == 0 and priority_friendly_affected[ uid ] -- reset team number
			player\SetProp "m_iTeamNum",  player\GetProp "m_iPendingTeamNum" -- `m_iPendingTeamNum`, seems to work for resetting
			priority_friendly_affected[ uid ] = nil
		elseif set.get"targetmode" == 1 -- change team number to my team
			player\SetProp "m_iTeamNum", localplayer\GetTeamNumber!
			priority_friendly_affected[ uid ] = true
		elseif set.get"targetmode" == 2
			if player\GetProp"m_iPendingTeamNum" == localplayer\GetTeamNumber! -- in my team = make him enemy
				player\SetProp "m_iTeamNum", (localplayer\GetTeamNumber!-1) % 2 + 2 -- this seems to work for getting enemy team number
				priority_friendly_affected[ uid ] = true
			else
				if priority_friendly_affected[ uid ] -- reset team number
					player\SetProp "m_iTeamNum",  player\GetProp "m_iPendingTeamNum" -- `m_iPendingTeamNum`, seems to work for resetting
					priority_friendly_affected[ uid ] = nil
				-- if we arent targetting anyone
				if not priority_targetting_priority and player\GetTeamNumber! != localplayer\GetTeamNumber!
					-- pasted code from Zarkos & converted to moonscript
					
					lp_pos = localplayer\GetAbsOrigin! + localplayer\GetPropVector "localdata", "m_vecViewOffset[0]"
					t_pos = player\GetHitboxPosition 5

					engine.SetViewAngles (t_pos - lp_pos)\Angles!
					gui.SetValue "rbot.aim.target.fov", priority_lock_fov
					gui.SetValue "rbot.aim.target.lock", true
					priority_targetted_entity = player
					priority_targetting_priority = true
					
					--print("priority targetting", player)

callbacks.Register "FireGameEvent", "playerlist.plugins.Priority.FireGameEvent", (event) ->
	-- we have to reset FOV and stuff after they die
	if event\GetName! == "player_death" and priority_targetting_priority
		if client.GetPlayerIndexByUserID( event\GetInt"userid" ) == priority_targetted_entity\GetIndex!
			--print("priority target died", priority_targetted_entity)
			
			priority_targetting_priority = false
			priority_targetted_entity = nil
			gui.SetValue "rbot.aim.target.fov", 180
			gui.SetValue "rbot.aim.target.lock", false
			
-- Force Baim / SafePoint plugin (fbsp)
fbsp_force = plist.gui.Multibox "Force ..."
with plist.gui.Multibox_Checkbox fbsp_force, "force.baim", "BAIM", false
    \SetDescription "Set's bodyaim to priority."
with plist.gui.Multibox_Checkbox fbsp_force, "force.safepoint", "Safepoint", false
    \SetDescription "Shoots only on safepoint."

-- setters and undoers
fbsp_weapon_types = {"asniper", "hpistol", "lmg", "pistol", "rifle", "scout", "shared", "shotgun", "smg", "sniper", "zeus"}
fbsp_cache_baim = { applied: false }
fbsp_baim_apply = ->
    if fbsp_cache_baim.applied
        print( "[PLAYERLIST] WARNING: Force baim has already been applied." )
    for weapon in *fbsp_weapon_types
        if gui.GetValue"rbot.hitscan.mode.#{weapon}.bodyaim" != 1
            fbsp_cache_baim[ weapon ] = gui.GetValue"rbot.hitscan.mode.#{weapon}.bodyaim"
            gui.SetValue "rbot.hitscan.mode.#{weapon}.bodyaim", 1 -- priority
    fbsp_cache_baim.applied = true
fbsp_baim_undo = ->
    if not fbsp_cache_baim.applied
        print( "[PLAYERLIST] WARNING: Force baim hasn't been applied." )
    for weapon, value in pairs fbsp_cache_baim
        continue if weapon == "applied"
        gui.SetValue "rbot.hitscan.mode.#{weapon}.bodyaim", value

    fbsp_cache_baim = { applied: false }

fbsp_cache_sp = { applied: false }
fbsp_sp_regions = {"delayshot", "delayshotbody", "delayshotlimbs"}
fbsp_sp_apply = -> -- sp = safepoint
    if fbsp_cache_sp.applied
        print( "[PLAYERLIST] WARNING: Force safepoint has already been applied." )
    for weapon in *fbsp_weapon_types
        for delayshot_region in *fbsp_sp_regions
            if gui.GetValue"rbot.hitscan.mode.#{weapon}.#{delayshot_region}" != 1
                fbsp_cache_sp[ "#{weapon}.#{delayshot_region}" ] = gui.GetValue"rbot.hitscan.mode.#{weapon}.#{delayshot_region}"
                gui.SetValue "rbot.hitscan.mode.#{weapon}.#{delayshot_region}", 1 -- 1 == safepoint
    fbsp_cache_sp.applied = true
fbsp_sp_undo = ->
    if not fbsp_cache_sp.applied
        print( "[PLAYERLIST] WARNING: Force safepoint hasn't been applied." )
    for weapon, value in pairs fbsp_cache_sp
        continue if weapon == "applied"
        gui.SetValue "rbot.hitscan.mode.#{weapon}", value

    fbsp_cache_sp = { applied: false }

fbsp_targetted_enemy = nil
callbacks.Register "AimbotTarget", "playerlist.plugins.FBSP.AimbotTarget", (entity) ->
    if not entity\GetIndex! then return -- idk why, but it sometimes just returns "nil"

    fbsp_targetted_enemy = entity
    
    set = plist.GetByIndex entity\GetIndex!
    if set.get"force.baim"
        if not fbsp_cache_baim.applied
            fbsp_baim_apply!
    elseif fbsp_cache_baim.applied
        fbsp_baim_undo!
        
    if set.get"force.safepoint"
        if not fbsp_cache_sp.applied
            fbsp_sp_apply!
    elseif fbsp_cache_sp.applied
        fbsp_sp_undo!
        

callbacks.Register "FireGameEvent", "playerlist.plugins.FBSP.FireGameEvent", (event) ->
	if event\GetName! == "player_death" and fbsp_targetted_enemy and client.GetPlayerIndexByUserID( event\GetInt"userid" ) == fbsp_targetted_enemy\GetIndex! -- reset enemy after death
        fbsp_targetted_enemy = nil
        if fbsp_cache_baim.applied
            fbsp_baim_undo!
        if fbsp_cache_sp.applied
            fbsp_sp_undo!

-- per player esp plugin (ppe)
with plist.gui.Checkbox "esp", "ESP", false
    \SetDescription "Basic Box ESP."

-- copy pasta from https://aimware.net/forum/thread/109067 (V4 script)
callbacks.Register "DrawESP", "playerlist.plugins.PPE.DrawESP", (builder) ->
    player = builder\GetEntity!
    if not player\IsPlayer! then return
    
    if plist.GetByIndex( player\GetIndex! ).get"esp"
            draw.Color 0x80, 0x80, 0x80, 0xFF
            draw.OutlinedRect builder\GetRect!


-- removed by `build.py` to prevent crashes
return "__REMOVE_ME__"