local logger = require("Hanafuda.logger")
local koi = require("Hanafuda.KoiKoi.koikoi")
local card = require("Hanafuda.card")
local config = require("Hanafuda.config")

---@enum KoiKoi.Phase
local phase = {
    new = 1,
    initialized = 2,
    decidingParent = 10,
    decidedParent = 11,
    decidedParentWait = 12,
    setupRound = 20,
    dealingInitial = 21,
    checkLuckyHands = 22,
    luckyHandsWait = 23,
    beginTurn = 30,
    matchCard = 40, -- rename
    matchCardFlip = 41, -- rename
    matchCardFlipWait = 42, -- rename
    matchCardWait = 43, -- rename
    drawCard = 50, -- rename
    drawCardWait = 51, -- rename
    matchDrawCard = 52, -- rename
    matchDrawCardWait = 53, -- rename
    checkCombo = 60,
    checkComboWait = 61,
    calling = 70,
    callingWait = 71,
    endTurn = 72,
    noMatch = 80,
    win = 81,
    roundResultWait = 82,
    roundFinished = 83,
    gameFinished = 90,
    resultWait = 91,
    terminate = 100,

    wait = 1000,
}

---@class KoiKoi.ExitStatus
---@field winner KoiKoi.Player? tie is nil
---@field playerPoint integer
---@field opponentPoint integer
---@field conceding KoiKoi.Player?

--- aka controller
---@class KoiKoi.Service
---@field phase KoiKoi.Phase
---@field phaseNext KoiKoi.Phase
---@field game KoiKoi.Game
---@field view KoiKoi.View
---@field drawnCard integer? or game has this
---@field skipDecidingParent boolean
---@field skipAnimation boolean
---@field waitScale number
---@field lastCommand KoiKoi.ICommand?
---@field onExit fun(params : KoiKoi.ExitStatus)?
---@field enterFrameCallback fun(e : enterFrameEventData)?
---@field debugDumpCallback fun(e : keyDownEventData)?
local Service = {}

-- todo debug: hold key skip to deside parent
-- fixed deciding and more debugging function

---@param game KoiKoi.Game
---@param view KoiKoi.View
---@param onExit fun(params : KoiKoi.ExitStatus)?
---@return KoiKoi.Service
function Service.new(game, view, onExit)
    --@type KoiKoi.Service
    local instance = {
        phase = phase.new,
        phaseNext = phase.new,
        game = game,
        view = view,
        drawnCard = nil,
        skipDecidingParent = false, -- or table flags
        skipAnimation = true,
        waitScale = 1.0,
        lastCommand = nil,
        onExit = onExit,
    }
    setmetatable(instance, { __index = Service })
    return instance
end

---@param self KoiKoi.Service
---@param cardId integer
---@param targetId integer
---@return boolean
function Service.CanMatch(self, cardId, targetId)
    return self.game.current == koi.player.you and self.game:CanMatch(cardId, targetId)
end

---@param self KoiKoi.Service
---@param cardId integer
---@param ground boolean
function Service.Capture(self, cardId, ground)
    local drawn = self.drawnCard == cardId
    self.game:Capture(self.game.current, cardId, ground, drawn)
    if drawn then
        self.drawnCard = nil
    end
end

---@param self KoiKoi.Service
---@param cardId integer
---@return boolean
function Service.CanDiscard(self, cardId)
    return self.game.current == koi.player.you and self.game:CanDiscard(cardId)
end

---@param self KoiKoi.Service
---@param cardId integer
function Service.Discard(self, cardId)
    local drawn = self.drawnCard == cardId
    self.game:Discard(self.game.current, cardId, drawn)
    if drawn then
        self.drawnCard = nil
    end
end

---@param self KoiKoi.Service
---@param next KoiKoi.Phase
---@return KoiKoi.Phase
function Service.RequestPhase(self, next)
    local n = next or (self.phase + 1)
    logger:trace("Request Phase %d -> %d", self.phase, n)
    -- self.phase = n
    -- return self.phase
    self.phaseNext = n
    return self.phaseNext
end

