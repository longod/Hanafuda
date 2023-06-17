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

-- TODO there are placeholder
-- TODO It would be nice to be able to assign unused assets. This is only for assets that are referenced by esm.
-- Structures that can distinguish the gender, race, outlander, etc. of the other party are complex and are avoided.
-- Maybe we should have 2 levels, depending on disposition.
-- Thieves (Thf_) and crime alerts could be useful if the cheat feature could be.
-- Servants (Srv_) have been excluded because they may have a different tone of speech even if it is textually appropriate.
---@type {[string] : {[string]: {[VoiceId] : string[] } } } race, sex, VoiceId, file excluding directory
this.voiceData = {
    ["argonian"] = {
        ["f"] = {
            [this.voice.continue] = {
                "vo\\a\\f\\Hlo_AF011.mp3", --	I will gladly add to your wounds if you do not leave.
                "vo\\a\\f\\Hlo_AF021.mp3", --	Hisses
                "vo\\a\\f\\Hlo_AF022.mp3", --	Hissss!
                "vo\\a\\f\\Hlo_AF053.mp3",	--	The prey approaches.
                "vo\\a\\f\\Hlo_AF059.mp3",	--	The prey approaches.
                "vo\\a\\f\\Hlo_AF114.mp3", --	Please, go ahead. Speak.
            },
            [this.voice.finish] = {
                "vo\\a\\f\\Atk_AF017.mp3", --	Your life is mine!
                "vo\\a\\f\\Hlo_AF043.mp3",	--	You waste my time with your foolishness.
                "vo\\a\\f\\Hlo_AF047.mp3", --	You look unwell.
                "vo\\a\\f\\Hlo_AF048.mp3", --	It looks unwell, unhealthy...
                "vo\\a\\f\\Hlo_AF049.mp3", --	Death is upon you.
                "vo\\a\\f\\Hlo_AF057.mp3", --	Fresh game.
                "vo\\a\\f\\Hlo_AF079.mp3", --	It looks unwell, unhealthy...
                "vo\\a\\f\\Hlo_AF104.mp3", --	It looks unwell, unhealthy...
                "vo\\a\\f\\Hlo_AF131.mp3", --	You are unwell, friend.
            },
            [this.voice.loseRound] = {
                "vo\\a\\f\\Fle_AF002.mp3", --	Stop!
                "vo\\a\\f\\Fle_AF003.mp3", --	Go away!
                "vo\\a\\f\\Fle_AF004.mp3", --	No more!
                "vo\\a\\f\\Fle_AF005.mp3", --	Make it stop!
                "vo\\a\\f\\Hit_AF001.mp3",	--	Ungh!
                "vo\\a\\f\\Hit_AF002.mp3", --	Arrgh.
                "vo\\a\\f\\Hit_AF004.mp3", --	Groan.
                "vo\\a\\f\\Hit_AF005.mp3", --	Groan.
                "vo\\a\\f\\Hit_AF006.mp3", --	Groan.
                "vo\\a\\f\\Hit_AF007.mp3", --	Groan.
                "vo\\a\\f\\Hit_AF008.mp3", --	Grunt.
                "vo\\a\\f\\Hit_AF009.mp3", --	Grunt.
                "vo\\a\\f\\Hit_AF010.mp3", --	Grunt.
                "vo\\a\\f\\Hit_AF011.mp3", --	Grunt.
                "vo\\a\\f\\Hit_AF012.mp3", --	Grunt.
                "vo\\a\\f\\Hit_AF014.mp3", --	Hiss.
                "vo\\a\\f\\Hlo_AF024.mp3",	--	Return to me no more.
                "vo\\a\\f\\Hlo_AF025.mp3", --	Unwelcome it is.
                "vo\\a\\f\\Hlo_AF026.mp3", --	Don't bother me.
                "vo\\a\\f\\Hlo_AF028.mp3", --	Leave me.
                "vo\\a\\f\\Hlo_AF029.mp3", --	Go away, wretch.
            },
            [this.voice.winGame] = {
                "vo\\a\\f\\Hlo_AF071.mp3", --	Excuse me, sera.
                "vo\\a\\f\\Hlo_AF085.mp3", --	Be well, traveller.
                "vo\\a\\f\\Hlo_AF108.mp3", --	Your bidding, muthsera?
                "vo\\a\\f\\Hlo_AF135.mp3", --	Blessed we are.
                "vo\\a\\f\\Hlo_AF136.mp3", --	This is an honor for me.
            },
            [this.voice.think] = {
                "vo\\a\\f\\Hlo_AF000a.mp3", --	What?
                "vo\\a\\f\\Hlo_AF000b.mp3", --	Humph.
                "vo\\a\\f\\Hlo_AF000c.mp3", --	Humph.
                "vo\\a\\f\\Hlo_AF087.mp3",  --	Ah, yes. What is it?
                "vo\\a\\f\\Hlo_AF134.mp3",  --	What is this one before me?
                "vo\\a\\f\\Hlo_AF139.mp3",  --	Hisses
                "vo\\a\\f\\Idl_AF001.mp3",  --	Sniff.
                "vo\\a\\f\\Idl_AF002.mp3",  --	No. That's not it.
                "vo\\a\\f\\Idl_AF007.mp3",  --	What was that?
            },
            [this.voice.remind] = {
                "vo\\a\\f\\Hlo_AF040.mp3", --	Is there nothing for you to do?
                "vo\\a\\f\\Hlo_AF052.mp3", --	Questions?
                "vo\\a\\f\\Hlo_AF082.mp3", --	Friend?
                "vo\\a\\f\\Hlo_AF083.mp3", --	Yes?
                "vo\\a\\f\\Hlo_AF109.mp3", --	Share your thoughts.
                "vo\\a\\f\\Hlo_AF111.mp3", --	It wants something. What does it ask?
                "vo\\a\\f\\Hlo_AF132.mp3",	--	We work hard for you. Ease your burden.
                "vo\\a\\f\\Idl_AF008.mp3", --	Click, click, click.
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "vo\\a\\m\\Atk_AM012.mp3",	--	It will die!
                "vo\\a\\m\\Atk_AM015.mp3",	--	To the gods with you!
                "vo\\a\\m\\Hlo_AM011.mp3",	--	I will gladly add to your wounds if you do not leave.
                "vo\\a\\m\\Hlo_AM021.mp3",	--	Hiss!
                "vo\\a\\m\\Hlo_AM053.mp3",  --	The prey approaches.
                "vo\\a\\m\\Hlo_AM059.mp3",  --	The prey approaches.
                "vo\\a\\m\\Hlo_AM088.mp3",  --	Go ahead, speak.
                "vo\\a\\m\\Hlo_AM114.mp3",  --	Please, go ahead. Speak.
            },
            [this.voice.finish] = {
                "vo\\a\\m\\Atk_AM009.mp3",	--	A small trophy for my young!
                "vo\\a\\m\\Atk_AM010.mp3",	--	Bash!
                "vo\\a\\m\\Atk_AM013.mp3",	--	Suffer!
                "vo\\a\\m\\Atk_AM014.mp3",	--	Die!
                "vo\\a\\m\\Hlo_AM042.mp3",	--	You bother us. Do not waste our time.
                "vo\\a\\m\\Hlo_AM047.mp3",	--	You look unwell.
                "vo\\a\\m\\Hlo_AM048.mp3",  --	It looks unwell, unhealthy...
                "vo\\a\\m\\Hlo_AM049.mp3",  --	Death is upon you.
                "vo\\a\\m\\Hlo_AM057.mp3",  --	Fresh game.
                "vo\\a\\m\\Hlo_AM079.mp3",  --	It looks unwell, unhealthy...
                "vo\\a\\m\\Hlo_AM104.mp3",  --	It looks unwell, unhealthy...
            },
            [this.voice.loseRound] = {
                "vo\\a\\m\\Fle_AM001.mp3",	--	Stop! Help!
                "vo\\a\\m\\Fle_AM002.mp3",	--	Help us!
                "vo\\a\\m\\Fle_AM003.mp3",	--	Go away!
                "vo\\a\\m\\Fle_AM004.mp3",	--	No more!
                "vo\\a\\m\\Fle_AM005.mp3",	--	No!
                "vo\\a\\m\\Hit_AM001.mp3",	--	AAAIIEE!
                "vo\\a\\m\\Hit_AM002.mp3",	--	Arrhgh!
                "vo\\a\\m\\Hit_AM004.mp3",	--	Groan!
                "vo\\a\\m\\Hit_AM005.mp3",	--	Groan!
                "vo\\a\\m\\Hit_AM006.mp3",	--	Groan!
                "vo\\a\\m\\Hit_AM007.mp3",	--	Groan!
                "vo\\a\\m\\Hit_AM008.mp3",	--	Grunt!
                "vo\\a\\m\\Hit_AM009.mp3",	--	Grunt!
                "vo\\a\\m\\Hit_AM010.mp3",	--	Grunt!
                "vo\\a\\m\\Hit_AM012.mp3",	--	Grunt!
                "vo\\a\\m\\Hit_AM013.mp3",	--	Hiss!
                "vo\\a\\m\\Hit_AM014.mp3",	--	Hiss!
                "vo\\a\\m\\Hit_AM015.mp3",	--	Hiss!
                "vo\\a\\m\\Hit_AM016.mp3",	--	Arrgh!
                "vo\\a\\m\\Hlo_AM022.mp3",	--	Be gone!
                "vo\\a\\m\\Hlo_AM024.mp3",	--	Return to me no more.
                "vo\\a\\m\\Hlo_AM025.mp3",	--	Unwelcome it is.
                "vo\\a\\m\\Hlo_AM026.mp3",	--	Don't bother me.
                "vo\\a\\m\\Hlo_AM028.mp3",	--	Leave me.
                "vo\\a\\m\\Hlo_AM029.mp3",	--	Go away, stranger.
            },
            [this.voice.winGame] = {
                "vo\\a\\m\\Hlo_AM135.mp3",  --	Blessed we are.
                "vo\\a\\m\\Hlo_AM136.mp3",  --	This is an honor for me.
                "vo\\a\\m\\Hlo_AM071.mp3",  --	Excuse me, saer.
                "vo\\a\\m\\Hlo_AM085.mp3",  --	Be well, traveller.
                "vo\\a\\m\\Hlo_AM108.mp3",  --	Your bidding, Muthsera?
            },
            [this.voice.think] = {
                "vo\\a\\m\\Hlo_AM000a.mp3",	--	Growl!
                "vo\\a\\m\\Hlo_AM000b.mp3",	--	Humph.
                "vo\\a\\m\\Hlo_AM000c.mp3",	--	Grunt.
                "vo\\a\\m\\Hlo_AM000d.mp3",	--	Pest!
                "vo\\a\\m\\Hlo_AM000e.mp3",	--	Enough!
                "vo\\a\\m\\Idl_AM001.mp3",  --	Grunt.
                "vo\\a\\m\\Idl_AM003.mp3",  --	So much to remember.
                "vo\\a\\m\\Idl_AM008.mp3",  --	Grunt. Grunt. Grunt. Grunt. Grunt.
            },
            [this.voice.remind] = {
                "vo\\a\\m\\Hlo_AM040.mp3",	--	Is there nothing for you to do?
                "vo\\a\\m\\Hlo_AM052.mp3",  --	Questions?
                "vo\\a\\m\\Hlo_AM061.mp3",  --	Questions?
                "vo\\a\\m\\Hlo_AM082.mp3",  --	Friend?
                "vo\\a\\m\\Hlo_AM083.mp3",  --	Yes?
                "vo\\a\\m\\Hlo_AM087.mp3",  --	Ah, yes. What is it, Muthsera?
                "vo\\a\\m\\Hlo_AM089.mp3",  --	What is it? What do you want?
                "vo\\a\\m\\Hlo_AM109.mp3",  --	Share your thoughts, friend.
                "vo\\a\\m\\Hlo_AM111.mp3",  --	It wants something. What does it ask?
                "vo\\a\\m\\Hlo_AM132.mp3",  --	We work hard for you. Ease your burden.
                "vo\\a\\m\\Hlo_AM139.mp3",  --	Hiss!
                "vo\\a\\m\\Idl_AM002.mp3",  --	Small fork on outside, or is it inside....
            },
        },
    },
    ["breton"] = {
        ["f"] = {
            [this.voice.continue] = {
                "vo\\b\\f\\Atk_BF004.mp3",	--	You'll be dead soon!
                "vo\\b\\f\\Atk_BF006.mp3",	--	Death awaits you!
                "vo\\b\\f\\Atk_BF007.mp3",	--	Not long now!
                "vo\\b\\f\\Atk_BF009.mp3",	--	Soon you'll be reduced to dust!
                "vo\\b\\f\\Atk_BF010.mp3",	--	Come on, fight!
                "vo\\b\\f\\Hlo_BF086.mp3",	--	Go ahead, I'm listening.
                "vo\\b\\f\\Hlo_BF088.mp3",	--	I'm listening, please, go ahead.
                "vo\\b\\f\\Hlo_BF134.mp3",	--	Go ahead, please. Tell me about yourself.
                "vo\\b\\f\\Hlo_BF136.mp3",	--	I must say, I find you most interesting right now. Please, go ahead.
            },
            [this.voice.finish] = {
                "vo\\b\\f\\Atk_BF001.mp3",	--	Ha-ha!
                "vo\\b\\f\\Atk_BF002.mp3",	--	Ha!
                "vo\\b\\f\\Atk_BF003.mp3",	--	I have you!
                "vo\\b\\f\\Atk_BF005.mp3",	--	Your skills fail you!
                "vo\\b\\f\\Atk_BF008.mp3",	--	You should have run while you had a chance!
                "vo\\b\\f\\Atk_BF012.mp3",	--	My victory is at hand!
                "vo\\b\\f\\Atk_BF014.mp3",	--	To the death!
            },
            [this.voice.loseRound] = {
                "vo\\b\\f\\Fle_BF001.mp3",	--	You'll get yours!
                "vo\\b\\f\\Fle_BF002.mp3",	--	Help!
                "vo\\b\\f\\Fle_BF003.mp3",	--	Hey, leave me alone! I give up!
                "vo\\b\\f\\Fle_BF004.mp3",	--	I've had enough of this! I hope you get eaten by a kagouti!
                "vo\\b\\f\\Fle_BF005.mp3",	--	Go away!
                "vo\\b\\f\\Hit_BF001.mp3",	--	AAAIIEE.
                "vo\\b\\f\\Hit_BF002.mp3",	--	Oomph!
                "vo\\b\\f\\Hit_BF003.mp3",	--	Ack!
                "vo\\b\\f\\Hit_BF004.mp3",	--	Groan.
                "vo\\b\\f\\Hit_BF005.mp3",	--	Groan.
                "vo\\b\\f\\Hit_BF006.mp3",	--	Groan.
                "vo\\b\\f\\Hit_BF007.mp3",	--	Groan.
                "vo\\b\\f\\Hit_BF008.mp3",	--	Grunt.
                "vo\\b\\f\\Hit_BF009.mp3",	--	Grunt.
                "vo\\b\\f\\Hit_BF010.mp3",	--	Grunt.
                "vo\\b\\f\\Hit_BF011.mp3",	--	Grunt.
                "vo\\b\\f\\Hit_BF012.mp3",	--	Grunt.
                "vo\\b\\f\\Hit_BF013.mp3",	--	Hiss.
                "vo\\b\\f\\Hit_BF014.mp3",	--	Hiss.
                "vo\\b\\f\\Hit_BF015.mp3",	--	Hiss.
                "vo\\b\\f\\Hlo_BF000e.mp3",	--	Get out of here!
                "vo\\b\\f\\Hlo_BF014.mp3",	--	You're positively revolting.
                "vo\\b\\f\\Hlo_BF022.mp3",	--	This is most unsettling. Leave me.
            },
            [this.voice.winGame] = {
                "vo\\b\\f\\Hlo_BF000d.mp3",	--	I won't waste my time on the likes of you.
                "vo\\b\\f\\Hlo_BF001.mp3",	--	I think you should go elsewhere.
                "vo\\b\\f\\Hlo_BF011.mp3",	--	Whatever trouble you've gotten yourself into, you'll have to deal with it yourself.
                "vo\\b\\f\\Hlo_BF025.mp3",	--	No, I don't have time for you.
                "vo\\b\\f\\Hlo_BF116.mp3",	--	To what do I owe this pleasure?
                "vo\\b\\f\\Hlo_BF118.mp3",	--	My pleasure, truly.
            },
            [this.voice.think] = {
                "vo\\b\\f\\Hlo_BF000a.mp3",	--	What?
                "vo\\b\\f\\Hlo_BF000b.mp3",	--	Hmmph!
                "vo\\b\\f\\Hlo_BF000c.mp3",	--	Hmmph!
                "vo\\b\\f\\Hlo_BF026.mp3",	--	Well, this should be interesting.
                "vo\\b\\f\\Hlo_BF074.mp3",	--	What brings you out in this mess?
                "vo\\b\\f\\Hlo_BF084.mp3",	--	Yes, what is it?
                "vo\\b\\f\\Hlo_BF087.mp3",	--	I suppose I have a moment. What is it?
                "vo\\b\\f\\Idl_BF001.mp3",	--	What was that about?
                "vo\\b\\f\\Idl_BF003.mp3",	--	What was I thinking?
                "vo\\b\\f\\Idl_BF004.mp3",	--	Dirt, dirt, dirt, dirt, dirt. Everywhere dirt.
                "vo\\b\\f\\Idl_BF005.mp3",	--	Who put that there?
                "vo\\b\\f\\Idl_BF006.mp3",	--	Whistle.
                "vo\\b\\f\\Idl_BF007.mp3",	--	Cough.
                "vo\\b\\f\\Idl_BF008.mp3",	--	Clears throat.
                "vo\\b\\f\\Idl_BF009.mp3",	--	Sniff.
            },
            [this.voice.remind] = {
                "vo\\b\\f\\Hlo_BF027.mp3",	--	Don't press your luck.
                -- "vo\\b\\f\\Hlo_BF030.mp3",	--	Be quick about this or find someone else to talk to.
                -- "vo\\b\\f\\Hlo_BF041.mp3",	--	What say you?
                -- "vo\\b\\f\\Hlo_BF054.mp3",	--	I haven't much time, so be quick about this.
                "vo\\b\\f\\Hlo_BF055.mp3",	--	I hope this won't take long.
                -- "vo\\b\\f\\Hlo_BF056.mp3",	--	I am busy, so, if you will excuse me.
                "vo\\b\\f\\Hlo_BF058.mp3",	--	So what do you want?
                "vo\\b\\f\\Hlo_BF061.mp3",	--	Yes?
                "vo\\b\\f\\Hlo_BF089.mp3",	--	May I help you?
                "vo\\b\\f\\Hlo_BF090.mp3",	--	Do you need something?
                "vo\\b\\f\\Hlo_BF091.mp3",	--	Is there something I can do for you?
                "vo\\b\\f\\Hlo_BF109.mp3",	--	What can I do for you, friend?
                "vo\\b\\f\\Hlo_BF113.mp3",	--	What can I help you with?
                "vo\\b\\f\\Hlo_BF114.mp3",	--	How fair thee, friend?
                "vo\\b\\f\\Hlo_BF115.mp3",	--	Should you need something, I will be happy to oblige.
                "vo\\b\\f\\Hlo_BF135.mp3",	--	Share your thoughts, friend, I enjoy the company.
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "vo\\b\\m\\Atk_BM004.mp3",	--	You'll be dead soon!
                "vo\\b\\m\\Atk_BM006.mp3",	--	Death awaits you!
                "vo\\b\\m\\Atk_BM007.mp3",	--	Not long now!
                "vo\\b\\m\\Atk_BM009.mp3",	--	Soon you'll be reduced to dust!
                "vo\\b\\m\\Atk_BM010.mp3",	--	Come on, fight!
                "vo\\b\\m\\Hlo_BM086.mp3",	--	Go ahead, I'm listening.
                "vo\\b\\m\\Hlo_BM088.mp3",	--	I'm listening, please, go ahead.
                "vo\\b\\m\\Hlo_BM134.mp3",	--	I must say, I find you most interesting right now. Please, go ahead.
                "vo\\b\\m\\Hlo_BM136.mp3",	--	I must say, I find you most interesting right now. Please, go ahead.
            },
            [this.voice.finish] = {
                "vo\\b\\m\\Atk_BM001.mp3",	--	Ha-ha!
                "vo\\b\\m\\Atk_BM002.mp3",	--	Ha!
                "vo\\b\\m\\Atk_BM003.mp3",	--	I have you!
                "vo\\b\\m\\Atk_BM005.mp3",	--	Your skills fail you!
                "vo\\b\\m\\Atk_BM008.mp3",	--	You should have run while you had a chance!
                "vo\\b\\m\\Atk_BM012.mp3",	--	My victory is at hand!
                "vo\\b\\m\\Atk_BM014.mp3",	--	To the death!
                -- "vo\\b\\m\\CrAtk_BM001.mp3",	--	Arrgh!
                -- "vo\\b\\m\\CrAtk_BM002.mp3",	--	Rarrh!
                -- "vo\\b\\m\\CrAtk_BM003.mp3",	--	Huhh!
                -- "vo\\b\\m\\CrAtk_BM004.mp3",	--	Ha!
                -- "vo\\b\\m\\CrAtk_BM005.mp3",	--	Die!
                "vo\\b\\m\\Idl_BM005.mp3",	--	I shouldn't have pushed so hard.
            },
            [this.voice.loseRound] = {
                "vo\\b\\m\\Fle_BM001.mp3",	--	You've won this time, but you'll get yours!
                "vo\\b\\m\\Fle_BM002.mp3",	--	Help!
                "vo\\b\\m\\Fle_BM003.mp3",	--	Leave me alone!
                "vo\\b\\m\\Fle_BM004.mp3",	--	Not today.
                "vo\\b\\m\\Fle_BM005.mp3",	--	I have no more quarrel with you. Go away!
                "vo\\b\\m\\Hit_BM001.mp3",	--	AAAIIEE.
                "vo\\b\\m\\Hit_BM002.mp3",	--	Umph!
                "vo\\b\\m\\Hit_BM004.mp3",	--	Ow!
                "vo\\b\\m\\Hit_BM005.mp3",	--	Arghph!
                "vo\\b\\m\\Hit_BM006.mp3",	--	Ungh!
                "vo\\b\\m\\Hit_BM007.mp3",	--	Hungh!
                "vo\\b\\m\\Hit_BM008.mp3",	--	Gulp!
                "vo\\b\\m\\Hit_BM009.mp3",	--	Aaghph!
                "vo\\b\\m\\Hit_BM010.mp3",	--	Ungh!
                "vo\\b\\m\\Hit_BM011.mp3",	--	Ooof!
                "vo\\b\\m\\Hit_BM012.mp3",	--	Aaahgh!
                "vo\\b\\m\\Hit_BM013.mp3",	--	Unulph!
                "vo\\b\\m\\Hit_BM014.mp3",	--	Ungh!
                "vo\\b\\m\\Hit_BM015.mp3",	--	Wheeze!
                "vo\\b\\m\\Hlo_BM000e.mp3",	--	Get out of here!
                "vo\\b\\m\\Hlo_BM014.mp3",	--	You're positively revolting.
                "vo\\b\\m\\Hlo_BM022.mp3",	--	This is most unsettling. Leave me.
            },
            [this.voice.winGame] = {
                "vo\\b\\m\\Hlo_BM000d.mp3",	--	I won't waste my time on the likes of you!
                "vo\\b\\m\\Hlo_BM001.mp3",	--	I think you should go elsewhere.
                "vo\\b\\m\\Hlo_BM011.mp3",	--	Whatever trouble you've gotten yourself into, you'll have to deal with it yourself.
                "vo\\b\\m\\Hlo_BM025.mp3",	--	I don't have time for you.
                "vo\\b\\m\\Hlo_BM116.mp3",	--	To what do I owe this pleasure?

            },
            [this.voice.think] = {
                "vo\\b\\m\\Hlo_BM000a.mp3",	--	What?!
                "vo\\b\\m\\Hlo_BM000b.mp3",	--	Humph.
                "vo\\b\\m\\Hlo_BM000c.mp3",	--	Humph.
                "vo\\b\\m\\Hlo_BM026.mp3",	--	This should be interesting.
                "vo\\b\\m\\Hlo_BM058.mp3",	--	What's this then?
                "vo\\b\\m\\Hlo_BM059.mp3",	--	What's this about?
                "vo\\b\\m\\Hlo_BM060.mp3",	--	What's this regarding?
                "vo\\b\\m\\Idl_BM004.mp3",	--	Dirt, dirt, dirt, dirt, dirt. Everywhere dirt.
                "vo\\b\\m\\Idl_BM006.mp3",	--	Whistle.
                "vo\\b\\m\\Idl_BM007.mp3",	--	Humm.
                "vo\\b\\m\\Idl_BM008.mp3",	--	Clears throat.
                "vo\\b\\m\\Idl_BM009.mp3",	--	Sniff.
            },
            [this.voice.remind] = {
                "vo\\b\\m\\Hlo_BM027.mp3",	--	Don't press your luck.
                -- "vo\\b\\m\\Hlo_BM030.mp3",	--	Be quick about this or find someone else to talk to.
                -- "vo\\b\\m\\Hlo_BM041.mp3",	--	What say you?
                -- "vo\\b\\m\\Hlo_BM054.mp3",	--	I haven't much time, so be quick about this.
                "vo\\b\\m\\Hlo_BM055.mp3",	--	I hope this won't take long.
                -- "vo\\b\\m\\Hlo_BM056.mp3",	--	I am busy, so, if you will excuse me.
                "vo\\b\\m\\Hlo_BM057.mp3",	--	What do you want?
                "vo\\b\\m\\Hlo_BM061.mp3",	--	Yes, friend?
                "vo\\b\\m\\Hlo_BM083.mp3",	--	All right, I'm listening.
                "vo\\b\\m\\Hlo_BM087.mp3",	--	I suppose I have a moment. What is it?
                "vo\\b\\m\\Hlo_BM089.mp3",	--	May I help you?
                "vo\\b\\m\\Hlo_BM090.mp3",	--	Do you need something?
                "vo\\b\\m\\Hlo_BM091.mp3",	--	Is there something I can do for you?
                "vo\\b\\m\\Hlo_BM108.mp3",	--	What can I do for you, friend?
                "vo\\b\\m\\Hlo_BM109.mp3",	--	Tidings and good wishes to you.
                "vo\\b\\m\\Hlo_BM113.mp3",	--	What can I help you with?
                "vo\\b\\m\\Hlo_BM114.mp3",	--	How fair thee, friend?
                "vo\\b\\m\\Hlo_BM115.mp3",	--	Should you need something, I would be happy to oblige.
                "vo\\b\\m\\Hlo_BM135.mp3",	--	Well, I find myself in pleasant company. Please, share your thoughts.
                "vo\\b\\m\\Hlo_BM137.mp3",	--	Well, I find myself in pleasant company. Please, share your thoughts.
                "vo\\b\\m\\Idl_BM001.mp3",	--	Do I drop the sweetroll or hand it over and come back later? Dunno....
                "vo\\b\\m\\Idl_BM002.mp3",	--	The blue plates are nice, but the brown ones seem to last longer.
                "vo\\b\\m\\Idl_BM003.mp3",	--	I think that tavern girl was looking at me. How can I tell her I'm not interested?
            },
        },
    },
    ["dark elf"] = {
        ["f"] = {
            [this.voice.continue] = {
                "vo\\d\\f\\Atk_DF002.mp3",	--	Your life's end is approaching.
                "vo\\d\\f\\Atk_DF008.mp3",	--	You will suffer greatly!
                "vo\\d\\f\\Atk_DF009.mp3",	--	There is no escape!
                "vo\\d\\f\\Atk_DF010.mp3",	--	Your pain is nearing an end!
                "vo\\d\\f\\Atk_DF012.mp3",	--	You will die!
                "vo\\d\\f\\Atk_DF013.mp3",	--	Surrender your life to me and I will end your pain!
                "vo\\d\\f\\bAtk_DF003.mp3",	--	I've got a bone for you. Come and get it!
                "vo\\d\\f\\Fle_DF001.mp3",	--	This will not go unnoticed, you will be disgraced for this.
                "vo\\d\\f\\Hlo_DF025.mp3",	--	Go now.
                "vo\\d\\f\\Hlo_DF031.mp3",	--	Not today.
                "vo\\d\\f\\Hlo_DF036.mp3",	--	There's no time for talk now. Go.
                "vo\\d\\f\\Hlo_DF084.mp3",	--	Go ahead.
                "vo\\d\\f\\Hlo_DF092.mp3",	--	Come on, I haven't got all day to stand around and talk to you.
                "vo\\d\\f\\Hlo_DF123.mp3",	--	I'm listening. Go ahead.
                "vo\\d\\f\\Hlo_DF184.mp3",	--	Go ahead, I'm listening.
                "vo\\d\\f\\tHlo_DF159.mp3",	--	It's fine with me. Go ahead.
                "vo\\d\\f\\tHlo_DF160.mp3",	--	Go ahead. I'm waiting.
                "vo\\d\\f\\tHlo_DF171.mp3",	--	Go on. I can't stop you.
            },
            [this.voice.finish] = {
                "vo\\d\\f\\Atk_DF001.mp3",	--	Now you die.
                "vo\\d\\f\\Atk_DF003.mp3",	--	Die, fetcher.
                "vo\\d\\f\\Atk_DF004.mp3",	--	You n'wah!
                "vo\\d\\f\\Atk_DF005.mp3",	--	This is the end of you, s'wit.
                "vo\\d\\f\\Atk_DF011.mp3",	--	I have you!
                "vo\\d\\f\\bAtk_DF002.mp3",	--	Your head will be my new trophy!
                -- "vo\\d\\f\\CrAtk_DF001.mp3",	--	Arrgh!
                -- "vo\\d\\f\\CrAtk_DF002.mp3",	--	Rarrgh!
                -- "vo\\d\\f\\CrAtk_DF003.mp3",	--	Hurrrgh!
                -- "vo\\d\\f\\CrAtk_DF004.mp3",	--	Ha!
                -- "vo\\d\\f\\CrAtk_DF005.mp3",	--	Die!
                "vo\\d\\f\\Hlo_DF172.mp3",	--	Three blessings, sera.
                "vo\\d\\f\\Hlo_DF195.mp3",	--	We are blessed. Truly blessed. This is an honor.
                "vo\\d\\f\\tHlo_DF017.mp3",	--	Walk in the light, in the spirits' names.
                "vo\\d\\f\\tHlo_DF040.mp3",	--	I smell your blood, mortal.
                "vo\\d\\f\\tHlo_DF071.mp3",	--	Seven virtues, sera.
                "vo\\d\\f\\tHlo_DF075.mp3",	--	Out of our mouths, truth, sera.
                "vo\\d\\f\\tIdl_DF007.mp3",	--	No chance. None.
            },
            [this.voice.loseRound] = {
                "vo\\d\\f\\bFle_DF003.mp3",	--	Go away! I don't have any treats!
                "vo\\d\\f\\Fle_DF003.mp3",	--	I can't take anymore!
                "vo\\d\\f\\Fle_DF004.mp3",	--	Let me live!
                "vo\\d\\f\\Fle_DF005.mp3",	--	This fight is over!
                "vo\\d\\f\\Hit_DF001.mp3",	--	Arrgh.
                "vo\\d\\f\\Hit_DF002.mp3",	--	Eeek
                "vo\\d\\f\\Hit_DF003.mp3",	--	Ooph!
                "vo\\d\\f\\Hit_DF003.mp3",	--	Oooff.
                "vo\\d\\f\\Hit_DF004.mp3",	--	Ughn
                "vo\\d\\f\\Hit_DF005.mp3",	--	Stoopid.
                "vo\\d\\f\\Hit_DF006.mp3",	--	AIIEEE.
                "vo\\d\\f\\Hit_DF007.mp3",	--	Groan.
                "vo\\d\\f\\Hit_DF008.mp3",	--	Groan.
                "vo\\d\\f\\Hit_DF009.mp3",	--	Ungh!
                "vo\\d\\f\\Hit_DF009.mp3",	--	Groan.
                "vo\\d\\f\\Hit_DF010.mp3",	--	Grunt.
                "vo\\d\\f\\Hit_DF011.mp3",	--	Grunt.
                "vo\\d\\f\\Hit_DF012.mp3",	--	Groan.
                "vo\\d\\f\\Hit_DF013.mp3",	--	Growl.
                "vo\\d\\f\\Hit_DF014.mp3",	--	Gasp.
                "vo\\d\\f\\Hlo_DF000e.mp3",	--	Get out of here!
                "vo\\d\\f\\Hlo_DF001.mp3",	--	Go away.
                "vo\\d\\f\\Hlo_DF017.mp3",	--	I am not amused.
                "vo\\d\\f\\Hlo_DF029.mp3",	--	How rude!
                "vo\\d\\f\\Hlo_DF033.mp3",	--	Leave me.
                "vo\\d\\f\\Hlo_DF040.mp3",	--	I can already tell I'm not going to like this.
                "vo\\d\\f\\Hlo_DF041.mp3",	--	Oh, come on. Leave me alone.
                "vo\\d\\f\\Hlo_DF072.mp3",	--	Say what you want or go away.
                "vo\\d\\f\\Hlo_DF107.mp3",	--	We are punished by the gods. The wind is our suffering.
                "vo\\d\\f\\tHlo_DF007.mp3",	--	Get OUT! Now!
                "vo\\d\\f\\tHlo_DF033.mp3",	--	So much for THAT problem....
                "vo\\d\\f\\tHlo_DF034.mp3",	--	You BEAST! Get out of here!
                "vo\\d\\f\\tHlo_DF062.mp3",	--	Mind your tongue, sera.
                "vo\\d\\f\\tHlo_DF088.mp3",	--	It's terrible. Terrible. I'm so worried....

            },
            [this.voice.winGame] = {
                "vo\\d\\f\\bAtk_DF004.mp3",	--	I've fought guars more ferocious than you!
                "vo\\d\\f\\Hlo_DF000d.mp3",	--	I don't waste my time on the likes of you!
                "vo\\d\\f\\Hlo_DF022.mp3",	--	You waste your time. Go away.
                "vo\\d\\f\\Hlo_DF023.mp3",	--	You must be joking. Bother someone else.
                "vo\\d\\f\\Hlo_DF046.mp3",	--	If you'll excuse me, I don't have time for you right now. Or ever.
                "vo\\d\\f\\Hlo_DF077.mp3",	--	Spit it out or hit the road.
                "vo\\d\\f\\Hlo_DF219.mp3",	--	I'm very happy to make your acquaintance.
                "vo\\d\\f\\Hlo_DF222.mp3",	--	I don't know where to begin. It is such an honor to meet you.
                "vo\\d\\f\\Hlo_DF223.mp3",	--	It's so good to meet you.
                "vo\\d\\f\\tHlo_DF031.mp3",	--	You were very brave.
                "vo\\d\\f\\tHlo_DF045.mp3",	--	Respect is repaid, sera.
                "vo\\d\\f\\tHlo_DF046.mp3",	--	Your words are your measure, sera.
                "vo\\d\\f\\tHlo_DF047.mp3",	--	Blessings upon your house, sera.
                "vo\\d\\f\\tHlo_DF064.mp3",	--	I'll thank you to be brief, sera.
                "vo\\d\\f\\tHlo_DF065.mp3",	--	Life is a burden. Bear it with honor.
                "vo\\d\\f\\tHlo_DF067.mp3",	--	Forget tomorrow. If you are right, act today.
                "vo\\d\\f\\tHlo_DF069.mp3",	--	Do what is right, and all else shall follow.
                "vo\\d\\f\\tHlo_DF072.mp3",	--	Show respect, sera.
                "vo\\d\\f\\tHlo_DF073.mp3",	--	Gods grant you justice, sera.
                "vo\\d\\f\\tHlo_DF074.mp3",	--	I'll judge your words fairly, sera.
                "vo\\d\\f\\tHlo_DF076.mp3",	--	Walk in mercy, sera.
                "vo\\d\\f\\tHlo_DF078.mp3",	--	A pure reputation is wealth enough for me, sera.
                "vo\\d\\f\\tHlo_DF085.mp3",	--	Take care, stranger.

            },
            [this.voice.think] = {
                "vo\\d\\f\\bIdl_DF013.mp3",	--	*Pfbbbbbbbt*
                "vo\\d\\f\\bIdl_DF014.mp3",	--	Oh, not AGAIN!
                "vo\\d\\f\\Hlo_DF000a.mp3",	--	What?
                "vo\\d\\f\\Hlo_DF000b.mp3",	--	Humph!
                "vo\\d\\f\\Hlo_DF000c.mp3",	--	Groan.
                "vo\\d\\f\\Hlo_DF047.mp3",	--	What now?
                "vo\\d\\f\\Hlo_DF075.mp3",	--	No. I don't think so.
                "vo\\d\\f\\Hlo_DF079.mp3",	--	What now?
                "vo\\d\\f\\Hlo_DF080.mp3",	--	This better be important.
                "vo\\d\\f\\tHlo_DF041.mp3",	--	So much to do, so little time....
                "vo\\d\\f\\tHlo_DF027.mp3",	--	Excuse me, please.
                "vo\\d\\f\\tHlo_DF161.mp3",	--	Excuse me. Did you say something?
                "vo\\d\\f\\tHlo_DF162.mp3",	--	Excuse me. I was just thinking...
                "vo\\d\\f\\tIdl_DF012.mp3",	--	Gods, that itches.
            },
            [this.voice.remind] = {
                "vo\\d\\f\\bIdl_DF003.mp3",	--	An untidy tale comes to a sorry end.
                "vo\\d\\f\\bIdl_DF004.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\d\\f\\bIdl_DF015.mp3",	--	[Wide yawn.]
                -- "vo\\d\\f\\Hlo_DF035.mp3",	--	Keep moving, scum.
                "vo\\d\\f\\Hlo_DF070.mp3",	--	Do you want something?
                "vo\\d\\f\\Hlo_DF074.mp3",	--	Whatever you're looking for, I'm sure I don't know how to find it.
                "vo\\d\\f\\Hlo_DF085.mp3",	--	What do you want?
                "vo\\d\\f\\Hlo_DF090.mp3",	--	My time is precious, so make it quick.
                "vo\\d\\f\\Hlo_DF091.mp3",	--	I'm waiting.
                "vo\\d\\f\\Hlo_DF095.mp3",	--	Let's hear it.
                "vo\\d\\f\\Hlo_DF096.mp3",	--	What is it, sera?
                "vo\\d\\f\\Hlo_DF119.mp3",	--	Muthsera?
                "vo\\d\\f\\Hlo_DF126.mp3",	--	What is this about?
                "vo\\d\\f\\Hlo_DF127.mp3",	--	Can we hurry this up?
                "vo\\d\\f\\Hlo_DF129.mp3",	--	What do you want?
                "vo\\d\\f\\Hlo_DF145.mp3",	--	May I help you?
                "vo\\d\\f\\Hlo_DF147.mp3",	--	Is there something you need?
                "vo\\d\\f\\Hlo_DF148.mp3",	--	Is there something I can do for you?
                "vo\\d\\f\\Hlo_DF179.mp3",	--	Tell me what you want.
                "vo\\d\\f\\Hlo_DF193.mp3",	--	Is there something I can do for you?
                "vo\\d\\f\\Idl_DF001.mp3",	--	Cough.
                "vo\\d\\f\\Idl_DF002.mp3",	--	Sniff.
                "vo\\d\\f\\Idl_DF003.mp3",	--	Sigh.
                "vo\\d\\f\\Idl_DF004.mp3",	--	Grumbling.
                "vo\\d\\f\\tHlo_DF018.mp3",	--	What do you want?
                "vo\\d\\f\\tHlo_DF020.mp3",	--	What do you want with me?
                "vo\\d\\f\\tHlo_DF036.mp3",	--	Well? What's going on?
                "vo\\d\\f\\tHlo_DF044.mp3",	--	Do you have a question for me, sera?
                "vo\\d\\f\\tHlo_DF079.mp3",	--	Be quick, and I shall serve you, sera.
                "vo\\d\\f\\tHlo_DF151.mp3",	--	I'm not busy now. What do you need?
                "vo\\d\\f\\tHlo_DF153.mp3",	--	Happy to help. What's your problem?
                "vo\\d\\f\\tHlo_DF155.mp3",	--	Whatever you want... within reason.
                "vo\\d\\f\\tHlo_DF157.mp3",	--	Yes?
                "vo\\d\\f\\tHlo_DF165.mp3",	--	What is it now?
                "vo\\d\\f\\tHlo_DF167.mp3",	--	Will this take long?
                "vo\\d\\f\\tHlo_DF169.mp3",	--	Well?
                "vo\\d\\f\\tHlo_DF170.mp3",	--	So? You want something?
                "vo\\d\\f\\tHlo_DF172.mp3",	--	If you insist...
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "vo\\d\\m\\Atk_DM002.mp3",	--	Your life's end is approaching.
                "vo\\d\\m\\Atk_DM007.mp3",	--	You will suffer greatly.
                "vo\\d\\m\\Atk_DM008.mp3",	--	There is no escape.
                "vo\\d\\m\\Atk_DM009.mp3",	--	Your pain is nearing an end.
                "vo\\d\\m\\Atk_DM011.mp3",	--	You will die.
                "vo\\d\\m\\Atk_DM012.mp3",	--	Surrender your life to me and I will end your pain!
                "vo\\d\\m\\bAtk_DM003.mp3",	--	I've got a bone for you. Come and get it!
                "vo\\d\\m\\Fle_DM001.mp3",	--	This will not go unnoticed!
                "vo\\d\\m\\Hlo_DM025.mp3",	--	Go now.
                "vo\\d\\m\\Hlo_DM031.mp3",	--	Not today.
                "vo\\d\\m\\Hlo_DM084.mp3",	--	Go ahead.
                "vo\\d\\m\\Hlo_DM094.mp3",	--	I've got better things to do, so, if you don't mind, let's move this along.
                "vo\\d\\m\\Hlo_DM123.mp3",	--	I'm listening. Go ahead.
                "vo\\d\\m\\Hlo_DM184.mp3",	--	Go ahead, I'm listening.
                "vo\\d\\m\\tHlo_DM032.mp3",	--	Carry on. I'm listening.
                "vo\\d\\m\\tHlo_DM058.mp3",	--	Could it get any worse?
                "vo\\d\\m\\tHlo_DM069.mp3",	--	Welcome to MY world, where we do things MY way.
                "vo\\d\\m\\tHlo_DM083.mp3",	--	Show respect, sera.
                "vo\\d\\m\\tHlo_DM187.mp3",	--	It's fine with me. Go ahead.
                "vo\\d\\m\\tHlo_DM188.mp3",	--	Go ahead. I'm waiting.
                "vo\\d\\m\\tHlo_DM199.mp3",	--	Go on. I can't stop you.
                "vo\\d\\m\\tIdl_DM002.mp3",	--	Try me, and you'll regret it.
            },
            [this.voice.finish] = {
                "vo\\d\\m\\Atk_DM001.mp3",	--	Now you die.
                "vo\\d\\m\\Atk_DM003.mp3",	--	Die, fetcher.
                "vo\\d\\m\\Atk_DM004.mp3",	--	You n'wah!
                "vo\\d\\m\\Atk_DM005.mp3",	--	This is the end of you, s'wit.
                -- "vo\\d\\m\\Atk_DM006.mp3",	--	ARRRR!
                "vo\\d\\m\\Atk_DM010.mp3",	--	I have you.
                "vo\\d\\m\\Atk_DM013.mp3",	--	You're beaten.
                "vo\\d\\m\\Atk_DM014.mp3",	--	Your wounds are great!
                "vo\\d\\m\\bAtk_DM002.mp3",	--	Your head will be my new trophy!
                -- "vo\\d\\m\\CrAtk_AM001.mp3",	--	Arrgh!
                -- "vo\\d\\m\\CrAtk_AM002.mp3",	--	Hrarh!
                -- "vo\\d\\m\\CrAtk_AM003.mp3",	--	Hungh!
                -- "vo\\d\\m\\CrAtk_AM004.mp3",	--	Ha!
                -- "vo\\d\\m\\CrAtk_AM005.mp3",	--	Die!
                "vo\\d\\m\\Hlo_DM172.mp3",	--	Three blessings, sera.
                "vo\\d\\m\\Hlo_DM195.mp3",	--	We are blessed. Truly blessed. This is an honor.
                "vo\\d\\m\\tHlo_DM023.mp3",	--	We are in your debt, sera.
                "vo\\d\\m\\tHlo_DM027.mp3",	--	We are pleased to see you, sera.
                "vo\\d\\m\\tHlo_DM028.mp3",	--	Welcome, sera.
                "vo\\d\\m\\tHlo_DM035.mp3",	--	What are YOU staring at?
                "vo\\d\\m\\tHlo_DM041.mp3",	--	Look on me, and despair!
                "vo\\d\\m\\tHlo_DM060.mp3",	--	It's never easy, is it?
                "vo\\d\\m\\tHlo_DM064.mp3",	--	We print the truth -- the straight truth.
                "vo\\d\\m\\tHlo_DM074.mp3",	--	Justice never sleeps.
                "vo\\d\\m\\tHlo_DM080.mp3",	--	Do what is right, and all else shall follow.
                "vo\\d\\m\\tHlo_DM084.mp3",	--	Gods grant you justice, sera.
                "vo\\d\\m\\tIdl_DM004.mp3",	--	Trust in Gods and Justice.
            },
            [this.voice.loseRound] = {
                "vo\\d\\m\\bFle_DM003.mp3",	--	Go away! I don't have any treats!
                "vo\\d\\m\\bHlo_DM004.mp3",	--	Uh... there's a perfectly good explanation for this, I assure you...
                "vo\\d\\m\\bIdl_DM002.mp3",	--	The sun shines every day in hell.
                "vo\\d\\m\\Fle_DM003.mp3",	--	I cannot take anymore!
                "vo\\d\\m\\Fle_DM004.mp3",	--	Let me live!
                "vo\\d\\m\\Fle_DM005.mp3",	--	You will be disgraced for this!
                "vo\\d\\m\\Hit_DM001.mp3",	--	Arrgh.
                "vo\\d\\m\\Hit_DM002.mp3",	--	Umph!
                "vo\\d\\m\\Hit_DM003.mp3",	--	Omph!
                "vo\\d\\m\\Hit_DM004.mp3",	--	Ughn
                "vo\\d\\m\\Hit_DM005.mp3",	--	Grunt.
                "vo\\d\\m\\Hit_DM006.mp3",	--	Argh!
                "vo\\d\\m\\Hit_DM007.mp3",	--	Grunt!
                "vo\\d\\m\\Hit_DM008.mp3",	--	Grunt!
                "vo\\d\\m\\Hit_DM009.mp3",	--	Groan!
                "vo\\d\\m\\Hit_DM010.mp3",	--	Umph!
                "vo\\d\\m\\Hit_DM011.mp3",	--	Ungh!
                "vo\\d\\m\\Hit_DM012.mp3",	--	Ugh!
                "vo\\d\\m\\Hit_DM013.mp3",	--	Unngh!
                "vo\\d\\m\\Hit_DM014.mp3",	--	Ungh!
                "vo\\d\\m\\Hlo_DM000e.mp3",	--	That is quite enough!
                "vo\\d\\m\\Hlo_DM001.mp3",	--	Go away.
                "vo\\d\\m\\Hlo_DM017.mp3",	--	I am not amused.
                "vo\\d\\m\\Hlo_DM026.mp3",	--	What, n'wah?
                "vo\\d\\m\\Hlo_DM029.mp3",	--	How rude!
                "vo\\d\\m\\Hlo_DM030.mp3",	--	Must you be so annoying? Go away.
                "vo\\d\\m\\Hlo_DM033.mp3",	--	Leave me.
                "vo\\d\\m\\Hlo_DM041.mp3",	--	Oh, come on. Leave me alone.
                "vo\\d\\m\\Hlo_DM072.mp3",	--	Say what you want or go away.
                "vo\\d\\m\\Hlo_DM107.mp3",	--	We are punished by the gods. The wind is our suffering.
                "vo\\d\\m\\tHlo_DM008.mp3",	--	Well, well, well. Aren't YOU the tasty little morsel?
                "vo\\d\\m\\tHlo_DM043.mp3",	--	Mind your tongue, sera.
                "vo\\d\\m\\tHlo_DM049.mp3",	--	Scram, f'lah.
                "vo\\d\\m\\tHlo_DM071.mp3",	--	Yes? W-w-what? What do you w-w-want?
                "vo\\d\\m\\tHlo_DM072.mp3",	--	Oh, dear. Oh, m-m-my. Goddess protect me.
            },
            [this.voice.winGame] = {
                "vo\\d\\m\\bAtk_DM004.mp3",	--	I've fought guars more ferocious than you!
                "vo\\d\\m\\bIdl_DM001.mp3",	--	The best swimmers are soonest drowned.
                "vo\\d\\m\\Hlo_DM023.mp3",	--	You must be joking. Bother someone else.
                "vo\\d\\m\\Hlo_DM022.mp3",	--	You waste your time. Go away.
                "vo\\d\\m\\Hlo_DM024.mp3",	--	Whatever it is, I'm not interested.
                "vo\\d\\m\\Hlo_DM046.mp3",	--	If you'll excuse me, I don't have time for you right now. Or ever.
                "vo\\d\\m\\Hlo_DM077.mp3",	--	Spit it out or hit the road.
                "vo\\d\\m\\Hlo_DM216.mp3",	--	This one honors us. Please, speak.
                "vo\\d\\m\\Hlo_DM219.mp3",	--	I'm very happy to make your acquaintance.
                "vo\\d\\m\\Hlo_DM222.mp3",	--	I don't know where to begin. It is such an honor to meet you.
                "vo\\d\\m\\Hlo_DM223.mp3",	--	It's so good to meet you.
                "vo\\d\\m\\tHlo_DM001.mp3",	--	Peace! Now I must be silent, and join my ancestors.
                "vo\\d\\m\\tHlo_DM006.mp3",	--	With the right deal, we all profit.
                "vo\\d\\m\\tHlo_DM007.mp3",	--	Hey there, sport. What's the word?
                "vo\\d\\m\\tHlo_DM026.mp3",	--	Your reputation does you honor, sera.
                "vo\\d\\m\\tHlo_DM045.mp3",	--	I'll thank you to be brief, sera.
                "vo\\d\\m\\tHlo_DM057.mp3",	--	Not bad for an amateur.
                "vo\\d\\m\\tHlo_DM059.mp3",	--	Relax. You'll be fine.
                "vo\\d\\m\\tHlo_DM063.mp3",	--	I'll thank you to be brief, sera.
                "vo\\d\\m\\tHlo_DM076.mp3",	--	Life is a burden. Bear it with honor.
                "vo\\d\\m\\tHlo_DM077.mp3",	--	Honor is food and drink for the soul.
                "vo\\d\\m\\tHlo_DM078.mp3",	--	Forget tomorrow. If you are right, act today.
                "vo\\d\\m\\tHlo_DM082.mp3",	--	Seven virtues, sera.
                "vo\\d\\m\\tHlo_DM086.mp3",	--	Out of our mouths, truth, sera.
                "vo\\d\\m\\tHlo_DM087.mp3",	--	Walk in mercy, sera.
                "vo\\d\\m\\tHlo_DM089.mp3",	--	A pure reputation is wealth enough for me, sera.
                "vo\\d\\m\\tHlo_DM097.mp3",	--	Respect is repaid, sera.
                "vo\\d\\m\\tHlo_DM099.mp3",	--	Blessings upon your house, sera.
                "vo\\d\\m\\tHlo_DM113.mp3",	--	I'll thank you to be brief, sera.
            },
            [this.voice.think] = {
                "vo\\d\\m\\bHlo_DM006.mp3",	--	Here to choose from our incredibly limited selection? What'll it be?
                "vo\\d\\m\\bHlo_DM007.mp3",	--	So old.... So weary.
                "vo\\d\\m\\bIdl_DM004.mp3",	--	Uh-oh!
                "vo\\d\\m\\bIdl_DM005.mp3",	--	Please, not again....
                "vo\\d\\m\\bIdl_DM006.mp3",	--	How'd that get there?
                "vo\\d\\m\\bIdl_DM012.mp3",	--	*Pfbbbbbbbt*
                "vo\\d\\m\\bIdl_DM013.mp3",	--	Oh, not AGAIN!
                "vo\\d\\m\\Hlo_DM000b.mp3",	--	Humph.
                "vo\\d\\m\\Hlo_DM000c.mp3",	--	Hmmph.
                "vo\\d\\m\\Hlo_DM040.mp3",	--	I can already tell I'm not going to like this.
                "vo\\d\\m\\Hlo_DM075.mp3",	--	No. I don't think so.
                "vo\\d\\m\\Hlo_DM079.mp3",	--	What now?
                "vo\\d\\m\\Hlo_DM080.mp3",	--	This better be important.
                "vo\\d\\m\\Idl_DM007.mp3",	--	What was that?
                "vo\\d\\m\\Idl_DM008.mp3",	--	Probably nothing.
                "vo\\d\\m\\tHlo_DM010.mp3",	--	Take care, stranger.
                "vo\\d\\m\\tHlo_DM031.mp3",	--	Yes, I've been around, I can tell you. Been there done that....
                "vo\\d\\m\\tHlo_DM052.mp3",	--	Sorry. Not interested.
                "vo\\d\\m\\tHlo_DM073.mp3",	--	What is it now? Must we go on?
                "vo\\d\\m\\tHlo_DM116.mp3",	--	Gods' grief! What next?
                "vo\\d\\m\\tHlo_DM189.mp3",	--	Excuse me. Did you say something?
                "vo\\d\\m\\tHlo_DM190.mp3",	--	Excuse me. I was just thinking...
                "vo\\d\\m\\tIdl_DM003.mp3",	--	A hard judge, but fair.
                "vo\\d\\m\\tIdl_DM006.mp3",	--	What are you gawking at?
                "vo\\d\\m\\tIdl_DM008.mp3",	--	Must be going crazy, talking to myself like this...
                "vo\\d\\m\\tIdl_DM019.mp3",	--	[Laughter]
            },
            [this.voice.remind] = {
                "vo\\d\\m\\bIdl_DM003.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\d\\m\\bIdl_DM007.mp3",	--	Well, if it bothers you so much, just don't look at it, all right?
                "vo\\d\\m\\bIdl_DM014.mp3",	--	[Wide yawn.]
                -- "vo\\d\\m\\Hlo_DM035.mp3",	--	Keep moving, scum.
                "vo\\d\\m\\Hlo_DM047.mp3",	--	What now?
                "vo\\d\\m\\Hlo_DM070.mp3",	--	Do you want something?
                "vo\\d\\m\\Hlo_DM074.mp3",	--	Whatever you're looking for, I'm sure I don't know how to find it.
                "vo\\d\\m\\Hlo_DM085.mp3",	--	What do you want?
                -- "vo\\d\\m\\Hlo_DM090.mp3",	--	My time is precious, so make it quick.
                "vo\\d\\m\\Hlo_DM091.mp3",	--	I'm waiting.
                "vo\\d\\m\\Hlo_DM096.mp3",	--	What is it, sera?
                "vo\\d\\m\\Hlo_DM119.mp3",	--	Muthsera?
                "vo\\d\\m\\Hlo_DM126.mp3",	--	What is this about?
                "vo\\d\\m\\Hlo_DM127.mp3",	--	Can we hurry this up?
                "vo\\d\\m\\Hlo_DM129.mp3",	--	What do you want?
                "vo\\d\\m\\Hlo_DM145.mp3",	--	May I help you?
                "vo\\d\\m\\Hlo_DM147.mp3",	--	Is there something you need?
                "vo\\d\\m\\Hlo_DM148.mp3",	--	Is there something I can do for you?
                "vo\\d\\m\\Hlo_DM179.mp3",	--	Tell me what you want.
                "vo\\d\\m\\Hlo_DM193.mp3",	--	Is there something I can do for you?
                "vo\\d\\m\\Idl_DM001.mp3",	--	Cough.
                "vo\\d\\m\\Idl_DM002.mp3",	--	Sniff.
                "vo\\d\\m\\Idl_DM003.mp3",	--	Sigh.
                "vo\\d\\m\\Idl_DM004.mp3",	--	Grumbling.
                "vo\\d\\m\\tHlo_DM090.mp3",	--	Be quick, and I shall serve you, sera.
                "vo\\d\\m\\tHlo_DM179.mp3",	--	I'm not busy now. What do you need?
                "vo\\d\\m\\tHlo_DM181.mp3",	--	Happy to help. What's your problem?
                "vo\\d\\m\\tHlo_DM183.mp3",	--	Whatever you want... within reason.
                "vo\\d\\m\\tHlo_DM185.mp3",	--	Yes?
                "vo\\d\\m\\tHlo_DM193.mp3",	--	What is it now?
                "vo\\d\\m\\tHlo_DM195.mp3",	--	Will this take long?
                "vo\\d\\m\\tHlo_DM197.mp3",	--	Well?
                "vo\\d\\m\\tHlo_DM198.mp3",	--	So? You want something?
                "vo\\d\\m\\tHlo_DM200.mp3",	--	If you insist...
                "vo\\d\\m\\tIdl_DM007.mp3",	--	Do I care?
                "vo\\d\\m\\tIdl_DM018.mp3",	--	Ahh... ahh... CHUE!
                "vo\\d\\m\\tIdl_DM021.mp3",	--	Woo-hoo-hoo-hoo!
                "vo\\d\\m\\tIdl_DM022.mp3",	--	Dah-da-dah-de-dah-de-dah.
            },
        },
    },
    ["high elf"] = {
        ["f"] = {
            [this.voice.continue] = {
                "vo\\h\\f\\Atk_HF007.mp3",	--	You will die in disgrace.
                "vo\\h\\f\\Atk_HF013.mp3",	--	You'll soon be nothing more than a bad memory!
                "vo\\h\\f\\Atk_HF014.mp3",	--	I shall enjoy watching you take your last breath.
                "vo\\h\\f\\Hlo_HF013.mp3",	--	There are other places to die. I suggest you find one.
                "vo\\h\\f\\Hlo_HF040.mp3",	--	Identify yourself.
                "vo\\h\\f\\Hlo_HF056.mp3",	--	Identify yourself.
                "vo\\h\\f\\Hlo_HF110.mp3",	--	All right, I'm intrigued. Go ahead.
            },
            [this.voice.finish] = {
                "vo\\h\\f\\Atk_HF011.mp3",	--	It's over for you!
                "vo\\h\\f\\Atk_HF012.mp3",	--	Embrace your demise!
                "vo\\h\\f\\Atk_HF015.mp3",	--	Your end is here!
                "vo\\h\\f\\Fle_HF004.mp3",	--	You had your chance!
                "vo\\h\\f\\Hlo_HF012.mp3",	--	You look fairly beaten. Care for more?
                "vo\\h\\f\\Hlo_HF029.mp3",	--	Spare me the formalities and get to the point.
                "vo\\h\\f\\Hlo_HF041.mp3",	--	Hail.
                "vo\\h\\f\\Hlo_HF049.mp3",	--	Trouble seems to have found you and given you a good kicking.
                "vo\\h\\f\\Hlo_HF092.mp3",	--	Hail.
            },
            [this.voice.loseRound] = {
                "vo\\h\\f\\Fle_HF003.mp3",	--	I give up!
                "vo\\h\\f\\Fle_HF005.mp3",	--	No!
                "vo\\h\\f\\Hit_HF001.mp3",	--	AAAIIEE.
                "vo\\h\\f\\Hit_HF002.mp3",	--	Arrgh.
                "vo\\h\\f\\Hit_HF003.mp3",	--	Fetcher!
                "vo\\h\\f\\Hit_HF004.mp3",	--	Groan.
                "vo\\h\\f\\Hit_HF005.mp3",	--	Groan.
                "vo\\h\\f\\Hit_HF006.mp3",	--	Ungh!
                "vo\\h\\f\\Hit_HF007.mp3",	--	Groan.
                "vo\\h\\f\\Hit_HF008.mp3",	--	Grunt.
                "vo\\h\\f\\Hit_HF009.mp3",	--	Grunt.
                "vo\\h\\f\\Hit_HF010.mp3",	--	Grunt.
                "vo\\h\\f\\Hit_HF011.mp3",	--	Grunt.
                "vo\\h\\f\\Hit_HF012.mp3",	--	Grunt.
                "vo\\h\\f\\Hit_HF013.mp3",	--	Hiss.
                "vo\\h\\f\\Hit_HF014.mp3",	--	Ungh!
                "vo\\h\\f\\Hit_HF015.mp3",	--	Hiss.
                "vo\\h\\f\\Hlo_HF000e.mp3",	--	Get out of here!
                "vo\\h\\f\\Hlo_HF019.mp3",	--	I sense great hostility -- mine.
                "vo\\h\\f\\Hlo_HF027.mp3",	--	You again. How tiresome.
                "vo\\h\\f\\Hlo_HF111.mp3",	--	This is unexpected, but not unwelcome. Please go ahead.
                "vo\\h\\f\\Idl_HF001.mp3",	--	The indignity of it all.
            },
            [this.voice.winGame] = {
                "vo\\h\\f\\Hlo_HF000d.mp3",	--	Clearly, you are an idiot.
                "vo\\h\\f\\Hlo_HF001.mp3",	--	I haven't any time for you now.
                "vo\\h\\f\\Hlo_HF055.mp3",	--	You will address me with respect.
                "vo\\h\\f\\Hlo_HF117.mp3",	--	Ah, there's an intelligent face.
                "vo\\h\\f\\Hlo_HF134.mp3",	--	An honor to be sure.
                "vo\\h\\f\\Hlo_HF135.mp3",	--	How delightful! Welcome.
            },
            [this.voice.think] = {
                "vo\\h\\f\\Hlo_HF000a.mp3",	--	What?
                "vo\\h\\f\\Hlo_HF000b.mp3",	--	Hmph!
                "vo\\h\\f\\Hlo_HF000c.mp3",	--	Hmph!
                "vo\\h\\f\\Hlo_HF024.mp3",	--	Do you mind?
                "vo\\h\\f\\Hlo_HF025.mp3",	--	This better be good.
                "vo\\h\\f\\Hlo_HF026.mp3",	--	This is an unwelcome surprise.
                "vo\\h\\f\\Hlo_HF085.mp3",	--	I suppose I could spare a moment or two.
                "vo\\h\\f\\Hlo_HF109.mp3",	--	Well, what have we here? Interesting.
            },
            [this.voice.remind] = {
                -- "vo\\h\\f\\Hlo_HF054.mp3",	--	Is it necessary that you speak with ME?
                "vo\\h\\f\\Hlo_HF057.mp3",	--	You have something to say to me?
                "vo\\h\\f\\Hlo_HF059.mp3",	--	My patience is limited.
                "vo\\h\\f\\Hlo_HF060.mp3",	--	Can we hurry this along?
                "vo\\h\\f\\Hlo_HF061.mp3",	--	What assistance do you need?
                "vo\\h\\f\\Hlo_HF082.mp3",	--	Any time now.
                "vo\\h\\f\\Hlo_HF083.mp3",	--	You have my attention.
                "vo\\h\\f\\Hlo_HF089.mp3",	--	Do you want something?
                "vo\\h\\f\\Idl_HF006.mp3",	--	Whistle.
                "vo\\h\\f\\Idl_HF007.mp3",	--	Humm.
                "vo\\h\\f\\Idl_HF008.mp3",	--	Cough.
            },
        },
        ["m"] = {
            [this.voice.continue] = {
                "vo\\h\\m\\Atk_HM001.mp3",	--	This will be the end of you!
                "vo\\h\\m\\Atk_HM003.mp3",	--	Prepare to die!
                "vo\\h\\m\\Atk_HM005.mp3",	--	You haven't a chance against me!
                "vo\\h\\m\\Atk_HM006.mp3",	--	Your suffering will be great!
                "vo\\h\\m\\Atk_HM007.mp3",	--	You will die in disgrace.
                "vo\\h\\m\\Atk_HM013.mp3",	--	You'll soon be nothing more than a bad memory!
                "vo\\h\\m\\Hlo_HM040.mp3",	--	Identify yourself.
                "vo\\h\\m\\Hlo_HM056.mp3",	--	Identify yourself.
                "vo\\h\\m\\Hlo_HM110.mp3",	--	All right, I'm intrigued. Go ahead.
            },
            [this.voice.finish] = {
                "vo\\h\\m\\Atk_HM002.mp3",	--	Your moment is at an end!
                "vo\\h\\m\\Atk_HM008.mp3",	--	You're defeated, give up.
                "vo\\h\\m\\Atk_HM009.mp3",	--	HUHHH.
                "vo\\h\\m\\Atk_HM010.mp3",	--	AAAAAAYYYY.
                "vo\\h\\m\\Atk_HM011.mp3",	--	It's over for you!
                "vo\\h\\m\\Atk_HM012.mp3",	--	Embrace your demise!
                "vo\\h\\m\\Atk_HM014.mp3",	--	I shall enjoy watching you take your last breath.
                "vo\\h\\m\\Atk_HM015.mp3",	--	Your end is here!
                -- "vo\\h\\m\\CrAtk_HM001.mp3",	--	Arrrgh!
                -- "vo\\h\\m\\CrAtk_HM002.mp3",	--	Hurrrhhh!
                -- "vo\\h\\m\\CrAtk_HM003.mp3",	--	Hurrragh!
                -- "vo\\h\\m\\CrAtk_HM004.mp3",	--	Hah!
                -- "vo\\h\\m\\CrAtk_HM005.mp3",	--	Die!
                "vo\\h\\m\\Hlo_HM012.mp3",	--	You look fairly beaten. Care for more?
                "vo\\h\\m\\Hlo_HM029.mp3",	--	Spare me the formalities and get to the point.
                "vo\\h\\m\\Hlo_HM041.mp3",	--	Hail.
                "vo\\h\\m\\Hlo_HM092.mp3",	--	Hail.
            },
            [this.voice.loseRound] = {
                "vo\\h\\m\\Fle_HM003.mp3",	--	I give up! Let me live!
                "vo\\h\\m\\Fle_HM004.mp3",	--	You had your chance!
                "vo\\h\\m\\Fle_HM005.mp3",	--	Don't kill me!
                "vo\\h\\m\\Hit_HM001.mp3",	--	Arrgh!
                "vo\\h\\m\\Hit_HM002.mp3",	--	Upmph!
                "vo\\h\\m\\Hit_HM003.mp3",	--	Ungh!
                "vo\\h\\m\\Hit_HM004.mp3",	--	Groan.
                "vo\\h\\m\\Hit_HM005.mp3",	--	Upmph!
                "vo\\h\\m\\Hit_HM006.mp3",	--	Argh!
                "vo\\h\\m\\Hit_HM007.mp3",	--	Ungh!
                "vo\\h\\m\\Hit_HM008.mp3",	--	Ungh!
                "vo\\h\\m\\Hit_HM009.mp3",	--	Ommph!
                "vo\\h\\m\\Hit_HM010.mp3",	--	Aughph!
                "vo\\h\\m\\Hit_HM011.mp3",	--	Grunt!
                "vo\\h\\m\\Hit_HM012.mp3",	--	Umph!
                "vo\\h\\m\\Hit_HM013.mp3",	--	Humph!
                "vo\\h\\m\\Hit_HM015.mp3",	--	Unghaaaah!
                "vo\\h\\m\\Hlo_HM000e.mp3",	--	Get out of here!
                "vo\\h\\m\\Hlo_HM019.mp3",	--	I sense great hostility -- mine.
                "vo\\h\\m\\Hlo_HM027.mp3",	--	You again. How tiresome.
                "vo\\h\\m\\Hlo_HM111.mp3",	--	This is unexpected, but not unwelcome. Please go ahead.
            },
            [this.voice.winGame] = {
                "vo\\h\\m\\Hlo_HM001.mp3",	--	I haven't any time for you now.
                "vo\\h\\m\\Hlo_HM049.mp3",	--	Trouble seems to have found you and given you a good kicking.
                "vo\\h\\m\\Hlo_HM055.mp3",	--	You will address me with respect.
                "vo\\h\\m\\Hlo_HM104.mp3",	--	How tragic, you're barely standing.
                "vo\\h\\m\\Hlo_HM117.mp3",	--	Ah, there's an intelligent face.
                "vo\\h\\m\\Hlo_HM130.mp3",	--	How tragic, friend! You're barely standing.
                "vo\\h\\m\\Hlo_HM134.mp3",	--	An honor to be sure.
                "vo\\h\\m\\Hlo_HM135.mp3",	--	How delightful! Welcome.
            },
            [this.voice.think] = {
                "vo\\h\\m\\Hlo_HM000a.mp3",	--	What?!
                "vo\\h\\m\\Hlo_HM000b.mp3",	--	Humph!
                "vo\\h\\m\\Hlo_HM000c.mp3",	--	Humph!
                "vo\\h\\m\\Hlo_HM024.mp3",	--	Do you mind?
                "vo\\h\\m\\Hlo_HM025.mp3",	--	This better be good.
                "vo\\h\\m\\Hlo_HM026.mp3",	--	This is an unwelcome surprise.
                "vo\\h\\m\\Hlo_HM085.mp3",	--	I suppose I could spare a moment or two.
                "vo\\h\\m\\Hlo_HM109.mp3",	--	Well, what have we here? Interesting.
            },
            [this.voice.remind] = {
                -- "vo\\h\\m\\Hlo_HM000d.mp3",	--	I won't waste my time on the likes of you!
                "vo\\h\\m\\Hlo_HM057.mp3",	--	You have something to say to me?
                "vo\\h\\m\\Hlo_HM059.mp3",	--	My patience is limited.
                "vo\\h\\m\\Hlo_HM060.mp3",	--	Can we hurry this along?
                "vo\\h\\m\\Hlo_HM061.mp3",	--	What assistance do you need?
                "vo\\h\\m\\Hlo_HM082.mp3",	--	Any time now.
                "vo\\h\\m\\Hlo_HM083.mp3",	--	You have my attention.
                "vo\\h\\m\\Hlo_HM089.mp3",	--	Do you want something?
                "vo\\h\\m\\Hlo_HM103.mp3",	--	What happened to you?
                "vo\\h\\m\\Hlo_HM114.mp3",	--	You've piqued my interest. Please, share your thoughts.
                "vo\\h\\m\\Hlo_HM129.mp3",	--	Oh, my good friend. What happened to you?
                "vo\\h\\m\\Idl_HM006.mp3",	--	Whistle.
                "vo\\h\\m\\Idl_HM007.mp3",	--	Humm.
                "vo\\h\\m\\Idl_HM008.mp3",	--	Clearing throat.
                "vo\\h\\m\\Idl_HM009.mp3",	--	Sniff.
            },
        },
    },
    ["imperial"] = {
        ["f"] = {
            [this.voice.continue] = {
            },
            [this.voice.finish] = {
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
            },
            [this.voice.think] = {
            },
            [this.voice.remind] = {
                "vo\\i\\f\\Atk_IF001.mp3",	--	I've trifled with you long enough.
                "vo\\i\\f\\Atk_IF003.mp3",	--	Take that!
                "vo\\i\\f\\Atk_IF005.mp3",	--	You won't escape me that easily!
                "vo\\i\\f\\Atk_IF006.mp3",	--	I have you!
                "vo\\i\\f\\Atk_IF010.mp3",	--	Die, scoundrel!
                "vo\\i\\f\\Atk_IF012.mp3",	--	You've lost this round!
                "vo\\i\\f\\Atk_IF013.mp3",	--	You're not even trying!
                "vo\\i\\f\\Atk_IF014.mp3",	--	This is pointless, give in!
                "vo\\i\\f\\Atk_IF015.mp3",	--	No one can match me!
                "vo\\i\\f\\bAtk_IF001.mp3",	--	Taste my silver, foul beast!
                "vo\\i\\f\\bAtk_IF002.mp3",	--	Kill the beast!
                "vo\\i\\f\\bAtk_IF003.mp3",	--	Hunt it down and kill it!
                "vo\\i\\f\\bAtk_IF004.mp3",	--	Kill the beast!
                "vo\\i\\f\\bAtk_IF005.mp3",	--	Your head will be my new trophy!
                "vo\\i\\f\\bAtk_IF006.mp3",	--	I've got a bone for you. Come and get it!
                "vo\\i\\f\\bAtk_IF007.mp3",	--	I've fought guars more ferocious than you!
                "vo\\i\\f\\bAtk_IF008.mp3",	--	Your cursed bloodline ends here!
                "vo\\i\\f\\bFle_IF001.mp3",	--	Help! A beast!
                "vo\\i\\f\\bFle_IF002.mp3",	--	Get away, beast!
                "vo\\i\\f\\bFle_IF003.mp3",	--	Go away! I don't have any treats!
                "vo\\i\\f\\bFle_IF004.mp3",	--	Don't infect me with your curse!
                "vo\\i\\f\\bHlo_IF001.mp3",	--	The Rite of the Wolf Giver is nearly complete! He he he he he he he he he.
                "vo\\i\\f\\bHlo_IF002.mp3",	--	My sisters and I must make our brew before the Rite can proceed.
                "vo\\i\\f\\bHlo_IF003.mp3",	--	With the proper ingredients, we can cure your lycanthropy, yes....
                "vo\\i\\f\\bHlo_IF004.mp3",	--	Wolfsbane, belladonna, and the purity of innocence are what we need. He he he he he he he.
                "vo\\i\\f\\bHlo_IF005.mp3",	--	Be strong, my friend. You will persevere.
                "vo\\i\\f\\bHlo_IF006.mp3",	--	This place is not of this world. I fear for our lives.
                "vo\\i\\f\\bHlo_IF007.mp3",	--	Have you found more information on the weapons being smuggled from the Fort?
                "vo\\i\\f\\bHlo_IF011.mp3",	--	You've got to find the Captain! The fort needs him!
                "vo\\i\\f\\bHlo_IF012.mp3",	--	You're back. And just in time!
                "vo\\i\\f\\bHlo_IF013.mp3",	--	We gotta find these guys. And smash 'em. Smash 'em good.
                "vo\\i\\f\\bHlo_IF014.mp3",	--	Cap'n said you'd be by. I'm supposed to assist you with something?
                "vo\\i\\f\\bHlo_IF015.mp3",	--	Well, if it isn't you again. I daresay you're one of the nicest people I met, and that's saying quite a lot.
                "vo\\i\\f\\bHlo_IF016.mp3",	--	Get them away, get them away! The horrid things!
                "vo\\i\\f\\bHlo_IF017.mp3",	--	This place isn't much, but I've forged the best of weapons with less.
                "vo\\i\\f\\bIdl_IF001.mp3",	--	Why is he staring at me? Have I got a hunk of bear in my teeth?
                "vo\\i\\f\\bIdl_IF001.mp3",	--	Why is he staring at me? Have I got a hunk of bear in my teeth?
                "vo\\i\\f\\bIdl_IF001.mp3",	--	Why is he staring at me? Have I got a hunk of bear in my teeth?
                "vo\\i\\f\\bIdl_IF001.mp3",	--	Why is he staring at me? Have I got a hunk of bear in my teeth?
                "vo\\i\\f\\bIdl_IF001.mp3",	--	Why is he staring at me? Have I got a hunk of bear in my teeth?
                "vo\\i\\f\\bIdl_IF002.mp3",	--	So these three guys, a Nord, and Orc, and a Wood Elf, walk into the mead hall.... No. Wait. It was a DARK elf. I think....'
                "vo\\i\\f\\bIdl_IF002.mp3",	--	So these three guys, a Nord, and Orc, and a Wood Elf, walk into the mead hall.... No. Wait. It was a DARK elf. I think....'
                "vo\\i\\f\\bIdl_IF002.mp3",	--	So these three guys, a Nord, and Orc, and a Wood Elf, walk into the mead hall.... No. Wait. It was a DARK elf. I think....'
                "vo\\i\\f\\bIdl_IF002.mp3",	--	So these three guys, a Nord, and Orc, and a Wood Elf, walk into the mead hall.... No. Wait. It was a DARK elf. I think....'
                "vo\\i\\f\\bIdl_IF002.mp3",	--	So these three guys, a Nord, and Orc, and a Wood Elf, walk into the mead hall.... No. Wait. It was a DARK elf. I think....'
                "vo\\i\\f\\bIdl_IF003.mp3",	--	My mother warned me about mooks like you.
                "vo\\i\\f\\bIdl_IF003.mp3",	--	My mother warned me about mooks like you.
                "vo\\i\\f\\bIdl_IF003.mp3",	--	My mother warned me about mooks like you.
                "vo\\i\\f\\bIdl_IF003.mp3",	--	My mother warned me about mooks like you.
                "vo\\i\\f\\bIdl_IF003.mp3",	--	My mother warned me about mooks like you.
                "vo\\i\\f\\bIdl_IF004.mp3",	--	Why am I always surrounded by fawning admirers?
                "vo\\i\\f\\bIdl_IF004.mp3",	--	Why am I always surrounded by fawning admirers?
                "vo\\i\\f\\bIdl_IF004.mp3",	--	Why am I always surrounded by fawning admirers?
                "vo\\i\\f\\bIdl_IF004.mp3",	--	Why am I always surrounded by fawning admirers?
                "vo\\i\\f\\bIdl_IF004.mp3",	--	Why am I always surrounded by fawning admirers?
                "vo\\i\\f\\bIdl_IF005.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\i\\f\\bIdl_IF005.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\i\\f\\bIdl_IF005.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\i\\f\\bIdl_IF005.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\i\\f\\bIdl_IF005.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\i\\f\\bIdl_IF006.mp3",	--	No. Not in a million years.
                "vo\\i\\f\\bIdl_IF006.mp3",	--	No. Not in a million years.
                "vo\\i\\f\\bIdl_IF006.mp3",	--	No. Not in a million years.
                "vo\\i\\f\\bIdl_IF006.mp3",	--	No. Not in a million years.
                "vo\\i\\f\\bIdl_IF006.mp3",	--	No. Not in a million years.
                "vo\\i\\f\\bIdl_IF007.mp3",	--	If there's a barrel at the BOTTOM of the barrel, that's where you'll find him.
                "vo\\i\\f\\bIdl_IF007.mp3",	--	If there's a barrel at the BOTTOM of the barrel, that's where you'll find him.
                "vo\\i\\f\\bIdl_IF007.mp3",	--	If there's a barrel at the BOTTOM of the barrel, that's where you'll find him.
                "vo\\i\\f\\bIdl_IF007.mp3",	--	If there's a barrel at the BOTTOM of the barrel, that's where you'll find him.
                "vo\\i\\f\\bIdl_IF007.mp3",	--	If there's a barrel at the BOTTOM of the barrel, that's where you'll find him.
                "vo\\i\\f\\bIdl_IF008.mp3",	--	I got this piece of bacon stuck right here between my teeth.
                "vo\\i\\f\\bIdl_IF008.mp3",	--	I got this piece of bacon stuck right here between my teeth.
                "vo\\i\\f\\bIdl_IF008.mp3",	--	I got this piece of bacon stuck right here between my teeth.
                "vo\\i\\f\\bIdl_IF008.mp3",	--	I got this piece of bacon stuck right here between my teeth.
                "vo\\i\\f\\bIdl_IF008.mp3",	--	I got this piece of bacon stuck right here between my teeth.
                "vo\\i\\f\\bIdl_IF009.mp3",	--	Who IS that guy? Better look busy.....
                "vo\\i\\f\\bIdl_IF009.mp3",	--	Who IS that guy? Better look busy.....
                "vo\\i\\f\\bIdl_IF009.mp3",	--	Who IS that guy? Better look busy.....
                "vo\\i\\f\\bIdl_IF009.mp3",	--	Who IS that guy? Better look busy.....
                "vo\\i\\f\\bIdl_IF009.mp3",	--	Who IS that guy? Better look busy.....
                "vo\\i\\f\\bIdl_IF010.mp3",	--	See scenic Fort Frostmoth. Party with the heathens. Bring your own corpse.
                "vo\\i\\f\\bIdl_IF010.mp3",	--	See scenic Fort Frostmoth. Party with the heathens. Bring your own corpse.
                "vo\\i\\f\\bIdl_IF010.mp3",	--	See scenic Fort Frostmoth. Party with the heathens. Bring your own corpse.
                "vo\\i\\f\\bIdl_IF010.mp3",	--	See scenic Fort Frostmoth. Party with the heathens. Bring your own corpse.
                "vo\\i\\f\\bIdl_IF010.mp3",	--	See scenic Fort Frostmoth. Party with the heathens. Bring your own corpse.
                "vo\\i\\f\\bIdl_IF011.mp3",	--	*Pfbbbbbbbt*
                "vo\\i\\f\\bIdl_IF011.mp3",	--	*Pfbbbbbbbt*
                "vo\\i\\f\\bIdl_IF011.mp3",	--	*Pfbbbbbbbt*
                "vo\\i\\f\\bIdl_IF011.mp3",	--	*Pfbbbbbbbt*
                "vo\\i\\f\\bIdl_IF011.mp3",	--	*Pfbbbbbbbt*
                "vo\\i\\f\\bIdl_IF012.mp3",	--	Oh, not AGAIN!
                "vo\\i\\f\\bIdl_IF012.mp3",	--	Oh, not AGAIN!
                "vo\\i\\f\\bIdl_IF012.mp3",	--	Oh, not AGAIN!
                "vo\\i\\f\\bIdl_IF012.mp3",	--	Oh, not AGAIN!
                "vo\\i\\f\\bIdl_IF012.mp3",	--	Oh, not AGAIN!
                "vo\\i\\f\\bIdl_IF013.mp3",	--	[Wide yawn.]
                "vo\\i\\f\\bIdl_IF013.mp3",	--	[Wide yawn.]
                "vo\\i\\f\\bIdl_IF013.mp3",	--	[Wide yawn.]
                "vo\\i\\f\\bIdl_IF013.mp3",	--	[Wide yawn.]
                "vo\\i\\f\\bIdl_IF013.mp3",	--	[Wide yawn.]
                "vo\\i\\f\\Fle_IF001.mp3",	--	Run away!
                "vo\\i\\f\\Fle_IF002.mp3",	--	I'm getting out of here!
                "vo\\i\\f\\Fle_IF003.mp3",	--	No!
                "vo\\i\\f\\Fle_IF004.mp3",	--	Someone! Please!
                "vo\\i\\f\\Fle_IF005.mp3",	--	Help!
                "vo\\i\\f\\Flw_IF002.mp3",	--	Please, be careful!
                "vo\\i\\f\\Flw_IF005.mp3",	--	I'm on your side!
                "vo\\i\\f\\Hit_IF001.mp3",	--	AAAIIEE.
                "vo\\i\\f\\Hit_IF002.mp3",	--	Arrgh.
                "vo\\i\\f\\Hit_IF003.mp3",	--	Arrgh!
                "vo\\i\\f\\Hit_IF003.mp3",	--	Fetcher!
                "vo\\i\\f\\Hit_IF004.mp3",	--	Groan.
                "vo\\i\\f\\Hit_IF005.mp3",	--	Ungh!
                "vo\\i\\f\\Hit_IF005.mp3",	--	Groan.
                "vo\\i\\f\\Hit_IF006.mp3",	--	Groan.
                "vo\\i\\f\\Hit_IF007.mp3",	--	Groan.
                "vo\\i\\f\\Hit_IF008.mp3",	--	Grunt.
                "vo\\i\\f\\Hit_IF009.mp3",	--	Grunt.
                "vo\\i\\f\\Hit_IF010.mp3",	--	Grunt.
                "vo\\i\\f\\Hit_IF011.mp3",	--	Grunt.
                "vo\\i\\f\\Hit_IF012.mp3",	--	Grunt.
                "vo\\i\\f\\Hit_IF013.mp3",	--	Hiss.
                "vo\\i\\f\\Hit_IF014.mp3",	--	Hiss.
                "vo\\i\\f\\Hit_IF015.mp3",	--	Hiss.
                "vo\\i\\f\\Hlo_IF000a.mp3",	--	What!?
                "vo\\i\\f\\Hlo_IF000b.mp3",	--	Ugh!
                "vo\\i\\f\\Hlo_IF000c.mp3",	--	Uggh!
                "vo\\i\\f\\Hlo_IF000d.mp3",	--	I wouldn't waste my time on the likes of you!
                "vo\\i\\f\\Hlo_IF000e.mp3",	--	Get out of here!
                "vo\\i\\f\\Hlo_IF000e.mp3",	--	Get out of here!
                "vo\\i\\f\\Hlo_IF001.mp3",	--	Why did we bother to recruit you? Get back to work.
                "vo\\i\\f\\Hlo_IF002.mp3",	--	Looks like you've already got some of what's coming to you.
                "vo\\i\\f\\Hlo_IF003.mp3",	--	You don't look so good. Well done.
                "vo\\i\\f\\Hlo_IF004.mp3",	--	Since you're already on death's door... may I open it for you?
                "vo\\i\\f\\Hlo_IF005.mp3",	--	Vile criminal. Get away from me.
                "vo\\i\\f\\Hlo_IF006.mp3",	--	What a pathetic excuse for a criminal.
                "vo\\i\\f\\Hlo_IF007.mp3",	--	Are you here to start trouble, or are you just stupid?
                "vo\\i\\f\\Hlo_IF008.mp3",	--	Someone with your good looks needs more clothing.
                "vo\\i\\f\\Hlo_IF009.mp3",	--	Go away. I don't want to help you.
                "vo\\i\\f\\Hlo_IF010.mp3",	--	I don't think so.
                "vo\\i\\f\\Hlo_IF011.mp3",	--	So tiresome.
                "vo\\i\\f\\Hlo_IF012.mp3",	--	Don't bother me.
                "vo\\i\\f\\Hlo_IF013.mp3",	--	Stay away, vile creature!
                "vo\\i\\f\\Hlo_IF014.mp3",	--	I'm not hiring for cutthroats, Redguard, so go away.
                "vo\\i\\f\\Hlo_IF015.mp3",	--	I haven't anything to eat or smash, so go away.
                "vo\\i\\f\\Hlo_IF016.mp3",	--	Take your drunken war stories elsewhere, braggart.
                "vo\\i\\f\\Hlo_IF017.mp3",	--	Who let you off your leash?
                "vo\\i\\f\\Hlo_IF018.mp3",	--	You're a disgrace to the Empire.
                "vo\\i\\f\\Hlo_IF019.mp3",	--	Are you here to bore me to death with your sermons, Altmer?
                "vo\\i\\f\\Hlo_IF020.mp3",	--	Go complain elsewhere.
                "vo\\i\\f\\Hlo_IF023.mp3",	--	Does your owner know where you are?
                "vo\\i\\f\\Hlo_IF024.mp3",	--	Away from me, you diseased thing.
                "vo\\i\\f\\Hlo_IF025.mp3",	--	I wonder, did those clothes come with the stink of poverty, or did you add that yourself?
                "vo\\i\\f\\Hlo_IF026.mp3",	--	You actually walk around like that?
                "vo\\i\\f\\Hlo_IF027.mp3",	--	Ah...A wolf in cheap clothing!
                "vo\\i\\f\\Hlo_IF028.mp3",	--	Go away.
                "vo\\i\\f\\Hlo_IF029.mp3",	--	Oh please, by all means, ask me lots of questions.
                "vo\\i\\f\\Hlo_IF030.mp3",	--	What?
                "vo\\i\\f\\Hlo_IF031.mp3",	--	What a winning personality.
                "vo\\i\\f\\Hlo_IF032.mp3",	--	What? Why do you disturb me?
                "vo\\i\\f\\Hlo_IF033.mp3",	--	How wonderful. Another tourist.
                "vo\\i\\f\\Hlo_IF034.mp3",	--	Why are you away from your post?
                "vo\\i\\f\\Hlo_IF035.mp3",	--	Get back to work and stop bothering me.
                "vo\\i\\f\\Hlo_IF036.mp3",	--	Let's get this over with quickly.
                "vo\\i\\f\\Hlo_IF037.mp3",	--	I only have a few moments.
                "vo\\i\\f\\Hlo_IF038.mp3",	--	What stranger?
                "vo\\i\\f\\Hlo_IF039.mp3",	--	Come on. I haven't got all day you know.
                "vo\\i\\f\\Hlo_IF049.mp3",	--	Hmm, you look half dead. Why don't you find someone who can finish the job?
                "vo\\i\\f\\Hlo_IF050.mp3",	--	If I find out who beat you so badly, I think I'll buy them a drink.
                "vo\\i\\f\\Hlo_IF051.mp3",	--	That's disgusting, I think you should leave before I lose my lunch.
                "vo\\i\\f\\Hlo_IF052.mp3",	--	You've got to be kidding. Everyone knows you're nothing but trouble.
                "vo\\i\\f\\Hlo_IF053.mp3",	--	I see you favor a little crime. Hmm. Perhaps I should let the authorities know.
                "vo\\i\\f\\Hlo_IF054.mp3",	--	If you can't afford decent clothing, I'm not sure we should be talking.
                "vo\\i\\f\\Hlo_IF056.mp3",	--	Smelly, unkempt, unwashed. I see standards are being lowered everywhere.
                "vo\\i\\f\\Hlo_IF057.mp3",	--	Stay out of trouble, and you won't get hurt.
                "vo\\i\\f\\Hlo_IF058.mp3",	--	Oooh. You're naked. Spare me.
                "vo\\i\\f\\Hlo_IF059.mp3",	--	Alright, I'll listen, but hurry up.
                "vo\\i\\f\\Hlo_IF060.mp3",	--	What's this about?
                "vo\\i\\f\\Hlo_IF061.mp3",	--	Anytime now.
                "vo\\i\\f\\Hlo_IF062.mp3",	--	Let's hear it.
                "vo\\i\\f\\Hlo_IF063.mp3",	--	Go ahead, stranger.
                "vo\\i\\f\\Hlo_IF064.mp3",	--	Yes, friend?
                "vo\\i\\f\\Hlo_IF065.mp3",	--	Hail.
                "vo\\i\\f\\Hlo_IF069.mp3",	--	I'm not sure if I should be seen with you.
                "vo\\i\\f\\Hlo_IF070.mp3",	--	Don't try anything funny.
                "vo\\i\\f\\Hlo_IF071.mp3",	--	Watch your step.
                "vo\\i\\f\\Hlo_IF072.mp3",	--	You could be arrested for that. Put some clothes on.
                "vo\\i\\f\\Hlo_IF073.mp3",	--	I don't know about you, but I've had about enough of this awful blight.
                "vo\\i\\f\\Hlo_IF074.mp3",	--	It's best to head for shelter in these storms.
                "vo\\i\\f\\Hlo_IF075.mp3",	--	What brings you out in this mess?
                "vo\\i\\f\\Hlo_IF076.mp3",	--	I wish this rain would stop.
                "vo\\i\\f\\Hlo_IF077.mp3",	--	We could use a little rain, don't you think?
                "vo\\i\\f\\Hlo_IF078.mp3",	--	Almost didn't see you in all this.
                "vo\\i\\f\\Hlo_IF079.mp3",	--	Think it'll rain?
                "vo\\i\\f\\Hlo_IF080.mp3",	--	Good morning.
                "vo\\i\\f\\Hlo_IF081.mp3",	--	Good afternoon.
                "vo\\i\\f\\Hlo_IF082.mp3",	--	Good evening.
                "vo\\i\\f\\Hlo_IF083.mp3",	--	A pleasant afternoon to you, citizen.
                "vo\\i\\f\\Hlo_IF084.mp3",	--	A pleasant evening to you, citizen.
                "vo\\i\\f\\Hlo_IF085.mp3",	--	A pleasant day to you, citizen.
                "vo\\i\\f\\Hlo_IF086.mp3",	--	Hope this weather lasts.
                "vo\\i\\f\\Hlo_IF087.mp3",	--	I'm listening.
                "vo\\i\\f\\Hlo_IF088.mp3",	--	Yes?
                "vo\\i\\f\\Hlo_IF089.mp3",	--	Speak freely, friend.
                "vo\\i\\f\\Hlo_IF090.mp3",	--	You want something?
                "vo\\i\\f\\Hlo_IF100.mp3",	--	Move along.
                "vo\\i\\f\\Hlo_IF101.mp3",	--	Hello, citizen.
                "vo\\i\\f\\Hlo_IF102.mp3",	--	I really think you should go somewhere else. That doesn't look pleasant.
                "vo\\i\\f\\Hlo_IF103.mp3",	--	That's some outfit, you have there. Really.
                "vo\\i\\f\\Hlo_IF104.mp3",	--	Are you a herder, or am I mistaken?
                "vo\\i\\f\\Hlo_IF105.mp3",	--	Dressed for a jump in the mud, I see.
                "vo\\i\\f\\Hlo_IF106.mp3",	--	At ease.
                "vo\\i\\f\\Hlo_IF107.mp3",	--	This is truly an honor.
                "vo\\i\\f\\Hlo_IF109.mp3",	--	How dare you show your face.
                "vo\\i\\f\\Hlo_IF110.mp3",	--	Your bidding, Agent?
                "vo\\i\\f\\Hlo_IF111.mp3",	--	Your bidding, Trooper?
                "vo\\i\\f\\Hlo_IF113.mp3",	--	Your bidding, Knight?
                "vo\\i\\f\\Hlo_IF115.mp3",	--	What is this regarding?
                "vo\\i\\f\\Hlo_IF116.mp3",	--	Keep moving.
                "vo\\i\\f\\Hlo_IF117.mp3",	--	How can I help you?
                "vo\\i\\f\\Hlo_IF118.mp3",	--	Go ahead.
                "vo\\i\\f\\Hlo_IF119.mp3",	--	Greetings.
                "vo\\i\\f\\Hlo_IF120.mp3",	--	Do you want something from me?
                "vo\\i\\f\\Hlo_IF121.mp3",	--	Ah, a visitor. What may I do for you?
                "vo\\i\\f\\Hlo_IF122.mp3",	--	What say you?
                "vo\\i\\f\\Hlo_IF124.mp3",	--	Looks like you've had a run-in with some trouble. You should find some healing, friend.
                "vo\\i\\f\\Hlo_IF125.mp3",	--	Your wounds seem quite serious. You should find healing, friend.
                "vo\\i\\f\\Hlo_IF126.mp3",	--	I've heard of your crimes. You should watch your step.
                "vo\\i\\f\\Hlo_IF127.mp3",	--	Just keep your hands of my purse, I know what you're up to.
                "vo\\i\\f\\Hlo_IF128.mp3",	--	Stay out of trouble and you'll have none from me.
                "vo\\i\\f\\Hlo_IF129.mp3",	--	You really should put something on.
                "vo\\i\\f\\Hlo_IF130.mp3",	--	Ah, greetings. What shall we talk about?
                "vo\\i\\f\\Hlo_IF131.mp3",	--	Well, hello there, a pleasure to meet you.
                "vo\\i\\f\\Hlo_IF132.mp3",	--	Well met. What is it?
                "vo\\i\\f\\Hlo_IF133.mp3",	--	Please, by all means. I'm listening.
                "vo\\i\\f\\Hlo_IF143.mp3",	--	Please. I don't wish to catch whatever you have.
                "vo\\i\\f\\Hlo_IF144.mp3",	--	Can't you find more suitable clothes before venturing out?
                "vo\\i\\f\\Hlo_IF144.mp3",	--	Can't you find more suitable clothes before venturing out?
                "vo\\i\\f\\Hlo_IF145.mp3",	--	I see someone has been raiding the rubbish piles for something to wear.
                "vo\\i\\f\\Hlo_IF146.mp3",	--	Tidings, citizen.
                "vo\\i\\f\\Hlo_IF147.mp3",	--	I'm all yours, please go ahead.
                "vo\\i\\f\\Hlo_IF148.mp3",	--	I see I stand in good company. What can I do for you?
                "vo\\i\\f\\Hlo_IF149.mp3",	--	If I can be of any assistance, I'll be happy to help.
                "vo\\i\\f\\Hlo_IF150.mp3",	--	If you care to talk, I would consider it a privilege.
                "vo\\i\\f\\Hlo_IF151.mp3",	--	Hello there! How are you?
                "vo\\i\\f\\Hlo_IF152.mp3",	--	Well met.
                "vo\\i\\f\\Hlo_IF153.mp3",	--	Greetings to you. A pleasure to meet you.
                "vo\\i\\f\\Hlo_IF154.mp3",	--	Greetings, greetings! Oh, I see you're wounded. How sad.
                "vo\\i\\f\\Hlo_IF155.mp3",	--	I see you taken your share of abuse in these lands.
                "vo\\i\\f\\Hlo_IF157.mp3",	--	It's hard to believe that one can be so notorious and charming at the same time.
                "vo\\i\\f\\Hlo_IF158.mp3",	--	A nudist! How wonderful! You seem to be a lively spirit!
                "vo\\i\\f\\Hlo_IF158a.mp3",	--	Let's set aside our rivalries, and talk, shall we?
                "vo\\i\\f\\Hlo_IF160.mp3",	--	You seem like very good company.
                "vo\\i\\f\\Hlo_IF161.mp3",	--	With pleasure, please, go ahead. I'm all ears.
                "vo\\i\\f\\Hlo_IF162.mp3",	--	I'd be happy to talk. My pleasure, really.
                "vo\\i\\f\\Hlo_IF172.mp3",	--	The pleasure is mine. What may I do for you?
                "vo\\i\\f\\Hlo_IF172a.mp3",	--	Welcome, Argonian, let's set aside our differences and talk, shall we?
                "vo\\i\\f\\Hlo_IF173.mp3",	--	You're virtually oozing contagion and yet I feel we must talk. So talk we shall.
                "vo\\i\\f\\Idl_IF001.mp3",	--	What was that?
                "vo\\i\\f\\Idl_IF001.mp3",	--	What was that?
                "vo\\i\\f\\Idl_IF002.mp3",	--	I don't know if I like this.
                "vo\\i\\f\\Idl_IF002.mp3",	--	I don't know if I like this.
                "vo\\i\\f\\Idl_IF003.mp3",	--	That was the strangest book I've ever read.
                "vo\\i\\f\\Idl_IF003.mp3",	--	That was the strangest book I've ever read.
                "vo\\i\\f\\Idl_IF004.mp3",	--	Whistle.
                "vo\\i\\f\\Idl_IF004.mp3",	--	Whistle.
                "vo\\i\\f\\Idl_IF005.mp3",	--	Sniff.
                "vo\\i\\f\\Idl_IF005.mp3",	--	Sniff.
                "vo\\i\\f\\Idl_IF006.mp3",	--	Cough.
                "vo\\i\\f\\Idl_IF006.mp3",	--	Cough.
                "vo\\i\\f\\Idl_IF007.mp3",	--	Clearing throat.
                "vo\\i\\f\\Idl_IF007.mp3",	--	Clearing throat.
                "vo\\i\\f\\Idl_IF008.mp3",	--	Humming.
                "vo\\i\\f\\Idl_IF008.mp3",	--	Humming.
                "vo\\i\\f\\Idl_IF009.mp3",	--	Strange.
                "vo\\i\\f\\Idl_IF009.mp3",	--	Strange.
                "vo\\i\\f\\tHlo_IF001.mp3",	--	What's good for the Empire is good for business, citizen.
                "vo\\i\\f\\tHlo_IF002.mp3",	--	In the front lines on the war against crime...
                "vo\\i\\f\\tHlo_IF003.mp3",	--	Crime doesn't pay.
                "vo\\i\\f\\tHlo_IF004.mp3",	--	For King and Emperor.
                "vo\\i\\f\\tHlo_IF005.mp3",	--	You do me great honor, Primate.
                "vo\\i\\f\\tHlo_IF006.mp3",	--	How may I serve you, Theurgist?
                "vo\\i\\f\\tHlo_IF007.mp3",	--	It is an honor, Invoker.
                "vo\\i\\f\\tHlo_IF008.mp3",	--	Make faith your guide, Oracle.
                "vo\\i\\f\\tHlo_IF009.mp3",	--	Our hospitality is yours, Disciple.
                "vo\\i\\f\\tHlo_IF010.mp3",	--	Good day, Adept of the Imperial cult.
                "vo\\i\\f\\tHlo_IF011.mp3",	--	The Nine grant you wisdom, Acolyte.
                "vo\\i\\f\\tHlo_IF012.mp3",	--	Blessings of the Nine, Initiate.
                "vo\\i\\f\\tHlo_IF013.mp3",	--	Welcome, Novice. May your blessings increase.
                "vo\\i\\f\\tHlo_IF014.mp3",	--	Greetings, Layman. How may I help you?
                "vo\\i\\f\\tHlo_IF015.mp3",	--	Knight of the Imperial Dragon, how may I serve you?
                "vo\\i\\f\\tHlo_IF016.mp3",	--	Grandmaster of House Hlaalu, how may I serve you?
                "vo\\i\\f\\tHlo_IF017.mp3",	--	Archmagister of House Telvanni, how may I serve you?
                "vo\\i\\f\\tHlo_IF018.mp3",	--	Archmaster of Redoran, how may I serve you?
                "vo\\i\\f\\tHlo_IF019.mp3",	--	Knight of the Garland, how may I serve you?
                "vo\\i\\f\\tHlo_IF020.mp3",	--	Councilman of House Hlaalu, how may I serve you?
                "vo\\i\\f\\tHlo_IF021.mp3",	--	Magister of House Telvanni, how may I serve you?
                "vo\\i\\f\\tHlo_IF022.mp3",	--	Councilman of Redoran, how may I serve you?
                "vo\\i\\f\\tHlo_IF023.mp3",	--	Knight Protector, how may I serve you?
                "vo\\i\\f\\tHlo_IF024.mp3",	--	House Father of House Hlaalu, how may I serve you?
                "vo\\i\\f\\tHlo_IF025.mp3",	--	Master of House Telvanni, how may I serve you?
                "vo\\i\\f\\tHlo_IF026.mp3",	--	House Father of Redoran, how may I serve you?
                "vo\\i\\f\\tHlo_IF027.mp3",	--	Knight Bachelor, how may I serve you?
                "vo\\i\\f\\tHlo_IF028.mp3",	--	House Brother of House Hlaalu, how may I serve you?
                "vo\\i\\f\\tHlo_IF029.mp3",	--	Wizard of House Telvanni, how may I serve you?
                "vo\\i\\f\\tHlo_IF030.mp3",	--	House Brother of Redoran, how may I serve you?
                "vo\\i\\f\\tHlo_IF031.mp3",	--	Knight Errant, how may I serve you?
                "vo\\i\\f\\tHlo_IF032.mp3",	--	House Cousin of House Hlaalu, how may I serve you?
                "vo\\i\\f\\tHlo_IF033.mp3",	--	Spellwright of House Telvanni, how may I serve you?
                "vo\\i\\f\\tHlo_IF034.mp3",	--	House Cousin of Redoran, how may I serve you?
                "vo\\i\\f\\tHlo_IF035.mp3",	--	Champion and Legionary. How can I do for you?
                "vo\\i\\f\\tHlo_IF036.mp3",	--	Kinsman of House Hlaalu, what can I do for you?
                "vo\\i\\f\\tHlo_IF037.mp3",	--	Mouth of House Telvanni, what can I do for you?
                "vo\\i\\f\\tHlo_IF038.mp3",	--	Kinsman of House Redoran, how may I help you?
                "vo\\i\\f\\tHlo_IF039.mp3",	--	Agent and Legionary. How can I do for you?
                "vo\\i\\f\\tHlo_IF040.mp3",	--	Lawman of House Hlaalu, what can I do for you?
                "vo\\i\\f\\tHlo_IF041.mp3",	--	Lawman of House Telvanni, what can I do for you?
                "vo\\i\\f\\tHlo_IF042.mp3",	--	Lawman of House Redoran, how may I help you?
                "vo\\i\\f\\tHlo_IF043.mp3",	--	Trooper and Legionary. How can I do for you?
                "vo\\i\\f\\tHlo_IF044.mp3",	--	Oathman of House Hlaalu, what can I do for you?
                "vo\\i\\f\\tHlo_IF045.mp3",	--	Oathman of House Telvanni, what can I do for you?
                "vo\\i\\f\\tHlo_IF046.mp3",	--	Oathman of House Redoran, how may I help you?
                "vo\\i\\f\\tHlo_IF047.mp3",	--	Spearman and Legionary. How can I do for you?
                "vo\\i\\f\\tHlo_IF048.mp3",	--	Retainer of House Hlaalu, what can I do for you?
                "vo\\i\\f\\tHlo_IF049.mp3",	--	Retainer of House Telvanni, what can I do for you?
                "vo\\i\\f\\tHlo_IF050.mp3",	--	Retainer of House Redoran, how may I help you?
                "vo\\i\\f\\tHlo_IF051.mp3",	--	Recruit and Legionary. How can I do for you?
                "vo\\i\\f\\tHlo_IF052.mp3",	--	Hireling of House Hlaalu, what can I do for you?
                "vo\\i\\f\\tHlo_IF053.mp3",	--	Hireling of House Telvanni, what can I do for you?
                "vo\\i\\f\\tHlo_IF054.mp3",	--	Hireling of House Redoran, how may I help you?
                "vo\\i\\f\\tHlo_IF055.mp3",	--	Guild Arch-Mage, how may we serve you?
                "vo\\i\\f\\tHlo_IF056.mp3",	--	Master Wizard of the Guild, I greet you.
                "vo\\i\\f\\tHlo_IF057.mp3",	--	Honor to you, Wizard of the Guild.
                "vo\\i\\f\\tHlo_IF058.mp3",	--	You are a Warlock of the Guild, I see.
                "vo\\i\\f\\tHlo_IF059.mp3",	--	I welcome a Magician of the Guild.
                "vo\\i\\f\\tHlo_IF060.mp3",	--	A Mages Guild Conjurer, I see. Welcome.
                "vo\\i\\f\\tHlo_IF061.mp3",	--	A Mages Guild Evoker, I see. Welcome.
                "vo\\i\\f\\tHlo_IF062.mp3",	--	A Mages Guild Journeyman, I see. Welcome.
                "vo\\i\\f\\tHlo_IF063.mp3",	--	A Mages Guild Apprentice, I see. Welcome.
                "vo\\i\\f\\tHlo_IF064.mp3",	--	A Mages Guild Associate, I see. Welcome.
                "vo\\i\\f\\tHlo_IF065.mp3",	--	Master Thief of the Guild, how may we serve?
                "vo\\i\\f\\tHlo_IF066.mp3",	--	Greetings, Mastermind. The Guild is honored.
                "vo\\i\\f\\tHlo_IF067.mp3",	--	The Guild recognizes a Ringleader.
                "vo\\i\\f\\tHlo_IF068.mp3",	--	The Guild recognizes a Captain.
                "vo\\i\\f\\tHlo_IF069.mp3",	--	The Guild recognizes a Bandit.
                "vo\\i\\f\\tHlo_IF070.mp3",	--	Luck and loot for us all, Operative.
                "vo\\i\\f\\tHlo_IF071.mp3",	--	Luck and loot for us all, Blackcap.
                "vo\\i\\f\\tHlo_IF072.mp3",	--	Luck and loot for us all, Footpad.
                "vo\\i\\f\\tHlo_IF073.mp3",	--	Luck and loot for us all, Wet Ear.
                "vo\\i\\f\\tHlo_IF074.mp3",	--	Luck and loot for us all, Toad.
                "vo\\i\\f\\tHlo_IF085.mp3",	--	I'm not busy now. What do you need?
                "vo\\i\\f\\tHlo_IF086.mp3",	--	Time to talk? I've a few minutes....
                "vo\\i\\f\\tHlo_IF087.mp3",	--	Happy to help. What's your problem?
                "vo\\i\\f\\tHlo_IF088.mp3",	--	Oh... it's you. Can I help you?
                "vo\\i\\f\\tHlo_IF089.mp3",	--	Whatever you want... within reason.
                "vo\\i\\f\\tHlo_IF090.mp3",	--	If a few words can help, I'd be happy to talk.
                "vo\\i\\f\\tHlo_IF091.mp3",	--	All hail under the Drake, citizen.
                "vo\\i\\f\\tHlo_IF092.mp3",	--	What's good for the Empire is good for business, citizen.
                "vo\\i\\f\\tHlo_IF093.mp3",	--	Good for the Empire, good for all, eh, citizen?
                "vo\\i\\f\\tHlo_IF094.mp3",	--	Yes?
                "vo\\i\\f\\tHlo_IF095.mp3",	--	It's fine with me. Go ahead.
                "vo\\i\\f\\tHlo_IF096.mp3",	--	Go ahead. I'm waiting.
                "vo\\i\\f\\tHlo_IF097.mp3",	--	Excuse me. Did you say something?
                "vo\\i\\f\\tHlo_IF098.mp3",	--	Excuse me. I was just thinking...
                "vo\\i\\f\\tHlo_IF099.mp3",	--	Drake and Dragon, citizen.
                "vo\\i\\f\\tHlo_IF100.mp3",	--	I'm glad I see you well, sera.
                "vo\\i\\f\\tHlo_IF101.mp3",	--	Zenithar's fortune to you.
                "vo\\i\\f\\tHlo_IF102.mp3",	--	Today and tomorrow, good luck.
                "vo\\i\\f\\tHlo_IF103.mp3",	--	How are you today?
                "vo\\i\\f\\tHlo_IF104.mp3",	--	I'm listening.
                "vo\\i\\f\\tHlo_IF105.mp3",	--	What is it now?
                "vo\\i\\f\\tHlo_IF106.mp3",	--	Talk if you're talking.
                "vo\\i\\f\\tHlo_IF107.mp3",	--	Will this take long?
                "vo\\i\\f\\tHlo_IF108.mp3",	--	Talk is cheap.
                "vo\\i\\f\\tHlo_IF109.mp3",	--	Well?
                "vo\\i\\f\\tHlo_IF110.mp3",	--	So? You want something?
                "vo\\i\\f\\tHlo_IF111.mp3",	--	Go on. I can't stop you.
                "vo\\i\\f\\tHlo_IF112.mp3",	--	If you insist...
                "vo\\i\\f\\tIdl_IF001.mp3",	--	How'd that get wet?
                "vo\\i\\f\\tIdl_IF002.mp3",	--	Haven't heard from him in ages.
                "vo\\i\\f\\tIdl_IF003.mp3",	--	You talking to ME?
                "vo\\i\\f\\tIdl_IF004.mp3",	--	Never one around when you need one...
                "vo\\i\\f\\tIdl_IF005.mp3",	--	Now, what was it I was going to do today?
                "vo\\i\\f\\tIdl_IF006.mp3",	--	[Long sigh.] Mother said there'd be days like this.
                "vo\\i\\f\\tIdl_IF007.mp3",	--	[Ughk-ughk.] 'Scuse me. Swallowed a bug.
                "vo\\i\\f\\tIdl_IF008.mp3",	--	That robe makes me look like a house.
                "vo\\i\\f\\tIdl_IF009.mp3",	--	Don't look at me! I didn't do it....
                "vo\\i\\f\\tIdl_IF010.mp3",	--	[Singing to self....] 'Mama's little baby likes scumble, scumble....'
                "vo\\i\\f\\tIdl_IF011.mp3",	--	If it's not one thing, it's another...
                "vo\\i\\f\\tIdl_IF012.mp3",	--	Phew. Did somebody bring a guar in here?
                "vo\\i\\f\\tIdl_IF013.mp3",	--	Damn locals....
            },
        },
        ["m"] = {
            [this.voice.continue] = {
            },
            [this.voice.finish] = {
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
            },
            [this.voice.think] = {
            },
            [this.voice.remind] = {
                "vo\\i\\m\\Atk_IM001.mp3",	--	I've triffled with you long enough.
                "vo\\i\\m\\Atk_IM001.mp3",	--	I've trifled with you long enough.
                "vo\\i\\m\\Atk_IM002.mp3",	--	Ha-Ha!
                "vo\\i\\m\\Atk_IM003.mp3",	--	Take that!
                "vo\\i\\m\\Atk_IM004.mp3",	--	You won't escape me that easily!
                "vo\\i\\m\\Atk_IM005.mp3",	--	I have you!
                "vo\\i\\m\\Atk_IM006.mp3",	--	You're mine!
                "vo\\i\\m\\Atk_IM007.mp3",	--	Let's see what you're made of!
                "vo\\i\\m\\Atk_IM008.mp3",	--	Surrender now and I might let you live!
                "vo\\i\\m\\Atk_IM009.mp3",	--	Die, scoundrel!
                "vo\\i\\m\\Atk_IM010.mp3",	--	You're hardly a match for me!
                "vo\\i\\m\\Atk_IM011.mp3",	--	You make this too easy!
                "vo\\i\\m\\Atk_IM012.mp3",	--	This is pointless, give in!
                "vo\\i\\m\\Atk_IM013.mp3",	--	Come on! Fight!
                "vo\\i\\m\\Atk_IM014.mp3",	--	I will enjoy this!
                "vo\\i\\m\\bAtk_IM001.mp3",	--	Taste my silver, foul beast!
                "vo\\i\\m\\bAtk_IM002.mp3",	--	Kill the beast!
                "vo\\i\\m\\bAtk_IM003.mp3",	--	Hunt it down and kill it!
                "vo\\i\\m\\bAtk_IM004.mp3",	--	Kill the beast!
                "vo\\i\\m\\bAtk_IM005.mp3",	--	Your head will be my new trophy!
                "vo\\i\\m\\bAtk_IM006.mp3",	--	I've got a bone for you. Come and get it!
                "vo\\i\\m\\bAtk_IM007.mp3",	--	I've fought guars more ferocious than you!
                "vo\\i\\m\\bAtk_IM008.mp3",	--	Your cursed bloodline ends here!
                "vo\\i\\m\\bAtk_IM009.mp3",	--	I've got the cure for your curse right here.
                "vo\\i\\m\\bFle_IM001.mp3",	--	Help! A beast!
                "vo\\i\\m\\bFle_IM002.mp3",	--	Get away, beast!
                "vo\\i\\m\\bFle_IM003.mp3",	--	Go away! I don't have any treats!
                "vo\\i\\m\\bFle_IM004.mp3",	--	Don't infect me with your curse!
                "vo\\i\\m\\bHlo_IM001.mp3",	--	Be strong, my friend. You will persevere.
                "vo\\i\\m\\bHlo_IM002.mp3",	--	This place is not of this world. I fear for our lives.
                "vo\\i\\m\\bHlo_IM003.mp3",	--	Have you found more information on the weapons being smuggled from the Fort?
                "vo\\i\\m\\bHlo_IM004.mp3",	--	I asked you to investigate why the morale has been low in the fort. Have you learned anything?
                "vo\\i\\m\\bHlo_IM005.mp3",	--	Yes? What can I do for you? I am Captain Falx Carius, commander of Fort Frostmoth.
                "vo\\i\\m\\bHlo_IM006.mp3",	--	Stuck here. Forever. I'll die.
                "vo\\i\\m\\bHlo_IM007.mp3",	--	Yes? What can this humble priest do for you?
                "vo\\i\\m\\bHlo_IM008.mp3",	--	What is it you want?
                "vo\\i\\m\\bHlo_IM009.mp3",	--	All is well here at Fort Frostmoth.
                "vo\\i\\m\\bHlo_IM010.mp3",	--	We must find Captain Carius. This place will fall to shambles without him.
                "vo\\i\\m\\bHlo_IM011.mp3",	--	Thank the gods you've returned!
                "vo\\i\\m\\bHlo_IM012.mp3",	--	Let us ferret out this ring of smugglers.
                "vo\\i\\m\\bHlo_IM013.mp3",	--	Captain Carius mentioned that you might come to speak with me. How may I assist you?
                "vo\\i\\m\\bHlo_IM014.mp3",	--	I'll be gone soon. I promise you that.
                "vo\\i\\m\\bHlo_IM015.mp3",	--	What is it?
                "vo\\i\\m\\bHlo_IM016.mp3",	--	Hello! Are you here on assignment, or did you just stop by?
                "vo\\i\\m\\bHlo_IM017.mp3",	--	So, Carnius talked you into joining this little venture, did he?
                "vo\\i\\m\\bHlo_IM018.mp3",	--	I'm sorry, but I'm here on official business, and I don't have time to chat.
                "vo\\i\\m\\bHlo_IM019.mp3",	--	I.... I'm taking care of the supplies. Just keep your distance, all right?
                "vo\\i\\m\\bHlo_IM020.mp3",	--	Well now. Have they finally sent someone to deliver the extra payment I requested?
                "vo\\i\\m\\bHlo_IM021.mp3",	--	My lungs must be as black as these rocks by now.
                "vo\\i\\m\\bHlo_IM022.mp3",	--	Yes? Did you want something?
                "vo\\i\\m\\bHlo_IM023.mp3",	--	Good work with the ebony. Keep it up.
                "vo\\i\\m\\bHlo_IM023a.mp3",	--	I got nothing more to say.
                "vo\\i\\m\\bHlo_IM024.mp3",	--	Hroldar is gone, but we have other problems.
                "vo\\i\\m\\bHlo_IM025.mp3",	--	Too bad about the ship. Not your fault, though.
                "vo\\i\\m\\bHlo_IM026.mp3",	--	Decisions are good. But good decisions are better.
                "vo\\i\\m\\bHlo_IM027.mp3",	--	Okay. The supply ship is fine. What else can go wrong?
                "vo\\i\\m\\bHlo_IM028.mp3",	--	It's always something, isn't it?
                "vo\\i\\m\\bHlo_IM029.mp3",	--	YOU'RE not the problem. You're doing fine... thank the Gods.
                "vo\\i\\m\\bHlo_IM030.mp3",	--	What next?
                "vo\\i\\m\\bHlo_IM031.mp3",	--	No rest for the weary.
                "vo\\i\\m\\bHlo_IM032.mp3",	--	Between us, we just might pull this off.
                "vo\\i\\m\\bHlo_IM033.mp3",	--	You're a lifesaver.
                "vo\\i\\m\\bHlo_IM034.mp3",	--	Don't know what I'd do without you.
                "vo\\i\\m\\bHlo_IM035.mp3",	--	You're with Carnius now. I'm sorry, but it was your choice.
                "vo\\i\\m\\bHlo_IM036.mp3",	--	About time.
                "vo\\i\\m\\bHlo_IM037.mp3",	--	Who cares about Nord crackpots? We got a lot to do here.
                "vo\\i\\m\\bHlo_IM038.mp3",	--	I can't believe it. Can't anyone do anything right?
                "vo\\i\\m\\bHlo_IM039.mp3",	--	Don't bother me with trivial details. Know what's important, and do it right the first time.
                "vo\\i\\m\\bHlo_IM040.mp3",	--	Better. Just stick with it, and we'll all get rich.
                "vo\\i\\m\\bHlo_IM041.mp3",	--	Time is money. Let's get moving here.
                "vo\\i\\m\\bHlo_IM042.mp3",	--	You scratch my back? I'll scratch yours.
                "vo\\i\\m\\bHlo_IM043.mp3",	--	One hand washes the other.
                "vo\\i\\m\\bHlo_IM044.mp3",	--	We'll show 'em how it's done.
                "vo\\i\\m\\bHlo_IM045.mp3",	--	We'll whip this island into shape, and make it pay.
                "vo\\i\\m\\bHlo_IM046.mp3",	--	The Company does well, we get rich, and everyone is happy.
                "vo\\i\\m\\bHlo_IM047.mp3",	--	What they don't know won't hurt them.
                "vo\\i\\m\\bHlo_IM048.mp3",	--	You chose Falco. Fine. Just leaves more for me.
                "vo\\i\\m\\bHlo_IM049.mp3",	--	We must find our way through this maze.
                "vo\\i\\m\\bHlo_IM050.mp3",	--	I will wait here and defend this gate.
                "vo\\i\\m\\bHlo_IM051.mp3",	--	It is good to see you again, friend.
                "vo\\i\\m\\bHlo_IM052.mp3",	--	I am glad to see you alive!
                "vo\\i\\m\\bIdl_IM001.mp3",	--	After the kicking I gave that weasel, he BETTER mind his manners.
                "vo\\i\\m\\bIdl_IM001.mp3",	--	After the kicking I gave that weasel, he BETTER mind his manners.
                "vo\\i\\m\\bIdl_IM001.mp3",	--	After the kicking I gave that weasel, he BETTER mind his manners.
                "vo\\i\\m\\bIdl_IM001.mp3",	--	After the kicking I gave that weasel, he BETTER mind his manners.
                "vo\\i\\m\\bIdl_IM001.mp3",	--	After the kicking I gave that weasel, he BETTER mind his manners.
                "vo\\i\\m\\bIdl_IM002.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\i\\m\\bIdl_IM002.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\i\\m\\bIdl_IM002.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\i\\m\\bIdl_IM002.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\i\\m\\bIdl_IM002.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\i\\m\\bIdl_IM002.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\i\\m\\bIdl_IM003.mp3",	--	She looks like somebody threw up in the fountain of youth.
                "vo\\i\\m\\bIdl_IM003.mp3",	--	She looks like somebody threw up in the fountain of youth.
                "vo\\i\\m\\bIdl_IM003.mp3",	--	She looks like somebody threw up in the fountain of youth.
                "vo\\i\\m\\bIdl_IM003.mp3",	--	She looks like somebody threw up in the fountain of youth.
                "vo\\i\\m\\bIdl_IM003.mp3",	--	She looks like somebody threw up in the fountain of youth.
                "vo\\i\\m\\bIdl_IM004.mp3",	--	It wasn't my fault. Really. He just fell over. I hardly touched him.
                "vo\\i\\m\\bIdl_IM004.mp3",	--	It wasn't my fault. Really. He just fell over. I hardly touched him.
                "vo\\i\\m\\bIdl_IM004.mp3",	--	It wasn't my fault. Really. He just fell over. I hardly touched him.
                "vo\\i\\m\\bIdl_IM004.mp3",	--	It wasn't my fault. Really. He just fell over. I hardly touched him.
                "vo\\i\\m\\bIdl_IM004.mp3",	--	It wasn't my fault. Really. He just fell over. I hardly touched him.
                "vo\\i\\m\\bIdl_IM005.mp3",	--	It's not all that bad. It's not like I bit him or anything.
                "vo\\i\\m\\bIdl_IM005.mp3",	--	It's not all that bad. It's not like I bit him or anything.
                "vo\\i\\m\\bIdl_IM005.mp3",	--	It's not all that bad. It's not like I bit him or anything.
                "vo\\i\\m\\bIdl_IM005.mp3",	--	It's not all that bad. It's not like I bit him or anything.
                "vo\\i\\m\\bIdl_IM005.mp3",	--	It's not all that bad. It's not like I bit him or anything.
                "vo\\i\\m\\bIdl_IM006.mp3",	--	Want to feel my muscle?
                "vo\\i\\m\\bIdl_IM006.mp3",	--	Want to feel my muscle?
                "vo\\i\\m\\bIdl_IM006.mp3",	--	Want to feel my muscle?
                "vo\\i\\m\\bIdl_IM006.mp3",	--	Want to feel my muscle?
                "vo\\i\\m\\bIdl_IM006.mp3",	--	Want to feel my muscle?
                "vo\\i\\m\\bIdl_IM007.mp3",	--	Good grief. It smells like Grandpa Goat in garlic sauce in here.
                "vo\\i\\m\\bIdl_IM007.mp3",	--	Good grief. It smells like Grandpa Goat in garlic sauce in here.
                "vo\\i\\m\\bIdl_IM007.mp3",	--	Good grief. It smells like Grandpa Goat in garlic sauce in here.
                "vo\\i\\m\\bIdl_IM007.mp3",	--	Good grief. It smells like Grandpa Goat in garlic sauce in here.
                "vo\\i\\m\\bIdl_IM007.mp3",	--	Good grief. It smells like Grandpa Goat in garlic sauce in here.
                "vo\\i\\m\\bIdl_IM008.mp3",	--	I think they were teeth in her mouth, but I'm not sure.
                "vo\\i\\m\\bIdl_IM008.mp3",	--	I think they were teeth in her mouth, but I'm not sure.
                "vo\\i\\m\\bIdl_IM008.mp3",	--	I think they were teeth in her mouth, but I'm not sure.
                "vo\\i\\m\\bIdl_IM008.mp3",	--	I think they were teeth in her mouth, but I'm not sure.
                "vo\\i\\m\\bIdl_IM008.mp3",	--	I think they were teeth in her mouth, but I'm not sure.
                "vo\\i\\m\\bIdl_IM009.mp3",	--	Ummm... pudding!
                "vo\\i\\m\\bIdl_IM009.mp3",	--	Ummm... pudding!
                "vo\\i\\m\\bIdl_IM009.mp3",	--	Ummm... pudding!
                "vo\\i\\m\\bIdl_IM009.mp3",	--	Ummm... pudding!
                "vo\\i\\m\\bIdl_IM010.mp3",	--	Join the Legion. See the world. Freeze your arse.
                "vo\\i\\m\\bIdl_IM010.mp3",	--	Join the Legion. See the world. Freeze your arse.
                "vo\\i\\m\\bIdl_IM010.mp3",	--	Join the Legion. See the world. Freeze your arse.
                "vo\\i\\m\\bIdl_IM010.mp3",	--	Join the Legion. See the world. Freeze your arse.
                "vo\\i\\m\\bIdl_IM010.mp3",	--	Join the Legion. See the world. Freeze your arse.
                "vo\\i\\m\\bIdl_IM011.mp3",	--	Well, if you shaved her palms, she might pass for a monkey.
                "vo\\i\\m\\bIdl_IM011.mp3",	--	Well, if you shaved her palms, she might pass for a monkey.
                "vo\\i\\m\\bIdl_IM011.mp3",	--	Well, if you shaved her palms, she might pass for a monkey.
                "vo\\i\\m\\bIdl_IM011.mp3",	--	Well, if you shaved her palms, she might pass for a monkey.
                "vo\\i\\m\\bIdl_IM011.mp3",	--	Well, if you shaved her palms, she might pass for a monkey.
                "vo\\i\\m\\bIdl_IM012.mp3",	--	Cold, wet, no sun, ugly women. Yeah. This is some paradise all right.
                "vo\\i\\m\\bIdl_IM012.mp3",	--	Cold, wet, no sun, ugly women. Yeah. This is some paradise all right.
                "vo\\i\\m\\bIdl_IM012.mp3",	--	Cold, wet, no sun, ugly women. Yeah. This is some paradise all right.
                "vo\\i\\m\\bIdl_IM012.mp3",	--	Cold, wet, no sun, ugly women. Yeah. This is some paradise all right.
                "vo\\i\\m\\bIdl_IM012.mp3",	--	Cold, wet, no sun, ugly women. Yeah. This is some paradise all right.
                "vo\\i\\m\\bIdl_IM013.mp3",	--	Every day is Saint Plenty's Day in the Legion.
                "vo\\i\\m\\bIdl_IM013.mp3",	--	Every day is Saint Plenty's Day in the Legion.
                "vo\\i\\m\\bIdl_IM013.mp3",	--	Every day is Saint Plenty's Day in the Legion.
                "vo\\i\\m\\bIdl_IM013.mp3",	--	Every day is Saint Plenty's Day in the Legion.
                "vo\\i\\m\\bIdl_IM013.mp3",	--	Every day is Saint Plenty's Day in the Legion.
                "vo\\i\\m\\bIdl_IM014.mp3",	--	Got any idea how these alembic thingies work?
                "vo\\i\\m\\bIdl_IM014.mp3",	--	Got any idea how these alembic thingies work?
                "vo\\i\\m\\bIdl_IM014.mp3",	--	Got any idea how these alembic thingies work?
                "vo\\i\\m\\bIdl_IM014.mp3",	--	Got any idea how these alembic thingies work?
                "vo\\i\\m\\bIdl_IM014.mp3",	--	Got any idea how these alembic thingies work?
                "vo\\i\\m\\bIdl_IM015.mp3",	--	Couple strips of horker hide and it'll be good as new.
                "vo\\i\\m\\bIdl_IM015.mp3",	--	Couple strips of horker hide and it'll be good as new.
                "vo\\i\\m\\bIdl_IM015.mp3",	--	Couple strips of horker hide and it'll be good as new.
                "vo\\i\\m\\bIdl_IM015.mp3",	--	Couple strips of horker hide and it'll be good as new.
                "vo\\i\\m\\bIdl_IM015.mp3",	--	Couple strips of horker hide and it'll be good as new.
                "vo\\i\\m\\bIdl_IM017.mp3",	--	Oh, not AGAIN!
                "vo\\i\\m\\bIdl_IM017.mp3",	--	Oh, not AGAIN!
                "vo\\i\\m\\bIdl_IM017.mp3",	--	Oh, not AGAIN!
                "vo\\i\\m\\bIdl_IM017.mp3",	--	Oh, not AGAIN!
                "vo\\i\\m\\bIdl_IM017.mp3",	--	Oh, not AGAIN!
                "vo\\i\\m\\bIdl_IM018.mp3",	--	[Wide yawn.]
                "vo\\i\\m\\bIdl_IM018.mp3",	--	[Wide yawn.]
                "vo\\i\\m\\bIdl_IM018.mp3",	--	[Wide yawn.]
                "vo\\i\\m\\bIdl_IM018.mp3",	--	[Wide yawn.]
                "vo\\i\\m\\bIdl_IM018.mp3",	--	[Wide yawn.]
                "vo\\i\\m\\bIdl_IM019.mp3",	--	If it's not one thing, it's another.
                "vo\\i\\m\\bIdl_IM019.mp3",	--	If it's not one thing, it's another.
                "vo\\i\\m\\bIdl_IM020.mp3",	--	Well, it couldn't get worse... Could it?
                "vo\\i\\m\\bIdl_IM020.mp3",	--	Well, it couldn't get worse... Could it?
                "vo\\i\\m\\bIdl_IM021.mp3",	--	Once more, with feeling...
                "vo\\i\\m\\bIdl_IM021.mp3",	--	Once more, with feeling...
                "vo\\i\\m\\bIdl_IM022.mp3",	--	Without me, it all falls to pieces.
                "vo\\i\\m\\bIdl_IM022.mp3",	--	Without me, it all falls to pieces.
                "vo\\i\\m\\bIdl_IM023.mp3",	--	Ah, well. Duty calls.
                "vo\\i\\m\\bIdl_IM023.mp3",	--	Ah, well. Duty calls.
                "vo\\i\\m\\bIdl_IM024.mp3",	--	Just another of life's little disappointments...
                "vo\\i\\m\\bIdl_IM024.mp3",	--	Just another of life's little disappointments...
                "vo\\i\\m\\bIdl_IM025.mp3",	--	Uh-huh.
                "vo\\i\\m\\bIdl_IM025.mp3",	--	Uh-huh.
                "vo\\i\\m\\bIdl_IM025.mp3",	--	Uh-huh.
                "vo\\i\\m\\bIdl_IM025.mp3",	--	Uh-huh.
                "vo\\i\\m\\bIdl_IM026.mp3",	--	Right.
                "vo\\i\\m\\bIdl_IM026.mp3",	--	Right.
                "vo\\i\\m\\bIdl_IM026.mp3",	--	Right.
                "vo\\i\\m\\bIdl_IM026.mp3",	--	Right.
                "vo\\i\\m\\bIdl_IM027.mp3",	--	No point worrying about it.
                "vo\\i\\m\\bIdl_IM027.mp3",	--	No point worrying about it.
                "vo\\i\\m\\bIdl_IM027.mp3",	--	No point worrying about it.
                "vo\\i\\m\\bIdl_IM027.mp3",	--	No point worrying about it.
                "vo\\i\\m\\bIdl_IM028.mp3",	--	Just as well...
                "vo\\i\\m\\bIdl_IM028.mp3",	--	Just as well...
                "vo\\i\\m\\bIdl_IM028.mp3",	--	Just as well...
                "vo\\i\\m\\bIdl_IM028.mp3",	--	Just as well...
                "vo\\i\\m\\bIdl_IM029.mp3",	--	Could be worse. Probably will be.
                "vo\\i\\m\\bIdl_IM029.mp3",	--	Could be worse. Probably will be.
                "vo\\i\\m\\bIdl_IM029.mp3",	--	Could be worse. Probably will be.
                "vo\\i\\m\\bIdl_IM029.mp3",	--	Could be worse. Probably will be.
                "vo\\i\\m\\bIdl_IM030.mp3",	--	Wonder what HE'S up to.
                "vo\\i\\m\\bIdl_IM030.mp3",	--	Wonder what HE'S up to.
                "vo\\i\\m\\bIdl_IM030.mp3",	--	Wonder what HE'S up to.
                "vo\\i\\m\\bIdl_IM030.mp3",	--	Wonder what HE'S up to.
                "vo\\i\\m\\bIdl_IM031.mp3",	--	Wonder what SHE'S up to.
                "vo\\i\\m\\bIdl_IM031.mp3",	--	Wonder what SHE'S up to.
                "vo\\i\\m\\bIdl_IM031.mp3",	--	Wonder what SHE'S up to.
                "vo\\i\\m\\bIdl_IM031.mp3",	--	Wonder what SHE'S up to.
                "vo\\i\\m\\bIdl_IM032.mp3",	--	What a life.
                "vo\\i\\m\\bIdl_IM032.mp3",	--	What a life.
                "vo\\i\\m\\bIdl_IM032.mp3",	--	What a life.
                "vo\\i\\m\\bIdl_IM032.mp3",	--	What a life.
                "vo\\i\\m\\bIdl_IM033.mp3",	--	It's hard, but it's fair.
                "vo\\i\\m\\bIdl_IM033.mp3",	--	It's hard, but it's fair.
                "vo\\i\\m\\bIdl_IM033.mp3",	--	It's hard, but it's fair.
                "vo\\i\\m\\bIdl_IM033.mp3",	--	It's hard, but it's fair.
                "vo\\i\\m\\bIdl_IM034.mp3",	--	Oh, brother... not again....
                "vo\\i\\m\\bIdl_IM034.mp3",	--	Oh, brother... not again....
                "vo\\i\\m\\bIdl_IM034.mp3",	--	Oh, brother... not again....
                "vo\\i\\m\\bIdl_IM034.mp3",	--	Oh, brother... not again....
                "vo\\i\\m\\bIdl_IM035.mp3",	--	I'm still in pretty good shape... right?
                "vo\\i\\m\\bIdl_IM035.mp3",	--	I'm still in pretty good shape... right?
                "vo\\i\\m\\bIdl_IM035.mp3",	--	I'm still in pretty good shape... right?
                "vo\\i\\m\\bIdl_IM035.mp3",	--	I'm still in pretty good shape... right?
                "vo\\i\\m\\bIdl_IM036.mp3",	--	I took care of it... Didn't I?
                "vo\\i\\m\\bIdl_IM036.mp3",	--	I took care of it... Didn't I?
                "vo\\i\\m\\bIdl_IM036.mp3",	--	I took care of it... Didn't I?
                "vo\\i\\m\\bIdl_IM036.mp3",	--	I took care of it... Didn't I?
                "vo\\i\\m\\bIdl_IM037.mp3",	--	Look, don't tell me about YOUR problems....
                "vo\\i\\m\\bIdl_IM037.mp3",	--	Look, don't tell me about YOUR problems....
                "vo\\i\\m\\bIdl_IM037.mp3",	--	Look, don't tell me about YOUR problems....
                "vo\\i\\m\\bIdl_IM037.mp3",	--	Look, don't tell me about YOUR problems....
                "vo\\i\\m\\bIdl_IM038.mp3",	--	This is an evil place.
                "vo\\i\\m\\bIdl_IM039.mp3",	--	What foul magic is at work here?
                "vo\\i\\m\\bIdl_IM040.mp3",	--	I feel somehow changed by these events.
                "vo\\i\\m\\bIdl_IM041.mp3",	--	The fort will be rebuilt.
                "vo\\i\\m\\CrAtk_IM001.mp3",	--	Hurrgh!
                "vo\\i\\m\\CrAtk_IM002.mp3",	--	Hurrargh!
                "vo\\i\\m\\CrAtk_IM003.mp3",	--	Urrragh!
                "vo\\i\\m\\CrAtk_IM004.mp3",	--	Ha!
                "vo\\i\\m\\CrAtk_IM005.mp3",	--	Die!
                "vo\\i\\m\\Fle_IM001.mp3",	--	Run away!
                "vo\\i\\m\\Fle_IM002.mp3",	--	I'm getting out of here!
                "vo\\i\\m\\Fle_IM003.mp3",	--	No!
                "vo\\i\\m\\Fle_IM004.mp3",	--	Help, guards!
                "vo\\i\\m\\Flw_IM002.mp3",	--	Careful with that friend!
                "vo\\i\\m\\Hit_IM001.mp3",	--	Uggh
                "vo\\i\\m\\Hit_IM002.mp3",	--	Wuggh
                "vo\\i\\m\\Hit_IM003.mp3",	--	Hungh!
                "vo\\i\\m\\Hit_IM003.mp3",	--	Hooah.
                "vo\\i\\m\\Hit_IM004.mp3",	--	Huhhah.
                "vo\\i\\m\\Hit_IM005.mp3",	--	Hughah.
                "vo\\i\\m\\Hit_IM006.mp3",	--	Arrgh!
                "vo\\i\\m\\Hit_IM006.mp3",	--	Hughahh.
                "vo\\i\\m\\Hit_IM007.mp3",	--	Ungh!
                "vo\\i\\m\\Hit_IM007.mp3",	--	Hugharrr.
                "vo\\i\\m\\Hit_IM008.mp3",	--	Ugharrrh.
                "vo\\i\\m\\Hit_IM009.mp3",	--	Humphf.
                "vo\\i\\m\\Hit_IM010.mp3",	--	Umphf.
                "vo\\i\\m\\Hlo_IM000a.mp3",	--	What?!
                "vo\\i\\m\\Hlo_IM000b.mp3",	--	Humphf.
                "vo\\i\\m\\Hlo_IM000c.mp3",	--	Humph.
                "vo\\i\\m\\Hlo_IM000d.mp3",	--	You're about to find more trouble than you can possibly imagine.
                "vo\\i\\m\\Hlo_IM000e.mp3",	--	Get out of here!
                "vo\\i\\m\\Hlo_IM000e.mp3",	--	Get out of here.
                "vo\\i\\m\\Hlo_IM002.mp3",	--	Looks like you've already got some of what you have coming to you.
                "vo\\i\\m\\Hlo_IM003.mp3",	--	You don't look so good. Well done!
                "vo\\i\\m\\Hlo_IM004.mp3",	--	Since you're already on death's door, may I open it for you?
                "vo\\i\\m\\Hlo_IM005.mp3",	--	Vile criminal! Get away from me!
                "vo\\i\\m\\Hlo_IM006.mp3",	--	What a pathetic excuse for a criminal!
                "vo\\i\\m\\Hlo_IM007.mp3",	--	Are you here to start trouble, or are you just stupid?
                "vo\\i\\m\\Hlo_IM008.mp3",	--	Someone with your good looks needs more clothing.
                "vo\\i\\m\\Hlo_IM009.mp3",	--	Go away. I don't want to help you.
                "vo\\i\\m\\Hlo_IM010.mp3",	--	I don't think so.
                "vo\\i\\m\\Hlo_IM011.mp3",	--	So tiresome.
                "vo\\i\\m\\Hlo_IM012.mp3",	--	Don't bother me.
                "vo\\i\\m\\Hlo_IM013.mp3",	--	Stay away, vile creature!
                "vo\\i\\m\\Hlo_IM014.mp3",	--	I'm not hiring for cutthroats, Redguard, so go away.
                "vo\\i\\m\\Hlo_IM015.mp3",	--	I haven't anything to eat or smash, so go away.
                "vo\\i\\m\\Hlo_IM016.mp3",	--	Take your drunken war stories elsewhere, braggart.
                "vo\\i\\m\\Hlo_IM017.mp3",	--	Who let you off your leash?
                "vo\\i\\m\\Hlo_IM023.mp3",	--	Does your owner know where you are?
                "vo\\i\\m\\Hlo_IM024.mp3",	--	Away from me, you diseased thing!
                "vo\\i\\m\\Hlo_IM025.mp3",	--	I wonder, did those clothes come with the stink of poverty, or did you add that yourself?
                "vo\\i\\m\\Hlo_IM026.mp3",	--	Ah... A wolf in cheap clothing!
                "vo\\i\\m\\Hlo_IM028.mp3",	--	Go away.
                "vo\\i\\m\\Hlo_IM029.mp3",	--	Oh please, by all means, ask me lots of questions.
                "vo\\i\\m\\Hlo_IM030.mp3",	--	What?
                "vo\\i\\m\\Hlo_IM031.mp3",	--	What a winning personality.
                "vo\\i\\m\\Hlo_IM032.mp3",	--	What? Why do you disturb me?
                "vo\\i\\m\\Hlo_IM033.mp3",	--	How wonderful. Another tourist.
                "vo\\i\\m\\Hlo_IM034.mp3",	--	Why are you away from your post?
                "vo\\i\\m\\Hlo_IM035.mp3",	--	Get back to work and stop bothering me.
                "vo\\i\\m\\Hlo_IM036.mp3",	--	Let's get this over with quickly.
                "vo\\i\\m\\Hlo_IM037.mp3",	--	I only have a few moments.
                "vo\\i\\m\\Hlo_IM038.mp3",	--	What, stranger?
                "vo\\i\\m\\Hlo_IM039.mp3",	--	Come on. I haven't got all day you know.
                "vo\\i\\m\\Hlo_IM049.mp3",	--	Hmm. You look half-dead. Why don't you find someone who can finish the job?
                "vo\\i\\m\\Hlo_IM050.mp3",	--	If I find out who beat you so badly, I think I'll buy them a drink.
                "vo\\i\\m\\Hlo_IM051.mp3",	--	That's disgusting. I think you should leave before I lose my lunch.
                "vo\\i\\m\\Hlo_IM052.mp3",	--	You've got to be kidding. Everyone knows you're nothing but trouble.
                "vo\\i\\m\\Hlo_IM053.mp3",	--	I see you favor a little crime. Hmm, perhaps I should let the authorities know.
                "vo\\i\\m\\Hlo_IM054.mp3",	--	If you can't afford decent clothing, I'm not sure we should be talking.
                "vo\\i\\m\\Hlo_IM055.mp3",	--	I applaud your creativity, but guar blankets aren't for wearing.
                "vo\\i\\m\\Hlo_IM056.mp3",	--	Smelly, unkempt, unwashed. I see standards are lowered every day.
                "vo\\i\\m\\Hlo_IM057.mp3",	--	Stay out of trouble and you won't get hurt.
                "vo\\i\\m\\Hlo_IM058.mp3",	--	Oooh. You're naked. Spare me.
                "vo\\i\\m\\Hlo_IM059.mp3",	--	Alright, I'll listen, but hurry up.
                "vo\\i\\m\\Hlo_IM060.mp3",	--	What's this about?
                "vo\\i\\m\\Hlo_IM061.mp3",	--	Anytime now.
                "vo\\i\\m\\Hlo_IM062.mp3",	--	Let's hear it.
                "vo\\i\\m\\Hlo_IM063.mp3",	--	Go ahead, stranger.
                "vo\\i\\m\\Hlo_IM064.mp3",	--	Yes?
                "vo\\i\\m\\Hlo_IM065.mp3",	--	Hail.
                "vo\\i\\m\\Hlo_IM073.mp3",	--	I don't know about you, but I've had about enough of this awful blight.
                "vo\\i\\m\\Hlo_IM074.mp3",	--	It's best to head for shelter in these storms.
                "vo\\i\\m\\Hlo_IM075.mp3",	--	What brings you out in this mess?
                "vo\\i\\m\\Hlo_IM076.mp3",	--	I wish this rain would stop.
                "vo\\i\\m\\Hlo_IM077.mp3",	--	We could use a little rain, don't you think?
                "vo\\i\\m\\Hlo_IM078.mp3",	--	Almost didn't see you in all this.
                "vo\\i\\m\\Hlo_IM079.mp3",	--	Think it'll rain?
                "vo\\i\\m\\Hlo_IM087.mp3",	--	I'm listening.
                "vo\\i\\m\\Hlo_IM088.mp3",	--	Yes?
                "vo\\i\\m\\Hlo_IM089.mp3",	--	Speak freely, friend.
                "vo\\i\\m\\Hlo_IM090.mp3",	--	You want something, friend?
                "vo\\i\\m\\Hlo_IM109.mp3",	--	How dare you show your face.
                "vo\\i\\m\\Hlo_IM110.mp3",	--	Your bidding, Agent?
                "vo\\i\\m\\Hlo_IM111.mp3",	--	Your bidding, Trooper?
                "vo\\i\\m\\Hlo_IM113.mp3",	--	Your bidding, Knight?
                "vo\\i\\m\\Hlo_IM113.mp3",	--	Your bidding, Knight?
                "vo\\i\\m\\Hlo_IM113.mp3",	--	Your bidding, Knight?
                "vo\\i\\m\\Hlo_IM113.mp3",	--	Your bidding, Knight?
                "vo\\i\\m\\Hlo_IM115.mp3",	--	What is this regarding?
                "vo\\i\\m\\Hlo_IM116.mp3",	--	Keep moving.
                "vo\\i\\m\\Hlo_IM116.mp3",	--	Keep moving.
                "vo\\i\\m\\Hlo_IM117.mp3",	--	How can I help you?
                "vo\\i\\m\\Hlo_IM118.mp3",	--	Go ahead.
                "vo\\i\\m\\Hlo_IM119.mp3",	--	Greetings.
                "vo\\i\\m\\Hlo_IM120.mp3",	--	Do you want something from me?
                "vo\\i\\m\\Hlo_IM121.mp3",	--	Ah, welcome. What may I do for you?
                "vo\\i\\m\\Hlo_IM122.mp3",	--	What say you?
                "vo\\i\\m\\Hlo_IM124.mp3",	--	Looks like you've had a run-in with some trouble. You should find some healing, friend.
                "vo\\i\\m\\Hlo_IM125.mp3",	--	Your wounds seem quite serious. You should find healing, friend.
                "vo\\i\\m\\Hlo_IM126.mp3",	--	I've heard of your crimes. You should watch your step.
                "vo\\i\\m\\Hlo_IM127.mp3",	--	Greetings. Just keep your hands out of my purse, I know what you're up to.
                "vo\\i\\m\\Hlo_IM130.mp3",	--	Ah, greetings. What shall we talk about?
                "vo\\i\\m\\Hlo_IM131.mp3",	--	Well, hello there, a pleasure to meet you.
                "vo\\i\\m\\Hlo_IM132.mp3",	--	Well met.
                "vo\\i\\m\\Hlo_IM133.mp3",	--	Please, by all means. I'm listening.
                "vo\\i\\m\\Hlo_IM142.mp3",	--	Please, I don't wish to catch whatever you have.
                "vo\\i\\m\\Hlo_IM142.mp3",	--	Please, I don't wish to catch whatever you have.
                "vo\\i\\m\\Hlo_IM146.mp3",	--	Tidings, citizen.
                "vo\\i\\m\\Hlo_IM147.mp3",	--	I'm all yours. Please, go ahead.
                "vo\\i\\m\\Hlo_IM148.mp3",	--	I see I stand in good company. What can I do for you?
                "vo\\i\\m\\Hlo_IM149.mp3",	--	If I can be of any assistance, I'll be happy to help.
                "vo\\i\\m\\Hlo_IM150.mp3",	--	If you care to talk, I would consider it a privilege.
                "vo\\i\\m\\Hlo_IM151.mp3",	--	Hello there! How are you?
                "vo\\i\\m\\Hlo_IM152.mp3",	--	Well met.
                "vo\\i\\m\\Hlo_IM153.mp3",	--	Greetings, greetings. Oh, I see you're wounded. How sad.
                "vo\\i\\m\\Hlo_IM154.mp3",	--	A good day and fair travels to you. I see you've taken your share of abuse in these lands.
                "vo\\i\\m\\Hlo_IM156.mp3",	--	It's hard to believe one can be so notorious and charming at the same time.
                "vo\\i\\m\\Hlo_IM157.mp3",	--	Let's set aside our rivalries, and talk, shall we?
                "vo\\i\\m\\Hlo_IM158.mp3",	--	A nudist! How wonderful! You seem to be a lively spirit!
                "vo\\i\\m\\Hlo_IM159.mp3",	--	Greetings to you. A pleasure to meet you.
                "vo\\i\\m\\Hlo_IM160.mp3",	--	You seem like very good company.
                "vo\\i\\m\\Hlo_IM161.mp3",	--	With pleasure, please, go ahead. I'm all ears.
                "vo\\i\\m\\Hlo_IM162.mp3",	--	I'd be happy to talk. My pleasure really.
                "vo\\i\\m\\Hlo_IM172.mp3",	--	The pleasure is mine. What may I do for you?
                "vo\\i\\m\\Hlo_IM175.mp3",	--	Where's your uniform?
                "vo\\i\\m\\Hlo_IM177.mp3",	--	What do you think of Pelagiad?
                "vo\\i\\m\\Hlo_IM178.mp3",	--	What brings you here to Pelagiad?
                "vo\\i\\m\\Hlo_IM179.mp3",	--	Here to see the castle?
                "vo\\i\\m\\Idl_IM001.mp3",	--	Sniff.
                "vo\\i\\m\\Idl_IM001.mp3",	--	Sniff.
                "vo\\i\\m\\Idl_IM001.mp3",	--	Sniff.
                "vo\\i\\m\\Idl_IM001.mp3",	--	Sniff.
                "vo\\i\\m\\Idl_IM002.mp3",	--	Sniff, sniff.
                "vo\\i\\m\\Idl_IM002.mp3",	--	Sniff, sniff.
                "vo\\i\\m\\Idl_IM003.mp3",	--	Now, where did I put that?
                "vo\\i\\m\\Idl_IM003.mp3",	--	Now, where did I put that?
                "vo\\i\\m\\Idl_IM004.mp3",	--	Clears throat.
                "vo\\i\\m\\Idl_IM004.mp3",	--	Clears throat.
                "vo\\i\\m\\Idl_IM005.mp3",	--	Hmmm.
                "vo\\i\\m\\Idl_IM005.mp3",	--	Hmmm.
                "vo\\i\\m\\Idl_IM005.mp3",	--	Hmmm.
                "vo\\i\\m\\Idl_IM006.mp3",	--	Whistles.
                "vo\\i\\m\\Idl_IM006.mp3",	--	Whistles.
                "vo\\i\\m\\Idl_IM008.mp3",	--	What was that?
                "vo\\i\\m\\Idl_IM008.mp3",	--	What was that?
                "vo\\i\\m\\Idl_IM009.mp3",	--	Clears throat.
                "vo\\i\\m\\Idl_IM009.mp3",	--	Clears throat.
                "vo\\i\\m\\Idl_IM009.mp3",	--	Clears throat.
                "vo\\i\\m\\tHlo_IM001.mp3",	--	I'm on duty. But go ahead.
                "vo\\i\\m\\tHlo_IM002.mp3",	--	The King commands....
                "vo\\i\\m\\tHlo_IM003.mp3",	--	Emperor, King, and Justice, citizen.
                "vo\\i\\m\\tHlo_IM004.mp3",	--	Zenithar's fortune to you.
                "vo\\i\\m\\tHlo_IM005.mp3",	--	Welcome to the Robot Arena!
                "vo\\i\\m\\tHlo_IM006.mp3",	--	This is too much excitement for me!
                "vo\\i\\m\\tHlo_IM007.mp3",	--	The Nine and the Empire, citizen...
                "vo\\i\\m\\tHlo_IM008.mp3",	--	The King's health to you, sera.
                "vo\\i\\m\\tHlo_IM009.mp3",	--	Long live the King.
                "vo\\i\\m\\tHlo_IM010.mp3",	--	Good for the Empire, good for all, eh, citizen?
                "vo\\i\\m\\tHlo_IM011.mp3",	--	Good to see you again, friend! I was just doing a little writing.
                "vo\\i\\m\\tHlo_IM013.mp3",	--	These ashstorms do not bode well. What can the goddess be thinking?
                "vo\\i\\m\\tHlo_IM014.mp3",	--	You've returned from the Clockwork City! Perhaps I should write about you sometime....
                "vo\\i\\m\\tHlo_IM015.mp3",	--	Must you? This is SO tiresome....
                "vo\\i\\m\\tHlo_IM016.mp3",	--	Glory and honor, Emperor and Empire
                "vo\\i\\m\\tHlo_IM017.mp3",	--	Serve the Emperor and the Emperor's law.
                "vo\\i\\m\\tHlo_IM018.mp3",	--	For King and Emperor.
                "vo\\i\\m\\tHlo_IM019.mp3",	--	Knight of the Imperial Dragon, how may I serve you?
                "vo\\i\\m\\tHlo_IM020.mp3",	--	Grandmaster of House Hlaalu, how may I serve you?
                "vo\\i\\m\\tHlo_IM021.mp3",	--	Archmagister of House Telvanni, how may I serve you?
                "vo\\i\\m\\tHlo_IM022.mp3",	--	Archmaster of Redoran, how may I serve you?
                "vo\\i\\m\\tHlo_IM023.mp3",	--	Knight of the Garland, how may I serve you?
                "vo\\i\\m\\tHlo_IM024.mp3",	--	Councilman of House Hlaalu, how may I serve you?
                "vo\\i\\m\\tHlo_IM025.mp3",	--	Magister of House Telvanni, how may I serve you?
                "vo\\i\\m\\tHlo_IM026.mp3",	--	Councilman of Redoran, how may I serve you?
                "vo\\i\\m\\tHlo_IM027.mp3",	--	Knight Protector, how may I serve you?
                "vo\\i\\m\\tHlo_IM028.mp3",	--	House Father of House Hlaalu, how may I serve you?
                "vo\\i\\m\\tHlo_IM029.mp3",	--	Master of House Telvanni, how may I serve you?
                "vo\\i\\m\\tHlo_IM030.mp3",	--	House Father of Redoran, how may I serve you?
                "vo\\i\\m\\tHlo_IM031.mp3",	--	Knight Bachelor, how may I serve you?
                "vo\\i\\m\\tHlo_IM032.mp3",	--	House Brother of House Hlaalu, how may I serve you?
                "vo\\i\\m\\tHlo_IM033.mp3",	--	Wizard of House Telvanni, how may I serve you?
                "vo\\i\\m\\tHlo_IM034.mp3",	--	House Brother of Redoran, how may I serve you?
                "vo\\i\\m\\tHlo_IM035.mp3",	--	Knight Errant, how may I serve you?
                "vo\\i\\m\\tHlo_IM036.mp3",	--	House Cousin of House Hlaalu, how may I serve you?
                "vo\\i\\m\\tHlo_IM037.mp3",	--	Spellwright of House Telvanni, how may I serve you?
                "vo\\i\\m\\tHlo_IM038.mp3",	--	House Cousin of Redoran, how may I serve you?
                "vo\\i\\m\\tHlo_IM039.mp3",	--	Champion and Legionary. How can I do for you?
                "vo\\i\\m\\tHlo_IM040.mp3",	--	Kinsman of House Hlaalu, what can I do for you?
                "vo\\i\\m\\tHlo_IM041.mp3",	--	Mouth of House Telvanni, what can I do for you?
                "vo\\i\\m\\tHlo_IM042.mp3",	--	Kinsman of House Redoran, how may I help you?
                "vo\\i\\m\\tHlo_IM043.mp3",	--	Agent and Legionary. How can I do for you?
                "vo\\i\\m\\tHlo_IM044.mp3",	--	Lawman of House Hlaalu, what can I do for you?
                "vo\\i\\m\\tHlo_IM045.mp3",	--	Lawman of House Telvanni, what can I do for you?
                "vo\\i\\m\\tHlo_IM046.mp3",	--	Lawman of House Redoran, how may I help you?
                "vo\\i\\m\\tHlo_IM047.mp3",	--	Trooper and Legionary. How can I do for you?
                "vo\\i\\m\\tHlo_IM048.mp3",	--	Oathman of House Hlaalu, what can I do for you?
                "vo\\i\\m\\tHlo_IM049.mp3",	--	Oathman of House Telvanni, what can I do for you?
                "vo\\i\\m\\tHlo_IM050.mp3",	--	Oathman of House Redoran, how may I help you?
                "vo\\i\\m\\tHlo_IM051.mp3",	--	Spearman and Legionary. How can I do for you?
                "vo\\i\\m\\tHlo_IM052.mp3",	--	Retainer of House Hlaalu, what can I do for you?
                "vo\\i\\m\\tHlo_IM053.mp3",	--	Retainer of House Telvanni, what can I do for you?
                "vo\\i\\m\\tHlo_IM054.mp3",	--	Retainer of House Redoran, how may I help you?
                "vo\\i\\m\\tHlo_IM055.mp3",	--	Recruit and Legionary. How can I do for you?
                "vo\\i\\m\\tHlo_IM056.mp3",	--	Hireling of House Hlaalu, what can I do for you?
                "vo\\i\\m\\tHlo_IM057.mp3",	--	Hireling of House Telvanni, what can I do for you?
                "vo\\i\\m\\tHlo_IM058.mp3",	--	Hireling of House Redoran, how may I help you?
                "vo\\i\\m\\tHlo_IM059.mp3",	--	Grandmaster of the Morag Tong, how may we serve?
                "vo\\i\\m\\tHlo_IM060.mp3",	--	Greetings, Exalted Master. The Morag Tong is honored.
                "vo\\i\\m\\tHlo_IM061.mp3",	--	The Morag Tong recognizes a Master.
                "vo\\i\\m\\tHlo_IM062.mp3",	--	The Morag Tong recognizes a Knower.
                "vo\\i\\m\\tHlo_IM063.mp3",	--	The Morag Tong recognizes a Brother.
                "vo\\i\\m\\tHlo_IM064.mp3",	--	Duty and honor, Thinker of the Morag Tong.
                "vo\\i\\m\\tHlo_IM065.mp3",	--	Duty and honor, White Thrall of the Morag Tong.
                "vo\\i\\m\\tHlo_IM066.mp3",	--	Duty and honor, Thrall of the Morag Tong.
                "vo\\i\\m\\tHlo_IM067.mp3",	--	Duty and honor, Blind Thrall of the Morag Tong.
                "vo\\i\\m\\tHlo_IM068.mp3",	--	Duty and honor, Associate of the Morag Tong.
                "vo\\i\\m\\tHlo_IM069.mp3",	--	Master of the Fighters Guild, how may we serve you?
                "vo\\i\\m\\tHlo_IM070.mp3",	--	Champion of the Fighters Guild, it is an honor.
                "vo\\i\\m\\tHlo_IM071.mp3",	--	Guardian of the Fighters Guild, power and profit to you.
                "vo\\i\\m\\tHlo_IM072.mp3",	--	Warder of the Fighters Guild, power and profit to you.
                "vo\\i\\m\\tHlo_IM073.mp3",	--	Defender of the Fighters Guild, power and profit to you.
                "vo\\i\\m\\tHlo_IM074.mp3",	--	Protector, how can I help you?
                "vo\\i\\m\\tHlo_IM075.mp3",	--	Swordsman, how can I help you?
                "vo\\i\\m\\tHlo_IM076.mp3",	--	Journeyman, how can I help you?
                "vo\\i\\m\\tHlo_IM077.mp3",	--	Apprentice, how can I help you?
                "vo\\i\\m\\tHlo_IM078.mp3",	--	Associate, how can I help you?
                "vo\\i\\m\\tHlo_IM089.mp3",	--	I'm not busy now. What do you need?
                "vo\\i\\m\\tHlo_IM090.mp3",	--	Time to talk? I've a few minutes....
                "vo\\i\\m\\tHlo_IM091.mp3",	--	Happy to help. What's your problem?
                "vo\\i\\m\\tHlo_IM092.mp3",	--	Oh... it's you. Can I help you?
                "vo\\i\\m\\tHlo_IM093.mp3",	--	Whatever you want... within reason.
                "vo\\i\\m\\tHlo_IM094.mp3",	--	If a few words can help, I'd be happy to talk.
                "vo\\i\\m\\tHlo_IM095.mp3",	--	The Nine and the Empire, citizen...
                "vo\\i\\m\\tHlo_IM096.mp3",	--	The King's health to you, sera.
                "vo\\i\\m\\tHlo_IM097.mp3",	--	Long live the King.
                "vo\\i\\m\\tHlo_IM098.mp3",	--	Yes?
                "vo\\i\\m\\tHlo_IM099.mp3",	--	It's fine with me. Go ahead.
                "vo\\i\\m\\tHlo_IM100.mp3",	--	Go ahead. I'm waiting.
                "vo\\i\\m\\tHlo_IM101.mp3",	--	Excuse me. Did you say something?
                "vo\\i\\m\\tHlo_IM102.mp3",	--	Excuse me. I was just thinking...
                "vo\\i\\m\\tHlo_IM103.mp3",	--	Peace of the Nine to you.
                "vo\\i\\m\\tHlo_IM104.mp3",	--	Nine good days to you, sera.
                "vo\\i\\m\\tHlo_IM105.mp3",	--	Mara's mercy on you.
                "vo\\i\\m\\tHlo_IM106.mp3",	--	Walk with Stendarr, citizen.
                "vo\\i\\m\\tHlo_IM107.mp3",	--	How are you today?
                "vo\\i\\m\\tHlo_IM108.mp3",	--	I'm listening.
                "vo\\i\\m\\tHlo_IM109.mp3",	--	What is it now?
                "vo\\i\\m\\tHlo_IM110.mp3",	--	Talk if you're talking.
                "vo\\i\\m\\tHlo_IM111.mp3",	--	Will this take long?
                "vo\\i\\m\\tHlo_IM112.mp3",	--	Talk is cheap.
                "vo\\i\\m\\tHlo_IM113.mp3",	--	Well?
                "vo\\i\\m\\tHlo_IM114.mp3",	--	So? You want something?
                "vo\\i\\m\\tHlo_IM115.mp3",	--	Go on. I can't stop you.
                "vo\\i\\m\\tHlo_IM116.mp3",	--	If you insist...
                "vo\\i\\m\\tIdl_IM001.mp3",	--	I could eat a baby's arse through a sewer grate.
                "vo\\i\\m\\tIdl_IM002.mp3",	--	Hard times, and well-deserved.
                "vo\\i\\m\\tIdl_IM003.mp3",	--	Serves them right, the thieving swine....
                "vo\\i\\m\\tIdl_IM004.mp3",	--	Maybe when it snows in my stove...
                "vo\\i\\m\\tIdl_IM005.mp3",	--	I'm never get this stain out...
                "vo\\i\\m\\tIdl_IM006.mp3",	--	Prune-faced old witch...
                "vo\\i\\m\\tIdl_IM007.mp3",	--	Now, where did I put that?
                "vo\\i\\m\\tIdl_IM008.mp3",	--	Clears throat.
                "vo\\i\\m\\tIdl_IM009.mp3",	--	It'll never work. I told him so....
                "vo\\i\\m\\tIdl_IM010.mp3",	--	Weak as wickwheat... never does a thing...
                "vo\\i\\m\\tIdl_IM011.mp3",	--	[Whistles]
                "vo\\i\\m\\tIdl_IM012.mp3",	--	You're imagining things.
                "vo\\i\\m\\tIdl_IM013.mp3",	--	He should be here by now...
            },
        },
    },
    ["khajiit"] = {
        ["f"] = {
            [this.voice.continue] = {
            },
            [this.voice.finish] = {
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
            },
            [this.voice.think] = {
            },
            [this.voice.remind] = {
                "vo\\k\\f\\Atk_KF001.mp3",	--	Growl!
                "vo\\k\\f\\Atk_KF002.mp3",	--	You will die like a rat, Redguard.
                "vo\\k\\f\\Atk_KF003.mp3",	--	We are too quick for you, brute.
                "vo\\k\\f\\Atk_KF004.mp3",	--	You are clumsy, snowman.
                "vo\\k\\f\\Atk_KF005.mp3",	--	Growl!
                "vo\\k\\f\\Atk_KF006.mp3",	--	Growl!
                "vo\\k\\f\\Atk_KF007.mp3",	--	Growl!
                "vo\\k\\f\\Atk_KF008.mp3",	--	Enslaver! Die!
                "vo\\k\\f\\Atk_KF009.mp3",	--	I will feast well on you, Argonian.
                "vo\\k\\f\\Atk_KF010.mp3",	--	So small and tasty. I will enjoy eating you.
                "vo\\k\\f\\Atk_KF012.mp3",	--	Growl!
                "vo\\k\\f\\Atk_KF013.mp3",	--	Growl!
                "vo\\k\\f\\Atk_KF014.mp3",	--	This one is no more!
                "vo\\k\\f\\Fle_KF001.mp3",	--	Help! Someone!
                "vo\\k\\f\\Fle_KF002.mp3",	--	Over here! I'm under attack!
                "vo\\k\\f\\Fle_KF003.mp3",	--	I give up! Let me live!
                "vo\\k\\f\\Fle_KF004.mp3",	--	You had your chance!
                "vo\\k\\f\\Fle_KF005.mp3",	--	Don't kill me!
                "vo\\k\\f\\Flw_KF002.mp3",	--	Please, be careful!
                "vo\\k\\f\\Flw_KF005.mp3",	--	I'm on your side!
                "vo\\k\\f\\Hit_KF001.mp3",	--	AAAIIEE.
                "vo\\k\\f\\Hit_KF002.mp3",	--	Arrgh.
                "vo\\k\\f\\Hit_KF003.mp3",	--	Fetcher!
                "vo\\k\\f\\Hit_KF004.mp3",	--	Urggh!
                "vo\\k\\f\\Hit_KF004.mp3",	--	Groan.
                "vo\\k\\f\\Hit_KF005.mp3",	--	Groan.
                "vo\\k\\f\\Hit_KF006.mp3",	--	Urgh!
                "vo\\k\\f\\Hit_KF006.mp3",	--	Groan.
                "vo\\k\\f\\Hit_KF007.mp3",	--	Groan.
                "vo\\k\\f\\Hit_KF008.mp3",	--	Grunt.
                "vo\\k\\f\\Hit_KF009.mp3",	--	Grunt.
                "vo\\k\\f\\Hit_KF010.mp3",	--	Grunt.
                "vo\\k\\f\\Hit_KF011.mp3",	--	Grunt.
                "vo\\k\\f\\Hit_KF012.mp3",	--	Grunt.
                "vo\\k\\f\\Hit_KF013.mp3",	--	Hiss.
                "vo\\k\\f\\Hit_KF014.mp3",	--	Hiss.
                "vo\\k\\f\\Hit_KF014.mp3",	--	Hiss.
                "vo\\k\\f\\Hit_KF015.mp3",	--	Hiss.
                "vo\\k\\f\\Hlo_KF000a.mp3",	--	What?!
                "vo\\k\\f\\Hlo_KF000b.mp3",	--	Hmmph!
                "vo\\k\\f\\Hlo_KF000c.mp3",	--	Grrfph!
                "vo\\k\\f\\Hlo_KF000d.mp3",	--	I won't waste my time on the likes of you.
                "vo\\k\\f\\Hlo_KF000e.mp3",	--	Get out of here!
                "vo\\k\\f\\Hlo_KF000e.mp3",	--	Get out of here!
                "vo\\k\\f\\Hlo_KF001.mp3",	--	Don't stand so close. Khajiit smell you.
                "vo\\k\\f\\Hlo_KF005.mp3",	--	Let me stuff your shirt for you.
                "vo\\k\\f\\Hlo_KF011.mp3",	--	You show your weakness, prey.
                "vo\\k\\f\\Hlo_KF012.mp3",	--	Half-dead thing! Leave now!
                "vo\\k\\f\\Hlo_KF013.mp3",	--	Bleed elsewhere, prey.
                "vo\\k\\f\\Hlo_KF014.mp3",	--	Wealth? Fame? What good are these?
                "vo\\k\\f\\Hlo_KF015.mp3",	--	How can you hunt in those clothes?
                "vo\\k\\f\\Hlo_KF016.mp3",	--	Disgusting thing. Leave now.
                "vo\\k\\f\\Hlo_KF017.mp3",	--	Does it want to feel Khajiti claws?
                "vo\\k\\f\\Hlo_KF018.mp3",	--	You bring danger. You should leave.
                "vo\\k\\f\\Hlo_KF019.mp3",	--	You are trouble. Khajiit know this.
                "vo\\k\\f\\Hlo_KF020.mp3",	--	Do not bring your sickness here.
                "vo\\k\\f\\Hlo_KF021.mp3",	--	It will leave. Now.
                "vo\\k\\f\\Hlo_KF022.mp3",	--	Go away. Do not come back.
                "vo\\k\\f\\Hlo_KF023.mp3",	--	Do not bother us.
                "vo\\k\\f\\Hlo_KF024.mp3",	--	You talk too much.
                "vo\\k\\f\\Hlo_KF025.mp3",	--	The one from far away has too much talk.
                "vo\\k\\f\\Hlo_KF026.mp3",	--	So little manners. So little time.
                "vo\\k\\f\\Hlo_KF027.mp3",	--	To greet you? Or eat you?
                "vo\\k\\f\\Hlo_KF028.mp3",	--	Khajiit has nothing to say to you.
                "vo\\k\\f\\Hlo_KF029.mp3",	--	Go away.
                "vo\\k\\f\\Hlo_KF030.mp3",	--	Can it speak? Can it make words?
                "vo\\k\\f\\Hlo_KF040.mp3",	--	You speak of our clan?
                "vo\\k\\f\\Hlo_KF041.mp3",	--	Why is it here?
                "vo\\k\\f\\Hlo_KF042.mp3",	--	You do not share.
                "vo\\k\\f\\Hlo_KF043.mp3",	--	So much talk...
                "vo\\k\\f\\Hlo_KF044.mp3",	--	Why does it appoach?
                "vo\\k\\f\\Hlo_KF045.mp3",	--	Khajiit do not murder... and get caught.
                "vo\\k\\f\\Hlo_KF046.mp3",	--	Khajiit do not steal... and get caught.
                "vo\\k\\f\\Hlo_KF049.mp3",	--	Find another place to die.
                "vo\\k\\f\\Hlo_KF050.mp3",	--	It has no clothes.
                "vo\\k\\f\\Hlo_KF051.mp3",	--	It is a sick one.
                "vo\\k\\f\\Hlo_KF052.mp3",	--	It comes near. What does it want?
                "vo\\k\\f\\Hlo_KF053.mp3",	--	You do not please us.
                "vo\\k\\f\\Hlo_KF054.mp3",	--	Ask if you must.
                "vo\\k\\f\\Hlo_KF055.mp3",	--	Speak now or leave now.
                "vo\\k\\f\\Hlo_KF056.mp3",	--	You want something?
                "vo\\k\\f\\Hlo_KF057.mp3",	--	Why do you approach?
                "vo\\k\\f\\Hlo_KF058.mp3",	--	You have questions?
                "vo\\k\\f\\Hlo_KF059.mp3",	--	Khajiit has no time for you.
                "vo\\k\\f\\Hlo_KF060.mp3",	--	Khajiit has no words for you.
                "vo\\k\\f\\Hlo_KF061.mp3",	--	What do you need?
                "vo\\k\\f\\Hlo_KF071.mp3",	--	Khajiit better than lizard. We work hard. No steal. Make you happy.
                "vo\\k\\f\\Hlo_KF072.mp3",	--	It has no master?
                "vo\\k\\f\\Hlo_KF073.mp3",	--	Khajiit do elf work. What do you do?
                "vo\\k\\f\\Hlo_KF074.mp3",	--	Sickness comes from the windward mountain.
                "vo\\k\\f\\Hlo_KF075.mp3",	--	Red sand slows the feet.
                "vo\\k\\f\\Hlo_KF076.mp3",	--	Wet fur.
                "vo\\k\\f\\Hlo_KF077.mp3",	--	Dry fur. No ash. A good day.
                "vo\\k\\f\\Hlo_KF078.mp3",	--	Rest and heal your wounds.
                "vo\\k\\f\\Hlo_KF079.mp3",	--	It suffers wounds.
                "vo\\k\\f\\Hlo_KF081.mp3",	--	Its scent is unfamiliar.
                "vo\\k\\f\\Hlo_KF082.mp3",	--	What Khajiit do for you?
                "vo\\k\\f\\Hlo_KF083.mp3",	--	You wish to speak?
                "vo\\k\\f\\Hlo_KF084.mp3",	--	What do you want?
                "vo\\k\\f\\Hlo_KF085.mp3",	--	Greetings.
                "vo\\k\\f\\Hlo_KF086.mp3",	--	Friend.
                "vo\\k\\f\\Hlo_KF087.mp3",	--	Good hunting.
                "vo\\k\\f\\Hlo_KF088.mp3",	--	Sera?
                "vo\\k\\f\\Hlo_KF089.mp3",	--	Muthsera?
                "vo\\k\\f\\Hlo_KF090.mp3",	--	Speak, friend. My turn to listen.
                "vo\\k\\f\\Hlo_KF091.mp3",	--	Some sugar for you, friend?
                "vo\\k\\f\\Hlo_KF092.mp3",	--	We are far from the deserts, friend.
                "vo\\k\\f\\Hlo_KF093.mp3",	--	Not to be afraid of this one.
                "vo\\k\\f\\Hlo_KF105.mp3",	--	You are wounded. You should rest.
                "vo\\k\\f\\Hlo_KF106.mp3",	--	You are too easily caught.
                "vo\\k\\f\\Hlo_KF107.mp3",	--	Your claws are sharp. You cut many purses.
                "vo\\k\\f\\Hlo_KF108.mp3",	--	Not afraid of you, kind master.
                "vo\\k\\f\\Hlo_KF108b.mp3",	--	Khajiit serve. Khajiit serve well.
                "vo\\k\\f\\Hlo_KF109.mp3",	--	Friend?
                "vo\\k\\f\\Hlo_KF110.mp3",	--	Speak freely.
                "vo\\k\\f\\Hlo_KF111.mp3",	--	Warm day to you.
                "vo\\k\\f\\Hlo_KF112.mp3",	--	Greetings, friend.
                "vo\\k\\f\\Hlo_KF113.mp3",	--	Why is my friend here?
                "vo\\k\\f\\Hlo_KF114.mp3",	--	What is it, friend?
                "vo\\k\\f\\Hlo_KF115.mp3",	--	What can Khajiit do for you?
                "vo\\k\\f\\Hlo_KF116.mp3",	--	Swift hunting, friend.
                "vo\\k\\f\\Hlo_KF117.mp3",	--	Welcome, friend.
                "vo\\k\\f\\Hlo_KF118.mp3",	--	Our good friend approaches.
                "vo\\k\\f\\Hlo_KF119.mp3",	--	Warmest welcome to you, sweet friend.
                "vo\\k\\f\\Hlo_KF120.mp3",	--	Welcome, friend. Share some sugar?
                "vo\\k\\f\\Hlo_KF130.mp3",	--	Such wounds! You worry your friends.
                "vo\\k\\f\\Hlo_KF131.mp3",	--	A night's rest and you'll be good as new.
                "vo\\k\\f\\Hlo_KF132.mp3",	--	What do you ask, master?
                "vo\\k\\f\\Hlo_KF133.mp3",	--	Our sugar is yours, friend.
                "vo\\k\\f\\Hlo_KF134.mp3",	--	Greetings.
                "vo\\k\\f\\Hlo_KF135.mp3",	--	Warm day to you, friend.
                "vo\\k\\f\\Hlo_KF136.mp3",	--	Good friend. This is an honor.
                "vo\\k\\f\\Hlo_KF137.mp3",	--	May you walk on warm sands.
                "vo\\k\\f\\Hlo_KF138.mp3",	--	Warmly greeted, friend. Welcome.
                "vo\\k\\f\\Hlo_KF139.mp3",	--	Growls
                "vo\\k\\f\\Idl_KF001.mp3",	--	Sweet Skooma.
                "vo\\k\\f\\Idl_KF001.mp3",	--	Sweet Skooma.
                "vo\\k\\f\\Idl_KF002.mp3",	--	Purr.
                "vo\\k\\f\\Idl_KF002.mp3",	--	Purr.
                "vo\\k\\f\\Idl_KF003.mp3",	--	Var var var.
                "vo\\k\\f\\Idl_KF003.mp3",	--	Var var var.
                "vo\\k\\f\\Idl_KF004.mp3",	--	Sniff.
                "vo\\k\\f\\Idl_KF004.mp3",	--	Sniff.
                "vo\\k\\f\\Idl_KF005.mp3",	--	What was that?
                "vo\\k\\f\\Idl_KF005.mp3",	--	What was that?
                "vo\\k\\f\\Idl_KF006.mp3",	--	I heard something.
                "vo\\k\\f\\Idl_KF006.mp3",	--	I heard something.
                "vo\\k\\f\\Idl_KF007.mp3",	--	Over there. That's new.
                "vo\\k\\f\\Idl_KF007.mp3",	--	Over there. That's new.
                "vo\\k\\f\\Idl_KF008.mp3",	--	There is much to learn.
                "vo\\k\\f\\Idl_KF008.mp3",	--	There is much to learn.
                "vo\\k\\f\\Idl_KF009.mp3",	--	Sweet moon sugar.
                "vo\\k\\f\\Idl_KF009.mp3",	--	Sweet moon sugar.
            },
        },
        ["m"] = {
            [this.voice.continue] = {
            },
            [this.voice.finish] = {
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
            },
            [this.voice.think] = {
            },
            [this.voice.remind] = {
                "vo\\k\\m\\Atk_KM001.mp3",	--	Growl!
                "vo\\k\\m\\Atk_KM002.mp3",	--	You will die like a rat, Redguard.
                "vo\\k\\m\\Atk_KM003.mp3",	--	We are too quick for you, brute.
                "vo\\k\\m\\Atk_KM004.mp3",	--	You are clumsy, snowman.
                "vo\\k\\m\\Atk_KM005.mp3",	--	Growl!
                "vo\\k\\m\\Atk_KM006.mp3",	--	Growl!
                "vo\\k\\m\\Atk_KM007.mp3",	--	Growl!
                "vo\\k\\m\\Atk_KM008.mp3",	--	Enslaver! Die!
                "vo\\k\\m\\Atk_KM009.mp3",	--	I will feast well on you, Argonian.
                "vo\\k\\m\\Atk_KM010.mp3",	--	So small and tasty. I will enjoy eating you.
                "vo\\k\\m\\Atk_KM012.mp3",	--	Growl!
                "vo\\k\\m\\Atk_KM012.mp3",	--	Growl!
                "vo\\k\\m\\Atk_KM013.mp3",	--	Growl!
                "vo\\k\\m\\Atk_KM015.mp3",	--	This one is no more!
                "vo\\k\\m\\bAtk_KM001.mp3",	--	Kill the beast!
                "vo\\k\\m\\bAtk_KM001.mp3",	--	Kill the beast!
                "vo\\k\\m\\bAtk_KM002.mp3",	--	Your head will be my new trophy!
                "vo\\k\\m\\bAtk_KM002.mp3",	--	Your head will be my new trophy!
                "vo\\k\\m\\bAtk_KM003.mp3",	--	I've got a bone for you. Come and get it!
                "vo\\k\\m\\bAtk_KM003.mp3",	--	I've got a bone for you. Come and get it!
                "vo\\k\\m\\bAtk_KM004.mp3",	--	I've fought guars more ferocious than you!
                "vo\\k\\m\\bAtk_KM004.mp3",	--	I've fought guars more ferocious than you!
                "vo\\k\\m\\bFle_KM001.mp3",	--	Help! A beast!
                "vo\\k\\m\\bFle_KM001.mp3",	--	Help! A beast!
                "vo\\k\\m\\bFle_KM002.mp3",	--	Get away, beast!
                "vo\\k\\m\\bFle_KM002.mp3",	--	Get away, beast!
                "vo\\k\\m\\bFle_KM003.mp3",	--	Go away! I don't have any treats!
                "vo\\k\\m\\bFle_KM003.mp3",	--	Go away! I don't have any treats!
                "vo\\k\\m\\bFle_KM004.mp3",	--	Don't infect me with your curse!
                "vo\\k\\m\\bFle_KM004.mp3",	--	Don't infect me with your curse!
                "vo\\k\\m\\bIdl_KM001.mp3",	--	Hurry, hurry! Last boat to Solstheim! Until the next one. Hah-ha-hah.
                "vo\\k\\m\\bIdl_KM001.mp3",	--	Hurry, hurry! Last boat to Solstheim! Until the next one. Hah-ha-hah.
                "vo\\k\\m\\bIdl_KM002.mp3",	--	[Hawk-hawk-hawk-Ptooie] There! Eat that, little slaughterfish. Nice present from S'virr.
                "vo\\k\\m\\bIdl_KM003.mp3",	--	No! S'virr LIKES splinters. THAT'S why S'virr wears no boots.' Idiots.
                "vo\\k\\m\\CrAtk_KM001.mp3",	--	Rrrarrwlll!
                "vo\\k\\m\\Fle_KM001.mp3",	--	Help! Someone!
                "vo\\k\\m\\Fle_KM002.mp3",	--	Over here! I'm under attack!
                "vo\\k\\m\\Fle_KM003.mp3",	--	I give up! Let me live!
                "vo\\k\\m\\Fle_KM004.mp3",	--	You had your chance!
                "vo\\k\\m\\Fle_KM005.mp3",	--	Don't kill me!
                "vo\\k\\m\\Flw_KM002.mp3",	--	Careful with that friend!
                "vo\\k\\m\\Hit_KM001.mp3",	--	AAAIIEE.
                "vo\\k\\m\\Hit_KM002.mp3",	--	Arrgh.
                "vo\\k\\m\\Hit_KM003.mp3",	--	Hugnh!
                "vo\\k\\m\\Hit_KM004.mp3",	--	Groan.
                "vo\\k\\m\\Hit_KM005.mp3",	--	Grarrgh!
                "vo\\k\\m\\Hit_KM005.mp3",	--	Groan.
                "vo\\k\\m\\Hit_KM006.mp3",	--	Growwl!
                "vo\\k\\m\\Hit_KM006.mp3",	--	Groan.
                "vo\\k\\m\\Hit_KM007.mp3",	--	Groan.
                "vo\\k\\m\\Hit_KM008.mp3",	--	Grunt.
                "vo\\k\\m\\Hit_KM009.mp3",	--	Grunt.
                "vo\\k\\m\\Hit_KM010.mp3",	--	Rarrgh!
                "vo\\k\\m\\Hit_KM010.mp3",	--	Grunt.
                "vo\\k\\m\\Hit_KM011.mp3",	--	Grunt.
                "vo\\k\\m\\Hit_KM012.mp3",	--	Grunt.
                "vo\\k\\m\\Hit_KM013.mp3",	--	Hiss.
                "vo\\k\\m\\Hit_KM014.mp3",	--	Hiss.
                "vo\\k\\m\\Hlo_KM001.mp3",	--	Don't stand so close. Khajiit smell you.
                "vo\\k\\m\\Hlo_KM005.mp3",	--	Let me stuff your shirt for you.
                "vo\\k\\m\\Hlo_KM011.mp3",	--	You show your weakness, prey.
                "vo\\k\\m\\Hlo_KM012.mp3",	--	Half-dead thing! Leave now!
                "vo\\k\\m\\Hlo_KM013.mp3",	--	Bleed elsewhere, prey.
                "vo\\k\\m\\Hlo_KM014.mp3",	--	Wealth? Fame? What good are these?
                "vo\\k\\m\\Hlo_KM015.mp3",	--	How can you hunt in those clothes?
                "vo\\k\\m\\Hlo_KM016.mp3",	--	Disgusting thing. Leave now.
                "vo\\k\\m\\Hlo_KM017.mp3",	--	Does it want to feel Khajiiti claws?
                "vo\\k\\m\\Hlo_KM018.mp3",	--	You bring danger. You should leave.
                "vo\\k\\m\\Hlo_KM019.mp3",	--	You are trouble. Khajiit know this.
                "vo\\k\\m\\Hlo_KM020.mp3",	--	Do not bring your sickness here.
                "vo\\k\\m\\Hlo_KM021.mp3",	--	It will leave. Now.
                "vo\\k\\m\\Hlo_KM022.mp3",	--	Go away! Do not come back!
                "vo\\k\\m\\Hlo_KM022.mp3",	--	Go away. Do not come back.
                "vo\\k\\m\\Hlo_KM023.mp3",	--	Do not bother us!
                "vo\\k\\m\\Hlo_KM024.mp3",	--	You talk too much.
                "vo\\k\\m\\Hlo_KM025.mp3",	--	The one from far away has too much talk.
                "vo\\k\\m\\Hlo_KM026.mp3",	--	So little manners, so little time.
                "vo\\k\\m\\Hlo_KM027.mp3",	--	To greet you? Or eat you?
                "vo\\k\\m\\Hlo_KM028.mp3",	--	Khajiit has nothing to say to you.
                "vo\\k\\m\\Hlo_KM029.mp3",	--	Go away.
                "vo\\k\\m\\Hlo_KM030.mp3",	--	Can it speak? Can it make words?
                "vo\\k\\m\\Hlo_KM040.mp3",	--	You speak of our clan?
                "vo\\k\\m\\Hlo_KM041.mp3",	--	Why is it here?
                "vo\\k\\m\\Hlo_KM042.mp3",	--	You do not share.
                "vo\\k\\m\\Hlo_KM043.mp3",	--	So much talk.
                "vo\\k\\m\\Hlo_KM044.mp3",	--	Why does it approach?
                "vo\\k\\m\\Hlo_KM045.mp3",	--	Khajiit do not murder... and get caught.
                "vo\\k\\m\\Hlo_KM046.mp3",	--	Khajiit do not steal... and get caught.
                "vo\\k\\m\\Hlo_KM049.mp3",	--	Find another place to die.
                "vo\\k\\m\\Hlo_KM050.mp3",	--	It has no clothes?
                "vo\\k\\m\\Hlo_KM051.mp3",	--	It is a sick one.
                "vo\\k\\m\\Hlo_KM052.mp3",	--	It comes near. What does it want?
                "vo\\k\\m\\Hlo_KM053.mp3",	--	You do not please us.
                "vo\\k\\m\\Hlo_KM054.mp3",	--	Ask if you must.
                "vo\\k\\m\\Hlo_KM055.mp3",	--	Speak now or leave now.
                "vo\\k\\m\\Hlo_KM056.mp3",	--	You want something?
                "vo\\k\\m\\Hlo_KM057.mp3",	--	Why do you approach?
                "vo\\k\\m\\Hlo_KM058.mp3",	--	You have questions?
                "vo\\k\\m\\Hlo_KM059.mp3",	--	Khajiit has no time for you.
                "vo\\k\\m\\Hlo_KM060.mp3",	--	Khajiit has no words for you.
                "vo\\k\\m\\Hlo_KM061.mp3",	--	What do you need?
                "vo\\k\\m\\Hlo_KM071.mp3",	--	Khajiit better than lizard. We work hard. No steal. Make you happy.
                "vo\\k\\m\\Hlo_KM072.mp3",	--	It has no master?
                "vo\\k\\m\\Hlo_KM073.mp3",	--	Khajiit do Elf-work. What do you do?
                "vo\\k\\m\\Hlo_KM074.mp3",	--	Sickness comes from the windward mountain.
                "vo\\k\\m\\Hlo_KM075.mp3",	--	Red sand slows the feet.
                "vo\\k\\m\\Hlo_KM076.mp3",	--	Wet fur.
                "vo\\k\\m\\Hlo_KM077.mp3",	--	Dry fur. No ash. A good day.
                "vo\\k\\m\\Hlo_KM078.mp3",	--	Rest and heal your wounds.
                "vo\\k\\m\\Hlo_KM079.mp3",	--	It suffers wounds.
                "vo\\k\\m\\Hlo_KM081.mp3",	--	Its scent is unfamiliar.
                "vo\\k\\m\\Hlo_KM082.mp3",	--	What Khajiit do for you?
                "vo\\k\\m\\Hlo_KM083.mp3",	--	You wish to speak?
                "vo\\k\\m\\Hlo_KM084.mp3",	--	What do you want?
                "vo\\k\\m\\Hlo_KM085.mp3",	--	Greetings.
                "vo\\k\\m\\Hlo_KM086.mp3",	--	Friend?
                "vo\\k\\m\\Hlo_KM087.mp3",	--	Good hunting.
                "vo\\k\\m\\Hlo_KM088.mp3",	--	Sera?
                "vo\\k\\m\\Hlo_KM089.mp3",	--	Muthsera?
                "vo\\k\\m\\Hlo_KM090.mp3",	--	Speak friend. My turn to listen.
                "vo\\k\\m\\Hlo_KM091.mp3",	--	Some sugar for you, friend?
                "vo\\k\\m\\Hlo_KM092.mp3",	--	We are far from the deserts, friend.
                "vo\\k\\m\\Hlo_KM093.mp3",	--	Not to be afraid of this one.
                "vo\\k\\m\\Hlo_KM105.mp3",	--	You are wounded. You should rest.
                "vo\\k\\m\\Hlo_KM106.mp3",	--	You are too easily caught.
                "vo\\k\\m\\Hlo_KM107.mp3",	--	Your claws are sharp. You cut many purses.
                "vo\\k\\m\\Hlo_KM108.mp3",	--	Khajiit serve. Khajiit serve well.
                "vo\\k\\m\\Hlo_KM109.mp3",	--	Friend?
                "vo\\k\\m\\Hlo_KM110.mp3",	--	Speak freely.
                "vo\\k\\m\\Hlo_KM111.mp3",	--	Warm day to you.
                "vo\\k\\m\\Hlo_KM112.mp3",	--	Greetings, friend.
                "vo\\k\\m\\Hlo_KM113.mp3",	--	Why is my friend here?
                "vo\\k\\m\\Hlo_KM114.mp3",	--	What is it, friend?
                "vo\\k\\m\\Hlo_KM115.mp3",	--	What can Khajiit do for you?
                "vo\\k\\m\\Hlo_KM116.mp3",	--	Swift hunting, friend.
                "vo\\k\\m\\Hlo_KM117.mp3",	--	Welcome, friend.
                "vo\\k\\m\\Hlo_KM118.mp3",	--	Our good friend approaches.
                "vo\\k\\m\\Hlo_KM119.mp3",	--	Warmest welcomes to you, sweet friend.
                "vo\\k\\m\\Hlo_KM120.mp3",	--	Welcome, friend. Share some sugar?
                "vo\\k\\m\\Hlo_KM130.mp3",	--	Such wounds, you worry your friends.
                "vo\\k\\m\\Hlo_KM131.mp3",	--	A night's rest and you'll be good as new.
                "vo\\k\\m\\Hlo_KM132.mp3",	--	What do you ask, master?
                "vo\\k\\m\\Hlo_KM133.mp3",	--	Our sugar is yours, friend.
                "vo\\k\\m\\Hlo_KM134.mp3",	--	Greetings.
                "vo\\k\\m\\Hlo_KM135.mp3",	--	Warm day to you, friend.
                "vo\\k\\m\\Hlo_KM136.mp3",	--	Good friend, this is an honor.
                "vo\\k\\m\\Hlo_KM137.mp3",	--	May you walk on warm sands.
                "vo\\k\\m\\Hlo_KM138.mp3",	--	Warmly greeted, friend. Welcome.
                "vo\\k\\m\\Hlo_KM139.mp3",	--	Grrrowl!
                "vo\\k\\m\\Idl_KM001.mp3",	--	Sweet Skooma.
                "vo\\k\\m\\Idl_KM001.mp3",	--	Sweet Skooma.
                "vo\\k\\m\\Idl_KM002.mp3",	--	Purrs.
                "vo\\k\\m\\Idl_KM002.mp3",	--	Purrs.
                "vo\\k\\m\\Idl_KM003.mp3",	--	Var var var.
                "vo\\k\\m\\Idl_KM003.mp3",	--	Var var var.
                "vo\\k\\m\\Idl_KM004.mp3",	--	Sniff.
                "vo\\k\\m\\Idl_KM004.mp3",	--	Sniff.
                "vo\\k\\m\\Idl_KM005.mp3",	--	What was that?
                "vo\\k\\m\\Idl_KM005.mp3",	--	What was that?
                "vo\\k\\m\\Idl_KM006.mp3",	--	I heard something.
                "vo\\k\\m\\Idl_KM006.mp3",	--	I heard something.
                "vo\\k\\m\\Idl_KM007.mp3",	--	Over there. That's new.
                "vo\\k\\m\\Idl_KM007.mp3",	--	Over there. That's new.
                "vo\\k\\m\\Idl_KM008.mp3",	--	There is much to learn.
                "vo\\k\\m\\Idl_KM008.mp3",	--	There is much to learn.
                "vo\\k\\m\\Idl_KM009.mp3",	--	Sweet moon sugar.
                "vo\\k\\m\\Idl_KM009.mp3",	--	Sweet moon sugar.
            },

        },
    },
    ["nord"] = {
        ["f"] = {
            [this.voice.continue] = {
            },
            [this.voice.finish] = {
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
            },
            [this.voice.think] = {
            },
            [this.voice.remind] = {
                "vo\\n\\f\\Atk_NF001.mp3",	--	You will die where you stand!
                "vo\\n\\f\\Atk_NF002.mp3",	--	ARRRR!
                "vo\\n\\f\\Atk_NF003.mp3",	--	HAAAA!
                "vo\\n\\f\\Atk_NF004.mp3",	--	Fool!
                "vo\\n\\f\\Atk_NF005.mp3",	--	Give in! You're dead already!
                "vo\\n\\f\\Atk_NF006.mp3",	--	You should've picked an easier opponent!
                "vo\\n\\f\\Atk_NF007.mp3",	--	I will bathe in your blood.
                "vo\\n\\f\\Atk_NF008.mp3",	--	Now this is fighting!
                "vo\\n\\f\\Atk_NF010.mp3",	--	How does it feel to know death is near?
                "vo\\n\\f\\Atk_NF012.mp3",	--	This is too easy!
                "vo\\n\\f\\Atk_NF013.mp3",	--	Ungh! You call this fighting?
                "vo\\n\\f\\Atk_NF014.mp3",	--	Come on, fight!
                "vo\\n\\f\\Atk_NF015.mp3",	--	Face death!
                "vo\\n\\f\\bAtk_NF001.mp3",	--	Taste my silver, foul beast!
                "vo\\n\\f\\bAtk_NF002.mp3",	--	Your cursed bloodline ends here!
                "vo\\n\\f\\bAtk_NF003.mp3",	--	I've got the cure for your curse right here.
                "vo\\n\\f\\bAtk_NF004.mp3",	--	Kill the beast!
                "vo\\n\\f\\bAtk_NF005.mp3",	--	Your head will be my new trophy!
                "vo\\n\\f\\bAtk_NF006.mp3",	--	I've got a bone for you. Come and get it!
                "vo\\n\\f\\bAtk_NF007.mp3",	--	I've fought guars more ferocious than you!
                "vo\\n\\f\\bAtk_NF008.mp3",	--	Your cursed bloodline ends here!
                "vo\\n\\f\\bAtk_NF009.mp3",	--	I've got the cure for your curse right here.
                "vo\\n\\f\\bFle_NF001.mp3",	--	Help! Beast!
                "vo\\n\\f\\bFle_NF002.mp3",	--	Get away, beast!
                "vo\\n\\f\\bFle_NF003.mp3",	--	Go away! I don't have any treats!
                "vo\\n\\f\\bFle_NF004.mp3",	--	Don't infect me with your curse!
                "vo\\n\\f\\bHlo_NF001.mp3",	--	Hello, friend. Have you met my love, Brandr?
                "vo\\n\\f\\bHlo_NF002.mp3",	--	Welcome to Thirsk, friend! You should speak to Skjoldr Wolf-Runner. He is the chieftain of this hall, and wishes to meet all new arrivals.
                "vo\\n\\f\\bHlo_NF003.mp3",	--	Our mead ish the nectar of Shor himshelf, imported all the way from Shkyrim!
                "vo\\n\\f\\bHlo_NF004.mp3",	--	All hail the chieftain of Thirsk! Slayer of the Udyrfrykte! May the mead flow forever!
                "vo\\n\\f\\bHlo_NF005.mp3",	--	Thirsk is closed, and without a chieftain. These are sad times.
                "vo\\n\\f\\bHlo_NF006.mp3",	--	Watch yourself near Erich, friend.  He's a swine of a man.  It's too bad he's my clan brother....
                "vo\\n\\f\\bHlo_NF010.mp3",	--	Our dark business is complete. Erna is dead! Hahahahahahahaha!
                "vo\\n\\f\\bHlo_NF011.mp3",	--	My husband is mine, do you understand me? Mine! That harlot Erna will pay!
                "vo\\n\\f\\bHlo_NF012.mp3",	--	You have cleared my husband's name. What can I do for you?
                "vo\\n\\f\\bHlo_NF013.mp3",	--	You are the one who is to investigate a crime that has been blamed on my husband. How may I help you?
                "vo\\n\\f\\bHlo_NF014.mp3",	--	Stay with Long-Tooth, Blodskaal. The Ristaag must be completed.
                "vo\\n\\f\\bHlo_NF015.mp3",	--	Have you come for Stalhrim weapons, friend?
                "vo\\n\\f\\bHlo_NF016.mp3",	--	Speak to Graring.
                "vo\\n\\f\\bHlo_NF017.mp3",	--	You have no business being here, stranger. Leave now.
                "vo\\n\\f\\bHlo_NF019.mp3",	--	All hail the new sheeftain of Thirshk! Becaushe of you, the mead hall ish open again! Here'sh to your health!
                "vo\\n\\f\\bHlo_NF020.mp3",	--	Quickly, into the Greathall! Some of the beasts ran inside!
                "vo\\n\\f\\bHlo_NF021.mp3",	--	Werewolves in the Greathall! Get in there quickly!
                "vo\\n\\f\\bIdl_NF001.mp3",	--	Oh, sure. '...but it's a DRY heat.'
                "vo\\n\\f\\bIdl_NF001.mp3",	--	Oh, sure. '...but it's a DRY heat.'
                "vo\\n\\f\\bIdl_NF001.mp3",	--	Oh, sure. '...but it's a DRY heat.'
                "vo\\n\\f\\bIdl_NF001.mp3",	--	Oh, sure. '...but it's a DRY heat.'
                "vo\\n\\f\\bIdl_NF001.mp3",	--	Oh, sure. '...but it's a DRY heat.'
                "vo\\n\\f\\bIdl_NF002.mp3",	--	I am NOT getting fat. These furs are shrinking.
                "vo\\n\\f\\bIdl_NF002.mp3",	--	I am NOT getting fat. These furs are shrinking.
                "vo\\n\\f\\bIdl_NF002.mp3",	--	I am NOT getting fat. These furs are shrinking.
                "vo\\n\\f\\bIdl_NF002.mp3",	--	I am NOT getting fat. These furs are shrinking.
                "vo\\n\\f\\bIdl_NF002.mp3",	--	I am NOT getting fat. These furs are shrinking.
                "vo\\n\\f\\bIdl_NF003.mp3",	--	The Great Circle of Life goes on, sweetie.
                "vo\\n\\f\\bIdl_NF003.mp3",	--	The Great Circle of Life goes on, sweetie.
                "vo\\n\\f\\bIdl_NF003.mp3",	--	The Great Circle of Life goes on, sweetie.
                "vo\\n\\f\\bIdl_NF003.mp3",	--	The Great Circle of Life goes on, sweetie.
                "vo\\n\\f\\bIdl_NF003.mp3",	--	The Great Circle of Life goes on, sweetie.
                "vo\\n\\f\\bIdl_NF004.mp3",	--	So there I was, winking at the honey jar again.
                "vo\\n\\f\\bIdl_NF004.mp3",	--	So there I was, winking at the honey jar again.
                "vo\\n\\f\\bIdl_NF004.mp3",	--	So there I was, winking at the honey jar again.
                "vo\\n\\f\\bIdl_NF004.mp3",	--	So there I was, winking at the honey jar again.
                "vo\\n\\f\\bIdl_NF004.mp3",	--	So there I was, winking at the honey jar again.
                "vo\\n\\f\\bIdl_NF005.mp3",	--	Got to get these wolf guts off my britches. Got any ideas?
                "vo\\n\\f\\bIdl_NF005.mp3",	--	Got to get these wolf guts off my britches. Got any ideas?
                "vo\\n\\f\\bIdl_NF005.mp3",	--	Got to get these wolf guts off my britches. Got any ideas?
                "vo\\n\\f\\bIdl_NF005.mp3",	--	Got to get these wolf guts off my britches. Got any ideas?
                "vo\\n\\f\\bIdl_NF005.mp3",	--	Got to get these wolf guts off my britches. Got any ideas?
                "vo\\n\\f\\bIdl_NF006.mp3",	--	Can't a girl get a break?
                "vo\\n\\f\\bIdl_NF006.mp3",	--	Can't a girl get a break?
                "vo\\n\\f\\bIdl_NF006.mp3",	--	Can't a girl get a break?
                "vo\\n\\f\\bIdl_NF006.mp3",	--	Can't a girl get a break?
                "vo\\n\\f\\bIdl_NF006.mp3",	--	Can't a girl get a break?
                "vo\\n\\f\\bIdl_NF007.mp3",	--	Hey! Good-looking... No, chump, not you.
                "vo\\n\\f\\bIdl_NF007.mp3",	--	Hey! Good-looking... No, chump, not you.
                "vo\\n\\f\\bIdl_NF007.mp3",	--	Hey! Good-looking... No, chump, not you.
                "vo\\n\\f\\bIdl_NF007.mp3",	--	Hey! Good-looking... No, chump, not you.
                "vo\\n\\f\\bIdl_NF007.mp3",	--	Hey! Good-looking... No, chump, not you.
                "vo\\n\\f\\bIdl_NF008.mp3",	--	In your dreams, little buddy.
                "vo\\n\\f\\bIdl_NF008.mp3",	--	In your dreams, little buddy.
                "vo\\n\\f\\bIdl_NF008.mp3",	--	In your dreams, little buddy.
                "vo\\n\\f\\bIdl_NF008.mp3",	--	In your dreams, little buddy.
                "vo\\n\\f\\bIdl_NF008.mp3",	--	In your dreams, little buddy.
                "vo\\n\\f\\bIdl_NF009.mp3",	--	Hey. I found a piece of cheese. Whose piece of cheese is this?
                "vo\\n\\f\\bIdl_NF009.mp3",	--	Hey. I found a piece of cheese. Whose piece of cheese is this?
                "vo\\n\\f\\bIdl_NF009.mp3",	--	Hey. I found a piece of cheese. Whose piece of cheese is this?
                "vo\\n\\f\\bIdl_NF009.mp3",	--	Hey. I found a piece of cheese. Whose piece of cheese is this?
                "vo\\n\\f\\bIdl_NF009.mp3",	--	Hey. I found a piece of cheese. Whose piece of cheese is this?
                "vo\\n\\f\\bIdl_NF010.mp3",	--	... so Hrokar says, 'Bend over and kiss your old mother goodbye!' [gales of laughter]
                "vo\\n\\f\\bIdl_NF010.mp3",	--	... so Hrokar says, 'Bend over and kiss your old mother goodbye!' [gales of laughter]
                "vo\\n\\f\\bIdl_NF010.mp3",	--	... so Hrokar says, 'Bend over and kiss your old mother goodbye!' [gales of laughter]
                "vo\\n\\f\\bIdl_NF010.mp3",	--	... so Hrokar says, 'Bend over and kiss your old mother goodbye!' [gales of laughter]
                "vo\\n\\f\\bIdl_NF010.mp3",	--	... so Hrokar says, 'Bend over and kiss your old mother goodbye!' [gales of laughter]
                "vo\\n\\f\\bIdl_NF011.mp3",	--	I'm losing my woolens again. Look the other way, would ya?
                "vo\\n\\f\\bIdl_NF011.mp3",	--	I'm losing my woolens again. Look the other way, would ya?
                "vo\\n\\f\\bIdl_NF011.mp3",	--	I'm losing my woolens again. Look the other way, would ya?
                "vo\\n\\f\\bIdl_NF011.mp3",	--	I'm losing my woolens again. Look the other way, would ya?
                "vo\\n\\f\\bIdl_NF011.mp3",	--	I'm losing my woolens again. Look the other way, would ya?
                "vo\\n\\f\\bIdl_NF012.mp3",	--	Moody? Not really. I'm always this way.
                "vo\\n\\f\\bIdl_NF012.mp3",	--	Moody? Not really. I'm always this way.
                "vo\\n\\f\\bIdl_NF012.mp3",	--	Moody? Not really. I'm always this way.
                "vo\\n\\f\\bIdl_NF012.mp3",	--	Moody? Not really. I'm always this way.
                "vo\\n\\f\\bIdl_NF012.mp3",	--	Moody? Not really. I'm always this way.
                "vo\\n\\f\\bIdl_NF013.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\n\\f\\bIdl_NF013.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\n\\f\\bIdl_NF013.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\n\\f\\bIdl_NF013.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\n\\f\\bIdl_NF013.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\n\\f\\bIdl_NF014.mp3",	--	We keep it dark in here so you can't see the dirt.
                "vo\\n\\f\\bIdl_NF014.mp3",	--	We keep it dark in here so you can't see the dirt.
                "vo\\n\\f\\bIdl_NF014.mp3",	--	We keep it dark in here so you can't see the dirt.
                "vo\\n\\f\\bIdl_NF014.mp3",	--	We keep it dark in here so you can't see the dirt.
                "vo\\n\\f\\bIdl_NF014.mp3",	--	We keep it dark in here so you can't see the dirt.
                "vo\\n\\f\\bIdl_NF015.mp3",	--	Hot or cold, or served in a boot... mead's my drink. Rectifies the humors and confuses the vermin.
                "vo\\n\\f\\bIdl_NF015.mp3",	--	Hot or cold, or served in a boot... mead's my drink. Rectifies the humors and confuses the vermin.
                "vo\\n\\f\\bIdl_NF015.mp3",	--	Hot or cold, or served in a boot... mead's my drink. Rectifies the humors and confuses the vermin.
                "vo\\n\\f\\bIdl_NF015.mp3",	--	Hot or cold, or served in a boot... mead's my drink. Rectifies the humors and confuses the vermin.
                "vo\\n\\f\\bIdl_NF015.mp3",	--	Hot or cold, or served in a boot... mead's my drink. Rectifies the humors and confuses the vermin.
                "vo\\n\\f\\bIdl_NF016.mp3",	--	He's so sorry, his momma swapped him for a dog, and drowned the dog.
                "vo\\n\\f\\bIdl_NF016.mp3",	--	He's so sorry, his momma swapped him for a dog, and drowned the dog.
                "vo\\n\\f\\bIdl_NF016.mp3",	--	He's so sorry, his momma swapped him for a dog, and drowned the dog.
                "vo\\n\\f\\bIdl_NF016.mp3",	--	He's so sorry, his momma swapped him for a dog, and drowned the dog.
                "vo\\n\\f\\bIdl_NF016.mp3",	--	He's so sorry, his momma swapped him for a dog, and drowned the dog.
                "vo\\n\\f\\bIdl_NF017.mp3",	--	Might take a stroll and let the wind blow the stink off.
                "vo\\n\\f\\bIdl_NF017.mp3",	--	Might take a stroll and let the wind blow the stink off.
                "vo\\n\\f\\bIdl_NF017.mp3",	--	Might take a stroll and let the wind blow the stink off.
                "vo\\n\\f\\bIdl_NF017.mp3",	--	Might take a stroll and let the wind blow the stink off.
                "vo\\n\\f\\bIdl_NF017.mp3",	--	Might take a stroll and let the wind blow the stink off.
                "vo\\n\\f\\bIdl_NF018.mp3",	--	Cold? This ain't cold. You should try Skyrim. Now THERE'S cold for ya.
                "vo\\n\\f\\bIdl_NF018.mp3",	--	Cold? This ain't cold. You should try Skyrim. Now THERE'S cold for ya.
                "vo\\n\\f\\bIdl_NF018.mp3",	--	Cold? This ain't cold. You should try Skyrim. Now THERE'S cold for ya.
                "vo\\n\\f\\bIdl_NF018.mp3",	--	Cold? This ain't cold. You should try Skyrim. Now THERE'S cold for ya.
                "vo\\n\\f\\bIdl_NF018.mp3",	--	Cold? This ain't cold. You should try Skyrim. Now THERE'S cold for ya.
                "vo\\n\\f\\bIdl_NF019.mp3",	--	*Pfbbbbbbbt*
                "vo\\n\\f\\bIdl_NF019.mp3",	--	*Pfbbbbbbbt*
                "vo\\n\\f\\bIdl_NF019.mp3",	--	*Pfbbbbbbbt*
                "vo\\n\\f\\bIdl_NF019.mp3",	--	*Pfbbbbbbbt*
                "vo\\n\\f\\bIdl_NF019.mp3",	--	*Pfbbbbbbbt*
                "vo\\n\\f\\bIdl_NF020.mp3",	--	Oh, not AGAIN!
                "vo\\n\\f\\bIdl_NF020.mp3",	--	Oh, not AGAIN!
                "vo\\n\\f\\bIdl_NF020.mp3",	--	Oh, not AGAIN!
                "vo\\n\\f\\bIdl_NF020.mp3",	--	Oh, not AGAIN!
                "vo\\n\\f\\bIdl_NF020.mp3",	--	Oh, not AGAIN!
                "vo\\n\\f\\bIdl_NF021.mp3",	--	[Wide yawn.]
                "vo\\n\\f\\bIdl_NF022.mp3",	--	Wait-wait-wait! I remember now! 'Ecdysiast!' That's it! She used to work as an ecdysiast.
                "vo\\n\\f\\bIdl_NF022.mp3",	--	Wait-wait-wait! I remember now! 'Ecdysiast!' That's it! She used to work as an ecdysiast.
                "vo\\n\\f\\bIdl_NF022.mp3",	--	Wait-wait-wait! I remember now! 'Ecdysiast!' That's it! She used to work as an ecdysiast.
                "vo\\n\\f\\bIdl_NF022.mp3",	--	Wait-wait-wait! I remember now! 'Ecdysiast!' That's it! She used to work as an ecdysiast.
                "vo\\n\\f\\bIdl_NF022.mp3",	--	Wait-wait-wait! I remember now! 'Ecdysiast!' That's it! She used to work as an ecdysiast.
                "vo\\n\\f\\Fle_NF001.mp3",	--	Not today.
                "vo\\n\\f\\Fle_NF002.mp3",	--	You've won this round.
                "vo\\n\\f\\Fle_NF003.mp3",	--	You fight unfair, this bout is over.
                "vo\\n\\f\\Fle_NF004.mp3",	--	End your fight, I'm leaving.
                "vo\\n\\f\\Fle_NF005.mp3",	--	End your fight, I'm leaving.
                "vo\\n\\f\\Flw_NF002.mp3",	--	Please! Be careful!
                "vo\\n\\f\\Flw_NF005.mp3",	--	I'm on your side!
                "vo\\n\\f\\Hit_NF001.mp3",	--	Arrgh.
                "vo\\n\\f\\Hit_NF002.mp3",	--	Umpfh
                "vo\\n\\f\\Hit_NF003.mp3",	--	Ungh.
                "vo\\n\\f\\Hit_NF004.mp3",	--	Grunt.
                "vo\\n\\f\\Hit_NF005.mp3",	--	Engh!
                "vo\\n\\f\\Hit_NF005.mp3",	--	Groan.
                "vo\\n\\f\\Hit_NF006.mp3",	--	Growl.
                "vo\\n\\f\\Hit_NF007.mp3",	--	Cough
                "vo\\n\\f\\Hit_NF008.mp3",	--	Gasp.
                "vo\\n\\f\\Hit_NF009.mp3",	--	Scream.
                "vo\\n\\f\\Hit_NF010.mp3",	--	Ungh!
                "vo\\n\\f\\Hit_NF010.mp3",	--	Yell.
                "vo\\n\\f\\Hit_NF011.mp3",	--	Grunt.
                "vo\\n\\f\\Hit_NF012.mp3",	--	Groan.
                "vo\\n\\f\\Hit_NF013.mp3",	--	Growl.
                "vo\\n\\f\\Hit_NF014.mp3",	--	Gasp.
                "vo\\n\\f\\Hit_NF015.mp3",	--	Scream.
                "vo\\n\\f\\Hlo_NF000a.mp3",	--	What?
                "vo\\n\\f\\Hlo_NF000b.mp3",	--	Hmph!
                "vo\\n\\f\\Hlo_NF000c.mp3",	--	Hmph!
                "vo\\n\\f\\Hlo_NF000d.mp3",	--	I won't waste my time on the likes of you.
                "vo\\n\\f\\Hlo_NF000e.mp3",	--	Get out of here!
                "vo\\n\\f\\Hlo_NF000e.mp3",	--	Get out of here!
                "vo\\n\\f\\Hlo_NF001.mp3",	--	Save your garbage talk for the trash.
                "vo\\n\\f\\Hlo_NF011.mp3",	--	If you're here for sympathy over your wounds, go find someone else to cry to.
                "vo\\n\\f\\Hlo_NF012.mp3",	--	What a mess.
                "vo\\n\\f\\Hlo_NF013.mp3",	--	Go die in someone else's shadow.
                "vo\\n\\f\\Hlo_NF014.mp3",	--	You have to be the most hideous thing I've ever seen.
                "vo\\n\\f\\Hlo_NF015.mp3",	--	What a mess. What happened? Did you fall off a cliff?
                "vo\\n\\f\\Hlo_NF016.mp3",	--	Where'd you get those clothes? Off a corpse?
                "vo\\n\\f\\Hlo_NF017.mp3",	--	You must be joking.
                "vo\\n\\f\\Hlo_NF018.mp3",	--	You bloody thieves are all the same. Worthless.
                "vo\\n\\f\\Hlo_NF019.mp3",	--	They should hang the lot of you.
                "vo\\n\\f\\Hlo_NF020.mp3",	--	I took you for a corpse! Get away from me with that disease!
                "vo\\n\\f\\Hlo_NF021.mp3",	--	I've had enough of you.
                "vo\\n\\f\\Hlo_NF022.mp3",	--	Get out of here before you get hurt.
                "vo\\n\\f\\Hlo_NF023.mp3",	--	You must be joking.
                "vo\\n\\f\\Hlo_NF024.mp3",	--	Bother me again, and you might live to regret it.
                "vo\\n\\f\\Hlo_NF026.mp3",	--	If you're here for small talk, move along.
                "vo\\n\\f\\Hlo_NF027.mp3",	--	This is none of your business.
                "vo\\n\\f\\Hlo_NF028.mp3",	--	I don't think I want you around anymore.
                "vo\\n\\f\\Hlo_NF029.mp3",	--	Are you here to challenge me? I don't think so.
                "vo\\n\\f\\Hlo_NF030.mp3",	--	I think you should keep walking.
                "vo\\n\\f\\Hlo_NF040.mp3",	--	You risk your neck coming here.
                "vo\\n\\f\\Hlo_NF041.mp3",	--	Now what?
                "vo\\n\\f\\Hlo_NF042.mp3",	--	Look sharp.
                "vo\\n\\f\\Hlo_NF043.mp3",	--	I've seen better clothes on a corpse.
                "vo\\n\\f\\Hlo_NF044.mp3",	--	Take your filthy clothes away from me, beggar.
                "vo\\n\\f\\Hlo_NF045.mp3",	--	Do you dress like that on purpose?
                "vo\\n\\f\\Hlo_NF046.mp3",	--	You're too much trouble. Move on.
                "vo\\n\\f\\Hlo_NF047.mp3",	--	I've got no patience for petty criminals. Move on.
                "vo\\n\\f\\Hlo_NF048.mp3",	--	I can't help you. Get healed elsewhere.
                "vo\\n\\f\\Hlo_NF049.mp3",	--	By the gods, you're half-dead.
                "vo\\n\\f\\Hlo_NF050.mp3",	--	You're almost dead and you want to talk? Get healed and leave me be.
                "vo\\n\\f\\Hlo_NF051.mp3",	--	You look ridiculous. Cover yourself!
                "vo\\n\\f\\Hlo_NF052.mp3",	--	Go away, you diseased fool.
                "vo\\n\\f\\Hlo_NF053.mp3",	--	Someone should teach you some manners.
                "vo\\n\\f\\Hlo_NF054.mp3",	--	Say your piece or stand aside.
                "vo\\n\\f\\Hlo_NF055.mp3",	--	By the gods! You tourists are a nuisance!
                "vo\\n\\f\\Hlo_NF056.mp3",	--	Ask, or get going!
                "vo\\n\\f\\Hlo_NF057.mp3",	--	Don't stand about.
                "vo\\n\\f\\Hlo_NF058.mp3",	--	What say you?
                "vo\\n\\f\\Hlo_NF059.mp3",	--	You like to walk a fine line, don't you?
                "vo\\n\\f\\Hlo_NF060.mp3",	--	Don't press your luck. You're on your honor.
                "vo\\n\\f\\Hlo_NF061.mp3",	--	Come on then, say something or move on.
                "vo\\n\\f\\Hlo_NF062.mp3",	--	Are you new here?
                "vo\\n\\f\\Hlo_NF063.mp3",	--	What is it, lad?
                "vo\\n\\f\\Hlo_NF073.mp3",	--	The blight is unforgiving. Get inside.
                "vo\\n\\f\\Hlo_NF074.mp3",	--	Can't see a thing in this mess.
                "vo\\n\\f\\Hlo_NF075.mp3",	--	Looks like we're all going to get soaked.
                "vo\\n\\f\\Hlo_NF076.mp3",	--	And a fine day to you.
                "vo\\n\\f\\Hlo_NF077.mp3",	--	On your way.
                "vo\\n\\f\\Hlo_NF078.mp3",	--	Hail.
                "vo\\n\\f\\Hlo_NF079.mp3",	--	I can't help you. Get healed elsewhere.
                "vo\\n\\f\\Hlo_NF080.mp3",	--	By the gods, you're half-dead.
                "vo\\n\\f\\Hlo_NF081.mp3",	--	You're almost dead and you want to talk? Get healed and leave me be.
                "vo\\n\\f\\Hlo_NF082.mp3",	--	May the wind be on your back.
                "vo\\n\\f\\Hlo_NF083.mp3",	--	Speak up.
                "vo\\n\\f\\Hlo_NF084.mp3",	--	Head on.
                "vo\\n\\f\\Hlo_NF085.mp3",	--	What's your story?
                "vo\\n\\f\\Hlo_NF086.mp3",	--	Seen any elves?
                "vo\\n\\f\\Hlo_NF087.mp3",	--	What's this all about?
                "vo\\n\\f\\Hlo_NF088.mp3",	--	I take it you want something. Well, what is it?
                "vo\\n\\f\\Hlo_NF089.mp3",	--	Today's your lucky day, so let's hear it.
                "vo\\n\\f\\Hlo_NF090.mp3",	--	You've got the better of me. So go ahead.
                "vo\\n\\f\\Hlo_NF091.mp3",	--	Ho! What's your pleasure?
                "vo\\n\\f\\Hlo_NF092.mp3",	--	Hail.
                "vo\\n\\f\\Hlo_NF102.mp3",	--	You've taken a few knocks. Maybe you should get healed.
                "vo\\n\\f\\Hlo_NF103.mp3",	--	Those wounds seem serious, friend.
                "vo\\n\\f\\Hlo_NF104.mp3",	--	Ack! You're nearly dead! You should be healed!
                "vo\\n\\f\\Hlo_NF105.mp3",	--	Trouble surrounds you. I think we should not be seen together.
                "vo\\n\\f\\Hlo_NF106.mp3",	--	Hmm. You're not here to start trouble, are you?
                "vo\\n\\f\\Hlo_NF108.mp3",	--	Aren't you a sight? What can I do for you?
                "vo\\n\\f\\Hlo_NF109.mp3",	--	Well met.
                "vo\\n\\f\\Hlo_NF110.mp3",	--	No worries, I won't hurt you. Ask your question.
                "vo\\n\\f\\Hlo_NF111.mp3",	--	I'm ready for anything. Go ahead.
                "vo\\n\\f\\Hlo_NF112.mp3",	--	That's how I like it, bold and direct! Come, I like you.
                "vo\\n\\f\\Hlo_NF113.mp3",	--	Now here's one who can hold their own. How are you?
                "vo\\n\\f\\Hlo_NF114.mp3",	--	If you need a good laugh or a tall tale, you've come to the right place.
                "vo\\n\\f\\Hlo_NF115.mp3",	--	Well, this is a grand day. Greetings.
                "vo\\n\\f\\Hlo_NF116.mp3",	--	Care to talk. You're a welcome break from the locals!
                "vo\\n\\f\\Hlo_NF117.mp3",	--	Salute! Welcome! Please say your piece.
                "vo\\n\\f\\Hlo_NF128.mp3",	--	How dreadful friend. Those are some wounds. Maybe you should get healed.
                "vo\\n\\f\\Hlo_NF129.mp3",	--	Those wounds seem serious, friend.
                "vo\\n\\f\\Hlo_NF130.mp3",	--	You're nearly dead! You should be healed!
                "vo\\n\\f\\Hlo_NF132.mp3",	--	I see we share the same company. What can I do for you?
                "vo\\n\\f\\Hlo_NF133.mp3",	--	Did you forget your clothes?
                "vo\\n\\f\\Hlo_NF134.mp3",	--	Well, here's a fine one! Speak freely.
                "vo\\n\\f\\Hlo_NF135.mp3",	--	Welcome, friend. Hail!
                "vo\\n\\f\\Hlo_NF136.mp3",	--	Ah, you bring good fortune with you. Welcome.
                "vo\\n\\f\\Hlo_NF137.mp3",	--	You choose you share your time to me? You humble me.
                "vo\\n\\f\\Hlo_NF138.mp3",	--	Die creature! Be gone with you!
                "vo\\n\\f\\Idl_NF001.mp3",	--	What makes this smell?
                "vo\\n\\f\\Idl_NF001.mp3",	--	What makes this smell?
                "vo\\n\\f\\Idl_NF002.mp3",	--	I haven't seen that before.
                "vo\\n\\f\\Idl_NF002.mp3",	--	I haven't seen that before.
                "vo\\n\\f\\Idl_NF003.mp3",	--	Bloody scamps. I could skin them all.
                "vo\\n\\f\\Idl_NF003.mp3",	--	Bloody scamps. I could skin them all.
                "vo\\n\\f\\Idl_NF004.mp3",	--	What makes this smell?
                "vo\\n\\f\\Idl_NF004.mp3",	--	What makes this smell?
                "vo\\n\\f\\Idl_NF005.mp3",	--	Sniff.
                "vo\\n\\f\\Idl_NF005.mp3",	--	Sniff.
                "vo\\n\\f\\Idl_NF006.mp3",	--	Humms.
                "vo\\n\\f\\Idl_NF006.mp3",	--	Humms.
                "vo\\n\\f\\Idl_NF007.mp3",	--	Cough.
                "vo\\n\\f\\Idl_NF007.mp3",	--	Cough.
                "vo\\n\\f\\Idl_NF008.mp3",	--	Whistle
                "vo\\n\\f\\Idl_NF008.mp3",	--	Whistle
                "vo\\n\\f\\Idl_NF009.mp3",	--	Ugh! Disgusting!
                "vo\\n\\f\\Idl_NF009.mp3",	--	Ugh! Disgusting!
            },
        },
        ["m"] = {
            [this.voice.continue] = {
            },
            [this.voice.finish] = {
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
            },
            [this.voice.think] = {
            },
            [this.voice.remind] = {
                "vo\\n\\m\\Atk_NM001.mp3",	--	You will die where you stand!
                "vo\\n\\m\\Atk_NM002.mp3",	--	ARRRR!
                "vo\\n\\m\\Atk_NM003.mp3",	--	HAAAA!
                "vo\\n\\m\\Atk_NM004.mp3",	--	Fool!
                "vo\\n\\m\\Atk_NM005.mp3",	--	Give in! You're dead already!
                "vo\\n\\m\\Atk_NM006.mp3",	--	You should've picked an easier opponent!
                "vo\\n\\m\\Atk_NM007.mp3",	--	I will bathe in your blood.
                "vo\\n\\m\\Atk_NM008.mp3",	--	Now this is fighting!
                "vo\\n\\m\\Atk_NM009.mp3",	--	You're bested!
                "vo\\n\\m\\Atk_NM010.mp3",	--	How does it feel to know death is near?
                "vo\\n\\m\\Atk_NM011.mp3",	--	You're growing weak!
                "vo\\n\\m\\Atk_NM012.mp3",	--	Run while you still can, child!
                "vo\\n\\m\\Atk_NM013.mp3",	--	This is too easy!
                "vo\\n\\m\\Atk_NM020.mp3",	--	It will be your blood here, not mine!
                "vo\\n\\m\\bAtk_NM001.mp3",	--	Taste my silver, foul beast!
                "vo\\n\\m\\bAtk_NM002.mp3",	--	Your cursed bloodline ends here!
                "vo\\n\\m\\bAtk_NM003.mp3",	--	I've got the cure for your curse right here.
                "vo\\n\\m\\bAtk_NM004.mp3",	--	Kill the beast!
                "vo\\n\\m\\bAtk_NM005.mp3",	--	Your head will be my new trophy!
                "vo\\n\\m\\bAtk_NM006.mp3",	--	I've got a bone for you. Come and get it!
                "vo\\n\\m\\bAtk_NM007.mp3",	--	I'll take care of the small pup!
                "vo\\n\\m\\bAtk_NM008.mp3",	--	Your cursed bloodline ends here!
                "vo\\n\\m\\bAtk_NM009.mp3",	--	I've got the cure for your curse right here.
                "vo\\n\\m\\bFle_NM001.mp3",	--	Help! A beast!
                "vo\\n\\m\\bFle_NM002.mp3",	--	Get away, beast!
                "vo\\n\\m\\bFle_NM003.mp3",	--	Go away! I don't have any treats!
                "vo\\n\\m\\bFle_NM004.mp3",	--	Don't infect me with your curse!
                "vo\\n\\m\\bHlo_NM001.mp3",	--	By the Gods, it's good to see you again!
                "vo\\n\\m\\bHlo_NM002.mp3",	--	By the Gods, not you!  Get out of my house, cur!
                "vo\\n\\m\\bHlo_NM003.mp3",	--	You there! Can you help a warrior in trouble?
                "vo\\n\\m\\bHlo_NM004.mp3",	--	Did you see me? I fought like a wolf possessed! Ha!
                "vo\\n\\m\\bHlo_NM005.mp3",	--	I'd like you to meet Erna. We have a love my wife would never understand.
                "vo\\n\\m\\bHlo_NM006.mp3",	--	Yaawwwnnn!  Inside, outside, I'll sleep anywhere.
                "vo\\n\\m\\bHlo_NM007.mp3",	--	Yawwwwwnn! Hello again my friend. Thanks to you, I can sleep again. Yawwwnnn.....
                "vo\\n\\m\\bHlo_NM008.mp3",	--	Behold the sea, friend. Never will you meet a maiden so beautiful...or unforgiving.
                "vo\\n\\m\\bHlo_NM009.mp3",	--	My lord, I can craft armor worthy of a chieftain!
                "vo\\n\\m\\bHlo_NM010.mp3",	--	Did you see the size of that beast!
                "vo\\n\\m\\bHlo_NM011.mp3",	--	Come, friend! I make the best armor on all of Solstheim.
                "vo\\n\\m\\bHlo_NM012.mp3",	--	To Sovngarde!
                "vo\\n\\m\\bHlo_NM012.mp3",	--	To Sovngarde!
                "vo\\n\\m\\bHlo_NM013.mp3",	--	Enjoy our mead and kinship!
                "vo\\n\\m\\bHlo_NM014.mp3",	--	Well now, if you're not the comeliest lass I've ever laid eyes on. Come here, and let Big Erich keep you warm.
                "vo\\n\\m\\bHlo_NM015.mp3",	--	Keep your distance, friend, if you want to keep your head.
                "vo\\n\\m\\bHlo_NM016.mp3",	--	Thish is the besht mead hall anywhere, friend. You'll not find better in Shkyrim itshelf.
                "vo\\n\\m\\bHlo_NM017.mp3",	--	Have you found it? Have you found the entrance to Sovngarde?
                "vo\\n\\m\\bHlo_NM018.mp3",	--	Oddfrid tells me things, friend. Secret things.
                "vo\\n\\m\\bHlo_NM019.mp3",	--	They've taken my Oddfrid. My sweet, dear Oddfrid....
                "vo\\n\\m\\bHlo_NM020.mp3",	--	The forces of darkness are mine to command! All shall bow before the terrible power of Tymvaul the Dark!
                "vo\\n\\m\\bHlo_NM021.mp3",	--	My son.... My poor son.... Please, please help a sad old man.
                "vo\\n\\m\\bHlo_NM022.mp3",	--	The creatures have gone, and the lands are whole. Surely the All-Maker is pleased.
                "vo\\n\\m\\bHlo_NM023.mp3",	--	The Ristaag is complete. Praise be to the All-Maker.
                "vo\\n\\m\\bHlo_NM024.mp3",	--	Greetings, Blodskaal. You and I must speak of the Ristaag.
                "vo\\n\\m\\bHlo_NM025.mp3",	--	You are not welcome here while you follow the path of the beast.
                "vo\\n\\m\\bHlo_NM026.mp3",	--	I know you have been infected by these werewolves.
                "vo\\n\\m\\bHlo_NM027.mp3",	--	I've only just arrived, and to this horror.
                "vo\\n\\m\\bHlo_NM028.mp3",	--	Travel back to the Skaal village. I will meet you there soon.
                "vo\\n\\m\\bHlo_NM029.mp3",	--	What of Aesliip, my friend?
                "vo\\n\\m\\bHlo_NM030.mp3",	--	Ah...you've arrived. These are strange times, my friend.
                "vo\\n\\m\\bHlo_NM031.mp3",	--	Hello again, friend. What may I do for you?
                "vo\\n\\m\\bHlo_NM032.mp3",	--	You were to perform the Ritual of the Gifts. I hope your way has been easy.
                "vo\\n\\m\\bHlo_NM033.mp3",	--	Greetings to you, wanderer. Why have you returned to our village?
                "vo\\n\\m\\bHlo_NM034.mp3",	--	My greetings to you, wanderer.
                "vo\\n\\m\\bHlo_NM035.mp3",	--	What can this smith do for you? Armor, weapons? Some conversation?
                "vo\\n\\m\\bHlo_NM036.mp3",	--	I have nothing to say. My time is done.
                "vo\\n\\m\\bHlo_NM037.mp3",	--	You know my crime. Get on with your job.
                "vo\\n\\m\\bHlo_NM038.mp3",	--	Yes? I understand you are investigating Engar Ice-Mane's theft.
                "vo\\n\\m\\bHlo_NM039.mp3",	--	This place! It is fit for a warrior like Heart-Fang!
                "vo\\n\\m\\bHlo_NM040.mp3",	--	You've returned from the lake! I trust you completed your task.
                "vo\\n\\m\\bHlo_NM041.mp3",	--	You are to prove your strength as a warrior of the Skaal.
                "vo\\n\\m\\bHlo_NM042.mp3",	--	You have done well, showing your loyalty and wisdom
                "vo\\n\\m\\bHlo_NM043.mp3",	--	You were to investigate a crime. Have you done this?
                "vo\\n\\m\\bHlo_NM044.mp3",	--	You have shown your loyalty to the Skaal.
                "vo\\n\\m\\bHlo_NM045.mp3",	--	You were told to perform the rituals needed to restore the power of the Skaal. What have you done?
                "vo\\n\\m\\bHlo_NM048.mp3",	--	There is no more to say to you, stranger. The Skaal wish you no harm, but you are not welcome here.
                "vo\\n\\m\\bHlo_NM049.mp3",	--	What do you want, stranger? Why are you among the Skaal?
                "vo\\n\\m\\bHlo_NM050.mp3",	--	What can Long-Tooth do for you?
                "vo\\n\\m\\bHlo_NM051.mp3",	--	The Spirit Bear is dead, and the Ristaag is nearly complete.
                "vo\\n\\m\\bHlo_NM052.mp3",	--	You and I must continue the Ristaag.
                "vo\\n\\m\\bHlo_NM053.mp3",	--	Shhh...we must hunt carefully and quietly. There is no time to talk.
                "vo\\n\\m\\bHlo_NM054.mp3",	--	Come back at nightfall, my friend. We will perform the Ristaag.
                "vo\\n\\m\\bHlo_NM055.mp3",	--	Greetings, Blodskaal. Korst Wind-Eye has told me much about you.
                "vo\\n\\m\\bHlo_NM056.mp3",	--	We must complete the Ristaag. The All-Maker demands this.
                "vo\\n\\m\\bHlo_NM057.mp3",	--	You have cleared my name and restored my honor. What can I do for you, my friend?
                "vo\\n\\m\\bHlo_NM058.mp3",	--	You, who are to be my judge, what would you ask of me?
                "vo\\n\\m\\bHlo_NM059.mp3",	--	Have you come for Stalhrim armor, friend?
                "vo\\n\\m\\bHlo_NM060.mp3",	--	Speak to Graring.
                "vo\\n\\m\\bHlo_NM061.mp3",	--	Begone, stranger.
                "vo\\n\\m\\bHlo_NM062.mp3",	--	What is it, friend?
                "vo\\n\\m\\bHlo_NM063.mp3",	--	We'll have no dealings with the likes of you. Begone.
                "vo\\n\\m\\bHlo_NM064.mp3",	--	You'll not infect me with your Devilry! I am here to defend Nature, and I'll do so at any cost! Now begone!
                "vo\\n\\m\\bHlo_NM065.mp3",	--	Look, I said I'll leave. Just stay away from me, will you?
                "vo\\n\\m\\bHlo_NM066.mp3",	--	Let's get a move on.
                "vo\\n\\m\\bHlo_NM067.mp3",	--	Be careful out here in the wild, friend. There's more roaming about than just wolves and bears.
                "vo\\n\\m\\bHlo_NM068.mp3",	--	"In the cave he met the beast, and cut quite short its evil feast! And when the Udyrfrykte did fall, the chieftain came and claimed his hall!"
                "vo\\n\\m\\bHlo_NM068a.mp3",	--	"In the cave she met the beast, and cut quite short its evil feast! And when the Udyrfrykte did fall, the chieftain came and claimed his hall!"
                "vo\\n\\m\\bHlo_NM069.mp3",	--	Werewolves in the Greathall! Get in there quickly!
                "vo\\n\\m\\bHlo_NM070.mp3",	--	Quickly, into the Greathall! Some of the beasts ran inside!
                "vo\\n\\m\\bHlo_NM071.mp3",	--	Let us fight through to the end.
                "vo\\n\\m\\bHlo_NM072.mp3",	--	No time for talk. The Hunt has begun!
                "vo\\n\\m\\bHlo_NM073.mp3",	--	You have returned. I would hear of your journey.
                "vo\\n\\m\\bHlo_NM074.mp3",	--	The Skaal will endure.
                "vo\\n\\m\\bHlo_NM075.mp3",	--	It is an honor, Blodskaal.
                "vo\\n\\m\\bIdl_NM001.mp3",	--	Cold enough for ya, eh?
                "vo\\n\\m\\bIdl_NM001.mp3",	--	Cold enough for ya, eh?
                "vo\\n\\m\\bIdl_NM001.mp3",	--	Cold enough for ya, eh?
                "vo\\n\\m\\bIdl_NM001.mp3",	--	Cold enough for ya, eh?
                "vo\\n\\m\\bIdl_NM001.mp3",	--	Cold enough for ya, eh?
                "vo\\n\\m\\bIdl_NM002.mp3",	--	My teeth itch.
                "vo\\n\\m\\bIdl_NM002.mp3",	--	My teeth itch.
                "vo\\n\\m\\bIdl_NM002.mp3",	--	My teeth itch.
                "vo\\n\\m\\bIdl_NM002.mp3",	--	My teeth itch.
                "vo\\n\\m\\bIdl_NM002.mp3",	--	My teeth itch.
                "vo\\n\\m\\bIdl_NM003.mp3",	--	You're a long way from civilization, pilgrim.
                "vo\\n\\m\\bIdl_NM003.mp3",	--	You're a long way from civilization, pilgrim.
                "vo\\n\\m\\bIdl_NM003.mp3",	--	You're a long way from civilization, pilgrim.
                "vo\\n\\m\\bIdl_NM003.mp3",	--	You're a long way from civilization, pilgrim.
                "vo\\n\\m\\bIdl_NM003.mp3",	--	You're a long way from civilization, pilgrim.
                "vo\\n\\m\\bIdl_NM004.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\n\\m\\bIdl_NM004.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\n\\m\\bIdl_NM004.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\n\\m\\bIdl_NM004.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\n\\m\\bIdl_NM004.mp3",	--	Ah... ah... AH... CHOOOO!
                "vo\\n\\m\\bIdl_NM005.mp3",	--	So, this tooth-paste-stuff... what's it for? Fixing old teeth?
                "vo\\n\\m\\bIdl_NM005.mp3",	--	So, this tooth-paste-stuff... what's it for? Fixing old teeth?
                "vo\\n\\m\\bIdl_NM005.mp3",	--	So, this tooth-paste-stuff... what's it for? Fixing old teeth?
                "vo\\n\\m\\bIdl_NM005.mp3",	--	So, this tooth-paste-stuff... what's it for? Fixing old teeth?
                "vo\\n\\m\\bIdl_NM005.mp3",	--	So, this tooth-paste-stuff... what's it for? Fixing old teeth?
                "vo\\n\\m\\bIdl_NM006.mp3",	--	Just rub a little bear grease on it -- be good as new.
                "vo\\n\\m\\bIdl_NM006.mp3",	--	Just rub a little bear grease on it -- be good as new.
                "vo\\n\\m\\bIdl_NM006.mp3",	--	Just rub a little bear grease on it -- be good as new.
                "vo\\n\\m\\bIdl_NM006.mp3",	--	Just rub a little bear grease on it -- be good as new.
                "vo\\n\\m\\bIdl_NM006.mp3",	--	Just rub a little bear grease on it -- be good as new.
                "vo\\n\\m\\bIdl_NM007.mp3",	--	He said it was fresh, but I don't know. It looked kinda like dog to me.
                "vo\\n\\m\\bIdl_NM007.mp3",	--	He said it was fresh, but I don't know. It looked kinda like dog to me.
                "vo\\n\\m\\bIdl_NM007.mp3",	--	He said it was fresh, but I don't know. It looked kinda like dog to me.
                "vo\\n\\m\\bIdl_NM007.mp3",	--	He said it was fresh, but I don't know. It looked kinda like dog to me.
                "vo\\n\\m\\bIdl_NM007.mp3",	--	He said it was fresh, but I don't know. It looked kinda like dog to me.
                "vo\\n\\m\\bIdl_NM008.mp3",	--	No, don't eat the skin, for gods sake. You don't know where it's been.
                "vo\\n\\m\\bIdl_NM008.mp3",	--	No, don't eat the skin, for gods sake. You don't know where it's been.
                "vo\\n\\m\\bIdl_NM008.mp3",	--	No, don't eat the skin, for gods sake. You don't know where it's been.
                "vo\\n\\m\\bIdl_NM008.mp3",	--	No, don't eat the skin, for gods sake. You don't know where it's been.
                "vo\\n\\m\\bIdl_NM008.mp3",	--	No, don't eat the skin, for gods sake. You don't know where it's been.
                "vo\\n\\m\\bIdl_NM010.mp3",	--	Some people are born dumb. Like me, for instance.
                "vo\\n\\m\\bIdl_NM010.mp3",	--	Some people are born dumb. Like me, for instance.
                "vo\\n\\m\\bIdl_NM010.mp3",	--	Some people are born dumb. Like me, for instance.
                "vo\\n\\m\\bIdl_NM010.mp3",	--	Some people are born dumb. Like me, for instance.
                "vo\\n\\m\\bIdl_NM010.mp3",	--	Some people are born dumb. Like me, for instance.
                "vo\\n\\m\\bIdl_NM011.mp3",	--	It was a rock. Who cares what kind of rock.
                "vo\\n\\m\\bIdl_NM011.mp3",	--	It was a rock. Who cares what kind of rock.
                "vo\\n\\m\\bIdl_NM011.mp3",	--	It was a rock. Who cares what kind of rock.
                "vo\\n\\m\\bIdl_NM011.mp3",	--	It was a rock. Who cares what kind of rock.
                "vo\\n\\m\\bIdl_NM011.mp3",	--	It was a rock. Who cares what kind of rock.
                "vo\\n\\m\\bIdl_NM012.mp3",	--	All this, and in the spring, mud and flies, too.
                "vo\\n\\m\\bIdl_NM012.mp3",	--	All this, and in the spring, mud and flies, too.
                "vo\\n\\m\\bIdl_NM012.mp3",	--	All this, and in the spring, mud and flies, too.
                "vo\\n\\m\\bIdl_NM012.mp3",	--	All this, and in the spring, mud and flies, too.
                "vo\\n\\m\\bIdl_NM012.mp3",	--	All this, and in the spring, mud and flies, too.
                "vo\\n\\m\\bIdl_NM013.mp3",	--	Well, at least being cold, wet, and miserable all the time gives us plenty to complain about.
                "vo\\n\\m\\bIdl_NM013.mp3",	--	Well, at least being cold, wet, and miserable all the time gives us plenty to complain about.
                "vo\\n\\m\\bIdl_NM013.mp3",	--	Well, at least being cold, wet, and miserable all the time gives us plenty to complain about.
                "vo\\n\\m\\bIdl_NM013.mp3",	--	Well, at least being cold, wet, and miserable all the time gives us plenty to complain about.
                "vo\\n\\m\\bIdl_NM013.mp3",	--	Well, at least being cold, wet, and miserable all the time gives us plenty to complain about.
                "vo\\n\\m\\bIdl_NM014.mp3",	--	*Pfbbbbbbbt*
                "vo\\n\\m\\bIdl_NM014.mp3",	--	*Pfbbbbbbbt*
                "vo\\n\\m\\bIdl_NM014.mp3",	--	*Pfbbbbbbbt*
                "vo\\n\\m\\bIdl_NM014.mp3",	--	*Pfbbbbbbbt*
                "vo\\n\\m\\bIdl_NM014.mp3",	--	*Pfbbbbbbbt*
                "vo\\n\\m\\bIdl_NM015.mp3",	--	Oh, not AGAIN!
                "vo\\n\\m\\bIdl_NM015.mp3",	--	Oh, not AGAIN!
                "vo\\n\\m\\bIdl_NM015.mp3",	--	Oh, not AGAIN!
                "vo\\n\\m\\bIdl_NM015.mp3",	--	Oh, not AGAIN!
                "vo\\n\\m\\bIdl_NM015.mp3",	--	Oh, not AGAIN!
                "vo\\n\\m\\bIdl_NM016.mp3",	--	[Wide yawn.]
                "vo\\n\\m\\bIdl_NM016.mp3",	--	[Wide yawn.]
                "vo\\n\\m\\bIdl_NM016.mp3",	--	[Wide yawn.]
                "vo\\n\\m\\bIdl_NM016.mp3",	--	[Wide yawn.]
                "vo\\n\\m\\bIdl_NM016.mp3",	--	[Wide yawn.]
                "vo\\n\\m\\bIdl_NM017.mp3",	--	Stranger and guest...
                "vo\\n\\m\\bIdl_NM018.mp3",	--	No guest of the Skaal shall want for hospitality.
                "vo\\n\\m\\bIdl_NM019.mp3",	--	Strange times, and stranger...
                "vo\\n\\m\\bIdl_NM020.mp3",	--	Strange signs, carried on the wind...
                "vo\\n\\m\\bIdl_NM021.mp3",	--	Uh-huh.
                "vo\\n\\m\\bIdl_NM021.mp3",	--	Uh-huh.
                "vo\\n\\m\\bIdl_NM021.mp3",	--	Uh-huh.
                "vo\\n\\m\\bIdl_NM021.mp3",	--	Uh-huh.
                "vo\\n\\m\\bIdl_NM022.mp3",	--	Right.
                "vo\\n\\m\\bIdl_NM022.mp3",	--	Right.
                "vo\\n\\m\\bIdl_NM022.mp3",	--	Right.
                "vo\\n\\m\\bIdl_NM022.mp3",	--	Right.
                "vo\\n\\m\\bIdl_NM023.mp3",	--	No point worrying about it.
                "vo\\n\\m\\bIdl_NM023.mp3",	--	No point worrying about it.
                "vo\\n\\m\\bIdl_NM023.mp3",	--	No point worrying about it.
                "vo\\n\\m\\bIdl_NM023.mp3",	--	No point worrying about it.
                "vo\\n\\m\\bIdl_NM024.mp3",	--	Just as well...
                "vo\\n\\m\\bIdl_NM024.mp3",	--	Just as well...
                "vo\\n\\m\\bIdl_NM024.mp3",	--	Just as well...
                "vo\\n\\m\\bIdl_NM024.mp3",	--	Just as well...
                "vo\\n\\m\\bIdl_NM025.mp3",	--	Could be worse. Probably will be.
                "vo\\n\\m\\bIdl_NM025.mp3",	--	Could be worse. Probably will be.
                "vo\\n\\m\\bIdl_NM025.mp3",	--	Could be worse. Probably will be.
                "vo\\n\\m\\bIdl_NM025.mp3",	--	Could be worse. Probably will be.
                "vo\\n\\m\\bIdl_NM026.mp3",	--	Wonder what HE'S up to.
                "vo\\n\\m\\bIdl_NM026.mp3",	--	Wonder what HE'S up to.
                "vo\\n\\m\\bIdl_NM026.mp3",	--	Wonder what HE'S up to.
                "vo\\n\\m\\bIdl_NM026.mp3",	--	Wonder what HE'S up to.
                "vo\\n\\m\\bIdl_NM027.mp3",	--	Wonder what SHE'S up to.
                "vo\\n\\m\\bIdl_NM027.mp3",	--	Wonder what SHE'S up to.
                "vo\\n\\m\\bIdl_NM027.mp3",	--	Wonder what SHE'S up to.
                "vo\\n\\m\\bIdl_NM027.mp3",	--	Wonder what SHE'S up to.
                "vo\\n\\m\\bIdl_NM028.mp3",	--	What a life.
                "vo\\n\\m\\bIdl_NM028.mp3",	--	What a life.
                "vo\\n\\m\\bIdl_NM028.mp3",	--	What a life.
                "vo\\n\\m\\bIdl_NM028.mp3",	--	What a life.
                "vo\\n\\m\\bIdl_NM029.mp3",	--	It's a hard life, but it's fair.
                "vo\\n\\m\\bIdl_NM029.mp3",	--	It's a hard life, but it's fair.
                "vo\\n\\m\\bIdl_NM029.mp3",	--	It's a hard life, but it's fair.
                "vo\\n\\m\\bIdl_NM029.mp3",	--	It's a hard life, but it's fair.
                "vo\\n\\m\\bIdl_NM030.mp3",	--	Oh, brother... not again....
                "vo\\n\\m\\bIdl_NM030.mp3",	--	Oh, brother... not again....
                "vo\\n\\m\\bIdl_NM030.mp3",	--	Oh, brother... not again....
                "vo\\n\\m\\bIdl_NM030.mp3",	--	Oh, brother... not again....
                "vo\\n\\m\\bIdl_NM031.mp3",	--	I'm still in pretty good shape... right?
                "vo\\n\\m\\bIdl_NM031.mp3",	--	I'm still in pretty good shape... right?
                "vo\\n\\m\\bIdl_NM031.mp3",	--	I'm still in pretty good shape... right?
                "vo\\n\\m\\bIdl_NM031.mp3",	--	I'm still in pretty good shape... right?
                "vo\\n\\m\\bIdl_NM032.mp3",	--	I took care of it... Didn't I?
                "vo\\n\\m\\bIdl_NM032.mp3",	--	I took care of it... Didn't I?
                "vo\\n\\m\\bIdl_NM032.mp3",	--	I took care of it... Didn't I?
                "vo\\n\\m\\bIdl_NM032.mp3",	--	I took care of it... Didn't I?
                "vo\\n\\m\\bIdl_NM033.mp3",	--	Look, don't tell me about YOUR problems....
                "vo\\n\\m\\bIdl_NM033.mp3",	--	Look, don't tell me about YOUR problems....
                "vo\\n\\m\\bIdl_NM033.mp3",	--	Look, don't tell me about YOUR problems....
                "vo\\n\\m\\bIdl_NM033.mp3",	--	Look, don't tell me about YOUR problems....
                "vo\\n\\m\\bIdl_NM034.mp3",	--	There is great power in this place.
                "vo\\n\\m\\bIdl_NM035.mp3",	--	Heart-Fang shall survive the Hunt.
                "vo\\n\\m\\bIdl_NM036.mp3",	--	The Bloodmoon is in the sky. Who knows what will befall us.
                "vo\\n\\m\\bIdl_NM037.mp3",	--	The signs have faded. The Prophecy is at an end.
                "vo\\n\\m\\Fle_NM001.mp3",	--	Not today.
                "vo\\n\\m\\Fle_NM002.mp3",	--	You've won this round.
                "vo\\n\\m\\Fle_NM003.mp3",	--	You fight unfair, this bout is over.
                "vo\\n\\m\\Fle_NM004.mp3",	--	End your fight, I'm leaving.
                "vo\\n\\m\\Fle_NM005.mp3",	--	End your fight, I'm leaving.
                "vo\\n\\m\\Flw_NM002.mp3",	--	Mind who you're fighting!
                "vo\\n\\m\\Hit_NM001.mp3",	--	Arrgh.
                "vo\\n\\m\\Hit_NM002.mp3",	--	Umpfh
                "vo\\n\\m\\Hit_NM003.mp3",	--	Ungh!
                "vo\\n\\m\\Hit_NM003.mp3",	--	Ungh.
                "vo\\n\\m\\Hit_NM004.mp3",	--	Hungh!
                "vo\\n\\m\\Hit_NM004.mp3",	--	Grunt.
                "vo\\n\\m\\Hit_NM005.mp3",	--	Groan.
                "vo\\n\\m\\Hit_NM006.mp3",	--	Growl.
                "vo\\n\\m\\Hit_NM007.mp3",	--	Cough
                "vo\\n\\m\\Hit_NM008.mp3",	--	Gasp.
                "vo\\n\\m\\Hit_NM009.mp3",	--	Arrgh!
                "vo\\n\\m\\Hit_NM009.mp3",	--	Scream.
                "vo\\n\\m\\Hit_NM010.mp3",	--	Yell.
                "vo\\n\\m\\Hit_NM011.mp3",	--	Grunt.
                "vo\\n\\m\\Hit_NM012.mp3",	--	Groan.
                "vo\\n\\m\\Hit_NM013.mp3",	--	Growl.
                "vo\\n\\m\\Hit_NM014.mp3",	--	Gasp.
                "vo\\n\\m\\Hlo_NM001.mp3",	--	Save your garbage talk for the trash.
                "vo\\n\\m\\Hlo_NM011.mp3",	--	If you're here for sympathy over your wounds, go find someone else to cry to.
                "vo\\n\\m\\Hlo_NM012.mp3",	--	What a mess.
                "vo\\n\\m\\Hlo_NM013.mp3",	--	Go die in someone else's shadow.
                "vo\\n\\m\\Hlo_NM014.mp3",	--	Where'd you get those clothes? Off a corpse?
                "vo\\n\\m\\Hlo_NM015.mp3",	--	What a mess. There's hardly a stitch on ye that's worth more than a kwama pile.
                "vo\\n\\m\\Hlo_NM016.mp3",	--	Where'd you get those clothes? Off a corpse?
                "vo\\n\\m\\Hlo_NM017.mp3",	--	You must be joking.
                "vo\\n\\m\\Hlo_NM018.mp3",	--	You bloody thieves are all the same. Worthless.
                "vo\\n\\m\\Hlo_NM019.mp3",	--	They should hang the lot of you.
                "vo\\n\\m\\Hlo_NM020.mp3",	--	I took you for a corpse! Get away from me with that disease!
                "vo\\n\\m\\Hlo_NM021.mp3",	--	I've had enough of you.
                "vo\\n\\m\\Hlo_NM022.mp3",	--	Get out of here, before you get hurt!
                "vo\\n\\m\\Hlo_NM022.mp3",	--	Get out of here before you get hurt.
                "vo\\n\\m\\Hlo_NM022.mp3",	--	Get out of here, before you get hurt!
                "vo\\n\\m\\Hlo_NM023.mp3",	--	You must be joking.
                "vo\\n\\m\\Hlo_NM024.mp3",	--	Bother me again, and you might live to regret it.
                "vo\\n\\m\\Hlo_NM026.mp3",	--	If you're here for a chit-chat, move along.
                "vo\\n\\m\\Hlo_NM027.mp3",	--	This is none of your business.
                "vo\\n\\m\\Hlo_NM028.mp3",	--	I don't think I want you around anymore.
                "vo\\n\\m\\Hlo_NM029.mp3",	--	Are you here to challenge me? I don't think so.
                "vo\\n\\m\\Hlo_NM030.mp3",	--	Keep walking.
                "vo\\n\\m\\Hlo_NM040.mp3",	--	You risk your neck coming here.
                "vo\\n\\m\\Hlo_NM041.mp3",	--	Now what?
                "vo\\n\\m\\Hlo_NM042.mp3",	--	Look sharp.
                "vo\\n\\m\\Hlo_NM043.mp3",	--	I've seen better clothes on a corpse.
                "vo\\n\\m\\Hlo_NM044.mp3",	--	Take your filthy clothes away from me, beggar.
                "vo\\n\\m\\Hlo_NM045.mp3",	--	Do you dress like that on purpose?
                "vo\\n\\m\\Hlo_NM046.mp3",	--	You're too much trouble. Move on.
                "vo\\n\\m\\Hlo_NM047.mp3",	--	I've got no patience for petty criminals. Move on.
                "vo\\n\\m\\Hlo_NM048.mp3",	--	Get healed elsewhere.
                "vo\\n\\m\\Hlo_NM049.mp3",	--	By the gods, you're half-dead.
                "vo\\n\\m\\Hlo_NM050.mp3",	--	You're almost dead and you want to talk? Get healed and leave me be.
                "vo\\n\\m\\Hlo_NM051.mp3",	--	Cover yourself!
                "vo\\n\\m\\Hlo_NM052.mp3",	--	Diseased fool. Go away.
                "vo\\n\\m\\Hlo_NM053.mp3",	--	Someone should teach you some manners.
                "vo\\n\\m\\Hlo_NM054.mp3",	--	Say your piece or stand aside.
                "vo\\n\\m\\Hlo_NM055.mp3",	--	By the gods! You tourists are a nuisance!
                "vo\\n\\m\\Hlo_NM056.mp3",	--	Ask, or get going!
                "vo\\n\\m\\Hlo_NM057.mp3",	--	Don't stand about.
                "vo\\n\\m\\Hlo_NM058.mp3",	--	What say you?
                "vo\\n\\m\\Hlo_NM059.mp3",	--	You like to dance close to the fire, don't you?
                "vo\\n\\m\\Hlo_NM060.mp3",	--	You're on your honor. Don't press your luck.
                "vo\\n\\m\\Hlo_NM061.mp3",	--	Come on then, say something or move on.
                "vo\\n\\m\\Hlo_NM062.mp3",	--	You new here?
                "vo\\n\\m\\Hlo_NM062.mp3",	--	You new here?
                "vo\\n\\m\\Hlo_NM062.mp3",	--	You new here?
                "vo\\n\\m\\Hlo_NM063.mp3",	--	What is it, lass?
                "vo\\n\\m\\Hlo_NM073.mp3",	--	You risk infection to the blight. Get inside.
                "vo\\n\\m\\Hlo_NM074.mp3",	--	Bloody ash. Can't see a thing.
                "vo\\n\\m\\Hlo_NM075.mp3",	--	I could use some dry clothes about now.
                "vo\\n\\m\\Hlo_NM076.mp3",	--	A fine day to you.
                "vo\\n\\m\\Hlo_NM077.mp3",	--	On your way.
                "vo\\n\\m\\Hlo_NM078.mp3",	--	Hail.
                "vo\\n\\m\\Hlo_NM079.mp3",	--	I can't help you. Get healed elsewhere.
                "vo\\n\\m\\Hlo_NM080.mp3",	--	By the gods, you're half-dead.
                "vo\\n\\m\\Hlo_NM081.mp3",	--	You're almost dead and you want to talk? Get healed and leave me be.
                "vo\\n\\m\\Hlo_NM082.mp3",	--	May the wind be on your back.
                "vo\\n\\m\\Hlo_NM083.mp3",	--	Speak up.
                "vo\\n\\m\\Hlo_NM084.mp3",	--	Head on.
                "vo\\n\\m\\Hlo_NM085.mp3",	--	What's your story?
                "vo\\n\\m\\Hlo_NM086.mp3",	--	Seen any elves?
                "vo\\n\\m\\Hlo_NM087.mp3",	--	What's this all about?
                "vo\\n\\m\\Hlo_NM088.mp3",	--	I take it you want something. Well, what is it?
                "vo\\n\\m\\Hlo_NM089.mp3",	--	Today's your lucky day, so let's hear it.
                "vo\\n\\m\\Hlo_NM090.mp3",	--	You've got the better of me. So go ahead.
                "vo\\n\\m\\Hlo_NM092.mp3",	--	Hail.
                "vo\\n\\m\\Hlo_NM102.mp3",	--	You've taken a few knocks. Maybe you should get healed.
                "vo\\n\\m\\Hlo_NM103.mp3",	--	Those wounds seem serious, friend.
                "vo\\n\\m\\Hlo_NM104.mp3",	--	You're nearly dead! You should be healed!
                "vo\\n\\m\\Hlo_NM105.mp3",	--	Trouble surrounds you. I think we should not be seen together.
                "vo\\n\\m\\Hlo_NM106.mp3",	--	Hello. Hmm. You're not here to start trouble, are you?
                "vo\\n\\m\\Hlo_NM108.mp3",	--	Aren't you a sight? What can I do for you?
                "vo\\n\\m\\Hlo_NM109.mp3",	--	Well met.
                "vo\\n\\m\\Hlo_NM110.mp3",	--	No worries, I won't hurt you. Ask your question.
                "vo\\n\\m\\Hlo_NM111.mp3",	--	I'm ready for anything. Go ahead.
                "vo\\n\\m\\Hlo_NM112.mp3",	--	That's how I like it, bold and direct! Come, I like you.
                "vo\\n\\m\\Hlo_NM113.mp3",	--	Now here's one who can hold their own. How are you?
                "vo\\n\\m\\Hlo_NM114.mp3",	--	If you need a good laugh or a tall tale, you've come to the right place.
                "vo\\n\\m\\Hlo_NM115.mp3",	--	This is a grand day. Greetings.
                "vo\\n\\m\\Hlo_NM116.mp3",	--	Hey, care to talk. You're a welcome break from the locals!
                "vo\\n\\m\\Hlo_NM117.mp3",	--	Salute! Welcome! Please say your piece.
                "vo\\n\\m\\Hlo_NM128.mp3",	--	How dreadful, friend. You've taken a few knocks. Maybe you should get healed.
                "vo\\n\\m\\Hlo_NM129.mp3",	--	Those wounds seem serious, friend.
                "vo\\n\\m\\Hlo_NM130.mp3",	--	Ack! You're nearly dead! You should be healed!
                "vo\\n\\m\\Hlo_NM132.mp3",	--	We share the same company. What can I do for you?
                "vo\\n\\m\\Hlo_NM133.mp3",	--	Forget your clothes?
                "vo\\n\\m\\Hlo_NM134.mp3",	--	Well, here's a fine one! Speak freely.
                "vo\\n\\m\\Hlo_NM135.mp3",	--	Hail and welcome, friend. Hail!
                "vo\\n\\m\\Hlo_NM136.mp3",	--	Ah, you bring good fortune with you. Welcome.
                "vo\\n\\m\\Hlo_NM137.mp3",	--	You choose to share your time to me? You humble me.
                "vo\\n\\m\\Hlo_NM138.mp3",	--	Die creature! Be gone with you!
                "vo\\n\\m\\Idl_NM001.mp3",	--	What makes this smell?
                "vo\\n\\m\\Idl_NM001.mp3",	--	What makes this smell?
                "vo\\n\\m\\Idl_NM002.mp3",	--	Cough.
                "vo\\n\\m\\Idl_NM002.mp3",	--	Cough.
                "vo\\n\\m\\Idl_NM002.mp3",	--	Cough.
                "vo\\n\\m\\Idl_NM003.mp3",	--	Sniff.
                "vo\\n\\m\\Idl_NM003.mp3",	--	Sniff.
                "vo\\n\\m\\Idl_NM003.mp3",	--	Sniff.
                "vo\\n\\m\\Idl_NM004.mp3",	--	Cough.
                "vo\\n\\m\\Idl_NM004.mp3",	--	Cough.
                "vo\\n\\m\\Idl_NM005.mp3",	--	Whistle.
                "vo\\n\\m\\Idl_NM005.mp3",	--	Whistle.
                "vo\\n\\m\\Idl_NM006.mp3",	--	Humm.
                "vo\\n\\m\\Idl_NM006.mp3",	--	Humm.
                "vo\\n\\m\\Idl_NM007.mp3",	--	Cough.
                "vo\\n\\m\\Idl_NM007.mp3",	--	Cough.
                "vo\\n\\m\\Idl_NM008.mp3",	--	Whistle.
                "vo\\n\\m\\Idl_NM008.mp3",	--	Whistle.
                "vo\\n\\m\\Idl_NM009.mp3",	--	Humm.
                "vo\\n\\m\\Idl_NM009.mp3",	--	Humm.
                "vo\\n\\m\\sweetshare01.mp3",	--	He he! Ha ho! To the worskhop he will go!
                "vo\\n\\m\\sweetshare02.mp3",	--	My Uncle's candy is so sweet! It's such a yummy winter's treat!
                "vo\\n\\m\\sweetshare03.mp3",	--	When the sugar is warmed by the pale hearth light, the happiness spreads throughout the night!
                "vo\\n\\m\\sweetshare04.mp3",	--	Uncle Sweetshare is coming near, to spread his candy and his cheer!
                "vo\\n\\m\\sweetshare05.mp3",	--	It's better than trinkets, games or toys! So say all the little girls and boys!
                "vo\\n\\m\\sweetshare06.mp3",	--	Candy, candy -- he makes so much! Uncle Sweetshare has a magic touch!
                "vo\\n\\m\\sweetshare07.mp3",	--	So it's back to the workshop in the snow! With lovely lanterns all aglow! He he! Ha ho! He he he ha ha ho!
                "vo\\n\\m\\sweetshare08.mp3",	--	Candy, candy -- he makes so much! Uncle Sweetshare has a magic touch! So it's back to the workshop in the snow! With lovely lanterns all aglow! He he! Ha ho! He he he ha ha ho!
            },
        },
    },
    ["orc"] = {
        ["f"] = {
            [this.voice.continue] = {
            },
            [this.voice.finish] = {
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
            },
            [this.voice.think] = {
            },
            [this.voice.remind] = {
                "vo\\o\\f\\Atk_OF001.mp3",	--	You will die here.
                "vo\\o\\f\\Atk_OF002.mp3",	--	Die with honor, coward!
                "vo\\o\\f\\Atk_OF003.mp3",	--	No surrender! No mercy!
                "vo\\o\\f\\Atk_OF004.mp3",	--	Give up.
                "vo\\o\\f\\Atk_OF005.mp3",	--	Now you die.
                "vo\\o\\f\\Atk_OF006.mp3",	--	You grow weak.
                "vo\\o\\f\\Atk_OF007.mp3",	--	Weakling!
                "vo\\o\\f\\Atk_OF008.mp3",	--	Coward!
                "vo\\o\\f\\Atk_OF009.mp3",	--	You fight like a child!
                "vo\\o\\f\\Atk_OF010.mp3",	--	Escape while you can.
                "vo\\o\\f\\Atk_OF012.mp3",	--	I will kill you quickly.
                "vo\\o\\f\\Atk_OF013.mp3",	--	You will bring me great honor.
                "vo\\o\\f\\Atk_OF014.mp3",	--	You are a fool to fight me.
                "vo\\o\\f\\Atk_OF015.mp3",	--	Our blood is made for fighting!
                "vo\\o\\f\\Fle_OF001.mp3",	--	This one is too strong for me.
                "vo\\o\\f\\Fle_OF002.mp3",	--	Help.
                "vo\\o\\f\\Fle_OF003.mp3",	--	This fight is over.
                "vo\\o\\f\\Fle_OF004.mp3",	--	I have no more quarrel with you.
                "vo\\o\\f\\Fle_OF005.mp3",	--	I have no more quarrel with you.
                "vo\\o\\f\\Flw_OF002.mp3",	--	Please! Be careful!
                "vo\\o\\f\\Flw_OF005.mp3",	--	I'm on your side!
                "vo\\o\\f\\Hit_OF001.mp3",	--	AAAIIEE.
                "vo\\o\\f\\Hit_OF002.mp3",	--	Arrgh.
                "vo\\o\\f\\Hit_OF003.mp3",	--	Fetcher!
                "vo\\o\\f\\Hit_OF004.mp3",	--	Groan.
                "vo\\o\\f\\Hit_OF005.mp3",	--	AAAIIEE.
                "vo\\o\\f\\Hit_OF006.mp3",	--	AAAIIEE.
                "vo\\o\\f\\Hit_OF007.mp3",	--	Arrgh.
                "vo\\o\\f\\Hit_OF008.mp3",	--	Ughn!
                "vo\\o\\f\\Hit_OF009.mp3",	--	Groan.
                "vo\\o\\f\\Hit_OF010.mp3",	--	Groan.
                "vo\\o\\f\\Hit_OF011.mp3",	--	Arrgh!
                "vo\\o\\f\\Hit_OF011.mp3",	--	Groan.
                "vo\\o\\f\\Hit_OF012.mp3",	--	Groan.
                "vo\\o\\f\\Hit_OF013.mp3",	--	Grunt.
                "vo\\o\\f\\Hit_OF014.mp3",	--	Ungh!
                "vo\\o\\f\\Hit_OF014.mp3",	--	Grunt.
                "vo\\o\\f\\Hit_OF015.mp3",	--	Grunt.
                "vo\\o\\f\\Hlo_OF000a.mp3",	--	What?!
                "vo\\o\\f\\Hlo_OF000b.mp3",	--	Humph!
                "vo\\o\\f\\Hlo_OF000c.mp3",	--	Hmph!
                "vo\\o\\f\\Hlo_OF000d.mp3",	--	I won't warn you further. Leave.
                "vo\\o\\f\\Hlo_OF000e.mp3",	--	Get out of here!
                "vo\\o\\f\\Hlo_OF000e.mp3",	--	Get out of here!
                "vo\\o\\f\\Hlo_OF001.mp3",	--	Anger me further and I will be forced to take action.
                "vo\\o\\f\\Hlo_OF011.mp3",	--	I cannot help you. Leave me alone.
                "vo\\o\\f\\Hlo_OF012.mp3",	--	I will add to your wounds if you don't go away.
                "vo\\o\\f\\Hlo_OF013.mp3",	--	Find somewhere else to die.
                "vo\\o\\f\\Hlo_OF014.mp3",	--	Is there a reason you're wearing those rags.
                "vo\\o\\f\\Hlo_OF015.mp3",	--	Those rags are repulsive.
                "vo\\o\\f\\Hlo_OF016.mp3",	--	Can't you steal better clothes?
                "vo\\o\\f\\Hlo_OF017.mp3",	--	That's disgusting. Dress yourself.
                "vo\\o\\f\\Hlo_OF019.mp3",	--	You prey on the weak. There is no honor in this.
                "vo\\o\\f\\Hlo_OF020.mp3",	--	You smell of sickness. Go away.
                "vo\\o\\f\\Hlo_OF021.mp3",	--	I've killed far worse than you.
                "vo\\o\\f\\Hlo_OF022.mp3",	--	By what right do you distrub me?
                "vo\\o\\f\\Hlo_OF023.mp3",	--	I haven't time for fools.
                "vo\\o\\f\\Hlo_OF024.mp3",	--	Do you seek a fight with me? If not, leave.
                "vo\\o\\f\\Hlo_OF025.mp3",	--	You're hardly worth my time.
                "vo\\o\\f\\Hlo_OF026.mp3",	--	So annoying.
                "vo\\o\\f\\Hlo_OF027.mp3",	--	There is no time for talk with you.
                "vo\\o\\f\\Hlo_OF028.mp3",	--	What now?
                "vo\\o\\f\\Hlo_OF029.mp3",	--	What?
                "vo\\o\\f\\Hlo_OF030.mp3",	--	You may ask your question, but make it quick.
                "vo\\o\\f\\Hlo_OF031.mp3",	--	Sera?
                "vo\\o\\f\\Hlo_OF041.mp3",	--	You have much to learn.
                "vo\\o\\f\\Hlo_OF042.mp3",	--	Get back to work.
                "vo\\o\\f\\Hlo_OF043.mp3",	--	What is it, peasant?
                "vo\\o\\f\\Hlo_OF044.mp3",	--	What are you supposed to be?
                "vo\\o\\f\\Hlo_OF045.mp3",	--	You must be blind to dress like that.
                "vo\\o\\f\\Hlo_OF046.mp3",	--	We cut off the hand that steals. Know this, thief.
                "vo\\o\\f\\Hlo_OF046.mp3",	--	We cut off the hand that steals. Know this, thief.
                "vo\\o\\f\\Hlo_OF047.mp3",	--	You prey on the weak. There is no honor in this.
                "vo\\o\\f\\Hlo_OF048.mp3",	--	I cannot help you. Leave me alone.
                "vo\\o\\f\\Hlo_OF049.mp3",	--	I will add to your wounds if you don't go away.
                "vo\\o\\f\\Hlo_OF050.mp3",	--	Ugh, find somewhere else to die.
                "vo\\o\\f\\Hlo_OF051.mp3",	--	You reveal too much of yourself.
                "vo\\o\\f\\Hlo_OF052.mp3",	--	Do you want to infect us all? Go away!
                "vo\\o\\f\\Hlo_OF053.mp3",	--	Hurry up, before I change my mind.
                "vo\\o\\f\\Hlo_OF054.mp3",	--	How do I know you can even be trusted?
                "vo\\o\\f\\Hlo_OF055.mp3",	--	What are you doing?
                "vo\\o\\f\\Hlo_OF056.mp3",	--	Do not waste my time.
                "vo\\o\\f\\Hlo_OF056.mp3",	--	Do not waste my time.
                "vo\\o\\f\\Hlo_OF056.mp3",	--	Do not waste my time.
                "vo\\o\\f\\Hlo_OF057.mp3",	--	Say your needs.
                "vo\\o\\f\\Hlo_OF058.mp3",	--	Say your business.
                "vo\\o\\f\\Hlo_OF059.mp3",	--	Say your words.
                "vo\\o\\f\\Hlo_OF060.mp3",	--	Yes?
                "vo\\o\\f\\Hlo_OF061.mp3",	--	Speak quickly.
                "vo\\o\\f\\Hlo_OF062.mp3",	--	Ask and I will listen.
                "vo\\o\\f\\Hlo_OF073.mp3",	--	I wonder. Does the sun ever shine here?
                "vo\\o\\f\\Hlo_OF074.mp3",	--	It seems nature's wrath is upon us.
                "vo\\o\\f\\Hlo_OF075.mp3",	--	I hate this weather.
                "vo\\o\\f\\Hlo_OF076.mp3",	--	Pleasant weather, don't you think?
                "vo\\o\\f\\Hlo_OF077.mp3",	--	Move on.
                "vo\\o\\f\\Hlo_OF078.mp3",	--	Yes, what is it?
                "vo\\o\\f\\Hlo_OF079.mp3",	--	Hardly a scratch.
                "vo\\o\\f\\Hlo_OF080.mp3",	--	You suffer from wounds.
                "vo\\o\\f\\Hlo_OF081.mp3",	--	Your wounds are great.
                "vo\\o\\f\\Hlo_OF082.mp3",	--	Adventure lies beyond the cities, friend.
                "vo\\o\\f\\Hlo_OF083.mp3",	--	Strength is a virtue, friend. Welcome
                "vo\\o\\f\\Hlo_OF084.mp3",	--	May your battles show only victory, friend.
                "vo\\o\\f\\Hlo_OF085.mp3",	--	Citizen.
                "vo\\o\\f\\Hlo_OF086.mp3",	--	I greet you as a friend.
                "vo\\o\\f\\Hlo_OF087.mp3",	--	Your actions show promise. What do you want?
                "vo\\o\\f\\Hlo_OF088.mp3",	--	There is much to discuss. Much to learn.
                "vo\\o\\f\\Hlo_OF089.mp3",	--	You seem worthy of my knowledge. You may speak.
                "vo\\o\\f\\Hlo_OF090.mp3",	--	What is your business here?
                "vo\\o\\f\\Hlo_OF091.mp3",	--	Friend.
                "vo\\o\\f\\Hlo_OF092.mp3",	--	Have you any news?
                "vo\\o\\f\\Hlo_OF105.mp3",	--	Your crimes are known to us. Perhaps you should leave.
                "vo\\o\\f\\Hlo_OF106.mp3",	--	I know of your taste for crime. Be warned.
                "vo\\o\\f\\Hlo_OF107.mp3",	--	You bring infection with you. Go away.
                "vo\\o\\f\\Hlo_OF108.mp3",	--	My attention is yours.
                "vo\\o\\f\\Hlo_OF109.mp3",	--	You need not be afraid. Only fools earn my anger.
                "vo\\o\\f\\Hlo_OF110.mp3",	--	You're not what I expected. You've earned my trust.
                "vo\\o\\f\\Hlo_OF111.mp3",	--	You can speak freely. Friend to friend.
                "vo\\o\\f\\Hlo_OF112.mp3",	--	Hail. May your adventures be great.
                "vo\\o\\f\\Hlo_OF113.mp3",	--	Greetings. May fortune be with you.
                "vo\\o\\f\\Hlo_OF114.mp3",	--	How can I help you, friend?
                "vo\\o\\f\\Hlo_OF115.mp3",	--	Do not fear friend, I will assist you however I can.
                "vo\\o\\f\\Hlo_OF116.mp3",	--	Such good company. Welcome.
                "vo\\o\\f\\Hlo_OF117.mp3",	--	You interest me. Please, speak freely.
                "vo\\o\\f\\Hlo_OF118.mp3",	--	I would be honored if you would share your company.
                "vo\\o\\f\\Hlo_OF128.mp3",	--	You've been wounded.
                "vo\\o\\f\\Hlo_OF129.mp3",	--	Such wounds. They seem serious.
                "vo\\o\\f\\Hlo_OF130.mp3",	--	Such wounds. They seem very serious.
                "vo\\o\\f\\Hlo_OF132.mp3",	--	Welcome, friend.
                "vo\\o\\f\\Hlo_OF133.mp3",	--	Put that away!
                "vo\\o\\f\\Hlo_OF134.mp3",	--	I am honored. Truly. How may I help you?
                "vo\\o\\f\\Hlo_OF135.mp3",	--	A sincere welcome to you. May you be forever blessed.
                "vo\\o\\f\\Hlo_OF136.mp3",	--	Welcome, please speak.
                "vo\\o\\f\\Hlo_OF137.mp3",	--	I see you have great understanding, welcome.
                "vo\\o\\f\\Hlo_OF138.mp3",	--	Unholy beast! Go away!
                "vo\\o\\f\\Idl_OF001.mp3",	--	An oath is an oath.
                "vo\\o\\f\\Idl_OF001.mp3",	--	An oath is an oath.
                "vo\\o\\f\\Idl_OF002.mp3",	--	So careless, these creatures.
                "vo\\o\\f\\Idl_OF002.mp3",	--	So careless, these creatures.
                "vo\\o\\f\\Idl_OF003.mp3",	--	Clears throat.
                "vo\\o\\f\\Idl_OF003.mp3",	--	Clears throat.
                "vo\\o\\f\\Idl_OF004.mp3",	--	Cough.
                "vo\\o\\f\\Idl_OF004.mp3",	--	Cough.
                "vo\\o\\f\\Idl_OF005.mp3",	--	Sniff.
                "vo\\o\\f\\Idl_OF005.mp3",	--	Sniff.
                "vo\\o\\f\\Idl_OF006.mp3",	--	Cough.
                "vo\\o\\f\\Idl_OF006.mp3",	--	Cough.
                "vo\\o\\f\\Idl_OF007.mp3",	--	Need to practice more.
                "vo\\o\\f\\Idl_OF007.mp3",	--	Need to practice more.
                "vo\\o\\f\\Idl_OF008.mp3",	--	I don't care for those elves.
                "vo\\o\\f\\Idl_OF008.mp3",	--	I don't care for those elves.
                "vo\\o\\f\\Idl_OF009.mp3",	--	Finally something interesting.
                "vo\\o\\f\\Idl_OF009.mp3",	--	Finally something interesting.
            },
        },
        ["m"] = {
            [this.voice.continue] = {
            },
            [this.voice.finish] = {
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
            },
            [this.voice.think] = {
            },
            [this.voice.remind] = {
                "vo\\o\\m\\Atk_OM001.mp3",	--	You will die here.
                "vo\\o\\m\\Atk_OM002.mp3",	--	Arrrgh.
                "vo\\o\\m\\Atk_OM003.mp3",	--	Grunt.
                "vo\\o\\m\\Atk_OM004.mp3",	--	Give up.
                "vo\\o\\m\\Atk_OM005.mp3",	--	Now you die.
                "vo\\o\\m\\Atk_OM006.mp3",	--	You grow weak.
                "vo\\o\\m\\Atk_OM007.mp3",	--	Weakling!
                "vo\\o\\m\\Atk_OM008.mp3",	--	Coward!
                "vo\\o\\m\\Atk_OM009.mp3",	--	You fight like a child!
                "vo\\o\\m\\Atk_OM010.mp3",	--	Escape while you can.
                "vo\\o\\m\\Atk_OM011.mp3",	--	I will kill you quickly.
                "vo\\o\\m\\Atk_OM012.mp3",	--	You will bring me great honor.
                "vo\\o\\m\\Atk_OM013.mp3",	--	Your bones will be my dinner.
                "vo\\o\\m\\Atk_OM014.mp3",	--	You are a fool to fight me!
                "vo\\o\\m\\Fle_OM001.mp3",	--	This one is too strong for me!
                "vo\\o\\m\\Fle_OM002.mp3",	--	Help!
                "vo\\o\\m\\Fle_OM003.mp3",	--	This fight is over!
                "vo\\o\\m\\Fle_OM004.mp3",	--	I have no more quarrel with you.
                "vo\\o\\m\\Fle_OM005.mp3",	--	I have no more quarrel with you.
                "vo\\o\\m\\Flw_OM002.mp3",	--	Be careful!
                "vo\\o\\m\\Flw_OM005.mp3",	--	Watch what you're doing!
                "vo\\o\\m\\Hit_OM001.mp3",	--	AAAIIEE.
                "vo\\o\\m\\Hit_OM002.mp3",	--	Arrgh.
                "vo\\o\\m\\Hit_OM003.mp3",	--	Groan!
                "vo\\o\\m\\Hit_OM004.mp3",	--	Groan.
                "vo\\o\\m\\Hit_OM005.mp3",	--	AAAIIEE.
                "vo\\o\\m\\Hit_OM006.mp3",	--	AAAIIEE.
                "vo\\o\\m\\Hit_OM007.mp3",	--	Arrgh.
                "vo\\o\\m\\Hit_OM008.mp3",	--	Arrgh!
                "vo\\o\\m\\Hit_OM008.mp3",	--	Arrgh!
                "vo\\o\\m\\Hit_OM009.mp3",	--	Fetcher.
                "vo\\o\\m\\Hit_OM010.mp3",	--	Groan.
                "vo\\o\\m\\Hit_OM011.mp3",	--	Hurmph!
                "vo\\o\\m\\Hit_OM012.mp3",	--	Hargh!
                "vo\\o\\m\\Hit_OM013.mp3",	--	Hurragh!
                "vo\\o\\m\\Hit_OM014.mp3",	--	Grunt.
                "vo\\o\\m\\Hit_OM015.mp3",	--	Hurgh!
                "vo\\o\\m\\Hit_OM015.mp3",	--	Grunt.
                "vo\\o\\m\\Hlo_OM000.mp3",	--	Growl!
                "vo\\o\\m\\Hlo_OM000a.mp3",	--	Grrrrrr.
                "vo\\o\\m\\Hlo_OM000b.mp3",	--	Humph.
                "vo\\o\\m\\Hlo_OM000c.mp3",	--	Humph.
                "vo\\o\\m\\Hlo_OM000d.mp3",	--	You seek to challenge me?
                "vo\\o\\m\\Hlo_OM000d.mp3",	--	You seek to challenge me?
                "vo\\o\\m\\Hlo_OM000e.mp3",	--	Do not toy with me!
                "vo\\o\\m\\Hlo_OM001.mp3",	--	Anger me further, and I will be forced to take action.
                "vo\\o\\m\\Hlo_OM011.mp3",	--	I cannot help you. Leave me alone.
                "vo\\o\\m\\Hlo_OM012.mp3",	--	I will add to your wounds if you don't go away.
                "vo\\o\\m\\Hlo_OM013.mp3",	--	Ugh, find somewhere else to die.
                "vo\\o\\m\\Hlo_OM013.mp3",	--	Ugh, find somewhere else to die.
                "vo\\o\\m\\Hlo_OM013.mp3",	--	Ugh, find somewhere else to die.
                "vo\\o\\m\\Hlo_OM016.mp3",	--	You must be blind to dress like that.
                "vo\\o\\m\\Hlo_OM017.mp3",	--	That's disgusting. Dress yourself.
                "vo\\o\\m\\Hlo_OM018.mp3",	--	We cut of the hand that steals. Know this, thief.
                "vo\\o\\m\\Hlo_OM019.mp3",	--	You prey on the weak. There is no honor in this.
                "vo\\o\\m\\Hlo_OM020.mp3",	--	You smell of sickness. Go away.
                "vo\\o\\m\\Hlo_OM021.mp3",	--	I've killed far worse than you.
                "vo\\o\\m\\Hlo_OM021.mp3",	--	I've killed far worse than you.
                "vo\\o\\m\\Hlo_OM021.mp3",	--	I've killed far worse than you.
                "vo\\o\\m\\Hlo_OM022.mp3",	--	By what right do you disturb me?
                "vo\\o\\m\\Hlo_OM023.mp3",	--	I haven't time for fools.
                "vo\\o\\m\\Hlo_OM024.mp3",	--	Do you seek a fight with me? If not, leave.
                "vo\\o\\m\\Hlo_OM025.mp3",	--	You're hardly worth my time.
                "vo\\o\\m\\Hlo_OM026.mp3",	--	Annoying creature.
                "vo\\o\\m\\Hlo_OM027.mp3",	--	There is no time for talk with you.
                "vo\\o\\m\\Hlo_OM028.mp3",	--	What now?
                "vo\\o\\m\\Hlo_OM029.mp3",	--	What?
                "vo\\o\\m\\Hlo_OM030.mp3",	--	You may ask your question, but make it quick.
                "vo\\o\\m\\Hlo_OM030.mp3",	--	You may ask your question, but make it quick.
                "vo\\o\\m\\Hlo_OM030.mp3",	--	You may ask your question, but make it quick.
                "vo\\o\\m\\Hlo_OM031.mp3",	--	Sera?
                "vo\\o\\m\\Hlo_OM041.mp3",	--	You have much to learn.
                "vo\\o\\m\\Hlo_OM042.mp3",	--	Get back to work.
                "vo\\o\\m\\Hlo_OM043.mp3",	--	You must be blind to dress like that.
                "vo\\o\\m\\Hlo_OM044.mp3",	--	You must be blind to dress like that.
                "vo\\o\\m\\Hlo_OM045.mp3",	--	You must be blind to dress like that.
                "vo\\o\\m\\Hlo_OM046.mp3",	--	We cut of the hand that steals. Know this, thief.
                "vo\\o\\m\\Hlo_OM047.mp3",	--	You prey on the weak. There is no honor in this.
                "vo\\o\\m\\Hlo_OM048.mp3",	--	I cannot help you. Leave me alone.
                "vo\\o\\m\\Hlo_OM049.mp3",	--	I will add to your wounds if you don't go away.
                "vo\\o\\m\\Hlo_OM050.mp3",	--	Ugh, find somewhere else to die.
                "vo\\o\\m\\Hlo_OM051.mp3",	--	You reveal too much of yourself.
                "vo\\o\\m\\Hlo_OM052.mp3",	--	Do you want to infect us all? Go away!
                "vo\\o\\m\\Hlo_OM053.mp3",	--	Hurry up, before I change my mind.
                "vo\\o\\m\\Hlo_OM054.mp3",	--	Can you even be trusted?
                "vo\\o\\m\\Hlo_OM055.mp3",	--	What are you doing?
                "vo\\o\\m\\Hlo_OM056.mp3",	--	Do not waste my time.
                "vo\\o\\m\\Hlo_OM057.mp3",	--	Say your needs.
                "vo\\o\\m\\Hlo_OM058.mp3",	--	Say your business.
                "vo\\o\\m\\Hlo_OM059.mp3",	--	Say your words.
                "vo\\o\\m\\Hlo_OM060.mp3",	--	Yes?
                "vo\\o\\m\\Hlo_OM061.mp3",	--	Speak quickly.
                "vo\\o\\m\\Hlo_OM062.mp3",	--	Ask and I will listen.
                "vo\\o\\m\\Hlo_OM073.mp3",	--	I hate this weather.
                "vo\\o\\m\\Hlo_OM074.mp3",	--	I hate this weather.
                "vo\\o\\m\\Hlo_OM075.mp3",	--	I hate this weather.
                "vo\\o\\m\\Hlo_OM076.mp3",	--	Pleasant weather, don't you think?
                "vo\\o\\m\\Hlo_OM077.mp3",	--	Move on.
                "vo\\o\\m\\Hlo_OM078.mp3",	--	Yes, what is it?
                "vo\\o\\m\\Hlo_OM079.mp3",	--	You suffer from wounds.
                "vo\\o\\m\\Hlo_OM080.mp3",	--	You suffer from wounds.
                "vo\\o\\m\\Hlo_OM081.mp3",	--	Your wounds are great.
                "vo\\o\\m\\Hlo_OM082.mp3",	--	There are many creatures beyond the cities. Good hunting.
                "vo\\o\\m\\Hlo_OM083.mp3",	--	Fight well.
                "vo\\o\\m\\Hlo_OM084.mp3",	--	May your kills be quick and many.
                "vo\\o\\m\\Hlo_OM085.mp3",	--	Citizen.
                "vo\\o\\m\\Hlo_OM086.mp3",	--	I greet you as a friend.
                "vo\\o\\m\\Hlo_OM087.mp3",	--	Your actions show promise. What do you want?
                "vo\\o\\m\\Hlo_OM088.mp3",	--	There is much to discuss. Much to learn.
                "vo\\o\\m\\Hlo_OM089.mp3",	--	You seem worthy of my knowledge. You may speak.
                "vo\\o\\m\\Hlo_OM090.mp3",	--	And what is your business here? How may we help?
                "vo\\o\\m\\Hlo_OM091.mp3",	--	Friend.
                "vo\\o\\m\\Hlo_OM092.mp3",	--	Have you any news?
                "vo\\o\\m\\Hlo_OM105.mp3",	--	Your crimes are known to us. Perhaps you should leave.
                "vo\\o\\m\\Hlo_OM106.mp3",	--	I know of your taste for crime. Be warned.
                "vo\\o\\m\\Hlo_OM107.mp3",	--	You bring infection with you. Go away.
                "vo\\o\\m\\Hlo_OM108.mp3",	--	You have my ear.
                "vo\\o\\m\\Hlo_OM109.mp3",	--	You need not be afraid. My anger is reserved for the foolish.
                "vo\\o\\m\\Hlo_OM110.mp3",	--	You're not what I expected. You've earned my trust.
                "vo\\o\\m\\Hlo_OM111.mp3",	--	Greetings, friend to friend. May fortune be with you.
                "vo\\o\\m\\Hlo_OM112.mp3",	--	Hail. May your adventures be great.
                "vo\\o\\m\\Hlo_OM113.mp3",	--	Greetings. May fortune be with you.
                "vo\\o\\m\\Hlo_OM114.mp3",	--	How can I help you, friend?
                "vo\\o\\m\\Hlo_OM115.mp3",	--	Do not fear. I will assist you however I can.
                "vo\\o\\m\\Hlo_OM116.mp3",	--	Such good company. Welcome.
                "vo\\o\\m\\Hlo_OM117.mp3",	--	This one interests me.
                "vo\\o\\m\\Hlo_OM128.mp3",	--	You've been wounded, friend.
                "vo\\o\\m\\Hlo_OM129.mp3",	--	How did you come upon these wounds, friend? They seem serious.
                "vo\\o\\m\\Hlo_OM130.mp3",	--	How did you come upon these wounds, friend? They seem very serious.
                "vo\\o\\m\\Hlo_OM132.mp3",	--	A hail and hardy welcome, friend.
                "vo\\o\\m\\Hlo_OM133.mp3",	--	Put that away!
                "vo\\o\\m\\Hlo_OM134.mp3",	--	I am honored. Truly. How may I help you?
                "vo\\o\\m\\Hlo_OM135.mp3",	--	A sincere welcome to you. May you be forever blessed.
                "vo\\o\\m\\Hlo_OM136.mp3",	--	I feel I can truly share with you, without fear.
                "vo\\o\\m\\Hlo_OM137.mp3",	--	You have great understanding. Welcome.
                "vo\\o\\m\\Hlo_OM138.mp3",	--	Unholy beast! Go away!
                "vo\\o\\m\\Idl_OM001.mp3",	--	There it is again.
                "vo\\o\\m\\Idl_OM001.mp3",	--	There it is again.
                "vo\\o\\m\\Idl_OM002.mp3",	--	What was that?
                "vo\\o\\m\\Idl_OM002.mp3",	--	What was that?
                "vo\\o\\m\\Idl_OM003.mp3",	--	Growl.
                "vo\\o\\m\\Idl_OM003.mp3",	--	Growl.
                "vo\\o\\m\\Idl_OM004.mp3",	--	Hmmm.
                "vo\\o\\m\\Idl_OM004.mp3",	--	Hmmm.
                "vo\\o\\m\\Idl_OM005.mp3",	--	Sniff.
                "vo\\o\\m\\Idl_OM005.mp3",	--	Sniff.
                "vo\\o\\m\\Idl_OM006.mp3",	--	Cough.
                "vo\\o\\m\\Idl_OM006.mp3",	--	Cough.
                "vo\\o\\m\\Idl_OM007.mp3",	--	Clearing throat.
                "vo\\o\\m\\Idl_OM007.mp3",	--	Clearing throat.
                "vo\\o\\m\\Idl_OM009.mp3",	--	Probably nothing.
                "vo\\o\\m\\Idl_OM009.mp3",	--	Probably nothing.
            },
        },
    },
    ["redguard"] = {
        ["f"] = {
            [this.voice.continue] = {
            },
            [this.voice.finish] = {
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
            },
            [this.voice.think] = {
            },
            [this.voice.remind] = {
                "vo\\r\\f\\Atk_RF002.mp3",	--	Huh!
                "vo\\r\\f\\Atk_RF003.mp3",	--	Errgh!
                "vo\\r\\f\\Atk_RF004.mp3",	--	Stupid fetcher!
                "vo\\r\\f\\Atk_RF005.mp3",	--	I have the upper hand!
                "vo\\r\\f\\Atk_RF006.mp3",	--	I'm not giving up that easily.
                "vo\\r\\f\\Atk_RF007.mp3",	--	Run while you can.
                "vo\\r\\f\\Atk_RF008.mp3",	--	You're beaten!
                "vo\\r\\f\\Atk_RF009.mp3",	--	Hold still!
                "vo\\r\\f\\Atk_RF010.mp3",	--	You'll be dead soon.
                "vo\\r\\f\\Atk_RF012.mp3",	--	Am I good or what?
                "vo\\r\\f\\Atk_RF013.mp3",	--	I'll make this quick.
                "vo\\r\\f\\Atk_RF014.mp3",	--	Run or die!
                "vo\\r\\f\\Atk_RF015.mp3",	--	Here it comes!
                "vo\\r\\f\\Fle_RF001.mp3",	--	Not this time.
                "vo\\r\\f\\Fle_RF002.mp3",	--	We're done here!
                "vo\\r\\f\\Fle_RF003.mp3",	--	I'll be back, and you'll be dead!
                "vo\\r\\f\\Fle_RF004.mp3",	--	Not today!
                "vo\\r\\f\\Fle_RF005.mp3",	--	Get away from me!
                "vo\\r\\f\\Flw_RF002.mp3",	--	Please! Be careful!
                "vo\\r\\f\\Flw_RF005.mp3",	--	I'm on your side!
                "vo\\r\\f\\Hit_RF001.mp3",	--	Arrgh.
                "vo\\r\\f\\Hit_RF002.mp3",	--	Umpfh
                "vo\\r\\f\\Hit_RF003.mp3",	--	Ungh!
                "vo\\r\\f\\Hit_RF003.mp3",	--	Ungh.
                "vo\\r\\f\\Hit_RF004.mp3",	--	Grunt.
                "vo\\r\\f\\Hit_RF005.mp3",	--	Ungh!
                "vo\\r\\f\\Hit_RF006.mp3",	--	Growl.
                "vo\\r\\f\\Hit_RF008.mp3",	--	Ungh!
                "vo\\r\\f\\Hit_RF009.mp3",	--	Ungh!
                "vo\\r\\f\\Hit_RF009.mp3",	--	Ugnh!
                "vo\\r\\f\\Hit_RF010.mp3",	--	Ungh!
                "vo\\r\\f\\Hit_RF011.mp3",	--	Grunt!
                "vo\\r\\f\\Hit_RF012.mp3",	--	Groan.
                "vo\\r\\f\\Hit_RF013.mp3",	--	Growl.
                "vo\\r\\f\\Hit_RF014.mp3",	--	Gasp.
                "vo\\r\\f\\Hit_RF014.mp3",	--	Gasp.
                "vo\\r\\f\\Hlo_RF000a.mp3",	--	What?
                "vo\\r\\f\\Hlo_RF000b.mp3",	--	Humph.
                "vo\\r\\f\\Hlo_RF000c.mp3",	--	Humph.
                "vo\\r\\f\\Hlo_RF000d.mp3",	--	I won't waste my time on the likes of you.
                "vo\\r\\f\\Hlo_RF000e.mp3",	--	Get out of here!
                "vo\\r\\f\\Hlo_RF000e.mp3",	--	Get out of here!
                "vo\\r\\f\\Hlo_RF001.mp3",	--	I think it would be best if you leave. Now.
                "vo\\r\\f\\Hlo_RF011.mp3",	--	Go cry about your wounds to someone else.
                "vo\\r\\f\\Hlo_RF012.mp3",	--	Take your half-dead body away from me.
                "vo\\r\\f\\Hlo_RF013.mp3",	--	Ugh. I really think you should go find somewhere else to die.
                "vo\\r\\f\\Hlo_RF014.mp3",	--	What's the matter with you? Did scamps steal your clothes?
                "vo\\r\\f\\Hlo_RF015.mp3",	--	I can't believe what passes for clothing these days.
                "vo\\r\\f\\Hlo_RF016.mp3",	--	Now THAT is one ugly outfit.
                "vo\\r\\f\\Hlo_RF017.mp3",	--	Now that's something I didn't need to see.
                "vo\\r\\f\\Hlo_RF018.mp3",	--	You're a walking crimewave. Get away from me.
                "vo\\r\\f\\Hlo_RF019.mp3",	--	Petty thieves aren't on my guest list. Get lost.
                "vo\\r\\f\\Hlo_RF020.mp3",	--	Get out of here. What are you trying to do, make me sick?
                "vo\\r\\f\\Hlo_RF021.mp3",	--	I don't think so.
                "vo\\r\\f\\Hlo_RF022.mp3",	--	Get lost.
                "vo\\r\\f\\Hlo_RF023.mp3",	--	Ask somebody else, I'm busy.
                "vo\\r\\f\\Hlo_RF024.mp3",	--	If you're looking for trouble, you're getting very warm.
                "vo\\r\\f\\Hlo_RF025.mp3",	--	Watch it.
                "vo\\r\\f\\Hlo_RF026.mp3",	--	This better be important.
                "vo\\r\\f\\Hlo_RF027.mp3",	--	Keep walking.
                "vo\\r\\f\\Hlo_RF028.mp3",	--	Nothing's keeping you here. So move on.
                "vo\\r\\f\\Hlo_RF029.mp3",	--	Can't you be quiet?
                "vo\\r\\f\\Hlo_RF030.mp3",	--	I'm sure someone else can help you.
                "vo\\r\\f\\Hlo_RF040.mp3",	--	Hit the road, mister.
                "vo\\r\\f\\Hlo_RF041.mp3",	--	Speak.
                "vo\\r\\f\\Hlo_RF042.mp3",	--	Now what did I do to deserve this honor?
                "vo\\r\\f\\Hlo_RF043.mp3",	--	You look ridiculous. Stop bothering me.
                "vo\\r\\f\\Hlo_RF044.mp3",	--	Did your blind mother dress you this morning?
                "vo\\r\\f\\Hlo_RF045.mp3",	--	That's some outfit.
                "vo\\r\\f\\Hlo_RF046.mp3",	--	I don't want any part of this. Whatever it is.
                "vo\\r\\f\\Hlo_RF047.mp3",	--	If you value your freedom you'll mend your ways, thief.
                "vo\\r\\f\\Hlo_RF048.mp3",	--	I've seen healthier corpses than you. Get some healing attention!
                "vo\\r\\f\\Hlo_RF049.mp3",	--	Were you in a fight? Looks like you lost. Go get some healing.
                "vo\\r\\f\\Hlo_RF051.mp3",	--	Hey, put something on!
                "vo\\r\\f\\Hlo_RF052.mp3",	--	Get away before you infect all of us!
                "vo\\r\\f\\Hlo_RF053.mp3",	--	I don't know. You look like trouble to me.
                "vo\\r\\f\\Hlo_RF054.mp3",	--	How do I know you're not up to something devious?
                "vo\\r\\f\\Hlo_RF055.mp3",	--	There's something not right about you. Maybe you should go.
                "vo\\r\\f\\Hlo_RF056.mp3",	--	Talk with you? Something tells me I might regret it.
                "vo\\r\\f\\Hlo_RF057.mp3",	--	I'm a busy gal, so if you could hurry this up.
                "vo\\r\\f\\Hlo_RF058.mp3",	--	So what do you want?
                "vo\\r\\f\\Hlo_RF059.mp3",	--	Anytime you're ready. Just don't keep me waiting.
                "vo\\r\\f\\Hlo_RF060.mp3",	--	Okay, I'm listening.
                "vo\\r\\f\\Hlo_RF061.mp3",	--	If you want something, now's the time to talk.
                "vo\\r\\f\\Hlo_RF062.mp3",	--	I think I could spare a few minutes.
                "vo\\r\\f\\Hlo_RF073.mp3",	--	You should head inside.
                "vo\\r\\f\\Hlo_RF074.mp3",	--	Find shelter.
                "vo\\r\\f\\Hlo_RF075.mp3",	--	Hopefully the storm will pass us by.
                "vo\\r\\f\\Hlo_RF076.mp3",	--	This could be a lovely day, don't you think.
                "vo\\r\\f\\Hlo_RF077.mp3",	--	All right. Go ahead.
                "vo\\r\\f\\Hlo_RF078.mp3",	--	Well, I'm listening. So go ahead.
                "vo\\r\\f\\Hlo_RF079.mp3",	--	Your wounds don't look too bad, but you should find healing regardless.
                "vo\\r\\f\\Hlo_RF080.mp3",	--	What happened to you?
                "vo\\r\\f\\Hlo_RF081.mp3",	--	You shouldn't waste time talking to me. You should find healing.
                "vo\\r\\f\\Hlo_RF082.mp3",	--	Talk is free. What do you want?
                "vo\\r\\f\\Hlo_RF083.mp3",	--	You've got my ear. Let's hear it.
                "vo\\r\\f\\Hlo_RF084.mp3",	--	So where are you from?
                "vo\\r\\f\\Hlo_RF085.mp3",	--	What's your story?
                "vo\\r\\f\\Hlo_RF086.mp3",	--	What brings you here?
                "vo\\r\\f\\Hlo_RF087.mp3",	--	Anything I can do for you?
                "vo\\r\\f\\Hlo_RF088.mp3",	--	I've got a few minutes if you need something, friend.
                "vo\\r\\f\\Hlo_RF089.mp3",	--	Can I help you out? Do you need something?
                "vo\\r\\f\\Hlo_RF090.mp3",	--	So, what's this about?
                "vo\\r\\f\\Hlo_RF091.mp3",	--	Good to meet you.
                "vo\\r\\f\\Hlo_RF092.mp3",	--	Hail.
                "vo\\r\\f\\Hlo_RF104.mp3",	--	You should find healing friend, you've been badly wounded.
                "vo\\r\\f\\Hlo_RF105.mp3",	--	You've made quite a name for yourself. I don't know if we should be talking.
                "vo\\r\\f\\Hlo_RF106.mp3",	--	You might consider a less hazardous profession, thief.
                "vo\\r\\f\\Hlo_RF107.mp3",	--	Isn't that contagious?
                "vo\\r\\f\\Hlo_RF108.mp3",	--	Nice to see you, friend.
                "vo\\r\\f\\Hlo_RF109.mp3",	--	Anytime, friend. I'm right here.
                "vo\\r\\f\\Hlo_RF110.mp3",	--	Well, what brings you here friend?
                "vo\\r\\f\\Hlo_RF111.mp3",	--	You seem to be doing all right for yourself, what can I do for you?
                "vo\\r\\f\\Hlo_RF112.mp3",	--	Greetings, friend. I'm up for conversation if you care to talk.
                "vo\\r\\f\\Hlo_RF113.mp3",	--	You're a lot more refined than most of the travellers I've met. I like that.
                "vo\\r\\f\\Hlo_RF114.mp3",	--	So how are your travels? Anything I can do to help?
                "vo\\r\\f\\Hlo_RF115.mp3",	--	I think you're going to fit right in here, friend. You've won me over.
                "vo\\r\\f\\Hlo_RF116.mp3",	--	May each day greet you warmly, friend.
                "vo\\r\\f\\Hlo_RF117.mp3",	--	This is a pleasant surprise. Greetings, friend.
                "vo\\r\\f\\Hlo_RF118.mp3",	--	Well, what have we here?
                "vo\\r\\f\\Hlo_RF118.mp3",	--	Well, what have we here?
                "vo\\r\\f\\Hlo_RF118.mp3",	--	Well, what have we here?
                "vo\\r\\f\\Hlo_RF128.mp3",	--	Those wounds don't look too serious, but you should seek healing.
                "vo\\r\\f\\Hlo_RF129.mp3",	--	Oh friend, you've been wounded.
                "vo\\r\\f\\Hlo_RF130.mp3",	--	Your wounds concern me greatly friend. You should find healing and then we can talk.
                "vo\\r\\f\\Hlo_RF132.mp3",	--	Well met, friend.
                "vo\\r\\f\\Hlo_RF133.mp3",	--	It's probably a bad idea to walk around like that.
                "vo\\r\\f\\Hlo_RF134.mp3",	--	I like what I see.
                "vo\\r\\f\\Hlo_RF135.mp3",	--	The pleasure is all mine.
                "vo\\r\\f\\Hlo_RF136.mp3",	--	What did I do to deserve this honor?
                "vo\\r\\f\\Hlo_RF137.mp3",	--	Stay as long as you like friend, it would be a privilege to talk with you.
                "vo\\r\\f\\Hlo_RF138.mp3",	--	A vampire! No!
                "vo\\r\\f\\Idl_RF001.mp3",	--	What's a girl gotta do to get some attention around here?
                "vo\\r\\f\\Idl_RF001.mp3",	--	What's a girl gotta do to get some attention around here?
                "vo\\r\\f\\Idl_RF002.mp3",	--	What was that?
                "vo\\r\\f\\Idl_RF002.mp3",	--	What was that?
                "vo\\r\\f\\Idl_RF003.mp3",	--	I can't believe it. Pfft.
                "vo\\r\\f\\Idl_RF003.mp3",	--	I can't believe it. Pfft.
                "vo\\r\\f\\Idl_RF004.mp3",	--	Humming.
                "vo\\r\\f\\Idl_RF004.mp3",	--	Humming.
                "vo\\r\\f\\Idl_RF005.mp3",	--	Cough.
                "vo\\r\\f\\Idl_RF005.mp3",	--	Cough.
                "vo\\r\\f\\Idl_RF006.mp3",	--	If I ever see that elf, he's in so much trouble.
                "vo\\r\\f\\Idl_RF006.mp3",	--	If I ever see that elf, he's in so much trouble.
                "vo\\r\\f\\Idl_RF007.mp3",	--	I'm sure it's around here somewhere.
                "vo\\r\\f\\Idl_RF007.mp3",	--	I'm sure it's around here somewhere.
                "vo\\r\\f\\Idl_RF008.mp3",	--	Now where did I put that?
                "vo\\r\\f\\Idl_RF008.mp3",	--	Now where did I put that?
                "vo\\r\\f\\Idl_RF009.mp3",	--	Whistling.
                "vo\\r\\f\\Idl_RF009.mp3",	--	Whistling.
            },
        },
        ["m"] = {
            [this.voice.continue] = {
            },
            [this.voice.finish] = {
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
            },
            [this.voice.think] = {
            },
            [this.voice.remind] = {
                "vo\\r\\m\\Atk_RM001.mp3",	--	It's about time I had some fun!
                "vo\\r\\m\\Atk_RM002.mp3",	--	No mercy!
                "vo\\r\\m\\Atk_RM003.mp3",	--	I'm going to enjoy this!
                "vo\\r\\m\\Atk_RM004.mp3",	--	Today will be your last!
                "vo\\r\\m\\Atk_RM005.mp3",	--	I have the upper hand!
                "vo\\r\\m\\Atk_RM006.mp3",	--	I'm not giving up that easily.
                "vo\\r\\m\\Atk_RM007.mp3",	--	Run while you can.
                "vo\\r\\m\\Atk_RM008.mp3",	--	You're beaten!
                "vo\\r\\m\\Atk_RM009.mp3",	--	Hold still!
                "vo\\r\\m\\Atk_RM010.mp3",	--	You'll be dead soon.
                "vo\\r\\m\\Atk_RM011.mp3",	--	You're starting to fail.
                "vo\\r\\m\\Atk_RM012.mp3",	--	Am I good or what?
                "vo\\r\\m\\Atk_RM013.mp3",	--	I'll make this quick.
                "vo\\r\\m\\Atk_RM014.mp3",	--	Here it comes!
                "vo\\r\\m\\CrAtk_RM001.mp3",	--	Rarrgh!
                "vo\\r\\m\\CrAtk_RM002.mp3",	--	Ha!
                "vo\\r\\m\\CrAtk_RM003.mp3",	--	Haha!
                "vo\\r\\m\\CrAtk_RM004.mp3",	--	Die!
                "vo\\r\\m\\Fle_RM001.mp3",	--	Not this time.
                "vo\\r\\m\\Fle_RM002.mp3",	--	We're done here!
                "vo\\r\\m\\Fle_RM003.mp3",	--	I'll be back, and you'll be dead!
                "vo\\r\\m\\Fle_RM004.mp3",	--	Not today!
                "vo\\r\\m\\Fle_RM005.mp3",	--	Get away from me!
                "vo\\r\\m\\Flw_RM002.mp3",	--	Hey! Watch it, friend!
                "vo\\r\\m\\Hit_RM001.mp3",	--	Arrgh.
                "vo\\r\\m\\Hit_RM002.mp3",	--	Urgh!
                "vo\\r\\m\\Hit_RM002.mp3",	--	Umpfh
                "vo\\r\\m\\Hit_RM003.mp3",	--	Ungh.
                "vo\\r\\m\\Hit_RM004.mp3",	--	Ungh!
                "vo\\r\\m\\Hit_RM004.mp3",	--	Grunt.
                "vo\\r\\m\\Hit_RM005.mp3",	--	Groan.
                "vo\\r\\m\\Hit_RM006.mp3",	--	Growl.
                "vo\\r\\m\\Hit_RM007.mp3",	--	Cough
                "vo\\r\\m\\Hit_RM008.mp3",	--	Gasp.
                "vo\\r\\m\\Hit_RM009.mp3",	--	Arrgh!
                "vo\\r\\m\\Hit_RM009.mp3",	--	Scream.
                "vo\\r\\m\\Hit_RM010.mp3",	--	Yell.
                "vo\\r\\m\\Hit_RM011.mp3",	--	Grunt.
                "vo\\r\\m\\Hit_RM012.mp3",	--	Groan.
                "vo\\r\\m\\Hit_RM013.mp3",	--	Growl.
                "vo\\r\\m\\Hit_RM014.mp3",	--	Gasp.
                "vo\\r\\m\\Hit_RM015.mp3",	--	Scream.
                "vo\\r\\m\\Hlo_RM001.mp3",	--	I think it would be best if you leave, now!
                "vo\\r\\m\\Hlo_RM001.mp3",	--	I think it would be best if you leave. Now.
                "vo\\r\\m\\Hlo_RM001.mp3",	--	I think it would be best if you leave. Now.
                "vo\\r\\m\\Hlo_RM011.mp3",	--	Go cry about your wounds to someone else.
                "vo\\r\\m\\Hlo_RM012.mp3",	--	Take your half-dead body away from me.
                "vo\\r\\m\\Hlo_RM013.mp3",	--	Ugh. I really think you should go find somewhere else to die.
                "vo\\r\\m\\Hlo_RM014.mp3",	--	What's the matter with you? Did scamps steal your clothes?
                "vo\\r\\m\\Hlo_RM015.mp3",	--	I can't believe what passes for clothing these days.
                "vo\\r\\m\\Hlo_RM016.mp3",	--	Now THAT is one ugly outfit.
                "vo\\r\\m\\Hlo_RM017.mp3",	--	Now that's something I didn't need to see.
                "vo\\r\\m\\Hlo_RM018.mp3",	--	You're a walking crimewave. Get away from me.
                "vo\\r\\m\\Hlo_RM019.mp3",	--	Petty thieves aren't on my guest list. Get lost.
                "vo\\r\\m\\Hlo_RM020.mp3",	--	Get out of here. What are you trying to do, make me sick?
                "vo\\r\\m\\Hlo_RM021.mp3",	--	I don't think so.
                "vo\\r\\m\\Hlo_RM022.mp3",	--	Get lost.
                "vo\\r\\m\\Hlo_RM023.mp3",	--	Ask somebody else, I'm busy.
                "vo\\r\\m\\Hlo_RM024.mp3",	--	If you're looking for trouble, you're getting very warm.
                "vo\\r\\m\\Hlo_RM025.mp3",	--	Watch it.
                "vo\\r\\m\\Hlo_RM026.mp3",	--	This better be important.
                "vo\\r\\m\\Hlo_RM027.mp3",	--	Keep walking.
                "vo\\r\\m\\Hlo_RM028.mp3",	--	Nothing's keeping you here. So move on.
                "vo\\r\\m\\Hlo_RM029.mp3",	--	Can't you be quiet?
                "vo\\r\\m\\Hlo_RM030.mp3",	--	I'm sure someone else can help you.
                "vo\\r\\m\\Hlo_RM040.mp3",	--	Sorry, friend, I like ladies.
                "vo\\r\\m\\Hlo_RM041.mp3",	--	Don't you have someplace to be?
                "vo\\r\\m\\Hlo_RM042.mp3",	--	Not now. Go away.
                "vo\\r\\m\\Hlo_RM043.mp3",	--	I've seen guars with better fashion sense than you!
                "vo\\r\\m\\Hlo_RM044.mp3",	--	Stop wasting my time with your foolishness!
                "vo\\r\\m\\Hlo_RM045.mp3",	--	That's some outfit.
                "vo\\r\\m\\Hlo_RM046.mp3",	--	I don't want any part of this. Whatever it is.
                "vo\\r\\m\\Hlo_RM047.mp3",	--	If you value your freedom, you'll mend your ways thief.
                "vo\\r\\m\\Hlo_RM051.mp3",	--	Hey, put something on!
                "vo\\r\\m\\Hlo_RM052.mp3",	--	Say, is that contagious? Get out of here!
                "vo\\r\\m\\Hlo_RM053.mp3",	--	I don't know. You look like trouble to me.
                "vo\\r\\m\\Hlo_RM054.mp3",	--	How do I know you're not up to something devious?
                "vo\\r\\m\\Hlo_RM055.mp3",	--	There's something not right about you. Maybe you should go.
                "vo\\r\\m\\Hlo_RM056.mp3",	--	Talk with you? Something tells me I might regret it.
                "vo\\r\\m\\Hlo_RM057.mp3",	--	I'm a busy guy, so if you could, hurry this up.
                "vo\\r\\m\\Hlo_RM058.mp3",	--	So what do you want?
                "vo\\r\\m\\Hlo_RM059.mp3",	--	Anytime you're ready. Just don't keep me waiting.
                "vo\\r\\m\\Hlo_RM060.mp3",	--	Okay, I'm listening.
                "vo\\r\\m\\Hlo_RM061.mp3",	--	If you want something, now's the time to talk.
                "vo\\r\\m\\Hlo_RM062.mp3",	--	I think I could spare a few minutes.
                "vo\\r\\m\\Hlo_RM073.mp3",	--	You should head inside.
                "vo\\r\\m\\Hlo_RM074.mp3",	--	Find shelter.
                "vo\\r\\m\\Hlo_RM075.mp3",	--	Hopefully the storm will pass us by.
                "vo\\r\\m\\Hlo_RM076.mp3",	--	This could be a lovely day, don't you think.
                "vo\\r\\m\\Hlo_RM077.mp3",	--	Are you looking for something, friend?
                "vo\\r\\m\\Hlo_RM078.mp3",	--	Come on. What's the good word?
                "vo\\r\\m\\Hlo_RM079.mp3",	--	Your wounds don't look too bad, but you should find healing regardless.
                "vo\\r\\m\\Hlo_RM080.mp3",	--	What happened to you?
                "vo\\r\\m\\Hlo_RM081.mp3",	--	You shouldn't waste time talking to me. You should find healing.
                "vo\\r\\m\\Hlo_RM082.mp3",	--	Talk is free. What do you want?
                "vo\\r\\m\\Hlo_RM083.mp3",	--	You've got my ear. Let's hear it.
                "vo\\r\\m\\Hlo_RM084.mp3",	--	So where are you from?
                "vo\\r\\m\\Hlo_RM085.mp3",	--	What's your story?
                "vo\\r\\m\\Hlo_RM086.mp3",	--	What brings you here, friend?
                "vo\\r\\m\\Hlo_RM087.mp3",	--	Anything I can do for you?
                "vo\\r\\m\\Hlo_RM088.mp3",	--	I've got a few minutes if you need something.
                "vo\\r\\m\\Hlo_RM089.mp3",	--	Can I help you out? Do you need something?
                "vo\\r\\m\\Hlo_RM090.mp3",	--	So, what's this about?
                "vo\\r\\m\\Hlo_RM091.mp3",	--	Good to meet you.
                "vo\\r\\m\\Hlo_RM092.mp3",	--	Hail.
                "vo\\r\\m\\Hlo_RM104.mp3",	--	You should find healing, friend. You've been badly wounded.
                "vo\\r\\m\\Hlo_RM105.mp3",	--	You've made quite a name for yourself. I don't know if we should be talking.
                "vo\\r\\m\\Hlo_RM106.mp3",	--	You might consider a less hazardous profession, thief.
                "vo\\r\\m\\Hlo_RM107.mp3",	--	Isn't that contagious?
                "vo\\r\\m\\Hlo_RM108.mp3",	--	Nice to see you, friend.
                "vo\\r\\m\\Hlo_RM109.mp3",	--	Anytime, friend. I'm right here.
                "vo\\r\\m\\Hlo_RM110.mp3",	--	Well, friend, what brings you here?
                "vo\\r\\m\\Hlo_RM111.mp3",	--	You seem to be doing all right for yourself. What can I do for you?
                "vo\\r\\m\\Hlo_RM112.mp3",	--	Greetings, friend. I'm up for conversation if you care to talk.
                "vo\\r\\m\\Hlo_RM113.mp3",	--	You're a lot more refined than most tourists I've met. I like that.
                "vo\\r\\m\\Hlo_RM114.mp3",	--	Can I do anything to help?
                "vo\\r\\m\\Hlo_RM115.mp3",	--	You've won me over.
                "vo\\r\\m\\Hlo_RM116.mp3",	--	May each day greet you warmly, friend.
                "vo\\r\\m\\Hlo_RM117.mp3",	--	This is a pleasant surprise. Greetings, friend.
                "vo\\r\\m\\Hlo_RM118.mp3",	--	Well, what have we here?
                "vo\\r\\m\\Hlo_RM128.mp3",	--	Those wounds don't look too serious, but you seek healing.
                "vo\\r\\m\\Hlo_RM129.mp3",	--	Oh friend, you've been wounded.
                "vo\\r\\m\\Hlo_RM130.mp3",	--	Your wounds concern me greatly, friend. You should find healing, and then we can talk.
                "vo\\r\\m\\Hlo_RM132.mp3",	--	Well met, friend.
                "vo\\r\\m\\Hlo_RM133.mp3",	--	It's probably a bad idea to walk around like that.
                "vo\\r\\m\\Hlo_RM134.mp3",	--	I like what I see.
                "vo\\r\\m\\Hlo_RM135.mp3",	--	The pleasure is all mine.
                "vo\\r\\m\\Hlo_RM136.mp3",	--	What did I do to deserve this honor?
                "vo\\r\\m\\Hlo_RM137.mp3",	--	Stay as long as you like. It would be a privilege to talk with you.
                "vo\\r\\m\\Hlo_RM138.mp3",	--	No! Go away vampire!
                "vo\\r\\m\\Idl_RM001.mp3",	--	So I said. Where's the money in that?
                "vo\\r\\m\\Idl_RM001.mp3",	--	So I said. Where's the money in that?
                "vo\\r\\m\\Idl_RM002.mp3",	--	I wonder if she heard me say that?
                "vo\\r\\m\\Idl_RM002.mp3",	--	I wonder if she heard me say that?
                "vo\\r\\m\\Idl_RM003.mp3",	--	Not a lot of pretty ladies around here.
                "vo\\r\\m\\Idl_RM003.mp3",	--	Not a lot of pretty ladies around here.
                "vo\\r\\m\\Idl_RM004.mp3",	--	That's one ugly outfit.
                "vo\\r\\m\\Idl_RM004.mp3",	--	That's one ugly outfit.
                "vo\\r\\m\\Idl_RM005.mp3",	--	I should probably wash up before heading home.
                "vo\\r\\m\\Idl_RM005.mp3",	--	I should probably wash up before heading home.
                "vo\\r\\m\\Idl_RM006.mp3",	--	I can't imagine eating one of those things.
                "vo\\r\\m\\Idl_RM006.mp3",	--	I can't imagine eating one of those things.
                "vo\\r\\m\\Idl_RM007.mp3",	--	What day is today?
                "vo\\r\\m\\Idl_RM007.mp3",	--	What day is today?
                "vo\\r\\m\\Idl_RM008.mp3",	--	Sniff.
                "vo\\r\\m\\Idl_RM008.mp3",	--	Sniff.
                "vo\\r\\m\\Idl_RM009.mp3",	--	Cough.
                "vo\\r\\m\\Idl_RM009.mp3",	--	Cough.
            },
        },
    },
    ["wood elf"] = {
        ["f"] = {
            [this.voice.continue] = {
            },
            [this.voice.finish] = {
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
            },
            [this.voice.think] = {
            },
            [this.voice.remind] = {
                "vo\\w\\f\\Atk_WF001.mp3",	--	Now you're going to get it.
                "vo\\w\\f\\Atk_WF002.mp3",	--	Fetcher!
                "vo\\w\\f\\Atk_WF003.mp3",	--	You don't deserve to live.
                "vo\\w\\f\\Atk_WF004.mp3",	--	This is going to be fun.
                "vo\\w\\f\\Atk_WF006.mp3",	--	You chose the wrong Bosmer to mess with.
                "vo\\w\\f\\Atk_WF007.mp3",	--	You can't escape me.
                "vo\\w\\f\\Atk_WF008.mp3",	--	Run while you can.
                "vo\\w\\f\\Atk_WF009.mp3",	--	One of us will die here and it won't be me.
                "vo\\w\\f\\Atk_WF010.mp3",	--	This is too easy.
                "vo\\w\\f\\Atk_WF011.mp3",	--	Fight, coward!
                "vo\\w\\f\\Atk_WF012.mp3",	--	You should run now.
                "vo\\w\\f\\Atk_WF013.mp3",	--	I'll see you dead.
                "vo\\w\\f\\Atk_WF014.mp3",	--	You're growing weaker!
                "vo\\w\\f\\Fle_WF001.mp3",	--	There will be vengeance! This is not the last of this!
                "vo\\w\\f\\Fle_WF002.mp3",	--	When we meet again, you will die!
                "vo\\w\\f\\Fle_WF003.mp3",	--	Get away I do not wish to fight!
                "vo\\w\\f\\Fle_WF004.mp3",	--	I will deny you your victory and the spoils!
                "vo\\w\\f\\Fle_WF005.mp3",	--	Aaaagh!
                "vo\\w\\f\\Flw_WF002.mp3",	--	Hey! Be careful!
                "vo\\w\\f\\Flw_WF005.mp3",	--	I'm on your side!
                "vo\\w\\f\\Hit_WF001.mp3",	--	Arrgh!
                "vo\\w\\f\\Hit_WF001.mp3",	--	Arrgh.
                "vo\\w\\f\\Hit_WF002.mp3",	--	Eeek
                "vo\\w\\f\\Hit_WF003.mp3",	--	Oooff.
                "vo\\w\\f\\Hit_WF004.mp3",	--	Ughn
                "vo\\w\\f\\Hit_WF005.mp3",	--	Stoopid.
                "vo\\w\\f\\Hit_WF006.mp3",	--	AIIEEE.
                "vo\\w\\f\\Hit_WF007.mp3",	--	Groan.
                "vo\\w\\f\\Hit_WF008.mp3",	--	Groan.
                "vo\\w\\f\\Hit_WF009.mp3",	--	Ungh!
                "vo\\w\\f\\Hit_WF009.mp3",	--	Groan.
                "vo\\w\\f\\Hit_WF010.mp3",	--	Grunt.
                "vo\\w\\f\\Hit_WF011.mp3",	--	Grunt.
                "vo\\w\\f\\Hit_WF012.mp3",	--	Groan.
                "vo\\w\\f\\Hit_WF013.mp3",	--	Growl.
                "vo\\w\\f\\Hit_WF014.mp3",	--	Gasp.
                "vo\\w\\f\\Hit_WF015.mp3",	--	Scream.
                "vo\\w\\f\\Hlo_WF000a.mp3",	--	What?
                "vo\\w\\f\\Hlo_WF000b.mp3",	--	Hmmph!
                "vo\\w\\f\\Hlo_WF000c.mp3",	--	Grrrr.
                "vo\\w\\f\\Hlo_WF000d.mp3",	--	You don't want to see me angry.
                "vo\\w\\f\\Hlo_WF000e.mp3",	--	Get out of here!
                "vo\\w\\f\\Hlo_WF000e.mp3",	--	Get out of here!
                "vo\\w\\f\\Hlo_WF001.mp3",	--	Go back where you came from.
                "vo\\w\\f\\Hlo_WF011.mp3",	--	I take comfort in knowing you're not long for this world.
                "vo\\w\\f\\Hlo_WF012.mp3",	--	Your wounds are disgusting. Go away.
                "vo\\w\\f\\Hlo_WF013.mp3",	--	Ugh, why don't you just die already?
                "vo\\w\\f\\Hlo_WF014.mp3",	--	If you're here to beg for coins, go away.
                "vo\\w\\f\\Hlo_WF015.mp3",	--	Interesting outfit. You might get caught dead in it.
                "vo\\w\\f\\Hlo_WF016.mp3",	--	Dressed yourself, I see.
                "vo\\w\\f\\Hlo_WF017.mp3",	--	If there's an excuse to wear clothes, you're it.
                "vo\\w\\f\\Hlo_WF018.mp3",	--	Avoid the guards, thief, and you might live til tommorrow.
                "vo\\w\\f\\Hlo_WF019.mp3",	--	You're a disgrace.
                "vo\\w\\f\\Hlo_WF020.mp3",	--	Take your infections somewhere else.
                "vo\\w\\f\\Hlo_WF021.mp3",	--	Why must you people always pick on the small ones? Go away.
                "vo\\w\\f\\Hlo_WF022.mp3",	--	Can't you see I wish to be left alone!
                "vo\\w\\f\\Hlo_WF023.mp3",	--	Useless tourists.
                "vo\\w\\f\\Hlo_WF024.mp3",	--	You'll get more than you bargained for from me.
                "vo\\w\\f\\Hlo_WF025.mp3",	--	I really don't want you around here.
                "vo\\w\\f\\Hlo_WF026.mp3",	--	Don't bother me.
                "vo\\w\\f\\Hlo_WF027.mp3",	--	Can't you find someone else to bother?
                "vo\\w\\f\\Hlo_WF028.mp3",	--	I don't like you much, stranger.
                "vo\\w\\f\\Hlo_WF029.mp3",	--	Isn't there someone else you can talk to?
                "vo\\w\\f\\Hlo_WF030.mp3",	--	I'm sorry, you probably want to speak with someone else.
                "vo\\w\\f\\Hlo_WF040.mp3",	--	Is it really necessary that we talk?
                "vo\\w\\f\\Hlo_WF041.mp3",	--	Why aren't you working?
                "vo\\w\\f\\Hlo_WF042.mp3",	--	Shouldn't you be at your post?
                "vo\\w\\f\\Hlo_WF043.mp3",	--	You could at least try and be civilized and dress appropriately.
                "vo\\w\\f\\Hlo_WF044.mp3",	--	Let me guess. You were robbed and dressed in those ridiculous clothes.
                "vo\\w\\f\\Hlo_WF045.mp3",	--	If your clothes are any indication, I take it you're a herder.
                "vo\\w\\f\\Hlo_WF046.mp3",	--	The laws are harsh for thieves. You'd be wise to leave me alone.
                "vo\\w\\f\\Hlo_WF047.mp3",	--	I don't think you can be trusted.
                "vo\\w\\f\\Hlo_WF048.mp3",	--	You're wounded, but you'll live. Now move on.
                "vo\\w\\f\\Hlo_WF049.mp3",	--	If you're strong enough to walk, you should find healing.
                "vo\\w\\f\\Hlo_WF050.mp3",	--	There's healing elsewhere. Go find it.
                "vo\\w\\f\\Hlo_WF051.mp3",	--	If you refuse to dress, I refuse to talk.
                "vo\\w\\f\\Hlo_WF052.mp3",	--	Oh, that's some infection you have there.
                "vo\\w\\f\\Hlo_WF053.mp3",	--	I couldn't possibly. Too busy.
                "vo\\w\\f\\Hlo_WF054.mp3",	--	I'm sure this is important, but I really must go.
                "vo\\w\\f\\Hlo_WF055.mp3",	--	Too much trouble. Must be going now.
                "vo\\w\\f\\Hlo_WF056.mp3",	--	I really can't help you, stranger.
                "vo\\w\\f\\Hlo_WF057.mp3",	--	This better be important.
                "vo\\w\\f\\Hlo_WF058.mp3",	--	I really don't have time for this, so make it quick.
                "vo\\w\\f\\Hlo_WF059.mp3",	--	Hurry this up, will you?
                "vo\\w\\f\\Hlo_WF060.mp3",	--	Sorry stranger, my time is short, so get on with it.
                "vo\\w\\f\\Hlo_WF061.mp3",	--	If I can help I will, but don't take too much time.
                "vo\\w\\f\\Hlo_WF062.mp3",	--	Go ahead.
                "vo\\w\\f\\Hlo_WF063.mp3",	--	What is it, sister?
                "vo\\w\\f\\Hlo_WF073.mp3",	--	You shouldn't be out in this mess.
                "vo\\w\\f\\Hlo_WF074.mp3",	--	How do you travel in this?
                "vo\\w\\f\\Hlo_WF075.mp3",	--	Rain again.
                "vo\\w\\f\\Hlo_WF076.mp3",	--	Nice day, don't you think?
                "vo\\w\\f\\Hlo_WF077.mp3",	--	Go ahead.
                "vo\\w\\f\\Hlo_WF078.mp3",	--	Please. I'm listening.
                "vo\\w\\f\\Hlo_WF079.mp3",	--	Are you here about your wounds? You should find healing.
                "vo\\w\\f\\Hlo_WF080.mp3",	--	Someone has taken their toll on you. Maybe you should get healed.
                "vo\\w\\f\\Hlo_WF081.mp3",	--	What happened to you? You're nearly dead.
                "vo\\w\\f\\Hlo_WF082.mp3",	--	From where do you hail, friend?
                "vo\\w\\f\\Hlo_WF083.mp3",	--	What is this about?
                "vo\\w\\f\\Hlo_WF084.mp3",	--	All right, I'm listening.
                "vo\\w\\f\\Hlo_WF085.mp3",	--	I don't know if I can help you, but I'll try.
                "vo\\w\\f\\Hlo_WF086.mp3",	--	Do you want something from me?
                "vo\\w\\f\\Hlo_WF087.mp3",	--	How may I help you?
                "vo\\w\\f\\Hlo_WF088.mp3",	--	I'm listening.
                "vo\\w\\f\\Hlo_WF089.mp3",	--	Interesting, go on.
                "vo\\w\\f\\Hlo_WF090.mp3",	--	How do you do?
                "vo\\w\\f\\Hlo_WF091.mp3",	--	What can I do for you?
                "vo\\w\\f\\Hlo_WF092.mp3",	--	I've rarely seen one as lovely as you. Please, ask your question.
                "vo\\w\\f\\Hlo_WF102.mp3",	--	Have you run into trouble? You seem wounded.
                "vo\\w\\f\\Hlo_WF103.mp3",	--	Something must have gotten hold of you. You're half-dead.
                "vo\\w\\f\\Hlo_WF104.mp3",	--	Those are some serious wounds. You should find healing quick.
                "vo\\w\\f\\Hlo_WF105.mp3",	--	I've heard of you. Maybe you should talk to someone else.
                "vo\\w\\f\\Hlo_WF106.mp3",	--	Criminals should dealt with harshly, don't you think?
                "vo\\w\\f\\Hlo_WF108.mp3",	--	Yes?
                "vo\\w\\f\\Hlo_WF109.mp3",	--	Of course. What may I do for you?
                "vo\\w\\f\\Hlo_WF110.mp3",	--	Yes, stranger?
                "vo\\w\\f\\Hlo_WF111.mp3",	--	And how are you? Can I help you?
                "vo\\w\\f\\Hlo_WF112.mp3",	--	Hello.
                "vo\\w\\f\\Hlo_WF113.mp3",	--	How are you?
                "vo\\w\\f\\Hlo_WF114.mp3",	--	Three blessings friend.
                "vo\\w\\f\\Hlo_WF115.mp3",	--	How can I help? I'll do what I can.
                "vo\\w\\f\\Hlo_WF116.mp3",	--	How nice, I like good company. What can I do for you?
                "vo\\w\\f\\Hlo_WF117.mp3",	--	I am honored to meet you.
                "vo\\w\\f\\Hlo_WF118.mp3",	--	I think you're a thief, because you've stolen my heart.
                "vo\\w\\f\\Hlo_WF128.mp3",	--	Are you all right? You look wounded.
                "vo\\w\\f\\Hlo_WF129.mp3",	--	Oh, dear, what happened? You're half-dead.
                "vo\\w\\f\\Hlo_WF130.mp3",	--	Those are some serious wounds. You should find healing quick.
                "vo\\w\\f\\Hlo_WF131.mp3",	--	And what have we here? Please. Go ahead.
                "vo\\w\\f\\Hlo_WF132.mp3",	--	Hail, friend.
                "vo\\w\\f\\Hlo_WF133.mp3",	--	Woke up in a hurry? You've forgotten your clothes!
                "vo\\w\\f\\Hlo_WF134.mp3",	--	Greetings and salutations.
                "vo\\w\\f\\Hlo_WF135.mp3",	--	I have a feeling you and I are about to become very close.
                "vo\\w\\f\\Hlo_WF136.mp3",	--	This is a wondrous encounter. Welcome.
                "vo\\w\\f\\Hlo_WF137.mp3",	--	If there is anything I can do, I am humbly at your service.
                "vo\\w\\f\\Hlo_WF138.mp3",	--	Aargh! Go away!
                "vo\\w\\f\\Idl_WF001.mp3",	--	Sniff.
                "vo\\w\\f\\Idl_WF001.mp3",	--	Sniff.
                "vo\\w\\f\\Idl_WF002.mp3",	--	Cough.
                "vo\\w\\f\\Idl_WF002.mp3",	--	Cough.
                "vo\\w\\f\\Idl_WF003.mp3",	--	Sigh.
                "vo\\w\\f\\Idl_WF003.mp3",	--	Sigh.
                "vo\\w\\f\\Idl_WF004.mp3",	--	Whistle.
                "vo\\w\\f\\Idl_WF004.mp3",	--	Whistle.
                "vo\\w\\f\\Idl_WF005.mp3",	--	Humm.
                "vo\\w\\f\\Idl_WF005.mp3",	--	Humm.
                "vo\\w\\f\\Idl_WF006.mp3",	--	I thought I heard something?
                "vo\\w\\f\\Idl_WF006.mp3",	--	I thought I heard something?
                "vo\\w\\f\\Idl_WF007.mp3",	--	Hmm. Probably nothing.
                "vo\\w\\f\\Idl_WF007.mp3",	--	Hmm. Probably nothing.
                "vo\\w\\f\\Idl_WF008.mp3",	--	Now where did I put that?
                "vo\\w\\f\\Idl_WF008.mp3",	--	Now where did I put that?
                "vo\\w\\f\\Idl_WF009.mp3",	--	What was that?
                "vo\\w\\f\\Idl_WF009.mp3",	--	What was that?
            },
        },
        ["m"] = {
            [this.voice.continue] = {
            },
            [this.voice.finish] = {
            },
            [this.voice.loseRound] = {
            },
            [this.voice.winGame] = {
            },
            [this.voice.think] = {
            },
            [this.voice.remind] = {
                "vo\\w\\m\\Atk_WM001.mp3",	--	Now you're going to get it.
                "vo\\w\\m\\Atk_WM002.mp3",	--	Fetcher!
                "vo\\w\\m\\Atk_WM003.mp3",	--	You don't deserve to live.
                "vo\\w\\m\\Atk_WM004.mp3",	--	This is going to be fun.
                "vo\\w\\m\\Atk_WM005.mp3",	--	ARRRRGH.
                "vo\\w\\m\\Atk_WM006.mp3",	--	You chose the wrong Bosmer to mess with.
                "vo\\w\\m\\Atk_WM007.mp3",	--	You can't escape me.
                "vo\\w\\m\\Atk_WM008.mp3",	--	Run while you can.
                "vo\\w\\m\\Atk_WM009.mp3",	--	One of us will die here and it won't be me.
                "vo\\w\\m\\Atk_WM010.mp3",	--	This is too easy.
                "vo\\w\\m\\Atk_WM011.mp3",	--	Fight coward!
                "vo\\w\\m\\Atk_WM012.mp3",	--	You should run now.
                "vo\\w\\m\\Atk_WM013.mp3",	--	I'll see you dead.
                "vo\\w\\m\\Atk_WM018.mp3",	--	No one can challenge me!
                "vo\\w\\m\\Fle_WM001.mp3",	--	There will be vengeance! This is not the last of this!
                "vo\\w\\m\\Fle_WM002.mp3",	--	When we meet again, you will die!
                "vo\\w\\m\\Fle_WM003.mp3",	--	Get away! I do not wish to fight!
                "vo\\w\\m\\Fle_WM004.mp3",	--	I will deny you your victory and the spoils!
                "vo\\w\\m\\Fle_WM005.mp3",	--	Aaaagh!
                "vo\\w\\m\\Flw_WM002.mp3",	--	Careful with that, friend!
                "vo\\w\\m\\Hit_WM001.mp3",	--	Arrgh.
                "vo\\w\\m\\Hit_WM002.mp3",	--	Eeek
                "vo\\w\\m\\Hit_WM003.mp3",	--	Oooff.
                "vo\\w\\m\\Hit_WM004.mp3",	--	Ungh!
                "vo\\w\\m\\Hit_WM004.mp3",	--	Ughn
                "vo\\w\\m\\Hit_WM005.mp3",	--	Stoopid.
                "vo\\w\\m\\Hit_WM006.mp3",	--	AIIEEE.
                "vo\\w\\m\\Hit_WM007.mp3",	--	Groan.
                "vo\\w\\m\\Hit_WM008.mp3",	--	Groan.
                "vo\\w\\m\\Hit_WM009.mp3",	--	Groan.
                "vo\\w\\m\\Hit_WM010.mp3",	--	Grunt.
                "vo\\w\\m\\Hit_WM011.mp3",	--	Umph!
                "vo\\w\\m\\Hit_WM011.mp3",	--	Grunt.
                "vo\\w\\m\\Hit_WM012.mp3",	--	Ooomph!
                "vo\\w\\m\\Hit_WM012.mp3",	--	Groan.
                "vo\\w\\m\\Hit_WM013.mp3",	--	Growl.
                "vo\\w\\m\\Hit_WM014.mp3",	--	Gasp.
                "vo\\w\\m\\Hit_WM015.mp3",	--	Scream.
                "vo\\w\\m\\Hlo_WM001.mp3",	--	Go back where you came from.
                "vo\\w\\m\\Hlo_WM011.mp3",	--	I take comfort in knowing you're not long for this world.
                "vo\\w\\m\\Hlo_WM012.mp3",	--	Your wounds are disgusting. Go away.
                "vo\\w\\m\\Hlo_WM013.mp3",	--	Ugh, why don't you just die already?
                "vo\\w\\m\\Hlo_WM014.mp3",	--	If you're here to beg for coins, go away.
                "vo\\w\\m\\Hlo_WM015.mp3",	--	Interesting outfit. You might get caught dead in it.
                "vo\\w\\m\\Hlo_WM016.mp3",	--	Dressed yourself, I see.
                "vo\\w\\m\\Hlo_WM017.mp3",	--	If there's an excuse to wear clothes, you're it.
                "vo\\w\\m\\Hlo_WM018.mp3",	--	Avoid the guards, thief, and you might live til tommorrow.
                "vo\\w\\m\\Hlo_WM019.mp3",	--	You're a disgrace.
                "vo\\w\\m\\Hlo_WM020.mp3",	--	Take your infections somewhere else.
                "vo\\w\\m\\Hlo_WM021.mp3",	--	Why must you people always pick on the small ones? Go away.
                "vo\\w\\m\\Hlo_WM022.mp3",	--	Can't you see I wish to be left alone!
                "vo\\w\\m\\Hlo_WM022.mp3",	--	Can't you see I wish to be left alone!
                "vo\\w\\m\\Hlo_WM023.mp3",	--	Useless tourists.
                "vo\\w\\m\\Hlo_WM024.mp3",	--	You'll get more than you bargained for from me!
                "vo\\w\\m\\Hlo_WM024.mp3",	--	You'll get more than you bargained for from me.
                "vo\\w\\m\\Hlo_WM025.mp3",	--	I really don't want you around here.
                "vo\\w\\m\\Hlo_WM026.mp3",	--	Don't bother me.
                "vo\\w\\m\\Hlo_WM027.mp3",	--	Can't you find someone else to bother?
                "vo\\w\\m\\Hlo_WM028.mp3",	--	I don't like you much.
                "vo\\w\\m\\Hlo_WM029.mp3",	--	Isn't there someone else you can talk to?
                "vo\\w\\m\\Hlo_WM030.mp3",	--	I'm sorry, you probably want to speak with someone else.
                "vo\\w\\m\\Hlo_WM040.mp3",	--	Is it really necessary that we talk?
                "vo\\w\\m\\Hlo_WM041.mp3",	--	Why aren't you working?
                "vo\\w\\m\\Hlo_WM042.mp3",	--	Shouldn't you be at your post?
                "vo\\w\\m\\Hlo_WM043.mp3",	--	You could at least try and be civilized and dress appropriately.
                "vo\\w\\m\\Hlo_WM044.mp3",	--	Let me guess. You were robbed and dressed in those ridiculous clothes.
                "vo\\w\\m\\Hlo_WM045.mp3",	--	If your clothes are any indictation, I take it you're a herder.
                "vo\\w\\m\\Hlo_WM046.mp3",	--	The laws are harsh for thieves. Including yourself.
                "vo\\w\\m\\Hlo_WM047.mp3",	--	I don't think you can be trusted.
                "vo\\w\\m\\Hlo_WM048.mp3",	--	You're wounded, but you'll live. Now move on.
                "vo\\w\\m\\Hlo_WM049.mp3",	--	If you're strong enough to walk, you should find healing.
                "vo\\w\\m\\Hlo_WM050.mp3",	--	There's healing elsewhere. Go find it.
                "vo\\w\\m\\Hlo_WM051.mp3",	--	I'm not impressed. Find yourself some rags.
                "vo\\w\\m\\Hlo_WM052.mp3",	--	Oh, that's some infection you have there.
                "vo\\w\\m\\Hlo_WM053.mp3",	--	I couldn't possibly. Too busy.
                "vo\\w\\m\\Hlo_WM054.mp3",	--	I'm sure this is important, but I really must go.
                "vo\\w\\m\\Hlo_WM055.mp3",	--	Too much trouble. Must be going now.
                "vo\\w\\m\\Hlo_WM056.mp3",	--	I really can't help you, stranger.
                "vo\\w\\m\\Hlo_WM057.mp3",	--	This better be important.
                "vo\\w\\m\\Hlo_WM058.mp3",	--	I really don't have time for this, so make it quick.
                "vo\\w\\m\\Hlo_WM059.mp3",	--	Hurry this up, will you?
                "vo\\w\\m\\Hlo_WM060.mp3",	--	Sorry, stranger, my time is short, so get on with it.
                "vo\\w\\m\\Hlo_WM061.mp3",	--	If I can help I will, but don't take too much time.
                "vo\\w\\m\\Hlo_WM062.mp3",	--	Go ahead.
                "vo\\w\\m\\Hlo_WM073.mp3",	--	You shouldn't be out in this mess.
                "vo\\w\\m\\Hlo_WM074.mp3",	--	How do you travel in this?
                "vo\\w\\m\\Hlo_WM075.mp3",	--	Rain again.
                "vo\\w\\m\\Hlo_WM076.mp3",	--	Nice day, don't you think?
                "vo\\w\\m\\Hlo_WM077.mp3",	--	Go ahead.
                "vo\\w\\m\\Hlo_WM078.mp3",	--	Well, what is this about?
                "vo\\w\\m\\Hlo_WM079.mp3",	--	Are you here about your wounds? You should find healing.
                "vo\\w\\m\\Hlo_WM080.mp3",	--	Someone has taken their toll on you. Maybe you should get healed.
                "vo\\w\\m\\Hlo_WM081.mp3",	--	What happened to you? You're nearly dead.
                "vo\\w\\m\\Hlo_WM082.mp3",	--	From where do you hail?
                "vo\\w\\m\\Hlo_WM083.mp3",	--	What is this about?
                "vo\\w\\m\\Hlo_WM084.mp3",	--	All right, I'm listening.
                "vo\\w\\m\\Hlo_WM085.mp3",	--	Hello. I don't know if I can help you, but I'll try.
                "vo\\w\\m\\Hlo_WM086.mp3",	--	Do you want something from me?
                "vo\\w\\m\\Hlo_WM087.mp3",	--	How may I help you?
                "vo\\w\\m\\Hlo_WM088.mp3",	--	I'm listening.
                "vo\\w\\m\\Hlo_WM088.mp3",	--	I'm listening.
                "vo\\w\\m\\Hlo_WM088.mp3",	--	I'm listening.
                "vo\\w\\m\\Hlo_WM089.mp3",	--	Interesting, go on.
                "vo\\w\\m\\Hlo_WM090.mp3",	--	How do you do?
                "vo\\w\\m\\Hlo_WM091.mp3",	--	What can I do for you?
                "vo\\w\\m\\Hlo_WM092.mp3",	--	I've rarely seen one as lovely as you. Please, ask your question.
                "vo\\w\\m\\Hlo_WM102.mp3",	--	Have you run into trouble? You seem wounded.
                "vo\\w\\m\\Hlo_WM103.mp3",	--	Something must have gotten hold of you. You're half-dead.
                "vo\\w\\m\\Hlo_WM104.mp3",	--	Those are some serious wounds. You should find healing quick.
                "vo\\w\\m\\Hlo_WM104.mp3",	--	Those are some serious wounds. You should find healing quick.
                "vo\\w\\m\\Hlo_WM105.mp3",	--	I've heard of your crimes. Maybe you should talk to someone else.
                "vo\\w\\m\\Hlo_WM106.mp3",	--	Criminals should dealt with harshly, don't you think?
                "vo\\w\\m\\Hlo_WM108.mp3",	--	Yes?
                "vo\\w\\m\\Hlo_WM109.mp3",	--	Of course. What may I do for you?
                "vo\\w\\m\\Hlo_WM110.mp3",	--	Yes, stranger?
                "vo\\w\\m\\Hlo_WM111.mp3",	--	And how are you? Can I help you?
                "vo\\w\\m\\Hlo_WM112.mp3",	--	Hello.
                "vo\\w\\m\\Hlo_WM113.mp3",	--	How are you?
                "vo\\w\\m\\Hlo_WM114.mp3",	--	Three blessings, friend.
                "vo\\w\\m\\Hlo_WM115.mp3",	--	How can I help? I'll do what I can.
                "vo\\w\\m\\Hlo_WM116.mp3",	--	How nice, I like good company. What can I do for you?
                "vo\\w\\m\\Hlo_WM117.mp3",	--	I am honored to meet you.
                "vo\\w\\m\\Hlo_WM118.mp3",	--	I think you're a thief, because you've stolen my heart.
                "vo\\w\\m\\Hlo_WM128.mp3",	--	Are you all right? You look wounded.
                "vo\\w\\m\\Hlo_WM129.mp3",	--	Oh, dear, what happened? You're half-dead.
                "vo\\w\\m\\Hlo_WM131.mp3",	--	This is a rare honor.
                "vo\\w\\m\\Hlo_WM132.mp3",	--	Hail, friend.
                "vo\\w\\m\\Hlo_WM133.mp3",	--	How free you are, to venture in the nude!
                "vo\\w\\m\\Hlo_WM134.mp3",	--	Greetings and salutations.
                "vo\\w\\m\\Hlo_WM135.mp3",	--	I have a feeling that you and I are about to become very close.
                "vo\\w\\m\\Hlo_WM136.mp3",	--	This is a wondrous encounter. Welcome.
                "vo\\w\\m\\Hlo_WM137.mp3",	--	If there is anything I can do, I am humbly at your service.
                "vo\\w\\m\\Hlo_WM138.mp3",	--	You don't want to kill me do you?
                "vo\\w\\m\\Idl_WM001.mp3",	--	Sniff.
                "vo\\w\\m\\Idl_WM001.mp3",	--	Sniff.
                "vo\\w\\m\\Idl_WM002.mp3",	--	Cough.
                "vo\\w\\m\\Idl_WM002.mp3",	--	Cough.
                "vo\\w\\m\\Idl_WM003.mp3",	--	Sigh.
                "vo\\w\\m\\Idl_WM003.mp3",	--	Sigh.
                "vo\\w\\m\\Idl_WM004.mp3",	--	Whistle.
                "vo\\w\\m\\Idl_WM004.mp3",	--	Whistle.
                "vo\\w\\m\\Idl_WM005.mp3",	--	Humm.
                "vo\\w\\m\\Idl_WM005.mp3",	--	Humm.
                "vo\\w\\m\\Idl_WM006.mp3",	--	Sigh.
                "vo\\w\\m\\Idl_WM006.mp3",	--	Sigh.
                "vo\\w\\m\\Idl_WM007.mp3",	--	Grumbles.
                "vo\\w\\m\\Idl_WM007.mp3",	--	Grumbles.
                "vo\\w\\m\\Idl_WM008.mp3",	--	Sigh.
                "vo\\w\\m\\Idl_WM008.mp3",	--	Sigh.
                "vo\\w\\m\\Idl_WM009.mp3",	--	That's unusual.
                "vo\\w\\m\\Idl_WM009.mp3",	--	That's unusual.
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
