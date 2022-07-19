local function generateFlowers(map, map_x_size, map_y_size, tiles, flowers_options)

    --     flowers_options {
    --       meadow_rarity ... (number)
    --       flower_rarity_in_meadow ... (number)
    --       min_meadow_size ... (number)
    --       max_meadow_size ... (number)
    --     }

    for x = 1, map_x_size do
        for y = 1, map_y_size do

            local chanceForMeadow = math.random(flowers_options.meadow_rarity)
            if chanceForMeadow == 1 then
                
                local meadowStartX = math.max(1, x - math.random(flowers_options.min_meadow_size))
                local meadowEndX = math.min(map_x_size, math.random(meadowStartX, meadowStartX + flowers_options.max_meadow_size))
                local meadowStartY = math.max(1, y - math.random(flowers_options.min_meadow_size))
                local meadowEndY = math.min(map_y_size, math.random(meadowStartY, meadowStartY + flowers_options.max_meadow_size))
                
                for mx = meadowStartX, meadowEndX do
                    for my = meadowStartY, meadowEndY do
                        
                        local chanceForFlowerInMeadow = math.random(flowers_options.flower_rarity_in_meadow)
                        if chanceForFlowerInMeadow == 1 then
                            local whichFlower = math.random(6)
                            map[mx][my] = tiles.grass_flowers[whichFlower]
                        end
    
                    end
                end
    
            end
            
        end
    end

end

return generateFlowers