

local logger = require("Hanafuda.logger")
local config = require("Hanafuda.config")

---@class Sound
local this = {}

local soundData = require("Hanafuda.soundData")

this.se = soundData.se
this.voice = soundData.voice
this.music = soundData.music

-- todo need driver menu for testing audio

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
local function PlayVoice(id, race, female)
    if not tes3.onMainMenu() then
        local r = soundData.voiceData[string.lower(race)]
        if not r then
            return
        end
        local s = r[female and "f" or "m"]
        if not s then
            return
        end
        local voice = s[id]
        if voice and table.size(voice) > 0 then
            local path = table.choice(voice) ---@type string
            --path = path:gsub("/", "\\")
            logger:trace("Voice %d %s", id, path)
            -- local path = GenerateVoicePath(race, female) .. file
            tes3.playSound({ soundPath = path, mixChannel = tes3.soundMix.voice })
        end
    end
end

---@param id VoiceId
---@param objectId string
---@param special {[string] : {[VoiceId] : string[]}} id, VoiceId, file excluding directory
---@return integer?
local function PlaySpecialVoice(id, objectId, special)
    if special then
        local sp = special[objectId]
        if sp then
            local voice = sp[id]
            if voice and table.size(voice) > 0 then
                local path, k = table.choice(voice)
                logger:trace("Special Voice %d %s : %d %s", id, objectId, k, path)
                tes3.playSound({ soundPath = path, mixChannel = tes3.soundMix.voice })
                return k
            end
        end
    end
    return nil
end

---@param id VoiceId
---@param mobile tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer? -- todo use weak tes3reference
---@return integer? -- random choice index
function this.PlayVoice(id, mobile)
    if not tes3.onMainMenu() and mobile then
        logger:trace("PlayVoice %d %s", id, mobile.object.baseObject.id)

        local types = {
            [tes3.actorType.creature] =
            ---@param m tes3mobileCreature
            function(m)
                if not config.audio.npcVoice then
                    return
                end
                local sp = PlaySpecialVoice(id, m.object.baseObject.id, soundData.creatures)
                if sp ~= nil then
                    return sp
                end

                local soundCreature = m.object.baseObject
                local data = soundData.soundGenData[id]
                if soundCreature and data then
                    local gen = tes3.getSoundGenerator(soundCreature.id, data.gen)
                    if gen and gen.sound then
                        gen.sound:play(nil, 1)
                        return nil -- There is only one voice assigned.
                    end
                end
                return nil
            end,
            [tes3.actorType.npc] =
            ---@param m tes3mobileNPC
            function(m)
                if not config.audio.npcVoice then
                    return nil
                end
                local sp = PlaySpecialVoice(id, m.object.baseObject.id, soundData.npcs)
                if sp ~= nil then
                    return sp
                end
                return PlayVoice(id, m.object.race.id, m.object.female)
            end,
            [tes3.actorType.player] =
            ---@param m tes3mobilePlayer
            function(m)
                if not config.audio.playerVoice then
                    return nil
                end
                return PlayVoice(id, m.object.race.id, m.object.female)
            end,
        }
        if types[mobile.actorType] then
            return types[mobile.actorType](mobile)
        end
    end
    return nil
end

---@param id MusicId
function this.PlayMusic(id)
    local data = soundData.musicData[id]
    if data and data.path then
        tes3.streamMusic({ path = soundData.musicData[id].path })
    end
end

return this
