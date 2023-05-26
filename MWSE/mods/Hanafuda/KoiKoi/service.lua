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
    matchCardWait = 10, -- rename
    drawCard = 11, -- rename
    drawCardWait = 12, -- rename
    matchDrawCard = 13, -- rename
    matchDrawCardWait = 14, -- rename
    checkCombo = 15,
    checkComboWait = 16,
    calling = 17,
    endTurn = 18,
    noMatch = 19,
    roundFinish = 20,

    -- wait state -- todo maybe need transition wait time
}

--- aka controller
---@class KoiKoi.Service
---@field phase KoiKoi.Phase
---@field game KoiKoi
---@field view KoiKoi.UI
---@field drawnCard integer? or game has this
---@field skipDecidingParent boolean
---@field skipAnimation boolean
local Service = {}

---@param game KoiKoi
---@param view KoiKoi.UI
---@return KoiKoi.Service
function Service.new(game, view)
    --@type KoiKoi.Service
    local instance = {
        phase = phase.new,
        game = game,
        view = view,
        drawnCard = nil,
        skipDecidingParent = true, -- or table flags
        skipAnimation = true,
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

-- TODO need delay after end of everyframe, and waiting for game speed.
--- if it was called before main simulation logic, it is possible mismatch phase.
---@param self KoiKoi.Service
---@param next KoiKoi.Phase?
---@return KoiKoi.Phase
function Service.TransitPhase(self, next)
    local n = next or (self.phase + 1)
    logger:debug("Transit Phase %d -> %d", self.phase, n)
    self.phase = n
    return self.phase
end

---@param self KoiKoi.Service
---@return boolean
function Service.CanDrawCard(self)
    if self.game.current == koi.player.you and self.phase == phase.matchDrawCard then
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
    if self.game.current == koi.player.you and self.phase == phase.matchDrawCard then
        if self.drawnCard and self.drawnCard == cardId then
            return true
        end
    end
    if self.game.current == koi.player.you and self.phase == phase.matchCard then
        return self.game:HasCard(self.game.current, cardId)
    end
    return false
end

---@param self KoiKoi.Service
---@param cardId integer
---@return boolean
function Service.CanPutbackCard(self, cardId)
    if self.game.current == koi.player.you and self.phase == phase.matchCard then
        return self.game:HasCard(self.game.current, cardId)
    end
    return false
end


---comment
---@param self KoiKoi.Service
---@param e enterFrameEventData
function Service.OnEnterFrame(self, e)
    -- fixme Transitions should be triggered by notifications from the view.
    local state = {
        [phase.initialized] = function()
            logger:info("initialized")
            self.view:CreateDecidingParent(self)
            self:TransitPhase()
        end,
        [phase.decidedParent] = function()
            logger:info("inform parent")
            self.view:InformParent(self.game.parent) -- todo send opened card
            self:TransitPhase()
        end,
        [phase.setupRound] = function()
            self.game:DealInitialCards() -- todo animation
            self.view:DealInitialCards(self.game.parent, self.game.pools, self.game.groundPool, self.game.deck, self, self.skipAnimation)
            self:TransitPhase()
        end,
        [phase.dealingInitial] = function()
            -- wait for view
        end,
        [phase.checkLuckyHand] = function()
            -- todo
            self:TransitPhase()
        end,
        [phase.beginTurn] = function()
            self.view:BeginTurn(self.game.current, self.game.parent, self)
            --self:TransitPhase()
        end,
        [phase.matchCard] = function()
            -- Generally, this condition is not true. The deck is empty at the same time then game end. It occurs if player play simgle.
            if self.game:EmptyHand(self.game.current) then
                self:TransitPhase(phase.matchDrawCard)
                return
            end
            local command = self.game:Simulate(self.game.current, nil)
            if command then
                -- todo com:Execute()
                -- todo view
                self:TransitPhase() -- wait for view

                if command.selectedCard and command.matchedCard then
                    -- match
                    self.view:Capture(self, self.game.current, command.selectedCard, command.matchedCard, false, self.skipAnimation)
                    self:Capture(command.selectedCard, false)
                    self:Capture(command.matchedCard, true)
                elseif not command.matchedCard then
                    -- discard
                    self.view:Discard(self, self.game.current, command.selectedCard, false, self.skipAnimation)
                    self:Discard(command.selectedCard)
                else
                    -- skip?
                end
                --self.drawnCard = nil
            else
                -- thinking or no brain
            end
        end,
        [phase.matchCardWait] = function()
        end,
        [phase.drawCard] = function()
            if self.game.brains[self.game.current] then
                local draw = self:DrawCard()
                assert(draw)
                self:TransitPhase() -- wait for view
                self.view:Draw(self, self.game.current, draw, self.skipAnimation)
            else
                -- draw? prepare for view
                self:TransitPhase(phase.matchDrawCard)
            end
        end,
        [phase.drawCardWait] = function()
            -- waiting...
        end,
        [phase.matchDrawCard] = function()
            -- TODO draw card if non human
            local command = self.game:Simulate(self.game.current, self.drawnCard)
            if command then
                -- todo com:Execute()
                -- todo view
                self:TransitPhase() -- wait for view

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
            end
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
                self:TransitPhase(phase.checkComboWait)
            else
                -- no comb
                self:TransitPhase(phase.endTurn)
            end
        end,
        [phase.checkComboWait] = function()
        end,
        [phase.calling] = function()
            local command = self.game:Call(self.game.current, self.game.combinations[self.game.current]) -- fixme use accessor
            if command then
                if command.calling == koi.calling.koikoi then
                    -- todo view
                    self:NotifyKoiKoi()
                elseif command.calling == koi.calling.shobu then
                    -- todo view
                    self:NotifyShobu()
                end
            end
        end,
        [phase.endTurn] = function()
            if self.game:CheckEnd() then
                self:TransitPhase(phase.noMatch)
            else
                self.game:SwapPlayer()
                self:TransitPhase(phase.beginTurn)
            end
        end,
        [phase.noMatch] = function()
            -- draw or parent win (house rule)
        end,
        [phase.roundFinish] = function()
            -- win current player
        end,
    }
    --logger:trace("phase ".. tostring(self.phase) )
    if state[self.phase] then
        state[self.phase]()
    end
    -- after?
    self.view:OnEnterFrame(e)
end

---debugging
---@param self KoiKoi.Service
function Service.DumpData(self)
    logger:debug("phase      = " .. tostring(self.phase))
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
    local brain = require("Hanafuda.KoiKoi.simplismBrain").new()
    -- todo set brain anywhere
    self.game:SetBrains(brain)
    --self.game:SetBrains(brain, true) -- player
    self.game:Initialize()
    self.game.current = koi.player.opponent -- testing
    self.view:Initialize(self)
    self:TransitPhase(self.skipDecidingParent and phase.decidedParent or nil )
    -- todo skip deciding parent
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
---@param leftRight boolean
function Service.DecideParent(self, leftRight)
    self.game:DecideParent(leftRight)
    self:TransitPhase()
end

---@param self KoiKoi.Service
function Service.NotifyDealedInitialCards(self)
    self:TransitPhase(phase.checkLuckyHand)
end

---@param self KoiKoi.Service
function Service.NotifyBeganTurn(self)
    self:TransitPhase(phase.matchCard)
end

---@param self KoiKoi.Service
function Service.NotifyMatchedCards(self)
    -- match or draw
    local match = self.phase == phase.matchCard or self.phase == phase.matchCardWait -- hmm...
    self:TransitPhase(match and phase.drawCard or phase.checkCombo)
end

---@param self KoiKoi.Service
function Service.NotifyDiscardCard(self)
    -- match or draw
    local match = self.phase == phase.matchCard or self.phase == phase.matchCardWait -- hmm...
    self:TransitPhase(match and phase.drawCard or phase.checkCombo)
end

---@param self KoiKoi.Service
function Service.NotifyDrawCard(self)
    self:TransitPhase(phase.matchDrawCard)
end

---@param self KoiKoi.Service
function Service.NotifyComfirmCombo(self)
    self:TransitPhase(phase.calling)
end

---@param self KoiKoi.Service
function Service.NotifyKoiKoi(self)
    self:TransitPhase(phase.endTurn)
end

---@param self KoiKoi.Service
function Service.NotifyShobu(self)
    self:TransitPhase(phase.roundFinish)
end

return Service
