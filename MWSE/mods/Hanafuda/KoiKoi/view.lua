local uiid = require("Hanafuda.uiid")
local card = require("Hanafuda.card")
local sound = require("Hanafuda.sound")
local logger = require("Hanafuda.logger")
local koi = require("Hanafuda.KoiKoi.koikoi")
local combo = require("Hanafuda.KoiKoi.combinationView")
local i18n = mwse.loadTranslations("Hanafuda")

-- with mergin
local cardLayoutWidth = card.GetCardWidth() + 4
local cardLayoutHeight = card.GetCardHeight() + 4
local enabledCardColor = { 1, 1, 1 }
local disabledCardColor = { 0.2, 0.2, 0.2 }

local cardProperty = "Hanafuda:CardId"

---@param e uiEventEventData
local function CreateCombinationList(e)
    -- TODO
    logger:debug("combo help")
    local menu = tes3ui.createHelpLayerMenu({id = "helpcombo", dragFrame = true })
    menu:destroyChildren()
    menu.width = 300
    menu.height = 300
    menu.flowDirection = tes3.flowDirection.topToBottom
    -- local pane = menu:createVerticalScrollPane()
    -- pane.width = 300
    -- pane.height = 300
    -- local parent = pane:getContentElement()
    -- parent.width = 300
    -- parent.height = 300
    for index, value in ipairs(table.values(koi.combination, true)) do
        combo.CreateCombinationView(menu, value)
    end
    menu:updateLayout()
    --pane.widget:contentsChanged()
end

---@class KoiKoi.UI
local UI = {}

---@return KoiKoi.UI
function UI.new()
    --@type KoiKoi.UI
    local instance = {}
    setmetatable(instance, { __index = UI })
    return instance
end

---@param self KoiKoi.UI
---@param player KoiKoi.Player
---@param service KoiKoi.Service
function UI.ShowCallingDialog(self, player, service)
    tes3ui.showMessageMenu({
        -- id = "Calling",
        header = "Calling",
        message = "here scoring combinations",
        buttons = {
            {
                -- todo condition, if deck 0 is disable
                text = "Koi-koi",
                callback = function()
                    sound.PlayVoice(sound.voice.continue, "", false)
                    service:KoiKoi()
                end,
                tooltip = function()
                    local tooltip = tes3ui.createTooltipMenu()
                    tooltip:createLabel({ text = "continue" })
                end
            },
            {
                text = "Shobu",
                callback = function()
                    -- todo
                    sound.PlayVoice(sound.voice.finish, "", false)
                    service:Shobu()
                end,
                tooltip = function()
                    local tooltip = tes3ui.createTooltipMenu()
                    tooltip:createLabel({ text = "you win" })
                end
            },
        }
        -- , customBlock combination list
    })
end

---@param self KoiKoi.UI
---@param service KoiKoi.Service
function UI.CreateDecidingParent(self, service)
    -- I want to wait for a selection using coroutine,
    -- but for some reason the coroutine suspended by yield is runnning in selection callbacks.
    -- Therefore, cannot resume it in callbacks.
    tes3ui.showMessageMenu({
        id = "DecideParent",
        header = "Decide Parent",
        message = "Choose one of two cards.",
        buttons = {
            {
                text = "Left",
                callback = function()
                    logger:debug("choose left")
                    service:DecideParent(false)
                end,
                tooltip = function()
                    local tooltip = tes3ui.createTooltipMenu()
                    tooltip:createLabel({ text = "Choose Left" })
                end
            },
            {
                text = "Right",
                callback = function()
                    logger:debug("choose right")
                    service:DecideParent(true)
                end,
                tooltip = function()
                    local tooltip = tes3ui.createTooltipMenu()
                    tooltip:createLabel({ text = "Choose Right" })
                end
            },
        }
    })
end

---@param self KoiKoi.UI
---@param parent KoiKoi.Player
function UI.InformParent(self, parent)
    if parent == koi.player.you then
        tes3.messageBox("Parent is you")
    elseif parent == koi.player.opponent then
        tes3.messageBox("Parent is opponent")
    else
        assert()
    end
end

---@param element tes3uiElement
---@return integer?
local function GetCardId(element)
    local cardId = element:getPropertyInt(cardProperty)
    if cardId == 0 then
        logger:error("Tried to get a card ID from a non-card element.")
        return nil
    end
    return cardId
end

