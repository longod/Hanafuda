local config = require("Hanafuda.config")
local utils = require("Hanafuda.utils")

---@param _ initializedEventData
local function OnInitialized(_)

    local service = nil ---@type KoiKoi.Service?

    -- launch on key
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
                require("Hanafuda.KoiKoi.view").new(utils.GetPlayerName(), utils.GetNPCName()),
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

    require("Hanafuda.Dialog.service")

end
event.register(tes3.event.initialized, OnInitialized)
dofile("Hanafuda/mcm.lua")

-- unittest
if config.development.unittest then
    dofile("Hanafuda/test.lua")
    dofile("Hanafuda/KoiKoi/test.lua")
end
