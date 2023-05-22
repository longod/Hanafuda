local uiid = require("Hanafuda.uiid")
local card = require("Hanafuda.card")
local sound = require("Hanafuda.sound")
local logger = require("Hanafuda.logger")
local koi = require("Hanafuda.KoiKoi.koikoi")
local i18n = mwse.loadTranslations("Hanafuda")

-- with mergin
local cardLayoutWidth = card.GetCardWidth() + 4
local cardLayoutHeight = card.GetCardHeight() + 4
local enabledCardColor = { 1, 1, 1 }
local disabledCardColor = { 0.2, 0.2, 0.2 }

local rainman = card.Find({ symbol = card.symbol.rainman }) ---@cast rainman integer
local curtain = card.Find({ symbol = card.symbol.curtain }) ---@cast curtain integer
local moon = card.Find({ symbol = card.symbol.moon }) ---@cast moon integer
local boar = card.Find({ symbol = card.symbol.boar }) ---@cast boar integer
local deer = card.Find({ symbol = card.symbol.deer }) ---@cast deer integer
local butterfly = card.Find({ symbol = card.symbol.butterfly }) ---@cast butterfly integer
local sakeCup = card.Find({ symbol = card.symbol.sakeCup }) ---@cast sakeCup integer
local redPoetry = card.Find({ symbol = card.symbol.redPoetry, findAll = true }) ---@cast redPoetry integer[]
local blueRibbon = card.Find({ symbol = card.symbol.blue, findAll = true }) ---@cast blueRibbon integer[]
assert(rainman)
assert(curtain)
assert(moon)
assert(boar)
assert(deer)
assert(butterfly)
assert(sakeCup)
assert(redPoetry and table.size(redPoetry) == 3)
assert(blueRibbon and table.size(blueRibbon) == 3)

