local uiid = require("Hanafuda.KoiKoi.uiid")
local card = require("Hanafuda.card")
local sound = require("Hanafuda.KoiKoi.sound")
local logger = require("Hanafuda.logger")
local koi = require("Hanafuda.KoiKoi.koikoi")
local ui = require("Hanafuda.KoiKoi.ui")
local config = require("Hanafuda.config")
local i18n = mwse.loadTranslations("Hanafuda")

-- with mergin
local paddingSize = 4
local smallSize = 0.5

local cardLayoutWidth = card.GetCardWidth() + paddingSize * 2
local cardLayoutHeight = card.GetCardHeight() + paddingSize * 2
local cardLayoutWidthSmall = card.GetCardWidth() * smallSize + paddingSize * smallSize * 2
local cardLayoutHeightSmall = card.GetCardHeight() * smallSize + paddingSize * smallSize * 2
local enabledCardColor = { 1, 1, 1 }
local disabledCardColor = { 0.3, 0.3, 0.3 }

local cardProperty = "Hanafuda:CardId"

---@class KoiKoi.View.Voice
---@field latest { KoiKoi.Player : {VoiceId : integer} }
---@field timer number
---@field interval number
---@field chance number


---@class KoiKoi.View
---@field names { KoiKoi.Player : string }
---@field mobile { KoiKoi.Player : tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer? }
---@field disposition number?
---@field voices KoiKoi.View.Voice
---@field testShowDialog fun(e:keyDownEventData)?
---@field testCapture fun(e:keyDownEventData)?
local View = {}

---@param mobile tes3mobileActor?
---@param defaultName string
---@return string
local function GetActorName(mobile, defaultName)
    if mobile and mobile.reference and mobile.reference.object and mobile.reference.object.name then
        return mobile.reference.object.name
    end
    return defaultName
end

---@param player tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer?
---@param opponent tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer?
---@return number?
local function GetDispotision(player, opponent)
    if not player or not opponent then
        return nil
    end
    if player.actorType == tes3.actorType.player and opponent.actorType == tes3.actorType.npc then
        return opponent.object.disposition
    elseif opponent.actorType == tes3.actorType.player and player.actorType == tes3.actorType.npc then
        return player.object.disposition -- swapped case
    end
    return nil
end

-- todo It may be better to adjust the width of the ground cards as well as the captured cards

---@param player tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer?
---@param opponent tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer?
---@return KoiKoi.View
function View.new(player, opponent)
    --@type KoiKoi.UI
    local instance = {
        names = {
            [koi.player.you] = GetActorName(player, i18n("playerDefaultName")),
            [koi.player.opponent] = GetActorName(opponent, i18n("opponentDefaultName")),
        },
        mobile = {
            [koi.player.you] = player,
            [koi.player.opponent] = opponent,
        },
        disposition = GetDispotision(player, opponent),
        voices = {
            latest = { [koi.player.you] = {},
                [koi.player.opponent] = {},
            },
            timer = 0,
            chance = 0,
            interval = 0,
        }
    }
    setmetatable(instance, { __index = View })
    return instance
end

---@param element tes3uiElement
---@return integer?
local function GetCardId(element)
    local cardId = element:getPropertyInt(cardProperty)
    if cardId == 0 then
        logger:error("Tried to get a card ID from a non-card element.")
        return nil
    end
    return cardId
end

---@param element tes3uiElement
---@param cardId integer
---@return tes3uiElement?
local function FindCardIdInChildren(element, cardId)
    -- linear search
    for _, child in ipairs(element.children) do
        if GetCardId(child) == cardId  then
            return child
        end
    end
    return nil
end

---@return boolean
local function IsGrabbingCard()
    local grab = tes3ui.findHelpLayerMenu(uiid.grabMenu)
    return grab and grab.visible and not grab.disabled
end

---@param parent tes3uiElement
---@param cardId integer
---@param backface boolean
---@param notooltip boolean?
---@return tes3uiElement
local function PutCard(parent, cardId, backface, notooltip)
    local asset = backface and card.GetCardBackAsset() or card.GetCardAsset(cardId)

    local element = parent:createBlock() -- drop shadow better
    element.autoWidth = true
    element.autoHeight = true
    element.paddingAllSides = paddingSize
    element:setPropertyInt(cardProperty, cardId)

    local image = element:createImage({ path = asset.path })
    image.width = card.GetCardWidth()
    image.height = card.GetCardHeight()
    image.scaleMode = true
    image.consumeMouseEvents = false

    if notooltip then
    else
        element:register(tes3.uiEvent.help,
        ---@param e uiEventEventData
        function(e)
            if not IsGrabbingCard() then
                ui.CreateCardTooltip(cardId, backface)
            end
        end)
    end

    return element
end

---@param element tes3uiElement
---@return tes3uiElement
local function FlipCard(element)
    -- or query id to service
    local cardId = GetCardId(element)
    assert(cardId)
    local asset = card.GetCardAsset(cardId) -- only reveal

    element:destroyChildren()

    local image = element:createImage({ path = asset.path })
    image.width = card.GetCardWidth()
    image.height = card.GetCardHeight()
    image.scaleMode = true
    image.consumeMouseEvents = false

    element:unregister(tes3.uiEvent.help)
    element:register(tes3.uiEvent.help,
    function(_)
        if not IsGrabbingCard() then
            ui.CreateCardTooltip(cardId, false)
        end
    end)
    return element
end

---@param parent tes3uiElement
---@param deck integer[]
---@return tes3uiElement
local function PutDeck(parent, deck)
    local asset = card.GetCardBackAsset()
    local element = parent:createBlock()
    element.autoWidth = true
    element.autoHeight = true
    element.paddingAllSides = paddingSize
    local image = element:createImage({ path = asset.path })
    image.width = card.GetCardWidth()
    image.height = card.GetCardHeight()
    image.scaleMode = true
    image.consumeMouseEvents = true
    --image.borderAllSides = 2

    image:register(tes3.uiEvent.help,
    ---@param e uiEventEventData
    function(e)
        if not IsGrabbingCard() then
            ui.CreateDeckTooltip(deck)
        end
    end)

    return image
end


---@param element tes3uiElement
---@param highlight boolean
local function SetCardColor(element, highlight)
    -- skip toplevel, it's just block
    -- if use rect or background image then it is changed too.
    for key, value in pairs(element.children) do
        value.color = highlight and enabledCardColor or disabledCardColor
    end
end
---@param element tes3uiElement
---@param scale number
local function SetCardSize(element, scale)
    element.paddingAllSides = math.ceil(element.paddingAllSides * scale)
    for key, value in pairs(element.children) do
        value.width = card.GetCardWidth() * scale
        value.height = card.GetCardHeight() * scale
    end
end

---@param parent tes3uiElement
---@param cardId integer
local function HighlightCards(parent, cardId)
    for _, value in pairs(parent.children) do
        local id = GetCardId(value)
        if id then
            SetCardColor(value, koi.CanMatchSuit(cardId, id))
        end
    end
end

---@param parent tes3uiElement
local function ResetHighlightCards(parent)
    for _, value in pairs(parent.children) do
        SetCardColor(value, true)
    end
end

---@param element tes3uiElement
---@return boolean
local function GrabCard(element)
    local grab = tes3ui.findHelpLayerMenu(uiid.grabMenu)
    if table.size(grab.children) > 0 then
        logger:error("GrabCard but has children")
        return false
    end
    grab.disabled = false
    grab.visible = true
    -- need to set initial position?
    local root = element:getTopLevelMenu()

    -- calculate absolute position
    -- not use cursor position for AI playing
    local x = element.positionX
    local y = element.positionY
    local p = element.parent
    while p do
        x = x + p.positionX
        y = y + p.positionY
        p = p.parent
    end
    -- transform to screen space
    local viewportWidth, viewportHeight = tes3ui.getViewportSize()
    x = x + viewportWidth * 0.5
    y = y - viewportHeight * 0.5

    local to = element:move({ to = grab})
    -- unregister events?

    -- initial position
    grab.positionX = x
    grab.positionY = y

    -- TODO lock captureable overlay hints

    grab:updateLayout()
    root:updateLayout()
    return true
end

---@param to tes3uiElement
---@return tes3uiElement?
local function ReleaseGrabedCard(to)
    local grab = tes3ui.findHelpLayerMenu(uiid.grabMenu)
    if table.size(grab.children) == 0 then
        logger:error("ReleaseCard but no child")
        return nil
    end
    grab.disabled = true
    grab.visible = false
    local root = to:getTopLevelMenu()
    local moved = grab.children[1]:move({ to = to}) -- currently just one child.
    -- unregister events?

    -- TODO unlock captureable overlay hints

    grab:updateLayout()
    root:updateLayout()
    return moved
