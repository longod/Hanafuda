
---@class Config
local defaultConfig = {
    enable = true,
    -- language?
    -- game speed x1.0 for wait time
    koikoi = {
        houseRule = {
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
