

local logger = require("Hanafuda.logger")

---@class Sound
local this = {}

---@enum SoundEffectId
this.se = {
    dealCard = 1,
    putDeck = 2,
    pickCard = 3,
    putCard = 4,
}
---@enum VoiceId
this.voice = {
    continue = 1,
    finish = 2,
}

---@enum MusicId
this.music = {
    win = 1,
    lose = 2,
}

--randomness array? {}

---@class SoundData
---@field soundPath string?
---@field sound string? fallback
---@field volume number? normalzied value

---@type {[SoundEffectId] : SoundData}
local soundData = {
    -- ["koikoi.continue"] = { soundPath = "", volume = 1 },
    -- ["koikoi.end"] = { soundPath = "", volume = 1 },
    -- ["1"] = { sound ="",soundPath = "Fx/inter/menu1.wav" },
    -- ["2"] = { sound ="",soundPath = "Fx/inter/menu2.wav" },
    -- ["3"] = { sound ="",soundPath = "Fx/inter/menuNEWxbx.wav" },
    -- ["4"] = { sound ="book close",soundPath = "Fx/item/bookclose.wav" },
    -- ["5"] = { sound ="book open",soundPath = "Fx/item/bookopen.wav" },
    -- ["6"] = { sound ="book page",soundPath = "Fx/item/bookpag1.wav" },
    -- ["7"] = { sound ="book page2",soundPath = "Fx/item/bookpag2.wav" },
    -- ["8"] = { sound ="Item Clothes Up",soundPath = "Fx/item/cloth.wav" },
    -- ["9"] = { sound ="Item Misc Up",soundPath = "Fx/item/item.wav" },
    -- ["10"] = { sound ="Item Gold Up",soundPath = "Fx/item/money.wav" },
    -- Menu Size
    [this.se.dealCard] = { sound = "book page2" },
    [this.se.putDeck] = { sound = "book close" },
    [this.se.pickCard] = { sound = "book page" },
    [this.se.putCard] = { sound = "book page2" },
}
local voiceData = {
    [this.voice.continue] = { soundPath = "vo\\d\\m\\Hlo_DM035.mp3" }, -- Keep moving, scum.
    [this.voice.finish] = { soundPath = "vo\\d\\m\\Atk_DM013.mp3" }, -- You're beaten.
}

-- I'd like to treat it as an SE, but so far I can't.
local musicData = {
    [this.music.win] = { path = "Special/MW_Triumph.mp3" },
    [this.music.lose] = { path = "Special/MW_Death.mp3" },
}

---@param id SoundEffectId
function this.Play(id)
    local data = soundData[id]
            -- todo mixxhannel feder
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

---@param id VoiceId
---@param race string -- todo
---@param female boolean -- todo
function this.PlayVoice(id, race, female)
    if not tes3.onMainMenu() then
        local data = voiceData[id]
        if data and data.soundPath then
            tes3.playSound({ soundPath = data.soundPath, mixChannel = tes3.soundMix.voice, volume = data.volume or 1 })
        else
            logger:debug("invalid voice ID: ".. tostring(id))
        end
    end
end

---@param id MusicId
function this.PlayMusic(id)
    local data = musicData[id]
    if data and data.path then
        tes3.streamMusic({ path = musicData[id].path })
    end
end

return this
