local M = {}

function M.sign(number)
    return number > 0 and 1 or (number == 0 and 0 or -1)
end

function M.remap_range(val,lo1,hi1,lo2,hi2)
    if lo1 == hi1 then return lo2 end
    return lo2 + (hi2 - lo2) * ((val - lo1) / (hi1 - lo1))
end

return M