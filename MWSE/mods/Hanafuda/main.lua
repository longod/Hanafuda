local config = require("Hanafuda.config")

---@param _ initializedEventData
local function OnInitialized(_)
    if config.development.debug then
        require("Hanafuda.debug")
    end

    require("Hanafuda.Gamble.service")

end
event.register(tes3.event.initialized, OnInitialized)
dofile("Hanafuda/mcm.lua")

-- unittest
if config.development.unittest then
    dofile("Hanafuda/test.lua")
    dofile("Hanafuda/KoiKoi/test.lua")
    dofile("Hanafuda/Gamble/test.lua")
end

--- HACK Since the annotation are not defined in MWSE, this is to supress the warning caused by this.
--- @class tes3scriptVariables