---@param parent tes3uiElement
---@param cardId integer
---@param backface boolean
---@return tes3uiElement
local function PutCard(parent, cardId, backface)
    local asset = backface and card.GetCardBackAsset() or card.GetCardAsset(cardId)

    local element = parent:createBlock()
    element.autoWidth = true
    element.autoHeight = true
    element.paddingAllSides = 2
    element:setPropertyInt(cardProperty, cardId)

    local image = element:createImage({ path = asset.path })
    image.width = card.GetCardWidth()
    image.height = card.GetCardHeight()
    image.scaleMode = true
    image.consumeMouseEvents = false

    element:register(tes3.uiEvent.help,
    ---@param e uiEventEventData
    function(e)
        UI.CreateCardTooltip(cardId, backface)
    end)

    return element
end

---@param element tes3uiElement
---@return tes3uiElement
local function FlipCard(element)
    -- or query id to service
    local cardId = GetCardId(element)
    assert(cardId)
    local asset = card.GetCardAsset(cardId) -- only reveal

    element:destroyChildren()

    local image = element:createImage({ path = asset.path })
    image.width = card.GetCardWidth()
    image.height = card.GetCardHeight()
    image.scaleMode = true
    image.consumeMouseEvents = false

    -- todo register/unregister event

    return element
end

---@param parent tes3uiElement
---@param deck integer[]
---@return tes3uiElement
local function PutDeck(parent, deck)
    local asset = card.GetCardBackAsset()
    local element = parent:createBlock()
    element.autoWidth = true
    element.autoHeight = true
    element.paddingAllSides = 2
    local image = element:createImage({ path = asset.path })
    image.width = card.GetCardWidth()
    image.height = card.GetCardHeight()
    image.scaleMode = true
    image.consumeMouseEvents = true
    image.borderAllSides = 2

    image:register(tes3.uiEvent.help,
    ---@param e uiEventEventData
    function(e)
        UI.CreateDeckTooltip(deck)
    end)

    -- todo if empty it is invisible

    return image
end


---@param element tes3uiElement
---@param highlight boolean
local function SetCardColor(element, highlight)
    -- skip toplevel, it's just block
    -- if use rect or background image then it is changed too.
    for key, value in pairs(element.children) do
        value.color = highlight and enabledCardColor or disabledCardColor
    end
end

---@param parent tes3uiElement
---@param cardId integer
local function HighlightCards(parent, cardId)
    for _, value in pairs(parent.children) do
        local id = GetCardId(value)
        if id then
            SetCardColor(value, card.CanMatchSuit(cardId, id))
        end
    end
end

---@param parent tes3uiElement
local function ResetHighlightCards(parent)
    for _, value in pairs(parent.children) do
        SetCardColor(value, true)
    end
end

---@param element tes3uiElement
---@return boolean
local function GrabCard(element)
    local grab = tes3ui.findHelpLayerMenu(uiid.grabMenu)
    if table.size(grab.children) > 0 then
        logger:error("GrabCard but has children")
        return false
    end
    grab.disabled = false
    grab.visible = true
    -- need to set initial position?
    local root = element:getTopLevelMenu()

    -- calculate absolute position
    -- not use cursor position for AI playing
    local x = element.positionX
    local y = element.positionY
    local p = element.parent
    while p do
        x = x + p.positionX
        y = y + p.positionY
        p = p.parent
    end
    -- transform to screen space
    local viewportWidth, viewportHeight = tes3ui.getViewportSize()
    x = x + viewportWidth * 0.5
    y = y - viewportHeight * 0.5

    local to = element:move({ to = grab})
    -- unregister events?

    -- initial position
    grab.positionX = x
    grab.positionY = y

    grab:updateLayout()
    root:updateLayout()
    return true
end

---@param to tes3uiElement
---@return tes3uiElement?
local function ReleaseGrabedCard(to)
    local grab = tes3ui.findHelpLayerMenu(uiid.grabMenu)
    if table.size(grab.children) == 0 then
        logger:error("ReleaseCard but no child")
        return nil
    end
    grab.disabled = true
    grab.visible = false
    local root = to:getTopLevelMenu()
    local moved = grab.children[1]:move({ to = to}) -- currently just one child.
    -- unregister events?
    grab:updateLayout()
    root:updateLayout()
    return moved
end

---@return tes3uiElement?
local function GetGrabCard()
    local grab = tes3ui.findHelpLayerMenu(uiid.grabMenu)
    if not grab.visible or grab.disabled then
        return nil
    end
    if table.size(grab.children) == 0 then
        return nil
    end
    return grab.children[1]