---@param parent tes3uiElement
---@param combination KoiKoi.CombinationType
---@param actualPoint integer?
---@return tes3uiElement
local function CreateCombinationView(parent, combination, actualPoint)
    local header = tes3ui.getPalette(tes3.palette.headerColor)
    local block = parent:createBlock()
    block.flowDirection = tes3.flowDirection.topToBottom
    block.autoWidth = true
    block.autoHeight = true

    local indent = 12

    ---@param cardIds integer[]
    local listup = function(cardIds)
        local pattern = block:createBlock()
        pattern.autoWidth = true
        pattern.autoHeight = true
        pattern.flowDirection = tes3.flowDirection.leftToRight
        pattern.borderAllSides = 0
        pattern.borderLeft = indent

        for index, cardId in ipairs(cardIds) do
            local asset = card.GetCardAsset(cardId)
            local ref = card.GetCardData(cardId)
            local b = pattern:createBlock()
            b.borderAllSides = 0
            b.autoWidth = true
            b.autoHeight = true
            b.flowDirection = tes3.flowDirection.topToBottom
            b.childAlignX = 0.5
            local image = b:createImage({ path = asset.path })
            image.width = card.GetCardWidth() * 0.75
            image.height = card.GetCardHeight() * 0.75
            image.scaleMode = true
            image.consumeMouseEvents = false
            image.borderAllSides = 2
            image.flowDirection = tes3.flowDirection.topToBottom
            -- without card name for layout
            -- b:createLabel({ text = card.GetCardSuitText(ref.suit).name .. " (" .. tostring(ref.suit) .. ")" })
            -- local type = b:createLabel({ text = card.GetCardTypeText(ref.type).name })
            -- type.color = card.GetCardTypeColor(ref.type)
        end
        return pattern

    end
    local desc = {
        [koi.combination.fiveBrights] = {
            name = "Goko",
            point = string.format("%u points.", koi.basePoint[koi.combination.fiveBrights]),
            condition = string.format("All 5 %s cards.", card.GetCardTypeText(card.type.bright).name),
        },
        [koi.combination.fourBrights] = {
            name = "Shiko",
            point = string.format("%u points.", koi.basePoint[koi.combination.fourBrights]),
            condition = string.format("All 4 %s cards without %s.", card.GetCardTypeText(card.type.bright).name, card.GetCardText(rainman).name),
        },
        [koi.combination.rainyFourBrights] = {
            name = "Ame-Shiko",
            point = string.format("%u points.", koi.basePoint[koi.combination.rainyFourBrights]),
            condition = string.format("Any 4 %s cards.", card.GetCardTypeText(card.type.bright).name),
        },
        [koi.combination.threeBrights] = {
            name = "Sanko",
            point = string.format("%u points.", koi.basePoint[koi.combination.threeBrights]),
            condition = string.format("Any 3 %s cards.", card.GetCardTypeText(card.type.bright).name),
        },
        [koi.combination.boarDeerButterfly] = {
            name = "Ino-Shika-Cho",
            point = string.format("%u points.", koi.basePoint[koi.combination.boarDeerButterfly]),
            condition = string.format("%s, %s and %s", card.GetCardText(boar).name, card.GetCardText(deer).name, card.GetCardText(butterfly).name),
        },
        [koi.combination.animals] = {
            name = "Tane",
            point = string.format("%u points and 1 additional point for each additional %s card.", koi.basePoint[koi.combination.animals], card.GetCardTypeText(card.type.animal).name),
            condition = string.format("Any five %s cards.", card.GetCardTypeText(card.type.animal).name),
        },
        [koi.combination.poetryAndBlueRibbons] = {
            name = "Akatan-Aotan",
            point = string.format("%u points and 1 additional point for each additional %s card.", koi.basePoint[koi.combination.poetryAndBlueRibbons], card.GetCardTypeText(card.type.ribbon).name),
            condition = string.format("All 3 Red Poetry %s cards and all 3 Blue %s cards.", card.GetCardTypeText(card.type.ribbon).name, card.GetCardTypeText(card.type.ribbon).name),
        },
        [koi.combination.poetryRibbons] = {
            name = "Akatan",
            point = string.format("%u points and 1 additional point for each additional %s card.", koi.basePoint[koi.combination.poetryRibbons], card.GetCardTypeText(card.type.ribbon).name),
            condition = string.format("%s, %s and %s", card.GetCardText(redPoetry[1]).name, card.GetCardText(redPoetry[2]).name, card.GetCardText(redPoetry[3]).name),
        },
        [koi.combination.blueRibbons] = {
            name = "Aotan",
            point = string.format("%u points and 1 additional point for each additional %s card.", koi.basePoint[koi.combination.blueRibbons], card.GetCardTypeText(card.type.ribbon).name),
            condition = string.format("%s, %s and %s", card.GetCardText(blueRibbon[1]).name, card.GetCardText(blueRibbon[2]).name, card.GetCardText(blueRibbon[3]).name),
        },
        [koi.combination.ribbons] = {
            name = "Tan",
            point = string.format("%u points and 1 additional point for each additional %s card.", koi.basePoint[koi.combination.ribbons], card.GetCardTypeText(card.type.ribbon).name),
            condition = string.format("Any 5 %s cards.", card.GetCardTypeText(card.type.ribbon).name),
        },
        [koi.combination.flowerViewingSake] = {
            name = "Hanami de Ippai",
            point = string.format("%u points.", koi.basePoint[koi.combination.flowerViewingSake]),
            condition = string.format("%s and %s", card.GetCardText(curtain).name, card.GetCardText(sakeCup).name),
        },
        [koi.combination.moonViewingSake] = {
            name = "Tsukimi de Ippai",
            point = string.format("%u points.", koi.basePoint[koi.combination.moonViewingSake]),
            condition = string.format("%s and %s", card.GetCardText(moon).name, card.GetCardText(sakeCup).name),
        },
        [koi.combination.chaff] = {
            name = "Kasu",
            point = string.format("%u points and 1 additional point for each additional %s card.", koi.basePoint[koi.combination.chaff], card.GetCardTypeText(card.type.chaff).name),
            condition = string.format("Any 10 %s cards.", card.GetCardTypeText(card.type.chaff).name),
        },
    }
    local comb = {
        [koi.combination.fiveBrights] = function()
            local list = card.Find({type = card.type.bright, findAll = true}) ---@cast list integer[]
            listup(list)
        end,
        [koi.combination.fourBrights] = function()
            local list = card.Find({type = card.type.bright, findAll = true}) ---@cast list integer[]
            table.removevalue(list, rainman)
            listup(list)
        end,
        [koi.combination.rainyFourBrights] = function()
        end,
        [koi.combination.threeBrights] = function()
        end,
        [koi.combination.boarDeerButterfly] = function()
            local list = {boar, deer, butterfly}
            listup(list)
        end,
        [koi.combination.animals] = function()
        end,
        [koi.combination.poetryAndBlueRibbons] = function()
            local list = {}
            list = {redPoetry[1], redPoetry[2], redPoetry[3], blueRibbon[1], blueRibbon[2], blueRibbon[3] }
            listup(list)
        end,
        [koi.combination.poetryRibbons] = function()
            listup(redPoetry)
        end,
        [koi.combination.blueRibbons] = function()
            listup(blueRibbon)
        end,
        [koi.combination.ribbons] = function()
        end,
        [koi.combination.flowerViewingSake] = function()
            local list = {curtain, sakeCup}
            listup(list)
        end,
        [koi.combination.moonViewingSake] = function()
            local list = {moon, sakeCup}
            listup(list)
        end,
        [koi.combination.chaff] = function()
        end,
    }


    if comb[combination] and desc[combination] then
        local d = desc[combination]
        local name = block:createLabel({ text = d.name})
        name.color = header
        -- todo if actualPoint
        -- todo getting table data
        block:createLabel({ text = d.point }).borderLeft = indent
        block:createLabel({ text = d.condition }).borderLeft = indent

        comb[combination]()
    else
        logger:error("unknown combination %u", combination)
    end
    return block
