---@class Gamble.Actor
local this = {}
local logger = require("Hanafuda.logger")
local special = require("Hanafuda.Gamble.special")
local i18n = mwse.loadTranslations("Hanafuda")

---@param mobile tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@return boolean
function this.CanBarter(mobile)
    local ai = mobile.object.aiConfig
    local barters = {
        "bartersAlchemy",
        "bartersApparatus",
        "bartersArmor",
        "bartersBooks",
        "bartersClothing",
        "bartersEnchantedItems",
        "bartersIngredients",
        "bartersLights",
        "bartersLockpicks",
        "bartersMiscItems",
        "bartersProbes",
        "bartersRepairTools",
        "bartersWeapons",
    }
    for _, value in ipairs(barters) do
        if ai[value] == true then
            return true
        end
    end
    return false
end

---@param mobile tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@return integer
function this.GetActorGold(mobile)
    local gold = mobile.barterGold

    local goldId = {
        ["Gold_001"] = true,
        ["Gold_005"] = true,
        ["Gold_010"] = true,
        ["Gold_025"] = true,
        ["Gold_100"] = true,
    }

    local items = mobile.inventory
    for _, item in ipairs(items) do
        if goldId[item.object.id] then
            gold = gold + item.object.value * item.count
        end
    end
    return gold
end

---@param mobile tes3mobileActor
---@return boolean
local function ActorHasServiceMenu(mobile)
    if mobile.isDead then
        return false
    end
    return true
end

---@param mobile tes3mobileNPC
local function HasServiceMenuByClass(mobile)
    local classes = {
        -- pc and npc classes
        ["acrobat"] = false,
        ["agent"] = true,
        ["archer"] = false,
        ["assassin"] = false,
        ["barbarian"] = false,
        ["bard"] = false,
        ["battlemage"] = false,
        ["crusader"] = false,
        ["healer"] = false,
        ["knight"] = false,
        ["mage"] = false,
        ["monk"] = false,
        ["nightblade"] = false,
        ["pilgrim"] = false,
        ["rogue"] = true,
        ["scout"] = false,
        ["sorcerer"] = false,
        ["spellsword"] = false,
        ["thief"] = true,
        ["warrior"] = false,
        ["witchhunter"] = false,
        -- npc only classes
        ["alchemist"] = false,
        ["apothecary"] = false,
        ["bookseller"] = true,
        ["buoyant armiger"] = false,
        ["caravaner"] = false,
        ["champion"] = false,
        ["clothier"] = false,
        ["commoner"] = false,
        ["dreamer"] = false,
        ["drillmaster"] = false,
        ["enchanter"] = false,
        ["enforcer"] = false,
        ["farmer"] = false,
        ["gondolier"] = false,
        ["guard"] = false,
        ["guild guide"] = false,
        ["herder"] = false,
        ["hunter"] = false,
        ["mabrigash"] = false,
        ["master-at-arms"] = false,
        ["merchant"] = true,
        ["miner"] = false,
        ["necromancer"] = false,
        ["noble"] = false,
        ["ordinator"] = false,
        ["ordinator guard"] = false,
        ["pauper"] = false,
        ["pawnbroker"] = true,
        ["priest"] = false,
        ["publican"] = true,
        ["savant"] = false,
        ["sharpshooter"] = false,
        ["shipmaster"] = false,
        ["slave"] = false,
        ["smith"] = false,
        ["smuggler"] = true,
        ["trader"] = true,
        ["warlock"] = false,
        ["wise woman"] = false,
        ["witch"] = false,
        -- tribunals
        ["caretaker"] = false,
        ["gardener"] = false,
        ["journalist"] = false,
        ["king"] = false,
        ["queen mother"] = false,
        -- bloodmoon
        ["shaman"] = false,
        -- mod
        ["gambler"] = true,
    }
    -- modded class?
    local class = mobile.object.class.id:lower()
    logger:trace(class)
    local v = classes[class]
    if v == nil then
        -- Some classes have service as a suffix, so look for it by forward matching.
        -- It may be easier to support mods than to cover them all in a table.
        for key, value in pairs(classes) do
            if class:startswith(key) then
                v = value
                break
            end
        end
    end
    -- logger:trace(v)
    return (v == nil) or (v == true) -- ignored only false
end

---@param player tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param opponent tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@return boolean
function this.HasServiceMenu(player, opponent)
    if not ActorHasServiceMenu(opponent) then
        logger:trace("service is not allowed opponent condition")
        return false
    end

    local types = {
        [tes3.actorType.creature] =
        ---@param a tes3mobileCreature
        ---@return boolean
            function(a)
                if not special.IsAllowdCreature(a) then
                    logger:trace("service is not allowed creature")
                    return false
                end
                return true
            end,
        [tes3.actorType.npc] =
        ---@param a tes3mobileNPC
        ---@return boolean
            function(a)
                if special.IsAllowdNPC(a) then
                    logger:trace("service allowd by special npc")
                    return true
                end
                if not HasServiceMenuByClass(a) then
                    logger:trace("service is not allowd by class")
                    return false
                end
                return true
            end,
        [tes3.actorType.player] =
        ---@param a tes3mobilePlayer
        ---@return boolean
            function(a)
                -- possible?
                return false
            end,
    }
    if types[opponent.actorType] then
        return types[opponent.actorType](opponent)
    end
    return false
