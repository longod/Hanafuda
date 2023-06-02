local i18n = mwse.loadTranslations("Hanafuda")

--- @param e modConfigReadyEventData
local function OnModConfigReady(e)

    ---@param value boolean
    ---@return string
    local function GetOnOff(value)
        return (value and tes3.findGMST(tes3.gmst.sOn).value --[[@as string]] or tes3.findGMST(tes3.gmst.sOff).value --[[@as string]])
    end
    ---@param value boolean
    ---@return string
    local function GetYesNo(value)
        return (value and tes3.findGMST(tes3.gmst.sYes).value --[[@as string]] or tes3.findGMST(tes3.gmst.sNo).value --[[@as string]])
    end

    local settings = require("Hanafuda.settings")
    local config = settings.Load()
    local defaults = settings.Default()
    local template = mwse.mcm.createTemplate(settings.modName)
    template:saveOnClose(settings.configPath, config)
    template:register()

    local page = template:createSideBarPage({
        label = i18n("mcm.page.label"), -- does not show
        description = i18n("mcm.page.description")
    })

    do
        local sub = page:createCategory(i18n("mcm.development.category"))
        sub:createDropdown({
            label = i18n("mcm.development.logLevel.label"),
            description = i18n("mcm.development.logLevel.description") .. "\n\n" .. i18n("mcm.default") .. defaults.development.logLevel,
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
            label = i18n("mcm.development.logToConsole.label"),
            description = i18n("mcm.development.logToConsole.description") .. "\n\n" .. i18n("mcm.default") .. GetOnOff(defaults.development.logToConsole),
            variable = mwse.mcm.createTableVariable({
                id = "logToConsole",
                table = config.development,
            }),
            callback = function(self)
                local logger = require("Hanafuda.logger")
                logger.logToConsole = config.development.logToConsole
            end
        })
        sub:createOnOffButton({
            label = i18n("mcm.development.debug.label"),
            description = i18n("mcm.development.debug.description") .. "\n\n" .. i18n("mcm.default") .. GetOnOff(defaults.development.debug),
            variable = mwse.mcm.createTableVariable({
                id = "debug",
                table = config.development,
                restartRequired = true,
            })
        })
        sub:createOnOffButton({
            label = i18n("mcm.development.unittest.label"),
            description = i18n("mcm.development.unittest.description") .. "\n\n" .. i18n("mcm.default") .. GetOnOff(defaults.development.unittest),
            variable = mwse.mcm.createTableVariable({
                id = "unittest",
                table = config.development,
                restartRequired = true,
            })
        })
    end
end

event.register(tes3.event.modConfigReady, OnModConfigReady)