end

---@return tes3uiElement?
local function GetGrabCard()
    local grab = tes3ui.findHelpLayerMenu(uiid.grabMenu)
    if not grab.visible or grab.disabled then
        return nil
    end
    if table.size(grab.children) == 0 then
        return nil
    end
    return grab.children[1]
end

---@return integer?
local function GetGrabCardId()
    local grab = GetGrabCard()
    if grab then
        return GetCardId(grab)
    end
    return nil
end

---@param element tes3uiElement
---@param player KoiKoi.Player
---@return tes3uiElement
local function CaptureCard(element, player)
    local cardId = GetCardId(element)
    assert(cardId)
    local you = player == koi.player.you
    local destid = {
        [card.type.bright] = you and uiid.playerBright or uiid.opponentBright,
        [card.type.animal] = you and uiid.playerAnimal or uiid.opponentAnimal,
        [card.type.ribbon] = you and uiid.playerRibbon or uiid.opponentRibbon,
        [card.type.chaff] = you and uiid.playerChaff or uiid.opponentChaff,
    }

    local type = card.GetCardData(cardId).type
    local dest = destid[type]
    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)
    local to = gameMenu:findChild(dest)
    assert(to)
    local moved = element:move({ to = to })
    SetCardColor(moved, true)
    SetCardSize(moved, smallSize)

    -- Overlap placement if it does not fit
    gameMenu:updateLayout() -- calculate after moved
    local merginL = to.paddingLeft or to.paddingAllSides
    local merginR = to.paddingRight or to.paddingAllSides
    local availableWidth = to.width - merginL - merginR

    -- Assuming the same width, there is no need to do so. In fact, they are the same width.
    local requiredWidth = 0
    for _, child in ipairs(to.children) do
        requiredWidth = requiredWidth + child.width
        requiredWidth = requiredWidth + (child.borderLeft or child.borderAllSides)
        requiredWidth = requiredWidth + (child.borderRight or child.borderAllSides)
    end
    if requiredWidth > availableWidth then
        local count = table.size(to.children)
        assert(count > 0)
        local average = requiredWidth / count
        local interval = (availableWidth - average ) / (count - 1)
        for index, child in ipairs(to.children) do
            child.borderAllSides = 0
            child.borderLeft = nil
            child.borderRight = nil
            child.ignoreLayoutX = true
            child.positionX = math.floor(interval * (index - 1))
        end
    end

    return moved
end

---@param player KoiKoi.Player
---@return tes3uiElement
local function CaptureGrabCard(player)
    local element = GetGrabCard()
    assert(element)
    local moved = CaptureCard(element, player)
    local grab = tes3ui.findHelpLayerMenu(uiid.grabMenu)
    grab.disabled = true
    grab.visible = false
    grab:updateLayout()
    return moved
end

---comment
---@param element tes3uiElement?
local function UnregisterEvents(element)
    if not element then
        return
    end
    element:unregister(tes3.uiEvent.mouseOver)
    element:unregister(tes3.uiEvent.mouseLeave)
    element:unregister(tes3.uiEvent.mouseClick)
end

---@param self KoiKoi.View
---@param id VoiceId
---@param player KoiKoi.Player
function View.PlayVoice(self, id, player)
    -- It is possible that the special voice and the fallback normal voice indexes are mixed up, but I don't care.
    self.voices.latest[player][id] = sound.PlayVoice(id, self.mobile[player], self.disposition, self.voices.latest[player][id])
end

---@param self KoiKoi.View
---@param service KoiKoi.Service
---@param player KoiKoi.Player?
---@param points { KoiKoi.Player : integer }
function View.ShowResult(self, service, player, points)
    -- show round histroy?
    -- todo more rich
    local header = i18n("koi.view.drawGame")
    if player then
        local name = self.names[koi.player.you]
        if player == koi.player.you then
            header = i18n("koi.view.winGame", {name = name})
            sound.PlayMusic(sound.music.win)
        else
            header = i18n("koi.view.loseGame", {name = name})
            sound.PlayMusic(sound.music.lose)
        end
        self:PlayVoice(sound.voice.winGame, player)
    end

    local message = i18n("koi.view.gameResult", { name = self.names[koi.player.you], count = points[koi.player.you]}) .. "\n" ..
    i18n("koi.view.gameResult", { name = self.names[koi.player.opponent], count = points[koi.player.opponent] })
    tes3ui.showMessageMenu({
        header = header,
        message = message,
        buttons = {
            {
                text = tes3.findGMST(tes3.gmst.sOK).value --[[@as string]],
                callback = function()
                    service:NotifyTerminate()
                end,
            },
        },
    })
end

---@param self KoiKoi.View
---@param e uiEventEventData
---@param service KoiKoi.Service
function View.OnExit(self, e, service)
    tes3.messageBox({
        message = i18n("koi.view.exitMessage"),
        buttons = {
            tes3.findGMST(tes3.gmst.sOK).value --[[@as string]],
            tes3.findGMST(tes3.gmst.sCancel).value --[[@as string]],
        },
        callback =
        function(btnCallbackData)
            if btnCallbackData.button == 0 then
                logger:info("Yield the game")
                service:Exit(true)
            end
        end,
    })
end

---@param self KoiKoi.View
---@param parent KoiKoi.Player
---@param service KoiKoi.Service
function View.ShowNoMatch(self, parent, service)
    tes3.messageBox({
        message = i18n("koi.view.drawRound"),
        buttons = {
            tes3.findGMST(tes3.gmst.sOK).value --[[@as string]],
        },
        callback =
        function(btnCallbackData)
            if btnCallbackData.button == 0 then
                service:NotifyRoundFinished()
            end
        end,
    })
end

---@param self KoiKoi.View
---@param player KoiKoi.Player
---@param service KoiKoi.Service
function View.ShowWin(self, player, service)
    local name = self.names[player]
    tes3.messageBox(i18n("koi.view.winRound", {name = name}))
    self:PlayVoice(sound.voice.loseRound, koi.GetOpponent(player))
    service:NotifyRoundFinished()
end

---@param self KoiKoi.View
---@param player KoiKoi.Player
---@param service KoiKoi.Service
---@param calling KoiKoi.Calling
---@param point integer
function View.ShowCalling(self, player, service, calling, point)
    local name = self.names[player]
    tes3.messageBox({
        message = calling == koi.calling.koikoi and i18n("koi.view.callKoi", {name = name}) or i18n("koi.view.callShobu", {name = name, count = point}),
        buttons = {
            tes3.findGMST(tes3.gmst.sOK).value --[[@as string]],
        },
        callback =
        function(btnCallbackData)
            if btnCallbackData.button == 0 then
                service:NotifyCalling(calling)
            end
        end,
    })
    if calling == koi.calling.koikoi then
        self:PlayVoice(sound.voice.continue, player)
    elseif calling == koi.calling.shobu then
        self:PlayVoice(sound.voice.finish, player)
    end
end

---@param self KoiKoi.View
---@param player KoiKoi.Player
---@param deltaTime number
---@param minInterval integer
---@param maxInterval integer
---@param frequency number
---@param playerRatio number
function View.IdleReaction(self, player, deltaTime, minInterval, maxInterval, frequency, playerRatio)
    self.voices.timer = self.voices.timer + deltaTime
    if self.voices.timer > self.voices.interval then
        local r = math.random()
        if self.voices.chance > r then
            if math.random() < playerRatio then
                self:PlayVoice(sound.voice.think, player)
            else
                self:PlayVoice(sound.voice.remind, koi.GetOpponent(player))
            end
            self.voices.chance = 0
        else
            self.voices.chance = self.voices.chance + (self.voices.interval / frequency) -- usually speak once at this time.
        end
        self.voices.interval = math.random(minInterval, maxInterval) -- fluctuating
        self.voices.timer = 0
    end
end

---@param self KoiKoi.View
---@param player KoiKoi.Player
---@param deltaTime number
function View.ThinkMatchingHand(self, player, deltaTime)
    -- it would like to have a larger ratio on the thinking side,
    -- but player should spend more time thinking than the AI.
    self:IdleReaction(player, deltaTime, 6, 15, 60, 0.5) -- thoughtful
end

---@param self KoiKoi.View
---@param player KoiKoi.Player
---@param deltaTime number
function View.ThinkMatchingDrawn(self, player, deltaTime)
    self:IdleReaction(player, deltaTime, 4, 10, 60, 0.3) -- hurry
end

