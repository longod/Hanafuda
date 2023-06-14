-- Maybe it would be better to divide the points, etc. into smaller pieces for plural
local this = {
    ["playerDefaultName"] = "Outlander",
    ["opponentDefaultName"] = "Jiub",
    ["gamble.collected"] = "You collected %{actual} gold.",
    ["gamble.collectedInsufficient"] = "You tried to collect %{expected} gold, but were only able to collect %{actual} gold.",
    ["gamble.paid"] = "You paid %{actual} gold.",
    ["gamble.paidInsufficient"] = "You have to pay %{expected} gold, but you could only pay %{actual} gold.",
    ["gamble.refusedReason.combat"] = "%{name} seems to be in combat.",
    ["gamble.refusedReason.dead"] = "%{name} is already dead.",
    ["gamble.refusedReason.floating"] = "%{name} He is floating in the air. That's a peek at hand.",
    ["gamble.refusedReason.knocked"] = "%{name} seems to be unconscious.",
    ["gamble.refusedReason.paralyzed"] = "%{name} seems to be stuck.",
    ["gamble.refusedReason.hidden"] = "%{name} doesn't seem to see you.",
    ["gamble.refusedReason.sneaking"] = "%{name} is sneaking.",
    ["gamble.refusedReason.swimming"] = "%{name} is swimming now.",
    ["gamble.refusedReason.fight"] = "%{name} ready to attack at any moment.",
    ["gamble.refusedReason.disposition"] = "%{name} doesn't seem to feel well about you.",
    -- hanafuda card suit (month)
    ["hanafuda.card.suit_01"] = "Mutsuki",
    ["hanafuda.card.suit_02"] = "Kisaragi",
    ["hanafuda.card.suit_03"] = "Yayoi",
    ["hanafuda.card.suit_04"] = "Uzuki",
    ["hanafuda.card.suit_05"] = "Satsuki",
    ["hanafuda.card.suit_06"] = "Minazuki",
    ["hanafuda.card.suit_07"] = "Fumizuki",
    ["hanafuda.card.suit_08"] = "Hazuki",
    ["hanafuda.card.suit_09"] = "Nagatsuki",
    ["hanafuda.card.suit_10"] = "Kannazuki",
    ["hanafuda.card.suit_11"] = "Shimotsuki",
    ["hanafuda.card.suit_12"] = "Shiwasu",
    -- hanafuda card suit alt (flower)
    ["hanafuda.card.suit_alt_01"] = "Matsu",
    ["hanafuda.card.suit_alt_02"] = "Ume",
    ["hanafuda.card.suit_alt_03"] = "Sakura",
    ["hanafuda.card.suit_alt_04"] = "Fuji",
    ["hanafuda.card.suit_alt_05"] = "Kakitsubata",
    ["hanafuda.card.suit_alt_06"] = "Botan",
    ["hanafuda.card.suit_alt_07"] = "Hagi",
    ["hanafuda.card.suit_alt_08"] = "Susuki",
    ["hanafuda.card.suit_alt_09"] = "Kiku",
    ["hanafuda.card.suit_alt_10"] = "Momiji",
    ["hanafuda.card.suit_alt_11"] = "Yanagi",
    ["hanafuda.card.suit_alt_12"] = "Kiri",
    -- hanafuda card type (tier)
    ["hanafuda.card.type_0"] = "Hikari",
    ["hanafuda.card.type_1"] = "Tane",
    ["hanafuda.card.type_2"] = "Tanzaku",
    ["hanafuda.card.type_3"] = "Kasu",
    -- hanafuda card fullname
    ["hanafuda.card.name_01_1"] = "Matsu ni Tsuru",
    ["hanafuda.card.name_01_2"] = "Matsu ni Akatan", -- Akayoroshi
    ["hanafuda.card.name_01_3"] = "Matsu no Kasu",
    ["hanafuda.card.name_01_4"] = "Matsu no Kasu",
    ["hanafuda.card.name_02_1"] = "Ume ni Uguisu",
    ["hanafuda.card.name_02_2"] = "Ume ni Akatan", -- Akayoroshi
    ["hanafuda.card.name_02_3"] = "Ume no Kasu",
    ["hanafuda.card.name_02_4"] = "Ume no Kasu",
    ["hanafuda.card.name_03_1"] = "Sakura ni Maku",
    ["hanafuda.card.name_03_2"] = "Sakura ni Akatan", -- mi-Yoshino
    ["hanafuda.card.name_03_3"] = "Sakura no Kasu",
    ["hanafuda.card.name_03_4"] = "Sakura no Kasu",
    ["hanafuda.card.name_04_1"] = "Fuji ni Hototogisu",
    ["hanafuda.card.name_04_2"] = "Fuji ni Tanzaku",
    ["hanafuda.card.name_04_3"] = "Fuji no Kasu",
    ["hanafuda.card.name_04_4"] = "Fuji no Kasu",
    ["hanafuda.card.name_05_1"] = "Ayame ni Yatsuhashi",
    ["hanafuda.card.name_05_2"] = "Ayame ni Tanzaku",
    ["hanafuda.card.name_05_3"] = "Ayame no Kasu",
    ["hanafuda.card.name_05_4"] = "Ayame no Kasu",
    ["hanafuda.card.name_06_1"] = "Botan ni Chou",
    ["hanafuda.card.name_06_2"] = "Botan ni Aotan",
    ["hanafuda.card.name_06_3"] = "Botan no Kasu",
    ["hanafuda.card.name_06_4"] = "Botan no Kasu",
    ["hanafuda.card.name_07_1"] = "Hagi ni Inoshishi",
    ["hanafuda.card.name_07_2"] = "Hagi ni Tanzaku",
    ["hanafuda.card.name_07_3"] = "Hagi no Kasu",
    ["hanafuda.card.name_07_4"] = "Hagi no Kasu",
    ["hanafuda.card.name_08_1"] = "Susuki ni Tsuki",
    ["hanafuda.card.name_08_2"] = "Susuki ni Kari",
    ["hanafuda.card.name_08_3"] = "Susuki no Kasu",
    ["hanafuda.card.name_08_4"] = "Susuki no Kasu",
    ["hanafuda.card.name_09_1"] = "Kiku ni Sakazuki", -- Kotobuki
    ["hanafuda.card.name_09_2"] = "Kiku ni Aotan",
    ["hanafuda.card.name_09_3"] = "Kiku no Kasu",
    ["hanafuda.card.name_09_4"] = "Kiku no Kasu",
    ["hanafuda.card.name_10_1"] = "Momiji ni Shika",
    ["hanafuda.card.name_10_2"] = "Momiji ni Aotan",
    ["hanafuda.card.name_10_3"] = "Momiji no Kasu",
    ["hanafuda.card.name_10_4"] = "Momiji no Kasu",
    ["hanafuda.card.name_11_1"] = "Yanagi ni Ono no Michikaze",
    ["hanafuda.card.name_11_2"] = "Yanagi ni Tsubame",
    ["hanafuda.card.name_11_3"] = "Yanagi no Kasu",
    ["hanafuda.card.name_11_4"] = "Yanagi no Kasu",
    ["hanafuda.card.name_12_1"] = "Kiri ni Hou-ou",
    ["hanafuda.card.name_12_2"] = "Kiri no Kasu",
    ["hanafuda.card.name_12_3"] = "Kiri no Kasu",
    ["hanafuda.card.name_12_4"] = "Kiri no Kasu",
    -- help
    ["hanafuda.help.summary.header"] = "Hanafuda",
    ["hanafuda.help.summary.description"] =
[[Hanafuda is a traditional Akaviri playing cards known as 'flower cards'.
It features a deck of 48 unique cards divided into 12 suits representing the months of the year.
Hanafuda can be played in various ways with different rulesets and variations.]],
    -- koikoi
    ["koi.service.label"] = "Koi-Koi",
    ["koi.service.tooltip"] = "Let's play Koi-Koi",
    ["koi.service.odds.label"] = "Betting Odds",
    ["koi.service.odds.free"] = "Free",
    ["koi.service.odds.rate"] = "%{count} gold per point",
    ["koi.service.odds.disabled"] = "You or the opponent does not have sufficient ability to pay.",
    ["koi.service.payout"] = "Minimum payout for conceding: %{count}",
    ["koi.koikoi"] = "Koi-Koi",
    ["koi.shobu"] = "Shobu",
    ["koi.combinations.label"] = "Combinations", -- yaku
    ["koi.luckyHands.label"] = "Lucky Hands", -- teyaku
    ["koi.opponentCard"] = "Opponent's card",
    ["koi.deck.name"] = "Deck",
    ["koi.deck.remain"] = { one = "%{count} card remaining", other = "%{count} cards remaining"},
    ["koi.help.more"] = "More Informations",
    ["koi.help.tldr.header"] = "Quick Rules of Koi-Koi",
    ["koi.help.tldr.description"] =
[[1. A card is captured that matches the same suit in one hand and a card in the ground. If it does not match, a card is discarded from the hand.
2. Draw a card from the deck and do the same.
3. This is repeated alternately, with the player's turns swapped.
4. When a combo is created with the captured cards, the player decides whether to continue (Koi-Koi) to create better combos or win the round (Shobu).
5. The player with the highest total points wins At the end of the game.]],
    ["koi.help.tips.header"] = "Tips",
    ["koi.help.tips.description"] =
[[It is to make the combo faster than the opponent and at the same time prevent the opponent from making the combo.
Also, aim for a high score by calling Koi-Koi.]],
    ["koi.help.summary.header"] = "Koi-Koi",
    ["koi.help.summary.description"] =
[[Koi-koi is a popular game played with Hanafuda cards in Akavir.
The objective of Koi-koi is to accumulate points by collecting specific card combinations during the game. The game is typically played over several rounds, and the player with the highest score at the end wins.
Koi-koi is a strategic game that combines luck and skill in forming combinations and deciding when to continue or stop a round. It is a popular and enjoyable way to play with Hanafuda cards.]],
    ["koi.help.rule.header"] = "How to play Koi-Koi",
    ["koi.help.rule.setup.header"] = "Setup",
    ["koi.help.rule.setup.description"] =
[[Players who takes the face-down Hanafuda card and Whoever chooses the card of the early month becomes the dealer (Oya). If it is the same month, it is decided by the higher type of card. The person who does not is the player (Ko).
The dealer shuffles the deck and after dealing 8 cards each to the players and the ground, the turn begins with the dealer.]],
    ["koi.help.rule.luckyHands.header"] = "Lucky Hands",
    ["koi.help.rule.luckyHands.description"] =
[[After the cards are dealt, if the hand contains some combination of cards, the player reveals his or her cards to end the round.
This is a compensation for a hand that is difficult to win even if the game continues.
If both players hold lucky hands, this round is a tie and no score.]],
    ["koi.help.rule.turn.header"] = "Turns",
    ["koi.help.rule.turn.match.header"] = "Matching from the Hand",
    ["koi.help.rule.turn.match.description"] =
[[Select a card from the hand, choose a card in the ground with a matching suit, and capture them.
Or discard the unmatched card from the hand to the ground.
If there is even one matching card on the ground, it cannot be discarded and must be matched to be captured.
If the palyer have a matching card in the hand, the player can still choose another unmatched card to discard, but without much benefit.]],
    ["koi.help.rule.turn.draw.header"] = "Matching with Drawn Card",
    ["koi.help.rule.turn.draw.description"] =
[[A card is drawn from the deck, turned face up.
As with the hand, it matched with a card on the ground to capture them, or discarded on the ground if not possible.]],
    ["koi.help.rule.turn.check.header"] = "Checking for Combinations",
    ["koi.help.rule.turn.check.description"] =
[[Check to see if combinations are formed with the capturesd cards, the player declare one of the following.]],
    ["koi.help.rule.turn.check.continue.header"] = "Calling 'Koi-Koi'",
    ["koi.help.rule.turn.check.continue.description"] =
[[If 'Koi-Koi' is selected, the game continues. This is to aim for better combinations. The next time the palyer can declare them when combinations is updated.
The phrase 'koi-Koi' roughly means 'Come on'.]],
    ["koi.help.rule.turn.check.end.header"] = "Calling 'Shobu'",
    ["koi.help.rule.turn.check.end.description"] =
[[If 'Shobu' is selected, that player wins the round with current combinations.
The phrase 'Shobu' roughly means 'The game is won'.]],
    ["koi.help.rule.round.header"] = "End of Round",
    ["koi.help.rule.round.description"] =
[[There are two conditions for the end of a round.]],
    ["koi.help.rule.round.scoring.header"] = "The Player Wins",
    ["koi.help.rule.round.scoring.description"] =
[[The player who declares 'Shobu' and wins is awarded points according to combinations. The winning player becomes the dealer and goes to the next round.
Depending on the house rules, the multiplier are determined by the number of times 'Koi-Koi' is declared or base points, which is then multiplied.]],
    ["koi.help.rule.round.emptyDeck.header"] = "Both Players' Hands are Empty",
    ["koi.help.rule.round.emptyDeck.description"] =
[[If both players run out of cards in their hands at the end of the turn, the round ends in a tie.
Depending on the house rules, either the dealer or the player scores points, or the dealer and the player are swapped to go to the next round.]],
    ["koi.help.rule.end.header"] = "End of Game",
    ["koi.help.rule.end.description"] =
[[The player with the highest total score after repeating the specified number of rounds is the winner of the game.
The number of rounds is usually 3, 6, or 12; 12 comes from the number of months.]],
    ["koi.view.drawGame"] = "Draw Game",
    ["koi.view.winGame"] = "%{name} Wins!",
    ["koi.view.loseGame"] = "%{name} Loses!",
    ["koi.view.gameResult"] = { one = "%{name}: %{count} point", other = "%{name}: %{count} points"},
    ["koi.view.exitMessage"] = "Exit and you lose.",
    ["koi.view.drawRound"] = "Draw in this round.",
    ["koi.view.winRound"] = "%{name} wins in this round.",
    ["koi.view.luckyHands.label"] = "Lucky Hands", -- teyaku
    ["koi.view.luckyHands.player"] = { one = "%{name} holds lucky hands with %{count} point", other = "%{name} holds lucky hands with %{count} points"},
    ["koi.view.luckyHands.description"] = "Lucky Hands",
    ["koi.view.callKoi"] = "%{name} calls Koi-Koi.",
    ["koi.view.callShobu"] = { one = "%{name} calls Shobu with %{count} point.", other = "%{name} calls Shobu with %{count} points."},
    ["koi.view.callingHeader"] = "%{name}'s Calling",
    ["koi.view.callingMessage"] = { one = "Choose Koi-Koi or Shobu with %{count} point.\nBase point: %{base} Multiplier: x%{mult}", other = "Choose Koi-Koi or Shobu with %{count} points.\nBase point: %{base}, Multiplier: x%{mult}."},
    ["koi.view.koiTooltip"] = "Continue for more combos",
    ["koi.view.shobuTooltip"] = "You Win",
    ["koi.view.callingConfirmMessage"] = { one = "%{name} collected a total of %{count} point combos.\nBase point: %{base} Multiplier: x%{mult}", other = "%{name} collected a total of %{count} points combos.\nBase point: %{base} Multiplier: x%{mult}"},
    ["koi.view.point"] = { one = "%{count} point", other = "%{count} points"},
    ["koi.view.round"] = "Round: %{count} / %{max}",
    ["koi.view.parent"] = "Oya",
    ["koi.view.child"] = "Ko",
    ["koi.view.decideParentMessage"] = "Whoever chooses the card of the early month becomes the dealer.",
    ["koi.view.decideParentTooltip"] = "Choose a card.",
    ["koi.view.leftCard"] = "Left card",
    ["koi.view.rightCard"] = "Right card",
    ["koi.view.informParentHeader"] = "%{name} is Oya",
    ["koi.view.informParentMessage"] = "Oya is the dealer and is the first to play.",
    ["koi.view.informParentPick"] = "%{name} picked:",
    ["koi.view.infoGround"] = "Can't a card match from hand now.",
    ["koi.view.infoPutback"] = "Can't put back this card in hand",
    ["koi.view.infoHand"] = "Can't match this card with",
    ["koi.view.infoDiscard"] = "Can't discard this card, it shoud be matched.",
    ["koi.view.infoDraw"] = "Can't draw a card now.",
    ["koi.view.beginTurn"] = "%{name}'s Turn",
    ["koi.view.hand.player"] = "Your hand",
    ["koi.view.hand.opponent"] = "Opponent's hand",
    ["koi.view.capturedTooltip.player"] = "%{name} cards captured by you are placed.",
    ["koi.view.capturedTooltip.opponent"] = "%{name} cards captured by opponent are placed.",
    ["koi.view.capturedLabel"] = "%{name}'s Captured Cards",
    ["koi.view.exit"] = "Concede",
    ["koi.view.cardList"] = "Cards",
    ["koi.view.comboList"] = "Combos",
    ["koi.view.quickRule"] = "Rule",
    ["koi.view.totalScore"] = "Total Score: ",
    ["koi.view.roundCombo"] = "Combos in this round:",
    -- koikoi combo
    ["koi.combo.fiveBrights.name"] = "Goko",
    ["koi.combo.fiveBrights.point"] = "%{count} points.",
    ["koi.combo.fiveBrights.condition"] = "All 5 %{type} cards.",
    ["koi.combo.fourBrights.name"] = "Shiko",
    ["koi.combo.fourBrights.point"] = "%{count} points.",
    ["koi.combo.fourBrights.condition"] = "All 4 %{type} cards without %{symbol}.",
    ["koi.combo.rainyFourBrights.name"] = "Ame-Shiko",
    ["koi.combo.rainyFourBrights.point"] = "%{count} points.",
    ["koi.combo.rainyFourBrights.condition"] = "Any 4 %{type} cards.",
    ["koi.combo.threeBrights.name"] = "Sanko",
    ["koi.combo.threeBrights.point"] = "%{count} points.",
    ["koi.combo.threeBrights.condition"] = "Any 3 %{type} cards.",
    ["koi.combo.boarDeerButterfly.name"] = "Ino-Shika-Cho",
    ["koi.combo.boarDeerButterfly.point"] = "%{count} points.",
    ["koi.combo.boarDeerButterfly.condition"] = "%{symbol1}, %{symbol2} and %{symbol3}.",
    ["koi.combo.animals.name"] = "Tane",
    ["koi.combo.animals.point"] = "%{count} point and 1 additional point for each additional %{type} card.",
    ["koi.combo.animals.condition"] = "Any five %{type} cards.",
    ["koi.combo.poetryAndBlueRibbons.name"] = "Akatan-Aotan",
    ["koi.combo.poetryAndBlueRibbons.point"] = "%{count} points and 1 additional point for each additional %{type} card.",
    ["koi.combo.poetryAndBlueRibbons.condition"] = "All 3 Poetry %{type} cards and all 3 Blue %{type} cards.",
    ["koi.combo.poetryRibbons.name"] = "Akatan",
    ["koi.combo.poetryRibbons.point"] = "%{count} points and 1 additional point for each additional %{type} card.",
    ["koi.combo.poetryRibbons.condition"] = "%{symbol1}, %{symbol2} and %{symbol3}.",
    ["koi.combo.blueRibbons.name"] = "Aotan",
    ["koi.combo.blueRibbons.point"] = "%{count} points and 1 additional point for each additional %{type} card.",
    ["koi.combo.blueRibbons.condition"] = "%{symbol1}, %{symbol2} and %{symbol3}.",
    ["koi.combo.ribbons.name"] = "Tan",
    ["koi.combo.ribbons.point"] = "%{count} point and 1 additional point for each additional %{type} card.",
    ["koi.combo.ribbons.condition"] = "Any 5 %{type} cards.",
    ["koi.combo.flowerViewingSake.name"] = "Hanami-Zake",
    ["koi.combo.flowerViewingSake.point"] = "%{count} points.",
    ["koi.combo.flowerViewingSake.condition"] = "%{symbol1} and %{symbol2}.",
    ["koi.combo.moonViewingSake.name"] = "Tsukimi-Zake",
    ["koi.combo.moonViewingSake.point"] = "%{count} points.",
    ["koi.combo.moonViewingSake.condition"] = "%{symbol1} and %{symbol2}.",
    ["koi.combo.chaff.name"] = "Kasu",
    ["koi.combo.chaff.point"] = "%{count} point and 1 additional point for each additional %{type} card.",
    ["koi.combo.chaff.condition"] = "Any 10 %{type} cards.",
    ["koi.luckyHands.fourOfAKind.name"] = "Teshi",
    ["koi.luckyHands.fourOfAKind.point"] = "%{count} points.",
    ["koi.luckyHands.fourOfAKind.condition"] = "All 4 cards of any given suits.",
    ["koi.luckyHands.fourPairs.name"] = "Kuttsuki",
    ["koi.luckyHands.fourPairs.point"] = "%{count} points.",
    ["koi.luckyHands.fourPairs.condition"] = "Four pairs, a pair being 2 cards of the same suit.",
    -- mcm
    ["mcm.default"] = "Default: ",
    ["mcm.page.label"] = "Settings",
    ["mcm.page.description"] = "Let's play Koi-Koi with Hanafuda.",
    ["mcm.hanafuda.category"] = "Hanafuda",
    ["mcm.hanafuda.cardLanguage.label"] = "Card Language",
    ["mcm.hanafuda.cardLanguage.description"] = "Akaviri: Original language (Japanese)\nTamrielic: Tamrielic translation (English)",
    ["mcm.hanafuda.cardLanguage.japanese"] = "Akaviri",
    ["mcm.hanafuda.cardLanguage.tamrielic"] = "Tamrielic",
    ["mcm.hanafuda.tooltipImage.label"] = "Display card image in tooltip",
    ["mcm.hanafuda.tooltipImage.description"] = "Display large card images in tooltips, but if 'Menu Help Delay' is fast, it disturbs gameplay.",
    ["mcm.koi.category"] = "Koi-Koi",
    ["mcm.koi.round.label"] = "Number of Rounds",
    ["mcm.koi.round.description"] = "Number of rounds played during one game.",
    ["mcm.koi.houseRule.category"] = "House Rules",
    ["mcm.koi.houseRule.multiplier.label"] = "Score Multiplier",
    ["mcm.koi.houseRule.multiplier.description"] = "None: No multiplier\nDouble at least 7: The x2 multiplier earned for having a base score of at least 7\nEach time Koi-Koi was called: Multiplier equal to the number of times Koi-Koi was called in this round",
    ["mcm.koi.houseRule.multiplier.none"] = "None",
    ["mcm.koi.houseRule.multiplier.doublePointsOver7"] = "Double at least 7",
    ["mcm.koi.houseRule.multiplier.eachTimeKoiKoi"] = "Each time Koi-Koi was called",
    ["mcm.koi.houseRule.flowerViewingSake.label"] = "Enable %{name}",
    ["mcm.koi.houseRule.flowerViewingSake.description"] = "%{name} is powerful and often banned.",
    ["mcm.koi.houseRule.moonViewingSake.label"] = "Enable %{name}",
    ["mcm.koi.houseRule.moonViewingSake.description"] = "%{name} is powerful and often banned.",
    ["mcm.audio.category"] = "Audio",
    ["mcm.audio.playerVoice.label"] = "Player Voice",
    ["mcm.audio.playerVoice.description"] = "Player character talks according to the game situation.",
    ["mcm.audio.npcVoice.label"] = "NPC Voice",
    ["mcm.audio.npcVoice.description"] = "NPCs talk according to the game situation.",
    ["mcm.development.category"] = "Development",
    ["mcm.development.logLevel.label"] = "Logging Level",
    ["mcm.development.logLevel.description"] = "Set the log level.",
    ["mcm.development.logToConsole.label"] = "Log to Console",
    ["mcm.development.logToConsole.description"] = "Output the log to console.",
    ["mcm.development.debug.label"] = "Debug Mode",
    ["mcm.development.debug.description"] = "Enable debug features.",
    ["mcm.development.unittest.label"] = "Unit-Test",
    ["mcm.development.unittest.description"] = "Run unit-test.",
}

-- Hack to use multiple localizations in a single language
-- i18n must not be included by require nesting
local settings = require("Hanafuda.settings")
local config = require("Hanafuda.config")
if config.cardLanguage == settings.cardLanguage.tamrielic then
    -- overwrite
    local lang = require("Hanafuda.i18n.tamrielic")
    table.copy(lang, this)
end


return this
