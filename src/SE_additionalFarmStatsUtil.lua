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
    "revenue",
    "expenses",
    -- "treeTypesCut",
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
