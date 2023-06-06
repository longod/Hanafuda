--- baseline AI
---@class KoiKoi.SimpleBrain : KoiKoi.IBrain
---@field waitRange number[]? wait range
---@field timer number
---@field wait number?
local this = {}
local brain = require("Hanafuda.KoiKoi.brain.brain")
setmetatable(this, {__index = brain})

local koi = require("Hanafuda.KoiKoi.koikoi")
local logger = require("Hanafuda.logger")

---@param waitRange number[]?
---@return KoiKoi.SimpleBrain
function this.new(waitRange)
    local instance = brain.new({
        waitRange = waitRange,
        timer = 0,
        wait = nil,
    })
    ---@cast instance KoiKoi.SimpleBrain
    setmetatable(instance, { __index = this })
    return instance
end

---@param self KoiKoi.SimpleBrain
function this.Reset(self)
    self.timer = 0
    self.wait = nil
end

---@param self KoiKoi.SimpleBrain
---@param p KoiKoi.AI.Params
---@return KoiKoi.MatchCommand?
function this.Simulate(self, p)
    -- move other brain
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
        for _, id in ipairs(p.groundPool) do
            if koi.CanMatchSuit(p.drawnCard, id) then
                logger:trace(string.format("match drawnCard = %d, matchedCard = %d", p.drawnCard, id))
                self.wait = nil
                return { selectedCard = p.drawnCard, matchedCard = id }
            end
        end
        logger:trace(string.format("discard drawnCard = %d", p.drawnCard))
        self.wait = nil
        return { selectedCard = p.drawnCard, matchedCard = nil } -- discard
    else
        for _, hand in ipairs(p.pool.hand) do
            for _, id in ipairs(p.groundPool) do
                if koi.CanMatchSuit(hand, id) then
                    logger:trace(string.format("match selectedCard = %d, matchedCard = %d", hand, id))
                    self.wait = nil
                    return { selectedCard = hand, matchedCard = id }
                end
            end
        end
        if table.size(p.pool.hand) > 0 then
            logger:trace(string.format("discard selectedCard = %d", p.pool.hand[1]))
            self.wait = nil
            return { selectedCard = p.pool.hand[1], matchedCard = nil } -- discard
        end
    end
    logger:trace("no hand, no drawn")
    self.wait = nil
    return { selectedCard = nil, matchedCard = nil } -- skip
end

--and current yaku
---@param self KoiKoi.SimpleBrain
---@param p KoiKoi.AI.Params
---@return KoiKoi.CallCommand?
function this.Call(self, p)
    logger:trace("always shobu")
    return { calling = koi.calling.shobu }
end

return this
