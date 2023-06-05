---@class DialogService
local this = {}

local logger = require("Hanafuda.logger")
local uiid = require("Hanafuda.uiid")
local koi = require("Hanafuda.KoiKoi.koikoi")
local special = require("Hanafuda.Gamble.special")
local i18n = mwse.loadTranslations("Hanafuda")

local service ---@type KoiKoi.Service?

---@param actor tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@return boolean
local function CanBarter(actor)
    local ai = actor.object.aiConfig
    local barters = {
        "bartersAlchemy",
        "bartersApparatus",
        "bartersArmor",
        "bartersBooks",
        "bartersClothing",
        "bartersEnchantedItems",
        "bartersIngredients",
        "bartersLights",
        "bartersLockpicks",
        "bartersMiscItems",
        "bartersProbes",
        "bartersRepairTools",
        "bartersWeapons",
    }
    for _, value in ipairs(barters) do
        if ai[value] == true then
            return true
        end
    end
    return false
end

---@param actor tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@return integer
local function GetActorGold(actor)
    local gold = actor.barterGold

    local goldId = {
        ["Gold_001"] = true,
        ["Gold_005"] = true,
        ["Gold_010"] = true,
        ["Gold_025"] = true,
        ["Gold_100"] = true,
    }

    local items = actor.inventory
    for _, item in ipairs(items) do
        if goldId[item.object.id] then
            gold = gold + item.object.value * item.count
        end
    end
    return gold
end

--- This is popular in hanafuda gambling, where money is transferred according to difference scores and unit price.
--- NPCs in morrowind have little or no money. It may be more obvious to deal with a unique currency. or other gambling, debt system.
---@param player tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param npc tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param playerPoint number
---@param opponentPoint number
---@param unitPrice number
---@param allowDupe boolean not zero-sum. Missing money will be made up.
---@return number expected
---@return number actual
---@return number insufficient +npc -player
local function TradeGold(player, npc, playerPoint, opponentPoint, unitPrice, allowDupe)
    local delta = playerPoint - opponentPoint
    local expected = delta * unitPrice
    local item = "Gold_001"
    local npcGold = GetActorGold(npc)
    local playerGold = GetActorGold(player)     -- tes3.getPlayerGold()

    if expected > 0 then -- palyer gain money
        -- collect barter gold first
        local actual = allowDupe and expected or math.min(npcGold, expected)
        logger:debug("player cash from %d to %d", playerGold, playerGold + actual)

        local barterGold = npc.barterGold
        if barterGold > 0 then
            npc.barterGold = math.max(barterGold - actual, 0)
            tes3.addItem({ reference = player.reference, item = item, count = actual })
            logger:debug("collect %d from npc barterGold %d, %d remaining", actual, barterGold, npc.barterGold)
        end
        local cash = math.max(actual - barterGold, 0)
        if cash > 0 then
            if allowDupe then
                tes3.addItem({ reference = player.reference, item = item, count = cash })
                tes3.removeItem({ reference = npc.reference, item = item, count = cash })
            else
                tes3.transferItem({ from = npc.reference, to = player.reference, item = item, count = cash })
            end
            logger:debug("collect %d from npc cash %d, %d remaining", cash, npcGold - barterGold,
                math.max(npcGold - barterGold - cash, 0))
        end
        return expected, actual, (expected - actual)

    elseif expected < 0 then -- player lose money
        -- No sound when there is no money
        expected = -expected
        local actual = allowDupe and expected or math.min(playerGold, expected)
        logger:debug("collect %d from player cash %d, %d remaining", actual, playerGold, math.max(playerGold - actual, 0))
        if CanBarter(npc) then
            -- barterGold resets periodically, so might better add it in npc's inventory at all times?
            npc.barterGold = npc.barterGold + actual
            tes3.removeItem({ reference = player.reference, item = item, count = actual })
            logger:debug("npc barterGold from %d to %d", npc.barterGold + actual, npc.barterGold)
        else
            if allowDupe then
                tes3.addItem({ reference = npc.reference, item = item, count = actual })
                tes3.removeItem({ reference = player.reference, item = item, count = actual })
            else
                tes3.transferItem({ from = player.reference, to = npc.reference, item = item, count = actual })
            end
            logger:debug("npc cash from %d to %d", npcGold - npc.barterGold, npcGold - npc.barterGold + actual)
        end
        return -expected, -actual, -(expected - actual)
    end

    return 0, 0, 0
