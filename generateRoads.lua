local math_helpers = require("math_helpers")

-- local function isRoadTile(map, x, y, tiles)

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

-- local function cleanUpRoads(map, map_x_size, map_y_size)

--     for x = 1, map_x_size do
--         for y = 1, map_y_size do
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

local function placeRoad(map, x, y, tiles, direction)
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

local function generateRoads(map, map_x_size, map_y_size, tiles)
    
    local road_x = 1 + math.random(map_x_size - 2)
    local road_y = 1 + math.random(map_y_size - 2)
    local city_y = math.floor(math.random(1,road_y-1))
    
    -- generate horizontal road
    for x = 1, map_x_size do
        if string.find(map[x][road_y], "river") or string.find(map[x][road_y], "water") then
            map[x][road_y] = tiles.water_road_h
        elseif string.find(map[x][road_y], "sand") then
            map[x][road_y] = tiles.sand_road_h
        else
            map[x][road_y] = tiles.grass_road_h
        end
    end
    
    -- generate vertical road
    for y = 1, map_y_size do
        
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
    for x = 1, map_x_size do
        for y = 1, map_y_size do
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

            placeRoad(map, x, y, tiles, direction)
    
        end
    
    end

end

return generateRoads