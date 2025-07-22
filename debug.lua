SLASH_CMDEBUG1 = "/cmdebug"
CMSplit.debugBossCount = 0
CMSplit.debugTrashCount = 0
CMSplit.debugLineCount = 0


SlashCmdList["CMDEBUG"] = function(msg)
    local cmd = msg:lower()
    
    if cmd == "start" then
        print("|cffff9900[CM Split]|r Simulating CHALLENGE_MODE_START")
        CMSplit:CreateHUD()
        CMSplit:ClearSplits()
        CMSplit.debugBossCount = 0 -- Reset split count to start fresh
        CMSplit.debugTrashCount = 0
        CMSplit.debugLineCount = 0
        CMSplit:UpdateHUD("00:00")

        -- Start a simulated timer
        if CMSplit.debugTicker then
            CMSplit.debugTicker:Cancel()
        end

        CMSplit.debugTime = 0
        CMSplit.debugTicker = C_Timer.NewTicker(1, function()
            CMSplit.debugTime = CMSplit.debugTime + 1
            local minutes = math.floor(CMSplit.debugTime / 60)
            local seconds = CMSplit.debugTime % 60
            CMSplit:UpdateHUD(string.format("%02d:%02d", minutes, seconds))
        end)

    elseif cmd == "complete" then
        print("|cffff9900[CM Split]|r Simulating CHALLENGE_MODE_COMPLETED")
        if CMSplit.debugTicker then
            CMSplit.debugTicker:Cancel()
        end
        CMSplit:ClearSplits()
        CMSplit.debugBossCount = 0 -- Reset split count to start fresh
        CMSplit.debugTrashCount = 0
        CMSplit.debugLineCount = 0
        CMSplit:HideHUD()

    elseif cmd == "boss" then
        print("|cffff9900[CM Split]|r Simulating boss kill (ENCOUNTER_END)")
        -- You can simulate a boss split here
        CMSplit.debugBossCount = CMSplit.debugBossCount + 1
        CMSplit.debugLineCount = CMSplit.debugLineCount + 1
        local splitLabel = "Boss " .. CMSplit.debugBossCount
        local timeText = string.format("%02d:%02d", math.floor(CMSplit.debugTime / 60), CMSplit.debugTime % 60)
        CMSplit:UpdateSplitLine(CMSplit.debugLineCount, splitLabel, timeText)

    elseif cmd == "trash" then
    CMSplit.debugTrashCount = CMSplit.debugTrashCount + 1
    CMSplit.debugLineCount = CMSplit.debugLineCount + 1
    local splitLabel = "Trash " .. CMSplit.debugTrashCount
    local timeText = string.format("%02d:%02d", math.floor(CMSplit.debugTime / 60), CMSplit.debugTime % 60)
    print("|cffff9900[CM Split]|r Simulating trash split: " .. splitLabel)
    CMSplit:UpdateSplitLine(CMSplit.debugLineCount, splitLabel, timeText)
        

    else
        print("|cffff9900[CM Split Debug Commands]|r")
        print("/cmdebug start     - Start fake CM run")
        print("/cmdebug complete  - End fake CM run")
        print("/cmdebug boss      - Simulate a boss split")
        print("/cmdebug trash     - Simulate first trash pack clear")
    end
end
