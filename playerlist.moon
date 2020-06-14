
__author__ = "LeoDeveloper"
__verison__ = "1.0.2"

-- we're using a random name for settings, so they don't get accidently saved in the config
-- and even if they did, it'll name no impact on the next session
randomname = ""
for i=1, 16
    rand = math.random 1, 16
    randomname ..= ("0123456789abcdef")\sub rand, rand

MENU = gui.Reference"Menu"
GUI_ENABLE = gui.Checkbox gui.Reference( "Misc", "General", "Extra" ), "playerlist.enable", "Player List", false

GUI_WINDOW_POS = { x: 100, y: 100, w: 400, h: 400 }
LIST_WIDTH = GUI_WINDOW_POS.w / 2 - 8
GUI_WINDOW = gui.Window "playerlist#{randomname}", "Player List", GUI_WINDOW_POS.x, GUI_WINDOW_POS.y, GUI_WINDOW_POS.w, GUI_WINDOW_POS.h

GUI_WINDOW_PLIST_POS = { x: 8, y: 8, w: LIST_WIDTH, h: GUI_WINDOW_POS.h - 16 }
GUI_WINDOW_PLIST = gui.Groupbox GUI_WINDOW, "Select a player", GUI_WINDOW_PLIST_POS.x, GUI_WINDOW_PLIST_POS.y, GUI_WINDOW_PLIST_POS.w, GUI_WINDOW_PLIST_POS.h
GUI_WINDOW_PLIST_LIST = gui.Listbox GUI_WINDOW_PLIST, "players", GUI_WINDOW_POS.h - 106

GUI_WINDOW_SET_POS = { x: GUI_WINDOW_PLIST_POS.x + GUI_WINDOW_PLIST_POS.w + 4, y: GUI_WINDOW_PLIST_POS.y, w: GUI_WINDOW_POS.w - LIST_WIDTH - 16, h: GUI_WINDOW_POS.h }
GUI_WINDOW_SET = gui.Groupbox GUI_WINDOW, "Per Player Settings", GUI_WINDOW_SET_POS.x, GUI_WINDOW_SET_POS.y, GUI_WINDOW_SET_POS.w, GUI_WINDOW_SET_POS.h

guisettings = {}
playerlist = {}
playersettings = {}

setting_wrapper = (settings) ->
    {
        set: (varname, value) ->
            settings.settings[ varname ] = value
            -- if the player is currently selected, update it
            if playerlist[ GUI_WINDOW_PLIST_LIST\GetValue! + 1 ] == settings.info.uid
                guisettings[ varname ].set value
        get: (varname) ->
            settings.settings[ varname ]
    }

