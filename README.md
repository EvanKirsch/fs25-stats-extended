# :trophy: SE - Farming Simulator 25 Stats Extended
SE adds a new tab to the in-game Statistics screen that displays all achievements with their name, description, current progress, and unlock status for the active savegame.

![screenshot 1](https://github.com/EvanKirsch/fs25-stats-extended/blob/master/screenshots/screenshot-1.png)

## :spiral_notepad: Implementation Details
Adds a new "Statistics Extended" tab into the existing statistics menu. The tab displays all achievements registered with `g_achievementManager`.

Progress columns shown per achievement:
- **Unlocked** : Whether the achievement has been unlocked for the user
- **Name** : The achievement's display name
- **Description** : A plain-language description of what I believe to be the unlock condition 
- **Progress (Current Game)** : Current progress toward the target. This is modeled based on research from the `g_achievementManager`. 

## :gear: Manual Install Instructions
1. Download `FS25_statsExtended.zip` from the latest release on the [releases page](https://github.com/EvanKirsch/fs25-stats-extended/releases)
2. Move your downloaded copy of `FS25_statsExtended.zip` to `Documents\My Games\Farming Simulator 2025\mods`

## :hammer_and_wrench: Manual Build Instructions
`git archive -o FS25_statsExtended.zip HEAD`