end

---@param e uiEventEventData
local function CreateCombinationList(e)
    -- TODO
    logger:debug("combo help")
    local menu = tes3ui.createHelpLayerMenu({id = "helpcombo", dragFrame= true })
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
        CreateCombinationView(menu, value)
    end
    menu:updateLayout()
    --pane.widget:contentsChanged()
end

---@class PlayerView
---@field hand tes3uiElement
---@field [CardType] tes3uiElement
---@field card {[integer] : tes3uiElement} card pool

---@class GroundView
---@field pile tes3uiElement
---@field drawn tes3uiElement
---@field ground tes3uiElement
---@field card {[integer] : tes3uiElement} card pool

---@class KoiKoi.UI
---@field groundView GroundView
---@field playerViews PlayerView[]
local UI = {}

---@return KoiKoi.UI
function UI.new()
    --@type KoiKoi.UI
    local instance = {}
    setmetatable(instance, { __index = UI })
    return instance
end

function UI.ShowCallingDialog()
    tes3ui.showMessageMenu({
        -- id = "Calling",
        header = "Calling",
        message = "here scoring combinations",
        buttons = {
            -- todo tooltips
            {
                text = "Koi-koi",
                callback = function()
                    sound.PlayVoice(sound.voice.continue, "", false)

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
                end,
                tooltip = function()
                    local tooltip = tes3ui.createTooltipMenu()
                    tooltip:createLabel({ text = "you win" })
                end
            },
        }
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

---@param parent tes3uiElement
---@param cardId integer
---@param backface boolean
---@return tes3uiElement
local function PutCard(parent, cardId, backface)
    local asset = backface and card.GetCardBackAsset() or card.GetCardAsset(cardId)

    -- todo child on block for flipping
    local image = parent:createImage({ path = asset.path })
    -- image.ignoreLayoutX = true
    -- image.ignoreLayoutY = true
    -- image.positionX = 10
    -- image.positionY = 10
    image.width = card.GetCardWidth()
    image.height = card.GetCardHeight()
    image.scaleMode = true
    image.consumeMouseEvents = true
    image.borderAllSides = 2
    -- if not image.widget then
    --     image.widget = {}
    -- end
    -- image.widget.cardId = cardId -- i want to embeded...

    image:register(tes3.uiEvent.help,
    ---@param e uiEventEventData
    function(e)
        UI.CreateCardTooltip(cardId, backface)
    end)

    return image
end
---@param parent tes3uiElement
---@param deck integer[]
---@return tes3uiElement
local function PutDeck(parent, deck)
    local asset = card.GetCardBackAsset()

    -- todo child for flipping
    local image = parent:createImage({ path = asset.path })
    -- image.ignoreLayoutX = true
    -- image.ignoreLayoutY = true
    -- image.positionX = 10
    -- image.positionY = 10
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

-- fixme Only notification without direct transition is desirable.

---@param self KoiKoi.UI
---@param element tes3uiElement
---@param cardId integer
---@param service KoiKoi.Service
function UI.RegisterHandCardEvent(self, element, cardId, service)
    element:register(tes3.uiEvent.mouseOver,
    ---@param e uiEventEventData
    function(e)
        -- highlight matching ground cards
        -- if can then...
        for key, value in pairs(self.groundView.card) do
            if not card.CanMatchSuit(cardId, key) then
                value.color = disabledCardColor
            end
        end
        e.source:getTopLevelMenu():updateLayout()
    end)
    element:register(tes3.uiEvent.mouseLeave,
    ---@param e uiEventEventData
    function(e)
        -- stop highlight
        -- if can then...
        for key, value in pairs(self.groundView.card) do
            value.color = enabledCardColor
        end
        e.source:getTopLevelMenu():updateLayout()
    end)
    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- keep highlight
        -- grab card
    end)
end

---@param self KoiKoi.UI
---@param element tes3uiElement
---@param service KoiKoi.Service
function UI.RegisterHandEvent(self, element, service)
    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- cancel, put back card
    end)
