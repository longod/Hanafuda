do

    local card = require("Hanafuda.card")
    local combo = require("Hanafuda.KoiKoi.combination")
    local caps ---@type {[CardType] : integer[]}
    local unitwind = require("unitwind").new({
        enabled = true,
        highlight = false,
        beforeEach = function()
            caps = {
                [card.type.bright] = {},
                [card.type.animal] = {},
                [card.type.ribbon] = {},
                [card.type.chaff] = {},
            }
        end,
    })
    unitwind:start("Koi-Koi Combination Test")

    --- helper
    ---@param cardId integer
    local function AddCard(cardId)
        table.insert(caps[card.GetCardData(cardId).type], cardId)
    end

    unitwind:test("No Combo", function()
        local a = combo.Calculate(caps)
        unitwind:expect(a).toBe(nil)
    end)

    unitwind:test("Goko", function()
        --combo.Calculate()
    end)

    unitwind:finish()
end

do
    local unitwind = require("unitwind").new({
        enabled = true,
        highlight = false,
    })
    unitwind:start("Koi-Koi Integration Test")

    unitwind:test("Run Game", function()
        unitwind:expect(function()
            local runner = require("Hanafuda.KoiKoi.runner").new(
                require("Hanafuda.KoiKoi.simplismBrain").new(),
                require("Hanafuda.KoiKoi.simplismBrain").new()
            )
            while runner:Run() do
            end
        end).NOT.toFail()
    end)

    unitwind:finish()
end