---@param self KoiKoi.Service
---@return boolean
function Service.TransitPhase(self)
    if self.phase == self.phaseNext then
        return false
    end
    if self.phase == phase.wait then
        return false
    end
    local wait = 0.5 -- default wait
    -- specific wait
    local waitNext = {
        [phase.new] = 0,
        [phase.initialized] = 1, -- put cards for deciding parent
        [phase.decidingParent] = 1,
        [phase.decidedParent] = 1,
        [phase.decidedParentWait] = 1,
        [phase.setupRound] = 1,
        [phase.dealingInitial] = 1,
        -- [phase.checkLuckyHands] = 1,
        -- [phase.luckyHandsWait] = 1,
        -- [phase.beginTurn] = 0,
        -- [phase.matchCard] = 0,
        -- [phase.matchCardFlip] = 1,
        [phase.matchCardFlipWait] = 1.5,
        -- [phase.matchCardWait] = 0,
        [phase.drawCard] = 1,
        -- [phase.drawCardWait] = 0,
        [phase.matchDrawCard] = 1.5, -- acatial drawn card
        -- [phase.matchDrawCardWait] = 0,
        -- [phase.checkCombo] = 0,
        -- [phase.checkComboWait] = 0,
        -- [phase.calling] = 0,
        -- [phase.callingWait] = 0,
        -- [phase.endTurn] = 0,
        [phase.noMatch] = 2,
        [phase.win] = 2,
        [phase.roundResultWait] = 2,
        [phase.roundFinished] = 2,
        [phase.gameFinished] = 2,
        [phase.resultWait] = 2,
        [phase.terminate] = 0,
    }
    -- or use current phase
    if waitNext[self.phaseNext] ~= nil then
        wait = waitNext[self.phaseNext]
    end

    -- when player input available, no wait
    if self.game:HasBrain(self.game.current) == false then
        if phase.matchCard <= self.phaseNext and self.phaseNext <= phase.matchDrawCardWait then
            wait = 0
        end
    end

    wait = wait * self.waitScale

    if wait > 0 then
        self.phase = phase.wait
        timer.start({
            type = timer.real,
            ---@param e mwseTimerCallbackData
            callback = function(e)
                logger:trace("Transit Phase %d -> %d", self.phase, self.phaseNext)
                self.phase = self.phaseNext
            end,
            iterations = 1,
            duration = wait,
            persist = false,
        })
    else
        logger:trace("Transit Phase %d -> %d", self.phase, self.phaseNext)
        self.phase = self.phaseNext
    end

    return true
end

---@param self KoiKoi.Service
---@return boolean
function Service.CanDrawCard(self)
    if self.game.current == koi.player.you and (self.phase == phase.matchDrawCard or self.phase == phase.matchDrawCardWait) then
        if self.drawnCard == nil and not self.game:EmptyDeck() then
            return true
        end
    end
    return false
end


---@param self KoiKoi.Service
---@return integer?
function Service.DrawCard(self)
    if self.drawnCard == nil then
        self.drawnCard = self.game:DrawCard()
    end
    return self.drawnCard
end

---@param self KoiKoi.Service
---@param cardId integer
---@return boolean
function Service.CanGrabCard(self, cardId)
    if self.game.current == koi.player.you and (self.phase == phase.matchDrawCard or self.phase == phase.matchDrawCardWait) then
        if self.drawnCard and self.drawnCard == cardId then
            return true
        end
    end
    if self.game.current == koi.player.you and (self.phase == phase.matchCard or self.phase == phase.matchCardWait) then
        return self.game:HasCard(self.game.current, cardId)
    end
    return false
end

---@param self KoiKoi.Service
---@param cardId integer
---@param player KoiKoi.Player
---@return boolean
function Service.CanPutbackCard(self, cardId, player)
    if self.game.current == koi.player.you and (self.phase == phase.matchCard or self.phase == phase.matchCardWait) then
        return self.game:HasCard(player, cardId)
    end
    return false
end