end

---@param self KoiKoi.UI
---@param element tes3uiElement
---@param cardId integer
---@param service KoiKoi.Service
function UI.RegisterGroundCardEvent(self, element, cardId, service)
    element:register(tes3.uiEvent.mouseOver,
    ---@param e uiEventEventData
    function(e)
        -- highlight matching cards
        -- todo opponent (almost backface, but usefull for manual playing)
        -- if can then...
        for key, value in pairs(self.playerViews[koi.player.you].card) do
            if not card.CanMatchSuit(cardId, key) then
                value.color = disabledCardColor
            end
        end
        e.source:getTopLevelMenu():updateLayout()
    end)
    element:register(tes3.uiEvent.mouseLeave,
    ---@param e uiEventEventData
    function(e)
        -- stop highlight
        -- if can then...
        for key, value in pairs(self.playerViews[koi.player.you].card) do
            value.color = enabledCardColor
        end
        e.source:getTopLevelMenu():updateLayout()
    end)
    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- stop highlight
        -- if can then...
        for key, value in pairs(self.playerViews[koi.player.you].card) do
            value.color = enabledCardColor
        end
        e.source:getTopLevelMenu():updateLayout()
        -- match and capture
    end)
end

---@param self KoiKoi.UI
---@param element tes3uiElement
---@param service KoiKoi.Service
function UI.RegisterGroundEvent(self, element, service)
    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- discard card
    end)
end

---@param self KoiKoi.UI
---@param element tes3uiElement
---@param service KoiKoi.Service
function UI.RegisterDeckEvent(self, element, service)
    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- draw card
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

        local initialCards = 8
        local initialDealEach = 2
        -- must be no fraction
        -- annoy indexing begin 1
        for j = 0, (initialCards / initialDealEach) - 1 do
            local start = j * 2 + 1
            -- child
            for i = start, (start + (initialDealEach-1)) do
                --logger:trace(i)
                local view = self.playerViews[child].hand
                local cardId = pools[child].hand[i]
                local e = PutCard(view, cardId, not back)
                self.playerViews[child].card[cardId] = e
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
                local e = PutCard(self.groundView.ground, cardId, false)
                self.groundView.card[cardId] = e
                self:RegisterGroundCardEvent(e, cardId, service)
                if not skipAnimation then
                    gameMenu:updateLayout()
                    coroutine.yield(e)
                end
            end
            -- parent
            for i = start, (start + (initialDealEach-1)) do
                local view = self.playerViews[parent].hand
                local cardId = pools[parent].hand[i]
                local e = PutCard(view, cardId, back)
                self.playerViews[parent].card[cardId] = e
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

        local e = PutDeck(self.groundView.pile, deck)
        local gameMenu = tes3ui.findMenu(uiid.gameMenu)
        assert(gameMenu)
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
                    local e = PutDeck(self.groundView.pile, deck)
                    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
                    assert(gameMenu)
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
    area.paddingAllSides = 2
    area.childAlignY = 0.5
    area:register(tes3.uiEvent.help,
    ---@param e uiEventEventData
    function(e)
        local tooltip = tes3ui.createTooltipMenu()
        local label = tooltip:createLabel({ text = "combination description here" })
    end)
    return area
