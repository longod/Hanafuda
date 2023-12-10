
local koi = require("Hanafuda.KoiKoi.koikoi")
local card = require("Hanafuda.card")
local combination = require("Hanafuda.KoiKoi.combination")

---@class KoiKoi.IMCTS.Action
---@field player KoiKoi.Player
---@field cardId integer?
---@field captured integer[]? nil is discard
---@field calling KoiKoi.Calling?
local Action = {}

---@param player KoiKoi.Player
---@param cardId integer?
---@param captured integer[]? nil is discard
---@param calling KoiKoi.Calling?
---@return KoiKoi.IMCTS.Action
function Action.new(player, cardId, captured, calling)
    ---@type KoiKoi.IMCTS.Action
    local instance = {
        player = player,
        cardId = cardId,
        captured = captured,
        calling = calling,
    }
    setmetatable(instance, { __index = Action })
    return instance
end

-- own game state
---@enum KoiKoi.IMCTS.Phase
local phase = {
    matchCard = 1,
    matchDrawCard = 2,
    calling = 3,

    tie = 10,
    win = 11,
    lose = 12,
}


---@class KoiKoi.IMCTS.State
---@field player KoiKoi.Player
---@field phase KoiKoi.IMCTS.Phase
---@field params KoiKoi.AI.Params
---@field action KoiKoi.IMCTS.Action?
---@field combinations { KoiKoi.Player : { [KoiKoi.CombinationType] : integer } }
---@field rewardScaler number
---@field logger mwseLogger?
local State = {}

---@param player KoiKoi.Player
---@param phase KoiKoi.IMCTS.Phase
---@param params KoiKoi.AI.Params -- TODO Minimum parameters as they will be copied.
---@param combinations { KoiKoi.Player : { [KoiKoi.CombinationType] : integer } }
---@param action KoiKoi.IMCTS.Action?
---@param rewardScaler number
---@param logger mwseLogger?
---@return KoiKoi.IMCTS.State
function State.new(player, phase, params, combinations, action, rewardScaler, logger)
    ---@type KoiKoi.IMCTS.State
    local instance = {
        player = player,
        phase = phase,
        params = params,
        action = action,
        rewardScaler = rewardScaler,
        combinations = combinations, -- maybe need parent combos
        logger = logger,
    }
    setmetatable(instance, { __index = State })
    return instance
end

---@param self KoiKoi.IMCTS.State
---@return boolean
function State.IsTermianl(self)
    -- opponent?
    --if self.action and self.action.calling == koi.calling.shobu then
    if self.phase == phase.tie or self.phase == phase.win or self.phase == phase.lose then
        return true
    end
    -- if table.size(self.params.pool.hand) == 0 and table.size(self.params.opponentPool.hand) == 0 then
    --     return true
    -- end
    return false
end

---comment
---@param player KoiKoi.Player
---@param cardId integer
---@param ground integer[]
---@return KoiKoi.IMCTS.Action[]
local function GenerateCardActions(player, cardId, ground)
    local ids = {}
    for _, id in ipairs(ground) do
        if koi.CanMatchSuit(cardId, id) then
            table.insert(ids, id)
        end
    end
    local size = table.size(ids)
    if size > 0 then
        if size >= 3 then -- Capture three at a time.
            return { Action.new(player, cardId, ids, nil) }
        else
            -- capture a card
            local actions = table.new(size, 0) ---@type KoiKoi.IMCTS.Action[]
            for _, id in ipairs(ids) do
                table.insert(actions, Action.new(player, cardId, {id}, nil))
            end
            return actions
        end
    else
        -- discard
        return { Action.new(player, cardId, nil, nil) }
    end
end

-- unseen cards
---@param p KoiKoi.AI.Params
---@return integer[]
local function GenerateProbabilityCardList(p)
    -- TODO optimize to use hash
    local prob = card.CreateDeck() -- non-shuffle, expects [index] == index
    if p.drawnCard then
        local r = table.removevalue(prob, p.drawnCard)
        assert(r)
    end
    -- own hand
    for _, value in ipairs(p.pool.hand) do
        local r = table.removevalue(prob, value)
        assert(r)
    end
    -- captured
    for _, t in pairs(card.type) do
        for _, value in ipairs(p.pool[t]) do
            local r = table.removevalue(prob, value)
            assert(r)
        end
        for _, value in ipairs(p.opponentPool[t]) do
            local r = table.removevalue(prob, value)
            assert(r)
        end
    end
    -- ground
    for _, value in ipairs(p.groundPool) do
        local r = table.removevalue(prob, value)
        assert(r)
    end
    -- mwse.log(table.size(prob))
    return prob
