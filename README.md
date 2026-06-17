# :trophy: SE - Farming Simulator 25 Stats Extended
SE adds a new tab to the in-game Statistics screen that displays all achievements and farm statistics for the active savegame.

![screenshot 1](https://github.com/EvanKirsch/fs25-stats-extended/blob/master/screenshots/screenshot-1.png)

## :spiral_notepad: Implementation Details
Adds a new "Statistics Extended" tab into the existing statistics menu. The tab is split into two sections.

### Achievements List
- **Name** : The achievement's display name
- **Description** : A description of what I _believe_ to be the unlock condition
- **Progress** : Current progress toward the target. Shows "Unlocked" once the achievement is earned
Displays all achievements registered with `g_achievementManager`.

### Farm Statistics List
- **Statistic** : Display name of the statistic
- **Session** : The value accumulated in the current play session
- **Total** : The all-time total for the savegame
Displays raw farm stats from the active save, covers breeding counts, distances traveled, field area worked, time spent on tasks, resource usage, harvests, bales, wood, and more. Some of these are duplicated from the existing "Statistics" tab

## :gear: Manual Install Instructions
1. Download `FS25_StatsExtended_update.zip` from the latest release on the [releases page](https://github.com/EvanKirsch/fs25-stats-extended/releases)
2. Move your downloaded copy of `FS25_StatsExtended_update.zip` to `Documents\My Games\Farming Simulator 2025\mods`

## :hammer_and_wrench: Manual Build Instructions
`git archive -o FS25_StatsExtended.zip HEAD`
