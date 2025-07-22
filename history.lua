function CMSplit:InitHistory()
    CMSplitDB = CMSplitDB or {}
    CMSplitDB.history = CMSplitDB.history or {}
end

function CMSplit:SaveSplit(dungeonName, splitData)
    splitData.startTime = time()  -- Add this to save the current actual date/time
    CMSplitDB.history[dungeonName] = CMSplitDB.history[dungeonName] or {}
    table.insert(CMSplitDB.history[dungeonName], splitData)
    print("|cff00ff00[CM Split]|r Saved run to history.")
end


function CMSplit:GetBestSplit(dungeonName)
    local runs = CMSplitDB.history[dungeonName]
    if not runs or #runs == 0 then return nil end

    table.sort(runs, function(a, b)
        return a.totalTime < b.totalTime
    end)

    return runs[1]
end

-- Create main frame
local frame = CreateFrame("Frame", "CMSplitHistoryFrame", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(400, 500)
frame:SetPoint("CENTER")
frame:Hide()

frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
frame.title:SetPoint("TOP", frame.TitleBg, "TOP", 0, -5)
frame.title:SetText("CM Split History")

-- ScrollFrame for dungeon list
local dungeonListScroll = CreateFrame("ScrollFrame", "CMSplitDungeonListScroll", frame, "UIPanelScrollFrameTemplate")
dungeonListScroll:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -30)
dungeonListScroll:SetSize(180, 450)

local dungeonListContent = CreateFrame("Frame", nil, dungeonListScroll)
dungeonListContent:SetSize(180, 450)
dungeonListScroll:SetScrollChild(dungeonListContent)

-- ScrollFrame for run list
local runListScroll = CreateFrame("ScrollFrame", "CMSplitRunListScroll", frame, "UIPanelScrollFrameTemplate")
runListScroll:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -30)
runListScroll:SetSize(200, 450)

local runListContent = CreateFrame("Frame", nil, runListScroll)
runListContent:SetSize(200, 450)
runListScroll:SetScrollChild(runListContent)

local selectedDungeon = nil
local selectedRun = nil

-- Utility to clear children frames (to refresh UI lists)
local function ClearChildren(frame)
    for _, child in ipairs({frame:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end
end

-- Convert to CMSplit methods
function CMSplit:PopulateDungeonList()
    ClearChildren(dungeonListContent)

    local yOffset = -5
    for dungeonName, runs in pairs(CMSplitDB.history or {}) do
        local btn = CreateFrame("Button", nil, dungeonListContent, "UIPanelButtonTemplate")
        btn:SetSize(160, 20)
        btn:SetPoint("TOPLEFT", dungeonListContent, "TOPLEFT", 0, yOffset)
        btn:SetText(dungeonName)
        btn:SetNormalFontObject("GameFontHighlightSmall")
        btn:SetHighlightFontObject("GameFontHighlightSmall")
        btn:SetScript("OnClick", function()
            selectedDungeon = dungeonName
            CMSplit:PopulateRunList()
        end)

        yOffset = yOffset - 25
    end
end

function CMSplit:PopulateRunList()
    ClearChildren(runListContent)
    if not selectedDungeon then return end

    local runs = CMSplitDB.history[selectedDungeon]
    if not runs then return end

    local yOffset = -5
    for i, run in ipairs(runs) do
        local btn = CreateFrame("Button", nil, runListContent, "UIPanelButtonTemplate")
        btn:SetSize(180, 20)
        btn:SetPoint("TOPLEFT", runListContent, "TOPLEFT", 0, yOffset)
        local totalTime = run.totalTime or "N/A"
        local startTime = run.startTime and date("%Y-%m-%d %H:%M", run.startTime) or "Unknown"
        btn:SetText(string.format("%d: %s (%s)", i, totalTime, startTime))
        btn:SetNormalFontObject("GameFontHighlightSmall")
        btn:SetHighlightFontObject("GameFontHighlightSmall")
        btn:SetScript("OnClick", function()
            selectedRun = run
            CMSplit:ShowRunDetails(run)
        end)

        yOffset = yOffset - 25
    end
end

function CMSplit:ShowRunDetails(run)
    if not run then return end
    local msg = "Splits:\n"
    for i, split in ipairs(run.splits or {}) do
        msg = msg .. string.format("%d. %s - %s\n", i, split.boss or "Unknown", split.time or "N/A")
    end
    print("|cff00ff00[CM Split Run Details]|r\n" .. msg)
end

function CMSplit:ShowHistory()
    if not CMSplitHistoryFrame then
        print("|cffff0000[CM Split]|r History UI frame not initialized.")
        return
    end

    self:PopulateDungeonList()
    CMSplitHistoryFrame:Show()
end
