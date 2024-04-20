if not game:IsLoaded() then
    game.Loaded:Wait()
end

setthreadidentity(7)

local dev = false
local beta = true
local Version = "1.1.2a"

if not isfolder("SakataWare") then
    makefolder("SakataWare")
end

if library and getgenv().SakataWareLoaded then
    library:Unload()
    getgenv().SakataWareLoaded = nil
end

local library = loadstring(not dev and game:HttpGet("https://github.com/relsakata/sakataware/raw/main/library.lua") or readfile("SakataWare/library.lua"))()(`SakataWare | {cloneref(game:GetService("MarketplaceService")):GetProductInfo(game.PlaceId).Name}`, `SakataWare/{game.PlaceId}`)
library:Init();

local AutoLoad

for _, v in next, getconnections(cloneref(game:GetService("Players")).LocalPlayer.Idled) do
    v:Disable()
end

if isfile("SakataWare/autoload.json") then
    AutoLoad = cloneref(game:GetService("HttpService")):JSONDecode(readfile("SakataWare/autoload.json"))
else
    writefile("SakataWare/autoload.json", "{}")
    AutoLoad = cloneref(game:GetService("HttpService")):JSONDecode(readfile("SakataWare/autoload.json"))
end

if not game:HttpGet("https://raw.githubusercontent.com/relsakata/DBR/main/DB.lua"):find('--expeecall') then
    noRun = true
    -- while true do end
end

do
    local HomeTab = library:AddTab("Home")
    local HomeColumn = HomeTab:AddColumn();
    local MainSection = HomeColumn:AddSection("Home")
    MainSection:AddDivider("Main")
    if not isfile("SakataWare/HideUser") then
        writefile("SakataWare/HideUser", "return false")
    end
    
    local HideUser = loadstring(readfile("SakataWare/HideUser"))()

    local Name

    if HideUser then
        Name = "Anonymous"
    else
        Name = game.Players.LocalPlayer.DisplayName
    end


    local HelloLabel = MainSection:AddLabel(`Hello, {Name}!`)
    local VersionLabel = MainSection:AddLabel(`Version, {dev and "DEV" or beta and "BETA "..Version or Version}!`)

    local HideUser = MainSection:AddToggle({
        default = false,
        text = "Hide User from Home Page",
        skipflag = true,
        callback = function(bool)
            if bool then
                writefile("SakataWare/HideUser", "return true")
                HelloLabel:Update("Hello, Anonymous!")
            else
                writefile("SakataWare/HideUser", "return false")
                HelloLabel:Update("Hello, "..game.Players.LocalPlayer.DisplayName.."!")
            end
        end
    })    

end

if game.PlaceId == 9872472334 then
    if not noRun then
        do
            if not isfolder("SakataWare/"..game.PlaceId) then
                makefolder("SakataWare/"..game.PlaceId)
            end

            local CurrentTick = tick()

            getgenv().SakataWareLoaded = CurrentTick
            getgenv().SakataWare = {
                AutoFarm = {
                    toggle = false,
                    autohide = false,
                    autoclover = false,
                    autorevive = false,
                    autorespawn = false,
                },
                Speed = false,
                SpeedValue = 1500,
                HideUser = false,
                Threads = {}
            }

            local script_flag = {
                Hiding = false,
                Reviving = false,
                Clover = false,
            }

            local Players = game.Players
            local LocalPlayer = Players.LocalPlayer
            local char = LocalPlayer.Character
            local Action = "Hide"
            
            LocalPlayer.CharacterAdded:Connect(function(new)
                char = new
            end)
            
            local GetDownedPlr = function()
                for i,v in workspace.Game.Players:GetChildren() do
                    if v:GetAttribute("Downed") then
                        return v
                    end
                end
            end

            getgenv().SakataWare.Threads[#SakataWare.Threads+1] = task.spawn(function()
                local old
                old = hookmetamethod(game,"__namecall", newcclosure(function(self,...)
                    local Args = {...}
                    local method = getnamecallmethod()
                    if tostring(self) == 'Communicator' and Args[1] == "update" and getgenv().SakataWare.Speed and getgenv().SakataWareLoaded==CurrentTick then
                        return getgenv().SakataWare.SpeedValue, 50
                    end
                    return old(self,...)
                end))

                local Action = "None"
                local lastClover = tick()
                while task.wait() do
                    if not char then repeat task.wait() until char end
                    LocalPlayer.Character:WaitForChild"HumanoidRootPart"
                    if getgenv().SakataWare.AutoFarm.toggle then
                        if getgenv().SakataWare.AutoFarm.autorespawn and (char and char:GetAttribute("Downed") == true or not char) then
                            cloneref(game:GetService("ReplicatedStorage")).Events.Respawn:FireServer()
                        end
                        if Action == "None" and not script_flag.Hiding and getgenv().SakataWare.AutoFarm.autohide then
                            char:PivotTo(CFrame.new(char.HumanoidRootPart.Position+Vector3.new(0,200,0))) -- Hide
                            script_flag.Hiding=true
                        end
                        -- local DownedPlr = GetDownedPlr()
                        -- if DownedPlr and getgenv().SakataWare.AutoFarm.autorevive and Action == "None" then
                        --     -- script_flag.Hiding = false
                        --     -- Action = "Reviving"
                        --     -- task.spawn(function()
                        --     --     repeat task.wait() char.HumanoidRootPart:PivotTo(CFrame.new(DownedPlr.HumanoidRootPart.Position - Vector3.new(0, 8, 0))) until Action == "None" or char == nil
                        --     -- end)
                        --     -- game:GetService("ReplicatedStorage").Events.Revive.RevivePlayer:FireServer(DownedPlr.Name, true)
                        --     -- task.wait(3.5)
                        --     -- game:GetService("ReplicatedStorage").Events.Revive.RevivePlayer:FireServer(DownedPlr.Name, false)
                        --     -- task.wait(.2)
                        --     -- Action = "None"
                        -- end
                        if getgenv().SakataWare.AutoFarm.autoclover and Action == "None" and tick() - lastClover >= 10 then
                            for i,v in workspace.Game.Effects.Tickets:GetChildren() do
                                if v:FindFirstChild("HumanoidRootPart") then
                                    script_flag.Hiding = false
                                    Action = "Clover"
                                    char:PivotTo(CFrame.new(v.HumanoidRootPart.Position))
                                    task.wait(.2)
                                end
                            end
                            lastClover = tick()
                            Action = "None"
                        end
                    end
                end
            end)


            if getgenv().SakataWareLoaded~=CurrentTick then
                for i,v in getgenv().SakataWare.Threads do
                    v:Cancel()
                end
            end

            local MainTab = library:AddTab("Main")
            local MainColumn1 = MainTab:AddColumn();
            local AutoFarmSection = MainColumn1:AddSection("Main")


            local AutoFarmToggle = AutoFarmSection:AddToggle({
                default = false,
                text = "Toggle",
                flag = "ToggleAutoFarm",
                callback = function(bool)
                    getgenv().SakataWare.AutoFarm.toggle = bool
                end
            })

            AutoFarmSection:AddDivider("Settings");

            local AutoHide = AutoFarmSection:AddToggle({
                default = false,
                text = "Auto Hide",
                flag = "AutoHide",
                callback = function(bool)
                    getgenv().SakataWare.AutoFarm.autohide = bool
                end
            })

            -- local AutoRevive = AutoFarmSection:AddToggle({
            --     default = false,
            --     text = "Auto Revive",
            --     flag = "Revive",
            --     callback = function(bool)
            --         getgenv().SakataWare.AutoFarm.autorevive = bool
            --     end
            -- })

            local AutoClover = AutoFarmSection:AddToggle({
                default = false,
                text = "Auto Clover",
                flag = "Clover",
                callback = function(bool)
                    getgenv().SakataWare.AutoFarm.autoclover = bool
                end
            })

            local AutoRespawn = AutoFarmSection:AddToggle({
                default = false,
                text = "Auto Respawn",
                flag = "Respawn",
                callback = function(bool)
                    getgenv().SakataWare.AutoFarm.autorespawn = bool
                end
            })

            local MiscSection = MainColumn1:AddSection("Misc")
            local SpeedToggle = MiscSection:AddToggle({
                default = false,
                text = "Speed",
                flag = "Speed",
                callback = function(bool)
                    getgenv().SakataWare.Speed = bool
                end
            })

            local SpeedBox = MiscSection:AddBox({text = "Speed Value (Default=1500)", flag = "SpeedValue", callback = function(value) getgenv().SakataWare.SpeedValue = value end});
        end
    end
