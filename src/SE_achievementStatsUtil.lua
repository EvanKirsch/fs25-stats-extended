-- SE_achievementStatsUtil
-- util to access achievementStats

SE_achievementStatsUtil = {}
SE_achievementStatsUtil.achievementStats = {}

local SCORE_BY_ID = {
    ["PlayTime"]             = function(s, _) return math.floor(s:getTotalValue("playTime") / 60 + 0.0001) end,
    ["Money"]                = function(_, f) return f.money end,
    ["CultivateFirst"]       = function(s, _) return s:getTotalValue("cultivatedHectares") end,
    ["Cultivate"]            = function(s, _) return s:getTotalValue("cultivatedHectares") end,
    ["SowFirst"]             = function(s, _) return s:getTotalValue("sownHectares") end,
    ["Sow"]                  = function(s, _) return s:getTotalValue("sownHectares") end,
    ["FertilizeFirst"]       = function(s, _) return s:getTotalValue("sprayedHectares") end,
    ["Fertilize"]            = function(s, _) return s:getTotalValue("sprayedHectares") end,
    ["HarvestedFirst"]       = function(s, _) return s:getTotalValue("threshedHectares") end,
    ["Harvested"]            = function(s, _) return s:getTotalValue("threshedHectares") end,
    ["BreedCows"]            = function(s, _) return s:getTotalValue("breedCowsCount") end,
    ["BreedSheep"]           = function(s, _) return s:getTotalValue("breedSheepCount") end,
    ["BreedPigs"]            = function(s, _) return s:getTotalValue("breedPigsCount") end,
    ["BreedChicken"]         = function(s, _) return s:getTotalValue("breedChickenCount") end,
    ["TractorDriving"]       = function(s, _) return s:getTotalValue("tractorDistance") end,
    ["TruckDriving"]         = function(s, _) return s:getTotalValue("truckDistance") end,
    ["CarDriving"]           = function(s, _) return s:getTotalValue("carDistance") end,
    ["HorseRidingFirst"]     = function(s, _) return s:getTotalValue("horseDistance") end,
    ["HorseRiding"]          = function(s, _) return s:getTotalValue("horseDistance") end,
    ["HorseJumpsFirst"]      = function(s, _) return s:getTotalValue("horseJumpCount") end,
    ["HorseJumps"]           = function(s, _) return s:getTotalValue("horseJumpCount") end,
    ["MissionFirst"]         = function(s, _) return s:getTotalValue("missionCount") end,
    ["Mission"]              = function(s, _) return s:getTotalValue("missionCount") end,
    ["VehicleRepaint"]       = function(s, _) return s:getTotalValue("repaintVehicleCount") end,
    ["VehicleRepairFirst"]   = function(s, _) return s:getTotalValue("repairVehicleCount") end,
    ["VehicleRepair"]        = function(s, _) return s:getTotalValue("repairVehicleCount") end,
    ["NumBeehives"]          = function(_, f) return SE_achievementStatsUtil:getBeehives(f.farmId) end,
    ["NumDrivables"]         = function(_, f) return SE_achievementStatsUtil:getDrivableVehicles(f.farmId) end,
    ["NumVehiclesSmall"]     = function(_, f) return SE_achievementStatsUtil:getVehicles(f.farmId) end,
    ["NumVehiclesLarge"]     = function(_, f) return SE_achievementStatsUtil:getVehicles(f.farmId) end,
    ["PetDog"]               = function(s, _) return s:getTotalValue("petDogCount") end,
    ["WrappedBales"]         = function(s, _) return s:getTotalValue("wrappedBales") end,
    ["CottonBales"]          = function(s, _) return s:getTotalValue("soldCottonBales") end,
    ["CutTreeFirst"]         = function(s, _) return s:getTotalValue("cutTreeCount") end,
    ["CutTree"]              = function(s, _) return s:getTotalValue("cutTreeCount") end,
    ["NumPlaceables"]        = function(_, f) return SE_achievementStatsUtil:getPlaceables(f.farmId) end,
    ["NumProductionPoints"]  = function(_, f) return SE_achievementStatsUtil:getProductionPoints(f.farmId) end,
    ["CollectiblesUS"]       = function(_, _) return SE_achievementStatsUtil:getCollectableSystemInfo("CollectiblesUS") end,
    ["CollectiblesAS"]       = function(_, _) return SE_achievementStatsUtil:getCollectableSystemInfo("CollectiblesAS") end,
    ["CollectiblesEU"]       = function(_, _) return SE_achievementStatsUtil:getCollectableSystemInfo("CollectiblesEU") end,
    -- LoadedOldSavegame (not implemented)
}