---@param self KoiKoi.View
---@param player KoiKoi.Player
---@param deltaTime number
function View.ThinkCalling(self, player, deltaTime)
    self:IdleReaction(player, deltaTime, 4, 8, 30, 0.7) -- fast pace
end

--- custom block has max width. and it excluding frame size...
---@param parent tes3uiElement?
---@return integer?
local function ComputeParentMaxWidth(parent)
    local maxWidth = nil
    local p = parent
    while p do
        if p.maxWidth then
            if maxWidth then
                maxWidth = math.min(p.maxWidth, maxWidth)
            else
                maxWidth = p.maxWidth
            end
        end
        p = p.parent
    end
    return maxWidth
end

---@param parent tes3uiElement
---@param combo { [KoiKoi.CombinationType] : integer }
local function CreateTightCombinationList(parent, combo)
    -- todo curent combination cards on tooltip, need card IDs
    parent.widthProportional = 1
    local maxWidth = ComputeParentMaxWidth(parent)
    for _, value in ipairs(table.keys(combo, true)) do
        ui.CreateCombinationView(parent, value, combo[value], maxWidth, 0.5 * 0.75)
    end
    parent:createDivider().widthProportional = 1.0
end

---@param parent tes3uiElement
---@param combo { [KoiKoi.CombinationType] : integer }
local function CreateSummaryCombinationList(parent, combo)
    -- todo curent combination cards on tooltip, need card IDs
    for _, value in ipairs(table.keys(combo, true)) do
        ui.CreateCombinationView(parent, value, combo[value], nil, nil, true)
    end
end

-- todo need driver for test
---@param self KoiKoi.View
---@param player KoiKoi.Player
---@param service KoiKoi.Service?
---@param combo { [KoiKoi.CombinationType] : integer }
---@param basePoint integer
---@param multiplier integer
function View.ShowCallingDialog(self, player, service, combo, basePoint, multiplier)
    local total = basePoint * multiplier
    local empty = false
    if service then
        empty = table.size(service:GetPlayerHand(player)) == 0
    end

    tes3ui.showMessageMenu({
        header = i18n("koi.view.callingHeader", { name = self.names[player]}),
        message = i18n("koi.view.callingMessage" , {count = total, base = basePoint, mult = multiplier}),
        buttons = {
            {
                text = i18n("koi.koikoi"),
                callback = function()
                    self:PlayVoice(sound.voice.continue, player)
                    if service then
                        service:NotifyKoiKoi()
                    end
                end,
                tooltip = function()
                    local tooltip = tes3ui.createTooltipMenu()
                    tooltip:createLabel({ text = i18n("koi.view.koiTooltip") })
                end,
                enableRequirements = function (_)
                    return not empty
                end
            },
            {
                text = i18n("koi.shobu"),
                callback = function()
                    self:PlayVoice(sound.voice.finish, player)
                    if service then
                        service:NotifyShobu()
                    end
                end,
                tooltip = function()
                    local tooltip = tes3ui.createTooltipMenu()
                    tooltip:createLabel({ text = i18n("koi.view.shobuTooltip") })
                end
            },
        },
        customBlock =
        ---@param parent tes3uiElement
        function(parent)
            CreateTightCombinationList(parent, combo)
        end
    })

    local blockId = {
        [koi.player.you] = uiid.playerCombination,
        [koi.player.opponent] = uiid.opponentCombination,
    }
    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)
    local parent = gameMenu:findChild(blockId[player])
    parent:destroyChildren()
    CreateSummaryCombinationList(parent, combo)
    gameMenu:updateLayout()
end

-- todo need driver for test

---@param self KoiKoi.View
---@param player KoiKoi.Player
---@param service KoiKoi.Service?
---@param combo { [KoiKoi.CombinationType] : integer }
---@param basePoint integer
---@param multiplier integer
function View.ShowCombo(self, player, service, combo, basePoint, multiplier)
    local total = basePoint * multiplier

    local name = self.names[player]

    -- todo show multipiled score
    tes3ui.showMessageMenu({
        header = i18n("koi.view.callingHeader", {name = name}),
        message = i18n("koi.view.callingConfirmMessage", {name = name, count = total, base = basePoint, mult = multiplier}),
        buttons = {
            {
                text = tes3.findGMST(tes3.gmst.sOK).value --[[@as string]],
                callback = function()
                    if service then
                        service:NotifyComfirmCombo()
                    end
                end,
            },
        },
        customBlock =
        ---@param parent tes3uiElement
        function(parent)
            CreateTightCombinationList(parent, combo)
        end
    })

    local blockId = {
        [koi.player.you] = uiid.playerCombination,
        [koi.player.opponent] = uiid.opponentCombination,
    }
    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)
    local parent = gameMenu:findChild(blockId[player])
    parent:destroyChildren()
    CreateSummaryCombinationList(parent, combo)
    gameMenu:updateLayout()

end

---@param self KoiKoi.View
---@param player KoiKoi.Player
---@param score integer
function View.UpdateScorePoint(self, player, score)
    local labelId = {
        [koi.player.you] = uiid.playerScore,
        [koi.player.opponent] = uiid.opponentScore,
    }
    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)
    local label = gameMenu:findChild(labelId[player])
    label.text = i18n("koi.view.point", {count = score})
    --gameMenu:updateLayout()
end

---@param self KoiKoi.View
---@param current integer
---@param max integer
function View.UpdateRound(self, current, max)
    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)
    local label = gameMenu:findChild(uiid.round)
    label.text = i18n("koi.view.round", {count = current, max = max})
    --gameMenu:updateLayout()
end

---@param self KoiKoi.View
---@param parent KoiKoi.Player
function View.UpdateParent(self, parent)
    local labelId = {
        [koi.player.you] = uiid.playerDealer,
        [koi.player.opponent] = uiid.opponentDealer,
    }
    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)
    do
        local label = gameMenu:findChild(labelId[parent])
        label.text = i18n("koi.view.parent")
    end
    do
        local child = koi.GetOpponent(parent)
        local label = gameMenu:findChild(labelId[child])
        label.text = i18n("koi.view.child")
    end
    --gameMenu:updateLayout()
end

---@param self KoiKoi.View
---@param service KoiKoi.Service
---@param cardId0 integer
---@param cardId1 integer
function View.CreateDecidingParent(self, service, cardId0, cardId1)

    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)
    -- automatic layout does not center them, but this is not a major problem.
    local g0 = gameMenu:findChild(uiid.boardGroundRow0)
    local g1 = gameMenu:findChild(uiid.boardGroundRow1)
    local c0 = PutCard(g0, cardId0, true, true)
    local c1 = PutCard(g1, cardId1, true, true)
    c0:register(tes3.uiEvent.help,
    function(_)
        local tooltip = tes3ui.createTooltipMenu()
        tooltip:createLabel({ text = i18n("koi.view.decideParentTooltip") })
    end)
    c1:register(tes3.uiEvent.help,
    function(_)
        local tooltip = tes3ui.createTooltipMenu()
        tooltip:createLabel({ text = i18n("koi.view.decideParentTooltip") })
    end)
    c0:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- Good with weights and animations, but hard without coroutine
        FlipCard(c0)
        FlipCard(c1)
        UnregisterEvents(c0)
        UnregisterEvents(c1)
        -- no tooltips after flipped
        c0:unregister(tes3.uiEvent.help)
        c1:unregister(tes3.uiEvent.help)
        sound.Play(sound.se.pickCard)
        gameMenu:updateLayout()
        local selectedCardId = cardId0
        service:NotifyDecideParent(selectedCardId)
    end)
    c1:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- Good with weights and animations, but hard without coroutine
        FlipCard(c0)
        FlipCard(c1)
        UnregisterEvents(c0)
        UnregisterEvents(c1)
        -- no tooltips after flipped
        c0:unregister(tes3.uiEvent.help)
        c1:unregister(tes3.uiEvent.help)
        sound.Play(sound.se.pickCard)
        gameMenu:updateLayout()
        local selectedCardId = cardId1
        service:NotifyDecideParent(selectedCardId)
    end)
    gameMenu:updateLayout()
    sound.Play(sound.se.dealCard)
    tes3.messageBox(i18n("koi.view.decideParentMessage"))

end