---comment
---@param self KoiKoi.Service
---@param e enterFrameEventData
function Service.OnEnterFrame(self, e)
    local state = {
        [phase.initialized] = function()
            logger:info("initialized")
            self:RequestPhase(phase.decidingParent)
            local cards = self.game:ChoiceDecidingParentCards(2)
            self.view:CreateDecidingParent(self, cards[1], cards[2])
        end,
        [phase.decidingParent] = function()
            -- wait for input
        end,
        [phase.decidedParent] = function()
            logger:info("inform parent %d", self.game.parent)
            self:RequestPhase(phase.decidedParentWait)
            local cards = self.game.decidingParent
            self.view:InformParent(self.game.parent, self, self.game.decidingParentCardId, cards[1], cards[2])
        end,
        [phase.decidedParentWait] = function()
            -- wait for view
        end,
        [phase.setupRound] = function()
            self:RequestPhase(phase.dealingInitial)
            self.game:SetCurrentPlayer(self.game.parent)
            self.game:DealInitialCards()
            -- todo show round info somewhere if need
            self.view:DealInitialCards(self.game.parent, self.game.pools, self.game.groundPool, self.game.deck, self, self.skipAnimation)
        end,
        [phase.dealingInitial] = function()
            -- wait for view
        end,
        [phase.checkLuckyHands] = function()
            local lh0, total0 = self.game:CheckLuckyHands(koi.player.you)
            local lh1, total1 = self.game:CheckLuckyHands(koi.player.opponent)
            -- test data
            -- lh0 = {
            --     [koi.luckyHands.fourOfAKind] = 6,
            --     [koi.luckyHands.fourPairs] = 6,
            -- }
            -- total0 = 12
            -- lh1 = {
            --     --[koi.luckyHands.fourOfAKind] = 6,
            --     [koi.luckyHands.fourPairs] = 6,
            -- }
            -- total1 = 6

            -- todo in game?
            if lh0 or lh1 then
                self:RequestPhase(phase.luckyHandsWait)
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
                self.view:ShowLuckyHands({[koi.player.you] = lh0, [koi.player.opponent] = lh1}, points, winner, self)
                if not tie then
                    -- No transition to win, so we settle here.
                    self.game:SetRoundWinnerByLuckyHands(winner, points[winner])
                    self.view:UpdateScorePoint(winner, self.game.points[winner])
                end
            else
                self:RequestPhase(phase.beginTurn)
            end
        end,
        [phase.luckyHandsWait] = function()
        end,
        [phase.beginTurn] = function()
            self.view:BeginTurn(self.game.current, self.game.parent, self)
            --self:TransitPhase()
        end,
        [phase.matchCard] = function()
            if self.game:EmptyHand(self.game.current) then
                self:RequestPhase(phase.drawCard)
                return
            end
            local command = self.game:Simulate(self.game.current, nil, e.delta, e.timestamp)
            if command then
                -- first flip card
                self.lastCommand = command
                -- todo com:Execute()
                if command.selectedCard then
                    self:RequestPhase(phase.matchCardFlip) -- wait for view
                    self.view:Flip(self, self.game.current, command.selectedCard, self.skipAnimation)

                    if command.matchedCard then
                        -- match
                        self:Capture(command.selectedCard, false)
                        self:Capture(command.matchedCard, true)
                    else
                        -- discard
                        self:Discard(command.selectedCard)
                    end
                else
                    -- error?
                end
            else
                -- thinking or no brain
                -- if no brain
                -- tes3.messageBox("match in your hand or discard")
                -- self:RequestPhase(phase.matchCardWait)
                self.view:ThinkMatchingHand(self.game.current, e.delta);
            end
        end,
        [phase.matchCardFlip] = function()
            -- wait view
        end,
        [phase.matchCardFlipWait] = function()
            if self.lastCommand then
                local command = self.lastCommand ---@cast command KoiKoi.MatchCommand
                if command.selectedCard then
                    self:RequestPhase(phase.matchCardWait) -- wait for view

                    if command.matchedCard then
                        -- match
                        self.view:Capture(self, self.game.current, command.selectedCard, command.matchedCard, false, self.skipAnimation)
                    else
                        -- discard
                        self.view:Discard(self, self.game.current, command.selectedCard, false, self.skipAnimation)
                    end
                else
                    -- error?
                end
            end
        end,
        [phase.matchCardWait] = function()
            -- wait view
        end,
        [phase.drawCard] = function()
            if self.game.brains[self.game.current] then
                local draw = self:DrawCard()
                assert(draw)
                self:RequestPhase(phase.drawCardWait) -- wait for view
                self.view:Draw(self, self.game.current, draw, self.game:EmptyDeck(), self.skipAnimation)
            else
                -- draw? prepare for view
                self:RequestPhase(phase.matchDrawCard)
            end
        end,
        [phase.drawCardWait] = function()
            -- waiting...
        end,
        [phase.matchDrawCard] = function()
            local command = self.game:Simulate(self.game.current, self.drawnCard, e.delta, e.timestamp)
            if command then
                -- todo com:Execute()
                self:RequestPhase(phase.matchDrawCardWait) -- wait for view

                if command.selectedCard and command.matchedCard then
                    -- match
                    self.view:Capture(self, self.game.current, command.selectedCard, command.matchedCard, true, self.skipAnimation)
                    self:Capture(command.selectedCard, false)
                    self:Capture(command.matchedCard, true)
                    assert(not self.drawnCard)
                elseif not command.matchedCard then
                    -- discard
                    self.view:Discard(self, self.game.current, command.selectedCard, true, self.skipAnimation)
                    self:Discard(command.selectedCard)
                    assert(not self.drawnCard)
                else
                    -- error
                    logger:error("wrong command for drawn card")
                end

                --self:Next()
            else
                -- thinking or no brain
                -- if no brain
                -- tes3.messageBox("draw card and match it or discard")
                -- self:RequestPhase(phase.matchDrawCardWait)
                self.view:ThinkMatchingDrawn(self.game.current, e.delta)
            end
        end,
        [phase.matchDrawCardWait] = function()
        end,
        [phase.checkCombo] = function()
            local combo = self.game:CheckCombination(self.game.current)
            if combo then
                self:RequestPhase(phase.checkComboWait)
                local basePoint, multiplier = self.game:CalculateRoundPoint(self.game.current)
                if self.game.brains[self.game.current] then
                    -- message? or other notify
                    self.view:ShowCombo(self.game.current, self, combo, basePoint, multiplier)
                else
                    self.view:ShowCallingDialog(self.game.current, self, combo, basePoint, multiplier)
                end
            else
                -- no comb
                self:RequestPhase(phase.endTurn)
            end
        end,
        [phase.checkComboWait] = function()
            -- wait for pc calling
            self.view:ThinkCalling(self.game.current, e.delta);
        end,
        [phase.calling] = function()
            local command = self.game:Call(self.game.current, self.game.combinations[self.game.current], e.delta, e.timestamp)
            if command then
                self:RequestPhase(phase.callingWait)
                self.lastCommand = command
                local basePoint, multiplier = self.game:CalculateRoundPoint(self.game.current)
                self.view:ShowCalling(self.game.current, self, command.calling, basePoint * multiplier)
            else
                self.view:ThinkCalling(self.game.current, e.delta);
            end
        end,
        [phase.callingWait] = function()
            -- wait view
        end,
        [phase.endTurn] = function()
            if self.game:CheckEnd() then
                -- TODO test
                self:RequestPhase(phase.noMatch)
            else
                self.game:SwapPlayer()
                self:RequestPhase(phase.beginTurn)
            end
        end,
        [phase.noMatch] = function()
            self:RequestPhase(phase.roundResultWait)
            self.view:ShowNoMatch(self.game.parent, self)
            -- TODO draw or parent win (house rule)
        end,
        [phase.win] = function()
            self:RequestPhase(phase.roundResultWait)
            self.view:ShowWin(self.game.current, self)
            -- win current player
            self.game:SetRoundWinner(self.game.current)
            self.view:UpdateScorePoint(self.game.current, self.game.points[self.game.current])
        end,
        [phase.roundResultWait] = function()
            --wait
        end,
        [phase.roundFinished] = function ()
            if self.game:NextRound() then
                -- clean up
                self.game:Initialize()
                self.view:CleanUpCards()
                self.view:UpdateRound(self.game.round, self.game.settings.round)
                self.view:UpdateParent(self.game.parent)
                self:RequestPhase(phase.setupRound)
            else
                self:RequestPhase(phase.gameFinished)
            end
        end,
        [phase.gameFinished] = function ()
            self:RequestPhase(phase.resultWait)
            self.view:ShowResult(self, self.game:GetGameWinner(), self.game.points)
        end,
        [phase.resultWait] = function ()
            -- waiting
        end,
        [phase.terminate] = function ()
            self:Exit(false)
        end,
    }
    --logger:trace("phase ".. tostring(self.phase) )
    if state[self.phase] then
        state[self.phase]()
    end
    -- after?
    self.view:OnEnterFrame(e)

    self:TransitPhase()
