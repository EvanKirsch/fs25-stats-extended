-- SE_statsExtendedGui
--
-- gui extention to configure stats extended display controller
--

print("Init SE_statsExtendedGui")
SE_statsExtendedGui = {}
SE_statsExtendedGui._mt = Class(SE_statsExtendedGui)

function SE_statsExtendedGui.new(custom_mt)
    print("creating SE_statsExtendedGui")
    local self = setmetatable({}, custom_mt or SE_statsExtendedGui._mt)
    local statsFrame = g_inGameMenu.pageStatistics

    SE_statsExtendedGui.appendFunction(statsFrame, "onFrameOpen", self, "onFrameOpen")
    SE_statsExtendedGui.prependedFunction(statsFrame, "onFrameClose", self, "onFrameClose")
    SE_statsExtendedGui.overwriteFunction(statsFrame.subCategoryPaging, "onClickCallback", self, "onClickCallback")
    SE_statsExtendedGui.overwriteFunction(statsFrame, "inputEvent", self, "inputEvent")

    self.statsFrame = statsFrame
    self.screenController = nil
    -- print("--- Start Table ---")
    -- DebugUtil.printTableRecursively(statsFrame)
    -- print("--- End Table ---")

    return self
end

function SE_statsExtendedGui:addPage(position)
    -- position = math.min(#(InGameMenuStatisticsFrame.SUB_CATEGORY) + 1, position)
    -- print("--- Start Table ---")
    -- DebugUtil.printTableRecursively(InGameMenuStatisticsFrame)
    -- print("--- End Table ---")
    -- print(#(InGameMenuStatisticsFrame.SUB_CATEGORY))

    print("addPage SE_statsExtendedGui")
    local screenController = SE_statsExtendedController.register()
    self.screenController = screenController

    self:addElementAtPosition(screenController.statsExtendedPage, self.statsFrame.subCategoryPages[1].parent, position)
    self:addElementAtPosition(screenController.statsExtendedTab, self.statsFrame.subCategoryBox, position)

    table.insert(self.statsFrame.subCategoryPages, position, screenController.statsExtendedPage)
    table.insert(self.statsFrame.subCategoryTabs, position, screenController.statsExtendedTab)


    for subCategory, id in pairs(InGameMenuStatisticsFrame.SUB_CATEGORY) do
        if id >= position then
           InGameMenuStatisticsFrame.SUB_CATEGORY[subCategory] = id + 1
        end
    end

    InGameMenuStatisticsFrame.SUB_CATEGORY.STATS_EXTENDED = position
    table.insert(InGameMenuStatisticsFrame.HEADER_TITLES, position, "ui_menu_tab")

    self.statsFrame:updateAbsolutePosition()
    self.statsFrame:exposeControlsAsFields(self.statsFrame.name)
    self.statsFrame.getDescendants = function()
        return self.screenController.statsExtendedPage:getDescendants()
    end

    self.screenController.statsExtendedPage:setTarget(self.statsFrame, self.screenController.statsExtendedPage.target)
    self.screenController.statsExtendedTab:setTarget(self.statsFrame, self.screenController.statsExtendedTab.target)

    FocusManager:setGui(self.statsFrame.name)
    FocusManager:removeElement(screenController.statsExtendedPage)
    FocusManager:removeElement(screenController.statsExtendedTab)
    FocusManager:loadElementFromCustomValues(screenController.statsExtendedPage)
    FocusManager:loadElementFromCustomValues(screenController.statsExtendedTab)
    FocusManager:setGui(FocusManager.currentGui)

    return screenController
end

function SE_statsExtendedGui:onFrameOpen(frame)
    print("onFrameOpen SE_statsExtendedGui")
    self.statsFrame.isOpening = true

    if self.screenController ~= nil then
        -- DebugUtil.printTableRecursively(self.screenController)
        self.screenController:onFrameOpen()
    end

    self.statsFrame.isOpening = false
end

function SE_statsExtendedGui:onFrameClose(frame)
    if self.screenController ~= nil then
        self.screenController:onFrameClose()
    end
end

function SE_statsExtendedGui:addElementAtPosition(element, target, position)
    if element.parent ~= nil then
        element.parent:removeElement(element)
    end

    table.insert(target.elements, position, element)

    element.parent = target
end

function SE_statsExtendedGui:onClickCallback(statsFrame, superFunc, state)
    print(statsFrame)
    local superFunc = superFunc(statsFrame, state)
    local value = statsFrame.subCategoryPaging.texts[state]

    if value ~= nil and tonumber(value) == InGameMenuStatisticsFrame.SUB_CATEGORY.STATS_EXTENDED then
        if self.screenController ~= nil then
            self.screenController:onTabOpen()
        end

        local statsExtendedLayout = statsFrame.statsExtendedLayout

        -- statsFrame.statsDataElement(statsExtendedLayout)
        FocusManager:linkElements(statsFrame.subCategoryPaging, FocusManager.TOP, statsExtendedLayout.elements[#statsExtendedLayout.elements].elements[1])
        FocusManager:linkElements(statsFrame.subCategoryPaging, FocusManager.BOTTOM, statsExtendedLayout:findFirstFocusable(true))
    end

    return superFunc
end

function SE_statsExtendedGui.overwriteFunction(oldTarget, oldFunc, newTarget, newFunc)
    local superFunc = oldTarget[oldFunc]

    oldTarget[oldFunc] = function(...)
        return newTarget[newFunc](newTarget, superFunc, ...)
    end
end

function SE_statsExtendedGui.appendFunction(oldTarget, oldFunc, newTarget, newFunc)
    local superFunc = oldTarget[oldFunc]

    oldTarget[oldFunc] = function(...)
        superFunc(...)
        newTarget[newFunc](newTarget, ...)
    end
end

function SE_statsExtendedGui.prependedFunction(oldTarget, oldFunc, newTarget, newFunc)
    local superFunc = oldTarget[oldFunc]

    oldTarget[oldFunc] = function(...)
        newTarget[newFunc](newTarget, ...)
        superFunc(...)
    end
end
