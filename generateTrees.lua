local function generateTrees(map, map_x_size, map_y_size, tiles, trees_options)

    --     trees_options {
    --       tree_rarity ... (number)
    --       forest_rarity ... (number)
    --       tree_frequency_in_forest ... (number)
    --       min_forest_size ... (number)
    --       max_forest_size ... (number)
    --     }
    
    for x = 1, map_x_size do
        for y = 1, map_y_size do

            local chanceForTree = math.random(trees_options.tree_rarity)
            if chanceForTree == 1 then
                map[x][y] = tiles.grass_tree
            end

            local chanceForForest = math.random(trees_options.forest_rarity)
            if chanceForForest == 1 then
                
                local forestStartX = math.max(1, x - math.random(trees_options.min_forest_size))
                local forestEndX = math.min(map_x_size, math.random(forestStartX, forestStartX + trees_options.max_forest_size))
                local forestStartY = math.max(1, y - math.random(trees_options.min_forest_size))
                local forestEndY = math.min(map_y_size, math.random(forestStartY, forestStartY + trees_options.max_forest_size))
                
                for mx = forestStartX, forestEndX do
                    for my = forestStartY, forestEndY do
                        
                        local chanceForTreeInforest = math.random(trees_options.tree_frequency_in_forest)
                        if chanceForTreeInforest > 1 then
                            map[mx][my] = tiles.grass_tree
                        end
    
                    end
                end
    
            end

        end
    end

end

return generateTrees