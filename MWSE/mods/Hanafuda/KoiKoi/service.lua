local logger = require("Hanafuda.logger")
local koi = require("Hanafuda.KoiKoi.koikoi")
local card = require("Hanafuda.card")

---@enum KoiKoi.Phase
local phase = {
    new = 1,
    initialized = 2,
    decidingParent = 3,
    decidedParent = 4,
    setupRound = 5,
    dealingInitial = 6,
    checkLuckyHand = 7,
    beginTurn = 8,
    matchCard = 9, -- rename
    matchCardFlip = 10, -- rename
    matchCardFlipWait = 11, -- rename
    matchCardWait = 12, -- rename
    drawCard = 13, -- rename
    drawCardWait = 14, -- rename
    matchDrawCard = 15, -- rename
    matchDrawCardWait = 16, -- rename
    checkCombo = 17,
    checkComboWait = 18,
    calling = 19,
    endTurn = 20,
    noMatch = 21,
    win = 22,
    roundFinished = 23,
    gameFinished = 24,
    resultWait = 25,
    terminate = 26,

    wait = 100,
}

--- aka controller
---@class KoiKoi.Service
---@field phase KoiKoi.Phase
---@field phaseNext KoiKoi.Phase
---@field game KoiKoi
---@field view KoiKoi.View
---@field drawnCard integer? or game has this
---@field skipDecidingParent boolean
---@field skipAnimation boolean
---@field lastCommand KoiKoi.ICommand?
---@field onExit fun(winner: KoiKoi.Player?)?
local Service = {}

---@param game KoiKoi
---@param view KoiKoi.View
---@param onExit fun(winner: KoiKoi.Player)?
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
    -- todo and check phase
    return self.game:CanMatch(cardId, targetId)
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
    -- todo and check phase
    return self.game:CanDiscard(cardId)
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
    self.phase = phase.wait
    -- todo when player input available, no wait
    timer.start({
        type = timer.real,
        ---@param e mwseTimerCallbackData
        callback = function(e)
            logger:trace("Transit Phase %d -> %d", self.phase, self.phaseNext)
            self.phase = self.phaseNext
        end,
        iterations = 1,
        duration = 0.5,
        persist = false,
    })
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
---@return boolean
function Service.CanPutbackCard(self, cardId)
    if self.game.current == koi.player.you and (self.phase == phase.matchCard or self.phase == phase.matchCardWait) then
        return self.game:HasCard(self.game.current, cardId)
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
            self.view:CreateDecidingParent(self)
        end,
        [phase.decidingParent] = function()
        end,
        [phase.decidedParent] = function()
            logger:info("inform parent %d", self.game.parent)
            self.view:InformParent(self.game.parent, self) -- todo send opened card or dice
        end,
        [phase.setupRound] = function()
            self:RequestPhase(phase.dealingInitial)
            self.game:SetCurrentPlayer(self.game.parent)
            self.game:DealInitialCards()
            self.view:DealInitialCards(self.game.parent, self.game.pools, self.game.groundPool, self.game.deck, self, self.skipAnimation)
        end,
        [phase.dealingInitial] = function()
            -- wait for view
        end,
        [phase.checkLuckyHand] = function()
            -- todo
            self:RequestPhase(phase.beginTurn)
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
            local command = self.game:Simulate(self.game.current, nil)
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
                self.view:Draw(self, self.game.current, draw, self.skipAnimation)
            else
                -- draw? prepare for view
                self:RequestPhase(phase.matchDrawCard)
            end
        end,
        [phase.drawCardWait] = function()
            -- waiting...
        end,
        [phase.matchDrawCard] = function()
            local command = self.game:Simulate(self.game.current, self.drawnCard)
            if command then
                -- todo com:Execute()
                -- todo view
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
                    -- skip?
                end

                --self:Next()
            else
                -- thinking or no brain
                -- if no brain
                -- tes3.messageBox("draw card and match it or discard")
                -- self:RequestPhase(phase.matchDrawCardWait)
            end
        end,
        [phase.matchDrawCardWait] = function()
        end,
        [phase.checkCombo] = function()
            local combo = self.game:CheckCombination(self.game.current)
            -- fixme if called koi-koi the combination is subtract before combination
            if combo then
                if self.game.brains[self.game.current] then
                    -- message? or other notify
                    self.view:ShowCombo(self.game.current, self, combo)
                else
                    self.view:ShowCallingDialog(self.game.current, self, combo) -- todo and combo
                end
                self:RequestPhase(phase.checkComboWait)
            else
                -- no comb
                self:RequestPhase(phase.endTurn)
            end
        end,
        [phase.checkComboWait] = function()
        end,
        [phase.calling] = function()
            local command = self.game:Call(self.game.current, self.game.combinations[self.game.current]) -- fixme use accessor
            if command then
                self.lastCommand = command
                self.view:ShowCalling(self.game.current, self, command.calling)
            end
        end,
        [phase.endTurn] = function()
            if self.game:CheckEnd() then
                self:RequestPhase(phase.noMatch)
            else
                self.game:SwapPlayer()
                self:RequestPhase(phase.beginTurn)
            end
        end,
        [phase.noMatch] = function()
            self.view:ShowNoMatch(self.game.parent, self)
            -- draw or parent win (house rule)
        end,
        [phase.win] = function()
            self.view:ShowWin(self.game.current, self)
            -- win current player
            self.game:SetRoundWinner(self.game.current)
            self.view:UpdateScorePoint(self.game.current, self.game.points[self.game.current])
        end,
        [phase.roundFinished] = function ()
            if self.game:NextRound() then
                -- clean up
                self.game:Initialize()
                self.view:CleanUpCards()
                self.view:UpdateRound(self.game.round, self.game.settings.round)
                self.view:UpdateParent(self.game.parent)
                self:RequestPhase(phase.decidedParent)
            else
                self:RequestPhase(phase.gameFinished)
            end
        end,
        [phase.gameFinished] = function ()
            self:RequestPhase(phase.resultWait)
            self.view:ShowResult(self, self.game:GetGameWinner())
        end,
        [phase.resultWait] = function ()
            -- waiting
        end,
        [phase.terminate] = function ()
            self:Exit(self.game:GetGameWinner())
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
    logger:debug("phase      = " .. tostring(self.phase))
    logger:debug("round      = " .. tostring(self.game.round))
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
end

