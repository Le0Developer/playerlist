local __author__ = "LeoDeveloper"
local __version__ = "1.1.2"
local randomname = ""
for i = 1, 16 do
  local rand = math.random(1, 16)
  randomname = randomname .. ("0123456789abcdef"):sub(rand, rand)
end
local guiobjects = { }
local guisettings = { }
local playerlist = { }
local playersettings = { }
local MENU = gui.Reference("Menu")
local LIST_WIDTH = 300
local GUI_TAB = gui.Tab(gui.Reference("Misc"), "playerlist." .. tostring(randomname), "Player List")
local GUI_TAB_PLIST_POS = {
  x = 8,
  y = 8,
  w = LIST_WIDTH,
  h = 0
}
local GUI_TAB_PLIST = gui.Groupbox(GUI_TAB, "Select a player", GUI_TAB_PLIST_POS.x, GUI_TAB_PLIST_POS.y, GUI_TAB_PLIST_POS.w, GUI_TAB_PLIST_POS.h)
local GUI_TAB_PLIST_LIST = gui.Listbox(GUI_TAB_PLIST, "players", 440)
do
  local _with_0 = gui.Button(GUI_TAB_PLIST, "Clear", function()
    GUI_TAB_PLIST_LIST:SetOptions()
    playersettings = { }
    playerlist = { }
  end)
  _with_0:SetPosX(188)
  _with_0:SetPosY(-42)
  _with_0:SetWidth(80)
end
local GUI_TAB_SET_POS = {
  x = GUI_TAB_PLIST_POS.x + GUI_TAB_PLIST_POS.w + 4,
  y = GUI_TAB_PLIST_POS.y,
  w = 618 - LIST_WIDTH,
  h = 0
}
local GUI_TAB_SET = gui.Groupbox(GUI_TAB, "Per Player Settings", GUI_TAB_SET_POS.x, GUI_TAB_SET_POS.y, GUI_TAB_SET_POS.w, GUI_TAB_SET_POS.h)
local settings_wrapper
settings_wrapper = function(settings)
  return {
    set = function(varname, value)
      settings.settings[varname] = value
      if #playerlist > 0 and playerlist[GUI_TAB_PLIST_LIST:GetValue() + 1] == settings.info.uid then
        return guisettings[varname].set(value)
      end
    end,
    get = function(varname)
      return settings.settings[varname]
    end
  }
