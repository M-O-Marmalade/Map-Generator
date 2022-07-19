local map_generator = require("map_generator")
local M = {}

function M.requestMap(vb, x_size, y_size, tiles, options, seed)
    local map = map_generator.requestMap(x_size, y_size, tiles, options, seed)

    local renoise_map = vb:row{}
    for x = 1, x_size do
        local map_column = vb:column{}
        for y = 0, y_size-1 do
            map_column:add_child(
                vb:bitmap {
                    bitmap = tiles.path_prefix .. map[x][y_size - y] .. ".bmp"
                }
            )
        end
        renoise_map:add_child(map_column)
    end

    return renoise_map
end

return M