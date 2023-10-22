-- Monte Carlo Tree Search
-- The best move is selected from the results obtained by trying the game in Monte Carlo Tree Search.
-- Perfect information is used, including the opponent's cards in hand and in the deck.
-- This is a cheat, but it helps to step up to advanced AI.

local koi = require("Hanafuda.KoiKoi.koikoi")
local card = require("Hanafuda.card")
local combination = require("Hanafuda.KoiKoi.combination")

---@class KoiKoi.MCTS.Action
---@field player KoiKoi.Player
---@field cardId integer?
---@field captured integer[]? nil, zero is discard
---@field calling KoiKoi.Calling?
local Action = {}

---@param player KoiKoi.Player
---@param cardId integer?
---@param captured integer[]? nil, zero is discard
---@param calling KoiKoi.Calling?
---@return KoiKoi.MCTS.Action
function Action.new(player, cardId, captured, calling)
    ---@type KoiKoi.MCTS.Action
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
---@enum KoiKoi.MCTS.Phase
local phase = {
    matchCard = 1,
    matchDrawCard = 2,
    calling = 3,

    tie = 10,
    win = 11,
    lose = 12,
}


---@class KoiKoi.MCTS.State
---@field player KoiKoi.Player
---@field phase KoiKoi.MCTS.Phase
---@field params KoiKoi.AI.Params
---@field action KoiKoi.MCTS.Action?
---@field combinations { KoiKoi.Player : { [KoiKoi.CombinationType] : integer } }
---@field logger mwseLogger?
local State = {}

---@param player KoiKoi.Player
---@param phase KoiKoi.MCTS.Phase
---@param params KoiKoi.AI.Params -- TODO Minimum parameters as they will be copied.
---@param combinations { KoiKoi.Player : { [KoiKoi.CombinationType] : integer } }
---@param action KoiKoi.MCTS.Action?
---@param logger mwseLogger?
---@return KoiKoi.MCTS.State
function State.new(player, phase, params, combinations, action, logger)
    ---@type KoiKoi.MCTS.State
    local instance = {
        player = player,
        phase = phase,
        params = params,
        action = action,
        logger = logger,
        combinations = combinations, -- maybe need parent combos
    }
    setmetatable(instance, { __index = State })
    return instance
end

---@param self KoiKoi.MCTS.State
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
---@return KoiKoi.MCTS.Action[]
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
            local actions = table.new(size, 0) ---@type KoiKoi.MCTS.Action[]
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

---comments
---@param self KoiKoi.MCTS.State
---@return KoiKoi.MCTS.Action[]
function State.CollectLegalActions(self)
    local pool = self.player == koi.player.you and self.params.pool or self.params.opponentPool

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

    if self.params.drawnCard then
        local actions = GenerateCardActions(self.player, self.params.drawnCard, self.params.groundPool)
        --self.logger:debug("draw %d", table.size(actions))
        return actions
    else
        -- hand
        local concat = table.new(table.size(pool.hand) * 2, 0) ---@type KoiKoi.MCTS.Action[]
        for _, cardId in ipairs(pool.hand) do
            local actions = GenerateCardActions(self.player, cardId, self.params.groundPool)
            for _, a in ipairs(actions) do
                table.insert(concat, a)
            end
        end
        --self.logger:debug("hand %d", table.size(concat))
        return concat
    end
end

---@param self KoiKoi.MCTS.State
---@param action KoiKoi.MCTS.Action
---@return KoiKoi.MCTS.State
function State.NextState(self, action)

    local p = table.deepcopy(self.params) ---@type KoiKoi.AI.Params
    local c = table.deepcopy(self.combinations) ---@type  { KoiKoi.Player : { [KoiKoi.CombinationType] : integer } }
    local calling = action.calling
    local player = action.player
    local pool = self.player == koi.player.you and p.pool or p.opponentPool

    local handleCard = function ()
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
        local drawn = p.drawnCard ~= nil
        if not drawn then
            local removed = table.removevalue(pool.hand, cardId)
        else
            assert(p.drawnCard == cardId)
            p.drawnCard = nil
        end

    end

    ---@type {[KoiKoi.MCTS.Phase] : fun(): KoiKoi.MCTS.Phase}
    local transit = {
        [phase.matchCard] = function()
            handleCard()
            -- auto draw
            assert(p.drawnCard == nil)
            p.drawnCard = card.DealCard(p.deck)

            return phase.matchDrawCard
        end,
        [phase.matchDrawCard] = function()
            handleCard()
            -- check combo
            local houseRule = p.houseRule
            local combo = combination.Calculate(pool, houseRule, self.logger)
            local diff = combination.Different(combo, c[player], self.logger)
            if diff then
                c[player] = combo
                return phase.calling
            elseif table.size(p.pool.hand) == 0 and table.size(p.opponentPool.hand) == 0 then
                return phase.tie -- or end?
            else
                -- swap player
                player = player == koi.player.you and koi.player.opponent or koi.player.you
                return phase.matchCard
            end
        end,
        [phase.calling] = function()
            assert(action.calling)
            if action.calling == koi.calling.shobu then
                if player == koi.player.you then
                    return phase.win -- or end?
                else
                    return phase.lose -- or end?
                end
            else
                -- swap player
                player = player == koi.player.you and koi.player.opponent or koi.player.you
                return phase.matchCard
            end
        end,
    }
    --self.logger:debug("phase " .. tostring(self.phase))
    local next = transit[self.phase]()

    return State.new(player, next, p, c, action, self.logger)
