--[[
    ============================================================
    🥊 DAIGO HUB - UNTITLED BOXING GAME (HP + PC)
    + HYPHON EMULATOR BYPASS + ANTI-KICK
    ============================================================
    Default: SEMUA OFF. Nyalain lewat UI.
    PC: V = Master | 1 Dodge | 2 Block | 3 Attack | 4 Anti-Ryu
    ============================================================
--]]

-- ============================================================
-- 🛡️ HYPHON EMULATOR BYPASS + ANTI-KICK
-- ============================================================
pcall(function()
    if not filtergc then
        filtergc = function(ftype, filters, returnSingle)
            local results = {}
            for _, obj in pairs(getgc(true)) do
                if type(obj) == "function" then
                    local ok, info = pcall(debug.getinfo, obj)
                    if ok and info then
                        local match = true
                        if filters.StartLine and info.linedefined ~= filters.StartLine then match = false end
                        if filters.Source and info.source ~= filters.Source then match = false end
                        if match then
                            if returnSingle then return obj end
                            table.insert(results, obj)
                        end
                    end
                end
            end
            if returnSingle then return nil end
            return results
        end
    end
    if not getnilinstances then getnilinstances = function() return {} end end
    if not bit32 then bit32 = {} end
    if not bit32.bxor then
        bit32.bxor = function(a, b)
            local result, bit = 0, 1
            while a > 0 or b > 0 do
                if (a % 2) ~= (b % 2) then result = result + bit end
                a, b, bit = math.floor(a / 2), math.floor(b / 2), bit * 2
            end
            return result
        end
    end

    local gv = getgenv()
    local function tryFind(name, ln)
        local fn = filtergc("function", { StartLine = ln }, true)
        if type(fn) ~= "function" then fn = (type(fn) == "table" and #fn > 0 and fn[1]) or nil end
        if not fn then
            local all = filtergc("function", { StartLine = ln })
            if type(all) == "table" and #all > 0 then fn = all[1] end
        end
        if fn then gv[name] = fn end
        return fn
    end

    gv.Hyphon_2102 = tryFind("Hyphon_2102", 2102)
    gv.Hyphon_2247 = tryFind("Hyphon_2247", 2247)
    gv.Hyphon_2846 = tryFind("Hyphon_2846", 2846)
    gv.Hyphon_fake_dec = tryFind("Hyphon_fake_dec", 1097)

    if gv.Hyphon_2102 then
        pcall(function()
            gv.Hyphon_Encode = debug.getupvalue(gv.Hyphon_2102, 1)
            gv.Hyphon_Decode = debug.getupvalue(gv.Hyphon_2102, 21)
        end)
    end

    gv.Hyphon_Script = nil
    pcall(function()
        for _, o in pairs(getnilinstances()) do
            if o:IsA("Script") and o.Name:len() == 32 then
                gv.Hyphon_Script = o
                break
            end
        end
    end)

    if gv.Hyphon_2102 and gv.Hyphon_2247 and gv.Hyphon_2846 and gv.Hyphon_fake_dec then
        pcall(function()
            local HC = cloneref(game:GetService("MemoryStoreService")):FindFirstChild("Hyphon_Check")
            local RF = debug.getupvalue(gv.Hyphon_2247, 6)
            if HC and hookfunction then
                local o = hookfunction(HC.FireServer, function(s, ...) return o(s, ...) end)
            end
            if RF and hookfunction then
                local o = hookfunction(RF.InvokeServer, function(s, ...)
                    local a = table.pack(...)
                    if type(a[1]) == "table" and a[1][1] then
                        gv.T1 = a[1][1]; gv.T2 = a[1][2]; gv.T3 = a[1][6]; gv.T4 = a[1][11]
                    end
                    return o(s, ...)
                end)
            end
        end)
        if bit32 and bit32.bxor and gv.Hyphon_Script and checkcaller and getcallingscript and hookfunction then
            pcall(function()
                local o = hookfunction(bit32.bxor, function(a, b)
                    if not checkcaller() and getcallingscript() == gv.Hyphon_Script then
                        return task.wait(9e9)
                    end
                    return o(a, b)
                end)
            end)
        end
    end

    pcall(function()
        for _, Object in pairs(getgc(true)) do
            if typeof(Object) == "table" and typeof(rawget(Object, "Homeless")) == "table" then
                if rawget(Object.Homeless, "MaxDistance") then
                    Object.Homeless.MaxDistance = 9e9
                end
            end
        end
    end)

    gv.HyphonReady = true
    gv.Emulator_Set = true
end)

-- ============================================================
-- 🥊 DAIGO HUB BODY
-- ============================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

pcall(function()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        for _, g in ipairs(pGui:GetChildren()) do
            if g.Name:find("UBG") or g.Name:find("GodBot") or g.Name:find("Helper") or g.Name:find("Daigo") then
                g:Destroy()
            end
        end
    end
    for _, g in ipairs(CoreGui:GetChildren()) do
        if g.Name:find("Daigo") then g:Destroy() end
    end
end)

pcall(function() if setfpscap then setfpscap(60) end end)

local VirtualInputManager = nil
pcall(function() VirtualInputManager = game:GetService("VirtualInputManager") end)

local BridgeNet2, TryCodeBridge, HandleBlockBridge
pcall(function()
    BridgeNet2 = require(ReplicatedFirst:WaitForChild("BridgeNet2", 5))
    TryCodeBridge = BridgeNet2.ReferenceBridge("TryCode")
    HandleBlockBridge = BridgeNet2.ReferenceBridge("HandleBlock")
end)

local Buwic, InfoToString
pcall(function() Buwic = require(ReplicatedFirst:WaitForChild("Buwic", 4)) end)
pcall(function()
    local m = ReplicatedStorage:WaitForChild("Modules", 4)
    local c = m and m:WaitForChild("Combat", 4)
    if c then InfoToString = require(c:WaitForChild("InfoToString", 4)) end
end)

local Events = ReplicatedStorage:WaitForChild("Events", 5)
local ForceDashEvent = Events and Events:FindFirstChild("ForceDash")
local MobileEvents = ReplicatedStorage:WaitForChild("MobileEvents", 5)
local MobileTryDash = MobileEvents and MobileEvents:FindFirstChild("TryDash")
local MobileTryPunch = MobileEvents and MobileEvents:FindFirstChild("TryPunch")
local MobileSetBlock = MobileEvents and MobileEvents:FindFirstChild("SetBlock")
local MobileUseSpecial = MobileEvents and MobileEvents:FindFirstChild("UseSpecial")
local MobileTrySwitchEquip = MobileEvents and MobileEvents:FindFirstChild("TrySwitchEquip")

local RYU_SKILLS = {
    [90] = { Name = "Shoryuken", Direction = "Right", DodgeDelay = 0.22 },
    [91] = { Name = "Hadoken", Direction = "Right", DodgeDelay = 0.30, IsProjectile = true },
    [92] = { Name = "Tatsumaki", Direction = "Right", DodgeDelay = 0.24 },
    [93] = { Name = "Hashogeki", Direction = "Right", DodgeDelay = 0.20 },
    [94] = { Name = "DriveImpact", Direction = "Right", DodgeDelay = 0.35, SuperArmor = true },
    [95] = { Name = "DriveShoryuken", Direction = "Right", DodgeDelay = 0.22 },
    [96] = { Name = "DenjinHadoken", Direction = "Right", DodgeDelay = 0.26, IsProjectile = true },
    [97] = { Name = "DriveTatsumaki", Direction = "Right", DodgeDelay = 0.24 },
}

local RYU_ANIM_IDS = {
    ["131582211129837"] = { Name = "Hadoken", Direction = "Right", DodgeDelay = 0.30 },
    ["113734912309214"] = { Name = "Shoryuken", Direction = "Right", DodgeDelay = 0.22 },
    ["113937867671903"] = { Name = "Shoryuken", Direction = "Right", DodgeDelay = 0.22 },
    ["84594451329681"]   = { Name = "Tatsumaki", Direction = "Right", DodgeDelay = 0.24 },
    ["105301878639276"] = { Name = "Hashogeki", Direction = "Right", DodgeDelay = 0.20 },
    ["120504643328161"] = { Name = "DriveImpact", Direction = "Right", DodgeDelay = 0.35, SuperArmor = true },
}

local BotConfig = {
    MasterSwitch = false,
    AutoPerfectDodge = false,
    AutoDodgeRyu = false,
    AutoCounterAttack = false,
    AutoBlock = false,
    AutoChase = false,
    RingEdgeEscape = false,
    AutoAttack = false,
    SmartBlockBreak = false,
    AutoQ_Ultimate = false,
    AutoFaceOpponent = false,
    StaminaManagement = false,
    MinStaminaToAttack = 10,
    AttackDistance = 11.5,
    PunchInterval = 0.13,
    DodgeCooldown = 0.16,
}

local BotState = {
    LastDodgeTime = 0, LastPunchTime = 0, LastQ_Time = 0, LastRyuDodgeTime = 0,
    PauseAttackUntil = 0, IsBlocking = false, InCounterAttack = false, OpponentChar = nil,
}

local ALL_GAME_CODES = {
    "streetfighter","ryu","thedoctorwillseeyousoon","surgeon","3years","lynn","deimos","terror",
    "regularfish","dragonfish","loveintheair","lovefromubg","whitecash","adrenaline","vexthegoat",
    "dualemotes","justtakethecash","100KCASH","pocketchange","teleport","freeemoteforall","freecrates",
    "freecoins","hammer","funnycode","turtle","ippo","ghost","animetime","shotgun","freedom","200k",
    "100k","emotes","fasting","whitefang","delay","vegeta","bullet","balance1","ironfist","subzero",
    "cash","spins","bringbacktheolddays","trading","morecash","ranking","feint","earlybird","gems","box"
}

local function GetPlayerState(p)
    if not p then return nil end
    local s = Workspace:FindFirstChild("States")
    return s and s:FindFirstChild(p.Name)
end

local function CanPlayerPunch()
    local st = GetPlayerState(LocalPlayer)
    if not st then return false end
    local occ = st:FindFirstChild("Occupied")
    local cd = st:FindFirstChild("CharacterData")
    if not occ or not cd then return false end
    if occ:FindFirstChild("CanPunch") and not occ.CanPunch.Value then return false end
    if occ:FindFirstChild("Dashing") and occ.Dashing.Value then return false end
    if cd:FindFirstChild("Stunned") and cd.Stunned.Value then return false end
    return true
end

local function SetBlock(enable)
    if BotState.IsBlocking == enable then return end
    BotState.IsBlocking = enable
    if VirtualInputManager then
        pcall(function() VirtualInputManager:SendKeyEvent(enable, Enum.KeyCode.F, false, game) end)
    end
    if HandleBlockBridge then pcall(function() HandleBlockBridge:Fire(enable) end) end
    if MobileSetBlock then pcall(function() MobileSetBlock:Fire(enable) end) end
    local st = GetPlayerState(LocalPlayer)
    if st then
        pcall(function()
            if st:FindFirstChild("Occupied") and st.Occupied:FindFirstChild("Blocking") then
                st.Occupied.Blocking.Value = enable
            end
            if st:FindFirstChild("CharacterData") and st.CharacterData:FindFirstChild("Blocking") then
                st.CharacterData.Blocking.Value = enable
            end
        end)
    end
end

local function PressQ_Ultimate()
    local now = tick()
    if now - BotState.LastQ_Time < 0.25 then return end
    BotState.LastQ_Time = now
    if VirtualInputManager then
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
            task.wait(0.02)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
        end)
    end
    if MobileTryPunch then pcall(function() MobileTryPunch:Fire({ IsUltimate = true }) end) end
    if MobileUseSpecial then pcall(function() MobileUseSpecial:Fire() end) end
