-- define card data, user non configuable.

-- todo test missing indices

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

--- altanative of suit
---@enum CardFlower
this.cardFlower = {
    pine = 1,
    plumBlossoms = 2,
    cherryBlossoms = 3,
    wisteria = 4,
    iris = 5,
    peony = 6,
    bushClover = 7,
    pampas = 8,
    chrysanthemum = 9,
    maple = 10,
    willow = 11,
    paulownia = 12,
}
assert(table.size(this.cardSuit) == table.size(this.cardFlower))

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
this.cardWidth = math.ceil( 32 * 1.5 ) ---@type number
this.cardHeight = math.ceil( 53 * 1.5 ) ---@type number
assert(this.cardCount > 0)
assert(this.cardWidth > 0)
assert(this.cardHeight > 0)

---@class CardAsset
---@field path string

---@type CardAsset[]
this.cardAssets = {
    { path = "Textures/Hanafuda/01-1.dds" },
    { path = "Textures/Hanafuda/01-2.dds" },
    { path = "Textures/Hanafuda/01-3.dds" },
    { path = "Textures/Hanafuda/01-4.dds" },
    { path = "Textures/Hanafuda/02-1.dds" },
    { path = "Textures/Hanafuda/02-2.dds" },
    { path = "Textures/Hanafuda/02-3.dds" },
    { path = "Textures/Hanafuda/02-4.dds" },
    { path = "Textures/Hanafuda/03-1.dds" },
    { path = "Textures/Hanafuda/03-2.dds" },
    { path = "Textures/Hanafuda/03-3.dds" },
    { path = "Textures/Hanafuda/03-4.dds" },
    { path = "Textures/Hanafuda/04-1.dds" },
    { path = "Textures/Hanafuda/04-2.dds" },
    { path = "Textures/Hanafuda/04-3.dds" },
    { path = "Textures/Hanafuda/04-4.dds" },
    { path = "Textures/Hanafuda/05-1.dds" },
    { path = "Textures/Hanafuda/05-2.dds" },
    { path = "Textures/Hanafuda/05-3.dds" },
    { path = "Textures/Hanafuda/05-4.dds" },
    { path = "Textures/Hanafuda/06-1.dds" },
    { path = "Textures/Hanafuda/06-2.dds" },
    { path = "Textures/Hanafuda/06-3.dds" },
    { path = "Textures/Hanafuda/06-4.dds" },
    { path = "Textures/Hanafuda/07-1.dds" },
    { path = "Textures/Hanafuda/07-2.dds" },
    { path = "Textures/Hanafuda/07-3.dds" },
    { path = "Textures/Hanafuda/07-4.dds" },
    { path = "Textures/Hanafuda/08-1.dds" },
    { path = "Textures/Hanafuda/08-2.dds" },
    { path = "Textures/Hanafuda/08-3.dds" },
    { path = "Textures/Hanafuda/08-4.dds" },
    { path = "Textures/Hanafuda/09-1.dds" },
    { path = "Textures/Hanafuda/09-2.dds" },
    { path = "Textures/Hanafuda/09-3.dds" },
    { path = "Textures/Hanafuda/09-4.dds" },
    { path = "Textures/Hanafuda/10-1.dds" },
    { path = "Textures/Hanafuda/10-2.dds" },
    { path = "Textures/Hanafuda/10-3.dds" },
    { path = "Textures/Hanafuda/10-4.dds" },
    { path = "Textures/Hanafuda/11-1.dds" },
    { path = "Textures/Hanafuda/11-2.dds" },
    { path = "Textures/Hanafuda/11-3.dds" },
    { path = "Textures/Hanafuda/11-4.dds" },
    { path = "Textures/Hanafuda/12-1.dds" },
    { path = "Textures/Hanafuda/12-2.dds" },
    { path = "Textures/Hanafuda/12-3.dds" },
    { path = "Textures/Hanafuda/12-4.dds" },
}
assert(table.size(this.cardAssets) == this.cardCount)

