local config = require("Hanafuda.config")
local utils = require("Hanafuda.utils")

---@param _ initializedEventData
local function OnInitialized(_)
local settings = require("Hanafuda.settings")
    if config.cardLanguage == settings.cardLanguage.tamrielic then
        -- local i18n = mwse.loadTranslations("Hanafuda")
        -- local loc = require("i18n")
        -- local lang = require("Hanafuda.i18n.tamrielic")
        -- mwse.log(i18n.mod)
        --loc.load({ ["eng"] = { ["Hanafuda"] = lang } })
        --local i18n = mwse.loadTranslations("Hanafuda")
        --table.copy(i18n.mod.Hanafuda.tamrielic, i18n.mod.Hanafuda)
    end
    if config.development.debug then
        local service = nil ---@type KoiKoi.Service?
        event.register(tes3.event.keyDown,
        ---@param e keyDownEventData
        function(e)
            local mod = e.isAltDown or e.isControlDown or e.isShiftDown or e.isSuperDown
            if mod then
                return
            end
            if service then
                service:Destory()
                service = nil
            else
                service = require("Hanafuda.KoiKoi.service").new(
                    require("Hanafuda.KoiKoi.game").new(),
                    require("Hanafuda.KoiKoi.view").new(),
                    function()
                        if service then
                            service:Destory()
                            service = nil
                        end
                    end
                )
                service:Initialize()
            end
        end, {filter = tes3.scanCode.k} )

        -- test
        event.register(tes3.event.keyDown,
        ---@param e keyDownEventData
        function(e)
            local mod = e.isAltDown or e.isControlDown or e.isShiftDown or e.isSuperDown
            if mod then
                return
            end
            require("Hanafuda.KoiKoi.ui").CreateSettingsMenu()
        end, {filter = tes3.scanCode.x} )
    end

    require("Hanafuda.Dialog.service")

end
event.register(tes3.event.initialized, OnInitialized)
dofile("Hanafuda/mcm.lua")

-- unittest
if config.development.unittest then
    dofile("Hanafuda/test.lua")
    dofile("Hanafuda/KoiKoi/test.lua")
end
