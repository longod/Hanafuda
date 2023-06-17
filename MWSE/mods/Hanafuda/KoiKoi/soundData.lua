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
    continue = 1,  -- koi-koi
    finish = 2,    -- shobu
    loseRound = 3, -- negative
    winGame = 4,   -- positive
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
    [this.voice.think] = { gen = tes3.soundGenType.moan },
    [this.voice.remind] = { gen = tes3.soundGenType.roar },
}

-- todo there are placeholder
-- Maybe we should have 2 levels, depending on disposition.
---@type {[string] : {[string]: {[VoiceId] : string[] } } } race, sex, VoiceId, file excluding directory
this.voiceData = {
    ["argonian"] = {
        ["f"] = {
            [this.voice.continue] = {
                "vo\\a\\f\\Hlo_AF080.mp3", --	Death is upon you. You should find a healer.
                "vo\\a\\f\\Hlo_AF105.mp3", --	Death is upon you. You should find a healer.
            },
            [this.voice.finish] = {
                "vo\\a\\f\\Hlo_AF135.mp3", --	Blessed we are.
                "vo\\a\\f\\Hlo_AF136.mp3", --	This is an honor for me.
            },
            [this.voice.loseRound] = {
                "vo\\a\\f\\Hlo_AF079.mp3", --	It looks unwell, unhealthy...
                "vo\\a\\f\\Hlo_AF104.mp3", --	It looks unwell, unhealthy...
            },
            [this.voice.winGame] = {
                "vo\\a\\f\\Hlo_AF077.mp3", --	Fair travels, friend.
                "vo\\a\\f\\Hlo_AF085.mp3", --	Be well, traveller.
            },
            [this.voice.think] = {
                "vo\\a\\f\\Hlo_AF071.mp3", --	Excuse me, sera.
                "vo\\a\\f\\Hlo_AF109.mp3", --	Share your thoughts.
            },
            [this.voice.remind] = {
                "vo\\a\\f\\Hlo_AF081.mp3", --	What do you ask of me?
                "vo\\a\\f\\Hlo_AF082.mp3", --	Friend?
                "vo\\a\\f\\Hlo_AF083.mp3", --	Yes?
                "vo\\a\\f\\Hlo_AF108.mp3", --	Your bidding, muthsera?
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "vo\\a\\m\\Hlo_AM080.mp3", --	Death is upon you. You should find a healer.
                "vo\\a\\m\\Hlo_AM105.mp3", --	Death is upon you. You should find a healer.
            },
            [this.voice.finish] = {
                "vo\\a\\m\\Hlo_AM135.mp3", --	Blessed we are.
                "vo\\a\\m\\Hlo_AM136.mp3", --	This is an honor for me.
            },
            [this.voice.loseRound] = {
                "vo\\a\\m\\Hlo_AM079.mp3", --	It looks unwell, unhealthy...
                "vo\\a\\m\\Hlo_AM104.mp3", --	It looks unwell, unhealthy...
            },
            [this.voice.winGame] = {
                "vo\\a\\m\\Hlo_AM077.mp3", --	Fair travels, friend.
                "vo\\a\\m\\Hlo_AM085.mp3", --	Be well, traveller.
            },
            [this.voice.think] = {
                "vo\\a\\m\\Hlo_AM071.mp3", --	Excuse me, saer.
                "vo\\a\\m\\Hlo_AM109.mp3", --	Share your thoughts, friend.
            },
            [this.voice.remind] = {
                "vo\\a\\m\\Hlo_AM081.mp3", --	What do you ask of me?
                "vo\\a\\m\\Hlo_AM082.mp3", --	Friend?
                "vo\\a\\m\\Hlo_AM083.mp3", --	Yes?
                "vo\\a\\m\\Hlo_AM087.mp3", --	Ah, yes. What is it, Muthsera?
                "vo\\a\\m\\Hlo_AM089.mp3", --	What is it? What do you want?
                "vo\\a\\m\\Hlo_AM108.mp3", --	Your bidding, Muthsera?
            },
        },
    },
    ["breton"] = {
        ["f"] = {
            [this.voice.continue] = {
                "vo\\b\\f\\Hlo_BF086.mp3", --	Go ahead, I'm listening.
                "vo\\b\\f\\Hlo_BF088.mp3", --	I'm listening, please, go ahead.
                "vo\\b\\f\\Hlo_BF136.mp3", --	I must say, I find you most interesting right now. Please, go ahead.
            },
            [this.voice.finish] = {
                "vo\\b\\f\\Hlo_BF118.mp3", --	My pleasure, truly.
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
                "vo\\b\\f\\Hlo_BF077.mp3", --	You shouldn't be here.
            },
            [this.voice.think] = {
                "vo\\b\\f\\Hlo_BF087.mp3", --	I suppose I have a moment. What is it?
            },
            [this.voice.remind] = {
                "vo\\b\\f\\Hlo_BF084.mp3", --	Yes, what is it?
                "vo\\b\\f\\Hlo_BF091.mp3", --	Is there something I can do for you?
                "vo\\b\\f\\Hlo_BF113.mp3", --	What can I help you with?
                "vo\\b\\f\\Hlo_BF114.mp3", --	How fair thee, friend?
                "vo\\b\\f\\Hlo_BF115.mp3", --	Should you need something, I will be happy to oblige.
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "vo\\b\\m\\Hlo_BM086.mp3", --	Go ahead, I'm listening.
                "vo\\b\\m\\Hlo_BM088.mp3", --	I'm listening, please, go ahead.
                "vo\\b\\m\\Hlo_BM134.mp3", --	I must say, I find you most interesting right now. Please, go ahead.
                "vo\\b\\m\\Hlo_BM136.mp3", --	I must say, I find you most interesting right now. Please, go ahead.
            },
            [this.voice.finish] = {
                "vo\\b\\m\\Srv_BM002.mp3", --	Good day. Let's do business.
            },
            [this.voice.loseRound] = {
                "vo\\b\\m\\Hlo_BM077.mp3", --	You shouldn't be here.
                "vo\\b\\m\\Hlo_BM084.mp3", --	I must be going, so if you could make it quick.
            },
            [this.voice.winGame] = {
            },
            [this.voice.think] = {
                "vo\\b\\m\\Hlo_BM087.mp3", --	I suppose I have a moment. What is it?
            },
            [this.voice.remind] = {
                "vo\\b\\m\\Hlo_BM089.mp3", --	May I help you?
                "vo\\b\\m\\Hlo_BM090.mp3", --	Do you need something?
                "vo\\b\\m\\Hlo_BM091.mp3", --	Is there something I can do for you?
                "vo\\b\\m\\Hlo_BM113.mp3", --	What can I help you with?
                "vo\\b\\m\\Hlo_BM114.mp3", --	How fair thee, friend?
                "vo\\b\\m\\Hlo_BM115.mp3", --	Should you need something, I would be happy to oblige.
            },

        },
    },
    ["dark elf"] = {
        ["f"] = {
            [this.voice.continue] = {
                "vo\\d\\f\\tHlo_DF065.mp3", --	Life is a burden. Bear it with honor.
                "vo\\d\\f\\Hlo_DF123.mp3",  --	I'm listening. Go ahead.
                "vo\\d\\f\\Hlo_DF184.mp3",  --	Go ahead, I'm listening.
            },
            [this.voice.finish] = {
                "vo\\d\\f\\Hlo_DF172.mp3",  --	Three blessings, sera.
                "vo\\d\\f\\Hlo_DF195.mp3",  --	We are blessed. Truly blessed. This is an honor.
                "vo\\d\\f\\tHlo_DF045.mp3", --	Respect is repaid, sera.
                "vo\\d\\f\\tHlo_DF073.mp3", --	Gods grant you justice, sera.
            },
            [this.voice.loseRound] = {
                "vo\\d\\f\\Hlo_DF096.mp3", --	What is it, sera?
                "vo\\d\\f\\Hlo_DF107.mp3", --	We are punished by the gods. The wind is our suffering.
            },
            [this.voice.winGame] = {
                "vo\\d\\f\\Hlo_DF216.mp3",  --	This one honors us. Please. Speak.
                "vo\\d\\f\\tHlo_DF047.mp3", --	Blessings upon your house, sera.
                "vo\\d\\f\\tHlo_DF071.mp3", --	Seven virtues, sera.
                "vo\\d\\f\\tHlo_DF072.mp3", --	Show respect, sera.
            },
            [this.voice.think] = {
                "vo\\d\\f\\tHlo_DF069.mp3", --	Do what is right, and all else shall follow.
                "vo\\d\\f\\Hlo_DF119.mp3",  --	Muthsera?
            },
            [this.voice.remind] = {
                "vo\\d\\f\\Hlo_DF126.mp3",  --	What is this about?
                "vo\\d\\f\\Hlo_DF127.mp3",  --	Can we hurry this up?
                "vo\\d\\f\\Hlo_DF129.mp3",  --	What do you want?
                "vo\\d\\f\\Hlo_DF145.mp3",  --	May I help you?
                "vo\\d\\f\\Hlo_DF147.mp3",  --	Is there something you need?
                "vo\\d\\f\\Hlo_DF148.mp3",  --	Is there something I can do for you?
                "vo\\d\\f\\Hlo_DF150.mp3",  --	How are you?
                "vo\\d\\f\\Hlo_DF193.mp3",  --	Is there something I can do for you?
                "vo\\d\\f\\tHlo_DF153.mp3", --	Happy to help. What's your problem?
                "vo\\d\\f\\tHlo_DF155.mp3", --	Whatever you want... within reason.
                "vo\\d\\f\\tHlo_DF157.mp3", --	Yes?
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "vo\\d\\m\\Hlo_DM123.mp3", --	I'm listening. Go ahead.
                "vo\\d\\m\\Hlo_DM184.mp3", --	Go ahead, I'm listening.
                "vo\\d\\m\\Hlo_DM226.mp3", --	What an unexpected surprise! Please, go ahead outlander.
            },
            [this.voice.finish] = {
                "vo\\d\\m\\Hlo_DM172.mp3", --	Three blessings, sera.
                "vo\\d\\m\\Hlo_DM195.mp3", --	We are blessed. Truly blessed. This is an honor.
                "vo\\d\\m\\tHlo_DM084.mp3", --	Gods grant you justice, sera.
            },
            [this.voice.loseRound] = {
                "vo\\d\\m\\Hlo_DM096.mp3",  --	What is it, sera?
                "vo\\d\\m\\Hlo_DM107.mp3",  --	We are punished by the gods. The wind is our suffering.
                "vo\\d\\m\\tHlo_DM076.mp3", --	Life is a burden. Bear it with honor.
            },
            [this.voice.winGame] = {
                "vo\\d\\m\\Hlo_DM170.mp3", --	So good to see you.
                "vo\\d\\m\\Hlo_DM216.mp3", --	This one honors us. Please, speak.
                "vo\\d\\m\\tHlo_DM083.mp3", --	Show respect, sera.
            },
            [this.voice.think] = {
                "vo\\d\\m\\tHlo_DM082.mp3", --	Seven virtues, sera.
                "vo\\d\\m\\Hlo_DM119.mp3",  --	Muthsera?
            },
            [this.voice.remind] = {
                "vo\\d\\m\\Hlo_DM126.mp3",  --	What is this about?
                "vo\\d\\m\\Hlo_DM127.mp3",  --	Can we hurry this up?
                "vo\\d\\m\\Hlo_DM129.mp3",  --	What do you want?
                "vo\\d\\m\\Hlo_DM130.mp3",  --	Why are you here?
                "vo\\d\\m\\Hlo_DM145.mp3",  --	May I help you?
                "vo\\d\\m\\Hlo_DM147.mp3",  --	Is there something you need?
                "vo\\d\\m\\Hlo_DM148.mp3",  --	Is there something I can do for you?
                "vo\\d\\m\\Hlo_DM150.mp3",  --	How are you?
                "vo\\d\\m\\Hlo_DM193.mp3",  --	Is there something I can do for you?
                "vo\\d\\m\\tHlo_DM183.mp3", --	Whatever you want... within reason.
                "vo\\d\\m\\tHlo_DM185.mp3", --	Yes?
            },

        },
    },
    ["high elf"] = {
        ["f"] = {
            [this.voice.continue] = {
                "vo\\h\\f\\Hlo_HF082.mp3", --	Any time now.
                "vo\\h\\f\\Hlo_HF085.mp3", --	I suppose I could spare a moment or two.
                "vo\\h\\f\\Hlo_HF110.mp3", --	All right, I'm intrigued. Go ahead.
            },
            [this.voice.finish] = {
                "vo\\h\\f\\Hlo_HF092.mp3", --	Hail.
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
                "vo\\h\\f\\Hlo_HF134.mp3", --	An honor to be sure.
                "vo\\h\\f\\Hlo_HF135.mp3", --	How delightful! Welcome.
            },
            [this.voice.think] = {
                "vo\\h\\f\\Hlo_HF109.mp3", --	Well, what have we here? Interesting.
                "vo\\h\\f\\Hlo_HF111.mp3", --	This is unexpected, but not unwelcome. Please go ahead.
            },
            [this.voice.remind] = {
                "vo\\h\\f\\Hlo_HF083.mp3", --	You have my attention.
                "vo\\h\\f\\Hlo_HF089.mp3", --	Do you want something?
                "vo\\h\\f\\Hlo_HF091.mp3", --	Ah, how quaint. How do you do?
                "vo\\h\\f\\Hlo_HF112.mp3", --	How are you?
                "vo\\h\\f\\Hlo_HF117.mp3", --	Ah, there's an intelligent face.
            },

        },
        ["m"] = {
            [this.voice.continue] = {
                "vo\\h\\m\\Hlo_HM082.mp3", --	Any time now.
                "vo\\h\\m\\Hlo_HM085.mp3", --	I suppose I could spare a moment or two.
            },
            [this.voice.finish] = {
                "vo\\h\\m\\Atk_HM001.mp3",	--	This will be the end of you!
                "vo\\h\\m\\Atk_HM002.mp3",	--	Your moment is at an end!
                "vo\\h\\m\\Atk_HM004.mp3",	--	Beg for mercy, snowman!
                "vo\\h\\m\\Atk_HM005.mp3",	--	You haven't a chance against me!
                "vo\\h\\m\\Atk_HM006.mp3",	--	Your suffering will be great!
                "vo\\h\\m\\Atk_HM008.mp3",	--	You're defeated, give up.
                "vo\\h\\m\\Atk_HM011.mp3",	--	It's over for you!
                "vo\\h\\m\\Atk_HM012.mp3",	--	Embrace your demise!
                "vo\\h\\m\\Atk_HM013.mp3",	--	You'll soon be nothing more than a bad memory!
                "vo\\h\\m\\Atk_HM014.mp3",	--	I shall enjoy watching you take your last breath.
                "vo\\h\\m\\Atk_HM015.mp3",	--	Your end is here!
                "vo\\h\\m\\Hlo_HM092.mp3", --	Hail.
            },
            [this.voice.loseRound] = {
                "vo\\h\\m\\Fle_HM003.mp3",	--	I give up! Let me live!
            },
            [this.voice.winGame] = {
                "vo\\h\\m\\Fle_HM004.mp3",	--	You had your chance!
                "vo\\h\\m\\Hlo_HM134.mp3", --	An honor to be sure.
                "vo\\h\\m\\Hlo_HM135.mp3", --	How delightful! Welcome.
            },
            [this.voice.think] = {
                "vo\\h\\m\\Hlo_HM000a.mp3", --	What?!
                "vo\\h\\m\\Hlo_HM000b.mp3", --	Humph!
                "vo\\h\\m\\Hlo_HM000c.mp3", --	Humph!
                "vo\\h\\m\\Hlo_HM109.mp3",  --	Well, what have we here? Interesting.
                "vo\\h\\m\\Hlo_HM111.mp3", --	This is unexpected, but not unwelcome. Please go ahead.
            },
            [this.voice.remind] = {
                "vo\\h\\m\\Hlo_HM083.mp3", --	You have my attention.
                "vo\\h\\m\\Hlo_HM089.mp3", --	Do you want something?
                "vo\\h\\m\\Hlo_HM090.mp3", --	Hello. I hope you won't take too much of my time.
                "vo\\h\\m\\Hlo_HM091.mp3", --	Ah, how quaint. How do you do?
                "vo\\h\\m\\Hlo_HM103.mp3", --	What happened to you?
                "vo\\h\\m\\Hlo_HM112.mp3", --	How are you?
                "vo\\h\\m\\Hlo_HM117.mp3", --	Ah, there's an intelligent face.
            },

        },
    },
    ["imperial"] = {
        ["f"] = {
            [this.voice.continue] = {
                "vo\\i\\f\\Hlo_IF118.mp3", --	Go ahead.
                "vo\\i\\f\\Hlo_IF147.mp3", --	I'm all yours, please go ahead.
            },
            [this.voice.finish] = {
                "vo\\i\\f\\Hlo_IF065.mp3", --	Hail.
            },
            [this.voice.loseRound] = {
                "vo\\i\\f\\Hlo_IF157.mp3", --	It's hard to believe that one can be so notorious and charming at the same time.
            },
            [this.voice.winGame] = {
                "vo\\i\\f\\Hlo_IF106.mp3", --	At ease.
                "vo\\i\\f\\Hlo_IF107.mp3", --	This is truly an honor.
                "vo\\i\\f\\Hlo_IF162.mp3", --	I'd be happy to talk. My pleasure, really.
            },
            [this.voice.think] = {
                "vo\\i\\f\\Hlo_IF075.mp3", --	What brings you out in this mess?
                "vo\\i\\f\\Hlo_IF115.mp3", --	What is this regarding?
            },
            [this.voice.remind] = {
                "vo\\i\\f\\Hlo_IF070.mp3",  --	Don't try anything funny.
                "vo\\i\\f\\Hlo_IF088.mp3",  --	Yes?
                "vo\\i\\f\\Hlo_IF090.mp3",  --	You want something?
                "vo\\i\\f\\Hlo_IF117.mp3",  --	How can I help you?
                "vo\\i\\f\\Hlo_IF120.mp3",  --	Do you want something from me?
                "vo\\i\\f\\Hlo_IF149.mp3",  --	If I can be of any assistance, I'll be happy to help.
                "vo\\i\\f\\Hlo_IF172.mp3",  --	The pleasure is mine. What may I do for you?
                "vo\\i\\f\\tHlo_IF094.mp3", --	Yes?
            },

        },
        ["m"] = {
            [this.voice.continue] = {
                "vo\\i\\m\\Hlo_IM118.mp3", --	Go ahead.
                "vo\\i\\m\\Hlo_IM147.mp3", --	I'm all yours. Please, go ahead.
            },
            [this.voice.finish] = {
                "vo\\i\\m\\Hlo_IM065.mp3", --	Hail.
            },
            [this.voice.loseRound] = {
                "vo\\i\\m\\Hlo_IM156.mp3", --	It's hard to believe one can be so notorious and charming at the same time.
            },
            [this.voice.winGame] = {
            },
            [this.voice.think] = {
                "vo\\i\\m\\Hlo_IM075.mp3", --	What brings you out in this mess?
                "vo\\i\\m\\Hlo_IM115.mp3", --	What is this regarding?
            },
            [this.voice.remind] = {
                "vo\\i\\m\\Hlo_IM088.mp3",  --	Yes?
                "vo\\i\\m\\Hlo_IM090.mp3",  --	You want something, friend?
                "vo\\i\\m\\Hlo_IM117.mp3",  --	How can I help you?
                "vo\\i\\m\\Hlo_IM120.mp3",  --	Do you want something from me?
                "vo\\i\\m\\Hlo_IM172.mp3",  --	The pleasure is mine. What may I do for you?
                "vo\\i\\m\\tHlo_IM098.mp3", --	Yes?
            },

        },
    },
    ["khajiit"] = {
        ["f"] = {
            [this.voice.continue] = {
                "vo\\k\\f\\Hlo_KF071.mp3", --	Khajiit better than lizard. We work hard. No steal. Make you happy.
            },
            [this.voice.finish] = {
                "vo\\k\\f\\Hlo_KF091.mp3", --	Some sugar for you, friend?
            },
            [this.voice.loseRound] = {
                "vo\\k\\f\\Hlo_KF133.mp3", --	Our sugar is yours, friend.
            },
            [this.voice.winGame] = {
                "vo\\k\\f\\Hlo_KF106.mp3", --	You are too easily caught.
                "vo\\k\\f\\Hlo_KF107.mp3", --	Your claws are sharp. You cut many purses.
            },
            [this.voice.think] = {
                "vo\\k\\f\\Hlo_KF093.mp3", --	Not to be afraid of this one.
            },
            [this.voice.remind] = {
                "vo\\k\\f\\Hlo_KF061.mp3", --	What do you need?
                "vo\\k\\f\\Hlo_KF082.mp3", --	What Khajiit do for you?
                "vo\\k\\f\\Hlo_KF084.mp3", --	What do you want?
                "vo\\k\\f\\Hlo_KF114.mp3", --	What is it, friend?
                "vo\\k\\f\\Hlo_KF115.mp3", --	What can Khajiit do for you?
                "vo\\k\\f\\Hlo_KF120.mp3", --	Welcome, friend. Share some sugar?
            },

        },
        ["m"] = {
            [this.voice.continue] = {
                "vo\\k\\m\\Hlo_KM071.mp3", --	Khajiit better than lizard. We work hard. No steal. Make you happy.
            },
            [this.voice.finish] = {
                "vo\\k\\m\\Hlo_KM091.mp3", --	Some sugar for you, friend?
            },
            [this.voice.loseRound] = {
                "vo\\k\\m\\Hlo_KM133.mp3", --	Our sugar is yours, friend.
            },
            [this.voice.winGame] = {
                "vo\\k\\m\\Hlo_KM106.mp3", --	You are too easily caught.
                "vo\\k\\m\\Hlo_KM107.mp3", --	Your claws are sharp. You cut many purses.
            },
            [this.voice.think] = {
                "vo\\k\\m\\Hlo_KM093.mp3", --	Not to be afraid of this one.
            },
            [this.voice.remind] = {
                "vo\\k\\m\\Hlo_KM061.mp3", --	What do you need?
                "vo\\k\\m\\Hlo_KM082.mp3", --	What Khajiit do for you?
                "vo\\k\\m\\Hlo_KM084.mp3", --	What do you want?
                "vo\\k\\m\\Hlo_KM114.mp3", --	What is it, friend?
                "vo\\k\\m\\Hlo_KM115.mp3", --	What can Khajiit do for you?
                "vo\\k\\m\\Hlo_KM120.mp3", --	Welcome, friend. Share some sugar?
            },

        },
    },
    ["nord"] = {
        ["f"] = {
            [this.voice.continue] = {
                "vo\\n\\f\\Hlo_NF084.mp3", --	Head on.
                "vo\\n\\f\\Hlo_NF111.mp3", --	I'm ready for anything. Go ahead.
                "vo\\n\\f\\Hlo_NF090.mp3", --	You've got the better of me. So go ahead.
            },
            [this.voice.finish] = {
                "vo\\n\\f\\Hlo_NF078.mp3", --	Hail.
                "vo\\n\\f\\Hlo_NF092.mp3", --	Hail.
            },
            [this.voice.loseRound] = {
                "vo\\n\\f\\Hlo_NF074.mp3", --	Can't see a thing in this mess.
            },
            [this.voice.winGame] = {
                "vo\\n\\f\\Hlo_NF136.mp3", --	Ah, you bring good fortune with you. Welcome.
            },
            [this.voice.think] = {
                "vo\\n\\f\\Hlo_NF087.mp3", --	What's this all about?
                "vo\\n\\f\\Hlo_NF106.mp3", --	Hmm. You're not here to start trouble, are you?
            },
            [this.voice.remind] = {
                "vo\\n\\f\\Hlo_NF077.mp3", --	On your way.
                "vo\\n\\f\\Hlo_NF088.mp3", --	I take it you want something. Well, what is it?
                "vo\\n\\f\\Hlo_NF091.mp3", --	Ho! What's your pleasure?
                "vo\\n\\f\\Hlo_NF112.mp3", --	That's how I like it, bold and direct! Come, I like you.
                "vo\\n\\f\\Hlo_NF113.mp3", --	Now here's one who can hold their own. How are you?
            },

        },
        ["m"] = {
            [this.voice.continue] = {
                "vo\\n\\m\\Hlo_NM084.mp3", --	Head on.
                "vo\\n\\m\\Hlo_NM111.mp3", --	I'm ready for anything. Go ahead.
                "vo\\n\\m\\Hlo_NM090.mp3", --	You've got the better of me. So go ahead.
            },
            [this.voice.finish] = {
                "vo\\n\\m\\Hlo_NM078.mp3", --	Hail.
                "vo\\n\\m\\Hlo_NM092.mp3", --	Hail.
                "vo\\n\\m\\Hlo_NM135.mp3", --	Hail and welcome, friend. Hail!
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
                "vo\\n\\m\\Hlo_NM082.mp3", --	May the wind be on your back.
                "vo\\n\\m\\Hlo_NM136.mp3", --	Ah, you bring good fortune with you. Welcome.
            },
            [this.voice.think] = {
                "vo\\n\\m\\Hlo_NM087.mp3", --	What's this all about?
                "vo\\n\\m\\Hlo_NM106.mp3", --	Hello. Hmm. You're not here to start trouble, are you?
            },
            [this.voice.remind] = {
                "vo\\n\\m\\Hlo_NM077.mp3", --	On your way.
                "vo\\n\\m\\Hlo_NM088.mp3", --	I take it you want something. Well, what is it?
            },

        },
    },
    ["orc"] = {
        ["f"] = {
            [this.voice.continue] = {
                "vo\\o\\f\\Hlo_OF077.mp3", --	Move on.
                "vo\\o\\f\\Hlo_OF109.mp3", --	You need not be afraid. Only fools earn my anger.
            },
            [this.voice.finish] = {
                "vo\\o\\f\\Hlo_OF083.mp3", --	Strength is a virtue, friend. Welcome
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
                "vo\\o\\f\\Hlo_OF135.mp3", --	A sincere welcome to you. May you be forever blessed.
                "vo\\o\\f\\Hlo_OF137.mp3", --	I see you have great understanding, welcome.
            },
            [this.voice.think] = {
            },
            [this.voice.remind] = {
                "vo\\o\\f\\Hlo_OF078.mp3", --	Yes, what is it?
                "vo\\o\\f\\Hlo_OF087.mp3", --	Your actions show promise. What do you want?
                "vo\\o\\f\\Hlo_OF108.mp3", --	My attention is yours.
                "vo\\o\\f\\Hlo_OF134.mp3", --	I am honored. Truly. How may I help you?
            },

        },
        ["m"] = {
            [this.voice.continue] = {
                "vo\\o\\m\\Hlo_OM077.mp3", --	Move on.
                "vo\\o\\m\\Hlo_OM109.mp3", --	You need not be afraid. My anger is reserved for the foolish.
            },
            [this.voice.finish] = {
                "vo\\o\\m\\Hlo_OM083.mp3", --	Fight well.
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
                "vo\\o\\m\\Hlo_OM132.mp3", --	A hail and hardy welcome, friend.
                "vo\\o\\m\\Hlo_OM135.mp3", --	A sincere welcome to you. May you be forever blessed.
                "vo\\o\\m\\Hlo_OM136.mp3", --	I feel I can truly share with you, without fear.
                "vo\\o\\m\\Hlo_OM137.mp3", --	You have great understanding. Welcome.
            },
            [this.voice.think] = {
            },
            [this.voice.remind] = {
                "vo\\o\\m\\Hlo_OM078.mp3", --	Yes, what is it?
                "vo\\o\\m\\Hlo_OM087.mp3", --	Your actions show promise. What do you want?
                "vo\\o\\m\\Hlo_OM114.mp3", --	How can I help you, friend?
                "vo\\o\\m\\Hlo_OM134.mp3", --	I am honored. Truly. How may I help you?
            },

        },
    },
    ["redguard"] = {
        ["f"] = {
            [this.voice.continue] = {
                "vo\\r\\f\\Hlo_RF077.mp3", --	All right. Go ahead.
                "vo\\r\\f\\Hlo_RF088.mp3", --	I've got a few minutes if you need something, friend.
            },
            [this.voice.finish] = {
                "vo\\r\\f\\Hlo_RF092.mp3", --	Hail.
            },
            [this.voice.loseRound] = {
                "vo\\r\\f\\Hlo_RF115.mp3", --	I think you're going to fit right in here, friend. You've won me over.
            },
            [this.voice.winGame] = {
                "vo\\r\\f\\Hlo_RF135.mp3", --	The pleasure is all mine.
                "vo\\r\\f\\Hlo_RF136.mp3", --	What did I do to deserve this honor?
            },
            [this.voice.think] = {
                "vo\\r\\f\\Hlo_RF134.mp3", --	I like what I see.
            },
            [this.voice.remind] = {
                "vo\\r\\f\\Hlo_RF080.mp3", --	What happened to you?
                "vo\\r\\f\\Hlo_RF087.mp3", --	Anything I can do for you?
                "vo\\r\\f\\Hlo_RF089.mp3", --	Can I help you out? Do you need something?
                "vo\\r\\f\\Hlo_RF090.mp3", --	So, what's this about?
            },

        },
        ["m"] = {
            [this.voice.continue] = {
                "vo\\r\\m\\Hlo_RM078.mp3", --	Come on. What's the good word?
                "vo\\r\\m\\Hlo_RM087.mp3", --	Anything I can do for you?
            },
            [this.voice.finish] = {
                "vo\\r\\m\\Hlo_RM092.mp3", --	Hail.
            },
            [this.voice.loseRound] = {
                "vo\\r\\m\\Hlo_RM115.mp3", --	You've won me over.
            },
            [this.voice.winGame] = {
                "vo\\r\\m\\Hlo_RM135.mp3", --	The pleasure is all mine.
                "vo\\r\\m\\Hlo_RM136.mp3", --	What did I do to deserve this honor?
            },
            [this.voice.think] = {
                "vo\\r\\m\\Hlo_RM090.mp3", --	So, what's this about?
                "vo\\r\\m\\Hlo_RM134.mp3", --	I like what I see.
            },
            [this.voice.remind] = {
                "vo\\r\\m\\Hlo_RM077.mp3", --	Are you looking for something, friend?
                "vo\\r\\m\\Hlo_RM080.mp3", --	What happened to you?
                "vo\\r\\m\\Hlo_RM088.mp3", --	I've got a few minutes if you need something.
                "vo\\r\\m\\Hlo_RM114.mp3", --	Can I do anything to help?
            },

        },
    },
    ["wood elf"] = {
        ["f"] = {
            [this.voice.continue] = {
                "vo\\w\\f\\Hlo_WF077.mp3", --	Go ahead.
                "vo\\w\\f\\Hlo_WF131.mp3", --	And what have we here? Please. Go ahead.
            },
            [this.voice.finish] = {
                "vo\\w\\f\\Hlo_WF132.mp3", --	Hail, friend.
            },
            [this.voice.loseRound] = {
                "vo\\w\\f\\Hlo_WF118.mp3", --	I think you're a thief, because you've stolen my heart.
            },
            [this.voice.winGame] = {
                "vo\\w\\f\\Hlo_WF114.mp3", --	Three blessings friend.
            },
            [this.voice.think] = {
                "vo\\w\\f\\Hlo_WF083.mp3", --	What is this about?
                "vo\\w\\f\\Hlo_WF089.mp3", --	Interesting, go on.
            },
            [this.voice.remind] = {
                "vo\\w\\f\\Hlo_WF085.mp3", --	I don't know if I can help you, but I'll try.
                "vo\\w\\f\\Hlo_WF086.mp3", --	Do you want something from me?
                "vo\\w\\f\\Hlo_WF087.mp3", --	How may I help you?
                "vo\\w\\f\\Hlo_WF091.mp3", --	What can I do for you?
                "vo\\w\\f\\Hlo_WF108.mp3", --	Yes?
                "vo\\w\\f\\Hlo_WF109.mp3", --	Of course. What may I do for you?
                "vo\\w\\f\\Hlo_WF111.mp3", --	And how are you? Can I help you?
                "vo\\w\\f\\Hlo_WF113.mp3", --	How are you?
                "vo\\w\\f\\Hlo_WF115.mp3", --	How can I help? I'll do what I can.
            },

        },
        ["m"] = {
            [this.voice.continue] = {
                "vo\\w\\m\\Hlo_WM062.mp3", --	Go ahead.
                "vo\\w\\m\\Hlo_WM077.mp3", --	Go ahead.
            },
            [this.voice.finish] = {
                "vo\\w\\m\\Hlo_WM132.mp3", --	Hail, friend.
            },
            [this.voice.loseRound] = {
                "vo\\w\\m\\Hlo_WM118.mp3", --	I think you're a thief, because you've stolen my heart.
            },
            [this.voice.winGame] = {
                "vo\\w\\m\\Hlo_WM114.mp3", --	Three blessings, friend.
                "vo\\w\\m\\Hlo_WM131.mp3", --	This is a rare honor.
            },
            [this.voice.think] = {
                "vo\\w\\m\\Hlo_WM078.mp3", --	Well, what is this about?
                "vo\\w\\m\\Hlo_WM083.mp3", --	What is this about?
                "vo\\w\\m\\Hlo_WM089.mp3", --	Interesting, go on.
            },
            [this.voice.remind] = {
                "vo\\w\\m\\Hlo_WM086.mp3", --	Do you want something from me?
                "vo\\w\\m\\Hlo_WM087.mp3", --	How may I help you?
                "vo\\w\\m\\Hlo_WM090.mp3", --	How do you do?
                "vo\\w\\m\\Hlo_WM091.mp3", --	What can I do for you?
                "vo\\w\\m\\Hlo_WM108.mp3", --	Yes?
                "vo\\w\\m\\Hlo_WM109.mp3", --	Of course. What may I do for you?
                "vo\\w\\m\\Hlo_WM111.mp3", --	And how are you? Can I help you?
                "vo\\w\\m\\Hlo_WM113.mp3", --	How are you?
                "vo\\w\\m\\Hlo_WM115.mp3", --	How can I help? I'll do what I can.
            },

        },
    },
}

