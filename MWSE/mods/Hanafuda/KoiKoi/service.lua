local logger = require("Hanafuda.logger")
local koi = require("Hanafuda.KoiKoi.koikoi")
local card = require("Hanafuda.card")

--umm needs sub phase?
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
    matchCard = 9,
    drawCard = 10,
    endTurn = 11,
    -- roundSetup = 3,
    -- parentTurnBegin = 1,
    -- parentMatch = 1,
    -- parentDraw = 1,
    -- parentPlace = 1,
    -- parentCollect = 1,
    -- parentTurnEnd = 1,
    -- childTurnBegin = 1,
    -- childMatch = 1,
    -- childDraw = 1,
    -- childPlace = 1,
    -- childCollect = 1,
    -- childTurnEnd = 1,
    -- roundFinish = 1,
    -- finish = 1,

    -- waot state -- todo maybe need transition wait time
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
    if self.drawnCard == nil and table.size(self.game.deck) > 0 then
        return true
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
    -- todo and check phase
    if self.drawnCard and self.drawnCard == cardId then
        return true
    end
    return self.game:HasCard(self.game.current, cardId)
end

---@param self KoiKoi.Service
---@param cardId integer
---@return boolean
function Service.CanPutbackCard(self, cardId)
    -- todo and check phase
    return self.game:HasCard(self.game.current, cardId)
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
            local command = self.game:Simulate(self.game.current, nil)
            if command then
                -- todo com:Execute()
                -- todo view
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
                --self.drawnCard = nil
                --self:Next()
            end
        end,

        -- parentMatch = 9,
        -- parentDraw = 10,
        -- parentEnd = 11,

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

return Service
