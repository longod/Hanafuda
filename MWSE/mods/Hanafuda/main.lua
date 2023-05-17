dofile("Hanafuda/test.lua")

local logger = require("Hanafuda.logger")
local card = require("Hanafuda.card")
local uiid = require("Hanafuda.uiid")
local view = require("Hanafuda.KoiKoi.view")

local runner = require("Hanafuda.KoiKoi.runner").new(
    require("Hanafuda.KoiKoi.simplismBrain").new(),
    require("Hanafuda.KoiKoi.simplismBrain").new()
)
while runner:Run() do
end

--[[
local game = require("Hanafuda.KoiKoi.game").new()
local brain = require("Hanafuda.KoiKoi.simplismBrain").new()
game:SetBrains(brain)
game:SetBrains(brain, true) -- player
game:Initialize()
game:DecideParent()
game:DealInitialCards()
-- check lucky hand
-- do each turn
local com = game:Simulate(game.current)
if com then
    -- todo com:Execute()
    if com.selectedCard and com.matchedCard then
        -- match
        game:Capture(game.current, com.selectedCard)
        game:Capture(game.current, com.matchedCard)

    elseif not com.matchedCard then
        -- discard
        game:Discard(game.current, com.selectedCard)

    else
        -- skip
    end
end
if game:CheckCombination(game.current) then
    local com2 = game:Call(game.current)
end
com = game:Simulate(game.current, card.DealCard(game.deck))
game:CheckCombination(game.current)
game:SwapPlayer()
game:Simulate(game.current)
game:CheckCombination(game.current)
game:Simulate(game.current, card.DealCard(game.deck))
game:CheckCombination(game.current)
game:CheckEnd()
game:SwapPlayer()
]]--




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
local selectedCard = nil ---@type integer?
local gameState = 0

local deck = card.CreateDeck()
deck = card.ShuffleDeck(deck)

while not (#playerPool >= initialPlayerCards and #opponentPool >= initialPlayerCards and #groundPool >= initialPlaygroundCards) do
    -- todo check count
    for i = 1, initialDealEach do
        table.insert(playerPool, card.DealCard(deck))
    end
    for i = 1, initialDealEach do
        table.insert(groundPool, card.DealCard(deck))
    end
    for i = 1, initialDealEach do
        table.insert(opponentPool, card.DealCard(deck))
    end
end

local function Validate()
    -- no duplicated
    -- same pool and view
end


---@param cardId0 integer
---@param cardId1 integer
---@return boolean
local function CanMatch(cardId0, cardId1)
    return card.CanMatchSuit(cardId0, cardId1)
end


---@param parent tes3uiElement
---@param cardId integer
---@param backface boolean
---@return tes3uiElement
local function PutCard(parent, cardId, backface)
    local asset = backface and card.GetCardBackAsset() or card.GetCardAsset(cardId)

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
    -- if not image.widget then
    --     image.widget = {}
    -- end
    -- image.widget.cardId = cardId -- i want to embeded...
    image:register(tes3.uiEvent.help,
    ---@param e uiEventEventData
    function(e)
        view.CreateCardTooltip(cardId, backface)
    end)

    return image
end

---@param parent tes3uiElement
---@return tes3uiElement
local function PutDeck(parent)
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
    --image:createLabel({text= "Deck!"})
    image:register(tes3.uiEvent.help,
    ---@param e uiEventEventData
    function(e)
        view.CreateDeckTooltip(deck)
    end)
    -- todo split view and control
    image:register(tes3.uiEvent.mouseOver,
    ---@param e uiEventEventData
    function(e)
    end)
    image:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)

        local cardId = card.DealCard(deck)
        assert(cardId)
        local menu = tes3ui.findMenu(uiid.gameMenu)
        assert(menu)
        local pile = menu:findChild(uiid.boardPile)
        local image = PutCard(pile, cardId, false)
        menu:updateLayout()

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
            if not selectedCard then
                selectedCard = cardId
                logger:debug("Pick " .. tostring(selectedCard))
                tes3.messageBox("Pick " .. card.GetCardText(selectedCard).name)
                local overlay = tes3ui.findHelpLayerMenu(uiid.overlayMenu)
                overlay.disabled = false
                overlay.visible = true
                -- need to set initial position?
                local root = e.source:getTopLevelMenu()
                -- remove from view
                --e.source:move({ to = groundView.ground}) -- safe?
                local to = e.source:move({ to = overlay}) -- safe?
                -- unregister events?
                overlay:updateLayout()
                --groundView.ground:getTopLevelMenu():updateLayout()
                root:updateLayout()
            end
        end)

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
    local area = parent:createRect({ id = id, color = card.GetCardTypeColor(type) })
    area.widthProportional = 1
    area.heightProportional = 1
    area.flowDirection = tes3.flowDirection.leftToRight
    area.alpha = 0.25
    area.paddingAllSides = 2
    area.minHeight = card.GetCardHeight()
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
    bright.childAlignY = 0.5
    animal.childAlignY = 0.5
    ribbon.childAlignY = 0.5
    chaff.childAlignY = 0.5

    local hand = opponent:createBlock({ id = uiid.opponentHand })
    hand.widthProportional = 1
    hand.heightProportional = 1
    hand.flowDirection = tes3.flowDirection.leftToRight
    hand.paddingAllSides = 2
    hand.childAlignX = 0.5
    hand.minHeight = card.GetCardHeight()
    hand.childAlignY = 1.0

    return {hand = hand, bright = bright , animal = animal, ribbon = ribbon, chaff = chaff }
