local koi = require("Hanafuda.KoiKoi.koikoi")
local card = require("Hanafuda.card")
local logger = require("Hanafuda.logger")

---@class KoiKoi.Runner
---@field game KoiKoi
---@field state integer
---@field round integer
---@field drawnCard integer?
local this = {}

---@param yourBrain KoiKoi.IBrain
---@param opponentBrain KoiKoi.IBrain
---@return KoiKoi.Runner
function this.new(yourBrain, opponentBrain)
    --@type KoiKoi.Runner
    local instance = {
        game = require("Hanafuda.KoiKoi.game").new(),
        state = 0,
        round = 1,
        drawnCard = nil,
    }
    setmetatable(instance, { __index = this })
    instance.game:SetBrains(opponentBrain)
    instance.game:SetBrains(yourBrain, true)
    return instance
end

---@param self KoiKoi.Runner
---@param next integer?
function this.Next(self, next)
    if not next then
        next = self.state + 1
    end
    self.state = next
    return self.state
end


---@param self KoiKoi.Runner
function this.Run(self)
    local func = {
        [0] = function ()
            logger:debug("Run")
            self.game:Initialize()
            self.game:DecideParent(math.random(1, 2) == 1)
            self.game:DealInitialCards()
            -- todo lucky hand
            self:Next()
        end,
        [1] = function()
            local command = self.game:Simulate(self.game.current)
            if command then
                -- todo com:Execute()
                if command.selectedCard and command.matchedCard then
                    -- match
                    self.game:Capture(self.game.current, command.selectedCard, false, true)
                    self.game:Capture(self.game.current, command.matchedCard, true, true)
                elseif not command.matchedCard then
                    -- discard
                    self.game:Discard(self.game.current, command.selectedCard, false)
                else
                    -- skip
                end
                self:Next()
            end
        end,
        [2] = function()
            -- state is optimizable
            self.drawnCard = card.DealCard(self.game.deck)
            self:Next()
        end,
        [3] = function()
            local command = self.game:Simulate(self.game.current, self.drawnCard)
            if command then
                -- todo com:Execute()
                if command.selectedCard and command.matchedCard then
                    -- match
                    self.game:Capture(self.game.current, command.selectedCard, false, true)
                    self.game:Capture(self.game.current, command.matchedCard, true, true)
                elseif not command.matchedCard then
                    -- discard
                    self.game:Discard(self.game.current, command.selectedCard, true)
                else
                    -- skip
                end
                self.drawnCard = nil
                self:Next()
            end
        end,
        [4] = function()
            -- todo cache
            -- fixme if called koi-koi the combination is subtract before combination
            local combo = self.game:CheckCombination(self.game.current)
            if combo then
                local command = self.game:Call(self.game.current, combo) -- todo send combination list
                if command then
                    if command.calling == koi.calling.koikoi then
                        -- continue
                        self:Next()
                    elseif command.calling == koi.calling.shobu then
                        -- finish
                        self:Next(99) -- fixme temp
                    end
                end
            else
                -- no comb
                self:Next()
            end
        end,
        [5] = function()
            if self.game:CheckEnd() then
                self:Next(100) -- fixme temp
            else
                self.game:SwapPlayer()
                self:Next(1)
            end
        end,
        [99] = function()
            -- self.game.current won
            -- add score
            -- round increment
            self:Next()
        end,
        [100] = function()
            -- add score
            -- round increment
            -- next
            self:Next()
        end,
    }
    if func[self.state] then
        func[self.state]()
        return true
    end
    logger:debug("Finished")
    return false
end

return this