end

---comments
---@param self KoiKoi.IMCTS.State
---@return KoiKoi.IMCTS.Action[]
function State.CollectLegalActions(self)
    local you = self.player == koi.player.you
    local pool = you and self.params.pool or self.params.opponentPool

    -- continue or win
    if self.phase == phase.calling then
        if table.size(pool.hand) > 0 then
            --self.logger:debug("calling")
            return { Action.new(self.player, nil, nil, koi.calling.shobu), Action.new(self.player, nil, nil, koi.calling.koikoi) }
        else
            --self.logger:debug("calling (force win)")
            return { Action.new(self.player, nil, nil, koi.calling.shobu) }
        end
    end

    if self.phase == phase.matchDrawCard then
        if self.params.drawnCard then -- exists actual drawn card
            local actions = GenerateCardActions(self.player, self.params.drawnCard, self.params.groundPool)
            -- self.logger:debug("draw %d", table.size(actions))
            return actions
        else
            local prob = GenerateProbabilityCardList(self.params)
            local concat = table.new(table.size(prob) * 2, 0) ---@type KoiKoi.IMCTS.Action[]
            for _, cardId in ipairs(prob) do
                local actions = GenerateCardActions(self.player, cardId, self.params.groundPool)
                for _, a in ipairs(actions) do
                    table.insert(concat, a)
                end
            end
            -- self.logger:debug("probability draw %d", table.size(concat))
            return concat
        end
    else
        -- hand
        if you then
            local concat = table.new(table.size(pool.hand) * 2, 0) ---@type KoiKoi.IMCTS.Action[]
            for _, cardId in ipairs(pool.hand) do
                local actions = GenerateCardActions(self.player, cardId, self.params.groundPool)
                for _, a in ipairs(actions) do
                    table.insert(concat, a)
                end
            end
            -- self.logger:debug("hand %d", table.size(concat))
            return concat
        else
            local prob = GenerateProbabilityCardList(self.params)
            local concat = table.new(table.size(prob) * 2, 0) ---@type KoiKoi.IMCTS.Action[]
            for _, cardId in ipairs(prob) do
                local actions = GenerateCardActions(self.player, cardId, self.params.groundPool)
                for _, a in ipairs(actions) do
                    table.insert(concat, a)
                end
            end
            -- self.logger:debug("probability hand %d", table.size(concat))
            return concat
        end
    end
end

---@param self KoiKoi.IMCTS.State
---@param action KoiKoi.IMCTS.Action
---@return KoiKoi.IMCTS.State
function State.NextState(self, action)

    local p = table.deepcopy(self.params) ---@type KoiKoi.AI.Params
    local c = table.deepcopy(self.combinations) ---@type  { KoiKoi.Player : { [KoiKoi.CombinationType] : integer } }
    local player = action.player
    local you = self.player == koi.player.you
    local pool = you and p.pool or p.opponentPool

    ---@param ph KoiKoi.IMCTS.Phase
    local handleCard = function (ph)
        local cardId = action.cardId
        assert(cardId)
        if action.captured then
            -- capture
            assert(table.size(action.captured) > 0 and table.size(action.captured) <= 3)
            table.insert(pool[card.GetCardData(cardId).type], cardId)
            for _, id in ipairs(action.captured) do
                table.insert(pool[card.GetCardData(id).type], id)
                local removed = table.removevalue(p.groundPool, id)
            end
        else
            -- discard
            table.insert(p.groundPool, cardId)
        end

        -- release current card
        if ph == phase.matchCard then
            if you then
                local removed = table.removevalue(pool.hand, cardId)
            else
                -- Reduce the number of cards in opponent hand by one, whatever it is, to make it count.
                local removed = table.remove(pool.hand)
            end
        else
            p.drawnCard = nil
        end

    end

    -- self.logger:debug("current phase %d", self.phase)

    ---@type {[KoiKoi.IMCTS.Phase] : fun(ph: KoiKoi.IMCTS.Phase): KoiKoi.IMCTS.Phase}
    local transit = {
        [phase.matchCard] = function(ph)
            handleCard(ph)
            -- auto draw
            -- assert(p.drawnCard == nil)
            -- p.drawnCard = card.DealCard(p.deck)

            return phase.matchDrawCard
        end,
        [phase.matchDrawCard] = function(ph)
            handleCard(ph)
            -- check combo
            local houseRule = p.houseRule
            local combo = combination.Calculate(pool, houseRule, self.logger)
            local diff = combination.Different(combo, c[player], self.logger)

            -- self.logger:debug("your hand %d", table.size(p.pool.hand))
            -- self.logger:debug("opponent hand %d", table.size(p.opponentPool.hand))

            if diff then
                c[player] = combo
                return phase.calling
            elseif table.size(p.pool.hand) == 0 and table.size(p.opponentPool.hand) == 0 then
                return phase.tie
            else
                -- swap player
                player = player == koi.player.you and koi.player.opponent or koi.player.you
                return phase.matchCard
            end
        end,
        [phase.calling] = function(ph)
            assert(action.calling)
            if action.calling == koi.calling.shobu then
                if player == koi.player.you then
                    return phase.win
                else
                    return phase.lose
                end
            else
                -- swap player
                player = player == koi.player.you and koi.player.opponent or koi.player.you
                return phase.matchCard
            end
        end,
    }
    --self.logger:debug("phase " .. tostring(self.phase))
    local next = transit[self.phase](self.phase)

    return State.new(player, next, p, c, action, self.rewardScaler, self.logger)