end
plist = {
  gui = {
    Checkbox = function(varname, name, value)
      local checkbox = gui.Checkbox(GUI_TAB_SET, "settings." .. tostring(varname), name, value)
      guisettings[varname] = {
        set = function(value_)
          return checkbox:SetValue(value_)
        end,
        get = function()
          return checkbox:GetValue()
        end,
        default = value,
        obj = checkbox
      }
      for _, setting in pairs(playersettings) do
        setting.settings[varname] = value
      end
      table.insert(guiobjects, checkbox)
      return checkbox
    end,
    Slider = function(varname, name, value, min, max, step)
      local slider = gui.Slider(GUI_TAB_SET, "settings." .. tostring(varname), name, value, min, max, step or 1)
      guisettings[varname] = {
        set = function(value_)
          return slider:SetValue(value_)
        end,
        get = function()
          return slider:GetValue()
        end,
        default = value,
        obj = slider
      }
      for _, setting in pairs(playersettings) do
        setting.settings[varname] = value
      end
      table.insert(guiobjects, slider)
      return slider
    end,
    ColorPicker = function(varname, name, r, g, b, a)
      local colorpicker = gui.ColorPicker(GUI_TAB_SET, "settings." .. tostring(varname), r, g, b, a)
      guisettings[varname] = {
        set = function(value_)
          return colorpicker:SetValue(unpack(value_))
        end,
        get = function()
          return {
            colorpicker:GetValue()
          }
        end,
        default = {
          r,
          g,
          b,
          a
        },
        obj = colorpicker
      }
      for _, setting in pairs(playersettings) do
        setting.settings[varname] = {
          r,
          g,
          b,
          a
        }
      end
      table.insert(guiobjects, colorpicker)
      return colorpicker
    end,
    Text = function(varname, text)
      local text_ = gui.Text(GUI_TAB_SET, text)
      local current_text = text
      guisettings[varname] = {
        set = function(value_)
          text_:SetText(value_)
          current_text = value_
        end,
        get = function()
          return current_text
        end,
        default = text,
        obj = text_
      }
      for _, setting in pairs(playersettings) do
        setting.settings[varname] = text
      end
      table.insert(guiobjects, text)
      return text
    end,
    Combobox = function(varname, name, ...)
      local combobox = gui.Combobox(GUI_TAB_SET, "settings." .. tostring(varname), name, ...)
      guisettings[varname] = {
        set = function(value_)
          return combobox:SetValue(value_)
        end,
        get = function()
          return combobox:GetValue()
        end,
        default = 0,
        obj = combobox
      }
      for _, setting in pairs(playersettings) do
        setting.settings[varname] = 0
      end
      table.insert(guiobjects, combobox)
      return combobox
    end,
    Button = function(name, callback)
      local button = gui.Button(GUI_TAB_SET, name, function()
        if #playerlist > 0 then
          callback(playerlist[GUI_TAB_PLIST_LIST:GetValue() + 1])
        else
          callback()
        end
        
      end)
      table.insert(guiobjects, button)
      return button
    end,
    Editbox = function(varname, name)
      local editbox = gui.Editbox(GUI_TAB_SET, varname, name)
      guisettings[varname] = {
        set = function(value_)
          return editbox:SetValue(value_)
        end,
        get = function()
          return editbox:GetValue()
        end,
        default = 0,
        obj = editbox
      }
      for _, setting in pairs(playersettings) do
        setting.settings[varname] = 0
      end
      table.insert(guiobjects, editbox)
      return editbox
    end,
    Multibox = function(name)
      local multibox = gui.Multibox(GUI_TAB_SET, name)
      table.insert(guiobjects, multibox)
      return multibox
    end,
    Multibox_Checkbox = function(parent, varname, name, value)
      local checkbox = gui.Checkbox(parent, "settings." .. tostring(varname), name, value)
      guisettings[varname] = {
        set = function(value_)
          return checkbox:SetValue(value_)
        end,
        get = function()
          return checkbox:GetValue()
        end,
        default = value,
        obj = checkbox
      }
      for _, setting in pairs(playersettings) do
        setting.settings[varname] = value
      end
      return checkbox
    end,
    Delete = function(object)
      object:Delete()
      for varname, info in pairs(guisettings) do
        if info.obj == object then
          guisettings[varname] = nil
          for uid, set in pairs(playersettings) do
            set.settings[varname] = nil
          end
          break
        end
      end
    end
  },
  GetByUserID = function(userid)
    return settings_wrapper(playersettings[userid])
  end,
  GetByIndex = function(index)
    local pinfo = client.GetPlayerInfo(index)
    if pinfo ~= nil then
      return settings_wrapper(playersettings[pinfo["UserID"]])
    end
    for _, info in pairs(playersettings) do
      if info.info.index == index then
        return settings_wrapper(info)
      end
    end
  end,
  GetSelected = function()
    if #playerlist > 0 then
      settings_wrapper(playersettings[playerlist[GUI_TAB_PLIST_LIST:GetValue() + 1]])
    end
    return nil
  end,
  GetSelectedIndex = function()
    if #playerlist > 0 then
      local _ = playersettings[playerlist[GUI_TAB_PLIST_LIST:GetValue() + 1]].info.index
    end
    return nil
  end,
  GetSelectedUserID = function()
    if #playerlist > 0 then
      local _ = playerlist[GUI_TAB_PLIST_LIST:GetValue() + 1]
    end
    return nil
  end
}
local selected_player = nil
callbacks.Register("Draw", "playerlist.callbacks.Draw", function()
  if not MENU:IsActive() then
    return 
  end
  if #playerlist == 0 then
    for _index_0 = 1, #guiobjects do
      local guiobj = guiobjects[_index_0]
      guiobj:SetDisabled(true)
    end
    selected_player = nil
    return 
  elseif selected_player == nil then
    for _index_0 = 1, #guiobjects do
      local guiobj = guiobjects[_index_0]
      guiobj:SetDisabled(false)
    end
  end
  if selected_player ~= GUI_TAB_PLIST_LIST:GetValue() then
    selected_player = GUI_TAB_PLIST_LIST:GetValue()
    local set = playersettings[playerlist[GUI_TAB_PLIST_LIST:GetValue() + 1]].settings
    for varname, wrap in pairs(guisettings) do
      wrap.set(set[varname])
    end
  else
    local set = playersettings[playerlist[GUI_TAB_PLIST_LIST:GetValue() + 1]].settings
    for varname, wrap in pairs(guisettings) do
      set[varname] = wrap.get()
    end
  end
end)
local last_map = nil
callbacks.Register("CreateMove", "playerlist.callbacks.CreateMove", function(cmd)
  if engine.GetMapName() ~= last_map then
    last_map = engine.GetMapName()
    GUI_TAB_PLIST_LIST:SetOptions()
    playersettings = { }
    playerlist = { }
  end
  local _list_0 = entities.FindByClass("CCSPlayer")
  for _index_0 = 1, #_list_0 do
    local player = _list_0[_index_0]
    local uid = client.GetPlayerInfo(player:GetIndex())["UserID"]
    if playersettings[uid] == nil then
      table.insert(playerlist, uid)
      playersettings[uid] = {
        info = {
          nickname = player:GetName(),
          uid = uid,
          index = player:GetIndex()
        },
        settings = { }
      }
      local set = playersettings[uid].settings
      for varname, wrap in pairs(guisettings) do
        set[varname] = wrap.default
      end
      GUI_TAB_PLIST_LIST:SetOptions(unpack((function()
        local _accum_0 = { }
        local _len_0 = 1
        for _, v in ipairs(playerlist) do
          _accum_0[_len_0] = playersettings[v].info.nickname
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)()))
    elseif playersettings[uid].info.nickname ~= player:GetName() then
      playersettings[uid].info.nickname = player:GetName()
      GUI_TAB_PLIST_LIST:SetOptions(unpack((function()
        local _accum_0 = { }
        local _len_0 = 1
        for _, v in ipairs(playerlist) do
          _accum_0[_len_0] = playersettings[v].info.nickname
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)()))
    end
  end
end)
http.Get("https://raw.githubusercontent.com/Le0Developer/playerlist/master/version", function(content)
  if not content then
    return 
  end
  if content == __version__ then
    return 
  end
  local UPD_HEIGHT = 190
  local UPDATE = gui.Groupbox(GUI_TAB, "Update Available", GUI_TAB_PLIST_POS.x, GUI_TAB_PLIST_POS.y, 618, UPD_HEIGHT)
  local text = gui.Text(UPDATE, "Current version: " .. tostring(__version__) .. "\nLatest version: " .. tostring(content))
  local minified = gui.Checkbox(UPDATE, "updater.minified", "Download minified version", false)
  local btn
  do
    local _with_0 = gui.Button(UPDATE, "Update", function()
      text:SetText("Updating...")
      btn:SetDisabled(true)
      http.Get(((function()
        if minified:GetValue() then
          return "https://raw.githubusercontent.com/Le0Developer/playerlist/master/playerlist_minified.lua"
        else
          return "https://raw.githubusercontent.com/Le0Developer/playerlist/master/playerlist.lua"
        end
      end)()), function(luacode)
        if luacode then
          text:SetText("Saving...")
          do
            local _with_1 = file.Open(GetScriptName(), "w")
            _with_1:Write(luacode)
            _with_1:Close()
          end
          return text:SetText("Updated to version: " .. tostring(content) .. ".\nReload `" .. tostring(GetScriptName()) .. "` for changes to take effect.")
        else
          text:SetText("Failed.")
          return btn:SetDisabled(false)
        end
      end)
      
    end)
    _with_0:SetWidth(290)
    btn = _with_0
  end
  do
    local _with_0 = gui.Button(UPDATE, "Open Changelog in Browser", function()
      return panorama.RunScript("SteamOverlayAPI.OpenExternalBrowserURL( 'https://github.com/Le0Developer/playerlist/blob/master/changelog.md' );")
    end)
    _with_0:SetWidth(290)
    _with_0:SetPosX(300)
    _with_0:SetPosY(78)
  end
  GUI_TAB_PLIST_POS.y = GUI_TAB_PLIST_POS.y + UPD_HEIGHT
  GUI_TAB_PLIST:SetPosY(GUI_TAB_PLIST_POS.y)
  GUI_TAB_SET_POS.y = GUI_TAB_SET_POS.y + UPD_HEIGHT
  return GUI_TAB_SET:SetPosY(GUI_TAB_SET_POS.y)
end)
do
  local _with_0 = plist.gui.Combobox("resolver.type", "Resolver", "On", "Off", "Manual (LBY Override)")
  _with_0:SetDescription("Choose a resolver for this player.")
