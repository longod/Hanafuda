local config = require("Hanafuda.config")

-- koikoi
local eventHandler = nil ---@type KoiKoi.EventHandler?
event.register(tes3.event.keyDown,
---@param e keyDownEventData
function(e)
    local mod = e.isAltDown or e.isControlDown or e.isShiftDown or e.isSuperDown
    if mod then
        return
    end
    if eventHandler then
        eventHandler:Unregister()
        eventHandler.service:Destory()
        eventHandler.service = nil
        eventHandler = nil
else
        local logger = require("Hanafuda.logger")
        -- todo need game settings menu
        -- brain, parameters, debug options
        eventHandler = require("Hanafuda.KoiKoi.MWSE.event").new(
            require("Hanafuda.KoiKoi.service").new(
                require("Hanafuda.KoiKoi.game").new(
                    require("Hanafuda.config").koikoi,
                    require("Hanafuda.KoiKoi.brain.randomBrain").new({ koikoiChance = 0.3, meaninglessDiscardChance = 0.1, waitHand = { s = 1, e = 4}, waitDrawn = { s = 0.5, e = 1.5}, waitCalling = { s = 2, e = 4 } }),
                    nil,
                    logger
                ),
                require("Hanafuda.KoiKoi.MWSE.view").new(nil, nil, config.cardStyle, config.cardBackStyle),
                function()
                    if eventHandler then
                        eventHandler:Destory()
                        eventHandler = nil
                    end
                end,
                logger
            )
        )
        eventHandler.service:Initialize()
        eventHandler:Register()
    end
end, {filter = tes3.scanCode.k} )

-- sound player
event.register(tes3.event.keyDown,
---@param e keyDownEventData
function(e)
    local mod = e.isAltDown or e.isControlDown or e.isShiftDown or e.isSuperDown
    if mod then
        return
    end
    require("Hanafuda.KoiKoi.MWSE.sound").CreateSoundPlayer()
end, { filter = tes3.scanCode.v })

-- runner
local function CreateRunner()
    local menuid = "Hanafuda.KoiKoi.Runner"
    local menu = tes3ui.findMenu(menuid)
    if menu then
        menu:destroy()
        tes3ui.leaveMenuMode()
        return
    end
    local logger = require("Hanafuda.logger")

    local params = {
        batchSize = 1,
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
    local batchInput = header:createTextInput({ text = tostring(params.batchSize), numeric = true, placeholderText = "batch" })
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

    local ui = require("Hanafuda.KoiKoi.MWSE.ui")

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
        params.batchSize = ba and math.max(math.ceil(ba), 0) or 1
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

        local runlogger = require("logging.logger").new({
            name = "Hanafuda.Runner",
            logLevel = "DEBUG",
        })

        local batch = table.new(params.batchSize, 0)
        local epoch = 1
        timer.start({
            type = timer.real,
            ---@param callbackData mwseTimerCallbackData
            callback = function(callbackData)
                if cancellation then
                    logger:debug("cancel")
                    callbackData.timer:cancel()
                    e.source.disabled = false
                    menu:updateLayout()
                    return
                end
                runlogger:debug("epoch %d", epoch)
                -- todo use xpcall
                -- todo need factory or abstraction parameters
                -- todo custom house rules, no lucky hands
                table.clear(batch)
                for i = 1, params.batchSize do
                    table.insert(batch, require("Hanafuda.KoiKoi.runner").new(
                        require(relative .. brains[params.p1.index]).new({logger = runlogger}),
                        require(relative .. brains[params.p2.index]).new({logger = runlogger}),
                        runlogger
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

event.register(tes3.event.keyDown,
---@param e keyDownEventData
function(e)
    local mod = e.isAltDown or e.isControlDown or e.isShiftDown or e.isSuperDown
    if mod then
        return
    end

    CreateRunner()

end, { filter = tes3.scanCode.b })
