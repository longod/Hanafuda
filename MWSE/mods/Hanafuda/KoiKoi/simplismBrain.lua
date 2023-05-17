--- baseline AI
---@class KoiKoi.SimplismBrain : KoiKoi.IBrain
local this = {}

local card = require("Hanafuda.card")
local koi = require("Hanafuda.KoiKoi.koikoi")
local logger = require("Hanafuda.logger")

---@return KoiKoi.SimplismBrain
function this.new()
    local instance = {} ---@type KoiKoi.SimplismBrain
    -- todo setmetatable interface
    setmetatable(instance, { __index = this })
    return instance
end

---@param self KoiKoi.SimplismBrain
---@param p KoiKoi.AI.Params
---@return KoiKoi.MatchCommand?
function this.Simulate(self, p)
    if p.drawnCard then
        for _, id in ipairs(p.groundPool) do
            if card.CanMatchSuit(p.drawnCard, id) then
                logger:debug(string.format("match selectedCard = %d, matchedCard = %d", p.drawnCard, id))
                return { selectedCard = p.drawnCard, matchedCard = id }
            end
        end
        logger:debug(string.format("discard drawnCard = %d", p.drawnCard))
        return { selectedCard = p.drawnCard, matchedCard = nil } -- discard
    else
        for _, hand in ipairs(p.pool.hand) do
            for _, id in ipairs(p.groundPool) do
                if card.CanMatchSuit(hand, id) then
                    logger:debug(string.format("match selectedCard = %d, matchedCard = %d", hand, id))
                    return { selectedCard = hand, matchedCard = id }
                end
            end
        end
        if table.size(p.pool.hand) > 0 then
            logger:debug(string.format("discard selectedCard = %d", p.pool.hand[1]))
            return { selectedCard = p.pool.hand[1], matchedCard = nil } -- discard
        end
    end
    logger:debug("no hand, no drawn")
    return { selectedCard = nil, matchedCard = nil } -- skip
end

--and current yaku
---@param self KoiKoi.SimplismBrain
---@param p KoiKoi.AI.Params
---@return KoiKoi.CallCommand?
function this.Call(self, p)
    logger:debug("always shobu")
    return { calling = koi.calling.shobu }
end

return this
