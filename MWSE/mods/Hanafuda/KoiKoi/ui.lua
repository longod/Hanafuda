-- Regardless of the view representation format, this handles UI that can be used in common.
local this = {}

local uiid = require("Hanafuda.uiid")
local card = require("Hanafuda.card")
local logger = require("Hanafuda.logger")
local koi = require("Hanafuda.KoiKoi.koikoi")
local i18n = mwse.loadTranslations("Hanafuda")

local headerColor = tes3ui.getPalette(tes3.palette.headerColor)

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
---@param summary boolean?
---@return tes3uiElement
function this.CreateCombinationView(parent, combination, actualPoint, maxWidth, cardScale, summary)
    --local indent = 0
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
            local b = pattern:createBlock()
            b.borderAllSides = 0
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
            b:register(tes3.uiEvent.help,
                function(_)
                    this.CreateCardTooltip(cardId, false)
                end)
        end
        return pattern
    end
    local desc = {
        [koi.combination.fiveBrights] = {
            name = i18n("koi.combo.fiveBrights.name"),
            type = card.type.bright,
            point = i18n("koi.combo.fiveBrights.point", { koi.basePoint[koi.combination.fiveBrights] }),
            condition = i18n("koi.combo.fiveBrights.condition", { card.GetCardTypeText(card.type.bright).name }),
        },
        [koi.combination.fourBrights] = {
            name = i18n("koi.combo.fourBrights.name"),
            type = card.type.bright,
            point = i18n("koi.combo.fourBrights.point", { koi.basePoint[koi.combination.fourBrights] }),
            condition = i18n("koi.combo.fourBrights.condition",
                { card.GetCardTypeText(card.type.bright).name, card.GetCardText(rainman).name }),
        },
        [koi.combination.rainyFourBrights] = {
            name = i18n("koi.combo.rainyFourBrights.name"),
            type = card.type.bright,
            point = i18n("koi.combo.rainyFourBrights.point", { koi.basePoint[koi.combination.rainyFourBrights] }),
            condition = i18n("koi.combo.rainyFourBrights.condition", { card.GetCardTypeText(card.type.bright).name }),
        },
        [koi.combination.threeBrights] = {
            name = i18n("koi.combo.threeBrights.name"),
            type = card.type.bright,
            point = i18n("koi.combo.threeBrights.point", { koi.basePoint[koi.combination.threeBrights] }),
            condition = i18n("koi.combo.threeBrights.condition", { card.GetCardTypeText(card.type.bright).name }),
        },
        [koi.combination.boarDeerButterfly] = {
            name = i18n("koi.combo.boarDeerButterfly.name"),
            type = card.type.animal,
            point = i18n("koi.combo.boarDeerButterfly.point", { koi.basePoint[koi.combination.boarDeerButterfly] }),
            condition = i18n("koi.combo.boarDeerButterfly.condition",
                { card.GetCardText(boar).name, card.GetCardText(deer).name, card.GetCardText(butterfly).name }),
        },
        [koi.combination.animals] = {
            name = i18n("koi.combo.animals.name"),
            type = card.type.animal,
            point = i18n("koi.combo.animals.point",
                { koi.basePoint[koi.combination.animals], card.GetCardTypeText(card.type.animal).name }),
            condition = i18n("koi.combo.animals.condition", { card.GetCardTypeText(card.type.animal).name }),
        },
        [koi.combination.poetryAndBlueRibbons] = {
            name = i18n("koi.combo.poetryAndBlueRibbons.name"),
            type = card.type.ribbon,
            point = i18n("koi.combo.poetryAndBlueRibbons.point",
                { koi.basePoint[koi.combination.poetryAndBlueRibbons], card.GetCardTypeText(card.type.ribbon).name }),
            condition = i18n("koi.combo.poetryAndBlueRibbons.condition",
                { card.GetCardTypeText(card.type.ribbon).name, card.GetCardTypeText(card.type.ribbon).name }),
        },
        [koi.combination.poetryRibbons] = {
            name = i18n("koi.combo.poetryRibbons.name"),
            type = card.type.ribbon,
            point = i18n("koi.combo.poetryRibbons.point",
                { koi.basePoint[koi.combination.poetryRibbons], card.GetCardTypeText(card.type.ribbon).name }),
            condition = i18n("koi.combo.poetryRibbons.condition",
                { card.GetCardText(redPoetry[1]).name, card.GetCardText(redPoetry[2]).name,
                    card.GetCardText(redPoetry[3]).name }),
        },
        [koi.combination.blueRibbons] = {
            name = i18n("koi.combo.blueRibbons.name"),
            type = card.type.ribbon,
            point = i18n("koi.combo.blueRibbons.point",
                { koi.basePoint[koi.combination.blueRibbons], card.GetCardTypeText(card.type.ribbon).name }),
            condition = i18n("koi.combo.blueRibbons.condition",
                { card.GetCardText(blueRibbon[1]).name, card.GetCardText(blueRibbon[2]).name,
                    card.GetCardText(blueRibbon[3]).name }),
        },
        [koi.combination.ribbons] = {
            name = i18n("koi.combo.ribbons.name"),
            type = card.type.ribbon,
            point = i18n("koi.combo.ribbons.point",
                { koi.basePoint[koi.combination.ribbons], card.GetCardTypeText(card.type.ribbon).name }),
            condition = i18n("koi.combo.ribbons.condition", { card.GetCardTypeText(card.type.ribbon).name }),
        },
        [koi.combination.flowerViewingSake] = {
            name = i18n("koi.combo.flowerViewingSake.name"),
            type = card.type.chaff, -- no chaff but no suitable type
            point = i18n("koi.combo.flowerViewingSake.point", { koi.basePoint[koi.combination.flowerViewingSake] }),
            condition = i18n("koi.combo.flowerViewingSake.condition",
                { card.GetCardText(curtain).name, card.GetCardText(sakeCup).name }),
        },
        [koi.combination.moonViewingSake] = {
            name = i18n("koi.combo.moonViewingSake.name"),
            type = card.type.chaff, -- no chaff but no suitable type
            point = i18n("koi.combo.moonViewingSake.point", { koi.basePoint[koi.combination.moonViewingSake] }),
            condition = i18n("koi.combo.moonViewingSake.condition",
                { card.GetCardText(moon).name, card.GetCardText(sakeCup).name }),
        },
        [koi.combination.chaff] = {
            name = i18n("koi.combo.chaff.name"),
            type = card.type.chaff,
            point = i18n("koi.combo.chaff.point",
                { koi.basePoint[koi.combination.chaff], card.GetCardTypeText(card.type.chaff).name }),
            condition = i18n("koi.combo.chaff.condition", { card.GetCardTypeText(card.type.chaff).name }),
        },
    }
    local combo = {
        [koi.combination.fiveBrights] = function()
            local list = card.Find({ type = card.type.bright, findAll = true }) ---@cast list integer[]
            listup(list)
        end,
        [koi.combination.fourBrights] = function()
            local list = card.Find({ type = card.type.bright, findAll = true }) ---@cast list integer[]
            table.removevalue(list, rainman)
            listup(list)
        end,
        [koi.combination.rainyFourBrights] = function()
        end,
        [koi.combination.threeBrights] = function()
        end,
        [koi.combination.boarDeerButterfly] = function()
            local list = { boar, deer, butterfly }
            listup(list)
        end,
        [koi.combination.animals] = function()
        end,
        [koi.combination.poetryAndBlueRibbons] = function()
            local list = {}
            list = { redPoetry[1], redPoetry[2], redPoetry[3], blueRibbon[1], blueRibbon[2], blueRibbon[3] }
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
            local list = { curtain, sakeCup }
            listup(list)
        end,
        [koi.combination.moonViewingSake] = function()
            local list = { moon, sakeCup }
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
        local name = head:createLabel({ text = d.name })
        name.color = card.GetCardTypeColor(d.type)
        --name.borderLeft = indent
        local right = head:createBlock()
        right.widthProportional = 1
        right.autoHeight = true
        right.childAlignX = 1

        if actualPoint then
            local point = right:createLabel({ text = i18n("koi.point", { actualPoint }) })
            --point.borderRight = indent * 2
            --point.wrapText = true
        else
            local point = block:createLabel({ text = d.point })
            --point.borderLeft = indent * 2
            point.wrapText = true
        end

        if summary then
            -- not showing
        else
            local condition = block:createLabel({ text = d.condition })
            --condition.borderLeft = indent * 2
            condition.wrapText = true
            combo[combination]()
        end
    else
        logger:error("unknown combination %u", combination)
    end
    return block
end

---@param parent tes3uiElement
---@param luckyHands KoiKoi.LuckyHands
---@param actualPoint integer?
---@param maxWidth integer?
---@return tes3uiElement
function this.CreateLuckyHandsView(parent, luckyHands, actualPoint, maxWidth)
    --local indent = 0
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

    local desc = {
        [koi.luckyHands.fourOfAKind] = {
            name = i18n("koi.luckyHands.fourOfAKind.name"),
            point = i18n("koi.luckyHands.fourOfAKind.point", { koi.luckyHandsPoint[koi.luckyHands.fourOfAKind] }),
            condition = i18n("koi.luckyHands.fourOfAKind.condition"),
        },
        [koi.luckyHands.fourPairs] = {
            name = i18n("koi.luckyHands.fourPairs.name"),
            point = i18n("koi.luckyHands.fourPairs.point", { koi.luckyHandsPoint[koi.luckyHands.fourPairs] }),
            condition = i18n("koi.luckyHands.fourPairs.condition"),
        },
    }

    if desc[luckyHands] then
        local d = desc[luckyHands]

        local head = block:createBlock()
        head.widthProportional = 1
        head.autoHeight = true
        local name = head:createLabel({ text = d.name })
        name.color = headerColor
        --name.borderLeft = indent
        local right = head:createBlock()
        right.widthProportional = 1
        right.autoHeight = true
        right.childAlignX = 1

        if actualPoint then
            local point = right:createLabel({ text = i18n("koi.point", { actualPoint }) })
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
    else
        logger:error("unknown luckyhands %u", luckyHands)
    end
    return block
end

---@param e uiEventEventData
function this.CreateCardList(e)
    local menu = tes3ui.findMenu(uiid.helpCardListMenu)
    if menu then
        -- can be forecround focusing?
        return
    end

    local viewportWidth, viewportHeight = tes3ui.getViewportSize()
    local size = math.min(viewportWidth, viewportHeight)

    logger:debug("card help")
    menu = tes3ui.createMenu({ id = uiid.helpCardListMenu, fixedFrame = true })
    menu.width = size * 0.9
    menu.height = size * 0.9
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

    -- card table
    local scale = 1
    local padding = 4
    local minWidth = math.max(card.GetCardWidth() * scale + padding, 72)
    local suitWidth = math.max(card.GetCardWidth() * scale + padding, 128)
    local frame = parent
    -- local frame = parent:createThinBorder()
    -- frame.widthProportional = 1
    -- frame.autoWidth = true
    -- frame.autoHeight = true
    -- frame.flowDirection = tes3.flowDirection.topToBottom
    do
        local row = frame:createBlock()
        row.widthProportional = 1
        row.autoWidth = true
        row.autoHeight = true
        row.flowDirection = tes3.flowDirection.leftToRight
        row.paddingAllSides = 2
        do
            local col = row:createBlock()
            col.autoHeight = true
            col.minWidth = suitWidth
            col.width = suitWidth
        end
        for _, j in ipairs(table.values(card.type, true)) do
            local col = row:createBlock()
            col.autoHeight = true
            col.flowDirection = tes3.flowDirection.leftToRight
            col.minWidth = minWidth
            col.width = minWidth
            col:createLabel({ text = card.GetCardTypeText(j).name }).color = card.GetCardTypeColor(j)
        end
    end
    frame:createDivider().widthProportional = 1
    for _, i in ipairs(table.values(card.suit, true)) do
        local row = frame:createBlock()
        row.widthProportional = 1
        row.autoWidth = true
        row.autoHeight = true
        row.flowDirection = tes3.flowDirection.leftToRight
        row.paddingAllSides = 2
        do
            local col = row:createBlock()
            col.autoHeight = true
            col.minWidth = suitWidth
            col.width = suitWidth
            col.flowDirection = tes3.flowDirection.topToBottom
            -- not working...
            -- col.childAlignX = 1
            -- col.childAlignY = 0.5
            local text = card.GetCardSuitText(i)
            --col:createLabel({text = tostring(i) })
            local suit = col:createLabel({ text = text.name })
            suit.wrapText = true
            suit.color = headerColor
            if text.alt then
                local alt = col:createLabel({ text = text.alt })
                alt.wrapText = true
            end
        end

        for _, j in ipairs(table.values(card.type, true)) do
            local col = row:createBlock()
            col.autoWidth = true
            col.autoHeight = true
            col.minWidth = minWidth
            col.flowDirection = tes3.flowDirection.leftToRight
            local cards = card.Find({ suit = i, type = j, findAll = true }) --[[@as integer[]?]]
            if cards then
                for _, cardId in ipairs(cards) do
                    local asset = card.GetCardAsset(cardId)
                    local b = col:createBlock()
                    b.autoWidth = true
                    b.autoHeight = true
                    b.paddingAllSides = 0
                    b.paddingRight = padding
                    local image = b:createImage({ path = asset.path })
                    image.width = card.GetCardWidth() * scale
                    image.height = card.GetCardHeight() * scale
                    image.scaleMode = true
                    b:register(tes3.uiEvent.help,
                        function(_)
                            this.CreateCardTooltip(cardId, false)
                        end)
                end
            end
        end
        frame:createDivider().widthProportional = 1
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
function this.CreateCombinationList(e)
    local menu = tes3ui.findMenu(uiid.helpComboListMenu)
    if menu then
        -- can be forecround focusing?
        return
    end

    local viewportWidth, viewportHeight = tes3ui.getViewportSize()
    local size = math.min(viewportWidth, viewportHeight)

    logger:debug("combo help")
    menu = tes3ui.createMenu({ id = uiid.helpComboListMenu, fixedFrame = true })
    menu.width = size * 0.9
    menu.height = size * 0.9
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

    -- combo
    local parent = pane:getContentElement()
    local label = parent:createLabel({ text = i18n("koi.combinations.label") })
    label.color = headerColor
    label.borderAllSides = 0
    label.borderTop = 8
    label.borderBottom = 8
    for _, value in ipairs(table.values(koi.combination, true)) do
        this.CreateCombinationView(parent, value)
        parent:createDivider().widthProportional = 1.0
    end

    -- luckyhands
    label = parent:createLabel({ text = i18n("koi.luckyHands.label") })
    label.color = headerColor
    label.borderAllSides = 0
    label.borderTop = 8
    label.borderBottom = 8
    for _, value in ipairs(table.values(koi.luckyHands, true)) do
        this.CreateLuckyHandsView(parent, value)
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
    menu.width = size * 0.9
    menu.height = size * 0.9
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

    ---@param p tes3uiElement
    ---@param text string
    ---@param indent integer?
    local function createHeader(p, text, indent)
        indent = indent or 0
        local l = p:createLabel({ text = text })
        l.color = headerColor
        l.wrapText = true
        l.borderAllSides = 4
        l.borderTop = 12
        l.borderLeft = indent * 12
    end
    ---@param p tes3uiElement
    ---@param text string
    ---@param indent integer?
    local function createText(p, text, indent)
        indent = indent or 1
        local l = p:createLabel({ text = text })
        l.wrapText = true
        l.borderAllSides = 4
        l.borderLeft = indent * 12
    end
    ---@param p tes3uiElement
    ---@param text string
    ---@param indent integer?
    local function createLink(p, text, url, indent)
        indent = indent or 1
        local l = p:createHyperlink({ text = text, url = url })
        l.wrapText = true
        l.borderAllSides = 4
        l.borderLeft = indent * 12
    end
    -- tl;dr
    createHeader(parent, i18n("koi.help.tldr.header"))
    createText(parent, i18n("koi.help.tldr.description"))
    parent:createDivider().widthProportional = 1.0

    -- hanafuda abstruct
    createHeader(parent, i18n("hanafuda.help.summary.header"))
    createText(parent, i18n("hanafuda.help.summary.description"))
    parent:createDivider().widthProportional = 1.0

    -- koikoi abstruct
    createHeader(parent, i18n("koi.help.summary.header"))
    createText(parent, i18n("koi.help.summary.description"))

    createHeader(parent, i18n("koi.help.rule.header"), 1)
    createHeader(parent, i18n("koi.help.rule.setup.header"), 2)
    createText(parent, i18n("koi.help.rule.setup.description"), 2)

    createHeader(parent, i18n("koi.help.rule.luckyHands.header"), 3)
    createText(parent, i18n("koi.help.rule.luckyHands.description"), 3)

    createHeader(parent, i18n("koi.help.rule.turn.header"), 2)
    createHeader(parent, i18n("koi.help.rule.turn.match.header"), 3)
    createText(parent, i18n("koi.help.rule.turn.match.description"), 3)
    createHeader(parent, i18n("koi.help.rule.turn.draw.header"), 3)
    createText(parent, i18n("koi.help.rule.turn.draw.description"), 3)
    createHeader(parent, i18n("koi.help.rule.turn.check.header"), 3)
    createText(parent, i18n("koi.help.rule.turn.check.description"), 3)
    createHeader(parent, i18n("koi.help.rule.turn.check.continue.header"), 4)
    createText(parent, i18n("koi.help.rule.turn.check.continue.description"), 4)
    createHeader(parent, i18n("koi.help.rule.turn.check.end.header"), 4)
    createText(parent, i18n("koi.help.rule.turn.check.end.description"), 4)

    createHeader(parent, i18n("koi.help.rule.round.header"), 3)
    createText(parent, i18n("koi.help.rule.round.description"), 3)
    createHeader(parent, i18n("koi.help.rule.round.scoring.header"), 4)
    createText(parent, i18n("koi.help.rule.round.scoring.description"), 4)
    createHeader(parent, i18n("koi.help.rule.round.emptyDeck.header"), 4)
    createText(parent, i18n("koi.help.rule.round.emptyDeck.description"), 4)

    createHeader(parent, i18n("koi.help.rule.end.header"), 2)
    createText(parent, i18n("koi.help.rule.end.description"), 2)

    -- todo gambling (explain before game beginning)
    -- todo house rules
    -- hint, tips

    -- more info
    parent:createDivider().widthProportional = 1.0
    createHeader(parent, i18n("koi.help.more"))
    createLink(parent, "Wikipedia", "https://en.wikipedia.org/wiki/Koi-Koi")
    createLink(parent, "Fuda Wiki", "https://fudawiki.org/en/hanafuda/games/koi-koi")
    createLink(parent, "The History & Art of Hanafuda", "https://games.porg.es/articles/cards/japan/hanafuda/art/")

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
        -- It would be better if it could be replaced with a person's name. but it not make sence to receive in args.
        tooltip:createLabel({ text = i18n("koi.opponentCard") })
    else
        tooltip = tes3ui.createTooltipMenu()
        tooltip.flowDirection = tes3.flowDirection.leftToRight
        local asset = card.GetCardAsset(cardId)
        local ref = card.GetCardData(cardId)
        local name = tooltip:createLabel({ text = card.GetCardText(cardId).name })
        name.color = headerColor
        local thumb = tooltip:createImage({ path = asset.path })
        thumb.width = card.GetCardWidth() * 2
        thumb.height = card.GetCardHeight() * 2
        thumb.scaleMode = true
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
    local header = tooltip:createLabel({ text = "Deck" })
    header.color = headerColor
    local label = tooltip:createLabel({ text = i18n("koi.deck.remain", { table.size(deck) }) })
    return tooltip
end

return this