end
do
  local _with_0 = plist.gui.Slider("resolver.lby_override", "LBY Override Value", 0, -180, 180)
  _with_0:SetDescription("The LBY value for resolving when using manual resolver.")
end
callbacks.Register("AimbotTarget", "playerlist.extensions.Resolver.AimbotTarget", function(entity)
  if not entity:GetIndex() then
    return 
  end
  local set = plist.GetByIndex(entity:GetIndex())
  if set.get("resolver.type") == 0 then
    return gui.SetValue("rbot.accuracy.posadj.resolver", true)
  else
    return gui.SetValue("rbot.accuracy.posadj.resolver", false)
  end
end)
callbacks.Register("CreateMove", "playerlist.extensions.Resolver.CreateMove", function(cmd)
  local localplayer = entities.GetLocalPlayer()
  local _list_0 = entities.FindByClass("CCSPlayer")
  for _index_0 = 1, #_list_0 do
    local _continue_0 = false
    repeat
      local player = _list_0[_index_0]
      if not player:IsAlive() then
        _continue_0 = true
        break
      end
      local set = plist.GetByIndex(player:GetIndex())
      if set.get("resolver.type") == 2 then
        player:SetProp("m_flLowerBodyYawTarget", (player:GetProp("m_angEyeAngles").y + set.get("resolver.lby_override") + 180) % 360 - 180)
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
end)
local priority_targetted_entity = nil
local priority_targetting_priority = false
callbacks.Register("AimbotTarget", "playerlist.extensions.Priority.AimbotTarget", function(entity)
  if not entity:GetIndex() then
    return 
  end
  if priority_targetted_entity and entity:GetIndex() ~= priority_targetted_entity:GetIndex() then
    if priority_targetting_priority then
      gui.SetValue("rbot.aim.target.lock", false)
    end
    priority_targetted_entity = entity
    priority_targetting_priority = false
  elseif priority_targetting_priority then
    return gui.SetValue("rbot.aim.target.fov", 180)
  end
end)
do
  local _with_0 = plist.gui.Combobox("targetmode", "Targetmode", "Normal", "Friendly", "Priority")
  _with_0:SetDescription("Mode for targetting. NOTE: Priority on teammates attack them.")
