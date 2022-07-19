local generateGrass = require("generateGrass")
local generateTrees = require("generateTrees")
local generateFlowers = require("generateFlowers")
local generateRivers = require("generateRivers")
local generateSea = require("generateSea")
local generateSettlements = require("generateSettlements")
local generateRoads = require("generateRoads")


local M = {}

function M.requestMap(map_x_size, map_y_size, tiles, options, seed)
    -- map is indexed as map[x][y] with origin [1][1] at bottom-left
    -- each index of the map is a string provided by tiles.lua
    -- each string in tiles.lua corresponds to a tile's filename (without the filetype extension)
    
    -- options that can be passed to requestMap() are... 
    -- (indented options are required if their parent boolean option is true)
    --
    --   trees ... (boolean)
    --     trees_options {
    --       tree_rarity ... (number)
    --       forest_rarity ... (number)
    --       tree_frequency_in_forest ... (number)
    --       min_forest_size ... (number)
    --       max_forest_size ... (number)
    --     }
    --
    --   flowers ... (boolean)
    --     flowers_options {
    --       meadow_rarity ... (number)
    --       flower_rarity_in_meadow ... (number)
    --       min_meadow_size ... (number)
    --       max_meadow_size ... (number)
    --     }
    --
    --   rivers ... (boolean)
    --   sea ... (boolean)
    --   roads ... (boolean)
    --
    --   settlements ... (boolean)
    --     settlements_options {
    --       settlements_amount_min ... (number)
    --       settlements_amount_max ... (number)
    --     }
    --
    
    
    --initialize map data structure
    local map = {}
    for x = 1, map_x_size do
        if not map[x] then map[x] = {} end
    end
    
    math.randomseed(seed)

    generateGrass(map, map_x_size, map_y_size, tiles)

    if options.trees then
        generateTrees(map, map_x_size, map_y_size, tiles, options.trees_options)
    end

    if options.flowers then
        generateFlowers(map, map_x_size, map_y_size, tiles, options.flowers_options)
    end
    
    if options.rivers then
        generateRivers(map, map_x_size, map_y_size, tiles)
    end
    
    if options.sea then
        generateSea(map, map_x_size, map_y_size, tiles)
    end

    if options.settlements then
        generateSettlements(map, map_x_size, map_y_size, tiles, options.settlements_options)
    end

    if options.roads then
        generateRoads(map, map_x_size, map_y_size, tiles)
    end

    return map
end

return M