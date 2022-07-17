local tiles = require("tiles")
local math_helpers = require("math_helpers")

local function generateGrassFlowersTrees(map, x_size, y_size)
    --fill map completely with grass, flowers, and trees
    
    for x = 1, x_size do
        for y = 1, y_size do

            map[x][y] = tiles.grass

            local chanceForMeadow = math.random(1,20)
            if chanceForMeadow == 1 then
                
                local meadowStartX = math.max(1, x - math.random(1,4))
                local meadowEndX = math.min(x_size, math.random(meadowStartX, meadowStartX + 8))
                local meadowStartY = math.max(1, y - math.random(1,4))
                local meadowEndY = math.min(y_size, math.random(meadowStartY, meadowStartY + 8))
                
                for mx = meadowStartX, meadowEndX do
                    for my = meadowStartY, meadowEndY do
                        
                        local chanceForFlowerInMeadow = math.random(1,4)
                        if chanceForFlowerInMeadow == 1 then
                            map[mx][my] = tiles.grass_flowers
                        end

                    end
                end

            end
            
            local chanceForTree = math.random(1,7)
            if chanceForTree == 1 then
                map[x][y] = tiles.grass_tree
            end
            
        end
    end
end

local function generateRivers(map, x_size, y_size)
    
    local river_x = math.random(3, x_size - 3)
    local river_y = math.random(math.floor(y_size/3), y_size-3)

    for x = 1, x_size do
        map[x][river_y - 1] = tiles.river_bottom
        map[x][river_y] = tiles.river
        map[x][river_y + 1] = tiles.river_top
    end

    for y = 1, y_size do
        if y == river_y + 1 then
            map[river_x - 1][y] = tiles.river_top_left
            map[river_x][y] = tiles.river
            map[river_x + 1][y] = tiles.river_top_right
        elseif y == river_y - 1 then
            map[river_x - 1][y] = tiles.river_bottom_left
            map[river_x][y] = tiles.river
            map[river_x + 1][y] = tiles.river_bottom_right
        elseif y ~= river_y then
            map[river_x - 1][y] = tiles.river_left
            map[river_x][y] = tiles.river
            map[river_x + 1][y] = tiles.river_right
        end
    end
    
end

local function generateSea(map, x_size, y_size)
    
    local sand_size = math.random(4)
    local water_shallow_size = math.random(4)
    local water_size = math.random(4)
    local water_deep_size = math.random(6)
    
    local sea_size = math.min(y_size, sand_size + water_shallow_size + water_size + water_deep_size)

    for y = 1, sea_size do

        local water_type
        if sea_size - y <= sand_size then water_type = tiles.sand
        elseif sea_size - y <= sand_size + water_shallow_size then water_type = tiles.water_shallow
        elseif sea_size - y <= sand_size + water_shallow_size + water_size then water_type = tiles.water
        else water_type = tiles.water_deep
        end

        for x = 1, x_size do

            if water_type == tiles.sand then

                if string.find(map[x][y], "river") then
                    map[x][y] = tiles.water
                else
                    local chanceForPalm = math.random(10)
                    if chanceForPalm == 1 then
                        map[x][y] = tiles.sand_palm
                    else
                        map[x][y] = tiles.sand
                    end
                end

            elseif water_type == tiles.water_shallow then

                if string.find(map[x][y], "river") then
                    map[x][y] = tiles.water
                else
                    map[x][y] = tiles.water_shallow
                end

            else

                map[x][y] = water_type

            end
            
        end
        
    end
    
end

local function generateSettlements (map, x_size, y_size)

    local map_area = x_size * y_size
    local number_of_settlements = math.random( math.floor(map_area/100) )

    for i = 1, number_of_settlements do

        local x = math.random(x_size)
        local y = math.random(y_size)

        if string.find(map[x][y], "grass") then map[x][y] = tiles.grass_settlement
        elseif string.find(map[x][y], "sand") then map[x][y] = tiles.sand_settlement
        elseif map[x][y] == tiles.water or string.find(map[x][y], "river") then map[x][y] = tiles.water_settlement
        elseif map[x][y] == tiles.water_shallow then map[x][y] = tiles.water_shallow_settlement
        elseif map[x][y] == tiles.water_deep then map[x][y] = tiles.water_deep_settlement
        else map[x][y] = tiles.grass_settlement
        end

    end


end


-- local function isRoadTile(map, x, y)

--     --detect if we are out of bounds
--     if not map[x] then
--         return false
--     elseif not map[x][y] then
--         return false
--     end

--     if string.find(map[x][y], "road") then
--         return true
--     end

--     return false
-- end

