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

    if #remoteVersion ~= #localVersion then
        Advisor.UpToDate = false
        Advisor.Log.Error(LogAdvisor, "Failed to check for update as versioning differs with remote '%s'", body)
        return
    else
        Advisor.UpToDate = true
        for i = #localVersion, 1, -1 do
            if not tonumber(remoteVersion[i]) or not tonumber(localVersion[i]) then
                Advisor.Log.Error(LogAdvisor, "Invalid versioning detected. Current: '%s', Latest: '%s'", Advisor.CurrentVersion, body)
                return
            end
            if tonumber(remoteVersion[i]) > tonumber(localVersion[i]) then
                Advisor.UpToDate = false
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