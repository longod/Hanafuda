local config = require("Hanafuda.config")

---@param _ initializedEventData
local function OnInitialized(_)
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
                -- todo need game settings menu
                -- brain, parameters, debug options
                service = require("Hanafuda.KoiKoi.service").new(
                    require("Hanafuda.KoiKoi.game").new(
                        require("Hanafuda.config").koikoi,
                        require("Hanafuda.KoiKoi.brain.randomBrain").new({ koikoiChance = 0.3, meaninglessDiscardChance = 0.1, waitHand = { s = 1, e = 4}, waitDrawn = { s = 0.5, e = 1.5}, waitCalling = { s = 2, e = 4 } }),
                        nil
                    ),
                    require("Hanafuda.KoiKoi.view").new(nil, nil, config.cardStyle, config.cardBackStyle),
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
            require("Hanafuda.Gamble.ui").CreateBettingMenu(123456, {0, 1, 2}, {true, true, false}, 3 * config.koikoi.round)
        end, { filter = tes3.scanCode.x })
        -- test
        event.register(tes3.event.keyDown,
        ---@param e keyDownEventData
        function(e)
            local mod = e.isAltDown or e.isControlDown or e.isShiftDown or e.isSuperDown
            if mod then
                return
            end
            -- sound player
            require("Hanafuda.KoiKoi.sound").CreateSoundPlayer()
        end, { filter = tes3.scanCode.v })

        -- TODO add run game multi times on runner
    end

    require("Hanafuda.Gamble.service")

end
event.register(tes3.event.initialized, OnInitialized)
dofile("Hanafuda/mcm.lua")

-- unittest
if config.development.unittest then
    dofile("Hanafuda/test.lua")
    dofile("Hanafuda/KoiKoi/test.lua")
    dofile("Hanafuda/Gamble/test.lua")
end

--- HACK Since the annotation are not defined in MWSE, this is to supress the warning caused by this.
--- @class tes3scriptVariables
