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

---@class KoiKoi.CombinationView
local this = {}

---@param parent tes3uiElement
---@param combination KoiKoi.CombinationType
---@param actualPoint integer?
---@return tes3uiElement
function this.CreateCombinationView(parent, combination, actualPoint)
    local indent = 12

    local header = tes3ui.getPalette(tes3.palette.headerColor)
    local block = parent:createBlock()
    block.flowDirection = tes3.flowDirection.topToBottom
    block.widthProportional = 1
    block.autoHeight = true
    block.paddingAllSides = 4

    ---@param cardIds integer[]
    local listup = function(cardIds)
        local pattern = block:createBlock()
        pattern.autoWidth = true
        pattern.autoHeight = true
        pattern.flowDirection = tes3.flowDirection.leftToRight
        pattern.borderAllSides = 0
        pattern.borderLeft = indent * 2

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
            condition = string.format("%s and %s.", card.GetCardText(curtain).name, card.GetCardText(sakeCup).name),
        },
        [koi.combination.moonViewingSake] = {
            name = "Tsukimi de Ippai",
            point = string.format("%u points.", koi.basePoint[koi.combination.moonViewingSake]),
            condition = string.format("%s and %s.", card.GetCardText(moon).name, card.GetCardText(sakeCup).name),
        },
        [koi.combination.chaff] = {
            name = "Kasu",
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
        local name = block:createLabel({ text = d.name})
        name.color = header
        name.borderLeft = indent

        -- todo if actualPoint
        -- todo getting table data
        local point = block:createLabel({ text = d.point })
        point.borderLeft = indent * 2
        point.wrapText = true

        local condition = block:createLabel({ text = d.condition })
        condition.borderLeft = indent * 2
        condition.wrapText = true


        combo[combination]()
        block:createDivider().widthProportional = 1.0
    else
        logger:error("unknown combination %u", combination)
    end
    return block
end


return this