end

---@param self KoiKoi.IMCTS.State
---@param player KoiKoi.Player
---@return integer basePoint
---@return integer multiplier
function State.CalculateScore(self, player)
    ---@param combo { [KoiKoi.CombinationType] : integer }
    ---@return integer
    local function SumTotalPoint(combo)
        local total = 0
        for _, value in pairs(combo) do
            total = total + value
        end
        return total
    end

    local point = 0
    local mult = 1
    if self.combinations[player] then
        point = SumTotalPoint(self.combinations[player])
        -- It does not necessarily have to be an exact score. It would be easier to focus on selections that score higher.
        --[[
        local houseRule = require("Hanafuda.KoiKoi.houseRule")
        if self.params.houseRule.multiplier == houseRule.multiplier.doublePointsOver7 then
            if point >= 7 then
                mult = 2
            end
        elseif self.params.houseRule.multiplier == houseRule.multiplier.eachTimeKoiKoi then
            -- TODO call-time
            --mult = 1 + self.calls[koi.player.you] + self.calls[koi.player.opponent]
        end
        --]]--
    end
    return point, mult
end

---comment
---@param self KoiKoi.IMCTS.State
---@return number
function State.CalculateReward(self)
    -- TODO Is [-1,1] or [-n,n] better for the range of reward?
    -- or [0,1] win:1, lose:0, tie:0.5? ideals UCB1 parameter is 1?
    -- With [-n,n], I think the more attempts, the larger q/n will be and the more biased it will be...
    -- In any case, if the normalization range is greatly exceeded, it seems that the intensive search for certain selections will spoil the search for others.
    if self.phase == phase.win then
        local point, mult = self:CalculateScore(koi.player.you)
        return 1 * math.max(point * mult * self.rewardScaler, 1)
    elseif self.phase == phase.lose then
        local point, mult = self:CalculateScore(koi.player.opponent)
        return -1 * math.max(point * mult * self.rewardScaler, 1)
    end
    return 0
end

---@class KoiKoi.IMCTS.Node
---@field state KoiKoi.IMCTS.State
---@field parent KoiKoi.IMCTS.Node?
---@field children KoiKoi.IMCTS.Node[]
---@field ucb1Param number
---@field visited integer
---@field result number
---@field untriedActions KoiKoi.IMCTS.Action[]?
---@field logger mwseLogger?
local Node = {}

---@param state KoiKoi.IMCTS.State
---@param parent KoiKoi.IMCTS.Node?
---@param ucb1Param number
---@param logger mwseLogger?
---@return KoiKoi.IMCTS.Node
function Node.new(state, parent, ucb1Param, logger)
    ---@type KoiKoi.IMCTS.Node
    local instance = {
        state = state,
        parent = parent,
        children = {},
        ucb1Param = ucb1Param,
        visited = 0,
        result = 0,
        untriedActions = nil,
        logger = logger,
    }
    setmetatable(instance, { __index = Node })
    return instance
