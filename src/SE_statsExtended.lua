-- SE_statsExtended
-- Main driver class for Stats Extended
--

SE_statsExtended = {}
SE_statsExtended.dir = g_currentModDirectory
source(SE_statsExtended.dir .. "src/gui/SE_statsExtendedGui.lua")
source(SE_statsExtended.dir .. "src/gui/SE_statsExtendedController.lua")
source(SE_statsExtended.dir .. "src/SE_achievementStatsUtil.lua")

function SE_statsExtended:loadMap()
    local gui = SE_statsExtendedGui.new()
    local tabPosition = 6

    self.statsPage = gui:addPage(tabPosition)
end

addModEventListener(SE_statsExtended)
