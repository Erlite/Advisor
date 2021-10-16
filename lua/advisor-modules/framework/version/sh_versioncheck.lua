Advisor = Advisor or {}
Advisor.HasCheckedForUpdates = Advisor.HasCheckedForUpdates or false
Advisor.VersionCheckFailed = Advisor.VersionCheckFailed or false
Advisor.LatestVersion = Advisor.LatestVersion or nil
Advisor.UpToDate = Advisor.UpToDate or false

local function OnSuccess(body, size, headers, httpCode)
    Advisor.HasCheckedForUpdates = true
    if httpCode ~= 200 then
        Advisor.Log.Error(LogAdvisor, "Failed to check for updates with error code %i", httpCode)
        Advisor.VersionCheckFailed = true
        return
    end

    local localVersion = Advisor.CurrentVersion:Split(".")
    local remoteVersion = body:Split(".")
    Advisor.LatestVersion = body

    if not localVersion or not remoteVersion then 
        Advisor.VersionCheckFailed = true
        Advisor.UpToDate = false
        Advisor.Log.Error(LogAdvisor, "Invalid versioning detected. Current: '%s', Latest: '%s'", Advisor.CurrentVersion, body)
        return
    end

    if #remoteVersion ~= #localVersion then
        Advisor.VersionCheckFailed = true
        Advisor.UpToDate = false
        Advisor.Log.Error(LogAdvisor, "Failed to check for update as versioning differs with remote '%s'", body)
        return
    else
        -- Check each number indivually
        Advisor.UpToDate = true
        for i = 1, #localVersion do
            if localVersion[i] < remoteVersion[i] then
                Advisor.UpToDate = false
                break
            elseif localVersion[i] > remoteVersion[i] then
                break
            end
        end
    end

    if Advisor.UpToDate then 
        Advisor.Log.Info(LogAdvisor, "Version check complete, already up to date.")
    else
        Advisor.Log.Warning(LogAdvisor, "This version of Advisor is out of date! Current: '%s', Latest: '%s'", Advisor.CurrentVersion, body)
    end

    hook.Run("Advisor.OnVersionCheck")
end

local function OnFailure(msg)
    Advisor.Log.Error(LogAdvisor, "Failed to check for updates with error: %s", msg)
    Advisor.VersionCheckFailed = true
end

local function CheckAdvisorVersion() 
    -- Since the ISTEAMHTTP interface doesn't get initialized immediately, we have to delay.
    if SERVER then
        timer.Simple(5, function()
            Advisor.Log.Info(LogAdvisor, "Checking for updates...")
            http.Fetch(Advisor.VersionFile, OnSuccess, OnFailure)    
        end)
    else
        Advisor.Log.Info(LogAdvisor, "Checking for updates...")
        http.Fetch(Advisor.VersionFile, OnSuccess, OnFailure)    
    end
end

if CLIENT then
    hook.Add("InitPostEntity", "Advisor.VersionCheck", CheckAdvisorVersion)
else
    hook.Add("Initialize", "Advisor.VersionCheck", CheckAdvisorVersion)
end