elseif game.PlaceId == 71315343 then
    if not noRun then
        do
            if not isfolder("SakataWare/"..game.PlaceId) then
                makefolder("SakataWare/"..game.PlaceId)
            end
            local CurrentTick = tick()
            getgenv().SakataWareLoaded = CurrentTick
            local Players = game.Players
            local LocalPlayer = Players.LocalPlayer
            if not LocalPlayer.Character then
                LocalPlayer.CharacterAdded:Wait()
            end
            local Character = LocalPlayer.Character

            getgenv().SakataWare = {
                Threads = {},
                AutoDB = false,
                AutoRebirth = false,
            }

            local Threads = {}

            if getgenv().SakataWareLoaded~=CurrentTick then
                for i,v in Threads do
                    v:Cancel()
                end
            end

            local MainTab = library:AddTab("Main")
            local MainColumn1 = MainTab:AddColumn();
            local AutoFarmSection = MainColumn1:AddSection("Main")


            local AutoDB = AutoFarmSection:AddToggle({
                default = false,
                text = "Auto Dragon Ball Server Hop",
                flag = "DBToggle",
                callback = function(bool)
                    getgenv().SakataWare.AutoDB = bool
                end
            })

            AutoFarmSection:AddDivider("Settings");

            local AutoZenkai = AutoFarmSection:AddToggle({
                default = false,
                text = "Auto Zenkai (Use with DB)",
                flag = "Zenkai",
                callback = function(bool)
                    getgenv().SakataWare.AutoRebirth = bool
                end
            })

            local JobIds = {}
            local nextPageCursor
            if not isfile("dbr-shop.json") then
                writefile("dbr-shop.json", cloneref(game:GetService("HttpService")):JSONEncode(JobIds))
            end

            local JobIds = cloneref(game:GetService("HttpService")):JSONDecode(readfile("dbr-shop.json"))

            local function ServerHop()
                local Body;
                if not nextPageCursor then
                    Body = cloneref(game:GetService("HttpService")):JSONDecode(http_request({ Url = 'https://games.roblox.com/v1/games/' .. game.placeId .. '/servers/Public?sortOrder=Asc&limit=100', Method = "GET"}).Body)
                else
                    Body = cloneref(game:GetService("HttpService")):JSONDecode(http_request({ Url = 'https://games.roblox.com/v1/games/' .. game.placeId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. nextPageCursor, Method = "GET"}).Body)
                end
                local ID = ""
                if Body.nextPageCursor and Body.nextPageCursor ~= "null" and Body.nextPageCursor ~= nil then
                    nextPageCursor = Body.nextPageCursor
                end
                local num = 0;
                for i,v in Body.data do
                    ID = v.id
                    if tonumber(v.maxPlayers) > tonumber(v.playing) then
                        if JobIds[ID] then
                            if tick() - JobIds[ID] >= 600 then
                                JobIds[ID] = nil
                            elseif i ~= #Body.data then
                                continue
                            else
                                xpcall(ServerHop, warn)
                            end
                        end
                        JobIds[ID] = tick()
                        writefile("dbr-shop.json", cloneref(game:GetService("HttpService")):JSONEncode(JobIds))
                        repeat cloneref(game:GetService("TeleportService")):TeleportToPlaceInstance(game.placeId, ID) task.wait() until nil
                    end
                end
            end

            function CollectDB()
                for i,v in workspace.Map:GetChildren() do
                    if v:FindFirstChild("Main") then
                        Character.HumanoidRootPart.CFrame = CFrame.new(v.Main.Position)
                        task.wait(.5)
                        fireproximityprompt(v.Main.Attachment.ProximityPrompt)
                        task.wait(.5)
                    end
                end
            end

            function Wish()
                if require(game:GetService("ReplicatedStorage")["_replicationFolder"].DragonBallUtils).PlayerHasAllDragonBalls(LocalPlayer) then
                    Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.Pedestal.Center.Position)
                    task.wait(.5)
                    fireproximityprompt(workspace.Map.Pedestal.Center.Attachment.ProximityPrompt)
                    task.wait(.5)
                    firesignal(LocalPlayer.PlayerGui.Wish.Wishes.List.ZenkaiBoost.Button.MouseButton1Click)
                    task.wait(.5)
                    firesignal(LocalPlayer.PlayerGui.Wish.Accept.MouseButton1Click)
                end
            end

            Threads[#Threads+1] = task.spawn(function()
                while task.wait(1) do
                    if getgenv().SakataWare.AutoDB then
                        CollectDB()
                        if getgenv().SakataWare.AutoRebirth then
                            Wish()
                        end

                        queue_on_teleport(`{not dev and 'loadstring(game:HttpGet("https://github.com/relsakata/sakataware/raw/main/main.lua", "Real"))()({AutoDB = true})' or 'loadstring(readfile("SakataWare/SakataWare.lua"))()({AutoDB = true})'}`)
                        xpcall(ServerHop, warn)
                    end
                end
            end)

            Threads[#Threads+1] = task.spawn(function()
                while task.wait(1) do
                    if getgenv().SakataWare.AutoRebirth then
                        Wish()
                    end
                end
            end)
        end
    end
