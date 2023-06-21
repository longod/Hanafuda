---@class Gamble.Settings
local this = {}
this.oddsList = {
    0, -- free
    1,
    5,
    25,
    100,
}
this.penaltyPointPerRound = 5 -- per round

--- Probability value, since the multiplier applied is likely to result in a larger payment than estimated.
---@param mult KoiKoi.HouseRule.Multiplier
---@return number
function this.GetMultiplierFactorByHouseRule(mult)
    local hr = require("Hanafuda.KoiKoi.houseRule")
    local multiplierFactor = {
        [hr.multiplier.none] = 1,
        [hr.multiplier.doublePointsOver7] = 1.5,
        [hr.multiplier.eachTimeKoiKoi] = 2,
    }
    return multiplierFactor[mult] or 1
end

this.dispositionByInsufficientCoefficient = 0.2

this.factionRankBias = 1

this.fightThreshold = {
    base = 70,
}
this.dispositionThreshold = {
    base = 30,
}
---@class Gamble.Range
---@field min number
---@field max number

---@class Gamble.Attribute
---@field attribute tes3.attribute
---@field weight number
---@field current Gamble.Range
---@field out Gamble.Range

---@class Gamble.Skill
---@field skill tes3.skill
---@field weight number
---@field current Gamble.Range
---@field out Gamble.Range

---@class Gamble.Ability
---@field attributes Gamble.Attribute[]?
---@field skills Gamble.Skill[]?

---@type Gamble.Ability
this.gambleAbility = {
    attributes = {
        {
            attribute = tes3.attribute.willpower,
            weight = 1,
            current = {
                min = 30,
                max = 150,
            },
            out = {
                min = 0,
                max = 1,
            },
        },
        {
            attribute = tes3.attribute.intelligence,
            weight = 1,
            current = {
                min = 30,
                max = 150,
            },
            out = {
                min = 0,
                max = 1,
            },
        },
        {
            attribute = tes3.attribute.luck,
            weight = 0.5,
            current = {
                min = 0,
                max = 100,
            },
            out = {
                min = 0,
                max = 1,
            },
        },
    },
    skills = {
        {
            skill = tes3.skill.mercantile,
            weight = 1,
            current = {
                min = 0,
                max = 100,
            },
            out = {
                min = 0,
                max = 1,
            },
        },
    },
}

-- not ability, but same formula
---@type Gamble.Ability
this.greedyAbility = {
    attributes = {
        {
            attribute = tes3.attribute.willpower,
            weight = 1,
            current = {
                min = 0,
                max = 100,
            },
            out = {
                min = 0.9,
                max = 0.1,
            },
        },
    },
    skills = {
        {
            skill = tes3.skill.mercantile,
            weight = 1.0,
            current = {
                min = 0,
                max = 100,
            },
            out = {
                min = 0.1,
                max = 0.5,
            },
        },
    },
}

---@type Gamble.Ability
this.cheatAbility = {
    attributes = {
        {
            attribute = tes3.attribute.personality,
            weight = 0.5,
            current = {
                min = 50,
                max = 150,
            },
            out = {
                min = 0,
                max = 1,
            },
        },
        {
            attribute = tes3.attribute.agility,
            weight = 0.5,
            current = {
                min = 50,
                max = 150,
            },
            out = {
                min = 0,
                max = 1,
            },
        },
        {
            attribute = tes3.attribute.luck,
            weight = 0.25,
            current = {
                min = 0,
                max = 100,
            },
            out = {
                min = 0,
                max = 1,
            },
        },
    },
    skills = {
        {
            skill = tes3.skill.security,
            weight = 1,
            current = {
                min = 0,
                max = 100,
            },
            out = {
                min = 0,
                max = 1,
            },
        },
        {
            skill = tes3.skill.speechcraft,
            weight = 0.5,
            current = {
                min = 0,
                max = 100,
            },
            out = {
                min = 0,
                max = 1,
            },
        },
    },
}

---@type Gamble.Ability
this.spotAbility = {
    attributes = {
        {
            attribute = tes3.attribute.willpower,
            weight = 0.5,
            current = {
                min = 50,
                max = 150,
            },
            out = {
                min = 0,
                max = 1,
            },
        },
        {
            attribute = tes3.attribute.intelligence,
            weight = 0.5,
            current = {
                min = 50,
                max = 150,
            },
            out = {
                min = 0,
                max = 1,
            },
        },
        {
            attribute = tes3.attribute.luck,
            weight = 0.25,
            current = {
                min = 0,
                max = 100,
            },
            out = {
                min = 0,
                max = 1,
            },
        },
    },
    skills = {
        {
            skill = tes3.skill.security,
            weight = 1,
            current = {
                min = 0,
                max = 100,
            },
            out = {
                min = 0,
                max = 1,
            },
        },
    },
}

-- not ability, but same formula
---@type Gamble.Ability
this.luckyAbility = {
    attributes = {
        {
            attribute = tes3.attribute.luck,
            weight = 1.0,
            current = {
                min = 0,
                max = 100,
            },
            out = {
                min = 0,
                max = 1,
            },
        },
    },
    skills = nil,
}
return this