end

local function GetCurrentOpponent()
    local st = GetPlayerState(LocalPlayer)
    if st then
        local cd = st:FindFirstChild("CharacterData")
        if cd and cd:FindFirstChild("Opponent") and cd.Opponent.Value then return cd.Opponent.Value end
        local occ = st:FindFirstChild("Occupied")
        if occ and occ:FindFirstChild("LockedOn") and occ.LockedOn.Value then return occ.LockedOn.Value end
    end
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local closest, shortest = nil, 50
    local myPos = myChar.HumanoidRootPart.Position
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local h = p.Character:FindFirstChild("Humanoid")
            if h and h.Health > 0 then
                local d = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
                if d < shortest then shortest = d; closest = p.Character end
            end
        end
    end
    return closest
end

local function IsNearRingEdge()
    local c = LocalPlayer.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return false end
    local r = c.HumanoidRootPart
    local st = GetPlayerState(LocalPlayer)
    if st and st:FindFirstChild("CharacterData") then
        local cv = st.CharacterData:FindFirstChild("Centre")
        if cv and cv.Value and cv.Value:IsA("BasePart") then
            if (r.Position - cv.Value.Position).Magnitude >= 14 then return true end
        end
    end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = { c }
    local hit = Workspace:Raycast(r.Position, -r.CFrame.LookVector * 4.5, rp)
    return hit ~= nil
