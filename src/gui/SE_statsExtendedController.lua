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
    SE_achievementStatsUtil:populate()
    self.statsData = SE_achievementStatsUtil.achievementStats
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
    local achievement = self.statsData[index]
    if achievement == nil then return end
    cell:getAttribute("unlocked"):setText(achievement.unlocked)
    cell:getAttribute("name"):setText(achievement.name)
    cell:getAttribute("description"):setText(achievement.description)
    cell:getAttribute("progress"):setText(achievement.score .. "/" .. achievement.targetScore)
end

function SE_statsExtendedController.new(subclass_mt)
    local self = FrameElement.new(nil, subclass_mt or SE_statsExtendedController._mt)
    self.statsData = {}
    return self
end

function SE_statsExtendedController:onClickStatsExtended()
    g_inGameMenu.pageStatistics.subCategoryPaging:setState(InGameMenuStatisticsFrame.SUB_CATEGORY.STATS_EXTENDED, true)
end
