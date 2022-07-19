local function generateGrass(map, map_x_size, map_y_size, tiles)
    for x = 1, map_x_size do
        for y = 1, map_y_size do
            
            if not map[x][y] then
                map[x][y] = tiles.grass
            end
            
        end
    end
end

return generateGrass