dofile("Hanafuda/test.lua")

local logger = require("Hanafuda.logger")
local card = require("Hanafuda.card")
local uiid = require("Hanafuda.uiid")


---@class PlayerView
---@field hand tes3uiElement
---@field bright tes3uiElement
---@field animal tes3uiElement
---@field ribbon tes3uiElement
---@field chaff tes3uiElement

---@class GroundView
---@field pile tes3uiElement
---@field ground tes3uiElement

--math.randomseed()
local initialPlayerCards = 8
local initialPlaygroundCards = 8
local initialDealEach = 2

local playerPool = {} -- @type integer[]
local opponentPool = {} -- @type integer[]
local groundPool = {} -- @type integer[]
local opponentView = {} ---@typee PlayerView
local groundView = {} ---@typee GroundView
local playerView = {} ---@typee PlayerView
local opponentCardView = {} ---@typee { intger: tes3uiElement }
local groundCardView = {} ---@typee { intger: tes3uiElement }
local playerCardView = {} ---@typee { intger: tes3uiElement }

local deck = card.createDeck()
deck = card.shuffleDeck(deck)

while not (#playerPool >= initialPlayerCards and #opponentPool >= initialPlayerCards and #groundPool >= initialPlaygroundCards) do
    -- todo check count
    for i = 1, initialDealEach do
        table.insert(playerPool, card.dealCard(deck))
    end
    for i = 1, initialDealEach do
        table.insert(groundPool, card.dealCard(deck))
    end
    for i = 1, initialDealEach do
        table.insert(opponentPool, card.dealCard(deck))
    end
end


---@param cardId0 integer
---@param cardId1 integer
---@return boolean
local function CanMatch(cardId0, cardId1)
    return card.getCardData(cardId0).suit == card.getCardData(cardId1).suit
end

local selectedCard = nil ---@type integer?

---@param parent tes3uiElement
---@param cardId integer
---@param backface boolean
---@return tes3uiElement
local function PutCard(parent, cardId, backface)
    local asset = backface and card.getCardBackAsset() or card.getCardAsset(cardId)

    -- todo child for flipping
    local image = parent:createImage({ path = asset.path })
    -- image.ignoreLayoutX = true
    -- image.ignoreLayoutY = true
    -- image.positionX = 10
    -- image.positionY = 10
    image.width = card.getCardWidth()
    image.height = card.getCardHeight()
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
        local tooltip = tes3ui.createTooltipMenu()
        if backface then
            local name = tooltip:createLabel{text = "Back" }
            name.color = tes3ui.getPalette(tes3.palette.headerColor)
        else
            local thumb = tooltip:createImage({path = asset.path })
            thumb.width = card.getCardWidth() * 2
            thumb.height = card.getCardHeight() * 2
            thumb.scaleMode = true
            local ref = card.getCardData(cardId)
            local name = tooltip:createLabel{text = card.getCardText(cardId).name }
            name.color = card.getCardTypeColor(ref.type)
            tooltip:createLabel{text = card.getCardSuitText(ref.suit).name .. " (" .. tostring(ref.suit) .. ")"}
            tooltip:createLabel{text = card.getCardTypeText(ref.type).name}
        end
    end)

    return image
end

---@param parent tes3uiElement
---@return tes3uiElement
local function PutDeck(parent)
    local asset = card.getCardBackAsset()

    -- todo child for flipping
    local image = parent:createImage({ path = asset.path })
    -- image.ignoreLayoutX = true
    -- image.ignoreLayoutY = true
    -- image.positionX = 10
    -- image.positionY = 10
    image.width = card.getCardWidth()
    image.height = card.getCardHeight()
    image.scaleMode = true
    image.consumeMouseEvents = true
    image.borderAllSides = 2
    --image:createLabel({text= "Deck!"})
    image:register(tes3.uiEvent.help,
    ---@param e uiEventEventData
    function(e)
        local tooltip = tes3ui.createTooltipMenu()
        tooltip:createLabel{text = "Remain: " .. tostring(#deck)}
    end)
    -- todo split view and control
    image:register(tes3.uiEvent.mouseOver,
    ---@param e uiEventEventData
    function(e)
    end)
    image:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)

        local cardId = card.dealCard(deck)
        local menu = tes3ui.findMenu(uiid.gameMenu)
        local pile = menu:findChild(uiid.boardPile)
        PutCard(pile, cardId, false)
        menu:updateLayout()

    end)
    return image
end

--- in card gamae, player means each 'player'
--- but in this video game, player is you.

---@param parent tes3uiElement
---@param id number
---@param type CardType
---@return tes3uiElement
local function CreateTypeArea(parent, id, type)
    local area = parent:createRect({ id = id, color = card.getCardTypeColor(type) })
    area.widthProportional = 1
    area.heightProportional = 1
    area.flowDirection = tes3.flowDirection.leftToRight
    area.alpha = 0.25
    area.paddingAllSides = 2
    area.minHeight = card.getCardHeight()
    return area