---@param self KoiKoi.View
---@param parent KoiKoi.Player
---@param service KoiKoi.Service
---@param selectedId integer
---@param cardId0 integer
---@param cardId1 integer
function View.InformParent(self, parent, service, selectedId, cardId0, cardId1)
    local unselectedId = selectedId == cardId0 and cardId1 or cardId0

    tes3ui.showMessageMenu({
        header = i18n("koi.view.informParentHeader", { name = self.names[parent] }),
        message = i18n("koi.view.informParentMessage"),
        buttons = {
            {
                text = tes3.findGMST(tes3.gmst.sOK).value --[[@as string]],
                callback = function()
                    if service then
                        service:NotifyInformParent()
                    end
                end,
            },
        },
        customBlock =
        ---@param element tes3uiElement
        function(element)
            element.widthProportional = 1
            local maxWidth = ComputeParentMaxWidth(element)
            local function Create(cardId, name)
                local block = element:createBlock()
                block.flowDirection = tes3.flowDirection.leftToRight
                block.widthProportional = 1
                block.autoWidth = true
                block.autoHeight = true
                --block.borderAllSides = 8
                block.paddingAllSides = 0
                -- block.paddingLeft = 8
                -- block.paddingRight = 8
                if maxWidth then
                    block.maxWidth = maxWidth
                end
                local scale = 1
                local asset = card.GetCardAsset(cardId)
                local ref = card.GetCardData(cardId)
                local b = block:createBlock()
                b.borderAllSides = 2
                b.autoWidth = true
                b.autoHeight = true
                b.flowDirection = tes3.flowDirection.topToBottom
                --b.childAlignX = 0.5
                local image = b:createImage({ path = asset.path })
                image.width = card.GetCardWidth() * scale
                image.height = card.GetCardHeight() * scale
                image.scaleMode = true
                image.consumeMouseEvents = false
                --image.borderAllSides = 2
                image.flowDirection = tes3.flowDirection.topToBottom
                b:register(tes3.uiEvent.help,
                    function(_)
                        ui.CreateCardTooltip(cardId, false)
                    end)
                local t = block:createBlock()
                t.borderAllSides = 2
                t.autoWidth = true
                t.autoHeight = true
                t.flowDirection = tes3.flowDirection.topToBottom
                t:createLabel({ text = i18n("koi.view.informParentPick", {name = name})})
                local l = t:createLabel({ text = card.GetCardText(cardId).name })
                l.color = tes3ui.getPalette(tes3.palette.headerColor)
                t:createLabel({ text = card.GetCardSuitText(ref.suit).name .. " (" .. tostring(ref.suit) .. ")" })
                local type = t:createLabel({ text = card.GetCardTypeText(ref.type).name })
                type.color = card.GetCardTypeColor(ref.type)
            end
            Create(selectedId, self.names[koi.player.you])
            Create(unselectedId, self.names[koi.player.opponent])
            element:createDivider().widthProportional = 1.0

        end
    })

    self:UpdateParent(parent)
end

---@param self KoiKoi.View
---@param element tes3uiElement
---@param cardId integer
---@param service KoiKoi.Service
function View.RegisterHandCardEvent(self, element, cardId, service)
    UnregisterEvents(element)

    element:register(tes3.uiEvent.mouseOver,
    ---@param e uiEventEventData
    function(e)
        -- highlight matching ground cards
        -- if can then...
        local root = e.source:getTopLevelMenu()
        local g0 = root:findChild(uiid.boardGroundRow0)
        local g1 = root:findChild(uiid.boardGroundRow1)
        HighlightCards(g0, cardId)
        HighlightCards(g1, cardId)
        root:updateLayout()
    end)

    element:register(tes3.uiEvent.mouseLeave,
    ---@param e uiEventEventData
    function(e)
        -- stop highlight
        -- if can then...
        local root = e.source:getTopLevelMenu()
        local g0 = root:findChild(uiid.boardGroundRow0)
        local g1 = root:findChild(uiid.boardGroundRow1)
        ResetHighlightCards(g0)
        ResetHighlightCards(g1)
        root:updateLayout()
    end)

    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- keep highlight
        -- grab card
        if service:CanGrabCard(cardId) then
            if GrabCard(e.source) then -- sync serivice?
                sound.Play(sound.se.pickCard)
            end
        else
            tes3.messageBox(i18n("koi.view.infoGround"))
        end
    end)
end

---@param self KoiKoi.View
---@param element tes3uiElement
---@param service KoiKoi.Service
function View.RegisterHandEvent(self, element, service)
    UnregisterEvents(element)

    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- cancel, put back card
        -- or service has selectedcard
        local cardId = GetGrabCardId()
        if cardId then
            if service:CanPutbackCard(cardId) then
                if ReleaseGrabedCard(e.source) then -- sync serivice?
                    sound.Play(sound.se.putCard)
                end
            else
                tes3.messageBox(i18n("koi.view.infoPutback"))
            end
        end
    end)
end

---@param self KoiKoi.View
---@param element tes3uiElement
---@param cardId integer
---@param service KoiKoi.Service
function View.RegisterGroundCardEvent(self, element, cardId, service)
    UnregisterEvents(element)

    element:register(tes3.uiEvent.mouseOver,
    ---@param e uiEventEventData
    function(e)
        -- highlight matching cards
        -- todo opponent (almost backface, but usefull for manual playing)
        -- if can then...
        local hand = e.source:getTopLevelMenu():findChild(uiid.playerHand)
        for _, value in pairs(hand.children) do
            local id = GetCardId(value)
            if id then
                SetCardColor(value, koi.CanMatchSuit(cardId, id))
            end
        end
        e.source:getTopLevelMenu():updateLayout()
    end)

    element:register(tes3.uiEvent.mouseLeave,
    ---@param e uiEventEventData
    function(e)
        -- stop highlight
        -- if can then...
        local hand = e.source:getTopLevelMenu():findChild(uiid.playerHand)
        for key, value in pairs(hand.children) do
            SetCardColor(value, true)
        end
        e.source:getTopLevelMenu():updateLayout()
    end)

    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- stop highlight
        -- if can then...
        -- for key, value in pairs(self.playerViews[koi.player.you].card) do
        --     HighlightCard(value, true)
        -- end
        -- e.source:getTopLevelMenu():updateLayout()
        -- match and capture
        local grab = GetGrabCardId()
        if grab then
            local target = GetCardId(e.source) -- or use cardId
            if target and service:CanMatch(grab, target) then
                service:Capture(grab, false)
                service:Capture(target, true)
                -- house rule: multiple captring
                local grab = GetGrabCard()
                assert(grab)
                local root = e.source:getTopLevelMenu()
                local moved0 = CaptureCard(e.source, koi.player.you)
                local moved1 = CaptureGrabCard(koi.player.you)
                if moved0 and moved1 then
                    sound.Play(sound.se.putCard)
                end
                UnregisterEvents(moved0)
                UnregisterEvents(moved1)
                local g0 = root:findChild(uiid.boardGroundRow0)
                local g1 = root:findChild(uiid.boardGroundRow1)
                local h0 = root:findChild(uiid.playerHand)
                -- local h1 = root:findChild(uiid.opponentHand)
                ResetHighlightCards(g0)
                ResetHighlightCards(g1)
                ResetHighlightCards(h0)
                root:updateLayout()
                service:NotifyMatchedCards()
            else
                tes3.messageBox(i18n("koi.view.infoHand"))
            end
        end
    end)
end

---@param self KoiKoi.View
---@param element tes3uiElement
---@param service KoiKoi.Service
function View.RegisterGroundEvent(self, element, service)
    UnregisterEvents(element)

    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- discard card
        -- or service has selectedcard
        local cardId = GetGrabCardId()
        if cardId then
            if service:CanDiscard(cardId) then
                service:Discard(cardId)
                local root = e.source:getTopLevelMenu()
                local g0 = root:findChild(uiid.boardGroundRow0)
                local g1 = root:findChild(uiid.boardGroundRow1)
                local g = table.size(g0.children) < table.size(g1.children) and g0 or g1
                local moved = ReleaseGrabedCard(g)
                if moved then
                    self:RegisterGroundCardEvent(moved, cardId, service)
                    sound.Play(sound.se.putCard)
                end
                ResetHighlightCards(g0)
                ResetHighlightCards(g1)
                root:updateLayout()
                service:NotifyDiscardCard()
            else
                tes3.messageBox(i18n("koi.view.infoDiscard"))
            end
        end
    end)
end

---@param self KoiKoi.View
---@param element tes3uiElement
---@param cardId integer
---@param service KoiKoi.Service
function View.RegisterDrawnCardEvent(self, element, cardId, service)
    -- currently same
    self:RegisterHandCardEvent(element, cardId, service)
end

