--- @param e modConfigReadyEventData
local function OnModConfigReady(e)

    ---@param value boolean
    ---@return string
    local function GetOnOff(value)
        ---@diagnostic disable-next-line: return-type-mismatch
        return "Default: " .. (value and tes3.findGMST(tes3.gmst.sOn).value or tes3.findGMST(tes3.gmst.sOff).value)
    end
    ---@param value boolean
    ---@return string
    local function GetYesNo(value)
        ---@diagnostic disable-next-line: return-type-mismatch
        return "Default: " .. (value and tes3.findGMST(tes3.gmst.sYes).value or tes3.findGMST(tes3.gmst.sNo).value)
    end

    local settings = require("Hanafuda.settings")
    local config = settings.Load()
    local defaults = settings.Default()
    local template = mwse.mcm.createTemplate(settings.modName)
    template:saveOnClose(settings.configPath, config)
    template:register()

    local page = template:createSideBarPage({
        label = "Settings",
        description = "placeholder"
    })

    do
        local sub = page:createCategory("Development")
        sub:createDropdown({
            label = "Logging Level",
            description = "Set the log level.\n\nDefault: "  .. defaults.development.logLevel,
            options = {
                { label = "TRACE", value = "TRACE" },
                { label = "DEBUG", value = "DEBUG" },
                { label = "INFO",  value = "INFO" },
                { label = "WARN",  value = "WARN" },
                { label = "ERROR", value = "ERROR" },
                { label = "NONE",  value = "NONE" },
            },
            variable = mwse.mcm.createTableVariable({ id = "logLevel", table = config.development }),
            callback = function(self)
                local logger = require("Hanafuda.logger")
                logger:setLogLevel(self.variable.value)
            end
        })
        sub:createOnOffButton({
            label = "Log to Console",
            description = "Output the log to console.\n\n" .. GetOnOff(defaults.development.logToConsole),
            variable = mwse.mcm.createTableVariable({
                id = "logToConsole",
                table = config.development,
            })
        })
        sub:createOnOffButton({
            label = "Unit-Test",
            description = "Run unit-test.\n\n" .. GetOnOff(defaults.development.unittest),
            variable = mwse.mcm.createTableVariable({
                id = "unittest",
                table = config.development,
            })
        })
    end
end

event.register(tes3.event.modConfigReady, OnModConfigReady)