end

---@param parent tes3uiElement
---@return PlayerView
local function CreatePlayerArea(parent)
    local player = parent:createBlock()
    player.widthProportional = 1
    player.heightProportional = 1
    player.flowDirection = tes3.flowDirection.topToBottom

    local hand = player:createBlock({ id = uiid.playerHand })
    hand.widthProportional = 1
    hand.heightProportional = 1
    hand.flowDirection = tes3.flowDirection.leftToRight
    hand.paddingAllSides = 2
    hand.childAlignX = 0.5
    hand.minHeight = card.GetCardHeight()

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
    bright.childAlignY = 0.5
    animal.childAlignY = 0.5
    ribbon.childAlignY = 0.5
    chaff.childAlignY = 0.5

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
    pile.minWidth = card.GetCardWidth() * 1.2
    pile.minHeight = card.GetCardHeight() * 2
    pile.width = card.GetCardWidth() * 1.2
    pile.height = card.GetCardHeight() * 2
    pile.heightProportional = 1
    pile.flowDirection = tes3.flowDirection.topToBottom
    pile.paddingAllSides = 2

    local ground = area:createThinBorder({id = uiid.boardGround })
    ground.widthProportional = 1
    ground.heightProportional = 1
    ground.flowDirection = tes3.flowDirection.leftToRight
    ground.paddingAllSides = 2
    ground.childAlignX = 0.5
    ground.minHeight = card.GetCardHeight() * 2

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
    menu.alpha = 0.0
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
    menu.flowDirection = tes3.flowDirection.leftToRight

    -- todo remake layout
    local info = menu:createBlock()
    info.autoWidth = true
    info.autoHeight = true
    info.minWidth = 128
    info.heightProportional = 1
    info.flowDirection = tes3.flowDirection.topToBottom
    local b = info:createBlock()
    b.autoWidth = true
    b.autoHeight = true
    b.flowDirection = tes3.flowDirection.topToBottom
    local button = b:createButton({ text = "Yield"}) -- image button?
    button.autoWidth = true
    button.autoHeight = true
    b = info:createBlock()
    b.widthProportional = 1
    b.autoHeight = true
    b.flowDirection = tes3.flowDirection.topToBottom
    b.childAlignX = 1
    local l = b:createLabel({ text = "Round: 12"})
    l.color = tes3ui.getPalette(tes3.palette.headerColor)
    l.autoWidth = true
    l.autoHeight = true
    b = info:createBlock()
    b.widthProportional = 1
    b.autoHeight = true
    b.flowDirection = tes3.flowDirection.topToBottom
    b.childAlignX = 0.5
    l = b:createLabel({ text = "Opponent Name" })
    l.color = tes3ui.getPalette(tes3.palette.headerColor)
    l.autoWidth = true
    l.autoHeight = true
    l.wrapText = true
    b = info:createBlock()
    b.widthProportional = 1
    b.autoHeight = true
    b.flowDirection = tes3.flowDirection.topToBottom
    b.childAlignX = 1
    l = b:createLabel({ text = "Score: 88" })
    l.autoWidth = true
    l.autoHeight = true
    -- todo show current yaku
    b = info:createBlock()
    b.widthProportional = 1
    b.autoHeight = true
    b.flowDirection = tes3.flowDirection.topToBottom
    b.childAlignX = 0.5
    l = b:createLabel({ text = "Your Name" })
    l.color = tes3ui.getPalette(tes3.palette.headerColor)
    l.autoWidth = true
    l.autoHeight = true
    l.wrapText = true
    b = info:createBlock()
    b.widthProportional = 1
    b.autoHeight = true
    b.flowDirection = tes3.flowDirection.topToBottom
    b.childAlignX = 1
    l = b:createLabel({ text = "Score: 77" })
    l.autoWidth = true
    l.autoHeight = true
    -- todo show current yaku


    local board = menu:createRect()
    board.color = { 0.1, 0.1, 0.1 }
    board.alpha = 0.5
    board.widthProportional = 1
    board.heightProportional = 1
    board.flowDirection = tes3.flowDirection.topToBottom
    opponentView = CreateOpponentArea(board)
    groundView = CreateBoard(board)
    playerView = CreatePlayerArea(board)

    menu:updateLayout()
    -- getting actual size

    local overlayMenu = tes3ui.createHelpLayerMenu({ id = uiid.overlayMenu, fixedFrame = true }) -- maybe fixedFrame not work
    overlayMenu:destroyChildren()
    overlayMenu.absolutePosAlignX = nil
    overlayMenu.absolutePosAlignY = nil
    overlayMenu.borderAllSides = 0
    overlayMenu.paddingAllSides = 0
    overlayMenu.autoWidth = true
    overlayMenu.autoHeight = true
    overlayMenu.disabled = true
    overlayMenu.visible = false
    overlayMenu:updateLayout()


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
            if not selectedCard then
                selectedCard = cardId
                logger:debug("Pick " .. tostring(selectedCard))
                tes3.messageBox("Pick " .. card.GetCardText(selectedCard).name)
                local overlay = tes3ui.findHelpLayerMenu(uiid.overlayMenu)
                overlay.disabled = false
                overlay.visible = true
                -- need to set initial position?
                local root = e.source:getTopLevelMenu()
                -- remove from view
                --e.source:move({ to = groundView.ground}) -- safe?
                local to = e.source:move({ to = overlay}) -- safe?
                -- unregister events?
                overlay:updateLayout()
                --groundView.ground:getTopLevelMenu():updateLayout()
                root:updateLayout()
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

        image:register(tes3.uiEvent.mouseClick,
        ---@param e uiEventEventData
        function(e)
            -- callback(e, cardId)
            if selectedCard and CanMatch(selectedCard, cardId) then
                logger:debug("Match " .. tostring(selectedCard) .. " and " .. tostring(cardId) )
                tes3.messageBox("Match " .. card.GetCardText(selectedCard).name .. " and " .. card.GetCardText(cardId).name )

                -- -- need to set initial position?
                -- local root = e.source:getTopLevelMenu()
                -- -- remove from view
                -- --e.source:move({ to = groundView.ground}) -- safe?
                -- local to = e.source:move({ to = overlay}) -- safe?
                -- -- unregister events?
                -- overlay:updateLayout()
                -- --groundView.ground:getTopLevelMenu():updateLayout()
                -- root:updateLayout()
                local overlay = tes3ui.findHelpLayerMenu(uiid.overlayMenu)
                overlay.disabled = true
                overlay.visible = false
                local root = e.source:getTopLevelMenu()

                local dest = {
                    [card.type.bright] = playerView.bright,
                    [card.type.animal] = playerView.animal,
                    [card.type.ribbon] = playerView.ribbon,
                    [card.type.chaff] = playerView.chaff,
                }

                local to0 = overlay.children[1]:move({ to = dest[card.GetCardData(selectedCard).type] })
                local to1 = e.source:move({ to = dest[card.GetCardData(cardId).type] })
                -- todo re-register events
                overlay:updateLayout()
                --groundView.ground:getTopLevelMenu():updateLayout()
                root:updateLayout()
                -- todo keep temporary
                -- local result = table.removevalue(playerPool, selectedCard)
                -- assert(result)
                -- table.insert(groundPool, selectedCard)
                -- todo directory move to captured
                selectedCard = nil
            end
        end)
    end
    for _, cardId in pairs(opponentPool) do
        local image = PutCard(opponentView.hand, cardId, true)
        opponentCardView[cardId] = image
    end
    PutDeck(groundView.pile)

    playerView.hand:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        if selectedCard then
                logger:debug("Put " .. tostring(selectedCard))
                tes3.messageBox("Put " .. card.GetCardText(selectedCard).name)
            selectedCard = nil

            local overlay = tes3ui.findHelpLayerMenu(uiid.overlayMenu)
            overlay.disabled = true
            overlay.visible = false
            local root = e.source:getTopLevelMenu()
            local to = overlay.children[1]:move({ to = e.source}) -- safe?
            -- unregister events?
            overlay:updateLayout()
            --groundView.ground:getTopLevelMenu():updateLayout()
            root:updateLayout()

        end
    end)

    groundView.ground:register(tes3.uiEvent.mouseOver,
    ---@param e uiEventEventData
    function(e)
        -- callback(e, cardId)
        if selectedCard then
            logger:debug("Discard?")
            -- todo checking
        end
    end)
    groundView.ground:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- callback(e, cardId)
        if selectedCard then
            local canDiscard = true
            for _, cardId in pairs(groundPool) do
                if CanMatch(selectedCard, cardId) then
                    canDiscard = false
                    break
                end
            end
            if canDiscard then
                logger:debug("Discard " .. tostring(selectedCard))
                tes3.messageBox("Discard " .. card.GetCardText(selectedCard).name)

                local overlay = tes3ui.findHelpLayerMenu(uiid.overlayMenu)
                overlay.disabled = true
                overlay.visible = false
                local root = e.source:getTopLevelMenu()
                local to = overlay.children[1]:move({ to = e.source })
                -- todo re-register events
                overlay:updateLayout()
                --groundView.ground:getTopLevelMenu():updateLayout()
                root:updateLayout()
                -- todo move from pool
                local result = table.removevalue(playerPool, selectedCard)
                assert(result)
                table.insert(groundPool, selectedCard)
                selectedCard = nil
            else
                logger:debug(tostring(selectedCard) .. " can be matched")
                tes3.messageBox(card.GetCardText(selectedCard).name .. " can be matched")
            end
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
    local overlayMenu = tes3ui.findHelpLayerMenu(uiid.overlayMenu)
    if overlayMenu then
        overlayMenu:destroy()
    end
end

---@param _ initializedEventData
local function OnInitialized(_)
    dofile("Hanafuda/mcm.lua")

    --[[
    event.register(tes3.event.keyDown,
    ---@param e keyDownEventData
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

    event.register(tes3.event.enterFrame,
    ---@param e enterFrameEventData
    function(e)
        local overlayMenu = tes3ui.findHelpLayerMenu(uiid.overlayMenu)
        if overlayMenu and overlayMenu.visible and not overlayMenu.disabled then
            local cursor = tes3.getCursorPosition() -- coordinate is same as ui
            -- need offset by clicking position
            --overlayMenu:updateLayout()
            overlayMenu.positionX = cursor.x - overlayMenu.width * 0.5
            overlayMenu.positionY = cursor.y + overlayMenu.height * 0.5
            overlayMenu:updateLayout()
        end

    end)
    ]]--

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
                require("Hanafuda.KoiKoi.view").new()
            )
            service:Initialize()
        end
    end, {filter = tes3.scanCode.k} )
end
event.register(tes3.event.initialized, OnInitialized)