-- local function cleanUpRoads(map, x_size, y_size)

--     for x = 1, x_size do
--         for y = 1, y_size do
--             if string.find(map[x][y], "road") then
--                 local roadToTop = isRoadTile(map, x, y + 1)
--                 local roadToRight = isRoadTile(map, x + 1, y)
--                 local roadToBottom = isRoadTile(map, x, y - 1)
--                 local roadToLeft = isRoadTile(map, x - 1, y)

--                 if roadToLeft and roadToRight and not roadToBottom and not roadToTop then
--                     map[x][y] = 
--                 end
--             end
--         end
--     end

-- end

local function placeRoad(map, x, y, direction)
    local orientation = ""
    if direction[1] == 0 then
        orientation = "v"
    else
        orientation = "h"
    end

    if string.find(map[x][y], "road") then
        orientation = "c"
    end

    if string.find(map[x][y], "river") or string.find(map[x][y], "water") then
        map[x][y] = tiles["water_road_" .. orientation]
    elseif string.find(map[x][y], "sand") then
        map[x][y] = tiles["sand_road_" .. orientation]
    else
        map[x][y] = tiles["grass_road_" .. orientation]
    end
end

local function generateRoads(map, x_size, y_size)
    
    local road_x = 1 + math.random(x_size - 2)
    local road_y = 1 + math.random(y_size - 2)
    local city_y = math.floor(math.random(1,road_y-1))
    
    -- generate horizontal road
    for x = 1, x_size do
        if string.find(map[x][road_y], "river") or string.find(map[x][road_y], "water") then
            map[x][road_y] = tiles.water_road_h
        elseif string.find(map[x][road_y], "sand") then
            map[x][road_y] = tiles.sand_road_h
        else
            map[x][road_y] = tiles.grass_road_h
        end
    end
    
    -- generate vertical road
    for y = 1, y_size do
        
        if string.find(map[road_x][y], "sand") then
            map[road_x][y] = tiles.sand_road_v
        elseif map[road_x][y] == tiles.sand_road_h then
            map[road_x][y] = tiles.sand_road_c
        elseif map[road_x][y] == tiles.water_road_h then
            map[road_x][y] = tiles.water_road_c
        elseif string.find(map[road_x][y], "river") or string.find(map[road_x][y], "water") then
            map[road_x][y] = tiles.water_road_v
        elseif map[road_x][y] == tiles.grass_road_h then
            map[road_x][y] = tiles.grass_road_c
        else
            map[road_x][y] = tiles.grass_road_v
        end
        
    end

    --scan the map to find all the settlements' coordinates
    local settlementCoordinates = {}
    local settlementCount = 0
    for x = 1, x_size do
        for y = 1, y_size do
            print("x: " .. x .. "  y: " .. y .. " : " .. map[x][y])
            if string.find(map[x][y], "settlement") then
                settlementCount = settlementCount + 1
                settlementCoordinates[settlementCount] = {x,y}
            end
        end
    end

    --create roads linking settlements to main roads
    for i = 1, settlementCount do
    
        local x = settlementCoordinates[i][1]
        local y = settlementCoordinates[i][2]

        local distanceToHorizontalRoad = math.abs(road_x - x)
        local distanceToVerticalRoad = math.abs(road_y - y)

        local targetX
        local targetY
        local direction = {0,0}

        if distanceToHorizontalRoad < distanceToVerticalRoad then
            targetX = road_x
            targetY = y
            direction[1] = math_helpers.sign(road_x - x)
        else
            targetX = x
            targetY = road_y
            direction[2] = math_helpers.sign(road_y - y)
        end
    
        while x ~= targetX or y ~= targetY do

            x = x + direction[1]
            y = y + direction[2]

            placeRoad(map, x, y, direction)
    
        end
    
    end

    
end


local M = {}

function M.generate_map(x_size, y_size, options, seed)
    --map is indexed as map[x][y] with origin [1][1] at bottom-left
    --each index of the map is a number corresponding to a tile type
    
    --boolean options (flags) that can be passed to generate_map() are... [rivers], [sea], [roads], and [settlements]    
    
    math.randomseed(seed)

    --initialize map data structure
    local map = {}
    for x = 1, x_size do
        if not map[x] then map[x] = {} end
    end
    
    generateGrassFlowersTrees(map, x_size, y_size)
    
    if options.rivers then    
        generateRivers(map, x_size, y_size)
    end
    
    if options.sea then
        generateSea(map, x_size, y_size)
    end

    if options.settlements then
        generateSettlements(map, x_size, y_size)
    end

    if options.roads then
        generateRoads(map, x_size, y_size)
    end

    return map
end

return M