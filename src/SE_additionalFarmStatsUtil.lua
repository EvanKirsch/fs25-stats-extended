-- SE_additionalFarmStatsUtil
-- util to access farm statistics

SE_additionalFarmStatsUtil = {}
SE_additionalFarmStatsUtil.farmStats = {}

local STAT_NAMES = {
    "breedHorsesCount",
    "threshedHectares",
    "breedPigsCount",
    "sownTime",
    "sprayUsage",
    "breedChickenCount",
    "tractorDistance",
    "horseDistance",
    "seedUsage",
    "cultivatedHectares",
    "weededHectares",
    "workersHired",
    "harvestedGrapes",
    "workedHectares",
    "plantedTreeCount",
    "storedPallets",
    "threshedTime",
    "cultivatedTime",
    "breedGoatsCount",
    "expenses",
    "windTurbineCount",
    "sprayedTime",
    "sprayedHectares",
    "traveledDistance",
    "plowedTime",
    "harvestedOlives",
    "soldCottonBales",
    "repaintVehicleCount",
    "breedWaterBuffaloCount",
    "breedCowsCount",
    "baleCount",
    "truckDistance",
    "cutTreeCount",
    "repairVehicleCount",
    "carDistance",
    "breedSheepCount",
    "missionCount",
    "workedTime",
    "petDogCount",
    "sownHectares",
    "playTime",
    "woodTonsSold",
    "revenue",
    "horseJumpCount",
    "storedBales",
    "plowedHectares",
    "treeTypesCut",
    "fuelUsage",
    "wrappedBales",
    "weededTime",
}

function SE_additionalFarmStatsUtil:populate()
    self.farmStats = {}

    local mission = g_currentMission
    local farm = mission ~= nil and g_farmManager:getFarmById(mission:getFarmId()) or nil
    if farm == nil then return end

    local statistics = farm.stats.statistics

    for _, statName in ipairs(STAT_NAMES) do
        local stat = statistics[statName]
        if stat ~= nil then
            local wrapper
            if type(stat) == "table" then
                wrapper = {
                    name    = g_i18n:getText("ui_se_stat_" .. statName),
                    session = tostring(math.floor(stat.session)),
                    total   = tostring(math.floor(stat.total)),
                }
            else
                wrapper = {
                    name    = g_i18n:getText("ui_se_stat_" .. statName),
                    session = tostring(stat),
                    total   = tostring(stat),
                }
            end
            table.insert(self.farmStats, wrapper)
        end
    end
end
