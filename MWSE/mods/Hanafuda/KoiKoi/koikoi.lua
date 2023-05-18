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

return this
