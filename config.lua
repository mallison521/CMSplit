function string:trim()
    return self:match("^%s*(.-)%s*$")
end

SLASH_CMSPLIT1 = "/cmsplit"

CMSplit.isLocked = true  -- default state

SlashCmdList["CMSPLIT"] = function(msg)
    local cmd = msg:lower():trim()

    if cmd == "unlock" then
        CMSplit.isLocked = false
        CMSplit:UpdateHUDLockState()
        print("|cffff9900[CM Split]|r Frame unlocked. You can now drag it.")

    elseif cmd == "lock" then
        CMSplit.isLocked = true
        CMSplit:UpdateHUDLockState()
        local inInstance, instanceType = IsInInstance()
        if CMSplit.hud then
            if not inInstance or instanceType == "none" then
                CMSplit.hud:Hide()
                print("|cffff9900[CM Split]|r Frame locked and hidden outside of instances.")
            else
                print("|cffff9900[CM Split]|r Frame locked in place. It will remain visible during the dungeon.")
            end
        end

    elseif cmd == "show" then
        if CMSplit.hud then
            CMSplit.hud:Show()
            print("|cffff9900[CM Split]|r HUD shown.")
        else
            CMSplit:CreateHUD(true)
            if not IsInInstance() then
                print("|cffffcc00[CM Split]|r HUD visible. Use '/cmsplit unlock' to move its position.")
                print("|cffffcc00[CM Split]|r HUD visible. Use '/cmsplit lock' to save its position.")
            end
        end

    elseif cmd == "hide" then
        if CMSplit.hud then
            CMSplit.hud:Hide()
            print("|cffff9900[CM Split]|r HUD hidden.")
        end

    elseif cmd == "reset" then
        if CMSplit.debugTicker then
            CMSplit.debugTicker:Cancel()
            CMSplit.debugTicker = nil
        end
        CMSplit.debugTime = 0
        CMSplit.runStartTime = GetTime()
        CMSplit:UpdateHUD("00:00")
        CMSplit:ClearSplits()
        print("|cffff9900[CM Split]|r Timer and splits reset.")

    elseif cmd == "history" then
        CMSplit:ShowHistory()

    elseif cmd == "" then
        print("|cffffcc00[CM Split Commands]|r")
        print("/cmsplit lock      - Lock the HUD frame (prevents dragging)")
        print("/cmsplit unlock    - Unlock the HUD frame for dragging")
        print("/cmsplit show      - Show the HUD frame")
        print("/cmsplit hide      - Hide the HUD frame")
        print("/cmsplit reset     - Reset the timer to 00:00")
        print("/cmsplit history   - Show saved run history UI")

    else
        print("|cffff0000[CM Split]|r Unknown command: '" .. cmd .. "'")
    end
end
