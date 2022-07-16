local M = {}

function M.generate_map(x_size, y_size, options, seed)
    --map is indexed as map[x][y] with origin [1][1] at bottom-left
    --options are... rivers, sea, roads, and cities

    local tiles = {
        [1] = "grass",
        [2] = "flowers",
        [3] = "tree",

        [4] = "sand",
        [5] = "water",
        [6] = "water_deep",
        [7] = "water_shallow",
        [8] = "river_left",
        [9] = "river_right",
        [10] = "river_top",
        [11] = "river_bottom",
        [12] = "river_top_left",
        [13] = "river_top_right",
        [14] = "river_bottom_left",
        [15] = "river_bottom_right",

        [16] = "road_h",
        [17] = "road_v",
        [18] = "road_cross",
        [19] = "bridge_h",
        [20] = "bridge_v",

        [21] = "city_grass",
        [22] = "city_sand",
        [23] = "city_water",
        [24] = "city_water_deep",
        [25] = "city_water_shallow"
    }
    
    
    math.randomseed(seed)
    math.random()
    math.random()
    math.random()
    math.random()
    math.random()
    math.random()
    math.random()
    local sea_size = math.random(math.min(math.floor(y_size/3), 7), math.floor(y_size/2))
    local river_x = math.random(3, x_size - 3)
    local river_y = math.random(sea_size+3, y_size-3)
    local road_x
    local road_y
    for i = 1, 300 do
        road_y = 1 + math.random(y_size - 2)
        if math.abs(road_y - river_y) > 2 and road_y > sea_size + 2 then break
        elseif i == 300 then
            options.roads = false
        end
    end
    
    for i = 1, 300 do
        road_x = 1 + math.random(x_size - 2)
        if math.abs(road_x - river_x) > 2 then break
        elseif i == 300 then
            options.roads = false
        end
    end
    local city_y = math.floor(math.random(1,road_y-1))
    

    --initialize map data structure
    local map = {}
    for x = 1, x_size do
        if not map[x] then map[x] = {} end
    end
    
    --fill map with grass, flowers, and trees
    local terrainEnum = {1, 2, 3}   --1 = grass, 2 = flowers, and 3 = tree in tiles{}
    for x = 1, x_size do
        for y = 1, y_size do

            map[x][y] = tiles[1]

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
                            map[mx][my] = tiles[2]
                        end

                    end
                end

            end

            local chanceForTree = math.random(1,7)
            if chanceForTree == 1 then
                map[x][y] = tiles[3]
            end

        end
    end
    
    if options.rivers then        
        for x = 1, x_size do
            map[x][river_y - 1] = "river_bottom"
            map[x][river_y] = "water"
            map[x][river_y + 1] = "river_top"
        end

        for y = 1, y_size do
            if y == river_y + 1 then
                map[river_x - 1][y] = "river_top_left"
                map[river_x][y] = "water"
                map[river_x + 1][y] = "river_top_right"
            elseif y == river_y - 1 then
                map[river_x - 1][y] = "river_bottom_left"
                map[river_x][y] = "water"
                map[river_x + 1][y] = "river_bottom_right"
            elseif y ~= river_y then
                map[river_x - 1][y] = "river_left"
                map[river_x][y] = "water"
                map[river_x + 1][y] = "river_right"
            end
        end
    end
    
    if options.sea then
        for y = 0, sea_size do
            local water_type
            if sea_size - y < 2 then
                water_type = "sand"
            elseif sea_size - y < 4 then
                water_type = "water_shallow"
            elseif sea_size - y < 6 then
                water_type = "water"
            else
                water_type = "water_deep"
            end

            for x = 1, x_size do
                if water_type == "sand" then
                    if math.abs(river_x - x) <= 1 then
                        map[x][y] = "water"
                    else
                        local chanceForPalm = math.random(1,25)
                        if chanceForPalm == 1 then
                            map[x][y] = "palm"
                        else
                            map[x][y] = "sand"
                        end
                    end
                elseif water_type == "water_shallow" then
                    if math.abs(river_x - x) <= 1 then
                        map[x][y] = "water"
                    else
                        map[x][y] = "water_shallow"
                    end
                else
                    map[x][y] = water_type
                end
            end
        end
    end

    if options.roads then
        for x = 1, x_size do
            if math.abs(x - river_x) < 2 then
                map[x][road_y] = "bridge_h"
            else
                map[x][road_y] = "road_h"
            end
        end

        if options.cities then
            if map[road_x][city_y] == "grass" then map[road_x][city_y] = "city_grass"
            elseif map[road_x][city_y] == "sand" then map[road_x][city_y] = "city_sand"
            elseif map[road_x][city_y] == "water" or string.find(map[road_x][city_y], "river") then map[road_x][city_y] = "city_water"
            elseif map[road_x][city_y] == "water_deep" then map[road_x][city_y] = "city_water_deep"
            elseif map[road_x][city_y] == "water_shallow" then map[road_x][city_y] = "city_water_shallow"
            else map[road_x][city_y] = "city_grass"
            end
        end

        for y = city_y+1, y_size do
            if y == road_y then
                map[road_x][y] = "road_cross"
            elseif math.abs(y - river_y) < 2 or y < sea_size-1 then
                map[road_x][y] = "bridge_v"
            else
                map[road_x][y] = "road_v"
            end
        end
    end

    return map
end

return M