---@param self KoiKoi.View
---@param element tes3uiElement
---@param service KoiKoi.Service
function View.RegisterDeckEvent(self, element, service)
    UnregisterEvents(element)
    element:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        -- draw card
        -- It can grab cards directly after drawing them, -- but it will be difficult to confirm by tooltip or mouseover.
        -- It also makes it difficult to confirm the opponent's draw.
        -- Currently, cards drawn should be placed and then grabbed.
        if service:CanDrawCard() then
            local cardId = service:DrawCard()
            if cardId then
                local drawn = e.source:getTopLevelMenu():findChild(uiid.boardDrawn)
                local element = PutCard(drawn, cardId, false)
                self:RegisterDrawnCardEvent(element, cardId, service)
                e.source:getTopLevelMenu():updateLayout()
                sound.Play(sound.se.pickCard)
            end
        else
            tes3.messageBox(i18n("koi.view.infoDraw"))
        end
    end)
end


-- There are two ways to register all the necessary events for controling use CanPerform to decide,
-- or register and unregister the necessary events in each phase for each phase.
-- Here, I try to use the CanPerform method as in a general application.

---@param self KoiKoi.View
---@param parent KoiKoi.Player
---@param pools KoiKoi.PlayerPool[]
---@param groundPools integer[]
---@param deck integer[]
---@param service KoiKoi.Service
---@param skipAnimation boolean
function View.DealInitialCards(self, parent, pools, groundPools, deck, service, skipAnimation)
    self:CleanUpCards() -- clean deciding parnet cards

    ---@return any
    local function putCards()
        local gameMenu = tes3ui.findMenu(uiid.gameMenu)
        assert(gameMenu)

        local back = parent ~= koi.player.you
        local child = koi.GetOpponent(parent)

        local g0 = gameMenu:findChild(uiid.boardGroundRow0)
        local g1 = gameMenu:findChild(uiid.boardGroundRow1)
        local ph = gameMenu:findChild(uiid.playerHand)
        local oh = gameMenu:findChild(uiid.opponentHand)
        local childHand = child == koi.player.you and ph or oh
        local parentHand = child == koi.player.you and oh or ph


        -- todo use from service settings
        local initialCards = 8
        local initialDealEach = 2
        -- must be no fraction
        -- annoy indexing begin 1
        for j = 0, (initialCards / initialDealEach) - 1 do
            local start = j * 2 + 1
            -- child
            for i = start, (start + (initialDealEach-1)) do
                --logger:trace(i)
                local view = childHand
                local cardId = pools[child].hand[i]
                local e = PutCard(view, cardId, not back)
                if child == koi.player.you then -- workaround
                    self:RegisterHandCardEvent(e, cardId, service)
                end
                if not skipAnimation then
                    gameMenu:updateLayout()
                    coroutine.yield(e)
                end
            end
            -- ground
            for i = start, (start + (initialDealEach-1)) do
                local cardId = groundPools[i]
                local view = (i % 2 == 0) and g1 or g0
                local e = PutCard(view, cardId, false)
                self:RegisterGroundCardEvent(e, cardId, service)
                if not skipAnimation then
                    gameMenu:updateLayout()
                    coroutine.yield(e)
                end
            end
            -- parent
            for i = start, (start + (initialDealEach-1)) do
                local view = parentHand
                local cardId = pools[parent].hand[i]
                local e = PutCard(view, cardId, back)
                if parent == koi.player.you then -- workaround
                    self:RegisterHandCardEvent(e, cardId, service)
                end
                if not skipAnimation then
                    gameMenu:updateLayout()
                    coroutine.yield(e)
                end
            end
        end
    end

    -- BUG Crash when using coroutine with enterFrame event present

    -- animation with coroutine or timer
    -- todo card animation deck to hand/ground

    if skipAnimation then
        putCards()

        local gameMenu = tes3ui.findMenu(uiid.gameMenu)
        assert(gameMenu)
        local pile = gameMenu:findChild(uiid.boardPile)
        local e = PutDeck(pile, deck)
        self:RegisterDeckEvent(e, service)
        gameMenu:updateLayout()
        sound.Play(sound.se.putDeck)
        logger:debug("dealing done")
        service:NotifyDealedInitialCards()

    else
        local deal = coroutine.wrap(putCards)
        timer.start({
            type = timer.real,
            ---@param e mwseTimerCallbackData
            callback = function(e)
                if deal() == nil then
                    --or infinit and use e.timer.cancel
                    -- notify servic to next phase
                    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
                    assert(gameMenu)
                    local pile = gameMenu:findChild(uiid.boardPile)
                    local e = PutDeck(pile, deck)
                    self:RegisterDeckEvent(e, service)
                    gameMenu:updateLayout()
                    sound.Play(sound.se.putDeck)
                    logger:debug("dealing done")
                    service:NotifyDealedInitialCards()
                else
                    sound.Play(sound.se.dealCard)
                end
            end,
            iterations = 8 * 3 + 1, -- cards and endpoint
            duration = 0.1,         -- tweak this
            persist = false,        -- hmm..perhaps false
        })
    end
end

---@param self KoiKoi.View
---@param luckyHands { [KoiKoi.Player] : { [KoiKoi.LuckyHands] : integer }? }
---@param totalPoints { [KoiKoi.Player] : integer }
---@param winner KoiKoi.Player?
---@param service KoiKoi.Service
function View.ShowLuckyHands(self, luckyHands, totalPoints, winner, service)
    -- flip cards
    local tie = winner == nil
    if not tie and winner == koi.player.opponent then
        local gameMenu = tes3ui.findMenu(uiid.gameMenu)
        assert(gameMenu)
        --local ph = gameMenu:findChild(uiid.playerHand)
        local oh = gameMenu:findChild(uiid.opponentHand)
        if oh.children then
            for _, child in ipairs(oh.children) do
                FlipCard(child)
            end
            gameMenu:updateLayout()
        end
        sound.Play(sound.se.putCard)
    end
    if winner ~= nil then
        self:PlayVoice(sound.voice.remind, winner) -- todo more better voice
    end

    tes3ui.showMessageMenu({
        header = i18n("koi.view.luckyHands.label"),
        message = tie and i18n("koi.view.drawRound") or i18n("koi.view.winRound", {name = self.names[winner]}),
        buttons = {
            {
                text = tes3.findGMST(tes3.gmst.sOK).value --[[@as string]],
                callback = function()
                    service:NotifyLuckyHands()
                end,
            },
        },
        customBlock =
        ---@param parent tes3uiElement
        function(parent)
            parent.widthProportional = 1
            local maxWidth = ComputeParentMaxWidth(parent)
            local p = koi.player.you
            if luckyHands[p] then
                parent:createLabel({ text = i18n("koi.view.luckyHands.player", {name = self.names[p], count = totalPoints[p]})})
                for _, value in ipairs(table.keys(luckyHands[p], true)) do
                    ui.CreateLuckyHandsView(parent, value, luckyHands[p][value], maxWidth)
                end
                parent:createDivider().widthProportional = 1.0
            end
            p = koi.player.opponent
            if luckyHands[p] then
                parent:createLabel({ text = i18n("koi.view.luckyHands.player", {name = self.names[p], count = totalPoints[p]})})
                for _, value in ipairs(table.keys(luckyHands[p], true)) do
                    ui.CreateLuckyHandsView(parent, value, luckyHands[p][value], maxWidth)
                end
                parent:createDivider().widthProportional = 1.0
            end
        end
    })
end

---@param self KoiKoi.View
---@param service KoiKoi.Service
---@param player KoiKoi.Player
---@param selectedCard integer
---@param skipAnimation boolean
function View.Flip(self, service, player, selectedCard, skipAnimation)
    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)

    local handId = {
        [koi.player.you] = uiid.playerHand,
        [koi.player.opponent] = uiid.opponentHand,
    }
    local hand = gameMenu:findChild(handId[player])
    local selected = FindCardIdInChildren(hand, selectedCard)
    if selected then
        FlipCard(selected)
        sound.Play(sound.se.pickCard) -- todo
    else
        logger:error("%u does not contain in %u", selectedCard, player)
    end
    gameMenu:updateLayout()
    service:NotifyFlipCard()
end

