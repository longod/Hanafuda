---@class DialogService
local this = {}

local logger = require("Hanafuda.logger")
local uiid = require("Hanafuda.uiid")
local utils = require("Hanafuda.utils")
local service ---@type KoiKoi.Service?
local i18n = mwse.loadTranslations("Hanafuda")

---@param e uiEventEventData
local function UpdateVisibility(e)
    timer.delayOneFrame(function()
            local b = e.source:findChild(uiid.menuDialogServiceKoiKoi)
            if b and not b.visible then
                b.disabled = false
                b.visible = true
                e.source:updateLayout() -- endless calling?
                logger:trace("UpdateVisibility")
            end
        end,
        timer.real)
end

---comment
---@param actor tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@return boolean
local function EnableGambling(actor)
    local types = {
        [tes3.actorType.creature] =
        ---@param a tes3mobileCreature
        ---@return boolean
            function(a)
                -- creeper, mudcrub, some talkable creatures, pets, companions?
                return true
            end,
        [tes3.actorType.npc] =
        ---@param a tes3mobileNPC
        ---@return boolean
            function(a)
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
    if types[actor.actorType] then
        return types[actor.actorType](actor)
    end
    return false
end

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
-- NPCs in morrowind have little or no money. It may be more obvious to deal with a unique currency.
---comment
---@param player tes3mobilePlayer
---@param npc tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param playerPoint number
---@param opponentPoint number
---@param unitPrice number
---@return number expected
---@return number actual
---@return number insufficient +npc -player
local function TradeGold(player, npc, playerPoint, opponentPoint, unitPrice)
    local delta = playerPoint - opponentPoint
    local expected = delta * unitPrice
    local item = "Gold_001"
    local npcGold = GetActorGold(npc)
    local playerGold = GetActorGold(player)     -- tes3.getPlayerGold()
    if expected > 0 then                        -- palyer gain money
        -- collect barter gold first
        local actual = math.min(npcGold, expected)

        local barterGold = npc.barterGold
        if barterGold > 0 then
            npc.barterGold = math.max(barterGold - actual, 0)
            logger:debug("collect %d from npc barterGold %d, %d remaining", actual, barterGold, npc.barterGold)
        end
        local cash = math.max(actual - barterGold, 0)
        if cash > 0 then
            tes3.removeItem({ reference = npc.reference, item = item, count = cash })
            logger:debug("collect %d from npc cash %d, %d remaining", cash, npcGold - barterGold,
                math.max(npcGold - barterGold - cash, 0))
        end

        logger:debug("player cash from %d to %d", playerGold, playerGold + actual)
        tes3.addItem({ reference = player.reference, item = item, count = actual })

        return expected, actual, (expected - actual)
    elseif expected < 0 then -- player lose money
        expected = -expected
        local actual = math.min(playerGold, expected)
        logger:debug("collect %d from player cash %d, %d remaining", actual, playerGold, math.max(playerGold - actual, 0))
        tes3.removeItem({ reference = player.reference, item = item, count = actual })
        if CanBarter(npc) then
            -- barterGold resets periodically, so might better add it in npc's inventory at all times?
            logger:debug("npc barterGold from %d to %d", npc.barterGold, npc.barterGold + actual)
            npc.barterGold = npc.barterGold + actual
        else
            logger:debug("npc cash from %d to %d", npcGold - npc.barterGold, npcGold - npc.barterGold + actual)
            tes3.addItem({ reference = npc.reference, item = item, count = actual })
        end
        return -expected, -actual, -(expected - actual)
    end
    return 0, 0, 0
end



---@param menu tes3uiElement
---@param actor tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
local function AddGamblingMenu(menu, actor)
    local divider = menu:findChild(uiid.menuDialogDivider)
    local parent = divider.parent
    assert(divider)
    assert(parent)

    local serviceButton = parent:createTextSelect({ id = uiid.menuDialogServiceKoiKoi, text = i18n("koi.service.label") })
    parent:reorderChildren(divider, serviceButton, 1) -- above divider

    serviceButton:register(tes3.uiEvent.mouseClick,
        ---@param _ uiEventEventData
        function(_)
            -- todo passing more parameters from actor
            service = require("Hanafuda.KoiKoi.service").new(
                require("Hanafuda.KoiKoi.game").new(),
                require("Hanafuda.KoiKoi.view").new(utils.GetPlayerName(), utils.GetNPCName(actor)),
                ---@param winner KoiKoi.Player?
                ---@param playerPoint integer
                ---@param opponentPoint integer
                function(winner, playerPoint, opponentPoint)
                    -- and maybe need to get points for gambling
                    if service then
                        service:Destory()
                        service = nil
                    end

                    if winner then
                        local expected, actual, insufficient = TradeGold(tes3.mobilePlayer, actor, playerPoint, opponentPoint, 10)
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
        end)

    serviceButton:register(tes3.uiEvent.help,
        ---@param _ uiEventEventData
        function(_)
            local tooltip = tes3ui.createTooltipMenu()
            tooltip:createLabel({ text = i18n("koi.service.tooltip") })
        end)

    menu:registerAfter(tes3.uiEvent.update, UpdateVisibility)
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

    if not EnableGambling(actor) then
        return
    end
    logger:debug("Player money " .. tostring(GetActorGold(tes3.mobilePlayer)))
    logger:debug("NPC money" .. tostring(GetActorGold(actor)))

    AddGamblingMenu(e.element, actor)
end
event.register(tes3.event.uiActivated, OnMenuDialogActivated, { filter = "MenuDialog", priority = 0 })

return this
