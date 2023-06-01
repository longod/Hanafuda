---@class Utils
local this = {}
local i18n = mwse.loadTranslations("Hanafuda")

---@param mobile tes3mobileActor?
---@param defaultName string?
---@return string
function this.GetNPCName(mobile, defaultName)
    if mobile and mobile.reference and mobile.reference.object and mobile.reference.object.name then
        return mobile.reference.object.name
    end
    return defaultName or i18n("opponentDefaultName")
end

---@return string
function this.GetPlayerName()
    return this.GetNPCName(tes3.mobilePlayer, i18n("playerDefaultName"))
end

return this
