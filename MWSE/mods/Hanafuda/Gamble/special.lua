---@class Gamble.Special
local this = {}
local logger = require("Hanafuda.logger")

local npcs = {
    -- essential
    -- morrowind
    ["addhiranirr"] = false,
    ["athyn sarethi"] = true,
    ["Blatta Hateria"] = false,
    ["caius cosades"] = true,
    ["crassius curio"] = true,
    ["crazy_batou"] = false,
    ["danso indules"] = false,
    ["divayth fyr"] = true,
    ["dram bero"] = true,
    ["dutadalk"] = false,
    ["endryn llethan"] = false,
    ["falura llervu"] = false,
    ["garisa llethri"] = false,
    ["gilvas barelo"] = false,
    ["goris the maggot king"] = false,
    ["han-ammu"] = true,
    ["hasphat antabolis"] = true,
    ["hassour zainsubani"] = true,
    ["hlaren ramoran"] = false,
    ["huleeya"] = true,
    ["kaushad"] = true,
    ["kausi"] = false,
    ["lord cluttermonkey"] = false,
    ["manirai"] = false,
    ["mehra milo"] = true,
    ["miner arobar"] = false,
    ["brara morvayn"] = false,
    ["nevena ules"] = false,
    ["nibani maesa"] = true,
    ["raesa pullia"] = false,
    ["savile imayn"] = true,
    ["sharn gra-muzgob"] = false,
    ["sinnammu mirpal"] = true,
    ["sonummu zabamat"] = false,
    ["sul-matuul"] = true,
    ["tholer saryoni"] = true,
    ["uupse fyr"] = false,
    ["varvur sarethi"] = false,
    ["velanda omani"] = false,
    ["yenammu"] = false,
    -- tribunals
    ["apelles matius"] = false,
    ["asciene rane"] = false,
    ["barenziah"] = true,
    ["effe_tei"] = false,
    ["fedris hler"] = false,
    ["gavas drin"] = false,
    ["karrod"] = false,
    ["King Hlaalu Helseth"] = true,
    ["Tienius Delitian"] = false,
    -- bloodmoon
    ["falx carius"] = true,
    ["tharsten heart-fang"] = false,
    ["tharsten heart-fang2"] = false,
    -- notable npcs
    ["chargen name"] = true, -- jiub
    ["fargoth"] = true,
    ["agronian guy"] = true,
    ["umbra"] = true,
    ["ahnassi"] = true,
    ["hentus yansurnummu"] = true,
    ["folms mirel"] = true,
    ["galyn arvel"] = true,
    ["nelos onmar"] = true,
    ["nels llendo"] = true,
    ["jobasha"] = true,
    ["Orvas Dren Druglord"] = true,
    ["Vedam Dren"] = true,
    ["baren alen"] = true,
    ["aryon"] = true,
    ["dratha"] = true,
    ["baladas demnevanni"] = true,
    ["edryno arethi"] = true,
    ["ilmeni dren"] = true,
    ["lloros sarano"] = true,
    ["faral retheran"] = true,
    ["edd theman"] = true,
    ["persius mercius"] = true,
    ["ajira"] = true,
    ["skinkintreesshade"] = true,
    ["habasi"] = true,
    ["stacey"] = true,
    ["eno hlaalu"] = true,
    ["Canctunian Ponius"] = true,
    ["ralyn othravel"] = true,
    ["Relam Arinith"] = true,
    ["ulms drathen"] = true,
    ["daric bielle"] = true,
    ["dranas sarathram"] = true,
    ["berwen"] = true,
    ["andil"] = true,
    ["maela kaushad"] = true,
    ["cassius olcinius"] = true,
    ["yngling half-troll"] = true,
    ["trebonius artorius"] = true,
    ["zennammu"] = true,
    ["wulf"] = true,
    -- notable tribunals
    ["plitinius mero"] = true,
    ["Trels Varis"] = true,
    ["meryn othralas"] = true,
    ["Gaenor"] = true,
    -- notable bloodmoon
    ["Carnius Magius"] = true,
    ["Falco Galenus"] = true,
    ["zeno faustus"] = true,
    ["korst wind-eye"] = true,
    ["uncle sweetshare"] = true,
    ["Seler Favelnim"] = true,
    ["glenmoril_witch_cave"] = true,
    ["glenmoril_witch_cave_2"] = true,
    ["glenmoril_witch_cave_3"] = true,
}

