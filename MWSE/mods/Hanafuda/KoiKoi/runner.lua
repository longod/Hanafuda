local koi = require("Hanafuda.KoiKoi.koikoi")
local card = require("Hanafuda.card")
local logger = require("Hanafuda.logger")

---@class KoiKoi.Runner
---@field game KoiKoi
---@field state integer
---@field round integer
---@field drawnCard integer?
local this = {}

---@param opponentBrain KoiKoi.IBrain
---@param playerBrain KoiKoi.IBrain
---@return KoiKoi.Runner
function this.new(opponentBrain, playerBrain)
    --@type KoiKoi.Runner
    local instance = {
        game = require("Hanafuda.KoiKoi.game").new(
            require("Hanafuda.config").koikoi,
            opponentBrain,
            playerBrain
        ),
        state = 0,
        round = 1,
        drawnCard = nil,
    }
    setmetatable(instance, { __index = this })
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
            local choices = self.game:ChoiceDecidingParentCards(2)
            self.game:DecideParent(choices[1])
            self.game:DealInitialCards()
            local lh0, total0 = self.game:CheckLuckyHands(koi.player.you)
            local lh1, total1 = self.game:CheckLuckyHands(koi.player.opponent)

            -- todo in game?
            if lh0 or lh1 then
                local tie = lh0 ~= nil and lh1 ~= nil
                local winner = nil
                if not tie then
                    if lh0 then
                        winner = koi.player.you
                    else
                        winner = koi.player.opponent
                    end
                end
                local points = {[koi.player.you] = total0, [koi.player.opponent] = total1}
                if not tie then
                    -- No transition to win, so we settle here.
                    self.game:SetRoundWinnerByLuckyHands(winner, points[winner])
                    self:Next(99)
                end
            else
                self:Next()
            end
        end,
        [1] = function()
            local command = self.game:Simulate(self.game.current, nil, 1, 0)
            if command then
                -- todo com:Execute()
                if command.selectedCard and command.matchedCard then
                    -- match
                    if not koi.CanMatchSuit(command.selectedCard, command.matchedCard) then
                        logger:error("wrong matching %d %d", command.selectedCard, command.matchedCard)
                    end
                    self.game:Capture(self.game.current, command.selectedCard, false, false)
                    self.game:Capture(self.game.current, command.matchedCard, true, false)
                elseif not command.matchedCard then
                    -- discard
                    for _, cardId in ipairs(self.game.groundPool) do
                        if koi.CanMatchSuit(command.selectedCard, cardId) then
                            logger:error("wrong discarding %d, it can match %d", command.selectedCard, cardId)
                        end
                    end
                    self.game:Discard(self.game.current, command.selectedCard, false)
                else
                    -- skip
                    if table.size(self.game.pools[self.game.current].hand) > 0 then
                        logger:error("wrong command, must be choice card in hand")
                    end
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
            local command = self.game:Simulate(self.game.current, self.drawnCard, 1, 0)
            if command then
                -- todo com:Execute()
                if command.selectedCard and command.matchedCard then
                    -- match
                    if not koi.CanMatchSuit(command.selectedCard, command.matchedCard) then
                        logger:error("wrong matching %d %d", command.selectedCard, command.matchedCard)
                    end
                    self.game:Capture(self.game.current, command.selectedCard, false, true)
                    self.game:Capture(self.game.current, command.matchedCard, true, true)
                elseif not command.matchedCard then
                    -- discard
                    for _, cardId in ipairs(self.game.groundPool) do
                        if koi.CanMatchSuit(command.selectedCard, cardId) then
                            logger:error("wrong discarding %d, it can match %d", command.selectedCard, cardId)
                        end
                    end
                    self.game:Discard(self.game.current, command.selectedCard, true)
                else
                    -- skip
                    if self.drawnCard then
                        logger:error("wrong command, must be matching or discard %d", self.drawnCard)
                    else
                        logger:error("wrong drawnCard is nil")
                    end
                end
                self.drawnCard = nil
                local combo = self.game:CheckCombination(self.game.current)
                if combo then
                    self:Next()
                else
                    self:Next(5)
                end
            end
        end,
        [4] = function()
            local combo = self.game.combinations[self.game.current]
            if combo then
                local command = self.game:Call(self.game.current, self.game.combinations[self.game.current], 1, 0)
                if command then
                    if command.calling == koi.calling.koikoi then
                        -- continue
                        self:Next()
                    elseif command.calling == koi.calling.shobu then
                        -- finish
                        self:Next(99)
                    end
                end
            else
                -- no comb
                logger:error("wrong state")
                self:Next()
            end
        end,
        [5] = function()
            if self.game:CheckEnd() then
                self:Next(100)
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
    -- todo output statics. brain, winner, turn, point, combo, koikoi count, etc...
    return false
end

return this
