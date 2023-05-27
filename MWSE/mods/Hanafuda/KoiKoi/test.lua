local logger = require("Hanafuda.logger")

do
    local card = require("Hanafuda.card")
    local koi = require("Hanafuda.KoiKoi.koikoi")
    local combo = require("Hanafuda.KoiKoi.combination")
    local caps ---@type {[CardType] : integer[]}

    --- helper
    ---@param params Card.Find.Params|integer
    ---@return {[CardType] : integer[]}
    local function AddCard(params)
        ---@param cardId integer
        local function add(cardId)
            table.insert(caps[card.GetCardData(cardId).type], cardId)
        end

        if type(params) == "table" then
            local ids = card.Find(params)
            if type(ids) == "table" then
                for _, id in ipairs(ids) do
                    add(id)
                end
            elseif type(ids) == "number" then
                add(ids)
            end
        elseif type(params) == "number" then
            add(params)
        end
        return caps
    end

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

    unitwind:test("No Combo", function()
        local actual = combo.Calculate(caps)
        unitwind:expect(actual).toBe(nil)
        -- todo edge case
    end)

    unitwind:test("Goko", function()
        local actual = combo.Calculate(AddCard({ type = card.type.bright, findAll = true }))
        unitwind:expect(actual).NOT.toBe(nil)
        if actual then
            unitwind:expect(actual[koi.combination.fiveBrights]).toBe(koi.basePoint[koi.combination.fiveBrights])
        end
    end)

    unitwind:test("Different", function()
        local goko = AddCard({ type = card.type.bright, findAll = true })
        local shiko = table.deepcopy(goko)
        table.removevalue(shiko[card.type.bright], card.Find({ symbol = card.symbol.rainman }))
        local current = combo.Calculate(goko)
        local prev = combo.Calculate(shiko)

        do
            local diff = combo.Different(prev, prev)
            unitwind:expect(diff).toBe(nil)
            diff = combo.Different(current, current)
            unitwind:expect(diff).toBe(nil)
        end
        do
            local diff = combo.Different(current, prev)
            unitwind:expect(diff).NOT.toBe(nil)
            if diff then
                for key, value in pairs(diff) do
                    logger:debug("%d: %d", key, value)
                end
                unitwind:expect(diff[koi.combination.fiveBrights]).toBe(koi.basePoint[koi.combination.fiveBrights])
            end
        end
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
                require("Hanafuda.KoiKoi.brain.simpleBrain").new(),
                require("Hanafuda.KoiKoi.brain.simpleBrain").new()
            )
            while runner:Run() do
            end
        end).NOT.toFail()
    end)

    unitwind:finish()
end
