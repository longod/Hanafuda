local card = require("Hanafuda.card")

---@class KoiKoi.Settings
---@field round integer
---@field initialCards integer
---@field initialDealEach integer

-- It is not necessary to keep captured piles separate, but it will make score calculation easier.
---@class KoiKoi.PlayerPool
---@field hand integer[]
---@field bright integer[]
---@field animal integer[]
---@field ribbon integer[]
---@field chaff integer[]
-- or [type] integer[]

---@class KoiKoi
---@field settings KoiKoi.Settings
---@field phase KoiKoi.Phase
---@field parent KoiKoi.Parent
---@field deck integer[] card deck
---@field playerPool KoiKoi.PlayerPool
---@field opponentPool KoiKoi.PlayerPool
---@field groundPool  integer[]
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

---@enum KoiKoi.Parent
local parent = {
    player = 1,
    opponent = 2,
}

-- todo random seed

---@type KoiKoi
local defaults = {
    phase = phase.initialization,
    parent = parent.player,
    settings = {
        round = 3,           -- 6, 12
        initialCards = 8,
        initialDealEach = 2, -- 4
    },
    deck = {},
    playerPool = {
        hand = {},
        bright = {},
        animal = {},
        ribbon = {},
        chaff = {},
    },
    opponentPool = {
        hand = {},
        bright = {},
        animal = {},
        ribbon = {},
        chaff = {},
    },
    groundPool = {},
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

-- todo phase transition

function KoiKoi.Initialize(self)
    self.deck = card.CreateDeck()
    self.deck = card.ShuffleDeck(self.deck)
    self.playerPool = table.deepcopy(defaults.playerPool)
    self.opponentPool = table.deepcopy(defaults.opponentPool)
    self.groundPool = {}
end

-- Better to be able to choose between two cut cards to decide.
function KoiKoi.DecideParent(self)
    self.parent = math.random(1, 2)
end

-- Better with animation to hand out one card at a time.
function KoiKoi.DealInitialCards(self)
    local initialCards = self.settings.initialCards
    local initialDealEach = self.settings.initialDealEach
    local first, second
    if self.parent == parent.player then
        first = self.playerPool.hand
        second = self.opponentPool.hand
    else
        first = self.opponentPool.hand
        second = self.playerPool.hand
    end
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

return KoiKoi