end

---@param parent tes3uiElement
---@return tes3uiElement
local function CreateFrame(parent)
    local frame = parent:createThinBorder()
    frame.widthProportional = 1
    frame.heightProportional = 1
    frame.flowDirection = tes3.flowDirection.leftToRight
    frame.paddingAllSides = 2
    return frame
end

---@param parent tes3uiElement
---@return PlayerView
local function CreateOpponentArea(parent)
    local opponent = parent:createBlock()
    opponent.widthProportional = 1
    opponent.heightProportional = 1
    opponent.flowDirection = tes3.flowDirection.topToBottom
    local hand = opponent:createBlock({ id = uiid.opponentHand })
    hand.widthProportional = 1
    hand.heightProportional = 1
    hand.flowDirection = tes3.flowDirection.leftToRight
    hand.paddingAllSides = 2
    hand.childAlignX = 0.5
    hand.minHeight = card.getCardHeight()
    hand.childAlignY =1.0
    local captured = opponent:createBlock()
    captured.widthProportional = 1
    captured.heightProportional = 1
    captured.flowDirection = tes3.flowDirection.topToBottom
    local row0 = captured:createBlock()
    row0.widthProportional = 1
    row0.heightProportional = 1
    row0.flowDirection = tes3.flowDirection.leftToRight
    local bright = CreateTypeArea(CreateFrame(row0), uiid.opponentBright, card.type.bright)
    local animal = CreateTypeArea(CreateFrame(row0), uiid.opponentAnimal, card.type.animal)
    local row1 = captured:createBlock()
    row1.widthProportional = 1
    row1.heightProportional = 1
    row1.flowDirection = tes3.flowDirection.leftToRight
    local ribbon = CreateTypeArea(CreateFrame(row1), uiid.opponentRibbon, card.type.ribbon)
    local chaff = CreateTypeArea(CreateFrame(row1), uiid.opponentChaff, card.type.chaff)
    bright.childAlignY =1.0
    animal.childAlignY =1.0
    ribbon.childAlignY =1.0
    chaff.childAlignY =1.0

    return {hand = hand, bright = bright , animal = animal, ribbon = ribbon, chaff = chaff }
end

---@param parent tes3uiElement
---@return PlayerView
local function CreatePlayerArea(parent)
    local player = parent:createBlock()
    player.widthProportional = 1
    player.heightProportional = 1
    player.flowDirection = tes3.flowDirection.topToBottom
    local captured = player:createBlock()
    captured.widthProportional = 1
    captured.heightProportional = 1
    captured.flowDirection = tes3.flowDirection.topToBottom
    local row0 = captured:createBlock()
    row0.widthProportional = 1
    row0.heightProportional = 1
    row0.flowDirection = tes3.flowDirection.leftToRight
    local bright = CreateTypeArea(CreateFrame(row0), uiid.playerBright, card.type.bright)
    local animal = CreateTypeArea(CreateFrame(row0), uiid.playerAnimal, card.type.animal)
    local row1 = captured:createBlock()
    row1.widthProportional = 1
    row1.heightProportional = 1
    row1.flowDirection = tes3.flowDirection.leftToRight
    local ribbon = CreateTypeArea(CreateFrame(row1), uiid.playerRibbon, card.type.ribbon)
    local chaff = CreateTypeArea(CreateFrame(row1), uiid.playerChaff, card.type.chaff)
    local hand = player:createBlock({ id = uiid.playerHand })
    hand.widthProportional = 1
    hand.heightProportional = 1
    hand.flowDirection = tes3.flowDirection.leftToRight
    hand.paddingAllSides = 2
    hand.childAlignX = 0.5
    hand.minHeight = card.getCardHeight()
    return {hand = hand, bright = bright, animal = animal, ribbon = ribbon, chaff = chaff }
end


---@param parent tes3uiElement
---@return GroundView
local function CreateBoard(parent)
    local area = parent:createBlock()
    area.widthProportional = 1
    area.heightProportional = 1
    area.flowDirection = tes3.flowDirection.leftToRight

    local pile = area:createThinBorder({id = uiid.boardPile })
    -- for placement dealing card or vertical placement
    pile.minWidth = card.getCardWidth()
    pile.minHeight = card.getCardHeight() * 2
    pile.width = card.getCardWidth()
    pile.height = card.getCardHeight() * 2
    pile.heightProportional = 1
    pile.flowDirection = tes3.flowDirection.topToBottom
    pile.paddingAllSides = 2

    local ground = area:createThinBorder({id = uiid.boardGround })
    ground.widthProportional = 1
    ground.heightProportional = 1
    ground.flowDirection = tes3.flowDirection.leftToRight
    ground.paddingAllSides = 2
    ground.childAlignX = 0.5
    ground.minHeight = card.getCardHeight() * 2

    return { pile = pile, ground = ground }
end