end
local priority_lock_fov = 3
local priority_friendly_affected = { }
callbacks.Register("CreateMove", "playerlist.extensions.Priority.CreateMove", function(cmd)
  local localplayer = entities.GetLocalPlayer()
  local _list_0 = entities.FindByClass("CCSPlayer")
  for _index_0 = 1, #_list_0 do
    local _continue_0 = false
    repeat
      local player = _list_0[_index_0]
      if not player:IsAlive() then
        _continue_0 = true
        break
      end
      local set = plist.GetByIndex(player:GetIndex())
      local uid = client.GetPlayerInfo(player:GetIndex())["UserID"]
      if set.get("targetmode") == 0 and priority_friendly_affected[uid] then
        player:SetProp("m_iTeamNum", player:GetProp("m_iPendingTeamNum"))
        priority_friendly_affected[uid] = nil
      elseif set.get("targetmode") == 1 then
        player:SetProp("m_iTeamNum", localplayer:GetTeamNumber())
        priority_friendly_affected[uid] = true
      elseif set.get("targetmode") == 2 then
        if player:GetProp("m_iPendingTeamNum") == localplayer:GetTeamNumber() then
          player:SetProp("m_iTeamNum", (localplayer:GetTeamNumber() - 1) % 2 + 2)
          priority_friendly_affected[uid] = true
        else
          if priority_friendly_affected[uid] then
            player:SetProp("m_iTeamNum", player:GetProp("m_iPendingTeamNum"))
            priority_friendly_affected[uid] = nil
          end
          if not priority_targetting_priority and player:GetTeamNumber() ~= localplayer:GetTeamNumber() then
            local lp_pos = localplayer:GetAbsOrigin() + localplayer:GetPropVector("localdata", "m_vecViewOffset[0]")
            local t_pos = player:GetHitboxPosition(5)
            engine.SetViewAngles((t_pos - lp_pos):Angles())
            gui.SetValue("rbot.aim.target.fov", priority_lock_fov)
            gui.SetValue("rbot.aim.target.lock", true)
            priority_targetted_entity = player
            priority_targetting_priority = true
          end
        end
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
end)
callbacks.Register("FireGameEvent", "playerlist.extensions.Priority.FireGameEvent", function(event)
  if event:GetName() == "player_death" and priority_targetting_priority then
    if client.GetPlayerIndexByUserID(event:GetInt("userid")) == priority_targetted_entity:GetIndex() then
      priority_targetting_priority = false
      priority_targetted_entity = nil
      gui.SetValue("rbot.aim.target.fov", 180)
      return gui.SetValue("rbot.aim.target.lock", false)
    end
  end
end)
local fbsp_force = plist.gui.Multibox("Force ...")
do
  local _with_0 = plist.gui.Multibox_Checkbox(fbsp_force, "force.baim", "BAIM", false)
  _with_0:SetDescription("Set's bodyaim to priority.")