end

---@param parent tes3uiElement
---@return tes3uiElement
local function CreateTypeFrame(parent)
    local frame = parent:createThinBorder()
    frame.widthProportional = 1
    frame.minHeight = cardLayoutHeight
    frame.height = cardLayoutHeight
    frame.flowDirection = tes3.flowDirection.leftToRight
    frame.paddingAllSides = 2
    return frame
end

---@param parent tes3uiElement
---@return tes3uiElement
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
    return hand
end

---@param parent tes3uiElement
---@return GroundView
local function CreateBoard(parent, height)
    local area = parent:createBlock()
    area.widthProportional = 1
    area.heightProportional = height
    area.flowDirection = tes3.flowDirection.leftToRight

    local border = area:createBlock()
    -- for placement dealing card or vertical placement
    border.minWidth = cardLayoutWidth
    border.minHeight = cardLayoutHeight * 2
    border.autoWidth = true
    border.heightProportional = 1
    border.flowDirection = tes3.flowDirection.topToBottom
    --border.paddingAllSides = 2
    border.childAlignX = 0.5
    border.childAlignY = 0.5
    local pile = border:createBlock({id = uiid.boardPile })
    pile.width = cardLayoutWidth * 2
    pile.minWidth = cardLayoutWidth
    pile.minHeight = cardLayoutHeight * 2
    pile.heightProportional = 1
    pile.childAlignX = 0.5
    pile.childAlignY = 0.5
    local drawn = border:createBlock({id = uiid.boardDrawn })
    drawn.width = cardLayoutWidth * 2
    drawn.minWidth = cardLayoutWidth
    drawn.minHeight = cardLayoutHeight * 2
    drawn.heightProportional = 1
    drawn.childAlignX = 0.5
    drawn.childAlignY = 0.5

    -- todo double rows
    local ground = area:createBlock({id = uiid.boardGround })
    ground.widthProportional = 1
    ground.heightProportional = 1
    ground.flowDirection = tes3.flowDirection.leftToRight
    --ground.paddingAllSides = 2
    ground.childAlignX = 0.5
    ground.childAlignY = 0.5
    ground.minWidth = cardLayoutWidth * 8 -- fixme double rows and use 4
    ground.minHeight = cardLayoutHeight * 2

    return { pile = pile, drawn = drawn, ground = ground }
end

---@param parent tes3uiElement
---@return PlayerView
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
    bright.childAlignX = 1.0
    animal.childAlignX = 1.0
    ribbon.childAlignX = 1.0
    chaff.childAlignX = 1.0
    return {
        -- hand later
        [card.type.bright] = bright,
        [card.type.animal] = animal,
        [card.type.ribbon] = ribbon,
        [card.type.chaff] = chaff,
    }
end

---@param parent tes3uiElement
---@return PlayerView
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

    return {
        -- hand later
        [card.type.bright] = bright,
        [card.type.animal] = animal,
        [card.type.ribbon] = ribbon,
        [card.type.chaff] = chaff,
    }
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
    local borderSize = 4
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

    self.playerViews = {}
    self.playerViews[koi.player.opponent] = CreateOpponentCaptured(right)
    self.playerViews[koi.player.you] = CreateYourCaptured(right)

    local board = center:createRect()
    board.color = { 0.0, 0.0, 0.0 }
    board.alpha = 0.5
    board.widthProportional = 1
    board.heightProportional = 1
    board.flowDirection = tes3.flowDirection.topToBottom
    self.playerViews[koi.player.opponent].hand = CreateHandView(board, uiid.opponentHand, 0.75)
    self.groundView = CreateBoard(board, 1.5)
    self.playerViews[koi.player.you].hand = CreateHandView(board, uiid.playerHand, 0.75)

    -- allocate card table
    self.groundView.card = {}
    self.playerViews[koi.player.opponent].card = {}
    self.playerViews[koi.player.you].card = {}

    self:RegisterHandEvent(self.playerViews[koi.player.opponent].hand, service)
    self:RegisterHandEvent(self.playerViews[koi.player.you].hand, service)
    self:RegisterGroundEvent(self.groundView.ground, service)

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


return UI
