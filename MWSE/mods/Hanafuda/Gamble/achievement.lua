---@diagnostic disable: undefined-doc-name
---@class Gamble.Achievement
local this = {}

local logger = require("Hanafuda.logger")

---@return boolean
local function IsEnabled()
    -- and settings
    return tes3.isLuaModActive("sb_achievements")
end

local function GetInterop()
    return include("sb_achievements.interop")
end

local function RegisterAchievements(interop)
    if not interop then
        return
    end
    local iconPath = "Icons\\sb_achievements_example\\"

    local category = {
        main = interop.registerCategory("Koi-Koi"),
    }

    local stats = require("Hanafuda.Gamble.statsAccessor")

    -- colour: red, yellow, green, blue, indigo, violet, white, black, {r / 255, g / 255, b / 255}
    interop.registerAchievement({
        id = "Hanafuda.KoiKoi.A1",
        category = category.main,
        condition = function()
            return stats.GetData().play > 0
        end,
        icon = iconPath .. "icn_A1_1_1.tga",
        title = "Welcome to Hanafuda!",
        desc = "Playing Koi-Koi for the first time.",
        -- optional
        colour = interop.colours.yellow,
        --configDesc = interop.configDesc.groupHidden
        --lockedDesc
    })

    --

    logger:info("Registered achievements")

end
---@param _ initializedEventData
local function OnInitialized(_)
    RegisterAchievements(GetInterop())
end

---@return boolean
function this.RegisterService()
    local interop = GetInterop()
    if interop then
        event.register(tes3.event.initialized, OnInitialized, { priority = interop.priority + 1 })
        return true
    end
    return false
end

return this
