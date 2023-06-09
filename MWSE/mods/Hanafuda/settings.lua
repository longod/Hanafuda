
---@class Settings
local this = {}

local hr = require("Hanafuda.KoiKoi.houseRule")

---@enum CardLanguage
this.cardLanguage = {
    japanese = 1,
    tamrielic = 2,
}

---@class Config
local defaultConfig = {
    enable = true,
    -- language?
    cardLanguage = this.cardLanguage.tamrielic,
    -- game speed x1.0 for wait time
    ---@class Config.KoiKoi
    koikoi = {
        round = 3, -- 3, 6, 12, 1 (debug)
        ---@class Config.KoiKoi.HouseRule
        houseRule = {
            multiplier = hr.multiplier.doublePointsOver7,
            flowerViewingSake = true,
            moonViewingSake = true,
            -- nov cards rain off, dec cards fog
            -- wild card
        },
    },
    audio = {
        --volume = 100,
        playerVoice = true,
        opponentVoice = true,
    },
    development = {
        logLevel = "INFO",
        logToConsole = false,
        debug = false,
        unittest = false,
    }
}

this.configPath = "Hanafuda"
this.modName = "Hanafuda: Akaviri Playing Cards"
local config = nil ---@type Config

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
