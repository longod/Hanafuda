local card = require("Hanafuda.card")
local logger = require("Hanafuda.logger")
local koi = require("Hanafuda.KoiKoi.koikoi")

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
assert(table.size(koi.combination) == table.size(basePoint))

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
            caps[koi.combination.fiveBrights] = basePoint[koi.combination.fiveBrights]
            logger:debug("Goko " .. tostring(caps[koi.combination.fiveBrights]))
        elseif count == 4 then
            if card.Contain(rainman, bright) then
                caps[koi.combination.rainyFourBrights] = basePoint[koi.combination.rainyFourBrights]
                logger:debug("Ame-Shiko " .. tostring(caps[koi.combination.rainyFourBrights]))
            else
                caps[koi.combination.fourBrights] = basePoint[koi.combination.fourBrights]
                logger:debug("Shiko " .. tostring(caps[koi.combination.fourBrights]))
            end
        elseif count == 3 then
            if card.Contain(rainman, bright) then
            else
                caps[koi.combination.threeBrights] = basePoint[koi.combination.threeBrights]
                logger:debug("Sanko " .. tostring(caps[koi.combination.threeBrights]))
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
                caps[koi.combination.boarDeerButterfly] = basePoint[koi.combination.boarDeerButterfly]
                logger:debug("Ino-Shika-Cho " .. tostring(caps[koi.combination.boarDeerButterfly]))
            end
        end
        if count >= 5 then
            caps[koi.combination.animals] = basePoint[koi.combination.animals] + (count - 5)
            logger:debug("Tane " .. tostring(caps[koi.combination.animals]))
        end

        if card.Contain(sakeCup, animal) then
            if hasCurtain then
                caps[koi.combination.flowerViewingSake] = basePoint[koi.combination.flowerViewingSake]
                logger:debug("Hanami de Ippai " .. tostring(caps[koi.combination.flowerViewingSake]))
            end
            if hasMoon then
                caps[koi.combination.moonViewingSake] = basePoint[koi.combination.moonViewingSake]
                logger:debug("Tsukimi de Ippai " .. tostring(caps[koi.combination.moonViewingSake]))
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
                caps[koi.combination.poetryAndBlueRibbons] = basePoint[koi.combination.poetryAndBlueRibbons] + (count - 6)
                logger:debug("Akatan-Aotan " .. tostring(caps[koi.combination.poetryAndBlueRibbons]))
            elseif poetAll then
                caps[koi.combination.poetryRibbons] = basePoint[koi.combination.poetryRibbons] + (count - 3)
                logger:debug("Akatan " .. tostring(caps[koi.combination.poetryRibbons]))
            elseif blueAll then
                caps[koi.combination.blueRibbons] = basePoint[koi.combination.blueRibbons] + (count - 3)
                logger:debug("Aotan " .. tostring(caps[koi.combination.blueRibbons]))
            elseif count >= 5 then
                caps[koi.combination.ribbons] = basePoint[koi.combination.ribbons] + (count - 5)
                logger:debug("Tan " .. tostring(caps[koi.combination.ribbons]))
            end
        end
    end

    local chaff = captured[card.type.chaff]
    if chaff then
        local count = table.size(chaff)
        if count >= 10 then
            caps[koi.combination.chaff] = basePoint[koi.combination.chaff] + (count - 10)
            logger:debug("Kasu " .. tostring(caps[koi.combination.chaff]))
        end
    end
    return table.size(caps) > 0 and caps or nil
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
