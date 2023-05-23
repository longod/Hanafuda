local this = {}

---@param mobile tes3mobileActor?
---@param defaultName string?
---@return string
function this.GetNPCName(mobile, defaultName)
    if mobile and mobile.reference and mobile.reference.object and mobile.reference.object.name then
        return mobile.reference.object.name
    end
    return defaultName or "Dunmer" -- placeholder
end

---@return string
function this.GetPlayerName()
    return this.GetNPCName(tes3.mobilePlayer, "Outlander")
end

return this