---@param self KoiKoi.View
---@param service KoiKoi.Service
---@param player KoiKoi.Player
---@param selectedCard integer
---@param matchedCard integer
---@param drawn boolean
---@param skipAnimation boolean
function View.Capture(self, service, player, selectedCard, matchedCard, drawn, skipAnimation)
    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)

    local selected ---@type tes3uiElement?
    if drawn then
        local drawn = gameMenu:findChild(uiid.boardDrawn)
        selected = FindCardIdInChildren(drawn, selectedCard)
    else
        local handId = {
            [koi.player.you] = uiid.playerHand,
            [koi.player.opponent] = uiid.opponentHand,
        }
        local hand = gameMenu:findChild(handId[player])
        selected = FindCardIdInChildren(hand, selectedCard)
    end
    if not selected then
        logger:error("not find cardId %d in UI", selectedCard)
        return
    end
    local g0 = gameMenu:findChild(uiid.boardGroundRow0)
    local g1 = gameMenu:findChild(uiid.boardGroundRow1)
    local matched = FindCardIdInChildren(g0, matchedCard)
    if not matched then
        matched = FindCardIdInChildren(g1, matchedCard)
    end
    if not matched then
        logger:error("not find cardId %d in ground", matchedCard)
        return
    end

    assert(selected)
    local moved0 = CaptureCard(selected, player)
    local moved1 = CaptureCard(matched, player)
    if moved0 and moved1 then
        sound.Play(sound.se.putCard)
    end
    UnregisterEvents(moved0)
    UnregisterEvents(moved1)

    local g0 = gameMenu:findChild(uiid.boardGroundRow0)
    local g1 = gameMenu:findChild(uiid.boardGroundRow1)
    local h0 = gameMenu:findChild(uiid.playerHand)
    -- local h1 = gameMenu:findChild(uiid.opponentHand)
    ResetHighlightCards(g0)
    ResetHighlightCards(g1)
    ResetHighlightCards(h0)
    gameMenu:updateLayout()
    service:NotifyMatchedCards() -- correct usage?

end

---@param self KoiKoi.View
---@param service KoiKoi.Service
---@param player KoiKoi.Player
---@param selectedCard integer
---@param drawn boolean
---@param skipAnimation boolean
function View.Discard(self, service, player, selectedCard, drawn, skipAnimation)

    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)

    local selected ---@type tes3uiElement?
    if drawn then
        local drawn = gameMenu:findChild(uiid.boardDrawn)
        selected = FindCardIdInChildren(drawn, selectedCard)
    else
        local handId = {
            [koi.player.you] = uiid.playerHand,
            [koi.player.opponent] = uiid.opponentHand,
        }
        local hand = gameMenu:findChild(handId[player])
        selected = FindCardIdInChildren(hand, selectedCard)
        if player == koi.player.opponent and selected then -- fixme set property?
            FlipCard(selected)
        end
    end
    if not selected then
        logger:error("not find cardId %d in UI", selectedCard)
        return
    end
    local g0 = gameMenu:findChild(uiid.boardGroundRow0)
    local g1 = gameMenu:findChild(uiid.boardGroundRow1)
    local g = table.size(g0.children) < table.size(g1.children) and g0 or g1 -- whitch less

    assert(selected)
    local moved = selected:move({ to = g })
    self:RegisterGroundCardEvent(moved, selectedCard, service)
    gameMenu:updateLayout()

    sound.Play(sound.se.putCard)

    service:NotifyDiscardCard() -- correct usage?
end

---@param self KoiKoi.View
---@param service KoiKoi.Service
---@param player KoiKoi.Player
---@param cardId integer
---@param emptyDeck boolean
---@param skipAnimation boolean
function View.Draw(self, service, player, cardId, emptyDeck, skipAnimation)

    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)
    local drawn = gameMenu:findChild(uiid.boardDrawn)
    local element = PutCard(drawn, cardId, false)
    self:RegisterDrawnCardEvent(element, cardId, service) -- only player?
    if emptyDeck then
        local pile = gameMenu:findChild(uiid.boardPile)
        pile.visible = false
    end
    gameMenu:updateLayout()
    sound.Play(sound.se.pickCard)

    service:NotifyDrawCard()

end

---@param self KoiKoi.View
---@param player KoiKoi.Player
---@param parent KoiKoi.Player
---@param service KoiKoi.Service
function View.BeginTurn(self, player, parent, service)
    local text = i18n("koi.view.beginTurn", {name = self.names[player]})

    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)
    local turn = gameMenu:findChild(uiid.turn)
    turn.text = text

    tes3.messageBox(text)

    service:NotifyBeganTurn()
end

---@param self KoiKoi.View
function View.CleanUpCards(self)
    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(gameMenu)

    local cards = {
        uiid.playerHand,
        uiid.playerBright,
        uiid.playerAnimal,
        uiid.playerRibbon,
        uiid.playerChaff,
        uiid.playerCombination,
        uiid.opponentHand,
        uiid.opponentBright,
        uiid.opponentAnimal,
        uiid.opponentRibbon,
        uiid.opponentChaff,
        uiid.opponentCombination,
        uiid.boardPile,
        uiid.boardDrawn,
        uiid.boardGroundRow0,
        uiid.boardGroundRow1,
    }
    for index, value in ipairs(cards) do
        local element = gameMenu:findChild(value)
        if element then
            element:destroyChildren()
        end
    end
    gameMenu:updateLayout()
end

--- in card gamae, player means each 'player'
--- but in this video game, player is you.

---@param parent tes3uiElement
---@param id number
---@param type CardType
---@param you boolean
---@return tes3uiElement
local function CreateTypeArea(parent, id, type, you)
    local area = parent:createRect({ id = id, color = card.GetCardTypeColor(type) })
    area.widthProportional = 1
    --area.autoWidth = true
    --area.minHeight = cardLayoutHeight + 2
    area.height = cardLayoutHeightSmall + 2
    --area.autoHeight = true
    area.flowDirection = tes3.flowDirection.leftToRight
    --area.alpha = 0.25
    area.alpha = 0.2
    --area.paddingAllSides = 2
    area.childAlignY = 0.5
    local text = you and i18n("koi.view.capturedTooltip.player", {name = card.GetCardTypeText(type).name}) or i18n("koi.view.capturedTooltip.opponent", {name = card.GetCardTypeText(type).name})
    area:register(tes3.uiEvent.help,
    ---@param e uiEventEventData
    function(e)
        if not IsGrabbingCard() then
            local tooltip = tes3ui.createTooltipMenu()
            local label = tooltip:createLabel({ text = text })
        end
    end)
    return area
end

---@param parent tes3uiElement
---@return tes3uiElement
local function CreateTypeFrame(parent)
    local frame = parent:createBlock()
    frame.widthProportional = 1
    --frame.autoWidth = true
    --frame.minHeight = cardLayoutHeightSmall + 2
    --frame.height = cardLayoutHeightSmall + 2
    --frame.minHeight = cardLayoutHeightSmall
    frame.autoHeight = true
    frame.flowDirection = tes3.flowDirection.leftToRight
    --frame.paddingAllSides = 2
    return frame
end

---@param parent tes3uiElement
---@param id number
---@param height number
---@return tes3uiElement
local function CreateHandView(parent, id, height)
    local border = parent:createThinBorder()
    border.borderAllSides = 6
    border.widthProportional = 1
    border.heightProportional = height
    border.flowDirection = tes3.flowDirection.topToBottom

    local hand = border:createBlock({ id = id })
    hand.widthProportional = 1
    hand.heightProportional = 1
    hand.flowDirection = tes3.flowDirection.leftToRight
    --hand.paddingAllSides = 2
    hand.childAlignX = 0.5 -- fixme doesnt work...
    hand.childAlignY = 0.5
    hand.minWidth = cardLayoutWidth * 8
    hand.minHeight = cardLayoutHeight
    return hand
end

---@param parent tes3uiElement
local function CreateBoard(parent, height)
    local area = parent:createBlock()
    area.widthProportional = 1
    area.heightProportional = height
    area.flowDirection = tes3.flowDirection.leftToRight

    local border = area:createBlock()
    -- for placement dealing card or vertical placement
    -- border.minWidth = cardLayoutWidth
    -- border.minHeight = cardLayoutHeight * 2
    --border.autoWidth = true
    border.width = cardLayoutWidth * 2
    border.heightProportional = 1
    border.flowDirection = tes3.flowDirection.topToBottom
    --border.paddingAllSides = 2
    border.childAlignX = 0.5
    border.childAlignY = 0.5
    local pile = border:createBlock({id = uiid.boardPile })
    --pile.width = cardLayoutWidth * 2
    --pile.minWidth = cardLayoutWidth*2
    -- pile.minHeight = cardLayoutHeight * 2
    --pile.autoWidth = true -- why?
    pile.widthProportional = 1
    pile.heightProportional = 1
    pile.childAlignX = 0.5
    pile.childAlignY = 0.5
    local drawn = border:createBlock({id = uiid.boardDrawn })
    --drawn.width = cardLayoutWidth * 2
    --drawn.minWidth = cardLayoutWidth*2
    -- drawn.minHeight = cardLayoutHeight * 2
    --drawn.autoWidth = true -- why?
    drawn.widthProportional = 1
    drawn.heightProportional = 1
    drawn.childAlignX = 0.5
    drawn.childAlignY = 0.5

    -- double rows
    local block = area:createBlock()
    -- block.minWidth = cardLayoutWidth * 4
    -- block.minHeight = cardLayoutHeight * 2
    block.widthProportional = 1
    block.heightProportional = 1
    block.flowDirection = tes3.flowDirection.topToBottom

    ---@param parent tes3uiElement
    ---@param id number
    local function CreateGround(parent, id)
        local ground = parent:createBlock({id = id })
        ground.widthProportional = 1
        ground.heightProportional = 1
        ground.flowDirection = tes3.flowDirection.leftToRight
        --ground.paddingAllSides = 2
        ground.childAlignX = 0.5
        ground.childAlignY = 0.5
        -- ground.minWidth = cardLayoutWidth * 4 -- double rows and use 4
        -- ground.minHeight = cardLayoutHeight * 2
        -- min value affect childAlign, why?
        return ground
    end

    local ground = CreateGround(block, uiid.boardGroundRow0)
    ground.childAlignY = 1.0
    ground = CreateGround(block, uiid.boardGroundRow1)
    ground.childAlignY = 0.0
    -- ground.minWidth = cardLayoutWidth * 4 -- double rows and use 4
    -- ground.minHeight = cardLayoutHeight * 2
