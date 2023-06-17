--- asset collection for 2D
---@class Hanafuda.CardAssetPackage
---@field assets CardAsset[]
---@field back CardAsset
local this = {}

---@param style string?
---@param styleBack string?
---@return Hanafuda.CardAssetPackage
function this.new(style, styleBack)
    local data = require("Hanafuda.cardData")
    styleBack = styleBack or style
    ---@type Hanafuda.CardAssetPackage
    local instance = {
        assets = data.BuildCardAsset(style),
        back = data.BuildCardBackAsset(styleBack),
    }
    setmetatable(instance, { __index = this })
    return instance
end

---@param self Hanafuda.CardAssetPackage
---@param cardId integer
---@return CardAsset
function this.GetAsset(self, cardId)
    return self.assets[cardId]
end

---@param self Hanafuda.CardAssetPackage
---@return CardAsset
function this.GetBackAsset(self)
    return self.back
end

return this
