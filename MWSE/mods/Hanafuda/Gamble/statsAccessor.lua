-- store/load stats in MWSE
---@class Hanafuda.Gamble.StatsAccessor
local this = {}
local stats = require("Hanafuda.KoiKoi.stats")

--get persistent saved data
---@return Hanafuda.KoiKoi.StatsData
function this.GetData()
    if tes3.player and tes3.player.data then
        local data = tes3.player.data.Hanafuda ---@type Hanafuda.KoiKoi.StatsData?
        if not data then
            -- TODO init
            data = stats.GetDefault() ---@type Hanafuda.KoiKoi.StatsData
            tes3.player.data.Hanafuda = data
        end
        return data
    end
    return stats.GetDefault()
end

function this.ResetData()
    if tes3.player and tes3.player.data then
        tes3.player.data.Hanafuda = stats.GetDefault()
    end
end

return this