end

local function PerformDash(direction, force)
    local now = tick()
    if not force and (now - BotState.LastDodgeTime < BotConfig.DodgeCooldown) then return false end
    BotState.LastDodgeTime = now
    local dir = direction or "Right"
    if BotState.IsBlocking then SetBlock(false) end
    if ForceDashEvent then
        ForceDashEvent:Fire({ Direction = dir, MoveVector = Vector3.new() })
        return true
    elseif MobileTryDash then
        MobileTryDash:Fire()
        return true
    end
    return false
end

local function PerformPunch(isHeavy)
    if not MobileTryPunch then return false end
    if BotState.IsBlocking then SetBlock(false) end
    if BotConfig.AutoQ_Ultimate then PressQ_Ultimate() end
    if isHeavy then MobileTryPunch:Fire({ IsHeavy = true }) else MobileTryPunch:Fire(nil) end
    BotState.LastPunchTime = tick()
    return true
end

local function ExecuteCounterAttack(opp)
    if not opp or not opp:FindFirstChild("HumanoidRootPart") then return end
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myRoot = myChar.HumanoidRootPart
    local oppRoot = opp.HumanoidRootPart
    local myHum = myChar:FindFirstChild("Humanoid")
    BotState.InCounterAttack = true
    SetBlock(false)
    local t0 = tick()
    local st = GetPlayerState(LocalPlayer)
    local occ = st and st:FindFirstChild("Occupied")
    while (tick() - t0 < 0.40) do
        if occ and occ:FindFirstChild("CanPunch") and occ.CanPunch.Value and not occ.Dashing.Value then break end
        task.wait(0.01)
    end
    if opp and opp.Parent and myChar and myChar.Parent then
        if myHum then
            myRoot.CFrame = CFrame.lookAt(myRoot.Position, Vector3.new(oppRoot.Position.X, myRoot.Position.Y, oppRoot.Position.Z))
            myHum:MoveTo(oppRoot.Position)
        end
    end
    PressQ_Ultimate()
    for _ = 1, 4 do
        if not opp or not opp.Parent then break end
        local oh = opp:FindFirstChild("Humanoid")
        if oh and oh.Health <= 0 then break end
        if oppRoot and oppRoot.Parent and myRoot and myRoot.Parent then
            myRoot.CFrame = CFrame.lookAt(myRoot.Position, Vector3.new(oppRoot.Position.X, myRoot.Position.Y, oppRoot.Position.Z))
        end
        PerformPunch(false)
        task.wait(BotConfig.PunchInterval)
    end
    PressQ_Ultimate()
    PerformPunch(true)
    task.wait(0.20)
    BotState.InCounterAttack = false
