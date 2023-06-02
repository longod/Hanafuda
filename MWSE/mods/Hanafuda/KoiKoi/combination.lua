local card = require("Hanafuda.card")
local logger = require("Hanafuda.logger")
local koi = require("Hanafuda.KoiKoi.koikoi")

---@class KoiKoi.Combination
local this = {}

-- need estimeter with hand cards for AI

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

--todo test

-- or {combotype = N, point = M} can be accessed ipairs
---@param captured { [CardType] : integer[] }
---@param houseRule Config.KoiKoi.HouseRule
---@return { [KoiKoi.CombinationType] : integer }?
function this.Calculate(captured, houseRule)
    local combo = {}
    local hasCurtain = false
    local hasMoon = false

    local bright = captured[card.type.bright]
    if bright then
        local count = table.size(bright)
        if count == 5 then
            combo[koi.combination.fiveBrights] = koi.basePoint[koi.combination.fiveBrights]
            logger:debug("Goko " .. tostring(combo[koi.combination.fiveBrights]))
        elseif count == 4 then
            if card.Contain(rainman, bright) then
                combo[koi.combination.rainyFourBrights] = koi.basePoint[koi.combination.rainyFourBrights]
                logger:debug("Ame-Shiko " .. tostring(combo[koi.combination.rainyFourBrights]))
            else
                combo[koi.combination.fourBrights] = koi.basePoint[koi.combination.fourBrights]
                logger:debug("Shiko " .. tostring(combo[koi.combination.fourBrights]))
            end
        elseif count == 3 then
            if card.Contain(rainman, bright) then
            else
                combo[koi.combination.threeBrights] = koi.basePoint[koi.combination.threeBrights]
                logger:debug("Sanko " .. tostring(combo[koi.combination.threeBrights]))
            end
        end

        if card.Contain(curtain, bright) then
            hasCurtain = true
        end
        if card.Contain(moon, bright) then
            hasMoon = true
        end
    end

    local animal = captured[card.type.animal]
    if animal then
        local count = table.size(animal)
        if count >= 3 then
            if card.Contain(boar, animal) and
            card.Contain(deer, animal) and
            card.Contain(butterfly, animal) then
                combo[koi.combination.boarDeerButterfly] = koi.basePoint[koi.combination.boarDeerButterfly]
                logger:debug("Ino-Shika-Cho " .. tostring(combo[koi.combination.boarDeerButterfly]))
            end
        end
        if count >= 5 then
            combo[koi.combination.animals] = koi.basePoint[koi.combination.animals] + (count - 5)
            logger:debug("Tane " .. tostring(combo[koi.combination.animals]))
        end

        if card.Contain(sakeCup, animal) then
            if hasCurtain and houseRule.flowerViewingSake then
                combo[koi.combination.flowerViewingSake] = koi.basePoint[koi.combination.flowerViewingSake]
                logger:debug("Hanami-Zake " .. tostring(combo[koi.combination.flowerViewingSake]))
            end
            if hasMoon and houseRule.moonViewingSake then
                combo[koi.combination.moonViewingSake] = koi.basePoint[koi.combination.moonViewingSake]
                logger:debug("Tsukimi-Zake " .. tostring(combo[koi.combination.moonViewingSake]))
            end
        end
    end

    local ribbon = captured[card.type.ribbon]
    if ribbon then
        local count = table.size(ribbon)
        if count >= 3 then
            local poetAll = card.ContainAll(redPoetry, ribbon)
            local blueAll = card.ContainAll(blueRibbon, ribbon)
            if poetAll and blueAll then
                -- same as both poetryRibbons and blueRibbons, but checking easly with bonus points
                combo[koi.combination.poetryAndBlueRibbons] = koi.basePoint[koi.combination.poetryAndBlueRibbons] + (count - 6)
                logger:debug("Akatan-Aotan " .. tostring(combo[koi.combination.poetryAndBlueRibbons]))
            elseif poetAll then
                combo[koi.combination.poetryRibbons] = koi.basePoint[koi.combination.poetryRibbons] + (count - 3)
                logger:debug("Akatan " .. tostring(combo[koi.combination.poetryRibbons]))
            elseif blueAll then
                combo[koi.combination.blueRibbons] = koi.basePoint[koi.combination.blueRibbons] + (count - 3)
                logger:debug("Aotan " .. tostring(combo[koi.combination.blueRibbons]))
            elseif count >= 5 then
                combo[koi.combination.ribbons] = koi.basePoint[koi.combination.ribbons] + (count - 5)
                logger:debug("Tan " .. tostring(combo[koi.combination.ribbons]))
            end
        end
    end

    local chaff = captured[card.type.chaff]
    if chaff then
        local count = table.size(chaff)
        if count >= 10 then
            combo[koi.combination.chaff] = koi.basePoint[koi.combination.chaff] + (count - 10)
            logger:debug("Kasu " .. tostring(combo[koi.combination.chaff]))
        end
    end
    return table.size(combo) > 0 and combo or nil
end

---@param current { [KoiKoi.CombinationType] : integer }?
---@param prev { [KoiKoi.CombinationType] : integer }?
---@return { [KoiKoi.CombinationType] : integer }?
function this.Different(current, prev)
    if not prev or not current then
        return current
    end
    assert(prev)
    assert(current)

    -- FIXME including 1 additional point for each
    local diff = {}
    for key, value in pairs(current) do
        if not prev[key] then
            diff[key] = value
        end
        -- need tracking upgrade?
    end
    return table.size(diff) > 0 and diff or nil
end


return this
