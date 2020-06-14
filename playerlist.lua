local randomname = ""
for i = 1, 16 do
  local rand = math.random(1, 16)
  randomname = randomname .. ("0123456789abcdef"):sub(rand, rand)
end
local MENU = gui.Reference("Menu")
local GUI_ENABLE = gui.Checkbox(gui.Reference("Misc", "General", "Extra"), "playerlist.enable", "Player List", false)
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
      if playerlist[GUI_WINDOW_PLIST_LIST:GetValue() + 1] == value.info.uid then
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
      local combobox = gui.Slider(GUI_WINDOW_SET, "settings." .. tostring(varname), name, ...)
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
  if not GUI_WINDOW:IsActive() then
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
callbacks.Register("CreateMove", "playerlist.callbacks.CreateMove", function(cmd)
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
        for _, v in pairs(playersettings) do
          _accum_0[_len_0] = v.info.nickname
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)()))
    elseif playersettings[uid].info.nickname ~= player:GetName() then
      playersettings[uid].info.nickname = player:GetName()
      GUI_WINDOW_PLIST_LIST:SetOptions(unpack((function()
        local _accum_0 = { }
        local _len_0 = 1
        for _, v in pairs(playersettings) do
          _accum_0[_len_0] = v.info.nickname
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
      if not player:IsAlive() or player:GetTeamNumber() == localplayer:GetTeamNumber() then
        _continue_0 = true
        break
      end
      local set = plist.GetByIndex(player:GetIndex())
      if set.get("lby_override.toggle") then
        player:SetProp("m_flLowerBodyYawTarget", (player:GetProp("m_angEyeAngles")(set.get("lby_override.value") + 180)) % 360 - 180)
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
end)

