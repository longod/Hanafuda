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
    local hanafuda = page:createCategory(i18n("mcm.hanafuda.category"))

    local languageTable = {
        { label = i18n("mcm.hanafuda.cardLanguage.japanese"), value = settings.cardLanguage.japanese },
        { label = i18n("mcm.hanafuda.cardLanguage.tamrielic"), value = settings.cardLanguage.tamrielic },
    }
    hanafuda:createDropdown({
        label = i18n("mcm.hanafuda.cardLanguage.label"),
        description = i18n("mcm.hanafuda.cardLanguage.description") .. "\n\n" .. i18n("mcm.default") .. languageTable[defaults.cardLanguage].label, -- Strictly it is not correct to treat it as an index
        options = languageTable,
        variable = mwse.mcm.createTableVariable({
            id = "cardLanguage",
            table = config,
            restartRequired = true,
        }),
    })

    do
        local koikoi = hanafuda:createCategory(i18n("mcm.koi.category"))
        local roundTable = {
            { label = "3", value = 3 },
            { label = "6", value = 6 },
            { label = "12", value = 12 },
        }
        if config.development.debug then
            table.insert(roundTable, { label = "1 (Debug)", value = 1 })
        end
        koikoi:createDropdown({
            label = i18n("mcm.koi.round.label"),
            description = i18n("mcm.koi.round.description") .. "\n\n" .. i18n("mcm.default") .. tostring(defaults.koikoi.round),
            options = roundTable,
            variable = mwse.mcm.createTableVariable({ id = "round", table = config.koikoi }),
        })

        do
            local houseRule = require("Hanafuda.KoiKoi.houseRule")
            local house = koikoi:createCategory(i18n("mcm.koi.houseRule.category"))
            local multiplierTable = {
                { label = i18n("mcm.koi.houseRule.multiplier.none"), value = houseRule.multiplier.none },
                { label = i18n("mcm.koi.houseRule.multiplier.doublePointsOver7"), value = houseRule.multiplier.doublePointsOver7 },
                { label = i18n("mcm.koi.houseRule.multiplier.eachTimeKoiKoi"), value = houseRule.multiplier.eachTimeKoiKoi },
            }
            house:createDropdown({
                label = i18n("mcm.koi.houseRule.multiplier.label"),
                description = i18n("mcm.koi.houseRule.multiplier.description") .. "\n\n" .. i18n("mcm.default") .. multiplierTable[defaults.koikoi.houseRule.multiplier].label, -- Strictly it is not correct to treat it as an index
                options = multiplierTable,
                variable = mwse.mcm.createTableVariable({ id = "multiplier", table = config.koikoi.houseRule }),
            })

            house:createYesNoButton({
                label = i18n("mcm.koi.houseRule.flowerViewingSake.label", {i18n("koi.combo.flowerViewingSake.name")}),
                description = i18n("mcm.koi.houseRule.flowerViewingSake.description", {i18n("koi.combo.flowerViewingSake.name")}) .. "\n\n" .. i18n("mcm.default") .. GetYesNo(defaults.koikoi.houseRule.flowerViewingSake),
                variable = mwse.mcm.createTableVariable({ id = "flowerViewingSake", table = config.koikoi.houseRule })
            })
            house:createYesNoButton({
                label = i18n("mcm.koi.houseRule.moonViewingSake.label", {i18n("koi.combo.moonViewingSake.name")}),
                description = i18n("mcm.koi.houseRule.moonViewingSake.description", {i18n("koi.combo.moonViewingSake.name")}) .. "\n\n" .. i18n("mcm.default") .. GetYesNo(defaults.koikoi.houseRule.moonViewingSake),
                variable = mwse.mcm.createTableVariable({ id = "moonViewingSake", table = config.koikoi.houseRule })
            })
        end
    end
    do
        local audio = page:createCategory(i18n("mcm.audio.category"))
        audio:createOnOffButton({
            label = i18n("mcm.audio.playerVoice.label"),
            description = i18n("mcm.audio.playerVoice.description") .. "\n\n" .. i18n("mcm.default") .. GetOnOff(defaults.audio.playerVoice),
            variable = mwse.mcm.createTableVariable({ id = "playerVoice", table = config.audio })
        })
        audio:createOnOffButton({
            label = i18n("mcm.audio.npcVoice.label"),
            description = i18n("mcm.audio.npcVoice.description") .. "\n\n" .. i18n("mcm.default") .. GetOnOff(defaults.audio.npcVoice),
            variable = mwse.mcm.createTableVariable({ id = "npcVoice", table = config.audio })
        })    end
    do
        local dev = page:createCategory(i18n("mcm.development.category"))
        dev:createDropdown({
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
        dev:createOnOffButton({
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
        dev:createOnOffButton({
            label = i18n("mcm.development.debug.label"),
            description = i18n("mcm.development.debug.description") .. "\n\n" .. i18n("mcm.default") .. GetOnOff(defaults.development.debug),
            variable = mwse.mcm.createTableVariable({
                id = "debug",
                table = config.development,
                restartRequired = true,
            })
        })
        dev:createOnOffButton({
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

