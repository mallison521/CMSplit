CMSplit.LDB = LibStub("LibDataBroker-1.1"):NewDataObject("CMSplit", {
    type = "data source",
    text = "CMSplit",
    icon = 134376, -- Nifty Stopwatch
    OnClick = function(_, button)
        if IsShiftKeyDown() then
            CMSplit.hudVisible = not CMSplit.hudVisible
            if CMSplit.hudVisible then
                SlashCmdList["CMSPLIT"]("show")
            else
                SlashCmdList["CMSPLIT"]("hide")
            end
        else
            SlashCmdList["CMSPLIT"]("")
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine("CMSplit")
        tooltip:AddLine("Click to view options", 1, 1, 1)
        tooltip:AddLine("Shift-Click to toggle the HUD", 0.8, 0.8, 0.8)
    end,
})




function CMSplit:InitMinimap()
    self.db = self.db or {}
    self.db.minimap = self.db.minimap or {}

    local icon = LibStub("LibDBIcon-1.0")

    if not icon.objects["CMSplit"] then
        icon:Register("CMSplit", CMSplit.LDB, self.db.minimap)
    end
end