end

---@return integer?
local function GetGrabCardId()
    local grab = GetGrabCard()
    if grab then
        return GetCardId(grab)
    end
    return nil
end

---@param element tes3uiElement
local function CaptureCard(element)
    local cardId = GetCardId(element)
    assert(cardId)
    -- todo player or ooponent
    local destid = {
        [card.type.bright] = uiid.playerBright,
        [card.type.animal] = uiid.playerAnimal,
        [card.type.ribbon] = uiid.playerRibbon,
        [card.type.chaff] = uiid.playerChaff,
    }

    local type = card.GetCardData(cardId).type
    local dest = destid[type]
    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)
    local to = gameMenu:findChild(dest)

    local moved = element:move({ to = to })
    return moved
end

local function CaptureGrabCard()
    local element = GetGrabCard()
    assert(element)
    local moved = CaptureCard(element)
    local grab = tes3ui.findHelpLayerMenu(uiid.grabMenu)
    grab.disabled = true
    grab.visible = false
    grab:updateLayout()
    return moved
end

-- fixme Only notification without direct transition is desirable.

---comment
---@param element tes3uiElement?
local function UnregisterEvents(element)
    if not element then
        return
    end
    element:unregister(tes3.uiEvent.mouseOver)
    element:unregister(tes3.uiEvent.mouseLeave)
    element:unregister(tes3.uiEvent.mouseClick)
end

---@param self KoiKoi.UI
---@param element tes3uiElement
---@param cardId integer
---@param service KoiKoi.Service
function UI.RegisterHandCardEvent(self, element, cardId, service)
    UnregisterEvents(element)

    element:register(tes3.uiEvent.mouseOver,
    ---@param e uiEventEventData
    function(e)
        -- highlight matching ground cards
        -- if can then...
        local root = e.source:getTopLevelMenu()
        local g0 = root:findChild(uiid.boardGroundRow0)
        local g1 = root:findChild(uiid.boardGroundRow1)
        HighlightCards(g0, cardId)
        HighlightCards(g1, cardId)
        root:updateLayout()
    end)

    element:register(tes3.uiEvent.mouseLeave,
    ---@param e uiEventEventData
    function(e)
        -- stop highlight
        -- if can then...
        local root = e.source:getTopLevelMenu()
        local g0 = root:findChild(uiid.boardGroundRow0)
        local g1 = root:findChild(uiid.boardGroundRow1)
        ResetHighlightCards(g0)
        ResetHighlightCards(g1)
        root:updateLayout()
    end)

    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- keep highlight
        -- grab card
        if service:CanGrabCard(cardId) then
            if GrabCard(e.source) then -- sync serivice?
                sound.Play(sound.se.pickCard)
            end
        end
    end)
end

---@param self KoiKoi.UI
---@param element tes3uiElement
---@param service KoiKoi.Service
function UI.RegisterHandEvent(self, element, service)
    UnregisterEvents(element)

    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- cancel, put back card
        -- or service has selectedcard
        local cardId = GetGrabCardId()
        if cardId then
            if service:CanPutbackCard(cardId) then
                if ReleaseGrabedCard(e.source) then -- sync serivice?
                    sound.Play(sound.se.putCard)
                end
            end
        end
    end)
end

---@param self KoiKoi.UI
---@param element tes3uiElement
---@param cardId integer
---@param service KoiKoi.Service
function UI.RegisterGroundCardEvent(self, element, cardId, service)
    UnregisterEvents(element)

    element:register(tes3.uiEvent.mouseOver,
    ---@param e uiEventEventData
    function(e)
        -- highlight matching cards
        -- todo opponent (almost backface, but usefull for manual playing)
        -- if can then...
        local hand = e.source:getTopLevelMenu():findChild(uiid.playerHand)
        for _, value in pairs(hand.children) do
            local id = GetCardId(value)
            if id then
                SetCardColor(value, card.CanMatchSuit(cardId, id))
            end
        end
        e.source:getTopLevelMenu():updateLayout()
    end)

    element:register(tes3.uiEvent.mouseLeave,
    ---@param e uiEventEventData
    function(e)
        -- stop highlight
        -- if can then...
        local hand = e.source:getTopLevelMenu():findChild(uiid.playerHand)
        for key, value in pairs(hand.children) do
            SetCardColor(value, true)
        end
        e.source:getTopLevelMenu():updateLayout()
    end)

    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- stop highlight
        -- if can then...
        -- for key, value in pairs(self.playerViews[koi.player.you].card) do
        --     HighlightCard(value, true)
        -- end
        -- e.source:getTopLevelMenu():updateLayout()
        -- match and capture
        local grab = GetGrabCardId()
        if grab then
            local target = GetCardId(e.source) -- or use cardId
            if target and service:CanMatch(grab, target) then
                service:Capture(grab, false)
                service:Capture(target, true)
                -- house rule: multiple captring
                local grab = GetGrabCard()
                assert(grab)
                local root = e.source:getTopLevelMenu()
                local moved0 = CaptureCard(e.source)
                local moved1 = CaptureGrabCard()
                if moved0 and moved1 then
                    sound.Play(sound.se.putCard) -- todo
                end
                UnregisterEvents(moved0)
                UnregisterEvents(moved1)
                root:updateLayout()
                service:TransitPhase()
            else
                tes3.messageBox("Can't match this card with ...")
            end
        end
    end)
