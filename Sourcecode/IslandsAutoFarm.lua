-- 
local mainloop = game:GetService("RunService").RenderStepped

mainloop:Connect(function()

local tweenService = game:GetService("TweenService")

for i,v in pairs(game:GetService("Workspace").WildernessIsland.Entities:GetChildren()) do 
    
    if v:IsA("Model") and v.Name == "slime" and v:FindFirstChild("HumanoidRootPart") then 
        print(v)
    tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,2,0)}):Play()


local ohString1 = "707156CB-623A-461F-A3D4-CCF015FD54BC"
local ohTable2 = {
	[1] = {
		["crit"] = false,
		["hitUnit"] = v -- workspace.WildernessIsland.Entities.slime
	}
}

game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged["ifmiyEe/EDoykrNuwmlnz"]:FireServer(ohString1, ohTable2)
    end 
  end 
end)
