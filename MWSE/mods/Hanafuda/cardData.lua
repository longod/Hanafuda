-- define card data, user non configuable.
local i18n = mwse.loadTranslations("Hanafuda")

local this = {}
--- month
---@enum CardSuit
this.cardSuit = {
    january = 1,
    february = 2,
    march = 3,
    april = 4,
    may = 5,
    june = 6,
    july = 7,
    august = 8,
    september = 9,
    october = 10,
    november = 11,
    december = 12,
}

--- rank, tier
---@enum CardType
this.cardType = {
    bright = 1, -- hikari
    animal = 2, -- tane
    ribbon = 3, -- tanzaku
    chaff = 4, -- kasu
}

---@enum CardSymbol
this.cardSymbol = {
    crane = 1,
    curtain = 2,
    moon = 3,
    rainman = 4,
    phoenix = 5,
    warbler = 6,
    cuckoo = 7,
    bridge = 8,
    butterfly = 9,
    boar = 10,
    geese = 11,
    sakeCup = 12,
    deer = 13,
    swallow = 14,
    redPoetry = 15,
    red = 16,
    blue = 17,
    none = 18,
}

this.cardCount = 48 ---@type integer
this.cardWidth = math.ceil( 32 * 2 ) ---@type number
this.cardHeight = math.ceil( 53 * 2 ) ---@type number

---@class CardAsset
---@field path string

-- TODO Allow switching of art for each game.
-- directory layout, naming rule, search filesystem

local cardDir = "Textures/Hanafuda/card/"
local defaultCardArt = "worn"
local defaultCardDir = cardDir .. defaultCardArt .. "/"

---@type CardAsset[]
this.cardAssets = {
    { path = defaultCardDir .. "01-1.dds" },
    { path = defaultCardDir .. "01-2.dds" },
    { path = defaultCardDir .. "01-3.dds" },
    { path = defaultCardDir .. "01-4.dds" },
    { path = defaultCardDir .. "02-1.dds" },
    { path = defaultCardDir .. "02-2.dds" },
    { path = defaultCardDir .. "02-3.dds" },
    { path = defaultCardDir .. "02-4.dds" },
    { path = defaultCardDir .. "03-1.dds" },
    { path = defaultCardDir .. "03-2.dds" },
    { path = defaultCardDir .. "03-3.dds" },
    { path = defaultCardDir .. "03-4.dds" },
    { path = defaultCardDir .. "04-1.dds" },
    { path = defaultCardDir .. "04-2.dds" },
    { path = defaultCardDir .. "04-3.dds" },
    { path = defaultCardDir .. "04-4.dds" },
    { path = defaultCardDir .. "05-1.dds" },
    { path = defaultCardDir .. "05-2.dds" },
    { path = defaultCardDir .. "05-3.dds" },
    { path = defaultCardDir .. "05-4.dds" },
    { path = defaultCardDir .. "06-1.dds" },
    { path = defaultCardDir .. "06-2.dds" },
    { path = defaultCardDir .. "06-3.dds" },
    { path = defaultCardDir .. "06-4.dds" },
    { path = defaultCardDir .. "07-1.dds" },
    { path = defaultCardDir .. "07-2.dds" },
    { path = defaultCardDir .. "07-3.dds" },
    { path = defaultCardDir .. "07-4.dds" },
    { path = defaultCardDir .. "08-1.dds" },
    { path = defaultCardDir .. "08-2.dds" },
    { path = defaultCardDir .. "08-3.dds" },
    { path = defaultCardDir .. "08-4.dds" },
    { path = defaultCardDir .. "09-1.dds" },
    { path = defaultCardDir .. "09-2.dds" },
    { path = defaultCardDir .. "09-3.dds" },
    { path = defaultCardDir .. "09-4.dds" },
    { path = defaultCardDir .. "10-1.dds" },
    { path = defaultCardDir .. "10-2.dds" },
    { path = defaultCardDir .. "10-3.dds" },
    { path = defaultCardDir .. "10-4.dds" },
    { path = defaultCardDir .. "11-1.dds" },
    { path = defaultCardDir .. "11-2.dds" },
    { path = defaultCardDir .. "11-3.dds" },
    { path = defaultCardDir .. "11-4.dds" },
    { path = defaultCardDir .. "12-1.dds" },
    { path = defaultCardDir .. "12-2.dds" },
    { path = defaultCardDir .. "12-3.dds" },
    { path = defaultCardDir .. "12-4.dds" },
}

---@type CardAsset
this.cardBackAsset = { path = defaultCardDir .. "back.dds" }

-- this.cardBackAsset = { path = "Textures/Tx_fabric_tapestry_04.dds" }
-- this.cardBackAsset = { path = "Textures/Tx_ashl_banner_01.dds" }
-- this.cardBackAsset = { path = "Textures/Tx_ashl_banner_03.dds" }
-- this.cardBackAsset = { path = "Textures/Tx_ashl_banner_06.dds" }
-- this.cardBackAsset = { path = "Textures/Tx_banner_6th.dds" }
-- this.cardBackAsset = { path = "Textures/Tx_banner_dagoth_01.dds" }
-- this.cardBackAsset = { path = "Textures/Tx_banner_hlaalu_01.dds" }
-- this.cardBackAsset = { path = "Textures/Tx_banner_redoran_01.dds" }
-- this.cardBackAsset = { path = "Textures/Tx_de_banner_telvani_01.dds" }
-- this.cardBackAsset = { path = "Textures/Tx_c_robecommon02_c_bagside.dds" }
-- this.cardBackAsset = { path = "Textures/Tx_de_tapestry_02.dds" }
-- this.cardBackAsset = { path = "Textures/Tx_fresco_newtribunal_01.dds" }
-- this.cardBackAsset = { path = "Textures/Tx_saint_vivec_01.dds" }