end

---@param self KoiKoi.UI
---@param element tes3uiElement
---@param service KoiKoi.Service
function UI.RegisterGroundEvent(self, element, service)
    UnregisterEvents(element)

    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- discard card
        -- or service has selectedcard
        local cardId = GetGrabCardId()
        if cardId then
            if service:CanDiscard(cardId) then
                service:Discard(cardId)
                local root = e.source:getTopLevelMenu()
                local g0 = e.source:getTopLevelMenu():findChild(uiid.boardGroundRow0)
                local g1 = e.source:getTopLevelMenu():findChild(uiid.boardGroundRow1)
                local g = table.size(g0.children) < table.size(g1.children) and g0 or g1
                local moved = ReleaseGrabedCard(g)
                if moved then
                    self:RegisterGroundCardEvent(moved, cardId, service)
                    sound.Play(sound.se.putCard)
                end
                root:updateLayout()
                service:TransitPhase()
            else
                tes3.messageBox("Can't discard this card.")
            end
        end
    end)
end

---@param self KoiKoi.UI
---@param element tes3uiElement
---@param cardId integer
---@param service KoiKoi.Service
function UI.RegisterDrawnCardEvent(self, element, cardId, service)
    -- currently same
    self:RegisterHandCardEvent(element, cardId, service)
end

---@param self KoiKoi.UI
---@param element tes3uiElement
---@param service KoiKoi.Service
function UI.RegisterDeckEvent(self, element, service)
    UnregisterEvents(element)
    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- draw card
        -- It can grab cards directly after drawing them, -- but it will be difficult to confirm by tooltip or mouseover.
        -- It also makes it difficult to confirm the opponent's draw.
        -- Currently, cards drawn should be placed and then grabbed.
        if service:CanDrawCard() then
            local cardId = service:DrawCard()
            if cardId then
                local drawn = e.source:getTopLevelMenu():findChild(uiid.boardDrawn)
                local element = PutCard(drawn, cardId, false)
                self:RegisterDrawnCardEvent(element, cardId, service)
                e.source:getTopLevelMenu():updateLayout()
                sound.Play(sound.se.pickCard)
            end
        end
    end)
end


-- There are two ways to register all the necessary events for controling use CanPerform to decide,
-- or register and unregister the necessary events in each phase for each phase.
-- Here, I try to use the CanPerform method as in a general application.