---@type CardAsset
this.cardBackAsset = { path = "Textures/Tx_fabric_tapestry_04.dds" }
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

-- todo tamriel version.
-- original japanese version.
-- switch i18n (user friendly) or lore friendly describe

---@class CardText
---@field name string

---@type CardText[]
this.cardText = {
    { name = "Matsu ni Tsuru" },
    { name = "Matsu ni Akatan" }, -- Akayoroshi
    { name = "Matsu no Kasu" },
    { name = "Matsu no Kasu" },
    { name = "Ume ni Uguisu" },
    { name = "Ume ni Akatan" }, -- Akayoroshi
    { name = "Ume no Kasu" },
    { name = "Ume no Kasu" },
    { name = "Sakura ni Maku" },
    { name = "Sakura ni Akatan" }, -- mi-Yoshino
    { name = "Sakura no Kasu" },
    { name = "Sakura no Kasu" },
    { name = "Fuji ni Hototogisu" },
    { name = "Fuji ni Tanzaku" },
    { name = "Fuji no Kasu" },
    { name = "Fuji no Kasu" },
    { name = "Ayame ni Yatsuhashi" },
    { name = "Ayame ni Tanzaku" },
    { name = "Ayame no Kasu" },
    { name = "Ayame no Kasu" },
    { name = "Botan ni Chou" },
    { name = "Botan ni Aotan" },
    { name = "Botan no Kasu" },
    { name = "Botan no Kasu" },
    { name = "Hagi ni Inoshishi" },
    { name = "Hagi ni Tanzaku" },
    { name = "Hagi no Kasu" },
    { name = "Hagi no Kasu" },
    { name = "Susuki ni Tsuki" },
    { name = "Susuki ni Kari" },
    { name = "Susuki no Kasu" },
    { name = "Susuki no Kasu" },
    { name = "Kiku ni Sakazuki" }, -- Kotobuki
    { name = "Kiku ni Aotan" },
    { name = "Kiku no Kasu" },
    { name = "Kiku no Kasu" },
    { name = "Momiji ni Shika" },
    { name = "Momiji ni Aotan" },
    { name = "Momiji no Kasu" },
    { name = "Momiji no Kasu" },
    { name = "Yanagi ni Ono no Michikaze" },
    { name = "Yanagi ni Tsubame" },
    { name = "Yanagi no Kasu" },
    { name = "Yanagi no Kasu" },
    { name = "Kiri ni Hou-ou" },
    { name = "Kiri no Kasu" },
    { name = "Kiri no Kasu" },
    { name = "Kiri no Kasu" },
}
assert(table.size(this.cardText) == this.cardCount)

---@type CardText[]
this.suitText = {
    { name = "Mutsuki" },
    { name = "Kisaragi" },
    { name = "Yayoi" },
    { name = "Uzuki" },
    { name = "Satsuki" },
    { name = "Minazuki" },
    { name = "Fumizuki" },
    { name = "Hazuki" },
    { name = "Nagatsuki" },
    { name = "Kannazuki" },
    { name = "Shimotsuki" },
    { name = "Shiwasu" },
}
assert(table.size(this.suitText) == table.size(this.cardSuit))

---@type CardText[]
this.typeText = {
    { name = "Hikari" },
    { name = "Tane" },
    { name = "Tanzaku" },
    { name = "Kasu" },
}
assert(table.size(this.typeText) == table.size(this.cardType))

---@type {table : number[]} color
this.typeColor = {
    { 255 / 255.0, 128 / 255.0, 0 / 255.0 },
    { 163 / 255.0, 53 / 255.0,  238 / 255.0 },
    { 0 / 255.0,   112 / 255.0, 221 / 255.0 },
    { 30 / 255.0,  255 / 255.0, 0 / 255.0 },
}
assert(table.size(this.typeColor) == table.size(this.cardType))

return this