-- A unique name, with a stand-alone page in uesp. Not yet investigated if it is conversable.
local creatures = {
    -- special
    ---- morrowind
    ["dagoth_ur_1"] = true,
    ["dagoth_ur_2"] = false,
    ["heart_akulakhan"] = false,
    ["vivec_god"] = true,
    ["yagrum bagarn"] = true,
    ---- tribunals
    ["almalexia"] = true,
    ["almalexia_warrior"] = false,
    ["Imperfect"] = false,
    ["scrib_rerlas"] = false,
    ["rat_rerlas"] = false,
    ["Rat_pack_rerlas"] = false,
    ---- bloodmoon
    ["glenmoril_raven"] = false,
    ["glenmoril_raven_cave"] = false,
    ["BM_hircine"] = false,
    ["BM_hircine2"] = false,
    ["BM_hircine_huntaspect"] = false,
    ["BM_hircine_spdaspect"] = false,
    ["BM_hircine_straspect"] = false,
    ["bm_frost_giant"] = false,
    ["BM_udyrfrykte"] = false,
    -- unique
    ---- morrowind
    ["dagoth fandril"] = false,
    ["dagoth molos"] = false,
    ["dagoth felmis"] = false,
    ["dagoth rather"] = false,
    ["dagoth garel"] = false,
    ["dagoth reler"] = false,
    ["dagoth goral"] = false,
    ["dagoth tanis"] = false,
    ["dagoth_hlevul"] = false,
    ["dagoth uvil"] = false,
    ["dagoth malan"] = false,
    ["dagoth vaner"] = false,
    ["dagoth ulen"] = false,
    ["dagoth irvyn"] = false,
    ["dagoth aladus"] = false,
    ["dagoth fovon"] = false,
    ["dagoth baler"] = false,
    ["dagoth girer"] = false,
    ["dagoth daynil"] = false,
    ["dagoth ienas"] = false,
    ["dagoth delnus"] = false,
    ["dagoth mendras"] = false,
    ["dagoth drals"] = false,
    ["dagoth mulis"] = false,
    ["dagoth muthes"] = false,
    ["dagoth elam"] = false,
    ["dagoth nilor"] = false,
    ["dagoth fervas"] = false,
    ["dagoth ralas"] = false,
    ["dagoth soler"] = false,
    ["dagoth fals"] = false,
    ["dagoth galmis"] = false,
    ["dagoth gares"] = false,
    ["dagoth velos"] = false,
    ["dagoth araynys"] = false,
    ["dagoth endus"] = false,
    ["dagoth gilvoth"] = false,
    ["dagoth odros"] = false,
    ["dagoth Tureynul"] = false,
    ["dagoth uthol"] = false,
    ["dagoth vemyn"] = false,
    ["mudcrab_unique"] = true,
    ["rat_cave_hhte1"] = false,
    ["atronach_flame_ttmk"] = true,
    ["atronach_frost_ttmk"] = true,
    ["atronach_frost_gwai_uni"] = false,
    ["atronach_storm_ttmk"] = true,
    ["daedroth_menta_unique"] = false,
    ["dremora_ttmg"] = true,
    ["dremora_ttpc"] = true,
    ["dremora_special_Fyr"] = false,
    ["golden saint_staada"] = false,
    ["lustidrike"] = false,
    ["scamp_creeper"] = true,
    ["winged twilight_grunda_"] = false,
    ["ancestor_guardian_fgdd"] = false,
    ["gateway_haunt"] = false,
    ["ancestor_guardian_heler"] = false,
    ["ancestor_mg_wisewoman"] = false,
    ["ancestor_ghost_vabdas"] = false,
    ["wraith_sul_senipul"] = false,
    ["Dahrk Mezalf"] = false,
    ["skeleton_Vemynal"] = false,
    ["worm lord"] = false,
    ---- tribunals
    ["goblin_warchief1"] = false,
    ["goblin_warchief2"] = false,
    ["lich_profane_unique"] = false,
    ["lich_relvel"] = false,
    ["lich_barilzar"] = false,
    ["ancestor_ghost_Variner"] = false,
    ["dwarven ghost_radac"] = false,
    ["dremora_lord_khash_uni"] = false,
    ---- bloodmoon
    ["draugr_aesliip"] = false,
}

local npcStyles = {
}

local creatureStyles = {
    ["dagoth_ur_1"] = "sixth_house",
    ["dagoth_ur_2"] = "sixth_house",
    ["vivec_god"] = "tribunal",
    ["yagrum bagarn"] = "dwemer",
    ["almalexia"] = "tribunal",
    ["almalexia_warrior"] = "tribunal",
    ["mudcrab_unique"] = "creature",
    ["scamp_creeper"] = "daedra",
    ["dremora_ttmg"] = "daedra",
    ["dremora_ttpc"] = "daedra",
}

---@param mobile tes3mobileNPC
---@return boolean
function this.IsAllowdNPC(mobile)
    logger:debug("NPC baseObject ID: " .. mobile.object.baseObject.id)
    local v = npcs[mobile.object.baseObject.id]
    return (v ~= nil) and (v == true) -- allowed only true
end

---@param mobile tes3mobileCreature
---@return boolean
function this.IsAllowdCreature(mobile)
    logger:debug("Creature baseObject ID: " .. mobile.object.baseObject.id)
    local v = creatures[mobile.object.baseObject.id]
    return (v ~= nil) and (v == true) -- allowed only true
end

---@param mobile tes3mobileNPC
---@return string?
function this.GetCardStyleNPC(mobile)
    return npcStyles[mobile.object.baseObject.id]
end

---@param mobile tes3mobileCreature
---@return string?
function this.GetCardStyleCreature(mobile)
    return creatureStyles[mobile.object.baseObject.id]
end

return this