---@param self KoiKoi.UI
---@param parent KoiKoi.Player
---@param pools KoiKoi.PlayerPool[]
---@param groundPools integer[]
---@param deck integer[]
---@param service KoiKoi.Service
---@param skipAnimation boolean
function UI.DealInitialCards(self, parent, pools, groundPools, deck, service, skipAnimation)
    ---@return any
    local function putCards()
        local gameMenu = tes3ui.findMenu(uiid.gameMenu)
        assert(gameMenu)

        local back = parent ~= koi.player.you
        local child = koi.GetOpponent(parent)

        local g0 = gameMenu:findChild(uiid.boardGroundRow0)
        local g1 = gameMenu:findChild(uiid.boardGroundRow1)
        local ph = gameMenu:findChild(uiid.playerHand)
        local oh = gameMenu:findChild(uiid.opponentHand)
        local childHand = child == koi.player.you and ph or oh
        local parentHand = child == koi.player.you and oh or ph


        -- todo use from service settings
        local initialCards = 8
        local initialDealEach = 2
        -- must be no fraction
        -- annoy indexing begin 1
        for j = 0, (initialCards / initialDealEach) - 1 do
            local start = j * 2 + 1
            -- child
            for i = start, (start + (initialDealEach-1)) do
                --logger:trace(i)
                local view = childHand
                local cardId = pools[child].hand[i]
                local e = PutCard(view, cardId, not back)
                if child == koi.player.you then -- workaround
                    self:RegisterHandCardEvent(e, cardId, service)
                end
                if not skipAnimation then
                    gameMenu:updateLayout()
                    coroutine.yield(e)
                end
            end
            -- ground
            for i = start, (start + (initialDealEach-1)) do
                local cardId = groundPools[i]
                local view = (i % 2 == 0) and g1 or g0
                local e = PutCard(view, cardId, false)
                self:RegisterGroundCardEvent(e, cardId, service)
                if not skipAnimation then
                    gameMenu:updateLayout()
                    coroutine.yield(e)
                end
            end
            -- parent
            for i = start, (start + (initialDealEach-1)) do
                local view = parentHand
                local cardId = pools[parent].hand[i]
                local e = PutCard(view, cardId, back)
                if parent == koi.player.you then -- workaround
                    self:RegisterHandCardEvent(e, cardId, service)
                end
                if not skipAnimation then
                    gameMenu:updateLayout()
                    coroutine.yield(e)
                end
            end
        end
    end

    -- BUG Crash when using coroutine with enterFrame event present

    -- animation with coroutine or timer
    -- todo card animation deck to hand/ground

    if skipAnimation then
        putCards()

        local gameMenu = tes3ui.findMenu(uiid.gameMenu)
        assert(gameMenu)
        local pile = gameMenu:findChild(uiid.boardPile)
        local e = PutDeck(pile, deck)
        self:RegisterDeckEvent(e, service)
        gameMenu:updateLayout()
        sound.Play(sound.se.putDeck)
        logger:debug("dealing done")
        service:TransitPhase()

    else
        local deal = coroutine.wrap(putCards)
        timer.start({
            type = timer.real,
            ---@param e mwseTimerCallbackData
            callback = function(e)
                if deal() == nil then
                    --or infinit and use e.timer.cancel
                    -- notify servic to next phase
                    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
                    assert(gameMenu)
                    local pile = gameMenu:findChild(uiid.boardPile)
                    local e = PutDeck(pile, deck)
                    self:RegisterDeckEvent(e, service)
                    gameMenu:updateLayout()
                    sound.Play(sound.se.putDeck)
                    logger:debug("dealing done")
                    service:TransitPhase()
                else
                    sound.Play(sound.se.dealCard)
                end
            end,
            iterations = 8 * 3 + 1, -- cards and endpoint
            duration = 0.1,         -- tweak this
            persist = false,        -- hmm..perhaps false
        })
    end
end

---@param self KoiKoi.UI
---@param player KoiKoi.Player
---@param parent KoiKoi.Player
---@param service KoiKoi.Service
function UI.BeginTurn(self, player, parent, service)
    local getname = function(player, parent)
        if player == parent then
            return "Parent " .. tostring(player)
        else
            return "Child " .. tostring(player)
        end
    end
    tes3.messageBox("%s Turn", getname(player, parent))
    -- todo jingle
    service:TransitPhase()
end

---@param cardId integer
---@param backface boolean
---@return tes3uiElement?
function UI.CreateCardTooltip(cardId, backface)
    local tooltip = tes3ui.createTooltipMenu()
    if backface then
        tooltip:createLabel { text = "Opponent's card" }
    else
        tooltip = tes3ui.createTooltipMenu()
        local asset = card.GetCardAsset(cardId)
        local thumb = tooltip:createImage({ path = asset.path })
        thumb.width = card.GetCardWidth() * 2
        thumb.height = card.GetCardHeight() * 2
        thumb.scaleMode = true
        local ref = card.GetCardData(cardId)
        local name = tooltip:createLabel({ text = card.GetCardText(cardId).name })
        name.color = tes3ui.getPalette(tes3.palette.headerColor)
        tooltip:createLabel({ text = card.GetCardSuitText(ref.suit).name .. " (" .. tostring(ref.suit) .. ")" })
        local type = tooltip:createLabel({ text = card.GetCardTypeText(ref.type).name })
        type.color = card.GetCardTypeColor(ref.type)
        -- todo add flavor
        tooltip:createDivider().widthProportional = 0.8
        local desc = tooltip:createBlock()
        desc.minWidth = thumb.width
        desc.maxWidth = thumb.width * 1.5
        desc.autoWidth = true
        desc.autoHeight = true
        local flavor = desc:createLabel({text = "flavor text here"})
        flavor.wrapText = true
    end
    return tooltip
