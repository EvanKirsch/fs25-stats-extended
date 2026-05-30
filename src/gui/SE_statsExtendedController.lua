 -- SE_statsExtendedController
--
-- controller for stats extended display
--

SE_statsExtendedController = {}
local dir = g_currentModDirectory
SE_statsExtendedController._mt = Class(SE_statsExtendedController, FrameElement)

function SE_statsExtendedController.register()
    local statsExtendedPage = SE_statsExtendedController.new()

    g_gui:loadProfiles(Utils.getFilename("gui/SE_guiProfiles.xml", dir))
    g_gui:loadGui(Utils.getFilename("gui/SE_statsExtendedPage.xml", dir), "StatsExtendedPage", statsExtendedPage)

    return statsExtendedPage
end

function SE_statsExtendedController:onFrameOpen()
    local farm = nil
    if g_localPlayer ~= nil then
        farm = g_farmManager:getFarmById(g_localPlayer.farmId)
    end
    self.statsData = farm ~= nil and farm.stats:getStatisticData() or {}
    self.statsExtendedLayout:reloadData()
end

function SE_statsExtendedController:onFrameClose()
    -- no op
end

function SE_statsExtendedController:onTabOpen()
    -- no op
end

function SE_statsExtendedController:getNumberOfSections(list)
    return 1
end

function SE_statsExtendedController:getNumberOfItemsInSection(list, section)
    return self.statsData ~= nil and #self.statsData or 0
end

function SE_statsExtendedController:getTitleForSectionHeader(list, section)
    return nil
end

function SE_statsExtendedController:populateCellForItemInSection(list, section, index, cell)
    local stat = self.statsData[index]
    print(" Popcellitem ")
    DebugUtil.printTableRecursively(stat, "  ", 2, 2)
    if stat == nil then return end
    cell:getAttribute("name"):setText(stat.name)
    cell:getAttribute("session"):setText(stat.valueSession)
    cell:getAttribute("total"):setText(stat.valueTotal)
end

function SE_statsExtendedController.new(subclass_mt)
    local self = FrameElement.new(nil, subclass_mt or SE_statsExtendedController._mt)
    self.statsData = {}
    return self
end

function SE_statsExtendedController:onClickStatsExtended()
    g_inGameMenu.pageStatistics.subCategoryPaging:setState(InGameMenuStatisticsFrame.SUB_CATEGORY.STATS_EXTENDED, true)
end