function SE_achievementStatsUtil:populate()
    self.achievementStats = {}

    local mission = g_currentMission
    local farm = mission ~= nil and g_farmManager:getFarmById(mission:getFarmId()) or nil
    local stats = farm ~= nil and farm.stats or nil

    local fillTypeScores = {}
    for _, fta in ipairs(g_achievementManager.fillTypeAchievements) do
        fillTypeScores[fta.name] = fta.fillType.totalAmount
    end

    for _, achievement in ipairs(g_achievementManager.achievementList) do
        local currentScore
        local resolver = SCORE_BY_ID[achievement.idName]
        if achievement.score ~= 0 then
            currentScore = achievement.score
        elseif resolver ~= nil and stats ~= nil then
            currentScore = resolver(stats, farm)
        elseif fillTypeScores[achievement.idName] ~= nil then
            currentScore = fillTypeScores[achievement.idName]
        else
            -- not implemented
            currentScore = 0
        end

        local achievementWrapper = {
            ["idName"]      = achievement.idName,
            ["name"]        = achievement.name,
            ["description"] = g_i18n:getText("ui_se_achievement_" .. achievement.idName),
            ["progress"]    = SE_achievementStatsUtil:getProgress(achievement, currentScore)
        }
        table.insert(self.achievementStats, achievementWrapper)
    end
end

function SE_achievementStatsUtil:getProgress(achievement, currentScore)
    local strLocked = tostring(math.floor(currentScore or 0)) .. "/" .. tostring(achievement.targetScore or 0)
    local strUnlocked = g_i18n:getText("ui_se_stat_unlocked")
    return achievement.unlocked and strUnlocked or strLocked
end

function SE_achievementStatsUtil:getBeehives(farmId)
    local numBeehives = 0
    for _, placeable in ipairs(g_currentMission.placeableSystem.placeables) do
        if placeable:getOwnerFarmId() == farmId and placeable.spec_beehive ~= nil then
            numBeehives = numBeehives + 1
        end
    end
    return numBeehives
end

function SE_achievementStatsUtil:getPlaceables(farmId)
    local numPlaceables = 0
    for _, p in ipairs(g_currentMission.placeableSystem.placeables) do
        if p:getOwnerFarmId() == farmId then
            numPlaceables = numPlaceables + 1
        end
    end
    return numPlaceables
end

function SE_achievementStatsUtil:getProductionPoints(farmId)
    local pp = 0
    for _, p in ipairs(g_currentMission.placeableSystem.placeables) do
        if p:getOwnerFarmId() == farmId and p.spec_productionPoint ~= nil then
            pp = pp + 1
        end
    end
    return pp
end

function SE_achievementStatsUtil:getDrivableVehicles(farmId)
    local numVehicles = 0
    for _, v in ipairs(g_currentMission.vehicleSystem.vehicles) do
        if v:getOwnerFarmId() == farmId and v.spec_drivable ~= nil then
            numVehicles = numVehicles + 1
        end
    end
    return numVehicles
end

function SE_achievementStatsUtil:getVehicles(farmId)
    local numVehicles = 0
    for _, v in ipairs(g_currentMission.vehicleSystem.vehicles) do
        if v:getOwnerFarmId() == farmId
            and (v.spec_drivable ~= nil
                 or (v.spec_attachable ~= nil and v.spec_bigBag == nil))
        then
            numVehicles = numVehicles + 1
        end
    end
    return numVehicles
end

function SE_achievementStatsUtil:getCollectableSystemInfo(cName)
    local cs = g_currentMission.collectiblesSystem
    if cs ~= nil and cs.achievementName == cName then
        return cs:getTotalCollected()
    end
    return 0
end
