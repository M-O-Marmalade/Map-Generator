local function generateGrassFlowersTrees(map, tiles, x_size, y_size)
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
                            map[mx][my] = tiles.flowers
                        end

                    end
                end

            end
            
            local chanceForTree = math.random(1,7)
            if chanceForTree == 1 then
                map[x][y] = tiles.tree
            end
            
        end
    end
end

local function generateRivers(map, tiles, x_size, y_size)
    
    local river_x = math.random(3, x_size - 3)
    local river_y = math.random(math.floor(y_size/3), y_size-3)

    for x = 1, x_size do
        map[x][river_y - 1] = tiles.river_bottom
        map[x][river_y] = tiles.water
        map[x][river_y + 1] = tiles.river_top
    end

    for y = 1, y_size do
        if y == river_y + 1 then
            map[river_x - 1][y] = tiles.river_top_left
            map[river_x][y] = tiles.water
            map[river_x + 1][y] = tiles.river_top_right
        elseif y == river_y - 1 then
            map[river_x - 1][y] = tiles.river_bottom_left
            map[river_x][y] = tiles.water
            map[river_x + 1][y] = tiles.river_bottom_right
        elseif y ~= river_y then
            map[river_x - 1][y] = tiles.river_left
            map[river_x][y] = tiles.water
            map[river_x + 1][y] = tiles.river_right
        end
    end
    
end

local function generateSea(map, tiles, x_size, y_size)
    
    local sea_size = math.random(math.floor(y_size/6), math.floor(y_size/2))

    for y = 0, sea_size do
        local water_type
        if sea_size - y < 2 then
            water_type = tiles.sand
        elseif sea_size - y < 4 then
            water_type = tiles.water_shallow
        elseif sea_size - y < 6 then
            water_type = tiles.water
        else
            water_type = tiles.water_deep
        end

        for x = 1, x_size do
            if water_type == tiles.sand then
                if string.find(map[x][y], "river") or map[x][y] == tiles.water then
                    map[x][y] = tiles.water
                else
                    local chanceForPalm = math.random(1,14)
                    if chanceForPalm == 1 then
                        map[x][y] = tiles.palm
                    else
                        map[x][y] = tiles.sand
                    end
                end
            elseif water_type == tiles.water_shallow then
                if string.find(map[x][y], "river") or map[x][y] == tiles.water then
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

local function generateRoadsAndCities(map, tiles, x_size, y_size, cities)
    
    local road_x = 1 + math.random(x_size - 2)
    local road_y = 1 + math.random(y_size - 2)
    local city_y = math.floor(math.random(1,road_y-1))

    -- generate horizontal road
    for x = 1, x_size do
        if string.find(map[x][road_y], "river") or string.find(map[x][road_y], tiles.water) then
            map[x][road_y] = tiles.bridge_h
        elseif map[x][road_y] == tiles.sand then
            map[x][road_y] = tiles.sand_h
        else
            map[x][road_y] = tiles.road_h
        end
    end

    -- add the city
    if cities then
        if map[road_x][city_y] == tiles.sand then map[road_x][city_y] = tiles.city_sand
        elseif map[road_x][city_y] == tiles.water or string.find(map[road_x][city_y], "river") then map[road_x][city_y] = tiles.city_water
        elseif map[road_x][city_y] == tiles.water_deep then map[road_x][city_y] = tiles.city_water_deep
        elseif map[road_x][city_y] == tiles.water_shallow then map[road_x][city_y] = tiles.city_water_shallow
        else map[road_x][city_y] = tiles.city_grass
        end
    end

    -- generate vertical road
    for y = city_y+1, y_size do

        if map[road_x][y] == tiles.sand or map[road_x][y] == tiles.palm then
            map[road_x][y] = tiles.sand_v
        elseif map[road_x][y] == tiles.sand_h then
            map[road_x][y] = tiles.sand_cross
        elseif string.find(map[road_x][y], "river") or string.find(map[road_x][y], tiles.water) then
            map[road_x][y] = tiles.bridge_v
        elseif map[road_x][y] == tiles.bridge_h then
            map[road_x][y] = tiles.bridge_cross
        elseif map[road_x][y] == tiles.road_h then
            map[road_x][y] = tiles.road_cross
        else
            map[road_x][y] = tiles.road_v
        end

    end

end

local M = {}

function M.generate_map(x_size, y_size, options, seed)
    --map is indexed as map[x][y] with origin [1][1] at bottom-left
    --each index of the map is a number corresponding to a tile type

    --boolean options (flags) that can be passed to generate_map() are... [rivers], [sea], [roads], and [cities]

    local tiles = {
        grass = "grass",
        flowers = "flowers",
        tree = "tree",
        sand = "sand",
        palm = "palm",

        water = "water",
        water_deep = "water_deep",
        water_shallow = "water_shallow",

        river_left = "river_left",
        river_right = "river_right",
        river_top = "river_top",
        river_bottom = "river_bottom",
        river_top_left = "river_top_left",
        river_top_right = "river_top_right",
        river_bottom_left = "river_bottom_left",
        river_bottom_right = "river_bottom_right",

        road_h = "road_h",
        road_v = "road_v",
        road_cross = "road_cross",
        sand_h = "sand_h",
        sand_v = "sand_v",
        sand_cross = "sand_cross",
        bridge_h = "bridge_h",
        bridge_v = "bridge_v",
        bridge_cross = "bridge_cross",

        city_grass = "city_grass",
        city_sand = "city_sand",
        city_water = "city_water",
        city_water_deep = "city_water_deep",
        city_water_shallow = "city_water_shallow"
    }
    
    
    math.randomseed(seed)
    math.random()
    math.random()
    math.random()
    math.random()
    math.random()
    math.random()
    math.random()
    

    --initialize map data structure
    local map = {}
    for x = 1, x_size do
        if not map[x] then map[x] = {} end
    end
    
    generateGrassFlowersTrees(map, tiles, x_size, y_size)
    
    if options.rivers then    
        generateRivers(map, tiles, x_size, y_size)
    end
    
    if options.sea then
        generateSea(map, tiles, x_size, y_size)
    end

    if options.roads then
        generateRoadsAndCities(map, tiles, x_size, y_size, options.cities)
    end

    return map
end

return M