end

---@param mobile tes3mobileActor
---@return boolean
local function ActorHasServiceMenu(mobile)
    if mobile.isDead then
        return false
    end
    return true
end

---@param player tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param opponent tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@return boolean
local function HasServiceMenu(player, opponent)
    if not ActorHasServiceMenu(opponent) then
        return false
    end

    local types = {
        [tes3.actorType.creature] =
        ---@param a tes3mobileCreature
        ---@return boolean
            function(a)
                if not special.IsAllowdCreature(a) then
                    return false
                end
                return true
            end,
        [tes3.actorType.npc] =
        ---@param a tes3mobileNPC
        ---@return boolean
            function(a)
                if not special.IsAllowdNPC(a) then
                    return false
                end
                return true
            end,
        [tes3.actorType.player] =
        ---@param a tes3mobilePlayer
        ---@return boolean
            function(a)
                -- possible?
                return false
            end,
    }
    if types[opponent.actorType] then
        return types[opponent.actorType](opponent)
    end
    return false
end

---@param mobile tes3mobileActor
---@return boolean
local function ActorCanPerformService(mobile)
    local condition = {
        "attacked",
        "inCombat",
        "isAttackingOrCasting",
        "isDead",
        "isDiseased",
        "isFlying",
        "isJumping",
        "isKnockedDown",
        "isKnockedOut",
        "isParalyzed",
        "isPlayerHidden",
        "isReadyingWeapon",
        "isSneaking",
        "isSwimming",
    }
    for index, value in ipairs(condition) do
        if mobile[value] then
            return false
        end
    end
    return true
end

---@param player tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param opponent tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@return boolean
local function CanPerformService(player, opponent)
    if not ActorCanPerformService(player)then
        return false
    end
    if not ActorCanPerformService(opponent)then
        return false
    end

    --todo not in-combat
    local types = {
        [tes3.actorType.creature] =
        ---@param a tes3mobileCreature
        ---@return boolean
            function(a)
                return true
            end,
        [tes3.actorType.npc] =
        ---@param a tes3mobileNPC
        ---@return boolean
            function(a)
                -- todo
                if a.object.disposition < 0 then
                    return false
                end
                return true
            end,
        [tes3.actorType.player] =
        ---@param a tes3mobilePlayer
        ---@return boolean
            function(a)
                -- possible?
                return false
            end,
    }
    if types[opponent.actorType] then
        return types[opponent.actorType](opponent)
    end
    return false
end

local oddsList = {
    0, -- free
    1,
    5,
    25,
    100,
}
local penaltyPointPerRound = 3 -- per round

---@param player tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param opponent tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param conf Config.KoiKoi
local function CalculateBettingSettings(player, opponent, conf)
    local playerGold = GetActorGold(player)
    local opponentGold = GetActorGold(opponent)
    -- Allow odds if there is some amount of payment on both sides.
    local gold = math.min(playerGold, opponentGold)
    -- todo tweak
    local metric = math.max(gold / penaltyPointPerRound, gold > 0 and 1 or 0) -- average points per round... no evidence!
    local enables = {}
    for index, value in ipairs(oddsList) do
        local enable = value * conf.round <= metric
        table.insert(enables, enable)
    end
    return playerGold, enables
end


