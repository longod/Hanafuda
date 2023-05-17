---@class KoiKoi.IBrain
local this = {}

---@class KoiKoi.ICommand
---@field Execute fun(self)

---@class KoiKoi.MatchCommand : KoiKoi.ICommand
---@field selectedCard integer
---@field matchedCard integer? if nil means discard

---@class KoiKoi.CallCommand : KoiKoi.ICommand
---@field calling KoiKoi.Calling

---@class KoiKoi.AI.Params
---@field drawnCard integer? if it is not nil, you must use this.
---@field pool KoiKoi.PlayerPool your card pools
---@field opponentPool KoiKoi.PlayerPool eval for scoreing combinations, but peeping hand is cheating
---@field groundPool  integer[] placed card pools
---@field deck integer[] for cheating
-- + current combination

--- simulate on every frame
---@param self KoiKoi.IBrain
---@param p KoiKoi.AI.Params
---@return KoiKoi.MatchCommand?
function this.Simulate(self, p)
end

--- Call koikoi or shobu
---@param self KoiKoi.IBrain
---@param p KoiKoi.AI.Params
---@return KoiKoi.CallCommand?
function this.Call(self, p)
end

return this
