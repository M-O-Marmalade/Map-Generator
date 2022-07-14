_AUTO_RELOAD_DEBUG = true --Renoise will hot-reload changes to code

local app = renoise.app()
local tool = renoise.tool()
local vb = renoise.ViewBuilder()
local window = {
  obj = nil,
  content = nil
}


local function show_window()

  --prepare the window content if it hasn't been done yet
  if not window.content then
    window.content = vb:column {  --our entire view will be in one big column

    }
  end

  --create/show the dialog window
  if not window.obj or not window.obj.visible then
    window.obj = app:show_custom_dialog("MapGenerator", window.content)
  else window.obj:show() end

  return true
end

--MENU/HOTKEY ENTRIES-----------------------

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:Map Generator...", 
  invoke = function() show_window() end
}

renoise.tool():add_keybinding {
  name = "Global:Tools:Map Generator...",
  invoke = function() show_window() end 
}