end

---@param deck integer[]
---@return tes3uiElement tooltip
function UI.CreateDeckTooltip(deck)
    local tooltip = tes3ui.createTooltipMenu()
    local label = tooltip:createLabel({ text = tostring(table.size(deck)) .. " cards remaining" })
    label.color = tes3ui.getPalette(tes3.palette.headerColor)
    return tooltip
end


--- in card gamae, player means each 'player'
--- but in this video game, player is you.

---@param parent tes3uiElement
---@param id number
---@param type CardType
---@return tes3uiElement
local function CreateTypeArea(parent, id, type)
    local area = parent:createRect({ id = id, color = card.GetCardTypeColor(type) })
    area.widthProportional = 1
    area.minHeight = cardLayoutHeight
    area.height = cardLayoutHeight
    area.flowDirection = tes3.flowDirection.leftToRight
    area.alpha = 0.25
    --area.paddingAllSides = 2
    area.childAlignY = 0.5
    area:register(tes3.uiEvent.help,
    ---@param e uiEventEventData
    function(e)
        local tooltip = tes3ui.createTooltipMenu()
        local label = tooltip:createLabel({ text = card.GetCardTypeText(type).name .. " description here" })
    end)
    return area
end

---@param parent tes3uiElement
---@return tes3uiElement
local function CreateTypeFrame(parent)
    local frame = parent:createThinBorder()
    frame.widthProportional = 1
    frame.minHeight = cardLayoutHeight + 2
    frame.height = cardLayoutHeight + 2
    frame.flowDirection = tes3.flowDirection.leftToRight
    frame.paddingAllSides = 2
    return frame
end

---@param parent tes3uiElement
local function CreateHandView(parent, id, height)
    local border = parent:createThinBorder()
    border.widthProportional = 1
    border.heightProportional = height
    border.flowDirection = tes3.flowDirection.topToBottom

    local hand = border:createBlock({ id = id })
    hand.widthProportional = 1
    hand.heightProportional = 1
    hand.flowDirection = tes3.flowDirection.leftToRight
    --hand.paddingAllSides = 2
    hand.childAlignX = 0.5
    hand.childAlignY = 0.5
    hand.minWidth= cardLayoutWidth * 8
    hand.minHeight = cardLayoutHeight
end

---@param parent tes3uiElement
local function CreateBoard(parent, height)
    local area = parent:createBlock()
    area.widthProportional = 1
    area.heightProportional = height
    area.flowDirection = tes3.flowDirection.leftToRight

    -- todo tweak layout
    local border = area:createBlock()
    -- for placement dealing card or vertical placement
    -- border.minWidth = cardLayoutWidth
    -- border.minHeight = cardLayoutHeight * 2
    --border.autoWidth = true
    border.width = cardLayoutWidth * 2
    border.heightProportional = 1
    border.flowDirection = tes3.flowDirection.topToBottom
    --border.paddingAllSides = 2
    border.childAlignX = 0.5
    border.childAlignY = 0.5
    local pile = border:createBlock({id = uiid.boardPile })
    --pile.width = cardLayoutWidth * 2
    --pile.minWidth = cardLayoutWidth*2
    -- pile.minHeight = cardLayoutHeight * 2
    --pile.autoWidth = true -- why?
    pile.widthProportional = 1
    pile.heightProportional = 1
    pile.childAlignX = 0.5
    pile.childAlignY = 0.5
    local drawn = border:createBlock({id = uiid.boardDrawn })
    --drawn.width = cardLayoutWidth * 2
    --drawn.minWidth = cardLayoutWidth*2
    -- drawn.minHeight = cardLayoutHeight * 2
    --drawn.autoWidth = true -- why?
    drawn.widthProportional = 1
    drawn.heightProportional = 1
    drawn.childAlignX = 0.5
    drawn.childAlignY = 0.5

    -- double rows
    local block = area:createBlock()
    -- block.minWidth = cardLayoutWidth * 4
    -- block.minHeight = cardLayoutHeight * 2
    block.widthProportional = 1
    block.heightProportional = 1
    block.flowDirection = tes3.flowDirection.topToBottom

    ---@param parent tes3uiElement
    ---@param id number
    local function CreateGround(parent, id)
        local ground = parent:createBlock({id = id })
        ground.widthProportional = 1
        ground.heightProportional = 1
        ground.flowDirection = tes3.flowDirection.leftToRight
        --ground.paddingAllSides = 2
        ground.childAlignX = 0.5
        ground.childAlignY = 0.5
        -- ground.minWidth = cardLayoutWidth * 4 -- double rows and use 4
        -- ground.minHeight = cardLayoutHeight * 2
        -- min value affect childAlign, why?
        return ground
    end

    local ground = CreateGround(block, uiid.boardGroundRow0)
    ground.childAlignY = 1.0
    ground = CreateGround(block, uiid.boardGroundRow1)
    ground.childAlignY = 0.0
    -- ground.minWidth = cardLayoutWidth * 4 -- double rows and use 4
    -- ground.minHeight = cardLayoutHeight * 2