end

---@param self KoiKoi.IMCTS.Node
---@return boolean
function Node.IsTermianl(self)
    return self.state:IsTermianl()
end

---@param self KoiKoi.IMCTS.Node
---@return boolean
function Node.IsFullyExpanded(self)
    return table.size(self:CollectUntriedActions()) == 0
end

--- total simulation reward
---@param self KoiKoi.IMCTS.Node
---@return number
function Node.q(self)
    return self.result
end

--- total number of visits
---@param self KoiKoi.IMCTS.Node
---@return integer
function Node.n(self)
    return self.visited
end

---@param self KoiKoi.IMCTS.Node
---@param cp number hyperparameter of search
---@return number[]
function Node.UCB1(self, cp)
    local ln = 2.0 * math.log(self:n()) -- m log(n)/2nj m=4
    local ucb1 = table.new(table.size(self.children), 0) ---@type number[]
    for _, c in ipairs(self.children) do
        local v = 0
        if c:n() > 0 then -- This is when it never backpropagate, so when it skips because it is a single action
            v = c:q() / c:n() + cp * math.sqrt(ln / c:n())
        end
        table.insert(ucb1, v)
    end
    return ucb1
end

---@param self KoiKoi.IMCTS.Node
---@return KoiKoi.IMCTS.Node?
---@return integer
---@return number
function Node.SelectBestChild(self)
    local count = table.size(self.children)
    if count  == 0 then
        return nil, 0, 0
    elseif count == 1 then
        return self.children[1], 1, 0
    end

    local ucb1 = self:UCB1(self.ucb1Param)
    -- local index = table.maxn(ucb1) -- useless if contain negative value
    --self.logger:debug(table.concat(ucb1, ", "))
    local index = 1
    local max = ucb1[1]
    for i, v in ipairs(ucb1) do
        if max < v then
            index = i
            max = v
        end
    end
    assert(index > 0)
    return self.children[index], index, max
end

---@param self KoiKoi.IMCTS.Node
---@return KoiKoi.IMCTS.Action[]
---@return boolean
function Node.CollectUntriedActions(self)
    local first = false
    if not self.untriedActions then
        self.untriedActions = self.state:CollectLegalActions()
        first = true
    end
    -- self.logger:debug("untriedActions %d", table.size(self.untriedActions))
    return self.untriedActions, first
end


---@param self KoiKoi.IMCTS.Node
---@return KoiKoi.IMCTS.Node
function Node.Expand(self)
    local actions = self:CollectUntriedActions()
    assert(actions)
    assert(table.size(actions) > 0)
    local action = table.remove(actions, 1)
    local state = self.state:NextState(action)
    local child = Node.new(state, self, self.ucb1Param, self.logger)
    table.insert(self.children, child)
    return child
end

---@param actions KoiKoi.IMCTS.Action[]
---@return KoiKoi.IMCTS.Action
local function RolloutPolicy(actions)
    local action = table.choice(actions)
    return action
end

---@param self KoiKoi.IMCTS.Node
---@return integer
function Node.Rollout(self)
    local state = self.state
    while not state:IsTermianl() do
        local actions = state:CollectLegalActions()
        -- self.logger:debug("Rollout actions %d", table.size(actions))
        local action = RolloutPolicy(actions)
        state = state:NextState(action)
    end
    return state:CalculateReward()
end

---@param self KoiKoi.IMCTS.Node
---@param result integer
function Node.Backpropagate(self, result)
    self.visited = self.visited + 1
    self.result = self.result + result
    -- self.results[result] = table.get(self.results, result, 0) + 1
    if self.parent then
        self.parent:Backpropagate(result)
    end
end

---@param root KoiKoi.IMCTS.Node
---@return KoiKoi.IMCTS.Node?
local function InsertNodeWithTreePolicy(root)
    -- If only one action is available, no attempt is made.
    local rootAction, firstTime = root:CollectUntriedActions()
    if firstTime and table.size(rootAction) == 1 then
        local _ = root :Expand()
        return nil -- single action
    end

    local node = root ---@type KoiKoi.IMCTS.Node?
    while node and not node:IsTermianl() do
        if node:IsFullyExpanded() then
            node = node:SelectBestChild()
        else
            -- insert
            return node:Expand()
        end
    end
    return node
