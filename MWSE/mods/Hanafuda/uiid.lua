-- UI_ID , not UUID
local this = {
    gameMenu = tes3ui.registerID("KoiKoi"),
    grabMenu = tes3ui.registerID("KoiKoi.Grab"),
    helpCardListMenu = tes3ui.registerID("KoiKoi.CardList"),
    helpComboListMenu = tes3ui.registerID("KoiKoi.ComboList"),
    helpRuleMenu = tes3ui.registerID("KoiKoi.Rule"),
    splashMenu = tes3ui.registerID("KoiKoi.Splash"),
    playerHand = tes3ui.registerID("Player.Hand"),
    playerBright = tes3ui.registerID("Player.Bright"),
    playerAnimal = tes3ui.registerID("Player.Animal"),
    playerRibbon = tes3ui.registerID("Player.Ribbon"),
    playerChaff = tes3ui.registerID("Player.Chaff"),
    playerScore = tes3ui.registerID("Player.Score"),
    playerCombination = tes3ui.registerID("Player.Combination"),
    playerName = tes3ui.registerID("Player.Name"),
    playerDealer = tes3ui.registerID("Player.Dealer"),
    opponentHand = tes3ui.registerID("Opponent.Hand"),
    opponentBright = tes3ui.registerID("Opponent.Bright"),
    opponentAnimal = tes3ui.registerID("Opponent.Animal"),
    opponentRibbon = tes3ui.registerID("Opponent.Ribbon"),
    opponentChaff = tes3ui.registerID("Opponent.Chaff"),
    opponentScore = tes3ui.registerID("Opponent.Score"),
    opponentCombination = tes3ui.registerID("Opponent.Combination"),
    opponentName = tes3ui.registerID("Opponent.Name"),
    opponentDealer = tes3ui.registerID("Opponent.Dealer"),
    boardPile = tes3ui.registerID("Board.Pile"),
    boardDrawn = tes3ui.registerID("Board.Drawn"),
    boardGroundRow0 = tes3ui.registerID("Board.GroundRow0"),
    boardGroundRow1 = tes3ui.registerID("Board.GroundRow1"),
    round = tes3ui.registerID("Board.Round"),
    turn = tes3ui.registerID("Board.Turn"),
    -- dialog
	menuDialog = tes3ui.registerID("MenuDialog"),
    menuDialogDivider = tes3ui.registerID("MenuDialog_divider"),
    menuDialogServiceKoiKoi = tes3ui.registerID("MenuDialog_service_Hanafuda_KoiKoi"),
    -- gambling
    gambleMenu = tes3ui.registerID("KoiKoi.Gamble"),

}
return this