end
do
  local _with_0 = plist.gui.Multibox_Checkbox(fbsp_force, "force.safepoint", "Safepoint", false)
  _with_0:SetDescription("Shoots only on safepoint.")
end
local fbsp_weapon_types = {
  "asniper",
  "hpistol",
  "lmg",
  "pistol",
  "rifle",
  "scout",
  "shared",
  "shotgun",
  "smg",
  "sniper",
  "zeus"
}
local fbsp_cache_baim = {
  applied = false
}
local fbsp_baim_apply
fbsp_baim_apply = function()
  if fbsp_cache_baim.applied then
    print("[PLAYERLIST] WARNING: Force baim has already been applied.")
  end
  for _index_0 = 1, #fbsp_weapon_types do
    local weapon = fbsp_weapon_types[_index_0]
    if gui.GetValue("rbot.hitscan.mode." .. tostring(weapon) .. ".bodyaim") ~= 1 then
      fbsp_cache_baim[weapon] = gui.GetValue("rbot.hitscan.mode." .. tostring(weapon) .. ".bodyaim")
      gui.SetValue("rbot.hitscan.mode." .. tostring(weapon) .. ".bodyaim", 1)
    end
  end
  fbsp_cache_baim.applied = true
end
local fbsp_baim_undo
fbsp_baim_undo = function()
  if not fbsp_cache_baim.applied then
    print("[PLAYERLIST] WARNING: Force baim hasn't been applied.")
  end
  for weapon, value in pairs(fbsp_cache_baim) do
    local _continue_0 = false
    repeat
      if weapon == "applied" then
        _continue_0 = true
        break
      end
      gui.SetValue("rbot.hitscan.mode." .. tostring(weapon) .. ".bodyaim", value)
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  fbsp_cache_baim = {
    applied = false
  }
