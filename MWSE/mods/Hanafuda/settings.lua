
---@class Config
local defaultConfig = {
    enable = true,
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
