local config = require("Hanafuda.config")

local logger = require("logging.logger").new({
    name = "Hanafuda",
    logLevel = config.logLevel or "INFO",
    logToConsole = config.logToConsole,
    includeTimestamp = false,
})

return logger