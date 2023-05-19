local uiid = require("Hanafuda.uiid")
local card = require("Hanafuda.card")
local logger = require("Hanafuda.logger")
local koi = require("Hanafuda.KoiKoi.koikoi")
local i18n = mwse.loadTranslations("Hanafuda")

-- with mergin
local cardLayoutWidth = card.GetCardWidth() + 4
local cardLayoutHeight = card.GetCardHeight() + 4

---@class PlayerView
---@field hand tes3uiElement
---@field [CardType] tes3uiElement

---@class GroundView
---@field pile tes3uiElement
---@field drawn tes3uiElement
---@field ground tes3uiElement

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
                    -- todo
                end
            },
            {
                text = "Shobu",
                callback = function()
                    -- todo
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
        UI.CreateCardTooltip(cardId, backface)
    end)

    return image
end

---@param self KoiKoi.UI
---@param parent KoiKoi.Player
---@param pools KoiKoi.PlayerPool[]
---@param groundPools integer[]
function UI.DealInitialCards(self, parent, pools, groundPools)
    -- animation with coroutine or timer?
    local back = parent ~= koi.player.you
    local child = koi.GetOpponent(parent)
    local view = self.playerViews[child].hand
    for _, cardId in ipairs(pools[child].hand) do
        local e = PutCard(view, cardId, not back)
        -- todo callbacks
    end

    for _, cardId in ipairs(groundPools) do
        local e = PutCard(self.groundView.ground, cardId, false)
    end

    view = self.playerViews[parent].hand
    for _, cardId in ipairs(pools[parent].hand) do
        local e = PutCard(view, cardId, back)
    end

    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)
    gameMenu:updateLayout()
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
        name.color = card.GetCardTypeColor(ref.type)
        tooltip:createLabel({ text = card.GetCardSuitText(ref.suit).name .. " (" .. tostring(ref.suit) .. ")" })
        tooltip:createLabel({ text = card.GetCardTypeText(ref.type).name })
        -- todo add flavor text
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

---@param id number|string
function UI.OpenGameMenu(self, id)

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

    menu:updateLayout()
    -- getting actual size

    -- present card dragging
    local overlayMenu = tes3ui.createHelpLayerMenu({ id = uiid.overlayMenu }) -- maybe fixedFrame not work
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

    return menu
end



function UI.Initialize(self)
    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(not gameMenu)
    gameMenu = self:OpenGameMenu(uiid.gameMenu)
    tes3ui.enterMenuMode(gameMenu.id)
end

function UI.Shutdown(self)
    local overlayMenu = tes3ui.findHelpLayerMenu(uiid.overlayMenu)
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