end


-- can detect all rollout?
---@param root KoiKoi.IMCTS.Node
---@return boolean
local function Dispatch(root)
    local intersectedNode = InsertNodeWithTreePolicy(root)
    if intersectedNode then
        local reward = intersectedNode:Rollout()
        intersectedNode:Backpropagate(reward)
        return true
    end
    return false
end


--- Monte Carlo Tree Search (Imperfect Information)
--- The best move is selected from the results obtained by trying the game in Monte Carlo Tree Search.
--- Imperfect information is used, NOT including the opponent's cards in hand and in the deck.
--- This is fair.
--- However, the number of moves is enormous because the rollout is based on a list of all the moves that can be naively assumed.
--- It also does not seem good that the value of playing the real and hypothetical hands is the same.
---@class KoiKoi.IMCTSBrain : KoiKoi.IBrain
---@field node KoiKoi.IMCTS.Node?
---@field iteration integer
---@field maxIteration integer
---@field timeSlicing number seconds
---@field ucb1Param number -- 0 <= n It seems smaller values tend to be stronger. Become more focused on the outcome of the child.
---@field rewardScaler number -- 0 <= m (<= 1) Smaller values seem to simply place more emphasis on winning and losing, while larger values seem to place more emphasis on winning with high scores.
local this = {}
local brain = require("Hanafuda.KoiKoi.brain.brain")
setmetatable(this, {__index = brain})

---@type KoiKoi.IMCTSBrain
local defaults = {
    node = nil,
    iteration = 0,
    maxIteration = 10000,
    timeSlicing = 0.002, -- ms
    ucb1Param = 1,
    rewardScaler = 0.25,
}

---@class KoiKoi.IMCTSBrain.Params : KoiKoi.IBrain.Params
---@field maxIteration integer?
---@field timeSlicing number? seconds
---@field ucb1Param number?
---@field rewardScaler number?

---@param params KoiKoi.IMCTSBrain.Params?
---@return KoiKoi.IMCTSBrain
function this.new(params)
    local instance = brain.new(params)
    ---@cast instance KoiKoi.IMCTSBrain
    table.copymissing(instance, defaults)
    setmetatable(instance, { __index = this })
    instance:PrintHyperparameters()
    return instance
end

---@param params KoiKoi.IBrain.GenericParams
---@return KoiKoi.IMCTSBrain
function this.generate(params)
    return this.new({
        logger = params.logger,
        maxIteration = params.numbers[1] > 0 and 10 * math.exp(10 * params.numbers[1]) or defaults.maxIteration,
        ucb1Param = params.numbers[2] > 0 and math.max(params.numbers[2] * 2, 0) or defaults.ucb1Param,
        rewardScaler = params.numbers[3] > 0 and math.max(params.numbers[3], 0) or defaults.rewardScaler,
    })
end

---@param self KoiKoi.IMCTSBrain
function this.PrintHyperparameters(self)
    self.logger:debug("maxIteration: %d", self.maxIteration)
    self.logger:debug("ucb1Param: %f", self.ucb1Param)
    self.logger:debug("rewardScaler: %f", self.rewardScaler)
end

---@param self KoiKoi.IMCTSBrain
function this.Reset(self)
    self.node = nil
    self.iteration = 0
end

---@param self KoiKoi.IMCTSBrain
---@param root KoiKoi.IMCTS.Node
---@return KoiKoi.IMCTS.Node?
function this.Dispatch(self, root)
    assert(root)
    -- TODO How many attempts is appropriate?
    local iteration = self.maxIteration and self.maxIteration - self.iteration or nil
    local duration = self.timeSlicing -- seconds
    assert(iteration ~= nil or duration ~= nil)
    local it = 0
    local beginTime = os.clock() -- too low acculacy?
    --self.logger:debug(beginTime)
    local breaked = false
    while (iteration == nil or it < iteration) and (duration == nil or (os.clock() - beginTime) < duration) do
        it = it + 1
        if not Dispatch(root) then
            self.logger:debug("break")
            breaked = true
            break
        end
    end
    --self.logger:debug(os.clock() - beginTime)
    --self.logger:debug("iteration %d", it)

    -- break and continue
    if (not breaked) and iteration then
        self.iteration = self.iteration + it
        --self.logger:debug("total iteration %d", self.iteration )
        if self.iteration < self.maxIteration then
            return nil
        end
    end

    local best, index, max = root:SelectBestChild()
    self.logger:debug("best %d (%f)", index, max)

    local ucb1 = root:UCB1(self.ucb1Param)
    for i, child in ipairs(root.children) do
        self.logger:debug("%d: %d/%d (%f)", i, child:q(), child:n(), ucb1[i] )
    end
    -- if best then
    --     self.logger:assert(ucb1[index] == max, "mismatch max UCB1!" )
    -- end

    self.logger:assert(best ~= nil, "It's impossible not to have a best action.")

    return best
