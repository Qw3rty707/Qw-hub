-- i was bored and made this 

local executetime = os.clock()
local findFirstChildOfClass,findFirstChild = game.FindFirstChildOfClass, game.FindFirstChild;
local workspace, debug = workspace,debug;
local Color3, CFrame = Color3, CFrame;
local taskWait, taskSpawn = task.wait, task.spawn;
local vector2New, vector3New, udim2New, cframeNew = Vector2.new, Vector3.new, UDim2.new, CFrame.new;
local getService = game.GetService;
local instanceNew = Instance.new;
local drawingNew = Drawing.new;
local RaycastParams = RaycastParams.new(); 
local color3New = Color3.new;
local mathAbs,maathTan,mathRad,mathClamp,mathFloor = math.abs,  math.tan, math.rad, math.clamp, math.floor;
local tableFind, tableInsert = table.find, table.insert
local getChildren = game.GetChildren;
local getDescendants = game.GetDescendants;
local isA = workspace.IsA;
local raycast = workspace.Raycast;
local workspace = getService(game, "Workspace");
local runService = getService(game, "RunService");
local players = getService(game, "Players");
local coreGui = getService(game, "CoreGui");
local userInputService = getService(game, "UserInputService");
local currentCamera = workspace.CurrentCamera;
local mouse = localPlayer:GetMouse();


local Atlas = loadstring(game:HttpGet("https://siegehub.net/Atlas.lua"))()

local islandslist = {} 
-- plans for boss farm: pathfinding, tween 
for i,v in pairs(workspace.islandUnlockParts:GetChildren()) do 
    table.insert(islandslist, v.Name)
    
 end 
local tab1 = {
    AutoSwing = false,
    PlayerDropdown = "",
    BossSelectiondropdown = "",
    bossAutofarmenabled = false,
    AutoSell = false
    
}

local tab2 = {IslandDropdown = "" } 
local UI = Atlas.new({
    Name = "Qw hub "; -- script name (required)
    ConfigFolder = "Qw hub Ninja Legends"; -- folder name to save configs to, set this to nil if you want to disable configs saving
    Credit = "Made By Qw#1549"; -- text to appear if player presses the "i" button on their UI (optional)
    Color = Color3.fromRGB(195, 0, 255); -- theme color for UI (required)
    Bind = "RightShift"; -- keybind for toggling the UI, must be a valid KeyCode name
    -- Atlas Loader:
 
    FullName = ""; -- works if UseLoader is set to true, can be same as Name argument, shown on loader frame
   
})




local AutoFarmTab = UI:CreatePage("Farming") -- creates a page
local MiscTab = UI:CreatePage("Miscellaneous") -- creates a page

local Autofarmsection1 = AutoFarmTab:CreateSection("---> Main Farm  <---")

local Autofarmsection2 = AutoFarmTab:CreateSection("---> Second Farm <---")

local Miscsection1 = MiscTab:CreateSection("---> Teleportation <---")

local Miscsection2 = MiscTab:CreateSection("---> Buy and unlock <---")


local autoswingtoggle = Autofarmsection1:CreateToggle({ -- IMPORTANT: This function does not return anything, please modify flags directly in order to read or update toggle values. SCROLL TO BOTTOM OF PAGE TO SEE HOW TO MODIFY FLAGS
    Name = "Auto Swing"; -- required: name of element
    Flag = "AUtoSwingToggleFlag"; -- required: unique flag name to use
    Default = false; -- optional: default value for toggle, will be used if config saving is disabled and there is no saved data, will be false if left nil
    Callback = function(boolean)
     tab1.AutoSwing = boolean
     UI:Notify({
  Title = "Qw hub";
  Content = "AutoSwing: " .. tostring(boolean);
})
end;

    -- Scroll to the bottom of the page to read more about the following two:
  
})

local AutoSellaasdwasd = Autofarmsection1:CreateToggle({ -- IMPORTANT: This function does not return anything, please modify flags directly in order to read or update toggle values. SCROLL TO BOTTOM OF PAGE TO SEE HOW TO MODIFY FLAGS
    Name = "Auto sell"; -- required: name of element
    Flag = "AutSellsuniqueflag"; -- required: unique flag name to use
    Default = false; -- optional: default value for toggle, will be used if config saving is disabled and there is no saved data, will be false if left nil
    Callback = function(boolean)
     tab1.AutoSell = boolean
     UI:Notify({
  Title = "Qw hub";
  Content = "Autosell:  " .. tostring(boolean);
})
end;
 SavingDisabled = true;

    -- Scroll to the bottom of the page to read more about the following two:
  
})