end

---@param mobile tes3mobileActor
---@return boolean
---@return string? -- reason
local function ActorCanPerformService(mobile)
    local condition = {
        "attacked",
        "inCombat",
        "isAttackingOrCasting",
        "isDead",
        "isDiseased",
        "isFlying",
        "isJumping",
        "isKnockedDown",
        "isKnockedOut",
        "isParalyzed",
        "isPlayerHidden",
        "isReadyingWeapon",
        "isSneaking",
        "isSwimming",
        "weaponDrawn", -- weaponReady, castReady?
    }
    for _, value in ipairs(condition) do
        if mobile[value] then
            logger:trace(value)
            return false, value
        end
    end
    return true
end

---@param player tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param opponent tes3mobileCreature|tes3mobileNPC
---@return boolean
local function CanPerformServiceByFight(player, opponent)
    local baseFight = 70
    local threshold = baseFight
    -- todo Varying thresholds based on faction and other affinities with the player.
    return opponent.fight <= threshold
end

---@param player tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param opponent tes3mobileNPC
---@return boolean
local function CanPerformServiceByDisposition(player, opponent)
    local baseDisposition = 30
    local threshold = baseDisposition
    -- todo Varying thresholds based on faction and other affinities with the player.
    return opponent.object.disposition >= threshold
end

---@param player tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@param opponent tes3mobileNPC
---@return boolean
local function CanPerformServiceByFaction(player, opponent)
    local faction = opponent.object.faction
    if faction then

        local factions = {
            ["ashlanders"] =
            ---@return boolean
                function()
                    return faction.playerJoined
                end,
            ["blades"] =
            ---@return boolean
                function()
                    return faction.playerJoined
                end,
            ["clan aundae"] =
            ---@return boolean
                function()
                    return player.hasVampirism
                end,
            ["clan berne"] =
            ---@return boolean
                function()
                    return player.hasVampirism
                end,
            ["clan quarra"] =
            ---@return boolean
                function()
                    return player.hasVampirism
                end,
            ["hlaalu"] =
            ---@return boolean
                function()
                    if faction.playerJoined and not faction.playerExpelled then
                        return faction.playerRank >= opponent.object.baseObject.factionRank
                    end
                    return false
                end,
            ["morag tong"] =
            ---@return boolean
                function()
                    return faction.playerJoined and not faction.playerExpelled
                end,
            ["redoran"] =
            ---@return boolean
                function()
                    if faction.playerJoined and not faction.playerExpelled then
                        return faction.playerRank >= opponent.object.baseObject.factionRank
                    end
                    return false
                end,
            ["telvanni"] =
            ---@return boolean
                function()
                    if faction.playerJoined and not faction.playerExpelled then
                        return faction.playerRank >= opponent.object.baseObject.factionRank
                    end
                    return false
                end,
        }
        local id = faction.id:lower()
        if factions[id] then
            return factions[id]()
        end
    end
    return true
end

---@param player tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer?
---@param opponent tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer?
---@return boolean -- can perform
---@return string? -- reason
---@return boolean? -- byOpponent
function this.CanPerformService(player, opponent)
    if player == nil or opponent == nil then
        return false, nil, nil
    end

    local condition, reason = ActorCanPerformService(player)
    if not condition then
        logger:trace("not perform by player condition")
        return condition, reason, false
    end
    condition, reason = ActorCanPerformService(opponent)
    if not condition then
        logger:trace("not perform by opponent condition")
        return condition, reason, true
    end
    if not CanPerformServiceByFight(player, opponent) then
        logger:trace("not perform by fight")
        return false, "fight", true
    end

    local types = {
        [tes3.actorType.creature] =
        ---@param a tes3mobileCreature
        ---@return boolean
        ---@return string?
        ---@return boolean?
            function(a)
                -- no disposition
                return true
            end,
        [tes3.actorType.npc] =
        ---@param a tes3mobileNPC
        ---@return boolean
        ---@return string?
        ---@return boolean?
            function(a)
                if not CanPerformServiceByFaction(player, a) then
                    logger:trace("not perform by faction")
                    return false, "faction", true
                end
                if not CanPerformServiceByDisposition(player, a) then
                    logger:trace("not perform by disposition")
                    return false, "disposition", true
                end
                return true
            end,
        [tes3.actorType.player] =
        ---@param a tes3mobilePlayer
        ---@return boolean
        ---@return string?
        ---@return boolean
            function(a)
                -- possible?
                return false, nil, false
            end,
    }
    if types[opponent.actorType] then
        return types[opponent.actorType](opponent)
    end
    return false, nil, nil
end

