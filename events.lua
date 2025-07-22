-- Keep a persistent reference to the event frame so it won't get garbage collected
CMSplit.eventFrame = CMSplit.eventFrame or CreateFrame("Frame")
local f = CMSplit.eventFrame

-- Register only ADDON_LOADED initially
f:RegisterEvent("ADDON_LOADED")

f:SetScript("OnEvent", function(self, event, ...)
    -- Debug print to track all events
    -- Comment this out once verified working if spamm

    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "CMSplit" then
            print("|cff00ff00[CM Split]|r Addon loaded, registering events...")

            -- Register remaining events after addon loaded
            f:RegisterEvent("CHALLENGE_MODE_START")
            f:RegisterEvent("CHALLENGE_MODE_COMPLETED")
            f:RegisterEvent("ENCOUNTER_START")
            f:RegisterEvent("ENCOUNTER_END")
            f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            f:RegisterEvent("PLAYER_ENTERING_WORLD")

            -- Initialize your addon here if needed
            CMSplit:OnInitialize()
        end
        return
    end

    -- Now handle all other events:
    if event == "CHALLENGE_MODE_START" then
        print("|cff00ff00[CM Split]|r Challenge Mode started!")
        CMSplit:StartTimer()

    elseif event == "CHALLENGE_MODE_COMPLETED" then
        print("|cff00ff00[CM Split]|r Challenge Mode completed!")
        CMSplit:StopTimer()
        CMSplit:EndRun()

    elseif event == "ENCOUNTER_START" then
        local encounterID, encounterName, difficultyID, groupSize = ...
        CMSplit.bossStartTime = GetTime()
        CMSplit.currentEncounterName = encounterName
        print("|cff00ff00[CM Split]|r Encounter started: " .. tostring(encounterName))

    elseif event == "ENCOUNTER_END" then
        local encounterID, encounterName, difficultyID, groupSize, endStatus = ...

        if endStatus == 1 then -- boss defeated
            local instanceID = select(8, GetInstanceInfo())
            local isFinalBoss = (CMSplit.LastBosses and CMSplit.LastBosses[instanceID] == encounterName)

            if isFinalBoss then
                CMSplit:StopTimer()
                print("|cffffff00[CM Split]|r Dungeon complete! Timer stopped.")
                CMSplit:EndRun()
            end

            local timeText = "00:00"
            if CMSplit.runFinalTime and isFinalBoss then
                timeText = CMSplit.runFinalTime
            elseif CMSplit.runStartTime then
                local elapsed = GetTime() - CMSplit.runStartTime
                timeText = string.format("%02d:%02d", math.floor(elapsed / 60), math.floor(elapsed % 60))
            end

            CMSplit:UpdateSplitLine(#CMSplit.hud.splitLines + 1, encounterName, timeText)

            local splits = CMSplitDB.currentRun.splits
            if splits then
                table.insert(splits, { boss = encounterName, time = timeText })
            end

            print("|cff00ff00[CM Split]|r Boss defeated: " .. tostring(encounterName) .. " at " .. timeText)
        end

    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        -- Your existing or future combat log handling here (optional)

    elseif event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(0.2, function()
            local inInstance, instanceType = IsInInstance()
            local instanceName, _, difficultyID, _, _, _, _, instanceID = GetInstanceInfo()

            if inInstance and instanceType == "party" then
                CMSplit.currentDifficulty = difficultyID
                CMSplit.currentInstanceName = instanceName or ("ID: " .. (instanceID or "?"))

                print("|cff00ff00[CM Split]|r Entered dungeon: " .. (instanceName or "Unknown") .. " Difficulty ID: " .. tostring(difficultyID))
                print("CMSplit.currentDifficulty set to:", CMSplit.currentDifficulty)

                if CMSplit.lastInstanceID ~= instanceID then
                    CMSplit.lastInstanceID = instanceID
                    CMSplit:ClearSplits()
                    CMSplit:StopTimer()
                    CMSplit.runFinalTime = nil
                    CMSplit.runStartTime = nil
                    print("|cff00ff00[CM Split]|r Cleared splits and reset timer for new instance.")
                end

                CMSplit:RestoreRun()
                CMSplit:CreateHUD()

                -- Start timer only if NOT challenge mode (testing)
                if not C_ChallengeMode.IsChallengeModeActive() then
                    CMSplit.runStartTime = GetTime()
                    CMSplit:StartTimer()
                    print("|cff9999ff[CM Split]|r Timer started for testing (non-Challenge Mode).")
                end
            else
                CMSplit.currentDifficulty = nil
                CMSplit.currentInstanceName = nil
                CMSplit:StopTimer()
                CMSplit:HideHUD()
            end
        end)
    end
end)