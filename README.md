# Hanafuda: Akaviri Playing Cards

This mod allows you to play game (`Koi-Koi`) using `Hanafuda` with MWSE in Morrowind.  
`Hanafuda` is traditional Japanese playing cards and `Koi-Koi` is one of its game rules, but in-game treats them as card games brought by [Akavir](https://en.uesp.net/wiki/Lore:Akavir) and it will aim to make them lore-friendly.

## How to play
- This is where `Data Files` is located.
- You can play against NPCs from the service menu by talking to them.
- Or the game can be played instantly by pressing K key. Exit is also K key.
   - You need to enable Debug Mode from mcm.
   - This can also be called from the main menu.
- The game rule is `Koi-Koi` only.
- For information on `Hanafuda` and `Koi-Koi`, please refer to the following documents and others.
  - https://en.wikipedia.org/wiki/Hanafuda
  - https://en.wikipedia.org/wiki/Koi-Koi
  - https://fudawiki.org/en/hanafuda/games/koi-koi

## Specification
- `Hanafuda/KoiKoi` operates Koi-Koi on an MVC-like architecture.
  - game.lua: It corresponds to Model. It is a set of basic game logic.
  - view.lua: It corresponds to View. It provides screen output and receives the player input and notifies Controller.
  - service.lua: It corresponds to Controller. It manages the progress of the entire game, manipulates Models, and provides data for display to View.
  - runner.lua is also Controller that allows automatic play without input from the player.
- `Hanafuda/Gamble` provides the means to launch Koi-Koi from the world of morrowind.
  - Add the service menu to the dialog menu.
  - Filter actor who have the ability to play Koi-Koi. It also determines if Koi-Koi is currently playable with that actor.
  - Before launching Koi-Koi, a gambling arrangement is made with that actor.
  - Depending on the game result of Koi-Koi, it will affect that actor orand the world of Morrowind.

## TODO
- See [Project page](https://github.com/longod/Hanafuda/projects?query=is%3Aopen)

## Contributing
I hope you can do it together.  

## Future Work
- Advanced Gambling
- Skill Module (optional)
- Playing on 3D
- Generalize as a card or board game such as framework
- Other game rules using Hanafuda