end

---debugging
---@param self KoiKoi.Service
function Service.DumpData(self)
    logger:debug("phase       = " .. tostring(self.phase))
    logger:debug("round       = " .. tostring(self.game.round))
    logger:debug("parent      = " .. tostring(self.game.parent))
    logger:debug("current     = " .. tostring(self.game.current))
    logger:debug("drawn       = " .. tostring(self.drawnCard))
    logger:debug("you         = %d:{%s}", table.size(self.game.pools[koi.player.you].hand), table.concat(self.game.pools[koi.player.you].hand, ", "))
    logger:debug("     bright = %d:{%s}", table.size(self.game.pools[koi.player.you][card.type.bright]), table.concat(self.game.pools[koi.player.you][card.type.bright], ", "))
    logger:debug("     animal = %d:{%s}", table.size(self.game.pools[koi.player.you][card.type.animal]), table.concat(self.game.pools[koi.player.you][card.type.animal], ", "))
    logger:debug("     ribbon = %d:{%s}", table.size(self.game.pools[koi.player.you][card.type.ribbon]), table.concat(self.game.pools[koi.player.you][card.type.ribbon], ", "))
    logger:debug("      chaff = %d:{%s}", table.size(self.game.pools[koi.player.you][card.type.chaff]), table.concat(self.game.pools[koi.player.you][card.type.chaff], ", "))
    logger:debug("opponent    = %d:{%s}", table.size(self.game.pools[koi.player.opponent].hand), table.concat(self.game.pools[koi.player.opponent].hand, ", "))
    logger:debug("     bright = %d:{%s}", table.size(self.game.pools[koi.player.opponent][card.type.bright]), table.concat(self.game.pools[koi.player.opponent][card.type.bright], ", "))
    logger:debug("     animal = %d:{%s}", table.size(self.game.pools[koi.player.opponent][card.type.animal]), table.concat(self.game.pools[koi.player.opponent][card.type.animal], ", "))
    logger:debug("     ribbon = %d:{%s}", table.size(self.game.pools[koi.player.opponent][card.type.ribbon]), table.concat(self.game.pools[koi.player.opponent][card.type.ribbon], ", "))
    logger:debug("      chaff = %d:{%s}", table.size(self.game.pools[koi.player.opponent][card.type.chaff]), table.concat(self.game.pools[koi.player.opponent][card.type.chaff], ", "))
    logger:debug("ground      = %d:{%s}", table.size(self.game.groundPool), table.concat(self.game.groundPool, ", "))
    logger:debug("deck        = %d:{%s}", table.size(self.game.deck), table.concat(self.game.deck, ", "))
    logger:debug("points      = {%s}", table.concat(self.game.points, ", "))
    logger:debug("calls       = {%s}", table.concat(self.game.calls, ", "))
