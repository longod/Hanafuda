local card = require("Hanafuda.card")


-- order is important, almost combinations have exclusively
-- move name to trans data

---@enum KoiKoi.CombinationType
local combo = {
    -- bright
    fiveBrights = 1,
    fourBrights = 2,
    rainyFourBrights = 3,
    threeBrights = 4,
    -- animal
    boarDeerButterfly = 5,
    animals = 6,
    -- ribbon
    poetryAndBlueRibbons = 7, -- both poety and blue
    poetryRibbons = 8,
    blueRibbons = 9,
    ribbons = 10,
    -- chaff (no exclusively)
    flowerViewingSake = 11, -- house rule
    moonViewingSake = 12, -- house rules
    chaff = 13,
}

local basePoint = {
    -- bright
    15,
    8,
    7,
    6,
    -- animal
    5,
    1,
    -- ribbon
    10,
    5,
    5,
    1,
    -- chaff (no exclusively)
    5,
    5,
    1,
}
assert(table.size(combo) == table.size(basePoint))

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

-- or {combotype = N, point = M} can be accessed ipairs
---@param captured { [CardType] : integer[] }
-----@param excluding any? using already calling koi-koi
---@return { [KoiKoi.CombinationType] : integer }?
function this.Calculate(captured)
    local caps = {}
    local hasCurtain = false
    local hasMoon = false

    local bright = captured[card.type.bright]
    if bright then
        local count = table.size(bright)
        if count == 5 then
            caps[combo.fiveBrights] = basePoint[combo.fiveBrights]
        elseif count == 4 then
            if card.Contain(rainman, bright) then
                caps[combo.rainyFourBrights] = basePoint[combo.rainyFourBrights]
            else
                caps[combo.fourBrights] = basePoint[combo.fourBrights]
            end
        elseif count == 3 then
            if card.Contain(rainman, bright) then
            else
                caps[combo.threeBrights] = basePoint[combo.threeBrights]
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
                caps[combo.boarDeerButterfly] = basePoint[combo.boarDeerButterfly]
            end
        end
        if count >= 5 then
            caps[combo.animals] = basePoint[combo.animals] + (count - 5)
        end

        if card.Contain(sakeCup, animal) then
            if hasCurtain then
                caps[combo.flowerViewingSake] = basePoint[combo.flowerViewingSake]
            end
            if hasMoon then
                caps[combo.moonViewingSake] = basePoint[combo.moonViewingSake]
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
                caps[combo.poetryAndBlueRibbons] = basePoint[combo.poetryAndBlueRibbons] + (count - 6)
            elseif poetAll then
                caps[combo.poetryRibbons] = basePoint[combo.poetryRibbons] + (count - 3)
            elseif blueAll then
                caps[combo.blueRibbons] = basePoint[combo.blueRibbons] + (count - 3)
            elseif count >= 5 then
                caps[combo.ribbons] = basePoint[combo.ribbons] + (count - 5)
            end
        end
    end

    local chaff = captured[card.type.chaff]
    if chaff then
        local count = table.size(chaff)
        if count >= 10 then
            caps[combo.chaff] = basePoint[combo.chaff] + (count - 10)
        end
    end
    return table.size(caps) > 0 and caps or nil
end

return this
