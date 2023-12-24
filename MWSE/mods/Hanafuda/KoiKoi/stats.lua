-- record stats
---@class Hanafuda.KoiKoi.Stats
local this = {}

---@class Hanafuda.KoiKoi.StatsData
local defaults = {
    play = 0,
    win = 0,
    lose = 0,
}

---@return Hanafuda.KoiKoi.StatsData
function this.GetDefault()
    return table.deepcopy(defaults)
end

return this
