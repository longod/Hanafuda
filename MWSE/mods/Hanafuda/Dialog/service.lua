---@class DialogService
local this = {}

local logger = require("Hanafuda.logger")
local uiid = require("Hanafuda.uiid")
local utils = require("Hanafuda.utils")
local service ---@type KoiKoi.Service?

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

---@param menu tes3uiElement
---@param actor tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
local function AddGamblingMenu(menu, actor)
    local divider = menu:findChild(uiid.menuDialogDivider)
    local parent = divider.parent
    assert(divider)
    assert(parent)

    local serviceButton = parent:createTextSelect({ id = uiid.menuDialogServiceKoiKoi, text = "Koi-Koi" })
    parent:reorderChildren(divider, serviceButton, 1) -- above divider

    serviceButton:register(tes3.uiEvent.mouseClick,
        ---@param _ uiEventEventData
        function(_)
            service = require("Hanafuda.KoiKoi.service").new(
                require("Hanafuda.KoiKoi.game").new(),
                require("Hanafuda.KoiKoi.view").new(utils.GetPlayerName(), utils.GetNPCName(actor)),
                ---@param winner KoiKoi.Player?
                function (winner)
                    -- and maybe need to get points for gambling
                    if service then
                        service:Destory()
                        service = nil
                    end
                end
                -- todo passing more parameters from actor
            )
            service:Initialize()
        end)

    serviceButton:register(tes3.uiEvent.help,
        ---@param _ uiEventEventData
        function(_)
            local tooltip = tes3ui.createTooltipMenu()
            tooltip:createLabel({ text = "Let's gambling!" })
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

    AddGamblingMenu(e.element, actor)

end
event.register(tes3.event.uiActivated, OnMenuDialogActivated, { filter = "MenuDialog", priority = 0 })

return this