export plist = {
    -- custom gui library for adding your own shit :)
    gui: {
        Checkbox: ( varname, name, value ) ->
            checkbox = gui.Checkbox GUI_WINDOW_SET, "settings.#{varname}", name, value
            guisettings[ varname ] = {
                set: (value_) -> checkbox\SetValue value_
                get: -> checkbox\GetValue!
                default: value
            }
            for _, setting in pairs playersettings
                setting.settings[ varname ] = value
            checkbox

        Slider: ( varname, name, value, min, max, step ) ->
            slider = gui.Slider GUI_WINDOW_SET, "settings.#{varname}", name, value, min, max, step or 1
            guisettings[ varname ] = {
                set: (value_) -> slider\SetValue value_
                get: -> slider\GetValue!
                default: value
            }
            for _, setting in pairs playersettings
                setting.settings[ varname ] = value
            slider

        ColorPicker: ( varname, name, r, g, b, a ) ->
            colorpicker = gui.ColorPicker GUI_WINDOW_SET, "settings.#{varname}", r, g, b, a
            guisettings[ varname ] = {
                set: (value_) -> colorpicker\SetValue unpack value_
                get: -> {colorpicker\GetValue!}
                default: {r, g, b, a}
            }
            for _, setting in pairs playersettings
                setting.settings[ varname ] = {r, g, b, a}
            colorpicker
                
        Text: ( varname, text ) ->
            text_ = gui.Text GUI_WINDOW_SET, text
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
            text
                
        Combobox: ( varname, name, ... ) ->
            combobox = gui.Combobox GUI_WINDOW_SET, "settings.#{varname}", name, ...
            guisettings[ varname ] = {
                set: (value_) -> combobox\SetValue value_
                get: -> combobox\GetValue!
                default: 0
            }
            for _, setting in pairs playersettings
                setting.settings[ varname ] = 0
            combobox
        
        Button: ( name, callback ) ->
            gui.Button GUI_WINDOW_SET, name, -> callback playerlist[ GUI_WINDOW_PLIST_LIST\GetValue! + 1 ]

        Editbox: ( varname, name ) ->
            editbox = gui.Editbox GUI_WINDOW_SET, varname, name
            guisettings[ varname ] = {
                set: (value_) -> editbox\SetValue value_
                get: -> editbox\GetValue!
                default: 0
            }
            for _, setting in pairs playersettings
                setting.settings[ varname ] = 0
            editbox

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
    GUI_WINDOW\SetActive GUI_ENABLE\GetValue! and MENU\IsActive!
    if not GUI_WINDOW\IsActive! then return
    
    if selected_player != GUI_WINDOW_PLIST_LIST\GetValue!
        selected_player = GUI_WINDOW_PLIST_LIST\GetValue!

        set = playersettings[ playerlist[ GUI_WINDOW_PLIST_LIST\GetValue! + 1 ] ].settings
        for varname, wrap in pairs guisettings
            wrap.set set[ varname ]
    else
        set = playersettings[ playerlist[ GUI_WINDOW_PLIST_LIST\GetValue! + 1 ] ].settings
        for varname, wrap in pairs guisettings
            set[ varname ] = wrap.get!

last_map = nil
callbacks.Register "CreateMove", "playerlist.callbacks.CreateMove", (cmd) ->
    if engine.GetMapName! != last_map -- different server / map
        last_map = engine.GetMapName!
        GUI_WINDOW_PLIST_LIST\SetOptions! -- reset displayed players
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

            GUI_WINDOW_PLIST_LIST\SetOptions unpack [v.info.nickname for _, v in pairs playersettings]

        elseif playersettings[ uid ].info.nickname != player\GetName! -- changed name
            playersettings[ uid ].info.nickname = player\GetName!
            GUI_WINDOW_PLIST_LIST\SetOptions unpack [v.info.nickname for _, v in pairs playersettings]

-- lby "resolver" plugin
plist.gui.Checkbox "lby_override.toggle", "LBY Override", false
plist.gui.Slider "lby_override.value", "LBY Override Value", 0, -58, 58

callbacks.Register "CreateMove", "playerlist.plugins.LBY_Override", (cmd) ->
    localplayer = entities.GetLocalPlayer!
    for player in *entities.FindByClass"CCSPlayer"
        if not player\IsAlive! or player\GetTeamNumber! == localplayer\GetTeamNumber!
            continue
        
        set = plist.GetByIndex player\GetIndex!
        if set.get "lby_override.toggle" 
            player\SetProp "m_flLowerBodyYawTarget", (player\GetProp"m_angEyeAngles".y + set.get"lby_override.value" + 180) % 360 - 180

-- player priority plugin
priority_targetted_entity = nil
priority_targetting_priority = false
callbacks.Register "AimbotTarget", "playerlist.plugins.Priority.AimbotTarget", (entity) ->
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

plist.gui.Combobox "priority", "Priority", "Normal", "Friendly", "Priority"

priority_lock_fov = 3
priority_friendly_affected = {}
callbacks.Register "CreateMove", "playerlist.plugins.Priority.CreateMove", (cmd) ->
    localplayer = entities.GetLocalPlayer!
    for player in *entities.FindByClass"CCSPlayer"
        if not player\IsAlive!
            continue
			
		set = plist.GetByIndex player\GetIndex!
        uid = client.GetPlayerInfo( player\GetIndex! )[ "UserID" ]
		if set.get"priority" == 0 and priority_friendly_affected[ uid ] -- reset team number
			player\SetProp "m_iTeamNum",  player\GetProp "m_iPendingTeamNum" -- `m_iPendingTeamNum`, seems to work for resetting
			priority_friendly_affected[ uid ] = nil
		elseif set.get"priority" == 1 -- change team number to my team
			player\SetProp "m_iTeamNum", localplayer\GetTeamNumber!
			priority_friendly_affected[ uid ] = true
		elseif set.get"priority" == 2
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
			
			

-- removed by `build.py`, to prevent crashes
return "__REMOVE_ME__"