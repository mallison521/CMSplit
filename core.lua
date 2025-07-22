CMSplit = CMSplit or {}

function CMSplit:OnInitialize()
    CMSplitDB = CMSplitDB or {}
    CMSplitDB.currentRun = {
    startTime = time(),
    splits = {},
    instanceID = select(8, GetInstanceInfo()),
    }
    print("|cff00ff00[CM Split]|r loaded! Type /cmsplit to configure.")
    self:RestoreRun()
end


local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "CMSplit" then
        CMSplit:OnInitialize()
    end
end)

function CMSplit:RestoreRun()
    if not CMSplitDB.currentRun then return end

    local run = CMSplitDB.currentRun
    local instanceID = select(8, GetInstanceInfo())

    -- Only restore if instance matches
    if run.instanceID ~= instanceID then
        CMSplitDB.currentRun = { startTime = nil, splits = {}, instanceID = nil }
        return
    end

    if run.startTime then
        -- Convert saved absolute time to GetTime-relative
        self.runStartTime = GetTime() - (time() - run.startTime)
        self.timerRunning = true

        local elapsed = GetTime() - self.runStartTime
        local minutes = math.floor(elapsed / 60)
        local seconds = math.floor(elapsed % 60)
        self:UpdateHUD(string.format("%02d:%02d", minutes, seconds))

        if not self.realTicker then
            self.realTicker = C_Timer.NewTicker(1, function()
                if not self.runStartTime then
                    self:StopTimer()
                    return
                end
                local elapsed = GetTime() - self.runStartTime
                local m = math.floor(elapsed / 60)
                local s = math.floor(elapsed % 60)
                self:UpdateHUD(string.format("%02d:%02d", m, s))
            end)
        end
    end

    if run.splits then
        for i, split in ipairs(run.splits) do
            self:UpdateSplitLine(i, split.boss, split.time)
        end
    end
end


function CMSplit:EndRun()
    local run = CMSplitDB.currentRun
    if not run or not run.startTime then return end

    -- Build a summary to save to history
    local totalTime = nil
    if self.runFinalTime then
        totalTime = self.runFinalTime
    elseif self.runStartTime then
        local elapsed = GetTime() - self.runStartTime
        totalTime = string.format("%02d:%02d", math.floor(elapsed / 60), math.floor(elapsed % 60))
    end

    local historyEntry = {
        startTime = run.startTime,
        splits = run.splits or {},
        instanceID = run.instanceID,
        totalTime = totalTime,
    }

    -- Save it to history by instance/dungeon name or ID (use currentInstanceName or instanceID)
    local dungeonKey = self.currentInstanceName or tostring(run.instanceID or "unknown")
    CMSplitDB.history = CMSplitDB.history or {}
    CMSplitDB.history[dungeonKey] = CMSplitDB.history[dungeonKey] or {}
    table.insert(CMSplitDB.history[dungeonKey], historyEntry)

    -- Clear current run to mark no active timer
    CMSplitDB.currentRun = {
        startTime = nil,
        splits = {},
        instanceID = nil,
    }

    print("|cff00ff00[CM Split]|r Run saved to history and cleared current run.")
end
