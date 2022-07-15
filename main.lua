_AUTO_RELOAD_DEBUG = true --Renoise will hot-reload changes to code

local app = renoise.app()
local tool = renoise.tool()
local vb = renoise.ViewBuilder()
local window = {
  obj = nil,
  content = nil
}
local map_generator_to_renoise = require("map_generator_to_renoise")
local map_view = nil;

local function show_window()

  --prepare the window content if it hasn't been done yet
  if not window.content then
    window.content = vb:column {  --our entire view will be in one big column
      
      vb:column {
        id = "map_column"
      },

      vb:row {

        vb:button {
          text = "Generate Map",
          notifier = function ()
            math.randomseed(math.floor(os.clock()))
            if map_view then vb.views.map_column:remove_child( map_view ) end
            map_view = map_generator_to_renoise.request_map( 
              vb, 
              vb.views.x_size_box.value, 
              vb.views.y_size_box.value, 
              {rivers=true, sea=true, roads=true, cities=true}, 
              "bitmaps/"
            )
            vb.views.map_column:add_child( map_view )
          end
        },
        
        vb:text {
          text = "X Size:"
        },

        vb:valuebox {
          id = "x_size_box",
          value = 24
        },

        vb:text {
          text = "Y Size:"
        },
  
        vb:valuebox {
          id = "y_size_box",
          value = 24
        }
      }
    }

  end

  --create/show the dialog window
  if not window.obj or not window.obj.visible then
    window.obj = app:show_custom_dialog("Map Generator", window.content)
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