end

local function SetupDodgeAndHook(character)
    if not character then return end
    character:GetAttributeChangedSignal("Perfect"):Connect(function()
        if not BotConfig.MasterSwitch or not BotConfig.AutoPerfectDodge then return end
        if character:GetAttribute("Perfect") ~= nil then
            if BotState.IsBlocking then SetBlock(false) end
            local nd = character:GetAttribute("NeededDirection")
            if not nd or nd == "Standing" or nd == "Backward" then nd = "Right" end
            if BotConfig.RingEdgeEscape and IsNearRingEdge() then
                if nd == "Backward" or nd == "Standing" then nd = "Right" end
            end
            local ok = PerformDash(nd)
            if ok and BotConfig.AutoCounterAttack then
                task.spawn(function()
                    local o = GetCurrentOpponent()
                    if o then ExecuteCounterAttack(o) end
                end)
            end
        end
    end)
    character:GetAttributeChangedSignal("ClientProjectileFreeDashUntil"):Connect(function()
        if not BotConfig.MasterSwitch or not (BotConfig.AutoPerfectDodge or BotConfig.AutoDodgeRyu) then return end
        local v = character:GetAttribute("ClientProjectileFreeDashUntil")
        if v and v > Workspace:GetServerTimeNow() then
            SetBlock(false)
            PerformDash("Right", true)
        end
    end)
    character:GetAttributeChangedSignal("BlockBroken"):Connect(function()
        if character:GetAttribute("BlockBroken") then SetBlock(false) end
    end)
