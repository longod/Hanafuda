local koi = require("Hanafuda.KoiKoi.koikoi")
local card = require("Hanafuda.card")

---@class KoiKoi.Runner
---@field game KoiKoi.Game
---@field state integer
---@field round integer
---@field drawnCard integer?
---@field logger mwseLogger
local this = {}

---@param opponentBrain KoiKoi.IBrain
---@param playerBrain KoiKoi.IBrain
---@param logger mwseLogger?
---@return KoiKoi.Runner
function this.new(opponentBrain, playerBrain, logger)
    --@type KoiKoi.Runner
    local instance = {
        game = require("Hanafuda.KoiKoi.game").new(
            require("Hanafuda.config").koikoi,
            opponentBrain,
            playerBrain,
            logger
        ),
        state = 0,
        round = 1,
        drawnCard = nil,
        logger = logger or require("Hanafuda.logger"),
    }
    setmetatable(instance, { __index = this })
    return instance
end

---@param self KoiKoi.Runner
---@param next integer?
function this.Next(self, next)
    if not next then
        next = self.state + 1
    end
    self.state = next
    return self.state
end

---@param self KoiKoi.Runner
function this.Reset(self)
    self.state = 0
end

---@param self KoiKoi.Runner
function this.Run(self)
    local func = {
        [0] = function ()
            self.logger:debug("Run")
            self.game:Initialize()
            local choices = self.game:ChoiceDecidingParentCards(2)
            self.game:DecideParent(choices[1])
            self.game:DealInitialCards()
            local lh0, total0 = self.game:CheckLuckyHands(koi.player.you)
            local lh1, total1 = self.game:CheckLuckyHands(koi.player.opponent)

            -- todo in game?
            if lh0 or lh1 then
                local tie = lh0 ~= nil and lh1 ~= nil
                local winner = nil
                if not tie then
                    if lh0 then
                        winner = koi.player.you
                    else
                        winner = koi.player.opponent
                    end
                end
                local points = {[koi.player.you] = total0, [koi.player.opponent] = total1}
                if not tie then
                    -- No transition to win, so we settle here.
                    self.game:SetRoundWinnerByLuckyHands(winner, points[winner])
                    self:Next(99)
                end
            else
                self:Next()
            end
        end,
        [1] = function()
            local command = self.game:Simulate(self.game.current, nil, 1, 0)
            if command then
                -- todo com:Execute()
                if command.selectedCard and command.matchedCard then
                    -- match
                    if not koi.CanMatchSuit(command.selectedCard, command.matchedCard) then
                        self.logger:error("wrong matching %d %d", command.selectedCard, command.matchedCard)
                    end
                    self.game:Capture(self.game.current, command.selectedCard, false, false)
                    self.game:Capture(self.game.current, command.matchedCard, true, false)
                elseif not command.matchedCard then
                    -- discard
                    for _, cardId in ipairs(self.game.groundPool) do
                        if koi.CanMatchSuit(command.selectedCard, cardId) then
                            self.logger:error("wrong discarding %d, it can match %d", command.selectedCard, cardId)
                        end
                    end
                    self.game:Discard(self.game.current, command.selectedCard, false)
                else
                    -- skip
                    if table.size(self.game.pools[self.game.current].hand) > 0 then
                        self.logger:error("wrong command, must be choice card in hand")
                    end
                end
                self:Next()
            end
        end,
        [2] = function()
            -- state is optimizable
            self.drawnCard = card.DealCard(self.game.deck)
            self:Next()
        end,
        [3] = function()
            local command = self.game:Simulate(self.game.current, self.drawnCard, 1, 0)
            if command then
                -- todo com:Execute()
                if command.selectedCard and command.matchedCard then
                    -- match
                    if not koi.CanMatchSuit(command.selectedCard, command.matchedCard) then
                        self.logger:error("wrong matching %d %d", command.selectedCard, command.matchedCard)
                    end
                    self.game:Capture(self.game.current, command.selectedCard, false, true)
                    self.game:Capture(self.game.current, command.matchedCard, true, true)
                elseif not command.matchedCard then
                    -- discard
                    for _, cardId in ipairs(self.game.groundPool) do
                        if koi.CanMatchSuit(command.selectedCard, cardId) then
                            self.logger:error("wrong discarding %d, it can match %d", command.selectedCard, cardId)
                        end
                    end
                    self.game:Discard(self.game.current, command.selectedCard, true)
                else
                    -- skip
                    if self.drawnCard then
                        self.logger:error("wrong command, must be matching or discard %d", self.drawnCard)
                    else
                        self.logger:error("wrong drawnCard is nil")
                    end
                end
                self.drawnCard = nil
                local combo = self.game:CheckCombination(self.game.current)
                if combo then
                    self:Next()
                else
                    self:Next(5)
                end
            end
        end,
        [4] = function()
            local combo = self.game.combinations[self.game.current]
            if combo then
                local command = self.game:Call(self.game.current, self.game.combinations[self.game.current], 1, 0)
                if command then
                    if command.calling == koi.calling.koikoi then
                        -- continue
                        self:Next()
                    elseif command.calling == koi.calling.shobu then
                        -- finish
                        self:Next(99)
                    end
                end
            else
                -- no comb
                self.logger:error("wrong state")
                self:Next()
            end
        end,
        [5] = function()
            if self.game:CheckEnd() then
                self:Next(100)
            else
                self.game:SwapPlayer()
                self:Next(1)
            end
        end,
        [99] = function()
            -- self.game.current won
            -- add score
            -- round increment
            self:Next()
        end,
        [100] = function()
            -- add score
            -- round increment
            -- next
            self:Next()
        end,
    }
    if func[self.state] then
        func[self.state]()
        return true
    end
    self.logger:debug("Finished")
    -- todo output statics. brain, winner, turn, point, combo, koikoi count, etc...
    return false
