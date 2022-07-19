local function generateSea(map, map_x_size, map_y_size, tiles)
    
    local sand_size = math.random(4)
    local water_shallow_size = math.random(4)
    local water_size = math.random(4)
    local water_deep_size = math.random(6)
    
    local sea_size = math.min(map_y_size, sand_size + water_shallow_size + water_size + water_deep_size)

    for y = 1, sea_size do

        local water_type
        if sea_size - y <= sand_size then water_type = tiles.sand
        elseif sea_size - y <= sand_size + water_shallow_size then water_type = tiles.water_shallow
        elseif sea_size - y <= sand_size + water_shallow_size + water_size then water_type = tiles.water
        else water_type = tiles.water_deep
        end

        for x = 1, map_x_size do

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

return generateSea