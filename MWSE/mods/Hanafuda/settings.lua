local koi = require("Hanafuda.KoiKoi.koikoi")

---@class Config
local defaultConfig = {
    enable = true,
    -- language?
    -- game speed x1.0 for wait time
    ---@class Config.KoiKoi
    koikoi = {
        round = 3, -- 3, 6, 12, 1 (debug)
        ---@class Config.KoiKoi.HouseRule
        houseRule = {
            multiplier = koi.multiplier.doublePointsOver7,
            flowerViewingSake = true,
            moonViewingSake = true,
            -- nov cards rain off, dec cards fog
        },
    },
    audio = {
        volume = 100,
    },
    development = {
        logLevel = "INFO",
        logToConsole = false,
        debug = false,
        unittest = false,
    }
}

local config = nil ---@type Config

---@class Settings
local this = {}
this.configPath = "Hanafuda"
this.modName = "Hanafuda: Akaviri Playing Cards"

---@return Config
function this.Load()
    config = config or mwse.loadConfig(this.configPath, defaultConfig)
    return config
end

---@return Config
function this.Default()
    return table.deepcopy(defaultConfig)
end

return this
