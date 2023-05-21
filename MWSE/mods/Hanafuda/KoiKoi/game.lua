local logger = require("Hanafuda.logger")
local card = require("Hanafuda.card")
local koi = require("Hanafuda.KoiKoi.koikoi")
local combination = require("Hanafuda.KoiKoi.combination")

---@class KoiKoi.Settings
---@field round integer
---@field initialCards integer
---@field initialDealEach integer

-- It is not necessary to keep captured piles separate, but it will make score calculation easier.
---@class KoiKoi.PlayerPool
---@field hand integer[]
---@field [CardType] integer[]

--- ruleset aka model
---@class KoiKoi
---@field settings KoiKoi.Settings
---@field parent KoiKoi.Player
---@field current KoiKoi.Player
---@field deck integer[] card deck
---@field pools KoiKoi.PlayerPool[]
---@field groundPool integer[]
---@field brains KoiKoi.IBrain[]
---@field combinations { [KoiKoi.CombinationType] : integer }[]
local KoiKoi = {}


-- todo random seed or random object

---@type KoiKoi
local defaults = {
    parent = koi.player.you,
    current = koi.player.you,
    settings = {
        round = 3,           -- 6, 12
        initialCards = 8,
        initialDealEach = 2, -- 4
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
}

---@param settings KoiKoi.Settings
local function ValidateSettings(settings)
    assert(settings.round > 0)
    assert(settings.initialCards > 0)
    assert(settings.initialDealEach > 0)
    assert(settings.initialCards % settings.initialDealEach == 0) -- mod allowed, but it only complicate.
end
ValidateSettings(defaults.settings)

---comment
---@return KoiKoi
function KoiKoi.new()
    ---@type KoiKoi
    local instance = table.deepcopy(defaults)
    ValidateSettings(instance.settings)
    setmetatable(instance, { __index = KoiKoi })
    return instance
end

-- event base or command base
-- important split view and logic for replacing visualize using MVC or like as

-- todo phase transition in controller?

---comment
---@param self KoiKoi
---@param brain KoiKoi.IBrain
---@param player boolean?
function KoiKoi.SetBrains(self, brain, player)
    if player then -- rarely
        self.brains[koi.player.you] = brain
    else
        self.brains[koi.player.opponent] = brain
    end
end

function KoiKoi.Initialize(self)
    self.deck = card.CreateDeck()
    self.deck = card.ShuffleDeck(self.deck)
    self.pools = table.deepcopy(defaults.pools)
    self.groundPool = {}
end

-- Better to be able to choose between two cut cards to decide.
---@param self KoiKoi
---@param leftRight boolean
function KoiKoi.DecideParent(self, leftRight)
    --self.parent = math.random(koi.player.you, koi.player.opponent)
    self.parent = leftRight and koi.player.you or koi.player.opponent -- fixed
    self.current = self.parent
    logger:debug("Parent is ".. tostring(self.parent))
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
---@param drawnCardId integer?
---@return KoiKoi.MatchCommand?
function KoiKoi.Simulate(self, player, drawnCardId)
    if self.brains[player] then
        ---@type KoiKoi.AI.Params
        local params = {
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
---@return KoiKoi.CallCommand?
function KoiKoi.Call(self, player, combination)
    if self.brains[player] then
        -- todo temp
        ---@type KoiKoi.AI.Params
        local params = {
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

function KoiKoi.SwapPlayer(self)
    self.current = koi.GetOpponent(self.current)
end

---@param self KoiKoi
---@param player KoiKoi.Player
---@return { [KoiKoi.CombinationType] : integer }?
function KoiKoi.CheckCombination(self, player)
    local pool = self.pools[player]
    local comb = combination.Calculate(pool)
    local latest = self.combinations[player]
    return comb
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
            logger:trace("captured then removeing ".. tostring(cardId))
            logger:trace(table.concat(self.groundPool, ", "))
            local removed = table.removevalue(self.groundPool, cardId)
            assert(removed)
        elseif not drawn then
            logger:trace("captured then removeing ".. tostring(cardId))
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
        local pool = self.pools[player]
        if not drawn then
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

return KoiKoi