end
local fbsp_cache_sp = {
  applied = false
}
local fbsp_sp_regions = {
  "delayshot",
  "delayshotbody",
  "delayshotlimbs"
}
local fbsp_sp_apply
fbsp_sp_apply = function()
  if fbsp_cache_sp.applied then
    print("[PLAYERLIST] WARNING: Force safepoint has already been applied.")
  end
  for _index_0 = 1, #fbsp_weapon_types do
    local weapon = fbsp_weapon_types[_index_0]
    for _index_1 = 1, #fbsp_sp_regions do
      local delayshot_region = fbsp_sp_regions[_index_1]
      if gui.GetValue("rbot.hitscan.mode." .. tostring(weapon) .. "." .. tostring(delayshot_region)) ~= 1 then
        fbsp_cache_sp[tostring(weapon) .. "." .. tostring(delayshot_region)] = gui.GetValue("rbot.hitscan.mode." .. tostring(weapon) .. "." .. tostring(delayshot_region))
        gui.SetValue("rbot.hitscan.mode." .. tostring(weapon) .. "." .. tostring(delayshot_region), 1)
      end
    end
  end
  fbsp_cache_sp.applied = true
end
local fbsp_sp_undo
fbsp_sp_undo = function()
  if not fbsp_cache_sp.applied then
    print("[PLAYERLIST] WARNING: Force safepoint hasn't been applied.")
  end
  for weapon, value in pairs(fbsp_cache_sp) do
    local _continue_0 = false
    repeat
      if weapon == "applied" then
        _continue_0 = true
        break
      end
      gui.SetValue("rbot.hitscan.mode." .. tostring(weapon), value)
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  fbsp_cache_sp = {
    applied = false
  }
end
local fbsp_targetted_enemy = nil
callbacks.Register("AimbotTarget", "playerlist.extensions.FBSP.AimbotTarget", function(entity)
  if not entity:GetIndex() then
    return 
  end
  fbsp_targetted_enemy = entity
  local set = plist.GetByIndex(entity:GetIndex())
  if set.get("force.baim") then
    if not fbsp_cache_baim.applied then
      fbsp_baim_apply()
    end
  elseif fbsp_cache_baim.applied then
    fbsp_baim_undo()
  end
  if set.get("force.safepoint") then
    if not fbsp_cache_sp.applied then
      return fbsp_sp_apply()
    end
  elseif fbsp_cache_sp.applied then
    return fbsp_sp_undo()
  end
end)
callbacks.Register("FireGameEvent", "playerlist.extensions.FBSP.FireGameEvent", function(event)
  if event:GetName() == "player_death" and fbsp_targetted_enemy and client.GetPlayerIndexByUserID(event:GetInt("userid")) == fbsp_targetted_enemy:GetIndex() then
    fbsp_targetted_enemy = nil
    if fbsp_cache_baim.applied then
      fbsp_baim_undo()
    end
    if fbsp_cache_sp.applied then
      return fbsp_sp_undo()
    end
  end
end)
do
  local _with_0 = plist.gui.Checkbox("esp", "ESP", false)
  _with_0:SetDescription("Basic Box ESP.")
end
callbacks.Register("DrawESP", "playerlist.extensions.PPE.DrawESP", function(builder)
  local player = builder:GetEntity()
  if not player:IsPlayer() then
    return 
  end
  if plist.GetByIndex(player:GetIndex()).get("esp") then
    draw.Color(0x80, 0x80, 0x80, 0xFF)
    return draw.OutlinedRect(builder:GetRect())
  end
end)

