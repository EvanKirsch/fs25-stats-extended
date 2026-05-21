-- SE_statsExtendedGui
--
-- gui extention to configure stats extended display controller
--

SE_statsExtendedGui = {}
SE_statsExtendedGui._mt = Class(SE_statsExtendedGui)

function SE_statsExtendedGui.new(custom_mt)
    local self = setmetatable({}, custom_mt or SE_statsExtendedGui._mt)
    local statsFrame = g_inGameMenu.pageStatistics

    SE_statsExtendedGui.appendFunction(statsFrame, "onFrameOpen", self, "se_onFrameOpen")
    SE_statsExtendedGui.prependedFunction(statsFrame, "onFrameClose", self, "se_onFrameClose")
    SE_statsExtendedGui.overwriteFunction(statsFrame.subCategoryPaging, "onClickCallback", self, "se_onClickCallback")
    SE_statsExtendedGui.overwriteFunction(statsFrame, "inputEvent", self, "se_inputEvent")

    self.statsFrame = statsFrame
    self.screenController = nil

    return self
end

function SE_statsExtendedGui:addPage(position)
    local screenController = SE_statsExtendedController.register()
    local statsExtendedPage = screenController.statsExtendedPage
    local statsExtendedTab = screenController.statsExtendedTab

    self:addElementAtPosition(statsExtendedPage, self.statsFrame.subCategoryPages[1].parent, position)
    table.insert(self.statsFrame.subCategoryPaging.texts, position, tostring(position))
    self:addElementAtPosition(statsExtendedTab, self.statsFrame.subCategoryBox, position)

    table.insert(self.statsFrame.subCategoryPages, position, screenController.statsExtendedPage)
    table.insert(self.statsFrame.subCategoryTabs, position, screenController.statsExtendedTab)


    for subCategory, id in pairs(InGameMenuStatisticsFrame.SUB_CATEGORY) do
        if id >= position then
           InGameMenuStatisticsFrame.SUB_CATEGORY[subCategory] = id + 1
        end
    end

    InGameMenuStatisticsFrame.SUB_CATEGORY.STATS_EXTENDED = position
    table.insert(InGameMenuStatisticsFrame.HEADER_TITLES, position, "ui_menu_tab")

    self.statsFrame.menuButtonInfo[position] = self.statsFrame.menuButtonInfoDefault
    self.statsFrame:updateAbsolutePosition()
    self.statsFrame:exposeControlsAsFields(self.statsFrame.name)
    self.statsFrame.getDescendants = function()
        return statsExtendedPage:getDescendants()
    end

    statsExtendedPage:setTarget(self.statsFrame, statsExtendedPage.target)
    statsExtendedTab:setTarget(self.statsFrame, statsExtendedTab.target)

    FocusManager:setGui(self.statsFrame.name)
    FocusManager:removeElement(statsExtendedPage)
    FocusManager:removeElement(statsExtendedTab)
    FocusManager:loadElementFromCustomValues(statsExtendedPage)
    FocusManager:loadElementFromCustomValues(statsExtendedTab)
    FocusManager:setGui(FocusManager.currentGui)

    self.screenController = screenController

    return screenController
end

function SE_statsExtendedGui:se_onFrameOpen(frame)
    frame.isOpening = true

    if self.screenController ~= nil then
        -- DebugUtil.printTableRecursively(self.screenController)
        self.screenController:onFrameOpen()
    end

    frame.isOpening = false
end

function SE_statsExtendedGui:se_onFrameClose(frame)
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

function SE_statsExtendedGui:se_onClickCallback(superFunc, statsFrame, state)

    if state == InGameMenuStatisticsFrame.SUB_CATEGORY.STATS_EXTENDED then
        if self.screenController ~= nil then
            self.screenController:onTabOpen()
        end

        local statsExtendedLayout = self.statsFrame.statsExtendedLayout

        -- statsFrame.statsExtendedSlider.setDataElement(statsExtendedLayout)
        FocusManager:linkElements(statsFrame, FocusManager.TOP, statsExtendedLayout.elements[#statsExtendedLayout.elements].elements[1])
        FocusManager:linkElements(statsFrame, FocusManager.BOTTOM, statsExtendedLayout:findFirstFocusable(true))
    end

    superFunc(statsFrame, state)
    return nil
end

function SE_statsExtendedGui:se_inputEvent(statsFrame, superFunc, action, value, eventUsed)
    local retValue = superFunc(statsFrame, action, value, eventUsed)
    local pressedAccept = false
    local element = FocusManager.currentFocusData.focusElement

    if element ~= nil and not element.needExternalClick then
        pressedAccept = action == InputAction.MENU_ACCEPT

        if pressedAccept and not FocusManager:isFocusInputLocked(action) and element:getIsFocused() and element:getIsVisible() then
            FocusManager.focusSystemMadeChanges = true
            element:onFocusActivate()
            FocusManager.focusSystemMadeChanges = false
        end
    end

    return retValue or pressedAccept
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