end

if LocalPlayer.Character then SetupDodgeAndHook(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(SetupDodgeAndHook)

local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
local ReplicateTryAttack = RemoteEvents and RemoteEvents:FindFirstChild("ReplicateTryAttack")
if ReplicateTryAttack then
    ReplicateTryAttack.OnClientEvent:Connect(function(attackData)
        if not BotConfig.MasterSwitch or BotState.InCounterAttack then return end
        if not attackData or typeof(attackData) ~= "table" then return end
        local attacker = attackData[2]
        local myChar = LocalPlayer.Character
        if not attacker or not myChar or attacker == myChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        local oppRoot = attacker:FindFirstChild("HumanoidRootPart")
        if not myRoot or not oppRoot then return end
        local dist = (myRoot.Position - oppRoot.Position).Magnitude
        local isRyu, info = false, nil
        if BotConfig.AutoDodgeRyu and attackData[1] and Buwic and InfoToString then
            pcall(function()
                local br = Buwic.fromBuffer(attackData[1])
                local _a = br:readu16()
                local s = { br:readString() }
                local ai = InfoToString.DeconvertAttack(s)
                if ai and ai.CurrentPunch and RYU_SKILLS[ai.CurrentPunch] then
                    isRyu = true; info = RYU_SKILLS[ai.CurrentPunch]
                end
            end)
        end
        if isRyu and info then
            SetBlock(false)
            if info.SuperArmor then BotState.PauseAttackUntil = tick() + 0.80 end
            task.delay(info.DodgeDelay or 0.22, function()
                if BotConfig.MasterSwitch then
                    SetBlock(false)
                    PerformDash(info.Direction or "Right", true)
                end
            end)
            return
        end
        if BotConfig.AutoBlock and dist <= 11 then
            if not myChar:GetAttribute("Perfect") and not myChar:GetAttribute("ClientProjectileFreeDashUntil") then
                SetBlock(true)
                task.delay(0.32, function()
                    if BotState.IsBlocking and not myChar:GetAttribute("Perfect") and not BotState.InCounterAttack then
                        SetBlock(false)
                    end
                end)
            end
        end
    end)
end

local function CheckHadokenInstance(inst)
    if not BotConfig.MasterSwitch or not BotConfig.AutoDodgeRyu then return end
    local n = inst.Name
    if n:find("RyuHadoken") or n:find("Hadoken") or n:find("DenjinHadoken") then
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        local now = tick()
        if now - BotState.LastRyuDodgeTime < 0.25 then return end
        if n:find("Firing") or n:find("Proj") then
            BotState.LastRyuDodgeTime = now
            SetBlock(false)
            PerformDash("Right", true)
        elseif n:find("Charging") then
            task.delay(0.30, function()
                if BotConfig.MasterSwitch then
                    SetBlock(false)
                    PerformDash("Right", true)
                end
            end)
        end
    end
end

Workspace.ChildAdded:Connect(CheckHadokenInstance)
pcall(function()
    local d = Workspace:FindFirstChild("Debris") or Workspace:WaitForChild("Debris", 3)
    if d then d.ChildAdded:Connect(CheckHadokenInstance) end
end)

RunService.Heartbeat:Connect(function()
    if not BotConfig.MasterSwitch or not BotConfig.AutoAttack or BotState.InCounterAttack then return end
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myHum = myChar:FindFirstChild("Humanoid")
    if not myHum or myHum.Health <= 0 then return end
    local myRoot = myChar.HumanoidRootPart
    local st = GetPlayerState(LocalPlayer)
    if not st then return end
    local cd = st:FindFirstChild("CharacterData")
    local occ = st:FindFirstChild("Occupied")
    if not cd or not occ then return end
    if occ:FindFirstChild("Equipped") and not occ.Equipped.Value then
        if MobileTrySwitchEquip then MobileTrySwitchEquip:Fire() end
        return
    end
    local opp = GetCurrentOpponent()
    BotState.OpponentChar = opp
    if not opp or not opp:FindFirstChild("HumanoidRootPart") then return end
    local oppRoot = opp.HumanoidRootPart
    local oppHum = opp:FindFirstChild("Humanoid")
    if not oppHum or oppHum.Health <= 0 then SetBlock(false); return end
    local dist = (myRoot.Position - oppRoot.Position).Magnitude

    if BotConfig.AutoDodgeRyu and oppHum then
        local a = oppHum:FindFirstChild("Animator")
        if a then
            for _, tr in ipairs(a:GetPlayingAnimationTracks()) do
                if tr.IsPlaying and tr.Animation and tr.Animation.AnimationId then
                    local aid = tr.Animation.AnimationId
                    for rid, sk in pairs(RYU_ANIM_IDS) do
                        if aid:find(rid) then
                            if sk.SuperArmor then BotState.PauseAttackUntil = tick() + 0.60 end
                            local now = tick()
                            if now - BotState.LastRyuDodgeTime > 0.35 then
                                if tr.TimePosition >= (sk.DodgeDelay - 0.08) then
                                    BotState.LastRyuDodgeTime = now
                                    SetBlock(false)
                                    PerformDash(sk.Direction or "Right", true)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if BotConfig.AutoFaceOpponent then
        myRoot.CFrame = CFrame.lookAt(myRoot.Position, Vector3.new(oppRoot.Position.X, myRoot.Position.Y, oppRoot.Position.Z))
    end
    if BotConfig.AutoChase and not BotState.IsBlocking then myHum:MoveTo(oppRoot.Position) end

    local stamina = (cd:FindFirstChild("Stamina") and cd.Stamina.Value) or 100
    if BotConfig.StaminaManagement and stamina < BotConfig.MinStaminaToAttack then
        if dist <= 7 and not BotState.IsBlocking then SetBlock(true) end
        return
    elseif BotState.IsBlocking and dist > 7 then
        SetBlock(false)
    end

    local ult = (cd:FindFirstChild("UltimateEnergy") and cd.UltimateEnergy.Value) or 0
    if BotConfig.AutoQ_Ultimate and ult >= 99 and dist <= BotConfig.AttackDistance then PressQ_Ultimate() end
    if BotState.PauseAttackUntil and tick() < BotState.PauseAttackUntil then return end

    if dist <= BotConfig.AttackDistance and not BotState.IsBlocking and CanPlayerPunch() then
        local oppSt = GetPlayerState(Players:GetPlayerFromCharacter(opp))
        local oppCd = oppSt and oppSt:FindFirstChild("CharacterData")
        local oppBlocking = (oppCd and oppCd:FindFirstChild("Blocking") and oppCd.Blocking.Value) or false
        if BotConfig.SmartBlockBreak and oppBlocking then
            PerformPunch(true); task.wait(0.20)
        else
            PerformPunch(false); task.wait(BotConfig.PunchInterval)
        end
    end
end)

-- ============================================================
-- 🥊 UI DAIGO HUB (HP + PC) - DEFAULT OFF
-- ============================================================
local isMobile = UserInputService.TouchEnabled
local isPC = UserInputService.KeyboardEnabled

local function getUIParent()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DaigoHubUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.Parent = getUIParent()

local panelSize    = isMobile and UDim2.new(0, 230, 0, 250) or UDim2.new(0, 220, 0, 230)
local panelPos     = isMobile and UDim2.new(0, 12, 0, 90)     or UDim2.new(1, -240, 0, 80)
local btnHeight    = isMobile and 34 or 28
local titleHeight  = isMobile and 34 or 30

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = panelSize
panel.Position = panelPos
panel.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
panel.BackgroundTransparency = 0.08
panel.BorderSizePixel = 0
panel.Active = true
panel.Draggable = true
panel.Parent = screenGui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", panel)
stroke.Color = Color3.fromRGB(0, 200, 120)
stroke.Thickness = 1.5
stroke.Transparency = 0.3

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, titleHeight)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 160, 95)
titleBar.BorderSizePixel = 0
titleBar.Parent = panel
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🥊 DAIGO HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = isMobile and 15 or 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 26, 0, 22)
minBtn.Position = UDim2.new(1, -32, 0, (titleHeight-22)/2)
minBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
minBtn.Text = "—"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -16, 1, -titleHeight - 10)
content.Position = UDim2.new(0, 8, 0, titleHeight + 6)
content.BackgroundTransparency = 1
content.Parent = panel

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 6)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = content

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "STATUS: OFF"
statusLabel.TextColor3 = Color3.fromRGB(220, 70, 70)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = isMobile and 12 or 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.LayoutOrder = 0
statusLabel.Parent = content

local function makeToggle(name, order, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, btnHeight)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 150, 90) or Color3.fromRGB(150, 40, 40)
    btn.Text = name .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = isMobile and 13 or 12
    btn.LayoutOrder = order
    btn.Parent = content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 90) or Color3.fromRGB(150, 40, 40)
        callback(state)
    end)
    return btn
end

makeToggle("MASTER", 1, false, function(v)
    BotConfig.MasterSwitch = v
    statusLabel.Text = "STATUS: " .. (v and "ON" or "OFF")
    statusLabel.TextColor3 = v and Color3.fromRGB(0,220,130) or Color3.fromRGB(220,70,70)
end)
makeToggle("DODGE",   2, false, function(v) BotConfig.AutoPerfectDodge = v end)
makeToggle("BLOCK",   3, false, function(v) BotConfig.AutoBlock = v end)
makeToggle("ATTACK",  4, false, function(v) BotConfig.AutoAttack = v end)
make
