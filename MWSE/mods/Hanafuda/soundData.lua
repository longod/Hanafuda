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
    loseRound = 3,
    winGame = 4,
    think = 5,
    remind = 6,
}

---@enum MusicId
this.music = {
    win = 1,
    lose = 2,
}

---@class MusicData
---@field path string

-- I'd like to treat it as an SE, but so far I can't.
---@type {[MusicId] : MusicData}
this.musicData = {
    [this.music.win] = { path = "Special/MW_Triumph.mp3" },
    [this.music.lose] = { path = "Special/MW_Death.mp3" },
}

---@class SoundData
---@field soundPath string?
---@field sound string? fallback
---@field volume number? normalzied value

---@type {[SoundEffectId] : SoundData}
this.soundData = {
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

---@class SoundGenData
---@field gen tes3.soundGenType

---@type {[VoiceId] : SoundGenData}
this.soundGenData = {
    [this.voice.continue] = { gen = tes3.soundGenType.moan },
    [this.voice.finish] = { gen = tes3.soundGenType.roar },
    [this.voice.loseRound] = { gen = tes3.soundGenType.scream },
    [this.voice.winGame] = { gen = tes3.soundGenType.roar },
}

-- todo there are placeholder
---@type {[string] : {[string]: {[VoiceId] : string[] } } } race, sex, VoiceId, file excluding directory
this.voiceData = {
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

-- special
---@type {[string] : {[VoiceId] : string[]}} id, VoiceId, file excluding directory
this.creatures = {
    ["dagoth_ur_1"] = {
        [this.voice.continue] = {
            "vo\\misc\\Hit_DU011.mp3",
        },
        [this.voice.finish] = {
            "vo\\misc\\Hit_DU002.mp3",
        },
        [this.voice.loseRound] = {
            "vo\\misc\\Hit Heart 1.mp3",
            "vo\\misc\\Hit Heart 4.mp3",
            "vo\\misc\\Hit Heart 6.mp3",
        },
        [this.voice.winGame] = {
            "vo\\misc\\Hit_DU005.mp3",
        },
        [this.voice.think] = {
            "vo\\misc\\Hit_DU001.mp3",
            "vo\\misc\\Hit_DU003.mp3",
        },
        [this.voice.remind] = {
            "vo\\misc\\Dagoth Ur Taunt 3.mp3",
        },
    }
}

return this
