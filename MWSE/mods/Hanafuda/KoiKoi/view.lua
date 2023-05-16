local card = require("Hanafuda.card")

local this = {}

function this.ShowCallingDialog()
    tes3ui.showMessageMenu {
        -- id = "Calling",
        header = "Calling",
        message = "here scoring combinations",
        buttons = {
            -- todo tooltips
            {
                text = "Koi-koi",
                callback = function()
                    -- todo
                end
            },
            {
                text = "Shobu",
                callback = function()
                    -- todo
                end
            },
        }
    }
end

---@param cardId integer
---@param backface boolean
---@return tes3uiElement?
function this.CreateCardTooltip(cardId, backface)
    local tooltip = tes3ui.createTooltipMenu()
    if backface then
        tooltip:createLabel { text = "Opponent's card" }
    else
        tooltip = tes3ui.createTooltipMenu()
        local asset = card.GetCardAsset(cardId)
        local thumb = tooltip:createImage({ path = asset.path })
        thumb.width = card.GetCardWidth() * 2
        thumb.height = card.GetCardHeight() * 2
        thumb.scaleMode = true
        local ref = card.GetCardData(cardId)
        local name = tooltip:createLabel({ text = card.GetCardText(cardId).name })
        name.color = card.GetCardTypeColor(ref.type)
        tooltip:createLabel({ text = card.GetCardSuitText(ref.suit).name .. " (" .. tostring(ref.suit) .. ")" })
        tooltip:createLabel({ text = card.GetCardTypeText(ref.type).name })
        -- todo add flavor text
    end
    return tooltip
end

---@param deck integer[]
---@return tes3uiElement tooltip
function this.CreateDeckTooltip(deck)
    local tooltip = tes3ui.createTooltipMenu()
    local label = tooltip:createLabel({ text = tostring(table.size(deck)) .. " cards remaining" })
    label.color = tes3ui.getPalette(tes3.palette.headerColor)
    return tooltip
end

return this