end

---@param self KoiKoi.View
---@param parent tes3uiElement
function View.CreateYourCaptured(self, parent)
    local captured = parent:createBlock()
    --captured.borderAllSides = 6
    captured.widthProportional = 1
    captured.heightProportional = 1
    captured.flowDirection = tes3.flowDirection.topToBottom
    captured.childAlignY = 1
    local border = captured:createThinBorder()
    border.widthProportional = 1
    border.autoHeight = true
    border.flowDirection = tes3.flowDirection.topToBottom
    border.childAlignY = 1
    border.borderAllSides = 6
    border.paddingAllSides = 2 -- avoid thin border

    -- local block = captured:createBlock()
    -- block.childAlignX = 0
    -- block.widthProportional = 1
    -- block.autoHeight = true
    -- local label = block:createLabel({text = i18n("koi.view.capturedLabel", {name = self.names[koi.player.you]})})
    -- label.wrapText = true

    local bright = CreateTypeArea(CreateTypeFrame(border), uiid.playerBright, card.type.bright, true)
    local animal = CreateTypeArea(CreateTypeFrame(border), uiid.playerAnimal, card.type.animal, true)
    local ribbon = CreateTypeArea(CreateTypeFrame(border), uiid.playerRibbon, card.type.ribbon, true)
    local chaff = CreateTypeArea(CreateTypeFrame(border), uiid.playerChaff, card.type.chaff, true)

end

---@param self KoiKoi.View
---@param parent tes3uiElement
function View.CreateOpponentCaptured(self, parent)
    local captured = parent:createBlock()
    --captured.borderAllSides = 6
    captured.widthProportional = 1
    captured.autoHeight = true
    captured.flowDirection = tes3.flowDirection.topToBottom
    local border = captured:createThinBorder()
    border.widthProportional = 1
    border.autoHeight = true
    border.flowDirection = tes3.flowDirection.topToBottom
    border.borderAllSides = 6
    border.paddingAllSides = 2 -- avoid thin border

    local bright = CreateTypeArea(CreateTypeFrame(border), uiid.opponentBright, card.type.bright, false)
    local animal = CreateTypeArea(CreateTypeFrame(border), uiid.opponentAnimal, card.type.animal, false)
    local ribbon = CreateTypeArea(CreateTypeFrame(border), uiid.opponentRibbon, card.type.ribbon, false)
    local chaff = CreateTypeArea(CreateTypeFrame(border), uiid.opponentChaff, card.type.chaff, false)
    bright.childAlignX = 1.0
    animal.childAlignX = 1.0
    ribbon.childAlignX = 1.0
    chaff.childAlignX = 1.0

    -- local block = captured:createBlock()
    -- block.childAlignX = 1
    -- block.widthProportional = 1
    -- block.autoHeight = true
    -- local label = block:createLabel({text = i18n("koi.view.capturedLabel", {name = self.names[koi.player.opponent]})})
    -- label.wrapText = true
end

---@param self KoiKoi.View
---@param parent tes3uiElement
---@param service KoiKoi.Service
function View.CreateInfo(self, parent, service)
    local upper = parent:createBlock()
    upper.widthProportional = 1
    upper.autoHeight = true
    upper.flowDirection = tes3.flowDirection.leftToRight
    upper.borderAllSides = 6
    --upper.paddingAllSides = 6

    local exit = upper:createButton({text = i18n("koi.view.exit")})
    local right = upper:createBlock()
    right.widthProportional = 1
    right.autoWidth= true
    right.autoHeight = true
    right.childAlignX = 1.0
    local cards = right:createButton({text = i18n("koi.view.cardList")})
    local combo = right:createButton({text = i18n("koi.view.comboList")})
    local rule = right:createButton({text = i18n("koi.view.quickRule")})
    exit.borderAllSides = 0
    cards.borderAllSides = 0
    combo.borderAllSides = 0
    rule.borderAllSides = 0
    exit:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        if not IsGrabbingCard() then
            self:OnExit(e, service)
        end
    end)
    cards:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        if not IsGrabbingCard() then
            ui.CreateCardList(e)
        end
    end)
    combo:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        if not IsGrabbingCard() then
            ui.CreateCombinationList(e)
        end
    end)

    rule:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        if not IsGrabbingCard() then
            ui.CreateRule(e)
        end
    end)

    local header = tes3ui.getPalette(tes3.palette.headerColor)

    -- local mid = split:createBlock()
    -- mid.widthProportional = 1
    -- mid.autoHeight = true
    -- mid.childAlignX = 0.5
    local rn = parent:createBlock()
    rn.widthProportional = 1
    rn.autoHeight = true
    rn.childAlignX = 0.5
    rn:createLabel({id = uiid.round, text = ""})
    local tn = parent:createBlock()
    tn.widthProportional = 1
    tn.autoHeight = true
    tn.childAlignX = 0.5
    local turn = tn:createLabel({id = uiid.turn, text = ""})
    turn.color = header
    turn.wrapText = true

    local split = parent:createBlock()
    split.widthProportional = 1
    split.heightProportional = 1
    split.flowDirection = tes3.flowDirection.topToBottom

    local opponent = split:createThinBorder()
    opponent.widthProportional = 1
    opponent.heightProportional = 1
    opponent.flowDirection = tes3.flowDirection.topToBottom
    opponent.borderAllSides = 6
    opponent.paddingAllSides = 6
    --opponent.height = cardLayoutHeight * 1.75

    local on = opponent:createBlock()
    on.widthProportional = 1
    --on.autoWidth = true
    on.autoHeight = true
    local oname = on:createLabel({id = uiid.opponentName, text = self.names[koi.player.opponent]})
    oname.color = header
    oname.wrapText = true
    local opponentDealer = on:createLabel({id = uiid.opponentDealer, text = ""})
    opponentDealer.borderLeft = 6

    local os = opponent:createBlock()
    os.autoWidth = true
    os.autoHeight = true
    os:createLabel({text = i18n("koi.view.totalScore")})
    os:createLabel({id = uiid.opponentScore, text = ""}).borderLeft = 6
    opponent:createLabel({text = i18n("koi.view.roundCombo")})
    local opponentCombo = opponent:createBlock({id = uiid.opponentCombination })
    opponentCombo.widthProportional = 1
    opponentCombo.autoWidth = true
    opponentCombo.autoHeight = true
    opponentCombo.flowDirection = tes3.flowDirection.topToBottom

    local you = split:createThinBorder()
    you.widthProportional = 1
    you.heightProportional = 1
    you.flowDirection = tes3.flowDirection.topToBottom
    you.borderAllSides = 6
    you.paddingAllSides = 6
    --you.height = cardLayoutHeight * 1.75

    local yn = you:createBlock()
    yn.widthProportional = 1
    --yn.autoWidth = true
    yn.autoHeight = true
    local yname = yn:createLabel({id = uiid.playerName, text = self.names[koi.player.you]})
    yname.color = header
    yname.wrapText = true
    local playerDealer = yn:createLabel({id = uiid.playerDealer, text = ""})
    playerDealer.borderLeft = 6

    local ys = you:createBlock()
    ys.autoWidth = true
    ys.autoHeight = true
    ys:createLabel({text = i18n("koi.view.totalScore")})
    ys:createLabel({id = uiid.playerScore, text = ""}).borderLeft = 6

    you:createLabel({text = i18n("koi.view.roundCombo")})
    local yourCombo = you:createBlock({id = uiid.playerCombination })
    yourCombo.widthProportional = 1
    yourCombo.autoWidth = true
    yourCombo.autoHeight = true
    yourCombo.flowDirection = tes3.flowDirection.topToBottom
