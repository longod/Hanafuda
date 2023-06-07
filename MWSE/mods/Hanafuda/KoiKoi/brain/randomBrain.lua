--- baseline AI
---@class KoiKoi.RandomBrain : KoiKoi.IBrain
---@field koikoiChance number
---@field waitRange number[]? wait range
---@field timer number
---@field wait number?
local this = {}
local brain = require("Hanafuda.KoiKoi.brain.brain")
setmetatable(this, {__index = brain})

local koi = require("Hanafuda.KoiKoi.koikoi")
local logger = require("Hanafuda.logger")

---@class KoiKoi.RandomBrain.Params
---@field koikoiChance number?
---@field waitRange number[]?

---@param params KoiKoi.RandomBrain.Params
---@return KoiKoi.RandomBrain
function this.new(params)
    local instance = brain.new({
        --allowDiscard = false,
        koikoiChance = params.koikoiChance ~= nil and params.koikoiChance or 0.3,
        waitRange = params.waitRange,
        timer = 0,
        wait = nil,
    })
    ---@cast instance KoiKoi.RandomBrain
    setmetatable(instance, { __index = this })
    return instance
end

---@param self KoiKoi.RandomBrain
function this.Reset(self)
    self.timer = 0
    self.wait = nil
end

---comment
---@param cardId integer
---@param ground integer[]
---@return integer[]
local function Match(cardId, ground)
    local matched = {} ---@type integer[]
    for _, id in ipairs(ground) do
        if koi.CanMatchSuit(cardId, id) then
            table.insert(matched, id)
        end
    end
    return matched
end

---@param self KoiKoi.RandomBrain
---@param p KoiKoi.AI.Params
---@return KoiKoi.MatchCommand?
function this.Simulate(self, p)
    --[[
    if self.waitRange then
        if self.wait == nil then
            self.timer = 0
            self.wait = math.random() * (self.waitRange[2]- self.waitRange[1]) + self.waitRange[1]
            logger:trace(string.format("wait for %f seconds", self.wait))
        end
        if self.timer < self.wait then
            self.timer = self.timer + p.deltaTime
            return nil -- feigning thinking
        end
    end
    ]]

    if p.drawnCard then
        local matched = Match(p.drawnCard, p.groundPool)
        if table.size(matched) > 0 then
            local id = matched[math.random(1, table.size(matched))]
            logger:trace(string.format("match drawnCard = %d, matchedCard = %d", p.drawnCard, id))
            self.wait = nil
            return { selectedCard = p.drawnCard, matchedCard = id }
        end
        -- discard
        logger:trace(string.format("discard drawnCard = %d", p.drawnCard))
        self.wait = nil
        return { selectedCard = p.drawnCard, matchedCard = nil } -- discard
    else
        local allMatches = {} ---@type integer[][]
        for _, hand in ipairs(p.pool.hand) do
            local matched = Match(hand, p.groundPool)
            if table.size(matched) > 0 then
                table.insert(allMatches, matched)
            end
        end
        if table.size(allMatches) > 0 then
            local index = math.random(1, table.size(allMatches))
            local hand = p.pool.hand[index]
            local matched = allMatches[index]
            local id = matched[math.random(1, table.size(matched))]
            logger:trace(string.format("match selectedCard = %d, matchedCard = %d", hand, id))
            self.wait = nil
            return { selectedCard = hand, matchedCard = id }
        end

        -- discard
        if table.size(p.pool.hand) > 0 then
            local id = p.pool.hand[math.random(1, table.size(p.pool.hand))]
            logger:trace(string.format("discard selectedCard = %d", id))
            self.wait = nil
            return { selectedCard = id, matchedCard = nil } -- discard
        end
    end
    logger:trace("no hand, no drawn")
    self.wait = nil
    return { selectedCard = nil, matchedCard = nil } -- skip
end

--and current yaku
---@param self KoiKoi.RandomBrain
---@param p KoiKoi.AI.Params
---@return KoiKoi.CallCommand?
function this.Call(self, p)
    local k = math.random() < self.koikoiChance
    logger:trace(k and "koikoi" or "shobu")
    return { calling = k and koi.calling.koikoi or koi.calling.shobu }
end

return this
