local uiid = require("Hanafuda.uiid")
local card = require("Hanafuda.card")
local logger = require("Hanafuda.logger")
local koi = require("Hanafuda.KoiKoi.koikoi")
local i18n = mwse.loadTranslations("Hanafuda")

---@class PlayerView
---@field hand tes3uiElement
---@field [CardType] tes3uiElement

---@class GroundView
---@field pile tes3uiElement
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
    tes3ui.showMessageMenu({
        id = "DecideParent",
        header = "Decide Parent",
        message = "Choose one of two cards.",
        buttons = {
            {
                text = "Left",
                callback = function()
                    -- todo
                    logger:debug("choose left")
                    service:DecideParent(false)
                end
            },
            {
                text = "Right",
                callback = function()
                    -- todo
                    logger:debug("choose right")
                    service:DecideParent(true)
                end
            },
        }
    })
end

---@param self KoiKoi.UI
---@param player KoiKoi.Player
function UI.InformParent(self, player)
    if player == koi.player.you then
        tes3.messageBox("Parent is you")
    elseif player == koi.player.opponent then
        tes3.messageBox("Parent is opponent")
    else
        assert()
    end
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
local function CreateYourArea(parent)
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

    return {
        hand = hand,
        [card.type.bright] = bright,
        [card.type.animal] = animal,
        [card.type.ribbon] = ribbon,
        [card.type.chaff] = chaff,
    }
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

    return {
        hand = hand,
        [card.type.bright] = bright,
        [card.type.animal] = animal,
        [card.type.ribbon] = ribbon,
        [card.type.chaff] = chaff,
    }
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
function UI.OpenGameMenu(self, id)

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
    self.playerViews = {}
    self.playerViews[koi.player.opponent] = CreateOpponentArea(board)
    self.groundView = CreateBoard(board)
    self.playerViews[koi.player.you] = CreateYourArea(board)

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


    menu:updateLayout()
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
