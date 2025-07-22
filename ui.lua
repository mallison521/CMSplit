local goldIcon = "|TInterface\\MoneyFrame\\UI-GoldIcon:16:16:0:0:16:16:0:16:0:16|t"
local silverIcon = "|TInterface\\MoneyFrame\\UI-SilverIcon:16:16:0:0:16:16:0:16:0:16|t"
local bronzeIcon = "|TInterface\\MoneyFrame\\UI-CopperIcon:16:16:0:0:16:16:0:16:0:16|t"
local skullIcon = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:16:16:0:0:16:16:0:16:0:16|t"


local function GetMedalColors(elapsed, medalTimes, runEnded)
    local colors = {
        gold = "|cffffffff",   -- default white
        silver = "|cffffffff",
        bronze = "|cffffffff",
    }

    if not runEnded then
        -- In-progress logic: red if passed the time, white otherwise
        if elapsed > medalTimes.gold then
            colors.gold = "|cffff0000"
        end
        if elapsed > medalTimes.silver then
            colors.silver = "|cffff0000"
        end
        if elapsed > medalTimes.bronze then
            colors.bronze = "|cffff0000"
        end
        return colors
    end

    -- Final colors after run completed
    if elapsed <= medalTimes.gold then
        -- Gold earned
        colors.gold = "|cff00ff00"
        colors.silver = "|cffffffff"
        colors.bronze = "|cffffffff"
    elseif elapsed <= medalTimes.silver then
        -- Silver earned
        colors.gold = "|cffff0000"
        colors.silver = "|cff00ff00"
        colors.bronze = "|cffffffff"
    elseif elapsed <= medalTimes.bronze then
        -- Bronze earned
        colors.gold = "|cffff0000"
        colors.silver = "|cffff0000"
        colors.bronze = "|cff00ff00"
    else
        -- No medal
        colors.gold = "|cffff0000"
        colors.silver = "|cffff0000"
        colors.bronze = "|cffff0000"
    end

    return colors
end



function CMSplit:UpdateHUD(timeText)
    if not self.hud then return end

    local difficultyLabel = "Unknown"
    local diff = self.currentDifficulty
    local medalTimes = CMSplit.MedalTimes[self.lastInstanceID]
    if medalTimes and self.hud.medalLine then
        local elapsed = 0
        if type(self.runStartTime) == "number" then
            elapsed = GetTime() - self.runStartTime
        end

        local runEnded = false

        if self.runFinalTime then
            local minutes, seconds = self.runFinalTime:match("(%d+):(%d+)")
            elapsed = tonumber(minutes) * 60 + tonumber(seconds)
            runEnded = true
        end

        local medalColors = GetMedalColors(elapsed, medalTimes, runEnded)
        local goldColor = medalColors.gold
        local silverColor = medalColors.silver
        local bronzeColor = medalColors.bronze


        local medalText = string.format(
            "%s%s %d:%02d|r    %s%s %d:%02d|r    %s%s %d:%02d|r",
            goldColor, goldIcon, math.floor(medalTimes.gold / 60), medalTimes.gold % 60,
            silverColor, silverIcon, math.floor(medalTimes.silver / 60), medalTimes.silver % 60,
            bronzeColor, bronzeIcon, math.floor(medalTimes.bronze / 60), medalTimes.bronze % 60
        )


        self.hud.medalLine:SetText(medalText)
    elseif self.hud.medalLine then
        self.hud.medalLine:SetText("")
    end


    if diff == 1 then
        difficultyLabel = "Normal"
    elseif diff == 2 then
        difficultyLabel = "Heroic"
    elseif diff == 8 then
        difficultyLabel = "Challenge Mode"
    elseif diff == 23 or diff == 24 then
        difficultyLabel = "Mythic/Heroic"
    elseif diff == 7 then
        difficultyLabel = "Raid Finder"
    end

    local instanceName = self.currentInstanceName or "Unknown Dungeon"
    local displayText = timeText or "00:00"

    -- Set each line individually
    self.hud.titleText:SetText(instanceName)
    self.hud.difficultyText:SetText("[" .. difficultyLabel .. "]")
    local timerColor = "|cffffffff"
    if runEnded and medalTimes then
        if elapsed <= medalTimes.gold then
            timerColor = "|cff00ff00"
        elseif elapsed <= medalTimes.silver then
            timerColor = "|cffcccc00"
        elseif elapsed <= medalTimes.bronze then
            timerColor = "|cffffa500"
        else
            timerColor = "|cffff0000"
        end
    end

    self.hud.timeText:SetText(timerColor .. "Time: " .. displayText .. "|r")


    -- Optional: auto-resize frame width to content
    local maxWidth = math.max(
        self.hud.titleText:GetStringWidth(),
        self.hud.difficultyText:GetStringWidth(),
        self.hud.timeText:GetStringWidth(),
        self.hud.medalLine:GetStringWidth()
    ) + 40
    self.hud:SetWidth(math.max(250, maxWidth))  -- 250 is your min width
end


function CMSplit:HideHUD()
    if self.hud then
        self.hud:Hide()
        self.hudVisible = false
    end
end

