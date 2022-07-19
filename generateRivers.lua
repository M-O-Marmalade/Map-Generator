local function generateRivers(map, map_x_size, map_y_size, tiles)
    
    local river_x = math.random(3, map_x_size - 3)
    local river_y = math.random(math.floor(map_y_size/3), map_y_size-3)

    for x = 1, map_x_size do
        map[x][river_y - 1] = tiles.river_bottom
        map[x][river_y] = tiles.river
        map[x][river_y + 1] = tiles.river_top
    end

    for y = 1, map_y_size do
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

return generateRivers