-- SE_additionalFarmStatsUtil
-- util to access farm statistics

SE_additionalFarmStatsUtil = {}
SE_additionalFarmStatsUtil.farmStats = {}

local STAT_NAMES = {
    -- Breed
    "breedChickenCount",
    "breedCowsCount",
    "breedGoatsCount",
    "breedHorsesCount",
    "breedPigsCount",
    "breedSheepCount",
    "breedWaterBuffaloCount",
    -- Distance
    "horseDistance",
    "carDistance",
    "tractorDistance",
    "truckDistance",
    "traveledDistance",
    -- Hectares
    "cultivatedHectares",
    "plowedHectares",
    "threshedHectares",
    "sownHectares",
    "sprayedHectares",
    "weededHectares",
    "workedHectares",
    -- Time
    "cultivatedTime",
    "plowedTime",
    "threshedTime",
    "sownTime",
    "sprayedTime",
    "weededTime",
    "workedTime",
    "playTime",
    -- Usage
    "sprayUsage",
    "seedUsage",
    "fuelUsage",
    -- Harvested
    "harvestedGrapes",
    "harvestedOlives",
    -- Bales
    "baleCount",
    "storedBales",
    "wrappedBales",
    -- Wood
    "plantedTreeCount",
    "cutTreeCount",
    "woodTonsSold",
    -- Misc?
    "workersHired",
    "horseJumpCount",
    "storedPallets",
    "windTurbineCount",
    "soldCottonBales",
    "repaintVehicleCount",
    "repairVehicleCount",
    "missionCount",
    "petDogCount",
    -- Finances? These seem off
    "revenue",
    "expenses",
    -- "treeTypesCut" **Not a table**, not implemented?
}

local STAT_FORMATERS = {
    ["cultivatedTime"] = function(s) return Utils.formatTime(s) end,
    ["plowedTime"]     = function(s) return Utils.formatTime(s) end,
    ["threshedTime"]   = function(s) return Utils.formatTime(s) end,
    ["sownTime"]       = function(s) return Utils.formatTime(s) end,
    ["sprayedTime"]    = function(s) return Utils.formatTime(s) end,
    ["weededTime"]     = function(s) return Utils.formatTime(s) end,
    ["workedTime"]     = function(s) return Utils.formatTime(s) end,
    ["playTime"]       = function(s) return Utils.formatTime(s) end,
}

function SE_additionalFarmStatsUtil:populate()
    self.farmStats = {}

    local mission = g_currentMission
    local farm = mission ~= nil and g_farmManager:getFarmById(mission:getFarmId()) or nil
    if farm == nil then return end

    local statistics = farm.stats.statistics

    for _, statName in ipairs(STAT_NAMES) do
        local stat = statistics[statName]
        local funcStatFormater = STAT_FORMATERS[statName] and STAT_FORMATERS[statName] or math.floor
        if stat ~= nil then
            local wrapper = {
                name    = g_i18n:getText("ui_se_stat_" .. statName),
                session = tostring(funcStatFormater(stat.session)),
                total   = tostring(funcStatFormater(stat.total)),
            }
            table.insert(self.farmStats, wrapper)
        end
    end
end
