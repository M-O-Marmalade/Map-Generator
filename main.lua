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

local tiles = require("tiles")

local map_x_size = 20
local map_y_size = 20

local map_options = {

  trees = true,
  trees_options = {
    tree_rarity = 20,
    forest_rarity = 270,
    tree_frequency_in_forest = 3,
    min_forest_size = 1,
    max_forest_size = 8
  },

  flowers = true,
  flowers_options = {
    meadow_rarity = 70,
    flower_rarity_in_meadow = 2,
    min_meadow_size = 1,
    max_meadow_size = 8,
  },

  rivers = true,
  sea = true,
  roads = true,

  settlements = true,
  settlements_options = {
    settlements_amount_min = 2,
    settlements_amount_max = 8
  }

}

local function show_window()

  --prepare the window content if it hasn't been done yet
  if not window.content then

    local rack_styles = {
      "invisible", -- no background
      "plain", -- undecorated, single coloured background
      "border", -- same as plain, but with a bold nested border
      "body", -- main "background" style, as used in dialog backgrounds
      "panel", -- alternative "background" style, beveled
      "group", -- background for "nested" groups within body
    }
    local default_style = rack_styles[6]

    local fonts = {
      "normal",
      "big",
      "bold",
      "italic",
      "mono"
    }
    local title_font = fonts[2]

    window.content = vb:row {  --our entire view will be in one big column
      
      vb:column {
        id = "map_column"
      },

      vb:column {
        spacing = 10,

        vb:button {
          text = "Generate Map",
          height = 32,
          width = "100%",
          notifier = function ()
            if map_view then vb.views.map_column:remove_child( map_view ) end
            map_view = map_generator_to_renoise.requestMap(
              vb,
              map_x_size,
              map_y_size,
              tiles,
              map_options,
              math.floor(os.clock() * 100)
            )
            vb.views.map_column:add_child( map_view )
          end
        },
        
        vb:horizontal_aligner {
          mode = "center",

          vb:column {
            vb:horizontal_aligner {
              vb:text{text = "Map Size", font = title_font},
              mode = "center"
            },
            style = default_style,

            vb:row {
              vb:text {text = "X Size"},
              vb:valuebox {
                value = map_x_size,
                notifier = function(val)
                  map_x_size = val
                end
              },
            },
            
            vb:row {
              vb:text {text = "Y Size"},
              vb:valuebox {
                value = map_y_size,
                notifier = function(val)
                  map_y_size = val
                end
              },
            }
          }

        },
        
        --trees
        vb:horizontal_aligner {
          mode = "center",

          vb:column {
            vb:horizontal_aligner {
              vb:text{text = "Trees", font = title_font},
              mode = "center"
            },
            style = default_style,
            
            vb:row {
              vb:text {text = "Trees"},
              vb:checkbox {
                value = map_options.trees,
                notifier = function(val)
                  map_options.trees = val
                end
              },
            },
            
            vb:row {
              vb:text {text = "Tree Rarity"},
              vb:valuebox {
                value = map_options.trees_options.tree_rarity,
                min = 1,
                notifier = function(val)
                  map_options.trees_options.tree_rarity = val
                end
              }
            },
            
            vb:row {
              vb:text {text = "Forest Rarity"},
              vb:valuebox {
                value = map_options.trees_options.forest_rarity,
                min = 1,
                max = 1000,
                notifier = function(val)
                  map_options.trees_options.forest_rarity = val
                end
              }
            },
            
            vb:row {
              vb:text {text = "Tree Frequency (in Forest)"},
              vb:valuebox {
                value = map_options.trees_options.tree_frequency_in_forest,
                min = 1,
                notifier = function(val)
                  map_options.trees_options.tree_frequency_in_forest = val
                end
              }
            },
            
            vb:row {
              vb:text {text = "Min Forest Size"},
              vb:valuebox {
                value = map_options.trees_options.min_forest_size,
                min = 1,
                notifier = function(val)
                  map_options.trees_options.min_forest_size = val
                end
              }
            },
            
            vb:row {
              vb:text {text = "Max Forest Size"},
              vb:valuebox {
                value = map_options.trees_options.max_forest_size,
                min = 1,
                notifier = function(val)
                  map_options.trees_options.max_forest_size = val
                end
              }
            },
          }

        },
        
        --flowers
        vb:horizontal_aligner {
          mode = "center",

          vb:column {
            vb:horizontal_aligner {
              vb:text{text = "Flowers", font = title_font},
              mode = "center"
            },
            style = default_style,

            vb:row {
              vb:text {text = "Flowers"},
              vb:checkbox {
                value = map_options.flowers,
                notifier = function(val)
                  map_options.flowers = val
                end
              },
            },

            vb:row {
              vb:text {text = "Meadow Rarity"},
              vb:valuebox {
                value = map_options.flowers_options.meadow_rarity,
                min = 1,
                notifier = function(val)
                  map_options.flowers_options.meadow_rarity = val
                end
              }
            },

            vb:row {
              vb:text {text = "Flower Rarity (in Meadow)"},
              vb:valuebox {
                value = map_options.flowers_options.flower_rarity_in_meadow,
                min = 1,
                notifier = function(val)
                  map_options.flowers_options.flower_rarity_in_meadow = val
                end
              }
            },

            vb:row {
              vb:text {text = "Min Meadow Size"},
              vb:valuebox {
                value = map_options.flowers_options.min_meadow_size,
                min = 1,
                notifier = function(val)
                  map_options.flowers_options.min_meadow_size = val
                end
              }
            },

            vb:row {
              vb:text {text = "Max Meadow Size"},
              vb:valuebox {
                value = map_options.flowers_options.max_meadow_size,
                min = 1,
                notifier = function(val)
                  map_options.flowers_options.max_meadow_size = val
                end
              }
            }
          }

        },

        --rivers
        vb:horizontal_aligner {
          mode = "center",

          vb:column {
            vb:horizontal_aligner {
              vb:text{text = "Rivers", font = title_font},
              mode = "center"
            },
            style = default_style,

            vb:row {
              vb:text {text = "Rivers"},
              vb:checkbox {
                value = map_options.rivers,
                notifier = function(val)
                  map_options.rivers = val
                end
              },
            }
          }

        },

        --sea
        vb:horizontal_aligner {
          mode = "center",

          vb:column {
            vb:horizontal_aligner {
              vb:text{text = "Sea", font = title_font},
              mode = "center"
            },
            style = default_style,

            vb:row {
              vb:text {text = "Sea"},
              vb:checkbox {
                value = map_options.sea,
                notifier = function(val)
                  map_options.sea = val
                end
              },
            }
          }

        },

        --roads
        vb:horizontal_aligner {
          mode = "center",

          vb:column {
            vb:horizontal_aligner {
              vb:text{text = "Roads", font = title_font},
              mode = "center"
            },
            style = default_style,

            vb:row {
              vb:text {text = "Roads"},
              vb:checkbox {
                value = map_options.roads,
                notifier = function(val)
                  map_options.roads = val
                end
              },
            }
          }

        },

        --settlements
        vb:horizontal_aligner {
          mode = "center",

          vb:column {
            vb:horizontal_aligner {
              vb:text{text = "Settlements", font = title_font},
              mode = "center"
            },
            style = default_style,

            vb:row {
              vb:text {text = "Settlements"},
              vb:checkbox {
                value = map_options.settlements,
                notifier = function(val)
                  map_options.settlements = val
                end
              },
            },

            vb:row {
              vb:text {text = "Settlements Amount Min"},
              vb:valuebox {
                value = map_options.settlements_options.settlements_amount_min,
                min = 1,
                notifier = function(val)
                  map_options.settlements_options.settlements_amount_min = val
                end
              }
            },
            
            vb:row {
              vb:text {text = "Settlements Amount Max"},
              vb:valuebox {
                value = map_options.settlements_options.settlements_amount_max,
                min = 1,
                notifier = function(val)
                  map_options.settlements_options.settlements_amount_max = val
                end
              }
            },
            
          }

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