end

---@param id number|string
---@param service KoiKoi.Service
function View.OpenGameMenu(self, id, service)

    -- pre-load all resources?
    --local viewportWidth, viewportHeight = tes3ui.getViewportSize()
    -- estiamte center or right pane height
    local baseHeight = math.max(cardLayoutHeight * 4 + (4 * 4) + (8 * 2), cardLayoutHeightSmall * 8 + (48 * 2) )
    local centerWidth = cardLayoutWidth * 9
    local rightWidth = cardLayoutWidthSmall * 8 + 8 * 2 -- + bordar, padding
    local leftWidth = rightWidth -- same size for easly centering

    local menu = tes3ui.createMenu({ id = id, fixedFrame = true })
    menu:destroyChildren()
    --menu.disabled = true
    menu.absolutePosAlignX = 0.5
	menu.absolutePosAlignY = 0.5
    menu.borderAllSides = 0
    menu.paddingAllSides = 0
    menu.color = { 0.0, 0.0, 0.0 }
    menu.alpha = 0.5
    menu.autoWidth = false
    menu.autoHeight = false
    -- menu.minWidth = viewportWidth / 2
    -- menu.minHeight = viewportHeight / 2
    menu.width = leftWidth + centerWidth + rightWidth
    menu.height = baseHeight
    -- menu.maxWidth = viewportWidth
    -- menu.maxHeight = viewportHeight
    menu.positionX = -menu.width * 0.5 -- center
    menu.positionY = menu.height * 0.5 -- center
    menu.childAlignX = 0.5
    menu.childAlignY = 0.5
    menu.flowDirection = tes3.flowDirection.leftToRight
    --menu:updateLayout()

    local bg = menu:createImage({ path = "Textures/Hanafuda/bg2k.dds" })
    bg.width = menu.width
    bg.height = menu.height
    bg.widthProportional = 1
    bg.heightProportional = 1
    bg.autoWidth = false
    bg.autoHeight = false
    menu:updateLayout() -- for calculate widht and height
    bg.scaleMode = true
    bg.imageScaleX = 1
    bg.imageScaleY = 16.0/9.0 -- original aspect
    bg.childAlignX = 0.5
    bg.childAlignY = 0.5
    bg.flowDirection = tes3.flowDirection.leftToRight
    bg.color = { 0.6, 0.6, 0.6 } -- darker
    bg.alpha = 1.0

    local left = bg:createBlock()
    --left.widthProportional = 0.8
    left.width = leftWidth
    left.heightProportional = 1
    left.flowDirection = tes3.flowDirection.topToBottom
    left.childAlignY = 0.5
    local center = bg:createBlock()
    center.width = centerWidth
    --center.widthProportional = 1.2
    center.heightProportional = 1
    center.flowDirection = tes3.flowDirection.topToBottom
    --center.minWidth = cardLayoutWidth * 8 -- initial card
    center.childAlignY = 0.5
    local right = bg:createBlock()
    -- right.widthProportional = 1
    right.heightProportional = 1
    right.width = rightWidth
    --right.height = cardLayoutHeightSmall * 5
    right.flowDirection = tes3.flowDirection.topToBottom
    right.childAlignY = 0.5

    self:CreateInfo(left, service)

    self:CreateOpponentCaptured(right)
    self:CreateYourCaptured(right)

    local board = center:createBlock()
    -- board.color = { 0.0, 0.0, 0.0 }
    -- board.alpha = 0.5
    board.widthProportional = 1
    board.heightProportional = 1
    board.flowDirection = tes3.flowDirection.topToBottom
    local opponentHand = CreateHandView(board, uiid.opponentHand, 0.75) -- 1/4
    CreateBoard(board, 1.5) -- 2/4
    local playerHand = CreateHandView(board, uiid.playerHand, 0.75)-- 1/4

    -- annoying tooltip?
    opponentHand:register(tes3.uiEvent.help,
    ---@param e uiEventEventData
    function(e)
        if not IsGrabbingCard() then
            local tooltip = tes3ui.createTooltipMenu()
            local label = tooltip:createLabel({ text = i18n("koi.view.hand.opponent") })
        end
    end)
    playerHand:register(tes3.uiEvent.help,
    ---@param e uiEventEventData
    function(e)
        if not IsGrabbingCard() then
            local tooltip = tes3ui.createTooltipMenu()
            local label = tooltip:createLabel({ text = i18n("koi.view.hand.player") })
        end
    end)

    self:RegisterHandEvent(board:findChild(uiid.opponentHand), service)
    self:RegisterHandEvent(board:findChild(uiid.playerHand), service)
    self:RegisterGroundEvent(board:findChild(uiid.boardGroundRow0), service)
    self:RegisterGroundEvent(board:findChild(uiid.boardGroundRow1), service)

    menu:updateLayout()
    -- getting actual size

    -- present card dragging
    local grabMenu = tes3ui.createHelpLayerMenu({ id = uiid.grabMenu }) -- maybe fixedFrame not work
    grabMenu:destroyChildren()
    grabMenu.absolutePosAlignX = nil
    grabMenu.absolutePosAlignY = nil
    grabMenu.borderAllSides = 0
    grabMenu.paddingAllSides = 0
    grabMenu.alpha = 0
    grabMenu.autoWidth = true
    grabMenu.autoHeight = true
    grabMenu.disabled = true
    grabMenu.visible = false
    grabMenu:updateLayout()

    return menu
end

---@param self KoiKoi.View
---@param service KoiKoi.Service
function View.Initialize(self, service)
    -- driver for testing
    if config.development.debug then
        self.testShowDialog = function(_)
            local combo ={
                [koi.combination.fiveBrights] = koi.basePoint[koi.combination.fiveBrights],
                [koi.combination.boarDeerButterfly] = koi.basePoint[koi.combination.boarDeerButterfly],
                [koi.combination.animals] = koi.basePoint[koi.combination.animals] + (10 - 5),
                [koi.combination.poetryAndBlueRibbons] = koi.basePoint[koi.combination.poetryAndBlueRibbons] + (10 - 6),
                [koi.combination.flowerViewingSake] = koi.basePoint[koi.combination.flowerViewingSake],
                [koi.combination.moonViewingSake] = koi.basePoint[koi.combination.moonViewingSake],
                [koi.combination.chaff] = koi.basePoint[koi.combination.chaff] + (12 - 10),
            }

            --self:ShowCallingDialog(koi.player.you, nil, combo, 12, 2)
            self:ShowCombo(koi.player.you, nil, combo, 12, 2)
        end
        event.register(tes3.event.keyDown, self.testShowDialog, {filter = tes3.scanCode.c} )

        self.testCapture = function(_)
            local m = tes3ui.findMenu(uiid.gameMenu)
            assert(m)
            CaptureCard(PutCard(m, 4, false), koi.player.opponent)
            m:updateLayout()
        end
        event.register(tes3.event.keyDown, self.testCapture, {filter = tes3.scanCode.z} )
    end

    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    assert(not gameMenu)
    gameMenu = self:OpenGameMenu(uiid.gameMenu, service)
    tes3ui.enterMenuMode(gameMenu.id)
end

---@param self KoiKoi.View
function View.Shutdown(self)
    local overlayMenu = tes3ui.findHelpLayerMenu(uiid.grabMenu)
    if overlayMenu then
        overlayMenu:destroy()
    end

    local gameMenu = tes3ui.findMenu(uiid.gameMenu)
    if gameMenu then
        gameMenu:destroy()
        tes3ui.leaveMenuMode()
    end

    -- unregister debug key events
    if self.testShowDialog then
        event.unregister(tes3.event.keyDown, self.testShowDialog, {filter = tes3.scanCode.c})
        self.testShowDialog = nil
    end
    if self.testCapture then
        event.unregister(tes3.event.keyDown, self.testCapture, {filter = tes3.scanCode.z})
        self.testCapture = nil
    end
end

---@param e enterFrameEventData
function View:OnEnterFrame(e)
    -- follow cursor
    local grab = tes3ui.findHelpLayerMenu(uiid.grabMenu)
    if grab and grab.visible and not grab.disabled then
        local cursor = tes3.getCursorPosition() -- coordinate is same as ui
        -- TODO need offset by clicking position
        grab.positionX = cursor.x - grab.width * 0.5
        grab.positionY = cursor.y + grab.height * 0.5
        grab:updateLayout()
    end
end

return View
