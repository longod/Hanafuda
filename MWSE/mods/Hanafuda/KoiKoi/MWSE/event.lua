---@class KoiKoi.EventHandler
---@field service KoiKoi.Service?
---@field enterFrameCallback fun(e : enterFrameEventData)?
---@field debugDumpCallback fun(e : keyDownEventData)?
local this = {}

---@param service KoiKoi.Service
---@return KoiKoi.EventHandler
function this.new(service)
    --@type KoiKoi.Event
    local instance = {
        service = service,
    }
    setmetatable(instance, { __index = this })
    return instance
end

---@param self KoiKoi.EventHandler
function this.Register(self)
    if not self.service then
        return
    end
    local config = require("Hanafuda.config")

    assert(not self.enterFrameCallback)
    self.enterFrameCallback = function (e)
        self.service:OnEnterFrame(e.delta, e.timestamp)
    end
    event.register(tes3.event.enterFrame, self.enterFrameCallback)
    if config.development.debug then
        assert(not self.debugDumpCallback)
        self.debugDumpCallback = function (_)
            self.service:DumpData()
        end
        event.register(tes3.event.keyDown, self.debugDumpCallback, {filter = tes3.scanCode.d} )
    end
end

---@param self KoiKoi.EventHandler
function this.Unregister(self)
    if self.enterFrameCallback then
        event.unregister(tes3.event.enterFrame, self.enterFrameCallback)
        self.enterFrameCallback = nil
    end
    if self.debugDumpCallback then
        event.unregister(tes3.event.keyDown, self.debugDumpCallback, {filter = tes3.scanCode.d} )
        self.debugDumpCallback = nil
    end
end

---@param self KoiKoi.EventHandler
function this.Initialize(self)
    self.service:Initialize()
    self:Register()
end

---@param self KoiKoi.EventHandler
function this.Destory(self)
    self:Unregister()
    self.service:Destory()
    self.service = nil
end


return this