elseif game.PlaceId == 1537690962 then
    if not noRun then
        do
            if not game:IsLoaded() then
                game.Loaded:Wait()
                cloneref(game:GetService("Players")).LocalPlayer.PlayerGui:WaitForChild("ScreenGui")
                cloneref(game:GetService("Players")).LocalPlayer.PlayerGui.ScreenGui:WaitForChild("LoadingMessage")
            end
            
            getgenv().SakataWare = {
                AutoFarm = {
                    toggle = false,
                    autodig = false,
                    SelectedField = "Dandelion Field",
                    ConvertAt = 100,
                    FarmDupedTokens = false,
                    FarmBubbles = false,
                    FaceBalloon = false,
                    ConvBalloon = false,
                    ConvBalloonAt = 30,
                },

                Planters = {
                    toggle = false,
                    BlacklistedPlanters = {},
                    BlacklistedNectars = {},
                    HarvestAt = 20,
                },

                Movements = {
                    MoveMethod = "Lerp", -- TweenService, Lerp, PathfindWalk, PathfindTween, PathfindLerp
                    LerpSteps = 10,
                    LerpDelay = 200,
                    TweenServiceSpeed = 100,
                }
            }
    
            local internalFlags = {
                LerpFinished = false,
                dupeTokens = {},
                MobDetection = {
                    Windy = false,
                    Vicious = false,
                    Mondo = false,
                },
                PauseAutoFarm = false,
                Sprout = {},
                PlayerBalloons = {},
                PlayerFires = {},
                Treasures = {},
                currentField = "Dandelion Field",
                currentTweenThread = nil,
                currentTweenFlags = nil,
                Tweening = false,
            }

            for i,v in workspace.Collectibles:GetChildren() do
                table.insert(internalFlags.Treasures, v.Position)
            end

            local CurrentTick = tick()
            getgenv().SakataWareLoaded = CurrentTick
    
            local Threads = {}
            if getgenv().SakataWareLoaded~=CurrentTick then
                for i,v in Threads do
                    v:Cancel()
                end
            end

            --Services
            local TweenService = cloneref(game:GetService("TweenService"))
            local HttpService = cloneref(game:GetService("HttpService"))
            local Players = cloneref(game:GetService("Players"))
            local PathfindingService = cloneref(game:GetService('PathfindingService'))
            local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
            local workspace = cloneref(game:GetService("Workspace"))

            -- Modules
            local ActivatablesHives = require(ReplicatedStorage.Activatables.Hives)
            -- local ActivatablesToys = require(ReplicatedStorage.Activatables.Toys)
            -- local ActivatablesNPC = require(ReplicatedStorage.Activatables.NPCs)
            -- local ActivatablesPlanters = require(ReplicatedStorage.Activatables.Planter)
            local ScreenInfo = require(ReplicatedStorage.ScreenInfo)
            -- local Events = require(ReplicatedStorage.Events)
            -- local Quests = require(ReplicatedStorage.Quests)
            -- local RoboBearGui = require(ReplicatedStorage.Gui.RoboBearGui)
            local PlanterTypes = require(ReplicatedStorage.PlanterTypes)
            local NectarTypes = require(ReplicatedStorage.NectarTypes)
            -- local EggTypes = require(ReplicatedStorage.EggTypes)
            -- local BeeTypes = require(ReplicatedStorage.BeeTypes)
            local LocalPlanters = require(ReplicatedStorage.LocalPlanters)
            -- local Accessories = require(ReplicatedStorage.Accessories)
            -- local Collectors = require(ReplicatedStorage.Collectors)
            -- local checkAccessory = require(ReplicatedStorage.ItemPackages.Accessory).PlayerHas
            -- local checkTool = require(ReplicatedStorage.ItemPackages.Collector).PlayerHas
            local BuffTileModule = require(ReplicatedStorage.Gui.TileDisplay.BuffTile)
            -- local ClientMonsterTools = require(ReplicatedStorage.ClientMonsterTools)
            -- local MemoryMatchModule = require(ReplicatedStorage.Gui.MemoryMatch)
            local ClientStatCache = require(ReplicatedStorage.ClientStatCache)
            -- local MinigameGui = require(ReplicatedStorage.Gui.MinigameGui)
            -- local MonsterTypes = require(ReplicatedStorage.MonsterTypes)
            local timeToString = require(ReplicatedStorage.TimeString)
            -- local AlertBoxes = require(ReplicatedStorage.AlertBoxes)
            -- local StatTools = require(ReplicatedStorage.StatTools)
            -- local StatReqs = require(ReplicatedStorage.StatReqs)
            local ServerTime = require(ReplicatedStorage.OsTime)

            local ScreenGui = ScreenInfo:GetScreenGui()
            -- local Activatables = ReplicatedStorage.Activatables
            -- local MemoryMatchManager = ReplicatedStorage.MemoryMatchManager
            -- local MemoryMatchGui = ReplicatedStorage.Gui.MemoryMatch

            local PlayerActivesCommands = ReplicatedStorage.Events.PlayerActivesCommand
            local RetrievePlayerStats = ReplicatedStorage.Events.RetrievePlayerStats

            local LocalPlayer = Players.LocalPlayer
            local FlowerZones = workspace:WaitForChild("FlowerZones")
            local Fields = {}
            local WhiteFields = {}
            local BlueFields = {}
            local RedFields = {}
            local PlantersList = {}
            local plantersTable = {}

            for i,v in PlanterTypes.GetTypes() do
                if v.Description == "Test planter." then continue end
                local planterData = {
                    systemName = v.Name,
                    displayName = v.DisplayName,
                    nectarMultipliers = v.NectarMultipliers,
                    pollenMultipliers = v.PollenMultipliers
                }
                plantersTable[v.Name] = planterData
                table.insert(PlantersList, v.DisplayName)
            end

            while not LocalPlayer:FindFirstChild("Honeycomb") do 
                task.wait()
                for i = 8,3,-1 do
                    local hive = workspace.Honeycombs:FindFirstChild("Hive"..i)
                    if hive and not hive.Owner.Value then
                        repeat
                            if (hive.SpawnPos.Value.p - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                                setthreadidentity(2)
                                ActivatablesHives.ButtonEffect(LocalPlayer, hive.Platform.Value)
                                setthreadidentity(7)
                                task.wait(.75)
                            else 
                                LocalPlayer.Character.Humanoid:MoveTo(hive.SpawnPos.Value.p - Vector3.new(0,2,0))
                            end
                            task.wait()
                        until hive.Owner.Value or LocalPlayer:FindFirstChild("Honeycomb")
                        if LocalPlayer:FindFirstChild("Honeycomb") then break end
                    end
                end
            end

            local playerHive = LocalPlayer:FindFirstChild("Honeycomb").Value

            for i, v in FlowerZones:GetChildren() do
                table.insert(Fields, v.Name)
                if not v:FindFirstChild("ColorGroup") then
                    local colorGroup = Instance.new("StringValue")
                    colorGroup.Name = "ColorGroup"
                    colorGroup.Value = "White"
                    colorGroup.Parent = v
                end
                if v.ColorGroup.Value == "Blue" then
                    table.insert(BlueFields, v.Name)
                elseif v.ColorGroup.Value == "Red" then
                    table.insert(RedFields, v.Name)
                elseif v.ColorGroup.Value == "White" then
                    table.insert(WhiteFields, v.Name)
                end
            end

            local oldTaskSpawn;
            oldTaskSpawn = hookfunction(task.spawn, function(...)
                local Task = oldTaskSpawn(...)
                Threads[#Threads+1] = Task
                return Task
            end)

            task.spawn(function()
                while task.wait() do
                    if getgenv().SakataWare.AutoFarm.autodig then
                        setthreadidentity(2)
                        require(game.ReplicatedStorage.Collectors.LocalCollect).Run()
                        setthreadidentity(7)
                    end
                end
            end)

            function findField(position)
                if typeof(position) == "CFrame" then position = position.p end
                local Rays = {}
                Rays[#Rays+1] = Ray.new(position+Vector3.new(0, -35, 0), Vector3.new(0, 100, 0))
                Rays[#Rays+1] = Ray.new(position+Vector3.new(5, -35, 0), Vector3.new(5, 100, 0))
                Rays[#Rays+1] = Ray.new(position+Vector3.new(-5, -35, 0), Vector3.new(-5, 100, 0))
                Rays[#Rays+1] = Ray.new(position+Vector3.new(0, -35, 5), Vector3.new(0, 100, 5))
                Rays[#Rays+1] = Ray.new(position+Vector3.new(0, -35, -5), Vector3.new(0, 100, -5))
                for i,v in Rays do
                    local hit, hitPos = workspace:FindPartOnRayWithWhitelist(v, {workspace.FlowerZones})
                    if hit and hit.Parent.Name == "FlowerZones" then
                        return hit
                    elseif i~=#Rays then
                        continue
                    else
                        return nil
                    end
                end
            end

            function isAlive()
                if not LocalPlayer.Character then
                    return false, nil
                end
                if not LocalPlayer.Character:FindFirstChild("Humanoid") then
                    return false, nil
                end
                if LocalPlayer.Character.Humanoid.Health<=0 then
                    return false, nil
                end

                return true, LocalPlayer.Character
            end

            function destroyBodyGyro()
                local Alive, Character = isAlive()
                if not Alive or not Character or not (Character and Character:FindFirstChild("UpperTorso")) then return end
                local Torso = Character:FindFirstChild("UpperTorso")
            
                local bodyGyro = Torso:FindFirstChildOfClass("BodyGyro")
                if bodyGyro then bodyGyro:Destroy() end
            end
            
            function lookAt(LookDirection)
                local Alive, Character = isAlive()
                if not Alive or not Character or not (Character and Character:FindFirstChild("UpperTorso")) then return end
                local Torso = Character:FindFirstChild("UpperTorso")
            
                local bodyGyro = Torso:FindFirstChildOfClass("BodyGyro") or Instance.new("BodyGyro")
                bodyGyro.MaxTorque = Vector3.new(0, math.huge, 0)
                bodyGyro.D = 10
                bodyGyro.P = 5000
                bodyGyro.CFrame = CFrame.new(Torso.CFrame.p, LookDirection)
                bodyGyro.Parent = Torso
            end

            local whitelistedDupedTokens = {
                "1629547638",
                "5877939956"
            }
            
            task.spawn(function() 
                repeat task.wait() until workspace:FindFirstChild("Camera") and workspace.Camera:FindFirstChild("DupedTokens")
                workspace.Camera.DupedTokens.ChildAdded:Connect(function(instance)
                    task.wait(.05)
                    local texture = instance.FrontDecal.Texture
                    local tokenId = tostring(texture):match("%d+")
                    if table.find(whitelistedDupedTokens, tokenId) and findField(instance.Position).Name == getgenv().SakataWare.AutoFarm.SelectedField then
                        table.insert(internalFlags.dupeTokens, instance)
                    end
                end)
                workspace.Camera.DupedTokens.ChildRemoved:Connect(function(instance) 
                    task.wait(.05)
                    local index = table.find(internalFlags.dupeTokens, instance)
                    if index then
                        table.remove(internalFlags.dupeTokens, index)
                    end
                end)
            end)

            function VeloZero()
                local Alive, Character = isAlive()
                if Alive and Character then
                    Character.HumanoidRootPart.Velocity = Vector3.zero
                    for i, v in Character:GetDescendants() do
                        if v:IsA("BasePart") and v.CanCollide == true then
                            v.CanCollide = false
                        end
                    end
                end
            end

            function Lerp(pos)
                local LerpTable = {
                    Finished = false,
                    LerpStarted = false,
                }

                local LerpThread = task.spawn(function()
                    local VeloZeroThread = oldTaskSpawn(function()
                        while task.wait() do
                            if LerpTable.Finished then break end
                            if LerpTable.LerpStarted then
                                VeloZero()
                            end
                        end
                    end)
                    if typeof(pos) == "CFrame" then pos = pos.p end
                    pos = pos + Vector3.new(0, 5, 0)
                    repeat
                        LerpTable.LerpStarted = true
                        local Alive, Character = isAlive()
                        if Alive then
                            local newpos = (pos - Character.HumanoidRootPart.Position).Unit
                            newpos = newpos == newpos and newpos * math.min((pos - Character.HumanoidRootPart.Position).Magnitude, getgenv().SakataWare.Movements.LerpSteps) or Vector3.zero
                            Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame + newpos
                            if (pos - Character.HumanoidRootPart.CFrame.p).Magnitude <= 5 then
                                break
                            end
                        end
                        task.wait(getgenv().SakataWare.Movements.LerpDelay/1000)
                    until not Alive or Alive and (pos - Character.HumanoidRootPart.Position).Magnitude <= 5
                    LerpTable.Finished = true
                    if VeloZeroThread then
                        task.cancel(VeloZeroThread)
                    end
                end)

                return LerpThread, LerpTable
            end

            function Tween(pos)
                local TweenTable = {
                    Finished = false,
                    TweenStarted = false,
                }

                local TweenThread = task.spawn(function()
                    local VeloZeroThread = oldTaskSpawn(function()
                        while task.wait() do
                            if TweenTable.TweenStarted then
                                VeloZero()
                            end
                        end
                    end)
                    if typeof(pos) == "CFrame" then
                        pos = pos.p
                    end
                    pos = pos+Vector3.new(0,5,0)
                    
                    local Alive, Character = isAlive()
                    local tweenInfo = TweenInfo.new((Character.HumanoidRootPart.Position - pos).Magnitude / getgenv().SakataWare.Movements.TweenServiceSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                    local CreatedTween = TweenService:Create(Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(pos)})
                    CreatedTween:Play()

                    TweenTable.Finished = true
                end)

                function TweenTable:Cancel()
                    task.cancel(TweenThread)
                end

                return TweenThread, TweenTable
            end

            function Goto(pos)
                if internalFlags.currentTweenThread then return "Active Lerp/Tween" end
                local MoveMethod = getgenv().SakataWare.Movements.MoveMethod
                local Thread
                local MoveFlag
                if typeof(pos) == "CFrame" then
                    pos = pos.p
                end
                pos = pos + Vector3.new(0, 5, 0)                    
                if MoveMethod == "Lerp" then
                    internalFlags.currentTweenThread, MoveFlag = Lerp(pos)
                elseif MoveMethod == "TweenService" then
                    internalFlags.currentTweenThread, MoveFlag = Tween(pos)
                end

                return internalFlags.currentTweenThread, MoveFlag
            end

            function WalkTo(pos)
                local Alive, Character = isAlive()
                if Alive and Character then
                    Character.Humanoid:MoveTo(pos)
                end
            end

            function getTokenId(token)
                local id = "0"
                if token and token.Parent and token:FindFirstChildOfClass("Decal") then
                    local texture = token:FindFirstChildOfClass("Decal").Texture
                    local tempId = tonumber(tostring(texture):match("%d+"))
                    if tempId then id = tempId end
                end
                return id
            end

             function NearestBubble()
                local Alive, Character = isAlive()
                local Current = {bubble = nil, distance = math.huge}
                for i, v in workspace.Particles:GetChildren() do
                    if v.Name ~= "Bubble" then continue end
                    local distance = (Character.HumanoidRootPart.Position - v.Position).Magnitude
                    if distance < Current.distance then
                        Current = {bubble = v, distance = distance}
                    end
                end
                return Current.bubble
            end

            function NearestToken(blacklistedTokens, callback)
                local Alive, Character = isAlive()
                local Current = {token = nil, distance = math.huge}
                for _, token in workspace.Collectibles:GetChildren() do
                    if blacklistedTokens and table.find(blacklistedTokens, token) then continue end
                    if token.CFrame.YVector.Y ~= 1 or token:FindFirstChild("Collected") or table.find(internalFlags.Treasures, token.Position) then 
                        continue
                    end
                    if findField(token.Position) and findField(Character.HumanoidRootPart.Position) and findField(token.Position) == findField(Character.HumanoidRootPart.Position) then
                        local distance = (Character.HumanoidRootPart.Position - token.Position).Magnitude
                        if distance < Current.distance and not token.Name:find("Collected") then
                            Current = {token = token, distance = distance}
                        end
                    end
                end
                return Current.token
            end

            function getTokenLink()
                local Alive, Character = isAlive()
                local Current = {token = nil, distance = math.huge}
                for i, v in workspace.Collectibles:GetChildren() do
                    if getTokenId(v) == 1629547638 and v.CFrame.YVector.Y == 1 then
                        local distance = (v.Position - Character.HumanoidRootPart.Position).magnitude
                        if distance < Current.distance then
                            Current = {token = v, distance = distance}
                        end
                    end
                end
                return Current.token
            end
            
            function collectToken(token)
                local Alive, Character = isAlive()
                if not token then return false end
                local startedCollecting = tick()
                local moveToCalled = -1
                local collected = false
                local TokenTouched = false
                local TouchConnection = token.Touched:Connect(function(a)
                    if a.Parent.Name == LocalPlayer.Name then
                        TokenTouched = true
                    end
                end)
                while task.wait() do
                    local Alive, Character = isAlive()
                    if Alive and (Character.HumanoidRootPart.Position - token.Position).magnitude < 4 or
                        token.CFrame.YVector.Y ~= 1 or (token.Position - Character.HumanoidRootPart.Position).magnitude < 4 or (tick() - startedCollecting) >= 3
                    then
                        if TokenTouched then break end
                        if (tick() - startedCollecting) >= 3 then break end
                        collected = true
                        break
                    elseif (Character.HumanoidRootPart.Position - token.Position).magnitude > 100 then break end
                    if TokenTouched then break end
                    if tick() - moveToCalled > 0.25 then
                        WalkTo(token.Position)
                        moveToCalled = tick()
                    end
            
                end

                if collected then
                    token.Name = token.Name.." Collected"
                    return true
                else
                    return false
                end
            end            

            function farmTokens()
                local nearestTokenLink = getTokenLink()
                if nearestTokenLink and isFieldSame(nearestTokenLink.Position, LocalPlayer.Character.HumanoidRootPart.Position) then
                    collectToken(nearestTokenLink)
                    return true
                else
                    local tokenToCollect = NearestToken(nil, function(token)
                        if token.CFrame.YVector.Y == 1 and not token:FindFirstChild("Collected") and not table.find(internalFlags.Treasures, token.Position) then 
                            return true 
                        end 
                    end)
                    if not tokenToCollect then return end
                    if tokenToCollect.Name:find("Collected") then return end
                    collectToken(tokenToCollect)
                    return true
                end
            end

            function farmBubble()
                local Alive, Character = isAlive()
                local nearestBubble = NearestBubble()
                if not nearestBubble then return false end
            
                local startedCollecting = tick()
                local moveToCalled = -1
                local Touched = false

                nearestBubble.Touched:Connect(function(b)
                    if b.Parent.Name == LocalPlayer.Name then
                        Touched = true
                        nearestBubble.Name = nearestBubble.Name.." Collected"
                    end
                end)


                while task.wait() do
                    if (Character.HumanoidRootPart.Position - nearestBubble.Position).Magnitude < 8.5 or
                    not nearestBubble.Parent or
                    (tick() - startedCollecting) >= 8 or nearestBubble.Name:find("Collected") then
                        break
                    end
                    
                    if tick() - moveToCalled > 0.5 then
                        WalkTo(nearestBubble.Position)
                        moveToCalled = tick()
                    end
                    task.wait()
                end
            
                return true
            end

            local cachedFieldFlowers = {}

            function getNumbers(str)
                local nums = {}
                for num in str:gmatch("%d+") do
                    table.insert(nums, tonumber(num))
                end
                return nums
            end

            function getAllFlowers(field)
                local fieldId = field.ID.Value
                local fieldFlowers
                if cachedFieldFlowers[field.Name] then
                    fieldFlowers = cachedFieldFlowers[field.Name]
                else
                    fieldFlowers = {}
                    for flowerIndex, flower in workspace.Flowers:GetChildren() do
                        local flowerInfo = getNumbers(flower.Name)
                        if #flowerInfo == 3 and flowerInfo[1] == fieldId then
                            table.insert(fieldFlowers, flower)
                        end
                    end
                    if not (#fieldFlowers <= 1) then 
                        cachedFieldFlowers[field.Name] = fieldFlowers 
                    else
                        return 
                    end
                end
                return fieldFlowers
            end

            function getRandomFlower(field)
                local fieldId = field.ID.Value
                local fieldFlowers
                if cachedFieldFlowers[field.Name] then
                    fieldFlowers = cachedFieldFlowers[field.Name]
                else
                    fieldFlowers = {}
                    for flowerIndex, flower in workspace.Flowers:GetChildren() do
                        local flowerInfo = getNumbers(flower.Name)
                        if #flowerInfo == 3 and flowerInfo[1] == fieldId then
                            table.insert(fieldFlowers, flower)
                        end
                    end
                    if not (#fieldFlowers <= 1) then 
                        cachedFieldFlowers[field.Name] = fieldFlowers 
                    else
                        return 
                    end
                end
                return fieldFlowers[math.random(1,#fieldFlowers)]
            end
            local lastRandomFlower = tick()

            function farmDupedTokens()
                local Alive, Character = isAlive()
                if #internalFlags.dupeTokens > 0 then
                    local dupedToken = next(internalFlags.dupeTokens)
                    if tonumber(dupedToken) then dupedToken = internalFlags.dupeTokens[dupedToken] end
                    local succ,err = pcall(function()
                        while dupedToken.Attachment.BillboardGuiFront.Smile.ImageColor3 ~= Color3.fromRGB(255, 0, 255) do
                            local pos = dupedToken.Position - Vector3.new(0,10,0)
            
                            WalkTo(pos)
            
                            task.wait(.05)
                        end
                        local index = table.find(internalFlags.dupeToken, dupedToken)
                        table.remove(internalFlags.dupeToken, index)
                    end)
                    if succ then return true end
                end
                return false
            end

            local sprinklerCounts = {
                ["The Supreme Saturator"] = 1,
                ["Basic Sprinkler"] = 1,
                ["Silver Soakers"] = 2,
                ["Golden Gushers"] = 3,
                ["Diamond Drenchers"] = 4
            }

            function isFieldSame(one, two)
                return findField(one) == findField(two)
            end

            function placeSprinkler(position, withoutWait, withoutJump)
                -- Place a sprinkler at the specified position
                local Alive, Character = isAlive()
                if not Alive then return end
                local humanoid = Character.Humanoid
                if position then
                    WalkTo(position)
                    humanoid.MoveToFinished:Wait()
                end
            
                if not withoutJump then
                    task.wait(.1)
                    humanoid.Jump = true
                    task.wait(.2)
                end
                PlayerActivesCommands:FireServer({["Name"] = "Sprinkler Builder"})
                if not withoutWait then
                    task.wait(1)
                end
            end
            
            function placeSprinklers(fieldPos)
                if not fieldPos then return end
                local sprinkler = ClientStatCache.Get().EquippedSprinkler
                local flowerSize = 4
            
                local sprinklersToPlace = sprinklerCounts[sprinkler] or 0
                local placedSprinklersCount = 0
            
                local centerPos = fieldPos
            
                for _,v in workspace.Gadgets:GetChildren() do
                    if v.Name == sprinkler and isFieldSame(centerPos, v.Base.Position) then
                        placedSprinklersCount += 1
                    end
                end
            
                if placedSprinklersCount >= sprinklersToPlace then return end
            
                -- Check number of sprinklers to place and use appropriate pattern
                if sprinklersToPlace == 1 then
                    -- Place one sprinkler in the center
                    placeSprinkler(centerPos, true, true)
                elseif sprinklersToPlace == 2 then
                    -- Place two sprinklers in a diagonal pattern
                    placeSprinkler(centerPos + Vector3.new(-3*flowerSize, 0, -3*flowerSize))
                    placeSprinkler(centerPos + Vector3.new(3*flowerSize, 0, 3*flowerSize), true, false)
                elseif sprinklersToPlace == 3 then
                    -- Place three sprinklers in a "T" pattern
                    placeSprinkler(centerPos + Vector3.new(3*flowerSize, 0, -3*flowerSize))
                    placeSprinkler(centerPos + Vector3.new(-4*flowerSize, 0, -3*flowerSize))
                    placeSprinkler(centerPos + Vector3.new(0*flowerSize, 0, 3*flowerSize), true, false)
                elseif sprinklersToPlace == 4 then
                    -- Place four sprinklers in a "square" pattern
                    placeSprinkler(centerPos + Vector3.new(-4*flowerSize, 0, 0*flowerSize))
                    placeSprinkler(centerPos + Vector3.new(4*flowerSize, 0, 0*flowerSize))
                    placeSprinkler(centerPos + Vector3.new(0*flowerSize, 0, 4*flowerSize))
                    placeSprinkler(centerPos + Vector3.new(0*flowerSize, 0, -4*flowerSize), true, false)
                end
            end

            local fullPlanterData = {
                ["Red Clay"] = {
                    NectarTypes = {Invigorating = 1.2, Satisfying = 1.2},
                    GrowthFields = {
                        ["Pepper Patch"] = 1.25,
                        ["Rose Field"] = 1.25,
                        ["Strawberry Field"] = 1.25,
                        ["Mushroom Field"] = 1.25
                    }
                },
                Plenty = {
                    NectarTypes = {
                        Satisfying = 1.5,
                        Comforting = 1.5,
                        Invigorating = 1.5,
                        Refreshing = 1.5,
                        Motivating = 1.5
                    },
                    GrowthFields = {
                        ["Mountain Top Field"] = 1.5,
                        ["Coconut Field"] = 1.5,
                        ["Pepper Patch"] = 1.5,
                        ["Stump Field"] = 1.5
                    }
                },
                Festive = {
                    NectarTypes = {
                        Satisfying = 3,
                        Comforting = 3,
                        Invigorating = 3,
                        Refreshing = 3,
                        Motivating = 3
                    },
                    GrowthFields = { }
                },
                Paper = {
                    NectarTypes = {
                        Satisfying = 0.75,
                        Comforting = 0.75,
                        Invigorating = 0.75,
                        Refreshing = 0.75,
                        Motivating = 0.75
                    },
                    GrowthFields = {}
                },
                Tacky = {
                    NectarTypes = {Satisfying = 1.25, Comforting = 1.25},
                    GrowthFields = {
                        ["Sunflower Field"] = 1.25,
                        ["Mushroom Field"] = 1.25,
                        ["Dandelion Field"] = 1.25,
                        ["Clover Field"] = 1.25,
                        ["Blue Flower Field"] = 1.25
                    }
                },
                Candy = {
                    NectarTypes = {Motivating = 1.2},
                    GrowthFields = {
                        ["Coconut Field"] = 1.25,
                        ["Strawberry Field"] = 1.25,
                        ["Pineapple Patch"] = 1.25
                    }
                },
                Hydroponic = {
                    NectarTypes = {Refreshing = 1.4, Comforting = 1.4},
                    GrowthFields = {
                        ["Blue Flower Field"] = 1.5,
                        ["Pine Tree Forest"] = 1.5,
                        ["Stump Field"] = 1.5,
                        ["Bamboo Field"] = 1.5
                    }
                },
                Plastic = {
                    NectarTypes = {
                        Refreshing = 1,
                        Invigorating = 1,
                        Comforting = 1,
                        Satisfying = 1,
                        Motivating = 1
                    },
                    GrowthFields = {}
                },
                Petal = {
                    NectarTypes = {Satisfying = 1.5, Comforting = 1.5},
                    GrowthFields = {
                        ["Sunflower Field"] = 1.5,
                        ["Dandelion Field"] = 1.5,
                        ["Spider Field"] = 1.5,
                        ["Pineapple Patch"] = 1.5,
                        ["Coconut Field"] = 1.5
                    }
                },
                ["Heat-Treated"] = {
                    NectarTypes = {Invigorating = 1.4, Motivating = 1.4},
                    GrowthFields = {
                        ["Pepper Patch"] = 1.5,
                        ["Rose Field"] = 1.5,
                        ["Strawberry Field"] = 1.5,
                        ["Mushroom Field"] = 1.5
                    }
                },
                ["Blue Clay"] = {
                    NectarTypes = {Refreshing = 1.2, Comforting = 1.2},
                    GrowthFields = {
                        ["Blue Flower Field"] = 1.25,
                        ["Pine Tree Forest"] = 1.25,
                        ["Stump Field"] = 1.25,
                        ["Bamboo Field"] = 1.25
                    }
                },
                Pesticide = {
                    NectarTypes = {Motivating = 1.3, Satisfying = 1.3},
                    GrowthFields = {
                        ["Strawberry Field"] = 1.3,
                        ["Spider Field"] = 1.3,
                        ["Bamboo Field"] = 1.3
                    }
                }
            }

            local planterTable = table.clone(fullPlanterData)
            
            local nectarData = {
                Refreshing = {"Blue Flower Field", "Strawberry Field", "Coconut Field"},
                Invigorating = {"Clover Field", "Cactus Field", "Mountain Top Field", "Pepper Patch"},
                Comforting = {"Dandelion Field", "Bamboo Field", "Pine Tree Forest"},
                Motivating = {"Mushroom Field", "Spider Field", "Stump Field", "Rose Field"},
                Satisfying = {"Sunflower Field", "Pineapple Patch", "Pumpkin Patch"}
            }
            
            function GetPlanterData(name)
                local PlanterTable = debug.getupvalues(LocalPlanters.LoadPlanter)[4]
                local tttttt = nil
                for k, v in PlanterTable do
                    if v.PotModel and v.IsMine and string.find(v.PotModel.Name, name) then 
                        tttttt = v
                    end
                end
                return tttttt
            end
            
            local fullnectardata = NectarTypes.GetTypes()
            
            function fetchNectarsData()
            
                local ndata = {
                    Refreshing = "none",
                    Invigorating = "none",
                    Comforting = "none",
                    Motivating = "none",
                    Satisfying = "none"
                }

                    for i, v in ScreenGui:GetChildren() do
                        if v.Name == "TileGrid" then
                            for p, l in v:GetChildren() do
                                for k, e in fullnectardata do
                                    if l:FindFirstChild("BG") then
                                        if l:FindFirstChild("BG"):FindFirstChild("Icon") then
                                            if l:FindFirstChild("BG"):FindFirstChild("Icon").ImageColor3 == e.Color then
                                                local Xsize = l:FindFirstChild("BG").Bar.AbsoluteSize.X
                                                local Ysize = l:FindFirstChild("BG").Bar.AbsoluteSize.Y
                                                local percentage = (Ysize / Xsize) * 100
                                                ndata[k] = percentage
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
            
                return ndata
            end
            
            function isBlacklisted(nectartype, blacklist)
                local bl = false
                for i, v in blacklist do
                    if v == nectartype then
                        bl = true
                    end
                end
                for i, v in SakataWare.Planters.BlacklistedNectars do
                    if v == nectartype then
                        bl = true
                    end
                end
                return bl
            end
            
            function calculateLeastNectar(blacklist)
                local leastNectar = nil
                local tempLeastValue = 999
            
                local nectarData = fetchNectarsData()
                for i, v in nectarData do
                    if not isBlacklisted(i, blacklist) then
                        if v == "none" or v == nil then
                            leastNectar = i
                            tempLeastValue = 0
                        else
                            if v <= tempLeastValue then
                                tempLeastValue = v
                                leastNectar = i
                            end
                        end
                    end
                end
                return leastNectar
            end

            function GetItemListWithValue()
                local StatCache = ClientStatCache.Get()
                return StatCache.Eggs
            end
            
            function fetchBestMatch(nectartype, field)
                local bestPlanter = nil
                local bestNectarMult = 0
                local bestFieldGrowthRate = 0
                for i, v in fullPlanterData do
                    if GetItemListWithValue()[i .. "Planter"] then
                        if GetItemListWithValue()[i .. "Planter"] >= 1 and not table.find(SakataWare.Planters.BlacklistedPlanters, i) then
                            if v.GrowthFields[field] ~= nil then
                                if v.GrowthFields[field] > bestFieldGrowthRate then
                                    bestFieldGrowthRate = v.GrowthFields[field]
                                    bestPlanter = i
                                end
                            end
                        end
                    end
                end
                for i, v in fullPlanterData do
                    if GetItemListWithValue()[i .. "Planter"] then
                        if GetItemListWithValue()[i .. "Planter"] >= 1 then
                            if v.NectarTypes[nectartype] ~= nil then
                                if v.NectarTypes[nectartype] > bestNectarMult then
                                    local totalNectarFieldGrowthMult = 0
                                    if v["GrowthFields"][field] ~= nil then
                                        totalNectarFieldGrowthMult = totalNectarFieldGrowthMult + (v["GrowthFields"][field])
                                    end
                                    bestNectarMult = (v.NectarTypes[nectartype] + totalNectarFieldGrowthMult)
                                    bestPlanter = i
                                end
                            end
                        end
                    end
                end
                return bestPlanter
            end
            
            function getPlanterLocation(plnt)
                local resultingField = "None"
                local lowestMag = math.huge
                for i, v in workspace.FlowerZones:GetChildren() do
                    if (v.Position - plnt.Position).magnitude < lowestMag then
                        lowestMag = (v.Position - plnt.Position).magnitude
                        resultingField = v.Name
                    end
                end
                return resultingField
            end
            
            function isFieldOccupied(field)
                local isOccupied = false
                local PlanterTable = debug.getupvalues(LocalPlanters.LoadPlanter)[4]
            
                for k, v in PlanterTable do
                    if v.PotModel and v.PotModel.Parent and v.PotModel.PrimaryPart then
                        if getPlanterLocation(v.PotModel.PrimaryPart) == field then
                            isOccupied = true
                        end
                    end
                end
                return isOccupied
            end
            
            function fetchAllPlanters()
                local p = {}
                local PlanterTable = debug.getupvalues(LocalPlanters.LoadPlanter)[4]
            
                for k, v in PlanterTable do
                    if v.PotModel and v.PotModel.Parent and v.IsMine == true then
                        p[k] = v
                    end
                end
                return p
            end
            
            function isNectarPending(nectartype)
                local planterz = fetchAllPlanters()
                local isPending = false
                for i, v in planterz do
                    local location = getPlanterLocation(v.PotModel.PrimaryPart)
                    if location then
                        local conftype = getNectarFromField(location)
                        if conftype then
                            if conftype == nectartype then
                                isPending = true
                            end
                        end
                    end
                end
                return isPending
            end
            
            function fetchBestFieldWithNectar(nectar)
                local bestField = "None"
                local nectarFields = nectarData[nectar]
                local fieldPlaceholderValue = ""
            
                repeat
                    task.wait(0.01)
                    local randomField = nectarFields[math.random(1, #nectarFields)]
                    if randomField then
                        fieldPlaceholderValue = randomField
                    end
                until not isFieldOccupied(fieldPlaceholderValue)
            
                bestField = fieldPlaceholderValue
            
                return bestField
            end
            
            function checkIfPlanterExists(pNum)
                local exists = false
                local stuffs = fetchAllPlanters()
                if stuffs ~= {} then
                    for i, v in stuffs do
                        if v["ActorID"] == pNum then
                            exists = true
                        end
                    end
                end
                return exists
            end
            
            function collectSpecificPlanter(prt, id)
                internalFlags.plantingPlanter = true
                local Thread, MoveFlags = Goto(prt.Position)
                repeat task.wait() until Thread == nil or MoveFlags.Finished
                ReplicatedStorage.Events.PlanterModelCollect:FireServer(id)
            end
            
            function RequestCollectPlanter(planter)
                if planter.PotModel and planter.PotModel.Parent and planter.ActorID then
                    repeat
                        task.wait(0.7)
                        collectSpecificPlanter(planter.PotModel.PrimaryPart, planter.ActorID)
                    until not checkIfPlanterExists(planter.ActorID)
                end
            end
            
            function RequestCollectPlanters(planterTable)
                task.spawn(function()
                    local plantersToCollect = {}
                    if planterTable then
                        for i, v in planterTable do
                            if v["GrowthPercent"] ~= nil then
                                if getgenv().SakataWare.Planters.HarvestAt then
                                    if v["GrowthPercent"] >= (getgenv().SakataWare.Planters.HarvestAt / 100) then
                                        table.insert(plantersToCollect, {
                                            ["PM"] = v["PotModel"].PrimaryPart,
                                            ["AID"] = v["ActorID"]
                                        })
                                    end
                                else
                                    if v["GrowthPercent"] >= (75 / 100) then
                                        table.insert(plantersToCollect, {
                                            ["PM"] = v["PotModel"].PrimaryPart,
                                            ["AID"] = v["ActorID"]
                                        })
                                    end
                                end
                            end
                        end
                    end
                    if plantersToCollect ~= {} then
                        for i, v in plantersToCollect do
                            repeat
                                task.wait(0.7)
                                collectSpecificPlanter(v["PM"], v["AID"])
                            until checkIfPlanterExists(v["AID"]) == false
                        end
                    end
                end)
            end
            
            function PlantPlanter(name, field)
                local Alive, Character = isAlive()
                if field and name then
                    local specField = workspace.FlowerZones:FindFirstChild(field)
                    if specField ~= nil then
                        internalFlags.plantingPlanter = true
                        local attempts = 0
                        local Thread, MoveFlags = Goto(specField.Position)
                        repeat task.wait() until Thread == nil or MoveFlags.Finished
                        repeat
                            task.wait(0.1)
                            if name == "The Planter Of Plenty" then
                                PlayerActivesCommands:FireServer({["Name"] = name})
                            else
                                PlayerActivesCommands:FireServer({["Name"] = name .. " Planter"})
                            end
                            attempts+=1
                        until GetPlanterData(name) ~= nil or attempts == 15
                        internalFlags.plantingPlanter = false
                    end
                end
            end
            
            function getNectarFromField(field)
                local foundnectar = nil
                for i, v in nectarData do
                    for k, p in v do
                        if p == field then
                            foundnectar = i
                        end
                    end
                end
                return foundnectar
            end
            
            function fetchNectarBlacklist()
                local nblacklist = {}
                for i, v in nectarData do
                    if isNectarPending(i) == true then
                        table.insert(nblacklist, i)
                    end
                end
                return nblacklist
            end

            function gethiveballoon()
                for _,balloon in workspace.Balloons.HiveBalloons:GetChildren() do
                    if balloon:FindFirstChild("BalloonRoot") then
                        if balloon.BalloonRoot.CFrame.p.X == LocalPlayer.SpawnPos.Value.p.X then
                            return true
                        end
                    end
                end
                return false
            end
            
            function getBuffTime(buffName, convertToHMS)
                local buff = BuffTileModule.GetBuffTile(buffName)
                if not buff or not buff.TimerDur or not buff.TimerStart then 
                    return 0 
                end
            
                local toReturn = buff.TimerDur - (math.floor(ServerTime()) - buff.TimerStart)
                if convertToHMS then 
                    toReturn = timeToString(toReturn) 
                end
                
                return toReturn
            end
            
            function getBuffStack(buffName)
                local buff = BuffTileModule.GetBuffTile(buffName)
            
                return (buff and tostring(buff.Combo)) or 0
            end

            function shouldIConvert(converting)
                print(`BAG = {getBagPercentage()}%`)
            
                if converting and getBagPercentage() > 0 or getBagPercentage() >= SakataWare.AutoFarm.ConvertAt then -- Check if the bag is full or if the user wants to convert manually
                    -- if SakataWare.AutoFarm.instantConv then
                        -- instaConvFunc()
                        -- task.wait(1.5)
                        -- return shouldIConvert()
                    -- end
                    return true
                else
                    if SakataWare.AutoFarm.ConvBalloon and gethiveballoon() then
                        if SakataWare.AutoFarm.ConvBalloonAt == 0 and converting then
                            return true
                        elseif SakataWare.AutoFarm.ConvBalloonAt ~= 0 and (getBuffTime("Balloon Blessing"))/60 <= SakataWare.AutoFarm.ConvBalloonAt then
                            return true
                        else
                            return false
                        end
                    else
                        return false
                    end
                end
            end
            
            internalFlags.lastFullBag = 0

            function getBagPercentage()
                local pollencount = LocalPlayer.CoreStats:FindFirstChild("Pollen") and LocalPlayer.CoreStats.Pollen.Value or 0
                local maxpollen = LocalPlayer.CoreStats:FindFirstChild("Capacity") and LocalPlayer.CoreStats.Capacity.Value or 0
            
                local percentage = (pollencount / maxpollen * 100) or 0
            
                if internalFlags.lastFullBag == 0 and percentage >= SakataWare.AutoFarm.ConvertAt then
                    internalFlags.lastFullBag = tick()
                elseif not (percentage >= SakataWare.AutoFarm.ConvertAt) then
                    internalFlags.lastFullBag = 0
                end
            
                return percentage
            end

            function convertHoney()
                local ConvFlags = {Finished = false}

                local ConvThread = task.spawn(function()
                    local hivePos = (LocalPlayer.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 9)).p
                    local Alive, Character = isAlive()

                    while shouldIConvert(true) and Alive do
                        -- if macrov2.toggles.AutoHoneyM then requestAccessoryEquip("Honey Mask") end
                        internalFlags.Conv = true
                        if (Character.HumanoidRootPart.Position - hivePos).magnitude <= 10 then
                            WalkTo(hivePos)
                        else
                            local Thread, MoveFlags = Goto(hivePos)
                            repeat task.wait() until Thread == nil or MoveFlags.Finished
                        end
                        task.wait(3)
                        local hiveInfo
                        task.spawn(function()
                            setthreadidentity(2)
                            hiveInfo = ScreenGui.ActivateButton.TextBox.Text
                            setthreadidentity(7)
                        end)
                        if hiveInfo == "Make Honey" then
                            task.spawn(function()
                                setthreadidentity(2)
                                ActivatablesHives.ButtonEffect(LocalPlayer, playerHive.Platform.Value)
                                setthreadidentity(7)
                            end)
                            task.wait(3)
                        elseif hiveInfo:find("To Make Honey") then
                            break
                        end
                        task.wait(1)
                    end
                    task.wait(5)
                    internalFlags.convertingHoney = false
                    -- if defaultMask == nil or defaultMask == true then
                        -- if macrov2.toggles.AutoHoneyM then requestAccessoryEquip(macrov2.vars.defaultmask) end
                    -- end
                    -- print("converted")
                    internalFlags.lastConvertAtHive = tick()
                    ConvFlags.Finished = true
                end)

                return ConvThread, ConvFlags
            end

            local Balloons = {}
            local balloonsTable = {}

            task.spawn(function() 
                repeat task.wait() until workspace:FindFirstChild("Balloons") and workspace.Balloons:FindFirstChild("FieldBalloons")
                Balloons = workspace.Balloons.FieldBalloons
                workspace.Balloons.FieldBalloons.ChildAdded:Connect(function(balloon) 
                    task.wait()
                    if balloon:FindFirstChild("PlayerName") and balloon.PlayerName.Value == LocalPlayer.Name then
                        local balloonId = balloon.Name:gsub("Balloon", "")
                        balloonsTable[tonumber(balloonId)] = balloon
                    end
                end)
                workspace.Balloons.FieldBalloons.ChildRemoved:Connect(function(balloon)
                    if balloon:FindFirstChild("PlayerName") and balloon.PlayerName.Value == LocalPlayer.Name then
                        local balloonId = balloon.Name:gsub("Balloon", "")
                        if balloonId then
                            balloonsTable[tonumber(balloonId)] = nil
                        end
                    end
                end)
            end)

            function getPartsFromRay(ray, whitelist)
                if typeof(whitelist) == "Instance" then whitelist = whitelist:GetDescendants() 
                elseif typeof(whitelist) == "nil"  then whitelist = {} end
                
                local Parts = {}
                local LastPart
                
                repeat
                    LastPart = workspace:FindPartOnRayWithIgnoreList(ray, Parts)
                    table.insert(Parts, LastPart)
                until LastPart == nil
            
                for i,v in Parts do
                    if not table.find(whitelist, v) then table.remove(Parts, i) continue end
                end
            
                return Parts
            end

            function getBestFieldBalloon()
                local Alive, Character = isAlive()
                if not Alive then return end
                local humanoidRootPart = Character.HumanoidRootPart
            
                local bestFieldBalloon = {instance = nil, mostBalloonsInRow = -1}
            
                for i, v in balloonsTable do
                    if not v:FindFirstChild("BalloonBody") then continue end
                    local playerPos = humanoidRootPart.Position + Vector3.new(0,16,0)
                    local balloonPos = v.BalloonBody.Position
            
                    if not isFieldSame(playerPos - Vector3.new(0,16,0), balloonPos - Vector3.new(0,16,0)) then continue end
            
                    local __, res = pcall(function()  
                        if v.BalloonBody.GuiAttach.Gui.Bar.BackgroundTransparency ~= 1 then return true end
                    end)
            
                    local ray = Ray.new(playerPos, (Vector3.new(balloonPos.X, playerPos.Y, balloonPos.Z) - playerPos))
            
                    local intersection = getPartsFromRay(ray, Balloons)
            
                    if intersection and #intersection >= bestFieldBalloon.mostBalloonsInRow then
                        bestFieldBalloon.mostBalloonsInRow = #intersection
                        bestFieldBalloon.instance = v
                    end
                end
            
                return bestFieldBalloon.instance
            end

            function AutoFarm()
                local Alive, Character = isAlive()
                if not findField(Character.HumanoidRootPart.Position) and not internalFlags.plantingPlanter or findField(Character.HumanoidRootPart.Position) and findField(Character.HumanoidRootPart.Position).Name ~= getgenv().SakataWare.AutoFarm.SelectedField and not internalFlags.plantingPlanter then
                    local Thread, MoveFlags = Goto(workspace.FlowerZones[getgenv().SakataWare.AutoFarm.SelectedField].Position)
                    repeat task.wait() until MoveFlags.Finished
                end
                if findField(Character.HumanoidRootPart.Position) and findField(Character.HumanoidRootPart.Position).Name == getgenv().SakataWare.AutoFarm.SelectedField and not internalFlags.plantingPlanter then
                    placeSprinklers(findField(Character.HumanoidRootPart.Position).Position)
                end

                if shouldIConvert() and not internalFlags.plantingPlanter then
                    local Thread, ConvFlags = convertHoney()
                    repeat task.wait() until Thread == nil or ConvFlags.Finished
                end

                if SakataWare.Planters.toggle then
                    internalFlags.plantingPlanter = true
                    RequestCollectPlanters(fetchAllPlanters())
                    if #fetchAllPlanters() < 3 then
                        local LeastNectar = calculateLeastNectar(fetchNectarBlacklist())
                        local Field = fetchBestFieldWithNectar(LeastNectar)
                        local Planter = fetchBestMatch(LeastNectar, Field)
                        if LeastNectar and Field and Planter then
                            PlantPlanter(Planter, Field)
                        end
                    end
                    internalFlags.plantingPlanter = false
                end

                if getgenv().SakataWare.AutoFarm.FarmDupedTokens and not internalFlags.plantingPlanter then
                    farmDupedTokens()
                end

                local BubbleFarmed

                if getgenv().SakataWare.AutoFarm.FarmBubbles and not internalFlags.plantingPlanter then
                    BubbleFarmed = farmBubble()
                end

                local Farmed = farmTokens()

                if not Farmed and tick() - lastRandomFlower >= 1.5 and not internalFlags.plantingPlanter then
                    local randomFlower = getRandomFlower(workspace.FlowerZones[getgenv().SakataWare.AutoFarm.SelectedField])
                    if randomFlower then
                        lastRandomFlower = tick()
                        WalkTo(randomFlower.Position)
                    end
                end
            end

            task.spawn(function()
                while task.wait() do
                    if getgenv().SakataWare.AutoFarm.toggle then
                        if SakataWare.AutoFarm.FaceBalloon then
                            local bestBalloon = getBestFieldBalloon()
                            if bestBalloon and bestBalloon:FindFirstChild("BalloonBody") then
                                lookAt(bestBalloon.BalloonBody.Position)
                            else
                                destroyBodyGyro()
                            end
                        end
        
                        AutoFarm()
                    end
                end
            end)

            -- UI
            do
                local MainTab = library:AddTab("Auto Farm")
                local MovementTab = library:AddTab("Movements")
                local PlanterTab = library:AddTab("Planters")

                local MainColumn1 = MainTab:AddColumn();
                local MovementColumn1 = MovementTab:AddColumn();
                local PlanterColumn1 = PlanterTab:AddColumn();

                local AutoFarmSection = MainColumn1:AddSection("Auto Farm")
                local ConvertSection = MainColumn1:AddSection("Convert Settings")
                local MoveMethodSection = MovementColumn1:AddSection("Movements")
                local PlanterSection = PlanterColumn1:AddSection("Planter")


                local ConvertSlider = ConvertSection:AddSlider({
                    text = "Convert At",
                    min  = 1,
                    max = 100,
                    value = 100,
                    callback = function(value)
                        getgenv().SakataWare.AutoFarm.ConvertAt = value
                    end
                })

                local ConvertBalloon = ConvertSection:AddToggle({
                    default = false,
                    text = "Convert Balloon",
                    flag = "ConvBalloons",
                    callback = function(bool)
                        getgenv().SakataWare.AutoFarm.ConvBalloon = bool
                    end
                })

                local ConvertBalloonAt = ConvertSection:AddSlider({
                    text = "Convert Balloon At",
                    flag = "ConvBalloonsAt",
                    min = 0,
                    max = 60,
                    value = 30,
                    callback = function(value)
                        getgenv().SakataWare.AutoFarm.ConvBalloonAt = value
                    end
                })

                local TogglePlanter = PlanterSection:AddToggle({
                    default = false,
                    text = "Auto Planters",
                    flag = "Auto Planters",
                    callback = function(bool)
                        getgenv().SakataWare.Planters.toggle = bool
                        print(bool, 69)
                    end
                })

                local blacklistedNectarsDropdown 
                blacklistedNectarsDropdown = PlanterSection:AddList({
                    text = "Blacklisted Nectars List",
                    flag = "BlacklistedNectars",
                    max = 4,
                    values = {},
                    value = "",
                    callback = function(selectedOption)
                        if selectedOption == nil or selectedOption == "" then return end
                        table.remove(getgenv().SakataWare.Planters.BlacklistedNectars, table.find(getgenv().SakataWare.Planters.BlacklistedNectars, selectedOption))
                        blacklistedNectarsDropdown:RemoveValue(selectedOption);
                    end
                });

                PlanterSection:AddList({
                    text = "Blacklist Nectar",
                    values = {
                        "Comforting Nectar",
                        "Satisfying Nectar",
                        "Invigorating Nectar",
                        "Refreshing Nectar",
                        "Motivating Nectar",
                    },
                    skipflag = true,
                    value = "",
                    function(value) 
                        if not table.find(getgenv().SakataWare.Planters.BlacklistedNectars, value) then
                            table.insert(getgenv().SakataWare.Planters.BlacklistedNectars, value)
                            blacklistedNectarsDropdown:AddValue(value)
                        end
                    end
                })

                PlanterSection:AddSlider({
                    text = "Harvest At", 
                    min = 1,
                    max = 100,
                    value = 20,
                    flag = "planterHarvestPercent",
                    callback = function(value)
                        SakataWare.Planters.HarvestAt = value
                    end
                })
                
                local PlanterColumn2 = PlanterTab:AddColumn()
                local BlacklistSectionPlanter = PlanterColumn2:AddSection("Blacklist")

                for i,v in plantersTable do
                    BlacklistSectionPlanter:AddToggle({
                        text = `{v.displayName}`,
                        default = false,
                        flag = i.."Blacklist",
                        callback = function(bool)
                            if bool then
                                table.insert(SakataWare.Planters.BlacklistedPlanters, i)
                            else
                                table.remove(SakataWare.Planters.BlacklistedPlanters, table.find(SakataWare.Planters.BlacklistedPlanters, i))
                            end
                        end
                    })
                end

                BlacklistSectionPlanter:AddDivider("Nectars")

                for i,v in nectarData do
                    BlacklistSectionPlanter:AddToggle({
                        text = `{i}`,
                        default = false,
                        flag = i.."Blacklist",
                        callback = function(bool)
                            if bool then
                                table.insert(SakataWare.Planters.BlacklistedPlanters, i)
                            else
                                table.remove(SakataWare.Planters.BlacklistedPlanters, table.find(SakataWare.Planters.BlacklistedPlanters, i))
                            end
                        end
                    })
                end

                local AutoFarmToggle = AutoFarmSection:AddToggle({
                    default = false,
                    text = "Toggle",
                    flag = "ToggleAutoFarm",
                    callback = function(bool)
                        getgenv().SakataWare.AutoFarm.toggle = bool
                    end
                })

                local AutoDigToggle = AutoFarmSection:AddToggle({
                    default = false,
                    text = "Auto Dig",
                    flag = "AutoDig",
                    callback = function(bool)
                        getgenv().SakataWare.AutoFarm.autodig = bool
                    end
                })
                
                local FieldList = AutoFarmSection:AddList({
                    text = "Select Field",
                    max = 4,
                    flag = "SelectedField",
                    values = Fields,
                    value = "Dandelion Field",
                    callback = function(selected)
                        getgenv().SakataWare.AutoFarm.SelectedField = selected
                    end
                })

                local FarmBubbles = AutoFarmSection:AddToggle({
                    default = false,
                    text = "Farm Bubbles",
                    flag = "FarmBubbles",
                    callback = function(bool)
                        getgenv().SakataWare.AutoFarm.FarmBubbles = bool
                    end
                })

                local FarmDupedTokens = AutoFarmSection:AddToggle({
                    default = false,
                    text = "Farm Duped Tokens",
                    flag = "FarmDuped",
                    callback = function(bool)
                        getgenv().SakataWare.AutoFarm.FarmDupedTokens = bool
                    end
                })

                local FaceBalloon = AutoFarmSection:AddToggle({
                    default = false,
                    text = "Face Balloon",
                    flag = "FaceBalls",
                    callback = function(bool)
                        getgenv().SakataWare.AutoFarm.FaceBalloon = bool
                    end
                })

                local MoveMethodList = MoveMethodSection:AddList({
                    text = "Movement Method",
                    max = 4,
                    flag = "MovementMethod",
                    values = {"Lerp", "TweenService"},
                    value = "Lerp",
                    callback = function(selected)
                        getgenv().SakataWare.Movements.MoveMethod = selected
                    end
                })

                local LerpSteps = MoveMethodSection:AddSlider({
                    text = "Lerp Steps",
                    min = 10,
                    max = 50,
                    value = 15,
                    callback = function(value)
                        getgenv().SakataWare.Movements.LerpSteps = value
                    end
                })

                local LerpDelay = MoveMethodSection:AddSlider({
                    text = "Lerp Delay",
                    min = 50,
                    max = 1000,
                    value = 200,
                    callback = function(value)
                        getgenv().SakataWare.Movements.LerpDelay = value
                    end
                })

                local TweenSpeed = MoveMethodSection:AddSlider({
                    text = "TweenService Speed",
                    min = 50,
                    max = 300,
                    value = 125,
                    callback = function(value)
                        getgenv().SakataWare.Movements.TweenServiceSpeed = value
                    end
                })

                local Thread
                local MoveFlags

                local MoveTest = AutoFarmSection:AddToggle({
                    default = false,
                    text = "Move Test",
                    skipflag = true,
                    callback = function(bool)
                        if bool then
                            Thread, MoveFlags = Goto(workspace.FlowerZones["Mountain Top Field"].Position)
                        else
                            if Thread then
                                MoveFlags.Finished = true
                                task.cancel(Thread)
                            end
                        end
                    end
                })
            end
        end
    end
else
    game.Players.LocalPlayer:Kick("SakataWare | Universal Soon")
    do
        getgenv().SakataWare = {
            AimbotToggle = false,
            AimbotLocksOn = "HumanoidRootPart",
            AimbotHitChance = 100,
            AimbotVisibleCheck = false,
            AimbotTeamCheck = false,
            ESP = {
                EspToggle = false,
                Skeleton = false,
                Chams = false,
                Nametags = false,
                Team = false
            },
            Movement = {
                SpeedToggle = false,
                FlyToggle = false,
                SpeedMethod = "CFrame", --Walk Speed, CFrame, Velocity, Teleport
                FlyMethod = "Velocity", --Velocity, CFrame, Teleport
                Speed = 16,
                FlySpeed = 16,
                FlyBypass1 = false,
                FlyBypass2 = false,
                FlyBypass1Max = 5,
            }
        }

        local scriptFlags = {
            AimbotPart = "None"
        }

        local RayParams = RaycastParams.new()
        RayParams.FilterType = Enum.RaycastFilterType.Whitelist
        RayParams.IgnoreWater = true

        local CurrentTick = tick()
        getgenv().SakataWareLoaded = CurrentTick

        local Threads = {}
        if getgenv().SakataWareLoaded~=CurrentTick then
            for i,v in Threads do
                v:Cancel()
            end
        end

        local BodyParts = {
            "Head",
            "UpperTorso",
            "LowerTorso",
            "Torso",
            "Left Arm",
            "LeftUpperArm",
            "LeftLowerArm",
            "LeftHand",
            "Right Arm",
            "RightUpperArm",
            "RightLowerArm",
            "RightHand",
            "Left Leg",
            "LeftUpperLeg",
            "LeftLowerLeg",
            "LeftFoot",
            "Right Leg",
            "RightUpperLeg",
            "RightLowerLeg",
            "RightFoot"
        }

        local MainTab = library:AddTab("Main")
        local MainColumn1 = MainTab:AddColumn();
        local AimbotSection = MainColumn1:AddSection("Aimbot")
        local ESPSection = MainColumn1:AddSection("ESP")

        local AimbotToggle = AimbotSection:AddToggle({
            default = false,
            text = "Toggle",
            flag = "ToggleAimlock",
            callback = function(bool)
                getgenv().SakataWare.AimbotToggle = bool
            end
        })

        AimbotSection:AddDivider("Settings");

        local AimbotLocks = AimbotSection:AddList({
            text = "Aimbot Locks on",
            max = 4,
            flag = "AimbotLocksOn",
            values = BodyParts,
            value = "HumanoidRootPart",
            callback = function(value)
                getgenv().SakataWare.AimbotLocksOn = value
            end
        })
        
        AimbotSection:AddSlider({text = "Aimbot Hit Chance", min = 1, max = 100, value = 100, callback = function(value)
            getgenv().SakataWare.AimbotHitChance = value
        end});

        local TeamCheck = AimbotSection:AddToggle({
            default = false,
            text = "Team Check",
            flag = "Teamcheck",
            callback = function(bool)
                getgenv().SakataWare.AimbotTeamCheck = bool
            end
        })

        local MovementTab = library:AddTab("Movements")
        local MovementColumn = MovementTab:AddColumn();
        local SpeedSection = MovementColumn:AddSection("Speed")

        local FlySection = MovementColumn:AddSection("Fly")
    end
end

local SettingsTab = library:AddTab("Settings"); 
local SettingsColumn = SettingsTab:AddColumn(); 
local SettingsColumn2 = SettingsTab:AddColumn(); 
local SettingSection = SettingsColumn:AddSection("Menu"); 
local ConfigSection = SettingsColumn2:AddSection("Configs");
local Warning = library:AddWarning({type = "confirm"});

SettingSection:AddBind({text = "Open / Close", flag = "UI Toggle", nomouse = true, key = "RShift", callback = function()
    library:Close();
end});

SettingSection:AddButton({text = "Unload UI", callback = function()
    local r, g, b = library.round(library.flags["Menu Accent Color"]);
    Warning.text = "<font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. 'Are you sure you wana unload the UI?' .. "</font>";
    if Warning:Show() then
    library:Unload()
    end
end});

SettingSection:AddColor({text = "Accent Color", flag = "Menu Accent Color", color = Color3.fromRGB(88,133,198), callback = function(color)
    if library.currentTab then
        library.currentTab.button.TextColor3 = color;
    end
    for i,v in library.theme do
        v[(v.ClassName == "TextLabel" and "TextColor3") or (v.ClassName == "ImageLabel" and "ImageColor3") or "BackgroundColor3"] = color;
    end
end});

local backgroundlist = {
    ["Floral"] = 5553946656,
    ["Flowers"] = 6071575925,
    ["Circles"] = 6071579801,
    ["Hearts"] = 6073763717,
    ["Polka dots"] = 6214418014,
    ["Mountains"] = 6214412460,
    ["Zigzag"] = 6214416834,
    ["Zigzag 2"] = 6214375242,
    ["Tartan"] = 6214404863,
    ["Roses"] = 6214374619,
    ["Hexagons"] = 6214320051,
    ["Leopard print"] = 6214318622
};

local back = SettingSection:AddList({text = "Background", max = 4, flag = "background", values = {"Floral", "Flowers", "Circles", "Hearts", "Polka dots", "Mountains", "Zigzag", "Zigzag 2", "Tartan", "Roses", "Hexagons", "Leopard print"}, value = "Floral", callback = function(v)
    if library.main then
        library.main.Image = backgroundlist[v];
    end
end});

back:AddColor({flag = "backgroundcolor", color = Color3.new(), callback = function(color)
    if library.main then
        library.main.ImageColor3 = Color or Color3.fromRGB(37,38,38)
    end
end, trans = 1, calltrans = function(trans)
    if library.main then
        library.main.ImageTransparency = 1 - trans;
    end
end});

SettingSection:AddSlider({text = "Tile Size", min = 50, max = 500, value = 50, callback = function(size)
    if library.main then
        library.main.TileSize = UDim2.new(0, size, 0, size);
    end
end});

SettingSection:AddButton({text = "Discord", callback = function()
    local r, g, b = library.round(library.flags["Menu Accent Color"]);
    Warning.text = "<font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. 'Discord invite copied to clip board!' .. "</font>";
    if Warning:Show() then
    setclipboard('')
    end
end});

local configFiles = {}

ConfigSection:AddBox({text = "Config Name", skipflag = true});

ConfigSection:AddList({text = "Configs", skipflag = true, value = "", flag = "Config List", values = library:GetConfigs()});

ConfigSection:AddButton({text = "Create", callback = function()
    library:GetConfigs();
    writefile(library.foldername .. "/" .. library.flags["Config Name"] .. library.fileext, "{}");
    library.options["Config List"]:AddValue(library.flags["Config Name"]);
end});

ConfigSection:AddButton({text = "Save", callback = function()
    local r, g, b = library.round(library.flags["Menu Accent Color"]);
    Warning.text = "Are you sure you want to save the current settings to config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?";
    if Warning:Show() then
        library:SaveConfig(library.flags["Config List"]);
    end
end});

ConfigSection:AddButton({text = "Load", callback = function()
    local r, g, b = library.round(library.flags["Menu Accent Color"]);
    Warning.text = "Are you sure you want to load config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?";
    if Warning:Show() then
        library:LoadConfig(library.flags["Config List"]);
    end
end});

ConfigSection:AddButton({text = "Delete", callback = function()
    local r, g, b = library.round(library.flags["Menu Accent Color"]);
    Warning.text = "Are you sure you want to delete config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?";
    if Warning:Show() then
        local config = library.flags["Config List"];
        if table.find(library:GetConfigs(), config) and isfile(library.foldername .. "/" .. config .. library.fileext) then
            library.options["Config List"]:RemoveValue(config);
            delfile(library.foldername .. "/" .. config .. library.fileext);
        end
    end
end});

local CurrentAutoLoad = ConfigSection:AddLabel(`Current Autoload {AutoLoad[tostring(game.PlaceId)] or "None"}`)

ConfigSection:AddButton({text = "Set as Autoload", callback = function()
    if not AutoLoad then
        AutoLoad = {}
    end
    AutoLoad[tostring(game.PlaceId)] = library.flags["Config List"]
    writefile("SakataWare/autoload.json", cloneref(game:GetService("HttpService")):JSONEncode(AutoLoad))
    CurrentAutoLoad:Update(`Current Autoload {AutoLoad[tostring(game.PlaceId)]}`)
end});

ConfigSection:AddButton({text = "Remove Autoload", callback = function()
    AutoLoad[tostring(game.PlaceId)] = nil
    writefile("SakataWare/autoload.json", cloneref(game:GetService("HttpService")):JSONEncode(AutoLoad))
    CurrentAutoLoad:Update(`Current Autoload None`)
end});

if AutoLoad[tostring(game.PlaceId)] then
    library:LoadConfig(AutoLoad[tostring(game.PlaceId)])
end

library:selectTab(library.tabs[1]);

local configShit
configShit = function(config, name)
    for i,v in config do
        if typeof(v) == "table" then
            configShit(v, i)
            continue
        end
        getgenv().SakataWare[i] = v
    end
end

return configShit