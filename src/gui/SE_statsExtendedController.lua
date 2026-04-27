-- SE_statsExtendedController
--
-- controller for stats extended display
--

print("Initiliazing SE_statsExtendedController")
SE_statsExtendedController = {}
local dir = g_currentModDirectory
SE_statsExtendedController._mt = Class(SE_statsExtendedController, FrameElement)

function SE_statsExtendedController.register()
    print("registering SE_statsExtenededController")
    local statsExtendedPage = SE_statsExtendedController.new()

    g_gui:loadGui(Utils.getFilename("gui/SE_statsExtendedPage.xml", dir), "StatsExtendedPage", statsExtendedPage)

    print("registed SE_statsExtenededController")
    -- DebugUtil.printTableRecursively(statsExtendedPage)

    return statsExtendedPage
end

function SE_statsExtendedController:onFrameOpen()
    self.statsExtendedLayout:invalidateLayout()
end

function SE_statsExtendedController:onFrameClose()
    -- no op
end

function SE_statsExtendedController:onTabOpen()
   -- no op
end

function SE_statsExtendedController.new(subclass_mt)
    print("new SE_statsExtenededController")
    local self = FrameElement.new(nil, subclass_mt or SE_statsExtendedController._mt)
    return self
end

function SE_statsExtendedController:onClickStatsExteneded()
    g_inGameMenu.pageStatistics.subCategoryPaging:setState(InGameMenuStatisticsFrame.SUB_CATEGORY.STATS_EXTENDED, true)
end