end

---@param self KoiKoi.IMCTSBrain
---@param p KoiKoi.AI.Params
---@return KoiKoi.MatchCommand?
function this.Simulate(self, p)

    -- The same situation should be maintained, but it would be nice to be able to validate it
    if self.node == nil then
        local houseRule = p.houseRule
        -- FIXME pass from service or runner
        local combos = {
            [koi.player.you] = combination.Calculate(p.pool, houseRule, self.logger),
            [koi.player.opponent] = combination.Calculate(p.opponentPool, houseRule, self.logger),
        }
        local state = State.new(koi.player.you, p.drawnCard and phase.matchDrawCard or phase.matchCard, table.deepcopy(p), combos, nil, self.rewardScaler, self.logger)
        self.node = Node.new(state, nil, self.ucb1Param, self.logger)
        self.iteration = 0
    end
    local best = self:Dispatch(self.node)
    if best then
        self.logger:debug("Q/N %d/%d", best:q(), best:n())
        self.node = nil
        if best.state.action then
            if best.state.action.captured then
                self.logger:debug("action card %d", best.state.action.cardId)
                self.logger:debug("action captured %s", table.concat(best.state.action.captured, ", "))
                return { selectedCard = best.state.action.cardId, matchedCard = best.state.action.captured[1] }
            elseif best.state.action.cardId then
                self.logger:debug("action discard %d", best.state.action.cardId)
                return { selectedCard = best.state.action.cardId, matchedCard = nil } -- discard
            else
                self.logger:debug("action calling " .. tostring(best.state.action.calling))
                self.logger:error("invalid action")
            end
        end
    end
    -- continue thinking
    return nil

    -- fallback
    -- return { selectedCard = nil, matchedCard = nil } -- skip
end

---@param self KoiKoi.IMCTSBrain
---@param p KoiKoi.AI.Params
---@return KoiKoi.CallCommand?
function this.Call(self, p)
    -- The same situation should be maintained, but it would be nice to be able to validate it
    if self.node == nil then
        -- perhaps can be saved and taken over to the next frame.
        local houseRule = p.houseRule
        -- FIXME pass from service or runner
        local combos = {
            [koi.player.you] = combination.Calculate(p.pool, houseRule, self.logger),
            [koi.player.opponent] = combination.Calculate(p.opponentPool, houseRule, self.logger),
        }
        local state = State.new(koi.player.you, phase.calling, table.deepcopy(p), combos, nil, self.rewardScaler, self.logger)
        self.node = Node.new(state, nil, self.ucb1Param, self.logger)
        self.iteration = 0
    end
    local best = self:Dispatch(self.node)
    if best then
        self.logger:debug("Q/N %d/%d", best:q(), best:n())
        self.node = nil
        if best.state.action then
            if best.state.action.captured then
                self.logger:debug("action card %d", best.state.action.cardId)
                self.logger:debug("action captured %s", table.concat(best.state.action.captured, ", "))
                --return { selectedCard = best.state.action.cardId, matchedCard = best.state.action.captured[1] }
                self.logger:error("invalid action")
            elseif best.state.action.cardId then
                self.logger:debug("action discard %d", best.state.action.cardId)
                self.logger:error("invalid action")
                --return { selectedCard = best.state.action.cardId, matchedCard = nil } -- discard
            else
                self.logger:debug("action calling " .. tostring(best.state.action.calling))
                return { calling = best.state.action.calling }
            end
        end
    end
    -- continue thinking
    return nil

    -- fallback
    -- return { calling = koi.calling.shobu }
end

return this