end

function this.Runner()
    local menuid = "Hanafuda.KoiKoi.Runner"
    local menu = tes3ui.findMenu(menuid)
    if menu then
        menu:destroy()
        tes3ui.leaveMenuMode()
        return
    end
    local logger = require("Hanafuda.logger")

    local params = {
        batch = 1,
        iteration = 1,
        epoch = 1,
        p1 = { index = 1 },
        p2 = { index = 1 },
    }

    menu = tes3ui.createMenu({ id = menuid, fixedFrame = true })
    menu.autoWidth = true
    menu.autoHeight = true
    menu.minWidth = 560
    menu.minHeight = 400
    menu.flowDirection = tes3.flowDirection.topToBottom
    local root = menu:createBlock()
    root.widthProportional = 1
    root.heightProportional = 1
    root.autoWidth = true
    root.autoHeight = true
    root.flowDirection = tes3.flowDirection.topToBottom

    local header = root:createBlock()
    header.widthProportional = 1
    header.autoWidth = true
    header.autoHeight = true
    header.flowDirection = tes3.flowDirection.leftToRight

    header:createLabel({ text = "batch: " }).borderRight = 6
    local batchInput = header:createTextInput({ text = tostring(params.batch), numeric = true, placeholderText = "batch" })
    batchInput.widthProportional = 1
    batchInput:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        tes3ui.acquireTextInput(e.source)
    end)

    header:createLabel({ text = "iteration: " }).borderRight = 6
    local iterationInput = header:createTextInput({ text = tostring(params.iteration), numeric = true, placeholderText = "iteration" })
    iterationInput.widthProportional = 1
    iterationInput:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        tes3ui.acquireTextInput(e.source)
    end)
    header:createLabel({ text = "epoch: "}).borderRight = 6
    local epochInput = header:createTextInput({ text = tostring(params.epoch), numeric = true, placeholderText = "epoch" })
    epochInput.widthProportional = 1
    epochInput:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function(e)
        tes3ui.acquireTextInput(e.source)
    end)

    root:createDivider().widthProportional = 1

    local parent = root:createBlock()
    parent.widthProportional = 1
    parent.heightProportional = 1
    parent.autoWidth = true
    parent.autoHeight = true
    parent.flowDirection = tes3.flowDirection.topToBottom

    local p1 = parent:createBlock()
    p1.widthProportional = 1
    p1.heightProportional = 1
    p1.autoWidth = true
    p1.autoHeight = true
    p1.flowDirection = tes3.flowDirection.topToBottom
    local p2 = parent:createBlock()
    p2.widthProportional = 1
    p2.heightProportional = 1
    p2.autoWidth = true
    p2.autoHeight = true
    p2.flowDirection = tes3.flowDirection.topToBottom

    local dir = "Data Files\\MWSE\\mods\\Hanafuda\\KoiKoi\\brain\\"
    local relative = "Hanafuda.KoiKoi.brain."
    local brains = {}
    for file in lfs.dir(dir) do
        if not file:startswith(".") and file:endswith(".lua") and file ~= "brain.lua" then
            local lua = file:sub(1, file:len() - 4)
            logger:trace(relative .. lua)
            table.insert(brains, lua)
        end
    end

    local ui = require("Hanafuda.KoiKoi.ui")

    local pane1 = ui.CreateSimpleListBox(nil, p1, brains, function (selectedIndex)
        params.p1.index = selectedIndex
    end, params.p1.index)
    local pane2 = ui.CreateSimpleListBox(nil, p2, brains, function (selectedIndex)
        params.p2.index = selectedIndex
    end, params.p2.index)
    -- todo parameters settings ui

    local footer = parent:createBlock()
    footer.widthProportional = 1
    -- parent.heightProportional = 1
    footer.autoWidth = true
    footer.autoHeight = true
    footer.flowDirection = tes3.flowDirection.leftToRight
    local run = footer:createButton({ text = "Run"})
    local cancel = footer:createButton({ text = "Cancel"})
    local cancellation = false
    cancel:register(tes3.uiEvent.mouseClick, function ()
        cancellation = true
    end)

    run:register(tes3.uiEvent.mouseClick,
    ---@param e uiEventEventData
    function (e)
        e.source.disabled = true
        menu:updateLayout()

        cancellation = false

        local ba = tonumber(batchInput.text)
        params.batch = ba and math.max(math.ceil(ba), 0) or 1
        local it = tonumber(iterationInput.text)
        params.iteration = it and math.max(math.ceil(it), 0) or 1
        local ep = tonumber(epochInput.text)
        params.epoch = ep and math.max(math.ceil(ep), 0) or 1

        ---@param batch KoiKoi.Runner[]
        ---@param iteration integer
        ---@param epoch integer
        local function Run(batch, iteration, epoch)
            for _, runner in ipairs(batch) do
                runner:Reset()
                while runner:Run() do
                end
                -- TODO gather result
            end
        end

        local log = require("logging.logger").new({
            name = "Hanafuda.Runner",
            logLevel = "DEBUG",
        })

        local batch = table.new(params.batch, 0)
        local epoch = 1
        timer.start({
            type = timer.real,
            ---@param callbackData mwseTimerCallbackData
            callback = function(callbackData)
                if cancellation then
                    callbackData.timer:cancel()
                    log:debug("cancel")
                    e.source.disabled = false
                    menu:updateLayout()
                    return
                end
                log:debug("epoch %d", epoch)
                -- todo use xpcall
                -- todo need factory or abstraction parameters
                table.clear(batch)
                for i = 1, params.batch do
                    table.insert(batch, this.new(
                        require(relative .. brains[params.p1.index]).new({logger = log}),
                        require(relative .. brains[params.p2.index]).new({logger = log}),
                        log
                    ))
                end
                for iteration = 1, params.iteration do
                    Run(batch, iteration, epoch)
                end
                if epoch >= params.epoch then
                    e.source.disabled = false
                    menu:updateLayout()
                end
                epoch = epoch + 1
            end,
            iterations = params.epoch,
            duration = 0.1, -- hmm
            persist = false,
        })

    end)


    menu:updateLayout()
    pane1.widget:contentsChanged() ---@diagnostic disable-line: param-type-mismatch
    pane2.widget:contentsChanged() ---@diagnostic disable-line: param-type-mismatch
    tes3ui.enterMenuMode(menuid)

end

return this