---@param player tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param opponent tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param odds integer
---@param penaltyPoint integer
local function LaunchKoiKoi(player, opponent, odds, penaltyPoint)
    -- todo passing more parameters from actor
    service = require("Hanafuda.KoiKoi.service").new(
        require("Hanafuda.KoiKoi.game").new(),
        require("Hanafuda.KoiKoi.view").new(player, opponent),

        ---@param params KoiKoi.ExitStatus
        function(params)
            -- and maybe need to get points for gambling
            if service then
                service:Destory()
                service = nil
            end
            local winner = params.winner
            local pp = params.playerPoint
            local op = params.opponentPoint
            if params.conceding ~= nil then
                if params.conceding == koi.player.you then
                    -- It's not actually winning, so it might not want to start referring to it for other things.
                    winner = koi.player.opponent
                    pp = 0
                    op = math.max(op, penaltyPoint)
                else
                    winner = koi.player.you
                    pp = math.max(pp, penaltyPoint)
                    op = 0
                end
            end
            if winner ~= nil and odds > 0 then
                local expected, actual, insufficient = TradeGold(player, opponent, pp, op, odds, false)
                -- TODO Use insufficient for dispositions, debt, etc.
                logger:debug("trade gold expected=%d, actual=%d, insufficient=%d", expected, actual, insufficient)
                if expected > 0 then
                    if insufficient == 0 then
                        tes3.messageBox(i18n("gamble.collected", {actual = actual}))
                    else
                        tes3.messageBox(i18n("gamble.collectedInsufficient", {expected = expected, actual = actual}))
                    end
                elseif expected < 0 then
                    if insufficient == 0 then
                        tes3.messageBox(i18n("gamble.paid", {actual = -actual}))
                    else
                        tes3.messageBox(i18n("gamble.paidInsufficient", {expected = -expected, actual = -actual}))
                    end
                end
            end
        end
    )
    service:Initialize()

end

---@param e uiEventEventData
---@param player tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param opponent tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
local function UpdateVisibility(e, player, opponent)
    timer.delayOneFrame(function()
            local b = e.source:findChild(uiid.menuDialogServiceKoiKoi)
            if b and not b.visible then
                b.visible = true
                if CanPerformService(player, opponent)then
                    b.disabled = false
                    b.color = tes3ui.getPalette(tes3.palette.normalColor)
                else
                    b.disabled = true
                    b.color = tes3ui.getPalette(tes3.palette.disabledColor)
                end
                e.source:updateLayout() -- endless calling?
                logger:trace("UpdateVisibility")
            end
        end,
        timer.real)
end

---@param menu tes3uiElement
---@param player tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param opponent tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
local function AddGamblingMenu(menu, player, opponent)
    local divider = menu:findChild(uiid.menuDialogDivider)
    local parent = divider.parent
    assert(divider)
    assert(parent)

    local serviceButton = parent:createTextSelect({ id = uiid.menuDialogServiceKoiKoi, text = i18n("koi.service.label") })
    parent:reorderChildren(divider, serviceButton, 1) -- above divider

    -- reflesh by update event?
    if not CanPerformService(player, opponent) then
        serviceButton.disabled = true
        serviceButton.color = tes3ui.getPalette(tes3.palette.disabledColor)
    else
    serviceButton:register(tes3.uiEvent.mouseClick,
        ---@param _ uiEventEventData
        function(_)
            local config = require("Hanafuda.config")
            local gold, enables = CalculateBettingSettings(player, opponent, config.koikoi)
            local penaltyPayout = penaltyPointPerRound * config.koikoi.round
            require("Hanafuda.Gamble.ui").CreateBettingMenu(gold, oddsList, enables, penaltyPayout,
            ---@param odds integer
            function(odds)
                LaunchKoiKoi(player, opponent, odds, penaltyPayout)
            end)
        end)
    end

    serviceButton:register(tes3.uiEvent.help,
        ---@param e uiEventEventData
        function(e)
            if e.source.disabled then
                -- todo reason if it disabled
            else
                local tooltip = tes3ui.createTooltipMenu()
                tooltip:createLabel({ text = i18n("koi.service.tooltip") })
            end
        end)

    menu:registerAfter(tes3.uiEvent.update,
    ---@param e uiEventEventData
    function(e)
        UpdateVisibility(e, player, opponent)
    end)
end

--- @param e uiActivatedEventData
local function OnMenuDialogActivated(e)
    if not e.newlyCreated then
        return
    end
    local actor = tes3ui.getServiceActor()
    if not actor then
        return
    end

    if not HasServiceMenu(tes3.mobilePlayer, actor) then
        return
    end
    logger:trace("Player money " .. tostring(GetActorGold(tes3.mobilePlayer)))
    logger:trace("NPC money " .. tostring(GetActorGold(actor)))

    AddGamblingMenu(e.element, tes3.mobilePlayer, actor)
end
event.register(tes3.event.uiActivated, OnMenuDialogActivated, { filter = "MenuDialog", priority = 0 })

return this