end

---@param self KoiKoi.MCTS.State
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
---@param self KoiKoi.MCTS.State
---@return integer
function State.CalculateReward(self)
    -- TODO Is [-1,1] or [-n,n] better for the range of reward?
    -- With [-n,n], I think the more attempts, the larger q/n will be and the more biased it will be...
    if self.phase == phase.win then
        local point, mult = self:CalculateScore(koi.player.you)
        return 1 * point * mult -- TODO its not best
    elseif self.phase == phase.lose then
        local point, mult = self:CalculateScore(koi.player.opponent)
        return -1 * point * mult -- TODO its not best
    end
    -- if self.player == koi.player.you and self.action == koi.calling.shobu then
    --     return 1 -- or score?
    -- elseif self.player == koi.player.you and self.action == koi.calling.shobu then
    --     return -1
    -- end
    return 0
end

---@class KoiKoi.MCTS.Node
---@field state KoiKoi.MCTS.State
---@field parent KoiKoi.MCTS.Node?
---@field children KoiKoi.MCTS.Node[]
---@field visited integer
---@field result number
---@field untriedActions KoiKoi.MCTS.Action[]?
---@field logger mwseLogger?
local Node = {}

---@param state KoiKoi.MCTS.State
---@param parent KoiKoi.MCTS.Node?
---@param logger mwseLogger?
---@return KoiKoi.MCTS.Node
function Node.new(state, parent, logger)
    ---@type KoiKoi.MCTS.Node
    local instance = {
        state = state,
        parent = parent,
        children = {},
        visited = 0,
        result = 0,
        untriedActions = nil,
        logger = logger,
    }
    setmetatable(instance, { __index = Node })
    return instance
end

---@param self KoiKoi.MCTS.Node
---@return boolean
function Node.IsTermianl(self)
    return self.state:IsTermianl()
end

---@param self KoiKoi.MCTS.Node
---@return boolean
function Node.IsFullyExpanded(self)
    return table.size(self:CollectUntriedActions()) == 0
end

--- total simulation reward
---@param self KoiKoi.MCTS.Node
---@return number
function Node.q(self)
    return self.result
end

--- total number of visits
---@param self KoiKoi.MCTS.Node
---@return number
function Node.n(self)
    return self.visited
end

---@param self KoiKoi.MCTS.Node
---@param cp number? hyperparameter of search
---@return number[]
function Node.UCB1(self, cp)
    cp = cp or 1
    local ln = 2 * math.log(self:n()) -- m log(n)/2nj m=4
    local ucb1 = table.new(table.size(self.children), 0) ---@type number[]
    for _, c in ipairs(self.children) do
        local v = c:q() / c:n() + cp * math.sqrt(ln / c:n())
        table.insert(ucb1, v)
    end
    return ucb1
end

---@param self KoiKoi.MCTS.Node
---@return KoiKoi.MCTS.Node?
---@return integer
---@return number
function Node.SelectBestChild(self)
    if table.size(self.children) == 0 then
        return nil, 0, 0
    end
    local ucb1 = self:UCB1() -- TODO cp
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

---@param self KoiKoi.MCTS.Node
---@return KoiKoi.MCTS.Action[]
function Node.CollectUntriedActions(self)
    if not self.untriedActions then
        self.untriedActions = self.state:CollectLegalActions()
    end
    -- self.logger:debug("untriedActions %d", table.size(self.untriedActions))
    return self.untriedActions
end


