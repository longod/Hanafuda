local logger = require("Hanafuda.logger")
local card = require("Hanafuda.card")
local koi = require("Hanafuda.KoiKoi.koikoi")
local combination = require("Hanafuda.KoiKoi.combination")
local houseRule = require("Hanafuda.KoiKoi.houseRule")

---@class KoiKoi.Settings
---@field round integer
---@field initialCards integer
---@field initialDealEach integer
---@field houseRule Config.KoiKoi.HouseRule

-- It is not necessary to keep captured piles separate, but it will make score calculation easier.
---@class KoiKoi.PlayerPool
---@field hand integer[]
---@field [CardType] integer[]

--- ruleset aka model
---@class KoiKoi
---@field parent KoiKoi.Player means dealer + alpha
---@field current KoiKoi.Player
---@field round integer
---@field settings KoiKoi.Settings
---@field deck integer[] card deck
---@field pools KoiKoi.PlayerPool[]
---@field groundPool integer[]
---@field brains KoiKoi.IBrain[]
---@field combinations { KoiKoi.Player : { [KoiKoi.CombinationType] : integer } }
---@field points { KoiKoi.Player : integer }
---@field calls { KoiKoi.Player : integer }
---@field decidingParentCardId integer?
---@field decidingParent integer[] card deck
local KoiKoi = {}


-- todo random seed or random object

---@type KoiKoi
local defaults = {
    parent = koi.player.you,
    current = koi.player.you,
    round = 1,
    settings = {
        round = 3,
        initialCards = 8,
        initialDealEach = 2, -- or 4
        houseRule = {},
    },
    deck = {},
    pools = {
        -- you
        {
            hand = {},
            [card.type.bright] = {},
            [card.type.animal] = {},
            [card.type.ribbon] = {},
            [card.type.chaff] = {},
        },
        -- opponent
        {
            hand = {},
            [card.type.bright] = {},
            [card.type.animal] = {},
            [card.type.ribbon] = {},
            [card.type.chaff] = {},
        }
    },
    groundPool = {},
    brains = {},
    combinations = {},
    points = {
        [koi.player.you] = 0,
        [koi.player.opponent] = 0,
    },
    calls = {
        [koi.player.you] = 0,
        [koi.player.opponent] = 0,
    },
    decidingParentCardId = nil,
    decidingParent = {},
}

---@param settings KoiKoi.Settings
local function ValidateSettings(settings)
    assert(settings.round > 0)
    assert(settings.initialCards > 0)
    assert(settings.initialDealEach > 0)
    assert(settings.initialCards % settings.initialDealEach == 0) -- mod allowed, but it only complicate.
end
ValidateSettings(defaults.settings)

---@param settings Config.KoiKoi
---@param opponentBrain KoiKoi.IBrain?
---@param playerBrain KoiKoi.IBrain?
---@return KoiKoi
function KoiKoi.new(settings, opponentBrain, playerBrain)
    ---@type KoiKoi
    local instance = table.deepcopy(defaults)
    instance.settings.houseRule = table.deepcopy(settings.houseRule) -- do not change in game
    instance.settings.round = settings.round
    ValidateSettings(instance.settings)
    setmetatable(instance, { __index = KoiKoi })
    instance:SetBrains(opponentBrain, koi.player.opponent)
    instance:SetBrains(playerBrain, koi.player.you)
    return instance
end

-- event base or command base
-- important split view and logic for replacing visualize using MVC or like as

---@param self KoiKoi
---@param brain KoiKoi.IBrain?
---@param player KoiKoi.Player
function KoiKoi.SetBrains(self, brain, player)
    self.brains[player] = brain
end

---@param self KoiKoi
function KoiKoi.Initialize(self)
    self.deck = card.CreateDeck()
    self.deck = card.ShuffleDeck(self.deck)
    self.pools = table.deepcopy(defaults.pools)
    self.calls = table.deepcopy(defaults.calls)
    self.groundPool = {}
    self.combinations = {}
    for _, b in pairs(self.brains) do
        if b then
            b:Reset()
        end
    end
end

-- The choice of the parents of the Hanafuda is flawed.
-- In the case of the same month, it is determined by card point, but there are cases where both players pick chaff. You must keep drawing cards until it is resolved.
-- That is boring in a video game, so limit the cards to avoid such a situation.
---@param self KoiKoi
---@param num integer
---@return integer[]
function KoiKoi.ChoiceDecidingParentCards(self, num)
    local deck = card.CreateDeck()
    local banned = {
        4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 47, 48,
    }
    -- Since it is a sequential number before shuffling, it can be established by removing it from the back as an index, but this is not strictly correct. Delete it as a normal value.
    for index, value in ipairs(banned) do
        table.removevalue(deck, value)
    end
    assert(num <= table.size(deck))
    deck = card.ShuffleDeck(deck)

    self.decidingParent = {}
    for i = 1, num do
        table.insert(self.decidingParent, deck[i])
    end
    return self.decidingParent
