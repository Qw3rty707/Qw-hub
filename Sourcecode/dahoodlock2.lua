-- universal da hood lock no lock keybind
-- open source which means you have rights to modify it and use it for your script
-- made by Qw#1549
-- this one uses __index instead of __namecall, and this one you dont need aa lock on keybind 
repeat wait()until game:IsLoaded()
        
local oldnamecalldhac

oldnamecalldhac = hookmetamethod(game,"__namecall",newcclosure(function(Self,...)
    Args = {...}
            if tostring(Args[1]) == "TeleportDetect" then
                                return
                             elseif tostring(Args[1]) == "CHECKER_1" then
                                return
                             elseif tostring(Args[1]) == "CHECKER" then
                                return
                             elseif tostring(Args[1]) == "GUI_CHECK" then
                                return
                              elseif tostring(Args[1]) == "OneMoreTime" then
                                return
                           elseif tostring(Args[1]) == "checkingSPEED" then
                                return
                             elseif tostring(Args[1]) == "BANREMOTE" then
                                return
                             elseif tostring(Args[1])== "PERMAIDBAN" then
                                return
                            elseif tostring(Args[1]) == "KICKREMOTE" then
                                return
                             elseif tostring(Args[1]) == "BR_KICKPC" then
                                return
                             elseif tostring(Args[1]) == "BR_KICKMOBILE" then
                                return
                            end
    return oldnamecalldhac(Self,...)
end))
local Qwownsyou = {
   Enabled = true,
   Part = "Head", -- Head,HumanoidRootPart
   Prediction = 0.12,
   FOV = 100
}

local getService = game.GetService;
local players = getService(game, "Players");

local vector2New, vector3New, udim2New, cframeNew = Vector2.new, Vector3.new, UDim2.new, CFrame.new;

local camera = workspace.CurrentCamera;
local findFirstChild = game.FindFirstChild
local localPlayer = players.LocalPlayer
local mouse = localPlayer:GetMouse();

 function closestPlayer(Value)
   local closesttarget  
    local fov = Value      

 for _,v in pairs(players.GetPlayers(players)) do 
     if v and v.Character and v ~= localPlayer and findFirstChild(v.Character, "Humanoid") and v.Character.Humanoid.Health ~= 0  then 
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


local oldindex 

oldindex = hookmetamethod(game,"__index",newcclosure(function(self,Key)
    if Qwownsyou.Enabled and self:IsA("Mouse") and Key == "Hit"  then 
        local Closestplr = closestPlayer(Qwownsyou.FOV)
        if  Closestplr and Closestplr ~= nil then 

        return cframeNew(Closestplr.Character[Qwownsyou.Part].Position + (Closestplr.Character[Qwownsyou.Part].Velocity *Qwownsyou.Prediction)) -- ig this is like a streamable
     end 
    end 
    return oldindex(self,Key)
    end))