end


---@param self KoiKoi.Service
function Service.Initialize(self)
    assert(self.phase == phase.new)
    logger:info("Begin Koi-Koi")
    assert(not self.enterFrameCallback)
    self.enterFrameCallback = function (e)
        self:OnEnterFrame(e)
    end
    event.register(tes3.event.enterFrame, self.enterFrameCallback)
    if config.development.debug then
        self.debugDumpCallback = function (e)
            self:DumpData()
        end
        event.register(tes3.event.keyDown, self.debugDumpCallback, {filter = tes3.scanCode.d} )
    end
    self.game:Initialize()
    self.view:Initialize(self)
    self.view:UpdateRound(self.game.round, self.game.settings.round)
    self.view:UpdateScorePoint(koi.player.you, self.game.points[koi.player.you])
    self.view:UpdateScorePoint(koi.player.opponent, self.game.points[koi.player.opponent])
    self:RequestPhase(self.skipDecidingParent and phase.decidedParent or phase.initialized )
end

---@param self KoiKoi.Service
function Service.Destory(self)
    if self.enterFrameCallback then
        event.unregister(tes3.event.enterFrame, self.enterFrameCallback)
        self.enterFrameCallback = nil
    end
    if self.debugDumpCallback then
        event.unregister(tes3.event.keyDown, self.debugDumpCallback, {filter = tes3.scanCode.d} )
        self.debugDumpCallback = nil
    end
    self.view:Shutdown()
    logger:info("Finished Koi-Koi")