end


-- Better to be able to choose between two cut cards to decide.
---@param self KoiKoi
---@param selectedCardId integer
function KoiKoi.DecideParent(self, selectedCardId)

    local most = selectedCardId
    local rhs = card.GetCardData(most)
    for index, value in ipairs(self.decidingParent) do
        local lhs = card.GetCardData(value)
        if (lhs.suit < rhs.suit) or (lhs.suit == rhs.suit and lhs.type < rhs.type) then
            most = value
            rhs = lhs
        end
    end

    self.decidingParentCardId = selectedCardId
    self.parent = selectedCardId == most and koi.player.you or koi.player.opponent
    --self.parent = leftRight and koi.player.you or koi.player.opponent -- fixed
    self.current = self.parent
    logger:debug("Parent is ".. tostring(self.parent))
end

---@param self KoiKoi
---@param player KoiKoi.Player
function KoiKoi.SetCurrentPlayer(self, player)
    self.current = player
end

-- Better with animation to hand out one card at a time.
function KoiKoi.DealInitialCards(self)
    local initialCards = self.settings.initialCards
    local initialDealEach = self.settings.initialDealEach
    local first = self.pools[koi.GetOpponent(self.parent)].hand
    local second = self.pools[self.parent].hand
    while table.size(first) < initialCards do
        -- todo check count
        for i = 1, initialDealEach do
            table.insert(first, card.DealCard(self.deck))
        end
        for i = 1, initialDealEach do
            table.insert(self.groundPool, card.DealCard(self.deck))
        end
        for i = 1, initialDealEach do
            table.insert(second, card.DealCard(self.deck))
        end
    end
    assert(table.size(first) == initialCards)
    assert(table.size(self.groundPool) == initialCards)
    assert(table.size(second) == initialCards)
end

---@param self KoiKoi
---@param player KoiKoi.Player
function KoiKoi.CheckLuckyHands(self, player)
    -- TODO in testing
    local lh = combination.CalculateLuckyHands(self.pools[player].hand, self.settings.houseRule)
    if not lh then
        logger:debug("%d is no lucky hands", player)
    end
end

---@param self KoiKoi
---@return integer?
function KoiKoi.DrawCard(self)
    return card.DealCard(self.deck)
end

---@param self KoiKoi
---@param player KoiKoi.Player
---@param drawnCardId integer?
---@param deltaTime number
---@param timestamp number
---@return KoiKoi.MatchCommand?
function KoiKoi.Simulate(self, player, drawnCardId, deltaTime, timestamp)
    if self.brains[player] then
        ---@type KoiKoi.AI.Params
        local params = {
            deltaTime = deltaTime,
            timestamp = timestamp,
            drawnCard = drawnCardId,
            pool = self.pools[player],
            opponentPool = self.pools[koi.GetOpponent(player)],
            groundPool = self.groundPool,
            deck = self.deck,
            combination = nil,
        }
        local command = self.brains[player]:Simulate(params)
        if command then
            -- todo validate
        end
        return command
    end
    return nil
end

---@param self KoiKoi
---@param player KoiKoi.Player
---@param combination { [KoiKoi.CombinationType] : integer }
---@param deltaTime number
---@param timestamp number
---@return KoiKoi.CallCommand?
function KoiKoi.Call(self, player, combination, deltaTime, timestamp)
    if self.brains[player] then
        -- todo temp
        ---@type KoiKoi.AI.Params
        local params = {
            deltaTime = deltaTime,
            timestamp = timestamp,
            drawnCard = nil,
            pool = self.pools[player],
            opponentPool = self.pools[koi.GetOpponent(player)],
            groundPool = self.groundPool,
            deck = self.deck,
            combination = combination,
        }
        local command = self.brains[player]:Call(params)
        if command then
            -- todo validate
        end
        return command
    end
    return nil
end

---@param self KoiKoi
---@return KoiKoi.Player
function KoiKoi.SwapPlayer(self)
    self:SetCurrentPlayer(koi.GetOpponent(self.current))
    return self.current
end

---@param self KoiKoi
---@param cardId integer
---@param targetId integer
---@return boolean
function KoiKoi.CanMatch(self, cardId, targetId)
    -- todo check is in ground?
    return koi.CanMatchSuit(cardId, targetId)
end

---@param self KoiKoi
---@param cardId integer
---@return boolean
function KoiKoi.CanDiscard(self, cardId)
    for _, id in pairs(self.groundPool) do
        if koi.CanMatchSuit(cardId, id) then
            return false
        end
    end
    return true
