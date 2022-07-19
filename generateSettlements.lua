local function generateSettlements (map, map_x_size, map_y_size, tiles, settlements_options)

    --     settlements_options {
    --       settlements_amount_min ... (number)
    --       settlements_amount_max ... (number)
    --     }

    local number_of_settlements = math.random(
        settlements_options.settlements_amount_min,
        settlements_options.settlements_amount_max
    )

    for i = 1, number_of_settlements do

        local x = math.random(map_x_size)
        local y = math.random(map_y_size)

        if string.find(map[x][y], "grass") then map[x][y] = tiles.grass_settlement
        elseif string.find(map[x][y], "sand") then map[x][y] = tiles.sand_settlement
        elseif map[x][y] == tiles.water or string.find(map[x][y], "river") then map[x][y] = tiles.water_settlement
        elseif map[x][y] == tiles.water_shallow then map[x][y] = tiles.water_shallow_settlement
        elseif map[x][y] == tiles.water_deep then map[x][y] = tiles.water_deep_settlement
        else map[x][y] = tiles.grass_settlement
        end

    end

end

return generateSettlements