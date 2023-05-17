local data = require("Hanafuda.cardData")

-- Basically based on rank, but points are defined individually taking into account house rules, etc.
local cardPoint = {
    20, 5, 1, 1,
    10, 5, 1, 1,
    20, 5, 1, 1,
    10, 5, 1, 1,
    10, 5, 1, 1,
    10, 5, 1, 1,
    10, 5, 1, 1,
    20, 10, 1, 1,
    10, 5, 1, 1,
    10, 5, 1, 1,
    20, 10, 5, 1,
    20, 1, 1, 1,
}

---@class CardData
---@field suit CardSuit
---@field type CardType
---@field symbol CardSymbol

---@type CardData[]
local cardReferenceData = {
    { suit = data.cardSuit.january,     type = data.cardType.bright, symbol = data.cardSymbol.crane },
    { suit = data.cardSuit.january,     type = data.cardType.ribbon, symbol = data.cardSymbol.redPoetry },
    { suit = data.cardSuit.january,     type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.january,     type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.february,    type = data.cardType.animal, symbol = data.cardSymbol.warbler },
    { suit = data.cardSuit.february,    type = data.cardType.ribbon, symbol = data.cardSymbol.redPoetry },
    { suit = data.cardSuit.february,    type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.february,    type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.march,       type = data.cardType.bright, symbol = data.cardSymbol.curtain },
    { suit = data.cardSuit.march,       type = data.cardType.ribbon, symbol = data.cardSymbol.redPoetry },
    { suit = data.cardSuit.march,       type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.march,       type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.april,       type = data.cardType.animal, symbol = data.cardSymbol.cuckoo },
    { suit = data.cardSuit.april,       type = data.cardType.ribbon, symbol = data.cardSymbol.red },
    { suit = data.cardSuit.april,       type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.april,       type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.may,         type = data.cardType.animal, symbol = data.cardSymbol.bridge },
    { suit = data.cardSuit.may,         type = data.cardType.ribbon, symbol = data.cardSymbol.red },
    { suit = data.cardSuit.may,         type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.may,         type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.june,        type = data.cardType.animal, symbol = data.cardSymbol.butterfly },
    { suit = data.cardSuit.june,        type = data.cardType.ribbon, symbol = data.cardSymbol.blue },
    { suit = data.cardSuit.june,        type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.june,        type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.july,        type = data.cardType.animal, symbol = data.cardSymbol.boar },
    { suit = data.cardSuit.july,        type = data.cardType.ribbon, symbol = data.cardSymbol.red },
    { suit = data.cardSuit.july,        type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.july,        type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.august,      type = data.cardType.bright, symbol = data.cardSymbol.moon },
    { suit = data.cardSuit.august,      type = data.cardType.animal, symbol = data.cardSymbol.geese },
    { suit = data.cardSuit.august,      type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.august,      type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.september,   type = data.cardType.animal, symbol = data.cardSymbol.sakeCup },
    { suit = data.cardSuit.september,   type = data.cardType.ribbon, symbol = data.cardSymbol.blue },
    { suit = data.cardSuit.september,   type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.september,   type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.october,     type = data.cardType.animal, symbol = data.cardSymbol.deer },
    { suit = data.cardSuit.october,     type = data.cardType.ribbon, symbol = data.cardSymbol.blue },
    { suit = data.cardSuit.october,     type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.october,     type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.november,    type = data.cardType.bright, symbol = data.cardSymbol.rainman },
    { suit = data.cardSuit.november,    type = data.cardType.animal, symbol = data.cardSymbol.swallow },
    { suit = data.cardSuit.november,    type = data.cardType.ribbon, symbol = data.cardSymbol.red },
    { suit = data.cardSuit.november,    type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.december,    type = data.cardType.bright, symbol = data.cardSymbol.phoenix },
    { suit = data.cardSuit.december,    type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.december,    type = data.cardType.chaff,  symbol = data.cardSymbol.none },
    { suit = data.cardSuit.december,    type = data.cardType.chaff,  symbol = data.cardSymbol.none },
}

--- basic card operation
---@class Card
local this = {
    type = data.cardType,
}

-- function this.getCardReference()
--     return cardReferenceData
-- end

-- function this.getCardCount()
--     return #cardReferenceData
-- end

---@param cardId integer
---@return CardData
function this.GetCardData(cardId)
    return cardReferenceData[cardId]
end

---@param cardId integer
---@return CardText
function this.GetCardText(cardId)
    return data.cardText[cardId]
end

---@param suit CardSuit
---@return CardText
function this.GetCardSuitText(suit)
    return data.suitText[suit]
end

---@param type CardType
---@return CardText
function this.GetCardTypeText(type)
    return data.typeText[type]
end

---@param type CardType
---@return number[]
function this.GetCardTypeColor(type)
    return data.typeColor[type]
end

---@param cardId integer
---@return integer
function this.GetCardPoint(cardId)
    return cardPoint[cardId]
end

---@param cardId integer
---@return CardAsset
function this.GetCardAsset(cardId)
    return data.cardAssets[cardId]
end

---@return CardAsset
function this.GetCardBackAsset()
    return data.cardBackAsset
end

-- contain CardAsset for any asset types?
---@return number
function this.GetCardWidth()
    return data.cardWidth
end

-- contain CardAsset for any asset types?
---@return number
function this.GetCardHeight()
    return data.cardHeight
end

---@return integer[] cardId
function this.CreateDeck()
    local deck = {}
    for index, _ in ipairs(cardReferenceData) do
        deck[index] = index
    end
    return deck
end

---@param deck integer[] cardId
---@return integer[] cardId
function this.ShuffleDeck(deck)
    local s = {}
    for i = 1, #deck do s[i] = deck[i] end
    for i = #deck, 2, -1 do
        local j = math.random(i)
        s[i], s[j] = s[j], s[i]
    end
    return s
end

---@param deck integer[] cardId
---@return integer? cardId
function this.DealCard(deck)
    if table.empty(deck) then
        return nil
    end
    return table.remove(deck) -- remove last element
end

---@param cardId0 integer
---@param cardId1 integer
---@return boolean
function this.CanMatchSuit(cardId0, cardId1)
    return this.GetCardData(cardId0).suit == this.GetCardData(cardId1).suit
end

-- lua 5.4 rng is xoshiro256**
-- So is the algorithm worse than it used to be?
return this
