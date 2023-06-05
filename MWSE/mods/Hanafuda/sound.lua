

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
    continue = 1, -- koi-koi
    finish = 2, -- shobu
    -- lose responce
    -- thinking etc
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

-- todo there are placeholder
---@type {[string] : {[string]: {[VoiceId] : string[] } } } race, sex, VoiceId, file excluding directory
local voiceData = {
    ["argonian"] = {
        ["f"] = {
            [this.voice.continue] = {
                "Atk_AF001.mp3",
                "Atk_AF002.mp3",
            },
            [this.voice.finish] = {
                "Atk_AF003.mp3",
                "Atk_AF004.mp3",
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "Atk_AM001.mp3",
                "Atk_AM002.mp3",
            },
            [this.voice.finish] = {
                "Atk_AM003.mp3",
                "Atk_AM004.mp3",
            },
        },
    },
    ["breton"] = {
        ["f"] = {
            [this.voice.continue] = {
                "Atk_BF001.mp3",
                "Atk_BF002.mp3",
            },
            [this.voice.finish] = {
                "Atk_BF003.mp3",
                "Atk_BF004.mp3",
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "Atk_BM001.mp3",
                "Atk_BM002.mp3",
            },
            [this.voice.finish] = {
                "Atk_BM003.mp3",
                "Atk_BM004.mp3",
            },
        },
    },
    ["dark elf"] = {
        ["f"] = {
            [this.voice.continue] = {
                "Atk_DF001.mp3",
                "Atk_DF002.mp3",
            },
            [this.voice.finish] = {
                "Atk_DF003.mp3",
                "Atk_DF004.mp3",
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "Atk_DM001.mp3",
                "Atk_DM002.mp3",
            },
            [this.voice.finish] = {
                "Atk_DM003.mp3",
                "Atk_DM004.mp3",
            },
        },
    },
    ["high elf"] = {
        ["f"] = {
            [this.voice.continue] = {
                "Atk_HF001.mp3",
                "Atk_HF002.mp3",
            },
            [this.voice.finish] = {
                "Atk_HF003.mp3",
                "Atk_HF004.mp3",
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "Atk_HM001.mp3",
                "Atk_HM002.mp3",
            },
            [this.voice.finish] = {
                "Atk_HM003.mp3",
                "Atk_HM004.mp3",
            },
        },
    },
    ["imperial"] = {
        ["f"] = {
            [this.voice.continue] = {
                "Atk_IF001.mp3",
                "Atk_IF002.mp3",
            },
            [this.voice.finish] = {
                "Atk_IF003.mp3",
                "Atk_IF004.mp3",
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "Atk_IM001.mp3",
                "Atk_IM002.mp3",
            },
            [this.voice.finish] = {
                "Atk_IM003.mp3",
                "Atk_IM004.mp3",
            },
        },
    },
    ["khajiit"] = {
        ["f"] = {
            [this.voice.continue] = {
                "Atk_KF001.mp3",
                "Atk_KF002.mp3",
            },
            [this.voice.finish] = {
                "Atk_KF003.mp3",
                "Atk_KF004.mp3",
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "Atk_KM001.mp3",
                "Atk_KM002.mp3",
            },
            [this.voice.finish] = {
                "Atk_KM003.mp3",
                "Atk_KM004.mp3",
            },
        },
    },
    ["nord"] = {
        ["f"] = {
            [this.voice.continue] = {
                "Atk_NF001.mp3",
                "Atk_NF002.mp3",
            },
            [this.voice.finish] = {
                "Atk_NF003.mp3",
                "Atk_NF004.mp3",
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "Atk_NM001.mp3",
                "Atk_NM002.mp3",
            },
            [this.voice.finish] = {
                "Atk_NM003.mp3",
                "Atk_NM004.mp3",
            },
        },
    },
    ["orc"] = {
        ["f"] = {
            [this.voice.continue] = {
                "Atk_OF001.mp3",
                "Atk_OF002.mp3",
            },
            [this.voice.finish] = {
                "Atk_OF003.mp3",
                "Atk_OF004.mp3",
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "Atk_OM001.mp3",
                "Atk_OM002.mp3",
            },
            [this.voice.finish] = {
                "Atk_OM003.mp3",
                "Atk_OM004.mp3",
            },
        },
    },
    ["redguard"] = {
        ["f"] = {
            [this.voice.continue] = {
                "Atk_RF001.mp3",
                "Atk_RF002.mp3",
            },
            [this.voice.finish] = {
                "Atk_RF003.mp3",
                "Atk_RF004.mp3",
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "Atk_RM001.mp3",
                "Atk_RM002.mp3",
            },
            [this.voice.finish] = {
                "Atk_RM003.mp3",
                "Atk_RM004.mp3",
            },
        },
    },
    ["wood elf"] = {
        ["f"] = {
            [this.voice.continue] = {
                "Atk_WF001.mp3",
                "Atk_WF002.mp3",
            },
            [this.voice.finish] = {
                "Atk_WF003.mp3",
                "Atk_WF004.mp3",
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "Atk_WM001.mp3",
                "Atk_WM002.mp3",
            },
            [this.voice.finish] = {
                "Atk_WM003.mp3",
                "Atk_WM004.mp3",
            },
        },
    },
}

local soundGenData = {
    [this.voice.continue] = { gen = tes3.soundGenType.moan },
    [this.voice.finish] = { gen = tes3.soundGenType.roar },
}

-- I'd like to treat it as an SE, but so far I can't.
local musicData = {
    [this.music.win] = { path = "Special/MW_Triumph.mp3" },
    [this.music.lose] = { path = "Special/MW_Death.mp3" },
}

---@param race string
---@param female boolean
local function GenerateVoicePath(race, female)
    local r = string.lower(string.sub(race, 1, 1))
    local s = female and "f" or "m"
    local path = string.format( "vo\\%s\\%s\\", r, s )
    return path
end

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
local function PlayVoice(id, race, female)
    if not tes3.onMainMenu() then
        local r = voiceData[string.lower(race)]
        if not r then
            return
        end
        local s = r[female and "f" or "m"]
        if not s then
            return
        end
        local data = s[id]
        if data then
            local file = table.choice(data)
            local path = GenerateVoicePath(race, female) .. file
            tes3.playSound({ soundPath = path, mixChannel = tes3.soundMix.voice })
        end
    end
end

---comment
---@param id VoiceId
---@param mobile tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer?
function this.PlayVoice(id, mobile)
    if not tes3.onMainMenu() and mobile then
        -- TODO unique character/creature
        -- https://en.uesp.net/wiki/Morrowind:Special_Creatures
        -- https://en.uesp.net/wiki/Tribunal:Special_Creatures
        -- https://en.uesp.net/wiki/Bloodmoon:Creatures

        local types = {
            [tes3.actorType.creature] =
            ---@param m tes3mobileCreature
            function(m)
                local soundCreature = m.object.baseObject
                local data = soundGenData[id]
                if soundCreature and data then
                    local gen = tes3.getSoundGenerator(soundCreature.id, data.gen)
                    if gen and gen.sound then
                        gen.sound:play(nil, 1)
                    end
                end
            end,
            [tes3.actorType.npc] =
            ---@param m tes3mobileNPC
            function(m)
                PlayVoice(id, m.object.race.id, m.object.female)
            end,
            [tes3.actorType.player] =
            ---@param m tes3mobilePlayer
            function(m)
                PlayVoice(id, m.object.race.id, m.object.female)
            end,
        }
        if types[mobile.actorType] then
            types[mobile.actorType](mobile)
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
