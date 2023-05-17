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

---@class KoiKoi
---@field settings KoiKoi.Settings
---@field phase KoiKoi.Phase
---@field parent KoiKoi.Player
---@field current KoiKoi.Player
---@field deck integer[] card deck
---@field pools KoiKoi.PlayerPool[]
---@field groundPool  integer[]
---@field brains KoiKoi.IBrain[]
local KoiKoi = {}

--umm
---@enum KoiKoi.Phase
local phase = {
    initialization = 1,
    decideParent = 2,
    roundSetup = 3,
    parentTurnBegin = 1,
    parentMatch = 1,
    parentDraw = 1,
    parentPlace = 1,
    parentCollect = 1,
    parentTurnEnd = 1,
    childTurnBegin = 1,
    childMatch = 1,
    childDraw = 1,
    childPlace = 1,
    childCollect = 1,
    childTurnEnd = 1,
    roundFinish = 1,
    finish = 1,
}


-- todo random seed or random object

---@type KoiKoi
local defaults = {
    phase = phase.initialization,
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
---@param data KoiKoi?
---@return KoiKoi
function KoiKoi.new(data)
    ---@type KoiKoi
    local instance = data and table.copy(data) or {}
    table.copymissing(instance, defaults)
    ValidateSettings(instance.settings)
    setmetatable(instance, { __index = KoiKoi })
    return instance
end

-- event base or command base
-- important split view and logic for replacing visualize using MVC or like as

-- todo phase transition in controller?

---comment
---@param player KoiKoi.Player
local function GetOpponent(player)
    if player == koi.player.you then
        return koi.player.opponent
    elseif player == koi.player.opponent then
        return koi.player.you
    end
    assert()
end

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
function KoiKoi.DecideParent(self)
    self.parent = math.random(koi.player.you, koi.player.opponent)
    self.current = self.parent
    logger:debug("Parent is ".. tostring(self.parent))
end

-- Better with animation to hand out one card at a time.
function KoiKoi.DealInitialCards(self)
    local initialCards = self.settings.initialCards
    local initialDealEach = self.settings.initialDealEach
    local first = self.pools[GetOpponent(self.parent)].hand
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
            opponentPool = self.pools[GetOpponent(player)],
            groundPool = self.groundPool,
            deck = self.deck,
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
---@return KoiKoi.CallCommand?
function KoiKoi.Call(self, player)
    if self.brains[player] then
        -- todo temp
        ---@type KoiKoi.AI.Params
        local params = {
            drawnCard = nil,
            pool = self.pools[player],
            opponentPool = self.pools[GetOpponent(player)],
            groundPool = self.groundPool,
            deck = self.deck,
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
    self.current = GetOpponent(self.current)
end

---@param self KoiKoi
---@param player KoiKoi.Player
function KoiKoi.CheckCombination(self, player)
    local pool = self.pools[player]
    -- combination:Find(pool)
    -- todo return
end

---@param self KoiKoi
function KoiKoi.CheckEnd(self)
    return table.empty(self.deck)
end

---@param self KoiKoi
---@param player KoiKoi.Player
---@param cardId integer?
function KoiKoi.Capture(self, player, cardId)
    if cardId then
        local pool = self.pools[player]
        table.insert(pool[card.GetCardData(cardId).type], cardId)
        table.removevalue(pool.hand, cardId) -- if own card?
        return true
    end
    return false
end

---@param self KoiKoi
---@param player KoiKoi.Player
---@param cardId integer?
function KoiKoi.Discard(self, player, cardId)
    if cardId then
        local pool = self.pools[player]
        local removed = table.removevalue(pool.hand, cardId)
        assert(removed)
        table.insert(self.groundPool, cardId)
        return true
    end
    return false
end

return KoiKoi