local enterFrameCallback = nil ---@type fun(e : enterFrameEventData)?
local debugDumpCallback = nil ---@type fun(e : keyDownEventData)?

---@param self KoiKoi.Service
function Service.Initialize(self)
    assert(self.phase == phase.new)
    logger:info("Begin Koi-Koi")
    assert(not enterFrameCallback)
    enterFrameCallback = function (e)
        self:OnEnterFrame(e)
    end
    event.register(tes3.event.enterFrame, enterFrameCallback)
    debugDumpCallback = function (e)
        self:DumpData()
    end
    event.register(tes3.event.keyDown, debugDumpCallback, {filter = tes3.scanCode.d} )
    local brain = require("Hanafuda.KoiKoi.brain.simpleBrain").new()
    -- todo set brain anywhere
    self.game:SetBrains(brain)
    --self.game:SetBrains(brain, true) -- player
    self.game:Initialize()
    -- self.game.parent = koi.player.opponent -- testing
    -- self.game.current = koi.player.opponent -- testing
    self.view:Initialize(self)
    self.view:UpdateRound(self.game.round, self.game.settings.round)
    self.view:UpdateScorePoint(koi.player.you, self.game.points[koi.player.you])
    self.view:UpdateScorePoint(koi.player.opponent, self.game.points[koi.player.opponent])
    self:RequestPhase(self.skipDecidingParent and phase.decidedParent or phase.initialized )
end

---@param self KoiKoi.Service
function Service.Destory(self)
    if enterFrameCallback then
        event.unregister(tes3.event.enterFrame, enterFrameCallback)
        enterFrameCallback = nil
    end
    if debugDumpCallback then
        event.unregister(tes3.event.keyDown, debugDumpCallback, {filter = tes3.scanCode.d} )
        debugDumpCallback = nil
    end
    self.view:Shutdown()
    logger:info("Finished Koi-Koi")
end

---@param self KoiKoi.Service
---@param winner KoiKoi.Player?
---@return boolean
function Service.Exit(self, winner)
    logger:debug("Exit Koi-Koi" .. tostring(winner))
    if not winner then
        -- no game
    end

    -- callback or event trigger?
    if self.onExit then
        self.onExit(winner)
    end
    return true
end

---@param self KoiKoi.Service
---@param leftRight boolean
function Service.NotifyDecideParent(self, leftRight)
    self.game:DecideParent(leftRight)
    self:RequestPhase(phase.decidedParent)
end

---@param self KoiKoi.Service
function Service.NotifyInformParent(self)
    self:RequestPhase(phase.setupRound)
end

---@param self KoiKoi.Service
function Service.NotifyDealedInitialCards(self)
    self:RequestPhase(phase.checkLuckyHand)
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
    local match = self.phase >= phase.matchCard and self.phase <= phase.matchCardWait -- hmm...
    self:RequestPhase(match and phase.drawCard or phase.checkCombo)
end

---@param self KoiKoi.Service
function Service.NotifyDiscardCard(self)
    -- match or draw
    local match = self.phase >= phase.matchCard and self.phase <= phase.matchCardWait -- hmm...
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
