-- plz dont sell this lock 
-- if you want to configure the prediction its in line 69
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getService = game.GetService;
local players = getService(game, "Players");
local lighting = getService(game, "Lighting");
local runService = getService(game, "RunService");
local guiService = getService(game, "GuiService");
local inputService = getService(game, "UserInputService");
local replicatedStorage = getService(game, "ReplicatedStorage");

-- Localizing 
local workspace, debug = workspace,debug;
local math, string = math, string;
local table, Instance = table, Instance;
local Vector3, Vector2 = Vector3, Vector2;
local Color3, CFrame = Color3, CFrame;
local Enum, type = Enum, type;

local mathFloor, mathCeil, mathMax, mathHuge, mathRandom, mathClamp = math.floor, math.ceil, math.max, math.huge, math.random, math.clamp;
local taskWait, taskSpawn, taskDelay = task.wait, task.spawn;
local vector2New, vector3New, udim2New, cframeNew = Vector2.new, Vector3.new, UDim2.new, CFrame.new;
local colorNew, color3RGB, color3Hex = Color3.new, Color3.fromRGB, Color3.fromHex;
local tableInsert, tableFind = table.insert, table.find;
local instanceNew = Instance.new;

local camera = workspace.CurrentCamera;
local worldToViewportPoint = camera.WorldToViewportPoint;
local findFirstChild, httpGet = game.FindFirstChild, game.HttpGet;
local localPlayer = players.LocalPlayer
local mouse = localPlayer:GetMouse();
local findFirstChildOfClass = game.FindFirstChildOfClass


 function closestPlayer(Value)
   local closesttarget  
    local fov = Value      

 for _,v in pairs(players.GetPlayers(players)) do 
     if v and v.Character and v ~= localPlayer and findFirstChild(v.Character, "Humanoid") and v.Character.Humanoid.Health ~= 0 and findFirstChild(v.Character, "HumanoidRootPart") and findFirstChild(v.Character, "Head") then
         local onscreen,isvisible =  camera.WorldToScreenPoint(camera, v.Character.Head.Position)
     
       if isvisible then 
        local Distance = (vector2New(onscreen.x, onscreen.y)  - vector2New(mouse.x, mouse.y)).Magnitude; 
      if  Distance <= fov then 
          fov = Distance
      closesttarget = v 
      
            end 
        end 
    end 
end 
   return closesttarget
end 

local targetlocked
inputService.InputBegan:Connect(function(keyinput)
      
               if (keyinput.KeyCode == Enum.KeyCode.Q) then
targetlocked = closestPlayer(mathHuge)
print(targetlocked)
        end
 end)

local OldNameCall
OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local Args = {...}
if   getnamecallmethod() == "FireServer" and Args[2] == "UpdateMousePos" then
    Args[3] = targetlocked.Character.Head.Position + (targetlocked.Character.Head.Velocity * 0.12)
    return OldNameCall(unpack(Args))
    end 
    return OldNameCall(...)
end))
