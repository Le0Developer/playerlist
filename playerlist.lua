local __author__ = "LeoDeveloper"
local __verison__ = "1.0.3"
local randomname = ""
for i = 1, 16 do
  local rand = math.random(1, 16)
  randomname = randomname .. ("0123456789abcdef"):sub(rand, rand)
end
local MENU = gui.Reference("Menu")
local GUI_ENABLE
do
  local _with_0 = gui.Checkbox(gui.Reference("Misc", "General", "Extra"), "playerlist.enable", "Player List", false)
  _with_0:SetDescription("Show Player List Window.")
  GUI_ENABLE = _with_0
end
local GUI_WINDOW_POS = {
  x = 100,
  y = 100,
  w = 400,
  h = 400
}
local LIST_WIDTH = GUI_WINDOW_POS.w / 2 - 8
local GUI_WINDOW = gui.Window("playerlist" .. tostring(randomname), "Player List", GUI_WINDOW_POS.x, GUI_WINDOW_POS.y, GUI_WINDOW_POS.w, GUI_WINDOW_POS.h)
local GUI_WINDOW_PLIST_POS = {
  x = 8,
  y = 8,
  w = LIST_WIDTH,
  h = GUI_WINDOW_POS.h - 16
}
local GUI_WINDOW_PLIST = gui.Groupbox(GUI_WINDOW, "Select a player", GUI_WINDOW_PLIST_POS.x, GUI_WINDOW_PLIST_POS.y, GUI_WINDOW_PLIST_POS.w, GUI_WINDOW_PLIST_POS.h)
local GUI_WINDOW_PLIST_LIST = gui.Listbox(GUI_WINDOW_PLIST, "players", GUI_WINDOW_POS.h - 106)
local GUI_WINDOW_SET_POS = {
  x = GUI_WINDOW_PLIST_POS.x + GUI_WINDOW_PLIST_POS.w + 4,
  y = GUI_WINDOW_PLIST_POS.y,
  w = GUI_WINDOW_POS.w - LIST_WIDTH - 16,
  h = GUI_WINDOW_POS.h
}
local GUI_WINDOW_SET = gui.Groupbox(GUI_WINDOW, "Per Player Settings", GUI_WINDOW_SET_POS.x, GUI_WINDOW_SET_POS.y, GUI_WINDOW_SET_POS.w, GUI_WINDOW_SET_POS.h)
local guisettings = { }
local playerlist = { }
local playersettings = { }
local setting_wrapper
setting_wrapper = function(settings)
  return {
    set = function(varname, value)
      settings.settings[varname] = value
      if #playerlist > 0 and playerlist[GUI_WINDOW_PLIST_LIST:GetValue() + 1] == settings.info.uid then
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
      local checkbox = gui.Checkbox(GUI_WINDOW_SET, "settings." .. tostring(varname), name, value)
      guisettings[varname] = {
        set = function(value_)
          return checkbox:SetValue(value_)
        end,
        get = function()
          return checkbox:GetValue()
        end,
        default = value
      }
      for _, setting in pairs(playersettings) do
        setting.settings[varname] = value
      end
      return checkbox
    end,
    Slider = function(varname, name, value, min, max, step)
      local slider = gui.Slider(GUI_WINDOW_SET, "settings." .. tostring(varname), name, value, min, max, step or 1)
      guisettings[varname] = {
        set = function(value_)
          return slider:SetValue(value_)
        end,
        get = function()
          return slider:GetValue()
        end,
        default = value
      }
      for _, setting in pairs(playersettings) do
        setting.settings[varname] = value
      end
      return slider
    end,
    ColorPicker = function(varname, name, r, g, b, a)
      local colorpicker = gui.ColorPicker(GUI_WINDOW_SET, "settings." .. tostring(varname), r, g, b, a)
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
        }
      }
      for _, setting in pairs(playersettings) do
        setting.settings[varname] = {
          r,
          g,
          b,
          a
        }
      end
      return colorpicker
    end,
    Text = function(varname, text)
      local text_ = gui.Text(GUI_WINDOW_SET, text)
      local current_text = text
      guisettings[varname] = {
        set = function(value_)
          text_:SetText(value_)
          current_text = value_
        end,
        get = function()
          return current_text
        end,
        default = text
      }
      for _, setting in pairs(playersettings) do
        setting.settings[varname] = text
      end
      return text
    end,
    Combobox = function(varname, name, ...)
      local combobox = gui.Combobox(GUI_WINDOW_SET, "settings." .. tostring(varname), name, ...)
      guisettings[varname] = {
        set = function(value_)
          return combobox:SetValue(value_)
        end,
        get = function()
          return combobox:GetValue()
        end,
        default = 0
      }
      for _, setting in pairs(playersettings) do
        setting.settings[varname] = 0
      end
      return combobox
    end,
    Button = function(name, callback)
      return gui.Button(GUI_WINDOW_SET, name, function()
        if #playerlist > 0 then
          return callback(playerlist[GUI_WINDOW_PLIST_LIST:GetValue() + 1])
        else
          return callback()
        end
      end)
    end,
    Editbox = function(varname, name)
      local editbox = gui.Editbox(GUI_WINDOW_SET, varname, name)
      guisettings[varname] = {
        set = function(value_)
          return editbox:SetValue(value_)
        end,
        get = function()
          return editbox:GetValue()
        end,
        default = 0
      }
      for _, setting in pairs(playersettings) do
        setting.settings[varname] = 0
      end
      return editbox
    end
  },
  GetByUserID = function(userid)
    return setting_wrapper(playersettings[userid])
  end,
  GetByIndex = function(index)
    local pinfo = client.GetPlayerInfo(index)
    if pinfo ~= nil then
      return setting_wrapper(playersettings[pinfo["UserID"]])
    end
    for _, info in pairs(playersettings) do
      if info.info.index == index then
        return setting_wrapper(info)
      end
    end
  end
}
local selected_player = nil
callbacks.Register("Draw", "playerlist.callbacks.Draw", function()
  GUI_WINDOW:SetActive(GUI_ENABLE:GetValue() and MENU:IsActive())
  if not GUI_WINDOW:IsActive() or #playerlist == 0 then
    return 
  end
  if selected_player ~= GUI_WINDOW_PLIST_LIST:GetValue() then
    selected_player = GUI_WINDOW_PLIST_LIST:GetValue()
    local set = playersettings[playerlist[GUI_WINDOW_PLIST_LIST:GetValue() + 1]].settings
    for varname, wrap in pairs(guisettings) do
      wrap.set(set[varname])
    end
  else
    local set = playersettings[playerlist[GUI_WINDOW_PLIST_LIST:GetValue() + 1]].settings
    for varname, wrap in pairs(guisettings) do
      set[varname] = wrap.get()
    end
  end
end)
local last_map = nil
callbacks.Register("CreateMove", "playerlist.callbacks.CreateMove", function(cmd)
  if engine.GetMapName() ~= last_map then
    last_map = engine.GetMapName()
    GUI_WINDOW_PLIST_LIST:SetOptions()
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
      GUI_WINDOW_PLIST_LIST:SetOptions(unpack((function()
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
      GUI_WINDOW_PLIST_LIST:SetOptions(unpack((function()
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
plist.gui.Checkbox("lby_override.toggle", "LBY Override", false)
plist.gui.Slider("lby_override.value", "LBY Override Value", 0, -58, 58)
callbacks.Register("CreateMove", "playerlist.plugins.LBY_Override", function(cmd)
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
      if set.get("lby_override.toggle") then
        player:SetProp("m_flLowerBodyYawTarget", (player:GetProp("m_angEyeAngles").y + set.get("lby_override.value") + 180) % 360 - 180)
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
callbacks.Register("AimbotTarget", "playerlist.plugins.Priority.AimbotTarget", function(entity)
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
plist.gui.Combobox("priority", "Priority", "Normal", "Friendly", "Priority")
local priority_lock_fov = 3
local priority_friendly_affected = { }
callbacks.Register("CreateMove", "playerlist.plugins.Priority.CreateMove", function(cmd)
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
      if set.get("priority") == 0 and priority_friendly_affected[uid] then
        player:SetProp("m_iTeamNum", player:GetProp("m_iPendingTeamNum"))
        priority_friendly_affected[uid] = nil
      elseif set.get("priority") == 1 then
        player:SetProp("m_iTeamNum", localplayer:GetTeamNumber())
        priority_friendly_affected[uid] = true
      elseif set.get("priority") == 2 then
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
callbacks.Register("FireGameEvent", "playerlist.plugins.Priority.FireGameEvent", function(event)
  if event:GetName() == "player_death" and priority_targetting_priority then
    if client.GetPlayerIndexByUserID(event:GetInt("userid")) == priority_targetted_entity:GetIndex() then
      priority_targetting_priority = false
      priority_targetted_entity = nil
      gui.SetValue("rbot.aim.target.fov", 180)
      return gui.SetValue("rbot.aim.target.lock", false)
    end
  end
end)
plist.gui.Checkbox("force.baim", "Force BAIM", false)
plist.gui.Checkbox("force.safepoint", "Force Safepoint", false)
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
callbacks.Register("AimbotTarget", "playerlist.plugins.FBSP.AimbotTarget", function(entity)
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
callbacks.Register("FireGameEvent", "playerlist.plugins.FBSP.FireGameEvent", function(event)
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
plist.gui.Checkbox("esp", "ESP", false)
callbacks.Register("DrawESP", "playerlist.plugins.PPE.DrawESP", function(builder)
  local player = builder:GetEntity()
  if not player:IsPlayer() then
    return 
  end
  if plist.GetByIndex(player:GetIndex()).get("esp") then
    draw.Color(0x80, 0x80, 0x80, 0xFF)
    return draw.OutlinedRect(builder:GetRect())
  end
end)

