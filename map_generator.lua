local M = {}

function M.generate_map(x_size, y_size, options)
    --map is indexed as map[x][y] with origin [1][1] at bottom-left
    --options are... rivers, sea, roads, and cities
    --tiles are...
    -- "grass", 
    -- "water", 
    -- "water_deep", 
    -- "water_shallow", 
    -- "sand", 
    -- "river_left",
    -- "river_right",
    -- "river_top",
    -- "river_bottom",
    -- "river_top_left",
    -- "river_top_right",
    -- "river_bottom_left",
    -- "river_bottom_right",
    -- "river_sand_left",
    -- "river_sand_right",
    -- "road_h", 
    -- "road_v", 
    -- "road_cross", 
    -- "bridge_h", 
    -- "bridge_v", 
    -- "city"
    
    local river_x = 1 + math.random(x_size - 2)
    local river_y = 1 + math.random(y_size - 2)
    local sea_size = math.floor(y_size/6) + math.random(math.floor(y_size/3))
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
    


    --initialize map data structure
    local map = {}
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
                    if x == river_x - 1 then
                        map[x][y] = "river_sand_left"
                    elseif x == river_x + 1 then
                        map[x][y] = "river_sand_right"
                    elseif x ~= river_x then
                        map[x][y] = "sand"
                    end
                elseif water_type == "water_shallow" then
                    if x == river_x - 1 then
                        map[x][y] = "water_shallow_left"
                    elseif x == river_x + 1 then
                        map[x][y] = "water_shallow_right"
                    elseif x ~= river_x then
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
            map[road_x][sea_size + 2] = "city"
        end

        for y = sea_size + 3, y_size do
            if y == road_y then
                map[road_x][y] = "road_cross"
            elseif math.abs(y - river_y) < 2 then
                map[road_x][y] = "bridge_v"
            else
                map[road_x][y] = "road_v"
            end
        end
    end

    return map
end

return M