end


---@param self KoiKoi
---@param player KoiKoi.Player
---@return { [KoiKoi.CombinationType] : integer }?
function KoiKoi.CheckCombination(self, player)
    local pool = self.pools[player]
    local combo = combination.Calculate(pool, self.settings.houseRule)
    local latest = self.combinations[player]
    local diff = combination.Different(combo, latest)
    if diff then
        self.combinations[player] = combo
        return combo
    end
    return nil
end

---@param self KoiKoi
function KoiKoi.CheckEnd(self)
    return table.empty(self.deck)
end

---@param self KoiKoi
---@param player KoiKoi.Player
---@param cardId integer?
---@param ground boolean -- todo smartway
---@param drawn boolean -- todo smartway
function KoiKoi.Capture(self, player, cardId, ground, drawn)
    if cardId then
        local pool = self.pools[player]
        table.insert(pool[card.GetCardData(cardId).type], cardId)
        if ground then
            logger:trace("captured then removeing from ground ".. tostring(cardId))
            logger:trace(table.concat(self.groundPool, ", "))
            local removed = table.removevalue(self.groundPool, cardId)
            assert(removed)
        elseif not drawn then
            logger:trace("captured then removeing from hand ".. tostring(cardId))
            logger:trace(table.concat(pool.hand, ", "))
            local removed = table.removevalue(pool.hand, cardId)
            assert(removed)
        end
        return true
    end
    return false
end

---@param self KoiKoi
---@param player KoiKoi.Player
---@param cardId integer?
---@param drawn boolean -- todo smartway
function KoiKoi.Discard(self, player, cardId, drawn)
    if cardId then
        if not drawn then
            local pool = self.pools[player]
            logger:trace("removeing ".. tostring(cardId))
            logger:trace(table.concat(pool.hand, ", "))
            local removed = table.removevalue(pool.hand, cardId)
            assert(removed)
        end
        table.insert(self.groundPool, cardId)
        return true
    end
    return false
end

---@param self KoiKoi
---@param player KoiKoi.Player
---@param cardId integer?
---@return boolean
function KoiKoi.HasCard(self, player, cardId)
    if cardId then
        local pool = self.pools[player]
        return table.find(pool.hand, cardId) ~= nil
    end
    return false
end

---@param self KoiKoi
---@return boolean
function KoiKoi.EmptyDeck(self)
    return table.size(self.deck) == 0 -- use empty better
end

---@param self KoiKoi
---@param player KoiKoi.Player
---@return boolean
function KoiKoi.EmptyHand(self, player)
    return table.size(self.pools[player].hand) == 0 -- use empty better
end

---@param self KoiKoi
---@param player KoiKoi.Player
---@return integer
function KoiKoi.AddKoiKoiCount(self, player)
    self.calls[player] = self.calls[player] + 1
    return self.calls[player]
end

---@param self KoiKoi
---@param player KoiKoi.Player
---@return integer basePoint
---@return integer multiplier
function KoiKoi.CalculateRoundPoint(self, player)
    ---@param combo { [KoiKoi.CombinationType] : integer }
    ---@return integer
    local function SumTotalPoint(combo)
        local total = 0
        for _, value in pairs(combo) do
            total = total + value
        end
        return total
    end

    local point = 0
    local mult = 1
    if self.combinations[player] then
        point = SumTotalPoint(self.combinations[player])
        if self.settings.houseRule.multiplier == houseRule.multiplier.doublePointsOver7 then
            if point >= 7 then
                mult = 2
            end
        elseif self.settings.houseRule.multiplier == houseRule.multiplier.eachTimeKoiKoi then
            mult = 1 + self.calls[koi.player.you] + self.calls[koi.player.opponent]
        end
    end
    return point, mult
end

---@param self KoiKoi
---@param player KoiKoi.Player
function KoiKoi.SetRoundWinner(self, player)
    local point, mult = self:CalculateRoundPoint(player)
    self.points[player] = self.points[player] + point * mult
    self.parent = player
end

---@param self KoiKoi
---@return boolean
function KoiKoi.NextRound(self)
    if self.round < self.settings.round then
        self.round = self.round + 1
        logger:debug("go to next round %d", self.round)
        return true
    end
    return false
end

---@param self KoiKoi
---@return KoiKoi.Player? -- nil is draw
function KoiKoi.GetGameWinner(self)
    local a = self.points[koi.player.you]
    local b = self.points[koi.player.opponent]
    local winner = (a == b) and nil or (a > b and koi.player.you or koi.player.opponent)
    return winner
end

return KoiKoi
