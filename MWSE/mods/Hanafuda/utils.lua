---@class Utils
local this = {}
local i18n = mwse.loadTranslations("Hanafuda")

---@param mobile tes3mobileActor?
---@param defaultName string
---@return string
function this.GetActorName(mobile, defaultName)
    if mobile and mobile.reference and mobile.reference.object and mobile.reference.object.name then
        return mobile.reference.object.name
    end
    return defaultName
end

return this