end

---@param self KoiKoi.Service
---@param giveup boolean
---@return boolean
function Service.Exit(self, giveup)
    local winner = self.game:GetGameWinner()
    logger:debug("Exit Koi-Koi " .. tostring(winner))

    -- callback or event trigger?
    if self.onExit then
        local pp = self.game.points[koi.player.you]
        local op = self.game.points[koi.player.opponent]
        local conceding = giveup and (koi.player.you) or nil
        self.onExit({ winner = winner, playerPoint = pp, opponentPoint = op, conceding = conceding })
        return true
    end
    return false
end

---@param self KoiKoi.Service
---@param player KoiKoi.Player
---@return integer[]
function Service.GetPlayerHand(self, player)
    return self.game.pools[player].hand
end

---@param self KoiKoi.Service
---@param selectedCardId integer
function Service.NotifyDecideParent(self, selectedCardId)
    self.game:DecideParent(selectedCardId)
    self:RequestPhase(phase.decidedParent)
end

---@param self KoiKoi.Service
function Service.NotifyInformParent(self)
    self:RequestPhase(phase.setupRound)
end

---@param self KoiKoi.Service
function Service.NotifyDealedInitialCards(self)
    self:RequestPhase(phase.checkLuckyHands)
end

---@param self KoiKoi.Service
function Service.NotifyLuckyHands(self)
    self:RequestPhase(phase.roundFinished)
end

---@param self KoiKoi.Service
function Service.NotifyBeganTurn(self)
    self:RequestPhase(phase.matchCard)
end

---@param self KoiKoi.Service
function Service.NotifyFlipCard(self)
    self:RequestPhase(phase.matchCardFlipWait)
end

---@param self KoiKoi.Service
function Service.NotifyMatchedCards(self)
    -- match or draw
    local match = self.phase >= phase.matchCard and self.phase <= phase.matchCardWait -- fixme bad conditions
    self:RequestPhase(match and phase.drawCard or phase.checkCombo)
end

---@param self KoiKoi.Service
function Service.NotifyDiscardCard(self)
    -- match or draw
    local match = self.phase >= phase.matchCard and self.phase <= phase.matchCardWait -- fixme bad conditions
    self:RequestPhase(match and phase.drawCard or phase.checkCombo)
end

---@param self KoiKoi.Service
function Service.NotifyDrawCard(self)
    self:RequestPhase(phase.matchDrawCard)
end

---@param self KoiKoi.Service
function Service.NotifyComfirmCombo(self)
    self:RequestPhase(phase.calling)
end

---@param self KoiKoi.Service
function Service.NotifyKoiKoi(self)
    -- Including logic in notify is not a good idea.
    self.game:AddKoiKoiCount(self.game.current)
    self:RequestPhase(phase.endTurn)
end

---@param self KoiKoi.Service
function Service.NotifyShobu(self)
    self:RequestPhase(phase.win)
end

---@param self KoiKoi.Service
---@param calling KoiKoi.Calling
function Service.NotifyCalling(self, calling)
    if calling == koi.calling.koikoi then
        self:NotifyKoiKoi()
    elseif calling == koi.calling.shobu then
        self:NotifyShobu()
    end
end

---@param self KoiKoi.Service
function Service.NotifyRoundFinished(self)
    self:RequestPhase(phase.roundFinished)
end

---@param self KoiKoi.Service
function Service.NotifyTerminate(self)
    self:RequestPhase(phase.terminate)
end

return Service
