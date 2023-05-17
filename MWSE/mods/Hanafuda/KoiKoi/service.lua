local logger = require("Hanafuda.logger")

--umm
---@enum KoiKoi.Phase
local phase = {
    new = 1,
    initialized = 2,
    decidingParent = 3,
    decidedParent = 4,
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
}



--- aka controller
---@class KoiKoi.Service
---@field phase KoiKoi.Phase
---@field game KoiKoi
---@field view KoiKoi.UI
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
    }
    setmetatable(instance, { __index = Service })
    return instance
end

---@param self KoiKoi.Service
---@param next KoiKoi.Phase
---@return KoiKoi.Phase
function Service.Transition(self, next)
    self.phase = next
    return self.phase
end

---@param self KoiKoi.Service
---@return KoiKoi.Phase
function Service.TransitionNext(self)
    self:Transition(self.phase + 1)
    return self.phase
end

---comment
---@param self KoiKoi.Service
---@param e enterFrameEventData
function Service.OnEnterFrame(self, e)
    local state = {
        [phase.initialized] = function()
            logger:info("initialized")
            self.view:CreateDecidingParent(self)
            self:TransitionNext()
        end,
        [phase.decidedParent] = function()
            logger:info("inform parent")
            self.view:InformParent(self.game.parent) -- todo send opened card
            self:TransitionNext()
        end,
    }
    --logger:trace("phase ".. tostring(self.phase) )
    if state[self.phase] then
        state[self.phase]()
    end
end

local enterFrameCallback = nil ---@type fun(e : enterFrameEventData)?

---@param self KoiKoi.Service
function Service.Initialize(self)
    assert(self.phase == phase.new)
    logger:info("Begin Koi-Koi")
    assert(not enterFrameCallback)
    enterFrameCallback = function (e)
        self:OnEnterFrame(e)
    end
    event.register(tes3.event.enterFrame, enterFrameCallback)

    local brain = require("Hanafuda.KoiKoi.simplismBrain").new()
    -- todo set brain anywhere
    self.game:SetBrains(brain)
    self.game:SetBrains(brain, true) -- player
    self.game:Initialize()
    self.view:Initialize()
    self:TransitionNext()
end

---@param self KoiKoi.Service
function Service.Destory(self)
    if enterFrameCallback then
        event.unregister(tes3.event.enterFrame, enterFrameCallback)
        enterFrameCallback = nil
    end
    self.view:Shutdown()
    logger:info("Finished Koi-Koi")
end

---@param self KoiKoi.Service
---@param leftRight boolean
function Service.DecideParent(self, leftRight)
    self.game:DecideParent(leftRight)
    self:TransitionNext()
end

return Service