---@param self KoiKoi.MCTS.Node
---@return KoiKoi.MCTS.Node
function Node.Expand(self)
    local actions = self:CollectUntriedActions()
    assert(actions)
    assert(table.size(actions) > 0)
    local action = table.remove(actions, 1)
    local state = self.state:NextState(action)
    local child = Node.new(state, self, self.logger)
    table.insert(self.children, child)
    return child
end

---@param actions KoiKoi.MCTS.Action[]
---@return KoiKoi.MCTS.Action
local function RolloutPolicy(actions)
    local action = table.choice(actions)
    return action
end

---@param self KoiKoi.MCTS.Node
---@return integer
function Node.Rollout(self)
    local state = self.state
    while not state:IsTermianl() do
        local actions = state:CollectLegalActions()
        --self.logger:debug("Rollout actions %d", table.size(actions))
        local action = RolloutPolicy(actions)
        state = state:NextState(action)
    end
    return state:CalculateReward()
end

---comments
---@param self KoiKoi.MCTS.Node
---@param result integer
function Node.Backpropagate(self, result)
    self.visited = self.visited + 1
    self.result = self.result + result
    -- self.results[result] = table.get(self.results, result, 0) + 1
    if self.parent then
        self.parent:Backpropagate(result)
    end
end

---comments
---@param root KoiKoi.MCTS.Node
---@return KoiKoi.MCTS.Node?
local function InsertNodeWithTreePolicy(root)
    local node = root ---@type KoiKoi.MCTS.Node?
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
---@param root KoiKoi.MCTS.Node
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


-- cheating reference
---@class KoiKoi.MCTSBrain : KoiKoi.IBrain
---@field node KoiKoi.MCTS.Node?
---@field iteration integer
---@field timer number
---@field wait number?
local this = {}
local brain = require("Hanafuda.KoiKoi.brain.brain")
setmetatable(this, {__index = brain})

---@param params KoiKoi.IBrain.Params?
---@return KoiKoi.MCTSBrain
function this.new(params)
    local instance = brain.new(params)
    ---@cast instance KoiKoi.MCTSBrain
    instance.node = nil
    instance.iteration = 0
    setmetatable(instance, { __index = this })
    return instance
end

---@param params KoiKoi.IBrain.GenericParams
---@return KoiKoi.MCTSBrain
function this.generate(params)
    return this.new({logger = params.logger})
end

---@param self KoiKoi.MCTSBrain
function this.Reset(self)
    self.timer = 0
    self.wait = nil
    self.node = nil
    self.iteration = 0
end

---@param self KoiKoi.MCTSBrain
---@param root KoiKoi.MCTS.Node
---@return KoiKoi.MCTS.Node?
function this.Dispatch(self, root)
    assert(root)
    -- TODO How many attempts is appropriate?
    local maxIteration = 10000
    local iteration = maxIteration - self.iteration
    local duration = 0.002 -- seconds
    assert(iteration ~= nil or duration ~= nil)
    local it = 0
    local beginTime = os.clock() -- too low acculacy?
    --self.logger:debug(beginTime)
    while (iteration == nil or it < iteration) and (duration == nil or (os.clock() - beginTime) < duration) do
        it = it + 1
        if not Dispatch(root) then
            break
        end
    end
    --self.logger:debug(os.clock() - beginTime)
    --self.logger:debug("iteration %d", it)

    -- break and continue
    if iteration then
        self.iteration = self.iteration + it
        --self.logger:debug("total iteration %d", self.iteration )
        if self.iteration < maxIteration then
            return nil
        end
    end

    local best, index, max = root:SelectBestChild()
    self.logger:debug("best %d (%f)", index, max)

    local ucb1 = root:UCB1() -- TODO cp
    for i, child in ipairs(root.children) do
        self.logger:debug("%d: %d/%d (%f)", i, child:q(), child:n(), ucb1[i] )
    end
    -- if best then
    --     self.logger:assert(ucb1[index] == max, "mismatch max UCB1!" )
    -- end

    self.logger:assert(best ~= nil, "It's impossible not to have a best action.")

    return best
end

---@param self KoiKoi.MCTSBrain
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
        local state = State.new(koi.player.you, p.drawnCard and phase.matchDrawCard or phase.matchCard, table.deepcopy(p), combos, nil, self.logger)
        self.node = Node.new(state, nil, self.logger)
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

--and current yaku
---@param self KoiKoi.MCTSBrain
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
        local state = State.new(koi.player.you, phase.calling, table.deepcopy(p), combos, nil, self.logger)
        self.node = Node.new(state, nil, self.logger)
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