-- Regardless of the view representation format, this handles UI that can be used in common.
local this = {}

local uiid = require("Hanafuda.uiid")
local card = require("Hanafuda.card")
local logger = require("Hanafuda.logger")
local koi = require("Hanafuda.KoiKoi.koikoi")
local i18n = mwse.loadTranslations("Hanafuda")

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
---@param maxWidth integer?
---@param cardScale number?
---@return tes3uiElement
function this.CreateCombinationView(parent, combination, actualPoint, maxWidth, cardScale)
    --local indent = 0
    --local headerColor = tes3ui.getPalette(tes3.palette.headerColor)
    local block = parent:createBlock()
    block.flowDirection = tes3.flowDirection.topToBottom
    block.widthProportional = 1
    block.autoWidth = true
    block.autoHeight = true
    --block.borderAllSides = 8
    block.paddingAllSides = 0
    block.paddingLeft = 8
    block.paddingRight = 8
    if maxWidth then
        block.maxWidth = maxWidth
    end
    local scale = cardScale or 0.75

    ---@param cardIds integer[]
    local listup = function(cardIds)
        local pattern = block:createBlock()
        pattern.autoWidth = true
        pattern.autoHeight = true
        pattern.flowDirection = tes3.flowDirection.leftToRight
        -- pattern.borderAllSides = 0
        -- pattern.borderLeft = indent * 2

        for index, cardId in ipairs(cardIds) do
            local asset = card.GetCardAsset(cardId)
            local ref = card.GetCardData(cardId)
            local b = pattern:createBlock()
            --b.borderAllSides = 0
            b.autoWidth = true
            b.autoHeight = true
            b.flowDirection = tes3.flowDirection.topToBottom
            b.childAlignX = 0.5
            local image = b:createImage({ path = asset.path })
            image.width = card.GetCardWidth() * scale
            image.height = card.GetCardHeight() * scale
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
            type = card.type.bright,
            point = string.format("%u points.", koi.basePoint[koi.combination.fiveBrights]),
            condition = string.format("All 5 %s cards.", card.GetCardTypeText(card.type.bright).name),
        },
        [koi.combination.fourBrights] = {
            name = "Shiko",
            type = card.type.bright,
            point = string.format("%u points.", koi.basePoint[koi.combination.fourBrights]),
            condition = string.format("All 4 %s cards without %s.", card.GetCardTypeText(card.type.bright).name, card.GetCardText(rainman).name),
        },
        [koi.combination.rainyFourBrights] = {
            name = "Ame-Shiko",
            type = card.type.bright,
            point = string.format("%u points.", koi.basePoint[koi.combination.rainyFourBrights]),
            condition = string.format("Any 4 %s cards.", card.GetCardTypeText(card.type.bright).name),
        },
        [koi.combination.threeBrights] = {
            name = "Sanko",
            type = card.type.bright,
            point = string.format("%u points.", koi.basePoint[koi.combination.threeBrights]),
            condition = string.format("Any 3 %s cards.", card.GetCardTypeText(card.type.bright).name),
        },
        [koi.combination.boarDeerButterfly] = {
            name = "Ino-Shika-Cho",
            type = card.type.animal,
            point = string.format("%u points.", koi.basePoint[koi.combination.boarDeerButterfly]),
            condition = string.format("%s, %s and %s", card.GetCardText(boar).name, card.GetCardText(deer).name, card.GetCardText(butterfly).name),
        },
        [koi.combination.animals] = {
            name = "Tane",
            type = card.type.animal,
            point = string.format("%u points and 1 additional point for each additional %s card.", koi.basePoint[koi.combination.animals], card.GetCardTypeText(card.type.animal).name),
            condition = string.format("Any five %s cards.", card.GetCardTypeText(card.type.animal).name),
        },
        [koi.combination.poetryAndBlueRibbons] = {
            name = "Akatan-Aotan",
            type = card.type.ribbon,
            point = string.format("%u points and 1 additional point for each additional %s card.", koi.basePoint[koi.combination.poetryAndBlueRibbons], card.GetCardTypeText(card.type.ribbon).name),
            condition = string.format("All 3 Red Poetry %s cards and all 3 Blue %s cards.", card.GetCardTypeText(card.type.ribbon).name, card.GetCardTypeText(card.type.ribbon).name),
        },
        [koi.combination.poetryRibbons] = {
            name = "Akatan",
            type = card.type.ribbon,
            point = string.format("%u points and 1 additional point for each additional %s card.", koi.basePoint[koi.combination.poetryRibbons], card.GetCardTypeText(card.type.ribbon).name),
            condition = string.format("%s, %s and %s", card.GetCardText(redPoetry[1]).name, card.GetCardText(redPoetry[2]).name, card.GetCardText(redPoetry[3]).name),
        },
        [koi.combination.blueRibbons] = {
            name = "Aotan",
            type = card.type.ribbon,
            point = string.format("%u points and 1 additional point for each additional %s card.", koi.basePoint[koi.combination.blueRibbons], card.GetCardTypeText(card.type.ribbon).name),
            condition = string.format("%s, %s and %s", card.GetCardText(blueRibbon[1]).name, card.GetCardText(blueRibbon[2]).name, card.GetCardText(blueRibbon[3]).name),
        },
        [koi.combination.ribbons] = {
            name = "Tan",
            type = card.type.ribbon,
            point = string.format("%u points and 1 additional point for each additional %s card.", koi.basePoint[koi.combination.ribbons], card.GetCardTypeText(card.type.ribbon).name),
            condition = string.format("Any 5 %s cards.", card.GetCardTypeText(card.type.ribbon).name),
        },
        [koi.combination.flowerViewingSake] = {
            name = "Hanami de Ippai",
            type = card.type.chaff, -- no chaff but no suitable type
            point = string.format("%u points.", koi.basePoint[koi.combination.flowerViewingSake]),
            condition = string.format("%s and %s.", card.GetCardText(curtain).name, card.GetCardText(sakeCup).name),
        },
        [koi.combination.moonViewingSake] = {
            name = "Tsukimi de Ippai",
            type = card.type.chaff, -- no chaff but no suitable type
            point = string.format("%u points.", koi.basePoint[koi.combination.moonViewingSake]),
            condition = string.format("%s and %s.", card.GetCardText(moon).name, card.GetCardText(sakeCup).name),
        },
        [koi.combination.chaff] = {
            name = "Kasu",
            type = card.type.chaff,
            point = string.format("%u points and 1 additional point for each additional %s card.", koi.basePoint[koi.combination.chaff], card.GetCardTypeText(card.type.chaff).name),
            condition = string.format("Any 10 %s cards.", card.GetCardTypeText(card.type.chaff).name),
        },
    }
    local combo = {
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

    if combo[combination] and desc[combination] then
        local d = desc[combination]

        local head = block:createBlock()
        head.widthProportional = 1
        head.autoHeight = true
        local name = head:createLabel({ text = d.name})
        name.color = card.GetCardTypeColor(d.type)
        --name.borderLeft = indent
        local right = head:createBlock()
        right.widthProportional = 1
        right.autoHeight = true
        right.childAlignX = 1

        if actualPoint then
            local point = right:createLabel({ text = string.format("%u points", actualPoint) })
            --point.borderRight = indent * 2
            --point.wrapText = true
        else
            local point = block:createLabel({ text = d.point })
            --point.borderLeft = indent * 2
            point.wrapText = true
        end

        local condition = block:createLabel({ text = d.condition })
        --condition.borderLeft = indent * 2
        condition.wrapText = true

        combo[combination]()
    else
        logger:error("unknown combination %u", combination)
    end
    return block
end

---@param e uiEventEventData
function this.CreateCombinationList(e)
    local menu = tes3ui.findMenu(uiid.helpComboMenu)
    if menu then
        -- can be forecround focusing?
        return
    end

    local viewportWidth, viewportHeight = tes3ui.getViewportSize()
    local size = math.min(viewportWidth, viewportHeight)

    logger:debug("combo help")
    menu = tes3ui.createMenu({ id = uiid.helpComboMenu, fixedFrame = true })
    menu.width = size * 0.75
    menu.height = size * 0.75
    menu.autoWidth = false
    menu.autoHeight = false
    menu.flowDirection = tes3.flowDirection.topToBottom

    local root = menu:createBlock()
    root.widthProportional = 1
    root.heightProportional = 1
    root.flowDirection = tes3.flowDirection.topToBottom

    local pane = root:createVerticalScrollPane()
    pane.widthProportional = 1
    pane.heightProportional = 1
    local parent = pane:getContentElement()
    for _, value in ipairs(table.values(koi.combination, true)) do
        this.CreateCombinationView(parent, value)
        parent:createDivider().widthProportional = 1.0
    end
    local bottom = root:createBlock()
    bottom.widthProportional = 1
    bottom.autoHeight = true
    bottom.flowDirection = tes3.flowDirection.leftToRight
    bottom.childAlignX = 1
    local close = bottom:createButton({ text = tes3.findGMST(tes3.gmst.sClose).value --[[@as string]] })
    close:register(tes3.uiEvent.mouseClick,
        ---@param ev uiEventEventData
        function(ev)
            ev.source:getTopLevelMenu():destroy()
        end)

    menu:updateLayout()
    pane.widget:contentsChanged() ---@diagnostic disable-line: param-type-mismatch
end

---@param e uiEventEventData
function this.CreateRule(e)
    local menu = tes3ui.findMenu(uiid.helpRuleMenu)
    if menu then
        -- can be forecround focusing?
        return
    end

    local viewportWidth, viewportHeight = tes3ui.getViewportSize()
    local size = math.min(viewportWidth, viewportHeight)

    logger:debug("rule help")
    local menu = tes3ui.createMenu({ id = uiid.helpRuleMenu, fixedFrame = true })
    menu.width = size * 0.75
    menu.height = size * 0.75
    menu.autoWidth = false
    menu.autoHeight = false
    menu.flowDirection = tes3.flowDirection.topToBottom

    local root = menu:createBlock()
    root.widthProportional = 1
    root.heightProportional = 1
    root.flowDirection = tes3.flowDirection.topToBottom

    local pane = root:createVerticalScrollPane()
    pane.widthProportional = 1
    pane.heightProportional = 1
    local parent = pane:getContentElement()

    parent:createHyperlink({ text = "Fuda Wiki", url = "https://fudawiki.org/en/hanafuda/games/koi-koi"})
    parent:createLabel({ text = "simple rule here"})

    local bottom = root:createBlock()
    bottom.widthProportional = 1
    bottom.autoHeight = true
    bottom.flowDirection = tes3.flowDirection.leftToRight
    bottom.childAlignX = 1
    local close = bottom:createButton({ text = tes3.findGMST(tes3.gmst.sClose).value --[[@as string]] })
    close:register(tes3.uiEvent.mouseClick,
        ---@param ev uiEventEventData
        function(ev)
            ev.source:getTopLevelMenu():destroy()
        end)

    menu:updateLayout()
    pane.widget:contentsChanged() ---@diagnostic disable-line: param-type-mismatch

end

---@param cardId integer
---@param backface boolean
---@return tes3uiElement?
function this.CreateCardTooltip(cardId, backface)
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
        --[[
        tooltip:createDivider().widthProportional = 0.8
        local desc = tooltip:createBlock()
        desc.minWidth = thumb.width
        desc.maxWidth = thumb.width * 1.5
        desc.autoWidth = true
        desc.autoHeight = true
        local flavor = desc:createLabel({text = "flavor text here"})
        flavor.wrapText = true
        ]]
    end
    return tooltip
end

---@param deck integer[]
---@return tes3uiElement tooltip
function this.CreateDeckTooltip(deck)
    local tooltip = tes3ui.createTooltipMenu()
    local label = tooltip:createLabel({ text = tostring(table.size(deck)) .. " cards remaining" })
    label.color = tes3ui.getPalette(tes3.palette.headerColor)
    return tooltip
end

return this