---@class CardText
---@field name string
---@field alt string?

---@type CardText[]
this.cardText = {
    { name = i18n("hanafuda.card.name_01_1") },
    { name = i18n("hanafuda.card.name_01_2") },
    { name = i18n("hanafuda.card.name_01_3") },
    { name = i18n("hanafuda.card.name_01_4") },
    { name = i18n("hanafuda.card.name_02_1") },
    { name = i18n("hanafuda.card.name_02_2") },
    { name = i18n("hanafuda.card.name_02_3") },
    { name = i18n("hanafuda.card.name_02_4") },
    { name = i18n("hanafuda.card.name_03_1") },
    { name = i18n("hanafuda.card.name_03_2") },
    { name = i18n("hanafuda.card.name_03_3") },
    { name = i18n("hanafuda.card.name_03_4") },
    { name = i18n("hanafuda.card.name_04_1") },
    { name = i18n("hanafuda.card.name_04_2") },
    { name = i18n("hanafuda.card.name_04_3") },
    { name = i18n("hanafuda.card.name_04_4") },
    { name = i18n("hanafuda.card.name_05_1") },
    { name = i18n("hanafuda.card.name_05_2") },
    { name = i18n("hanafuda.card.name_05_3") },
    { name = i18n("hanafuda.card.name_05_4") },
    { name = i18n("hanafuda.card.name_06_1") },
    { name = i18n("hanafuda.card.name_06_2") },
    { name = i18n("hanafuda.card.name_06_3") },
    { name = i18n("hanafuda.card.name_06_4") },
    { name = i18n("hanafuda.card.name_07_1") },
    { name = i18n("hanafuda.card.name_07_2") },
    { name = i18n("hanafuda.card.name_07_3") },
    { name = i18n("hanafuda.card.name_07_4") },
    { name = i18n("hanafuda.card.name_08_1") },
    { name = i18n("hanafuda.card.name_08_2") },
    { name = i18n("hanafuda.card.name_08_3") },
    { name = i18n("hanafuda.card.name_08_4") },
    { name = i18n("hanafuda.card.name_09_1") },
    { name = i18n("hanafuda.card.name_09_2") },
    { name = i18n("hanafuda.card.name_09_3") },
    { name = i18n("hanafuda.card.name_09_4") },
    { name = i18n("hanafuda.card.name_10_1") },
    { name = i18n("hanafuda.card.name_10_2") },
    { name = i18n("hanafuda.card.name_10_3") },
    { name = i18n("hanafuda.card.name_10_4") },
    { name = i18n("hanafuda.card.name_11_1") },
    { name = i18n("hanafuda.card.name_11_2") },
    { name = i18n("hanafuda.card.name_11_3") },
    { name = i18n("hanafuda.card.name_11_4") },
    { name = i18n("hanafuda.card.name_12_1") },
    { name = i18n("hanafuda.card.name_12_2") },
    { name = i18n("hanafuda.card.name_12_3") },
    { name = i18n("hanafuda.card.name_12_4") },
}

---@type CardText[]
this.suitText = {
    { name = i18n("hanafuda.card.suit_01"), alt = i18n("hanafuda.card.suit_alt_01") },
    { name = i18n("hanafuda.card.suit_02"), alt = i18n("hanafuda.card.suit_alt_02") },
    { name = i18n("hanafuda.card.suit_03"), alt = i18n("hanafuda.card.suit_alt_03") },
    { name = i18n("hanafuda.card.suit_04"), alt = i18n("hanafuda.card.suit_alt_04") },
    { name = i18n("hanafuda.card.suit_05"), alt = i18n("hanafuda.card.suit_alt_05") },
    { name = i18n("hanafuda.card.suit_06"), alt = i18n("hanafuda.card.suit_alt_06") },
    { name = i18n("hanafuda.card.suit_07"), alt = i18n("hanafuda.card.suit_alt_07") },
    { name = i18n("hanafuda.card.suit_08"), alt = i18n("hanafuda.card.suit_alt_08") },
    { name = i18n("hanafuda.card.suit_09"), alt = i18n("hanafuda.card.suit_alt_09") },
    { name = i18n("hanafuda.card.suit_10"), alt = i18n("hanafuda.card.suit_alt_10") },
    { name = i18n("hanafuda.card.suit_11"), alt = i18n("hanafuda.card.suit_alt_11") },
    { name = i18n("hanafuda.card.suit_12"), alt = i18n("hanafuda.card.suit_alt_12") },
}

---@type CardText[]
this.typeText = {
    { name = i18n("hanafuda.card.type_0") },
    { name = i18n("hanafuda.card.type_1") },
    { name = i18n("hanafuda.card.type_2") },
    { name = i18n("hanafuda.card.type_3") },
}

---@type {table : number[]} color
this.typeColor = {
    { 255 / 255.0, 128 / 255.0, 0 / 255.0 },
    { 163 / 255.0, 53 / 255.0,  238 / 255.0 },
    { 0 / 255.0,   112 / 255.0, 221 / 255.0 },
    { 30 / 255.0,  255 / 255.0, 0 / 255.0 },
}

return this
