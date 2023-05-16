do
    local card = require("Hanafuda.card")

    local unitwind = require("unitwind").new({
        enabled = true,
    })

    unitwind:start("Hanafuda Card")

    unitwind:test("CreateDeck", function()
        local deck = card.CreateDeck()
        unitwind:expect(#deck).toBe(48)
        -- sequence and unique?
        for index, value in ipairs(deck) do
            unitwind:expect(value).toBe(index)
        end
    end)

    unitwind:test("ShuffleDeck", function()
        local deck = card.CreateDeck()
        local shuffled = card.shuffleDeck(deck)
        unitwind:expect(#shuffled).toBe(#deck)

        -- no duplicated?
        -- smarter way in lua?
        for i, v1 in ipairs(shuffled) do
            for j, v2 in ipairs(shuffled) do
                if i ~= j then
                    unitwind:expect(v1 ~= v2).toBe(true)
                end
            end
        end
    end)

    unitwind:test("DealCard", function()
        local deck = card.CreateDeck()
        for i = 48, 1, -1 do
            local card = card.dealCard(deck)
            unitwind:expect(card).toBe(i)
        end
        local card = card.dealCard(deck)
        unitwind:expect(card).toBe(nil)
    end)

    unitwind:finish()
end