local PlayerDropdown = Autofarmsection2:CreateDropdown({
    Name = "Select player"; -- required: name of element
    Callback = function(item) -- required: function to be called an item in the dropdown is activated
  tab1.PlayerDropdown = item 
  
    end;
    Options = {}; -- required: dropdown options
    ItemSelecting = true; -- optional: whether to control item selecting behavior in dropdowns (see showcase video), is false by default
    DefaultItemSelected = "None"; -- optional: default item selected, will not run the callback and does not need to be from options table. This will be ignored if ItemSelecting is not true.
    -- Scroll to the bottom of the page to read more about the following two:
    Warning = "This has a warning"; -- optional: this argument is used in all elements (except for Body) and will indicate text that will appear when the player hovers over the warning icon
    WarningIcon = 12345; -- optional: ImageAssetId for warning icon, will only be used if Warning is not nil, default is yellow warning icon.
})
local selectbossdropdown = Autofarmsection2:CreateDropdown({
    Name = "Select Boss"; -- required: name of element
    Callback = function(item) -- required: function to be called an item in the dropdown is activated
tab1.BossSelectiondropdown = item 
    end;
    Options = {"RobotBoss", "EternalBoss", "AncientMagmaBoss"}; -- required: dropdown options
    ItemSelecting = true; -- optional: whether to control item selecting behavior in dropdowns (see showcase video), is false by default
    DefaultItemSelected = "None"; -- optional: default item selected, will not run the callback and does not need to be from options table. This will be ignored if ItemSelecting is not true.
    -- Scroll to the bottom of the page to read more about the following two:
 
})

local bossAutofarmenableda = Autofarmsection2:CreateToggle({ -- IMPORTANT: This function does not return anything, please modify flags directly in order to read or update toggle values. SCROLL TO BOTTOM OF PAGE TO SEE HOW TO MODIFY FLAGS
    Name = "Boss farm"; -- required: name of element
    Flag = "AutoBossFarmToggleFlaag"; -- required: unique flag name to use
    Default = false; -- optional: default value for toggle, will be used if config saving is disabled and there is no saved data, will be false if left nil
    Callback = function(boolean)
  tab1.bossAutofarmenabled = boolean

end;

    -- Scroll to the bottom of the page to read more about the following two:
    Warning = "Enable AutoSwing first"; -- optional: this argument is used in all elements (except for Body) and will indicate text that will appear when the player hovers over the warning icon
    WarningIcon = 12345; -- optional: ImageAssetId for warning icon, will only be used if Warning is not nil, default is yellow warning icon.
})

local enableautoswingparagraph = Autofarmsection2:CreateParagraph("Enable Autoswing for boss farm") -- creates a paragraph element with "Hello world!" as the text content


local Selectislaanddropdown = Miscsection1:CreateDropdown({
    Name = "Select island"; -- required: name of element
    Callback = function(item) -- required: function to be called an item in the dropdown is activated
tab2.IslandDropdown = item 
    end;
    Options = islandslist; -- required: dropdown options
    ItemSelecting = true; -- optional: whether to control item selecting behavior in dropdowns (see showcase video), is false by default
    DefaultItemSelected = "None"; -- optional: default item selected, will not run the callback and does not need to be from options table. This will be ignored if ItemSelecting is not true.
})

Miscsection1:CreateButton({
    Name = "Teleport"; -- required: name of element
    Callback = function() -- required: function to be called when button is pressed
 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").islandUnlockParts[tab2.IslandDropdown].CFrame
    end
})



Miscsection2:CreateButton({
    Name = "Unlock all islands"; -- required: name of element
    Callback = function() -- required: function to be called when button is pressed
        for i,v in pairs(workspace.islandUnlockParts:GetDescendants()) do 
    if findFirstChildOfClass(v, "TouchTransmitter") then 
       firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 0) 
    end 
    end 
    end
})
game:GetService("RunService").RenderStepped:Connect(function()
    local tbl = {}
    for _,v in ipairs(game:GetService("Players"):GetPlayers()) do
        table.insert(tbl,v.Name)
    end
    PlayerDropdown:Update(tbl) -- uses namecalling, ":" instead of "."
end)

game:GetService("RunService").RenderStepped:Connect(function()

   if  tab1.AutoSwing  then 
    
    game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("swingKatana")
   end
end)
 
game:GetService("RunService").RenderStepped:Connect(function()

    if tab1.bossAutofarmenabled then 

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =  findFirstChild(game:GetService("Workspace"), "bossFolder")[tab1.BossSelectiondropdown].HumanoidRootPart.CFrame
    end
end)
 game:GetService("RunService").RenderStepped:Connect(function()

    if tab1.AutoSell then 
        for i,v in pairs(game:GetService("Workspace").sellAreaCircles.sellAreaCircle8:GetDescendants()) do
    if v.Name == "TouchInterest" and v.Parent then
        firetouchinterest( game.Players.LocalPlayer.Character.Head, v.Parent, 0)
       
    end 
        end
    end
end)


  UI:Notify({
  Title = "loaded";
  Content = "load time: ".. string.sub(tostring(os.clock() - executetime),0,5);
})
    UI:Notify({
  Title = "loaded";
  Content = "Welcome to Qw hub ";
})
