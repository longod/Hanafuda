-- UI_ID , not UUID
local this = {
    gameMenu = tes3ui.registerID("KoiKoi"),
    playerHand = tes3ui.registerID("Player.Hand"),
    playerBright = tes3ui.registerID("Player.Bright"),
    playerAnimal = tes3ui.registerID("Player.Animal"),
    playerRibbon = tes3ui.registerID("Player.Ribbon"),
    playerChaff = tes3ui.registerID("Player.Chaff"),
    opponentHand = tes3ui.registerID("Opponent.Hand"),
    opponentBright = tes3ui.registerID("Opponent.Bright"),
    opponentAnimal = tes3ui.registerID("Opponent.Animal"),
    opponentRibbon = tes3ui.registerID("Opponent.Ribbon"),
    opponentChaff = tes3ui.registerID("Opponent.Chaff"),
    boardPile = tes3ui.registerID("Board.Pile"),
    boardGround = tes3ui.registerID("Board.Ground"),
}
return this
