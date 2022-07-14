local M = {}

function M.generate_map(x_size, y_size, options, seed)
    math.randomseed(seed)
    math.random()
    math.random()
    math.random()

    
    --options are... rivers, sea, roads, cities
    --tiles are...
    -- "grass", 
    -- "water", 
    -- "water_deep", 
    -- "water_shallow", 
    -- "sand", 
    -- "road_h", 
    -- "road_v", 
    -- "road_cross", 
    -- "bridge_h", 
    -- "bridge_v", 
    -- "city"

    --initialize map data structure
    local map = {}  --map is indexed as map[x][y] with origin [1][1] at bottom-left
    for x = 1, x_size do
        if not map[x] then map[x] = {} end
    end

    --fill map with grass
    for x = 1, x_size do
        for y = 1, y_size do
            map[x][y] = "grass"
        end
    end

    if options.rivers then
        local start_y = 1 + math.random(y_size - 2)
        local start_x = 1 + math.random(x_size - 2)

        for x = 1, x_size do
            map[x][start_y - 1] = "water_shallow"
            map[x][start_y] = "water"
            map[x][start_y + 1] = "water_shallow"
        end

        for y = 1, y_size do
            if y ~= start_y then
                map[start_x - 1][y] = "water_shallow"
                map[start_x][y] = "water"
                map[start_x + 1][y] = "water_shallow"
            end
        end
    end

    if options.sea then
        local sea_size = 7 + math.random(math.floor(y_size/4))
        for y = 1, sea_size do
            local water_type
            if sea_size - y == 0 then
                water_type = "sand"
            elseif sea_size - y < 3 then
                water_type = "water_shallow"
            elseif sea_size - y < 5 then
                water_type = "water"
            else
                water_type = "water_deep"
            end

            for x = 1, x_size do
                if map[x][y] ~= "water" and map[x][y] ~= "water_shallow" or water_type == "water_deep" or water_type == "water" then
                    map[x][y] = water_type
                end
            end
        end
    end

    if options.roads then
        local start_y
        while true do
            start_y = 1 + math.random(y_size - 2)
            if map[1][start_y] == "grass" then break end
        end

        local start_x
        while true do
            start_x = 1 + math.random(x_size - 2)
            if map[start_x][y_size] == "grass" then break end
        end

        for x = 1, x_size do
            if map[x][start_y] == "water" or map[x][start_y] == "water_shallow" then
                map[x][start_y] = "bridge_h"
            else
                map[x][start_y] = "road_h"
            end
        end

        for y = 1, y_size do
            if y == start_y then
                map[start_x][y] = "road_cross"
            elseif map[start_x][y] == "water" or map[start_x][y] == "water_shallow" then
                map[start_x][y] = "bridge_v"
            else
                map[start_x][y] = "road_v"
            end
        end
    end

    return map
end

return M