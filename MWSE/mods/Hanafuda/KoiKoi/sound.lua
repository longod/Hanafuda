

local logger = require("Hanafuda.logger")
local config = require("Hanafuda.config")

---@class Sound
local this = {}

local soundData = require("Hanafuda.KoiKoi.soundData")

this.se = soundData.se
this.voice = soundData.voice
this.music = soundData.music

-- todo need driver menu for testing audio

---@param t table
---@param excluding integer?
---@return integer?
local function GetRandomIndex(t, excluding)
    if t then
        local size = table.size(t)
        if size > 1 then
            -- If excluding is specified, the excluding index is considered the last index. So the total number is one less.
            local newsize = size
            if excluding ~= nil then
                newsize = newsize - 1
            end
            local index = math.random(newsize)
            if index == excluding then
                index = size
            end
            return index
        elseif size == 1 then
            return 1
        end
    end
    return nil
end

---@param id SoundEffectId
function this.Play(id)
    local data = soundData.soundData[id]
    -- todo mixchannel fader
    -- todo reference if 3D
    if data then
        -- tes3.playSound performs 3D audio with references, so it crashes when used in the main menu because of no references exist.
        -- but play using soundPath is only tes3.playSound, tes3sound only data loaded by esm, esp.
        if data.soundPath and not tes3.onMainMenu() then
            tes3.playSound({ soundPath = data.soundPath, mixChannel = tes3.soundMix.master, volume = data.volume or 1 })
        elseif data.sound then
            -- todo tes3.playSound version when 3D
            local se = tes3.getSound(data.sound) -- todo cache?
            if se then
                se:play(nil, data.volume or 1)
            else
                logger:debug("wrong sound id: ".. tostring(data.sound))
            end
        else
            logger:debug("invalid sound data: ".. tostring(id))
        end
    else
        logger:debug("invalid sound ID: ".. tostring(id))
    end
end

-- The dialogue corresponding to the opponent's race is not taken into account.
---@param id VoiceId
---@param race string
---@param female boolean
---@param disposition number? Mutual disposition
---@param excluding integer?
---@return integer?
local function PlayVoice(id, race, female, disposition, excluding)
    if not tes3.onMainMenu() then
        local r = soundData.voiceData[string.lower(race)]
        if not r then
            return nil
        end
        local s = r[female and "f" or "m"]
        if not s then
            return nil
        end
        local voice = s[id]
        local index = GetRandomIndex(voice, excluding)
        if index ~= nil then
            local path = voice[index]
            logger:trace("Voice %d : %d %s", id, index, path)
            tes3.playSound({ soundPath = path, mixChannel = tes3.soundMix.voice })
            return index
        end
    end
    return nil
end

---@param id VoiceId
---@param objectId string
---@param special {[string] : {[VoiceId] : string[]}} id, VoiceId, file excluding directory
---@param disposition number? Mutual disposition
---@param excluding integer?
---@return integer?
local function PlaySpecialVoice(id, objectId, special, disposition, excluding)
    if special then
        local sp = special[objectId]
        if sp then
            local voice = sp[id]
            local index = GetRandomIndex(voice, excluding)
            if index ~= nil then
                local path = voice[index]
                logger:trace("Special Voice %d %s : %d %s", id, objectId, index, path)
                tes3.playSound({ soundPath = path, mixChannel = tes3.soundMix.voice })
                return index
            end
        end
    end
    return nil
end

---comments
---@param id VoiceId
---@param creatureId string?
---@return nil
local function PlaySoundGenerator(id, creatureId)
    local data = soundData.soundGenData[id]
    if creatureId and data then
        local gen = tes3.getSoundGenerator(creatureId, data.gen)
        if gen and gen.sound then
            gen.sound:play()
            return nil -- There is only one voice assigned.
        end
    end
    return nil
end

---@param id VoiceId
---@param mobile tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer? -- todo use weak tes3reference
---@param disposition number? Mutual disposition
---@param excluding integer?
---@return integer? -- random choice index
---@return boolean? -- special
function this.PlayVoice(id, mobile, disposition, excluding)
    if not tes3.onMainMenu() and mobile then
        logger:trace("PlayVoice %d %s", id, mobile.object.baseObject.id)

        local types = {
            [tes3.actorType.creature] =
            ---@param m tes3mobileCreature
            ---@return integer? -- random choice index
            ---@return boolean? -- special
            function(m)
                if not config.audio.npcVoice then
                    return nil, nil
                end
                local sp = PlaySpecialVoice(id, m.object.baseObject.id, soundData.creatures, disposition, excluding)
                if sp ~= nil then
                    return sp, true
                end
                -- nil
                return PlaySoundGenerator(id, m.object.baseObject.id), false
            end,
            [tes3.actorType.npc] =
            ---@param m tes3mobileNPC
            ---@return integer? -- random choice index
            ---@return boolean? -- special
            function(m)
                if not config.audio.npcVoice then
                    return nil, nil
                end
                local sp = PlaySpecialVoice(id, m.object.baseObject.id, soundData.npcs, disposition, excluding)
                if sp ~= nil then
                    return sp, true
                end
                return PlayVoice(id, m.object.race.id, m.object.female, disposition, excluding), false
            end,
            [tes3.actorType.player] =
            ---@param m tes3mobilePlayer
            ---@return integer? -- random choice index
            ---@return boolean? -- special
            function(m)
                if not config.audio.playerVoice then
                    return nil, nil
                end
                return PlayVoice(id, m.object.race.id, m.object.female, disposition, excluding), false
            end,
        }
        if types[mobile.actorType] then
            return types[mobile.actorType](mobile)
        end
    end
    return nil, nil
end

---@param id MusicId
function this.PlayMusic(id)
    local data = soundData.musicData[id]
    if data and data.path then
        tes3.streamMusic({ path = soundData.musicData[id].path })
    end
end




--- debugging
function this.CreateSoundPlayer()
    local menuid = "Hanafuda.SoundPlayer"
    local menu = tes3ui.findMenu(menuid)
    if menu then
        menu:destroy()
    end
    menu = tes3ui.createMenu({ id = menuid, fixedFrame = true })

    menu:updateLayout()
end


return this
