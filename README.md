# Hanafuda: Akaviri Playing Cards

This mod allows you to play game (`Koi-Koi`) using `Hanafuda` with MWSE in Morrowind.  
`Hanafuda` is traditional Japanese playing cards and `Koi-Koi` is one of its game rules, but in-game treats them as card games brought by [Akavir](https://en.uesp.net/wiki/Lore:Akavir) and it will aim to make them lore-friendly.

![Featured image of Hanafuda: Akaviri Playing Cards](featured.png)

## Requirements
- Morrowind, Tribunal, Bloodmoon
- The latest nightly build of Morrowind Script Extender 2.1

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
### Card Images
- The aspect ratio is displayed as 32:53 as in the original card.
- Textures must have power-of-2 dimensions.
- Textures must be compressed in DDS format, DXT1 (BC1) for opaque and DXT5 (BC3) for transparent.
  - Engine uses D3D9, so do not add DXT10 header.
  - Mipmaps can be either. If there are generated, it can be reused when playing on 3D is supported.
  - TGA, BMP format can also be used, but are not recommended.

#### File Structure
- Textures/Hanafuda/card
  - &lt;style name&gt;
    - &lt;month with two-digit zero filled&gt;-&lt;sequential numbering in order of type&gt;.dds
      - i.e. 01-1.dds, 01-2.dds, 01-3.dds, 01-4.dds, 02-1.dds, 02-2.dds...
    - back.dds
- If a file is missing, it will fallback to the default style.

### Koi-Koi
- `Hanafuda/KoiKoi` operates Koi-Koi on an MVC-like architecture.
  - game.lua: It corresponds to Model. It is a set of basic game logic.
  - view.lua: It corresponds to View. It provides screen output and receives the player input and notifies Controller.
  - service.lua: It corresponds to Controller. It manages the progress of the entire game, manipulates Models, and provides data for display to View.
  - runner.lua is also Controller that allows automatic play without input from the player.

#### AI (Brain)
- Create an instance that inherits from `KoiKoi.IBrain`.
- Functions:
  - `Reset`: Used for initialization at the start of the game.
  - `Simulate`: Thinking to match cards in hand or drawn with cards on the field.
  - `Call`: When a combo is formed, thinking is whether to continue (Koi-Koi) or end the round (Shobu).
- Because it is single-threaded, it must return `nil` and continue to the next frame if it takes too long to think about it.

### Gamble
- `Hanafuda/Gamble` provides the means to launch Koi-Koi from the world of morrowind.
  - Add the service menu to the dialog menu.
  - Filter actor who have the ability to play Koi-Koi. It also determines if Koi-Koi is currently playable with that actor.
  - Before launching Koi-Koi, a gambling arrangement is made with that actor.
  - Depending on the game result of Koi-Koi, it will affect that actor orand the world of Morrowind.

### Localization
- See MWSE [Mod Translations](https://mwse.github.io/MWSE/guides/mod-translations/) for basic instructions.
- Apart from the game's locale, the terms are replaced with the original language by config. Please keep the original language and replacement code.

## TODO
- See [Project page](https://github.com/longod/Hanafuda/projects?query=is%3Aopen)

## Contributing
I hope you can do it together.  

## Future Work
- Advanced Gambling
- Skill Module (optional)
- Cheat and Spot
- Card movement animation system
- Playing on 3D
- Generalize as a card or board game such as framework
- Other game rules using Hanafuda

## Credits
These assets are not licensed for this project.
- Original card illustration by [MUSKA](https://www.pixiv.net/artworks/47260765)
- Original background image by [Xero Foxx](https://www.nexusmods.com/morrowind/mods/50973)
- Sound effects by [On-Jin](https://on-jin.com/), [Soundeffect-Lab](https://soundeffect-lab.info/) and [Springin' Sound Stock](https://www.springin.org/sound-stock/)
