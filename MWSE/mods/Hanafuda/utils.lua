local this = {}

---@param mobile tes3mobileActor?
---@param defaultName string?
---@return string
function this.GetNPCName(mobile, defaultName)
    if mobile and mobile.reference and mobile.reference.object and mobile.reference.object.name then
        return mobile.reference.object.name
    end
    return defaultName or "Opponent" -- placeholder
end

---@return string
function this.GetPlayerName()
    return this.GetNPCName(tes3.mobilePlayer, "Player")
end

return this
