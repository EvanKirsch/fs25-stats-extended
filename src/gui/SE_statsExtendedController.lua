-- SE_statsExtendedController
--
-- controller for stats extended display
--

print("Initiliazing SE_statsExtendedController")
SE_statsExtendedController = {}
SE_statsExtendedController._mt = Class(SE_statsExtendedController, FrameElement)

function SE_statsExtendedController.register()
    print("registering SE_statsExtenededController")
    local statsExtendedPage = SE_statsExtendedController.new()

    g_gui:loadGui(Utils.getFilename("gui/SE_statsExtendedPage.xml", SE_statsExtended.dir), "StatsExtendedPage", statsExtendedPage)

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
