--- Koi-Koi types
local this = {}

---@enum KoiKoi.Calling
this.calling = {
    koikoi = 1, -- continue
    shobu = 2, -- finish
}

---@enum KoiKoi.Player
this.player = {
    you = 1,
    opponent = 2,
}

---@enum KoiKoi.CombinationType
this.combination = {
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

---@type integer[]
this.basePoint = {
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
assert(table.size(this.combination) == table.size(this.basePoint))

---comment
---@param player KoiKoi.Player
function this.GetOpponent(player)
    if player == this.player.you then
        return this.player.opponent
    elseif player == this.player.opponent then
        return this.player.you
    end
    assert()
end
return this