end

---@param parent tes3uiElement
local function CreateYourCaptured(parent)
    local captured = parent:createBlock()
    captured.widthProportional = 1
    captured.heightProportional = 1
    captured.flowDirection = tes3.flowDirection.topToBottom
    captured.childAlignY = 1

    local block = captured:createBlock()
    block.childAlignX = 0
    block.widthProportional = 1
    block.autoHeight = true
    block:createLabel({text="Your Captured Cards"}) -- todo name

    local bright = CreateTypeArea(CreateTypeFrame(captured), uiid.playerBright, card.type.bright)
    local animal = CreateTypeArea(CreateTypeFrame(captured), uiid.playerAnimal, card.type.animal)
    local ribbon = CreateTypeArea(CreateTypeFrame(captured), uiid.playerRibbon, card.type.ribbon)
    local chaff = CreateTypeArea(CreateTypeFrame(captured), uiid.playerChaff, card.type.chaff)

end

---@param parent tes3uiElement
local function CreateOpponentCaptured(parent)
    local captured = parent:createBlock()
    captured.widthProportional = 1
    captured.autoHeight = true
    captured.flowDirection = tes3.flowDirection.topToBottom
    local bright = CreateTypeArea(CreateTypeFrame(captured), uiid.opponentBright, card.type.bright)
    local animal = CreateTypeArea(CreateTypeFrame(captured), uiid.opponentAnimal, card.type.animal)
    local ribbon = CreateTypeArea(CreateTypeFrame(captured), uiid.opponentRibbon, card.type.ribbon)
    local chaff = CreateTypeArea(CreateTypeFrame(captured), uiid.opponentChaff, card.type.chaff)
    bright.childAlignX = 1.0
    animal.childAlignX = 1.0
    ribbon.childAlignX = 1.0
    chaff.childAlignX = 1.0

    local block = captured:createBlock()
    block.childAlignX = 1
    block.widthProportional = 1
    block.autoHeight = true
    local label = block:createLabel({text="Opponent's Captured Cards"}) -- todo name
end

local function CreateInfo(parent)
    -- TODO
    local exit = parent:createButton({text = "Yield"})
    local combo = parent:createButton({text = "Combination List"})
    local rule = parent:createButton({text = "Quick Rule"})
    parent:createLabel({text = "Round"})
    parent:createLabel({text = "Opponent Name"})
    parent:createLabel({text = "Opponent Portrait"})
    parent:createLabel({text = "Opponent is parent or child"})
    parent:createLabel({text = "Opponent Score"})
    parent:createLabel({text = "Opponent Combination"})
    parent:createLabel({text = "Your Name"})
    parent:createLabel({text = "Your Portrait"})
    parent:createLabel({text = "You are parent or child"})
    parent:createLabel({text = "Your Score"})
    parent:createLabel({text = "Your Combination"})
    combo:register(tes3.uiEvent.mouseClick, CreateCombinationList)
end