function CMSplit:CreateHUD(force)
    if self.hud then  -- if hud exists, just show it and return
        self.hud:Show()
        self:UpdateHUD("00:00")  -- reset timer text on show
        self.hudVisible = true
        return
    end

    local inInstance, instanceType = IsInInstance()
    if not force and (not inInstance or instanceType ~= "party") then
        print("|cffff0000[CM Split]|r HUD not shown - not in a 5-man dungeon.")
        return
    end

    local frame = CMSplitHUD or CreateFrame("Frame", "CMSplitHUD", UIParent, "BackdropTemplate")
    self.hud = frame
    frame:SetSize(250, 100)  -- slightly taller for new line

    CMSplitDB = CMSplitDB or {}
    if CMSplitDB.hudPosition then
        local pos = CMSplitDB.hudPosition
        frame:SetPoint(pos.point or "TOP", UIParent, pos.relativePoint or "TOP", pos.x or 0, pos.y or -100)
    else
        frame:SetPoint("TOP", UIParent, "TOP", 0, -100)
    end

    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    frame:SetBackdropColor(0, 0, 0, 0.8)

    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(f)
        if not CMSplit.isLocked then f:StartMoving() end
    end)
    frame:SetScript("OnDragStop", function(f)
        f:StopMovingOrSizing()
        local point, _, relativePoint, xOfs, yOfs = f:GetPoint()
        CMSplitDB.hudPosition = {
            point = point, relativePoint = relativePoint, x = xOfs, y = yOfs
        }
    end)

    -- Line 1: Dungeon name
    frame.titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.titleText:SetPoint("TOP", frame, "TOP", 0, -10)

    -- Line 2: Difficulty
    frame.difficultyText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.difficultyText:SetPoint("TOP", frame.titleText, "BOTTOM", 0, -5)

    -- Line 3: Timer
    frame.timeText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.timeText:SetPoint("TOP", frame.difficultyText, "BOTTOM", 0, -5)
    frame.timeText:SetJustifyH("CENTER")
    frame.timeText:SetWidth(frame:GetWidth() - 20)

    -- Line 4: Medal timers
    frame.medalLine = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.medalLine:SetPoint("TOP", frame.timeText, "BOTTOM", 0, -5)
    frame.medalLine:SetJustifyH("CENTER")
    frame.medalLine:SetTextColor(1, 1, 1)



    frame.splitLines = {}

    frame:Show()
    self.hud = frame
    self:UpdateHUDLockState()
    self:UpdateHUD("00:00")  -- Show initial time after creation
end




function CMSplit:UpdateHUDLockState()
    if not self.hud then return end

    if self.isLocked then
        self.hud:SetBackdropBorderColor(0, 0, 0, 0)     -- hide border
        self.hud:SetBackdropColor(0, 0, 0, 0.8)          -- normal background
    else
        self.hud:SetBackdropBorderColor(1, 1, 0, 1)     -- yellow border
        self.hud:SetBackdropColor(0.1, 0.1, 0.1, 0.9)   -- darker background
    end
end

function CMSplit:ClearSplits()
    if not self.hud or not self.hud.splitLines then return end

    for i, line in ipairs(self.hud.splitLines) do
        line.label:SetText("")
        line.time:SetText("")
        -- Optionally: hide or clear lines to avoid overlap
        -- line.label:Hide()
        -- line.time:Hide()
    end

    self.hud.splitLines = {}
    self:AdjustHUDHeight()
end


function CMSplit:StartTimer()
    self.realTicker = C_Timer.NewTicker(1, function()
        if not self.runStartTime then
            self:StopTimer()
            return
        end

        local elapsed = GetTime() - self.runStartTime
        if elapsed < 0 or elapsed > 86400 then  -- sanity check (24 hours)
            self:StopTimer()
            return
        end

        local minutes = math.floor(elapsed / 60)
        local seconds = math.floor(elapsed % 60)
        self:UpdateHUD(string.format("%02d:%02d", minutes, seconds))
    end)

end



function CMSplit:StopTimer()
    if self.runStartTime then
        local elapsed = GetTime() - self.runStartTime
        self.runFinalTime = string.format("%02d:%02d", math.floor(elapsed / 60), math.floor(elapsed % 60))
    end
    self.timerRunning = false
    self.runStartTime = nil

    -- Cancel ticker if exists
    if self.realTicker then
        self.realTicker:Cancel()
        self.realTicker = nil
    end

    if self.hud then
        self:UpdateHUD(self.runFinalTime or "00:00")
    end
end



function CMSplit:UpdateSplitLine(index, label, timeText)
    if not self.hud then return end

    if not self.hud.splitLines[index] then
        local leftFS = self.hud:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        local rightFS = self.hud:CreateFontString(nil, "OVERLAY", "GameFontNormal")

        local _, _, _, _, medalLineY = self.hud.medalLine:GetPoint()
        local yOffset = -5 - 20 * (index + 3)  -- position below medalLine

        -- Position left label: top left relative to HUD, offset vertically
        leftFS:SetPoint("TOPLEFT", self.hud, "TOPLEFT", 10, yOffset)
        leftFS:SetJustifyH("LEFT")
        leftFS:SetWidth(self.hud:GetWidth() * 0.7)
        leftFS:SetWordWrap(false)

        -- Position right label: top right relative to HUD, offset vertically
        rightFS:SetPoint("TOPRIGHT", self.hud, "TOPRIGHT", -10, yOffset)
        rightFS:SetJustifyH("RIGHT")
        rightFS:SetWidth(self.hud:GetWidth() * 0.3)
        rightFS:SetWordWrap(false)

        self.hud.splitLines[index] = { label = leftFS, time = rightFS }
    end

    local line = self.hud.splitLines[index]
    line.label:SetText(skullIcon .. " " .. label)
    line.time:SetText(timeText)

    self:AdjustHUDHeight()
end




function CMSplit:AdjustHUDHeight()
    if not self.hud then return end

    local baseHeight = 100 -- fits name, difficulty, time, and medal lines
    local lineHeight = 20
    local numLines = #self.hud.splitLines or 0

    local newHeight = baseHeight + (lineHeight * numLines)
    self.hud:SetHeight(newHeight)
end