---@param id number|string
local function OpenGameMenu(id)

    local viewportWidth, viewportHeight = tes3ui.getViewportSize()

    local menu = tes3ui.createMenu({ id = id, fixedFrame = true })
    menu:destroyChildren()
    --menu.disabled = true
    menu.absolutePosAlignX = 0.5
	menu.absolutePosAlignY = 0.5
    menu.borderAllSides = 0
    menu.paddingAllSides = 2
    menu.color = { 0.1, 0.1, 0.1 }
    menu.alpha = 0.7
    menu.autoWidth = false
    menu.autoHeight = false
    menu.minWidth = viewportWidth / 2
    menu.minHeight = viewportHeight / 2
    menu.width = viewportWidth / 1.5
    menu.height = viewportHeight
    menu.maxWidth = viewportWidth
    menu.maxHeight = viewportHeight
    menu.positionX = -menu.width * 0.5 -- center
    menu.positionY = menu.height * 0.5 -- center
    menu.flowDirection = tes3.flowDirection.topToBottom
    local board = menu:createBlock()
    board.widthProportional = 1
    board.heightProportional = 1
    board.flowDirection = tes3.flowDirection.topToBottom
    opponentView = CreateOpponentArea(board)
    groundView = CreateBoard(board)
    playerView = CreatePlayerArea(board)

    menu:updateLayout()
    -- getting actual size

    for _, cardId in pairs(playerPool) do
        local image = PutCard(playerView.hand, cardId, false)
        playerCardView[cardId] = image

        image:register(tes3.uiEvent.mouseOver,
        ---@param e uiEventEventData
        function(e)
            for id, g in pairs(groundCardView) do
                if not CanMatch(cardId, id) then
                    g.alpha = 0.5
                end
            end
            menu:updateLayout()
        end)
        image:register(tes3.uiEvent.mouseLeave,
        ---@param e uiEventEventData
        function(e)
            for id, g in pairs(groundCardView) do
                g.alpha = 1.0
            end
            menu:updateLayout()
        end)


        image:register(tes3.uiEvent.mouseClick,
        ---@param e uiEventEventData
        function(e)
            -- callback(e, cardId)
            if selectedCard == cardId then
                selectedCard = nil
                logger:debug("Deselect")
                tes3.messageBox("Deselect")
            else
                selectedCard = cardId
                logger:debug("Select " .. tostring(selectedCard))
                tes3.messageBox("Select " .. tostring(selectedCard))
            end
        end)
    end
    for _, cardId in pairs(groundPool) do
        local image = PutCard(groundView.ground, cardId, false)
        groundCardView[cardId] = image

        image:register(tes3.uiEvent.mouseOver,
        ---@param e uiEventEventData
        function(e)
            for cid, c in pairs(playerCardView) do
                if not CanMatch(cardId, cid) then
                    c.color = {0.5, 0.5, 0.5}
                    c.alpha = 0.5
                end
            end
            menu:updateLayout()
        end)
        image:register(tes3.uiEvent.mouseLeave,
        ---@param e uiEventEventData
        function(e)
            for _, c in pairs(playerCardView) do
                c.color = {1, 1, 1}
                c.alpha = 1.0
        end
            menu:updateLayout()
        end)
    end
    for _, cardId in pairs(opponentPool) do
        local image = PutCard(opponentView.hand, cardId, true)
        opponentCardView[cardId] = image
    end
    PutDeck(groundView.pile)

    groundView.ground:register(tes3.uiEvent.mouseOver,
    ---@param e uiEventEventData
    function(e)
        -- callback(e, cardId)
        if selectedCard then
            logger:debug("Discard?")
        end
    end)
    groundView.ground:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- callback(e, cardId)
        if selectedCard then
            logger:debug("Discard")
        end
    end)

    menu:updateLayout()
    return menu
end


---@param element tes3uiElement
local function CloseGameMenu(element)
    playerPool = {}
    opponentPool = {}
    groundPool = {}
    opponentView = {}
    groundView = {}
    playerView = {}
    opponentCardView = {}
    groundCardView = {}
    playerCardView = {}
    element:destroy()
end

-- tes3ui.showMessageMenu{
--     id = "confirmyaku",
--     header = "Koi-koi or Shobu",
--     message = "show yaku",
--     buttons = {
--         -- tooltips
--         { text = "Shobu", callback = function() end },
--         { text = "Koi-koi", callback = function() end }
--     }
-- }


---@param _ initializedEventData
local function OnInitialized(_)
    dofile("Hanafuda/mcm.lua")

    event.register(tes3.event.keyDown,
    function(e)
        local mod = e.isAltDown or e.isControlDown or e.isShiftDown or e.isSuperDown
        if mod then
            return
        end
        local menu = tes3ui.findMenu(uiid.gameMenu)
        if menu then
            CloseGameMenu(menu)
        else
            menu = OpenGameMenu(uiid.gameMenu)
            tes3ui.enterMenuMode(menu.id)
        end

    end, {filter = tes3.scanCode.k} )

end
event.register(tes3.event.initialized, OnInitialized)