---@param id number|string
---@param service KoiKoi.Service
function UI.OpenGameMenu(self, id, service)

    -- pre-load all resources?

    local viewportWidth, viewportHeight = tes3ui.getViewportSize()

    local menu = tes3ui.createMenu({ id = id, fixedFrame = true })
    menu:destroyChildren()
    --menu.disabled = true
    local borderSize = 0
    menu.absolutePosAlignX = 0.5
	menu.absolutePosAlignY = 0.5
    menu.borderAllSides = borderSize
    menu.paddingAllSides = 0
    menu.color = { 0.0, 0.0, 0.0 }
    menu.alpha = 0.5
    menu.autoWidth = false
    menu.autoHeight = false
    menu.minWidth = viewportWidth / 2
    menu.minHeight = viewportHeight / 2
    menu.width = viewportWidth - borderSize * 2
    menu.height = viewportHeight - borderSize * 2
    menu.maxWidth = viewportWidth
    menu.maxHeight = viewportHeight
    menu.positionX = -menu.width * 0.5 -- center
    menu.positionY = menu.height * 0.5 -- center
    menu.childAlignX = 0.5
    menu.childAlignY = 0.5
    menu.flowDirection = tes3.flowDirection.leftToRight
    menu:updateLayout()

    -- local bg = menu:createImage({ path = "Textures/Tx_b_n_khajiit_f_h03.dds" })
    -- bg.widthProportional = 1
    -- bg.heightProportional = 1
    -- bg.imageScaleX = 4
    -- bg.imageScaleY = 3 -- todo aspect
    -- bg.scaleMode = false -- true is buggy, then using false and set manulay imageScaleX/Y

    local left = menu:createBlock()
    left.widthProportional = 0.8
    left.heightProportional = 1
    left.flowDirection = tes3.flowDirection.topToBottom
    left.childAlignY = 0.5
    local center = menu:createBlock()
    center.widthProportional = 1.2
    center.heightProportional = 1
    center.flowDirection = tes3.flowDirection.topToBottom
    center.minWidth = cardLayoutWidth * 8 -- initial card
    center.childAlignY = 0.5
    local right = menu:createBlock()
    right.widthProportional = 1
    right.heightProportional = 1
    right.flowDirection = tes3.flowDirection.topToBottom
    right.childAlignY = 0.5

    CreateInfo(left)

    CreateOpponentCaptured(right)
    CreateYourCaptured(right)

    local board = center:createRect()
    board.color = { 0.0, 0.0, 0.0 }
    board.alpha = 0.5
    board.widthProportional = 1
    board.heightProportional = 1
    board.flowDirection = tes3.flowDirection.topToBottom
    CreateHandView(board, uiid.opponentHand, 0.75)
    CreateBoard(board, 1.5)
    CreateHandView(board, uiid.playerHand, 0.75)

    self:RegisterHandEvent(board:findChild(uiid.opponentHand), service)
    self:RegisterHandEvent(board:findChild(uiid.playerHand), service)
    self:RegisterGroundEvent(board:findChild(uiid.boardGroundRow0), service)
    self:RegisterGroundEvent(board:findChild(uiid.boardGroundRow1), service)

    menu:updateLayout()
    -- getting actual size

    -- present card dragging
    local grabMenu = tes3ui.createHelpLayerMenu({ id = uiid.grabMenu }) -- maybe fixedFrame not work
    grabMenu:destroyChildren()
    grabMenu.absolutePosAlignX = nil
    grabMenu.absolutePosAlignY = nil
    grabMenu.borderAllSides = 0
    grabMenu.paddingAllSides = 0
    grabMenu.autoWidth = true
    grabMenu.autoHeight = true
    grabMenu.disabled = true
    grabMenu.visible = false
    grabMenu:updateLayout()

    return menu
end

---@param self KoiKoi.UI
---@param service KoiKoi.Service
function UI.Initialize(self, service)
    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(not gameMenu)
    gameMenu = self:OpenGameMenu(uiid.gameMenu, service)
    tes3ui.enterMenuMode(gameMenu.id)
end

---@param self KoiKoi.UI
function UI.Shutdown(self)
    local overlayMenu = tes3ui.findHelpLayerMenu(uiid.grabMenu)
    if overlayMenu then
        overlayMenu:destroy()
    end

    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    if gameMenu then
        gameMenu:destroy()
        tes3ui.leaveMenuMode()
    end
end

---@param e enterFrameEventData
function UI:OnEnterFrame(e)
    -- follow cursor
    local grab = tes3ui.findHelpLayerMenu(uiid.grabMenu)
    if grab and grab.visible and not grab.disabled then
        local cursor = tes3.getCursorPosition() -- coordinate is same as ui
        -- TODO need offset by clicking position
        grab.positionX = cursor.x - grab.width * 0.5
        grab.positionY = cursor.y + grab.height * 0.5
        grab:updateLayout()
    end
end

return UI
