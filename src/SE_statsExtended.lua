-- SE_statsExtended
-- Main driver class for Stats Extended
--

SE_statsExtended = {}
SE_statsExtended.dir = g_currentModDirectory

function SE_statsExtended:loadMap()
    local gui = SE_statsExtendedGui.new()
    local tabPosition = 6

    self.statsPage = gui:addPage(tabPosition)
end

addModEventListener(SE_statsExtended)