---@param reason string
---@param name string
---@return string?
function this.GetRefusedReasonText(reason, name)
    local condition = {
        ["attacked"] = "gamble.refusedReason.combat",
        ["inCombat"] = "gamble.refusedReason.combat",
        ["isAttackingOrCasting"] = "gamble.refusedReason.combat",
        ["isDead"] = "gamble.refusedReason.dead",
        ["isDiseased"] = "gamble.refusedReason.diseased",
        ["isFlying"] = "gamble.refusedReason.floating",
        ["isJumping"] = "gamble.refusedReason.floating",
        ["isKnockedDown"] = "gamble.refusedReason.knocked",
        ["isKnockedOut"] = "gamble.refusedReason.knocked",
        ["isParalyzed"] = "gamble.refusedReason.paralyzed",
        ["isPlayerHidden"] = "gamble.refusedReason.hidden",
        ["isReadyingWeapon"] = "gamble.refusedReason.combat",
        ["isSneaking"] = "gamble.refusedReason.sneaking",
        ["isSwimming"] = "gamble.refusedReason.swimming",
        ["weaponDrawn"] = "gamble.refusedReason.combat",
        ["fight"] = "gamble.refusedReason.fight",
        ["faction"] = "gamble.refusedReason.faction",
        ["disposition"] = "gamble.refusedReason.disposition",
    }
    local key = condition[reason]
    if key then
        return i18n(key, {name = name})
    end
    return nil -- or fallback text
end


-- fate
---@param mobile tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@return number
function this.CalculateLucky(mobile)
    local value = 0
    local total = 0
    do
        local weight = 1.0
        value = value + math.remap(mobile.luck.current, 0, 100, 0, 1) * weight
        total = total + weight
    end
    value = value / total -- normalize
    return value
end

---@param mobile tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@return number
function this.CalculateCheatAbility(mobile)
    local value = 0
    local total = 0
    do
        local weight = 0.5
        value = value + math.remap(mobile.willpower.current, 0, 150, 0, 1) * weight
        total = total + weight
    end
    do
        local weight = 1
        value = value + math.remap(mobile.agility.current, 0, 150, 0, 1) * weight
        total = total + weight
    end
    do
        local weight = 0.25
        value = value + math.remap(mobile.luck.current, 0, 100, 0, 1) * weight
        total = total + weight
    end
    if mobile.actorType == tes3.actorType.creature then
        ---@cast mobile tes3mobileCreature
    else
        ---@cast mobile tes3mobileNPC|tes3mobilePlayer
        do
            local weight = 1
            value = value + math.remap(mobile.sneak.current, 0, 100, 0, 1) * weight
            total = total + weight
        end
        do
            local weight = 1
            value = value + math.remap(mobile.speechcraft.current, 0, 100, 0, 1) * weight
            total = total + weight
        end
    end
    value = value / total -- normalize
    return value
end

---@param mobile tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@return number
function this.CalculateSpotAbility(mobile)
    local value = 0
    local total = 0
    do
        local weight = 1
        value = value + math.remap(mobile.willpower.current, 0, 150, 0, 1) * weight
        total = total + weight
    end
    do
        local weight = 0.5
        value = value + math.remap(mobile.intelligence.current, 0, 150, 0, 1) * weight
        total = total + weight
    end
    do
        local weight = 0.25
        value = value + math.remap(mobile.luck.current, 0, 100, 0, 1) * weight
        total = total + weight
    end
    if mobile.actorType == tes3.actorType.creature then
        ---@cast mobile tes3mobileCreature
    else
        ---@cast mobile tes3mobileNPC|tes3mobilePlayer
        local weight = 1
        value = value + math.remap(mobile.security.current, 0, 100, 0, 1) * weight
        total = total + weight
    end
    value = value / total -- normalize
    return value
end

---@param mobile tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@return number
function this.CalculateGreedy(mobile)
    local value = 0
    local total = 0
    do
        local weight = 1
        value = value + math.remap(mobile.willpower.current, 0, 100, 1, 0.1) * weight
        total = total + weight
    end
    if mobile.actorType == tes3.actorType.creature then
        -- no skill
    else
        ---@cast mobile tes3mobileNPC|tes3mobilePlayer
        local weight = 1
        value = value + math.remap(mobile.mercantile.current, 0, 100, 0.1, 1) * weight
        total = total + weight
    end
    value = value / total -- normalize
    return value
end

---@param mobile tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
---@return number
function this.CalculateGambleAbility(mobile)
    local value = 0
    local total = 0
    do
        local weight = 1
        local v = math.remap(mobile.willpower.current, 30, 150, 0, 1)
        value = value + v * weight
        total = total + weight
    end
    do
        local weight = 1
        local v = math.remap(mobile.intelligence.current, 30, 150, 0, 1)
        value = value + v * weight
        total = total + weight
    end
    do
        local weight = 0.5
        local v = math.remap(mobile.luck.current, 0, 100, 0, 1)
        value = value + v * weight
        total = total + weight
    end
    if mobile.actorType == tes3.actorType.creature then
        -- no skill
    else
        ---@cast mobile tes3mobileNPC|tes3mobilePlayer
        local weight = 1
        local v = math.remap(mobile.mercantile.current, 0, 100, 0, 1)
        value = value + v * weight
        total = total + weight
    end
    value = value / total -- normalize
    return value
end

return this