-- special
---@type {[string] : {[VoiceId] : string[]}} id, VoiceId, file excluding directory
this.npcs = {
}

-- special
---@type {[string] : {[VoiceId] : string[]}} id, VoiceId, file excluding directory
this.creatures = {
    ["dagoth_ur_1"] = {
        [this.voice.continue] = {
            "vo\\misc\\Hit_DU011.mp3", --	Come on!
        },
        [this.voice.finish] = {
            "vo\\misc\\Hit_DU004.mp3", --	Omnipotent. Omniscient. Sovereign. Immutable. How sweet it is to be a god!
            "vo\\misc\\Hit_DU002.mp3", --	Hah-hah-hah-hah. Oh, dear me. Forgive me, but I am enjoying this.
        },
        [this.voice.loseRound] = {
            "vo\\misc\\Hit_DU006.mp3", --	Persistent, aren't you.
            "vo\\misc\\Hit_DU008.mp3", --	STUpid....
            "vo\\misc\\Hit_DU009.mp3", --	You are a stubborn thing, Nerevar.
            "vo\\misc\\Hit_DU012.mp3", --	Damn this thing...
            "vo\\misc\\Hit Heart 4.mp3", --	STOP!
            "vo\\misc\\Hit Heart 6.mp3", --	This is the end. The bitter, bitter end.
        },
        [this.voice.winGame] = {
            "vo\\misc\\Hit_DU005.mp3", --	Farewell, sweet Nerevar. Better luck on your next incarnation.
        },
        [this.voice.think] = {
            "vo\\Misc\\Hit_DU001.mp3", --	Oh, please, Nerevar! Spare me!
            "vo\\misc\\Hit_DU003.mp3", --	I surrender! I surrender! Hah-hah-hah-hah-hah!
            "vo\\misc\\Hit_DU007.mp3", --	This is getting tiresome.
            "vo\\misc\\Hit_DU010.mp3", --	This is taking too long.
        },
        [this.voice.remind] = {
            "vo\\misc\\Dagoth Ur Taunt 3.mp3", --	Come to me, through fire and war. I welcome you.
            "vo\\misc\\Dagoth Ur Taunt 4.mp3", --	Welcome, Moon-and-Star. I have prepared a place for you.
            "vo\\misc\\Dagoth Ur Taunt 6.mp3", --	Welcome, Nerevar. Together we shall speak for the Law and the Land, and shall drive the mongrel dogs of the Empire from Morrowind.
            "vo\\misc\\Dagoth Ur Taunt 7.mp3", --	Is this how you honor the Sixth House, and the tribe unmourned? Come to me openly, and not by stealth.
            "vo\\Misc\\Dagoth Ur Welcome B.mp3", --	Welcome, Moon-and-Star, to this place where destiny is made.
        },
    },
    ["vivec_god"] = {
        [this.voice.continue] = {
            "vo\\Misc\\viv_alm1.mp3",	--	"I won't let you do that."
        },
        [this.voice.finish] = {
            "vo\\Misc\\viv_atk1.mp3",	--	"Foolish, mortal."
        },
        [this.voice.loseRound] = {
            "vo\\Misc\\viv_idl1.mp3",	--	"It is lonely to be a god."
        },
        [this.voice.winGame] = {
            "vo\\Misc\\viv_atk2.mp3",	--	"Don't fight gods, fool."
        },
        [this.voice.think] = {
            "vo\\Misc\\viv_hit1.mp3",
        },
        [this.voice.remind] = {
            "vo\\Misc\\viv_hlo1.mp3",	--	"Yes, incarnate? I am the Vivec and I can answer all your questions."
        },
    },
    ["yagrum bagarn"] = {
        [this.voice.continue] = {
        },
        [this.voice.finish] = {
        },
        [this.voice.loseRound] = {
            "vo\\Misc\\Yagrum_2.mp3",	--	Noooo!
        },
        [this.voice.winGame] = {
        },
        [this.voice.think] = {
        },
        [this.voice.remind] = {
        },
    },
    ["almalexia"] = {
        [this.voice.continue] = {
            "vo\\Misc\\tr_almgreet2.mp3",	--	Come. Bathe in the light of My Mercy.
        },
        [this.voice.finish] = {
            "vo\\Misc\\tr_almgreet1.mp3",	--	Many Blessings upon you, my loyal servant.
        },
        [this.voice.loseRound] = {
        },
        [this.voice.winGame] = {
            "vo\\Misc\\tr_almgreet1.mp3",	--	Many Blessings upon you, my loyal servant.
        },
        [this.voice.think] = {
        },
        [this.voice.remind] = {
            "vo\\Misc\\tr_almgreet3.mp3",	--	What may I do for you, my child?
        },
    },

}

return this
