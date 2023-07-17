-- modified sirius esp  to support TS not sense esp
-- i was gonna maake my owwn esp at one point 
-- this project is heavily onoptimized 
-- variables
local getService = game.GetService;
local instanceNew = Instance.new;
local drawingNew = Drawing.new;
local vector2New = Vector2.new;
local vector3New = Vector3.new;
local cframeNew = CFrame.new;
local color3New = Color3.new;
local raycastParamsNew = RaycastParams.new;
local abs = math.abs;
local tan = math.tan;
local rad = math.rad;
local clamp = math.clamp;
local floor = math.floor;
local find = table.find;
local insert = table.insert;
local findFirstChild = game.FindFirstChild;
local getChildren = game.GetChildren;
local getDescendants = game.GetDescendants;
local isA = workspace.IsA;
local raycast = workspace.Raycast;
local emptyCFrame = cframeNew();
local pointToObjectSpace = emptyCFrame.PointToObjectSpace;
local getComponents = emptyCFrame.GetComponents;
local cross = vector3New().Cross;
local inf = 1 / 0;

-- services
local workspace = getService(game, "Workspace");
local runService = getService(game, "RunService");
local players = getService(game, "Players");
local coreGui = getService(game, "CoreGui");
local userInputService = getService(game, "UserInputService");

-- cache
local currentCamera = workspace.CurrentCamera;
local localPlayer = players.LocalPlayer;
local screenGui = instanceNew("ScreenGui", coreGui);
local lastFov, lastScale;
local mouse = localPlayer:GetMouse()
-- instance functions
local wtvp = currentCamera.WorldToViewportPoint;

local utility ={}

local library,pointers =  loadfile("SplixDrawing.lua")() -- replace it with a loadstring of gamesneeze ui or modified splix by Daruno and TaskManager

--[[
    made by siper#9938 and mickey#5612
]]

-- main module
local espLibrary = {
    instances = {},
    espCache = {},
    chamsCache = {},
    objectCache = {},
    conns = {},
    whitelist = {}, -- insert string that is the player's name you want to whitelist (turns esp color to whitelistColor in options)
    blacklist = {}, -- insert string that is the player's name you want to blacklist (removes player from esp)
    options = {
        enabled = false,
        minScaleFactorX = 1,
        maxScaleFactorX = 10,
        minScaleFactorY = 1,
        maxScaleFactorY = 10,
        scaleFactorX = 5,
        scaleFactorY = 6,
        boundingBox = false, -- WARNING | Significant Performance Decrease when true
        boundingBoxDescending = true,
        excludedPartNames = {},
        font = 2,
        fontSize = 13,
        limitDistance = false,
        maxDistance = 1000,
        visibleOnly = false,
        teamCheck = false,
        teamColor = false,
        fillColor = nil,
        whitelistColor = Color3.new(1, 0, 0),
        outOfViewArrows = false,
        outOfViewArrowsFilled = false,
        outOfViewArrowsSize = 25,
        outOfViewArrowsRadius = 100,
        outOfViewArrowsColor = Color3.new(1, 1, 1),
        outOfViewArrowsTransparency = 0.5,
        outOfViewArrowsOutline = false,
        outOfViewArrowsOutlineFilled = false,
        outOfViewArrowsOutlineColor = Color3.new(1, 1, 1),
        outOfViewArrowsOutlineTransparency = 1,
        names = false,
        nameTransparency = 1,
        nameColor = Color3.new(1, 1, 1),
        boxes = false,
        boxesTransparency = 1,
        boxesColor = Color3.new(1, 0, 0),
        boxFill = false,
        boxFillTransparency = 0.5,
        boxFillColor = Color3.new(1, 0, 0),
        healthBars = false,
        healthBarsSize = 1,
        healthBarsTransparency = 1,
        healthBarsColor = Color3.new(0, 1, 0),
        healthText = false,
        healthTextTransparency = 1,
        healthTextSuffix = "%",
        healthTextColor = Color3.new(1, 1, 1),
        distance = false,
        distanceTransparency = 1,
        distanceSuffix = " Studs",
        distanceColor = Color3.new(1, 1, 1),
        tracers = false,
        tracerTransparency = 1,
        tracerColor = Color3.new(1, 1, 1),
        tracerOrigin = "Bottom", -- Available [Mouse, Top, Bottom]
        chams = false,
        chamsFillColor = Color3.new(1, 0, 0),
        chamsFillTransparency = 0.5,
        chamsOutlineColor = Color3.new(),
        chamsOutlineTransparency = 0
    },
};
espLibrary.__index = espLibrary;

-- variables



-- Support Functions
local function isDrawing(type)
    return type == "Square" or type == "Text" or type == "Triangle" or type == "Image" or type == "Line" or type == "Circle";
end

local function create(type, properties)
    local drawing = isDrawing(type);
    local object = drawing and drawingNew(type) or instanceNew(type);

    if (properties) then
        for i,v in next, properties do
            object[i] = v;
        end
    end

    if (not drawing) then
        insert(espLibrary.instances, object);
    end

    return object;
end

local function worldToViewportPoint(position)
    local screenPosition, onScreen = wtvp(currentCamera, position);
    return vector2New(screenPosition.X, screenPosition.Y), onScreen, screenPosition.Z;
end

local function round(number)
    return typeof(number) == "Vector2" and vector2New(round(number.X), round(number.Y)) or floor(number);
end

-- Main Functions
function espLibrary.getTeam(player)
    
    return 
end

function espLibrary.getCharacter(player)
    local character = player;
    return character, character and findFirstChild(character, "HumanoidRootPart");
end

function espLibrary.getBoundingBox(character, torso)
    if (espLibrary.options.boundingBox) then
        local minX, minY, minZ = inf, inf, inf;
        local maxX, maxY, maxZ = -inf, -inf, -inf;

        for _, part in next, espLibrary.options.boundingBoxDescending and getDescendants(character) or getChildren(character) do
            if (isA(part, "BasePart") and not find(espLibrary.options.excludedPartNames, part.Name)) then
                local size = part.Size;
                local sizeX, sizeY, sizeZ = size.X, size.Y, size.Z;

                local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = getComponents(part.CFrame);

                local wiseX = 0.5 * (abs(r00) * sizeX + abs(r01) * sizeY + abs(r02) * sizeZ);
                local wiseY = 0.5 * (abs(r10) * sizeX + abs(r11) * sizeY + abs(r12) * sizeZ);
                local wiseZ = 0.5 * (abs(r20) * sizeX + abs(r21) * sizeY + abs(r22) * sizeZ);

                minX = minX > x - wiseX and x - wiseX or minX;
                minY = minY > y - wiseY and y - wiseY or minY;
                minZ = minZ > z - wiseZ and z - wiseZ or minZ;

                maxX = maxX < x + wiseX and x + wiseX or maxX;
                maxY = maxY < y + wiseY and y + wiseY or maxY;
                maxZ = maxZ < z + wiseZ and z + wiseZ or maxZ;
            end
        end

        local oMin, oMax = vector3New(minX, minY, minZ), vector3New(maxX, maxY, maxZ);
        return (oMax + oMin) * 0.5, oMax - oMin;
    else
        return torso.Position, vector2New(espLibrary.options.scaleFactorX, espLibrary.options.scaleFactorY);
    end
end

function espLibrary.getScaleFactor(fov, depth)
    if (fov ~= lastFov) then
        lastScale = tan(rad(fov * 0.5)) * 2;
        lastFov = fov;
    end

    return 1 / (depth * lastScale) * 1000;
end

function espLibrary.getBoxData(position, size)
    local torsoPosition, onScreen, depth = worldToViewportPoint(position);
    local scaleFactor = espLibrary.getScaleFactor(currentCamera.FieldOfView, depth);

    local clampX = clamp(size.X, espLibrary.options.minScaleFactorX, espLibrary.options.maxScaleFactorX);
    local clampY = clamp(size.Y, espLibrary.options.minScaleFactorY, espLibrary.options.maxScaleFactorY);
    local size = round(vector2New(clampX * scaleFactor, clampY * scaleFactor));

    return onScreen, size, round(vector2New(torsoPosition.X - (size.X * 0.5), torsoPosition.Y - (size.Y * 0.5))), torsoPosition;
end

function espLibrary.getHealth(player, character)
    local humanoid = findFirstChild(character, "Humanoid");

    if (humanoid) then
        return humanoid.Health, humanoid.MaxHealth;
    end

    return 100, 100;
end

function espLibrary.visibleCheck(character, position)
    local origin = currentCamera.CFrame.Position;
    local params = raycastParamsNew();

    params.FilterDescendantsInstances = { espLibrary.getCharacter(localPlayer), currentCamera, character };
    params.FilterType = Enum.RaycastFilterType.Blacklist;
    params.IgnoreWater = true;

    return (not raycast(workspace, origin, position - origin, params));
end

function espLibrary.addEsp(player)


    local objects = {
        arrow = create("Triangle", {
            Thickness = 1,
        }),
        arrowOutline = create("Triangle", {
            Thickness = 1,
        }),
        top = create("Text", {
            Center = true,
            Size = 13,
            Outline = true,
            OutlineColor = color3New(),
            Font = 2,
        }),
        side = create("Text", {
            Size = 13,
            Outline = true,
            OutlineColor = color3New(),
            Font = 2,
        }),
        bottom = create("Text", {
            Center = true,
            Size = 13,
            Outline = true,
            OutlineColor = color3New(),
            Font = 2,
        }),
        boxFill = create("Square", {
            Thickness = 1,
            Filled = true,
        }),
        boxOutline = create("Square", {
            Thickness = 3,
            Color = color3New()
        }),
        box = create("Square", {
            Thickness = 1
        }),
        healthBarOutline = create("Square", {
            Thickness = 1,
            Color = color3New(),
            Filled = true
        }),
        healthBar = create("Square", {
            Thickness = 1,
            Filled = true
        }),
        line = create("Line")
    };

    espLibrary.espCache[player] = objects;
end

function espLibrary.removeEsp(player)
    local espCache = espLibrary.espCache[player];

    if (espCache) then
        espLibrary.espCache[player] = nil;

        for index, object in next, espCache do
            espCache[index] = nil;
            object:Remove();
        end
    end
end

function espLibrary.addChams(player)

    

    espLibrary.chamsCache[player] = create("Highlight", {
        Parent = screenGui,
    });
end

function espLibrary.removeChams(player)
    local highlight = espLibrary.chamsCache[player];

    if (highlight) then
        espLibrary.chamsCache[player] = nil;
        highlight:Destroy();
    end
end

function espLibrary.addObject(object, options)
    espLibrary.objectCache[object] = {
        options = options,
        text = create("Text", {
            Center = true,
            Size = 13,
            Outline = true,
            OutlineColor = color3New(),
            Font = 2,
        })
    };
end

function espLibrary.removeObject(object)
    local cache = espLibrary.objectCache[object];

    if (cache) then
        espLibrary.objectCache[object] = nil;
        cache.text:Remove();
    end
end

function espLibrary:AddObjectEsp(object, defaultOptions)
    assert(object and object.Parent, "invalid object passed");

    local options = defaultOptions or {};

    options.enabled = options.enabled or true;
    options.limitDistance = options.limitDistance or false;
    options.maxDistance = options.maxDistance or false;
    options.visibleOnly = options.visibleOnly or false;
    options.color = options.color or color3New(1, 1, 1);
    options.transparency = options.transparency or 1;
    options.text = options.text or object.Name;
    options.font = options.font or 2;
    options.fontSize = options.fontSize or 13;

    self.addObject(object, options);

    insert(self.conns, object.Parent.ChildRemoved:Connect(function(child)
        if (child == object) then
            self.removeObject(child);
        end
    end));

    return options;
end

function espLibrary:Unload()
    for _, connection in next, self.conns do
        connection:Disconnect();
    end

    for _, player in next, players:GetPlayers() do
        self.removeEsp(player);
        self.removeChams(player);
    end

    for object, _ in next, self.objectCache do
        self.removeObject(object);
    end

    for _, object in next, self.instances do
        object:Destroy();
    end

    screenGui:Destroy();
    runService:UnbindFromRenderStep("esp_rendering");
end

function espLibrary:Load(renderValue)
    insert(self.conns, workspace.ChildAdded:Connect(function(player)
    if  player:IsA("Model") and player:FindFirstChild("Humanoid") and player.Name ~= "Player" then 
        self.addEsp(player);
        self.addChams(player);
        end 
    end));

    insert(self.conns, players.PlayerRemoving:Connect(function(player)
    if  player:IsA("Model") and player:FindFirstChild("Humanoid") and player.Name ~= "Player" then 

        self.removeEsp(player);
        self.removeChams(player);
        end 
    end));

    for _, player in next, players:GetPlayers() do
    if  player:IsA("Model") and player:FindFirstChild("Humanoid") and player.Name ~= "Player" then 

        self.addEsp(player);
        self.addChams(player);
        end 
    end

    runService:BindToRenderStep("esp_rendering", renderValue or (Enum.RenderPriority.Camera.Value + 1), function()
        for player, objects in next, self.espCache do
            local character, torso = self.getCharacter(player);

            if (character and torso) then
                local onScreen, size, position, torsoPosition = self.getBoxData(torso.Position, Vector3.new(5, 6));
                local distance = (currentCamera.CFrame.Position - torso.Position).Magnitude;
                local canShow, enabled = onScreen and (size and position), self.options.enabled;
                local team, teamColor = self.getTeam(player);
                local color = self.options.teamColor and teamColor or nil;

                if (self.options.fillColor ~= nil) then
                    color = self.options.fillColor;
                end

                if (find(self.whitelist, player.Name)) then
                    color = self.options.whitelistColor;
                end

                if (find(self.blacklist, player.Name)) then
                    enabled = false;
                end

                if (self.options.limitDistance and distance > self.options.maxDistance) then
                    enabled = false;
                end

                if (self.options.visibleOnly and not self.visibleCheck(character, torso.Position)) then
                    enabled = false;
                end

                if (self.options.teamCheck and (team == self.getTeam(localPlayer))) then
                    enabled = false;
                end

                local viewportSize = currentCamera.ViewportSize;

                local screenCenter = vector2New(viewportSize.X / 2, viewportSize.Y / 2);
                local objectSpacePoint = (pointToObjectSpace(currentCamera.CFrame, torso.Position) * vector3New(1, 0, 1)).Unit;
                local crossVector = cross(objectSpacePoint, vector3New(0, 1, 1));
                local rightVector = vector2New(crossVector.X, crossVector.Z);

                local arrowRadius, arrowSize = self.options.outOfViewArrowsRadius, self.options.outOfViewArrowsSize;
                local arrowPosition = screenCenter + vector2New(objectSpacePoint.X, objectSpacePoint.Z) * arrowRadius;
                local arrowDirection = (arrowPosition - screenCenter).Unit;

                local pointA, pointB, pointC = arrowPosition, screenCenter + arrowDirection * (arrowRadius - arrowSize) + rightVector * arrowSize, screenCenter + arrowDirection * (arrowRadius - arrowSize) + -rightVector * arrowSize;

                local health, maxHealth = self.getHealth(player, character);
                local healthBarSize = round(vector2New(self.options.healthBarsSize, -(size.Y * (health / maxHealth))));
                local healthBarPosition = round(vector2New(position.X - (3 + healthBarSize.X), position.Y + size.Y));

                local origin = self.options.tracerOrigin;
                local show = canShow and enabled;

                objects.arrow.Visible = (not canShow and enabled) and self.options.outOfViewArrows;
                objects.arrow.Filled = self.options.outOfViewArrowsFilled;
                objects.arrow.Transparency = self.options.outOfViewArrowsTransparency;
                objects.arrow.Color = color or self.options.outOfViewArrowsColor;
                objects.arrow.PointA = pointA;
                objects.arrow.PointB = pointB;
                objects.arrow.PointC = pointC;

                objects.arrowOutline.Visible = (not canShow and enabled) and self.options.outOfViewArrowsOutline;
                objects.arrowOutline.Filled = self.options.outOfViewArrowsOutlineFilled;
                objects.arrowOutline.Transparency = self.options.outOfViewArrowsOutlineTransparency;
                objects.arrowOutline.Color = color or self.options.outOfViewArrowsOutlineColor;
                objects.arrowOutline.PointA = pointA;
                objects.arrowOutline.PointB = pointB;
                objects.arrowOutline.PointC = pointC;

                objects.top.Visible = show and self.options.names;
                objects.top.Font = self.options.font;
                objects.top.Size = self.options.fontSize;
                objects.top.Transparency = self.options.nameTransparency;
                objects.top.Color = color or self.options.nameColor;
                objects.top.Text = player.Head:FindFirstChild("Nametag").tag.Text;
                objects.top.Position = round(position + vector2New(size.X * 0.5, -(objects.top.TextBounds.Y + 2)));

                objects.side.Visible = show and self.options.healthText;
                objects.side.Font = self.options.font;
                objects.side.Size = self.options.fontSize;
                objects.side.Transparency = self.options.healthTextTransparency;
                objects.side.Color = color or self.options.healthTextColor;
                objects.side.Text = health .. self.options.healthTextSuffix;
                objects.side.Position = round(position + vector2New(size.X + 3, -3));

                objects.bottom.Visible = show and self.options.distance;
                objects.bottom.Font = self.options.font;
                objects.bottom.Size = self.options.fontSize;
                objects.bottom.Transparency = self.options.distanceTransparency;
                objects.bottom.Color = color or self.options.nameColor;
                objects.bottom.Text = tostring(round(distance)) .. self.options.distanceSuffix;
                objects.bottom.Position = round(position + vector2New(size.X * 0.5, size.Y + 1));


                objects.box.Visible = show and self.options.boxes;
                objects.box.Color = color or self.options.boxesColor;
                objects.box.Transparency = self.options.boxesTransparency;
                objects.box.Size = size;
                objects.box.Position = position;

                objects.boxOutline.Visible = show and self.options.boxes;
                objects.boxOutline.Transparency = self.options.boxesTransparency;
                objects.boxOutline.Size = size;
                objects.boxOutline.Position = position;

                objects.boxFill.Visible = show and self.options.boxFill;
                objects.boxFill.Color = color or self.options.boxFillColor;
                objects.boxFill.Transparency = self.options.boxFillTransparency;
                objects.boxFill.Size = size;
                objects.boxFill.Position = position;

                objects.healthBar.Visible = show and self.options.healthBars;
                objects.healthBar.Color = color or self.options.healthBarsColor;
                objects.healthBar.Transparency = self.options.healthBarsTransparency;
                objects.healthBar.Size = healthBarSize;
                objects.healthBar.Position = healthBarPosition;

                objects.healthBarOutline.Visible = show and self.options.healthBars;
                objects.healthBarOutline.Transparency = self.options.healthBarsTransparency;
                objects.healthBarOutline.Size = round(vector2New(healthBarSize.X, -size.Y) + vector2New(2, -2));
                objects.healthBarOutline.Position = healthBarPosition - vector2New(1, -1);

                objects.line.Visible = show and self.options.tracers;
                objects.line.Color = color or self.options.tracerColor;
                objects.line.Transparency = self.options.tracerTransparency;
                objects.line.From =
                    origin == "Mouse" and userInputService:GetMouseLocation() or
                    origin == "Top" and vector2New(viewportSize.X * 0.5, 0) or
                    origin == "Bottom" and vector2New(viewportSize.X * 0.5, viewportSize.Y);
                objects.line.To = torsoPosition;
            else
                for _, object in next, objects do
                    object.Visible = false;
                end
            end
        end

        for player, highlight in next, self.chamsCache do
            local character, torso = self.getCharacter(player);

            if (character and torso) then
                local distance = (currentCamera.CFrame.Position - torso.Position).Magnitude;
                local canShow = self.options.enabled and self.options.chams;
                local team, teamColor = self.getTeam(player);
                local color = self.options.teamColor and teamColor or nil;

                if (self.options.fillColor ~= nil) then
                    color = self.options.fillColor;
                end

                if (find(self.whitelist, player.Name)) then
                    color = self.options.whitelistColor;
                end

                if (find(self.blacklist, player.Name)) then
                    canShow = false;
                end

                if (self.options.limitDistance and distance > self.options.maxDistance) then
                    canShow = false;
                end

                if (self.options.teamCheck and (team == self.getTeam(localPlayer))) then
                    canShow = false;
                end

                highlight.Enabled = canShow;
                highlight.DepthMode = self.options.visibleOnly and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop;
                highlight.Adornee = character;
                highlight.FillColor = color or self.options.chamsFillColor;
                highlight.FillTransparency = self.options.chamsFillTransparency;
                highlight.OutlineColor = color or self.options.chamsOutlineColor;
                highlight.OutlineTransparency = self.options.chamsOutlineTransparency;
            end
        end

        for object, cache in next, self.objectCache do
            local partPosition = vector3New();

            if (object:IsA("BasePart")) then
                partPosition = object.Position;
            elseif (object:IsA("Model")) then
                partPosition = self.getBoundingBox(object);
            end

            local distance = (currentCamera.CFrame.Position - partPosition).Magnitude;
            local screenPosition, onScreen = worldToViewportPoint(partPosition);
            local canShow = cache.options.enabled and onScreen;

            if (self.options.limitDistance and distance > self.options.maxDistance) then
                canShow = false;
            end

            if (self.options.visibleOnly and not self.visibleCheck(object, partPosition)) then
                canShow = false;
            end

            cache.text.Visible = canShow;
            cache.text.Font = cache.options.font;
            cache.text.Size = cache.options.fontSize;
            cache.text.Transparency = cache.options.transparency;
            cache.text.Color = cache.options.color;
            cache.text.Text = cache.options.text;
            cache.text.Position = round(screenPosition);
        end
    end);
end

 espLibrary:Load()

 
 
    
function utility:closestPlayer(Value)
    local closesttarget
    local fov = Value

   for _,v in ipairs(Workspace:GetChildren()) do
    if  v.IsA(v,"Model") and v.FindFirstChild(v,"Humanoid") and v.Name ~= "Player" then 
            local onscreen, isvisible = currentCamera.WorldToScreenPoint(currentCamera, v[pointers["combat_aimassist_bodypartselected"]:get()].Position);

            if isvisible then
                local Distance = (vector2New(onscreen.x, onscreen.y) - vector2New(mouse.x, mouse.y)).Magnitude;
                if Distance <= fov then
                    fov = Distance
                    closesttarget = v
                end
            end
        end
    end
    return closesttarget
end
function utility:GetPlrposition()
    if pointers["combat_aim_assist_predictionenabled"]:get() then

        return utility:closestPlayer(pointers["combat_aim_assist_fov"]:get())[pointers["combat_aimassist_bodypartselected"]:get()].Position + (utility:closestPlayer(pointers["combat_aim_assist_fov"]:get())[pointers["combat_aimassist_bodypartselected"]:get()].Velocity / pointers["combat_aim_assist_prediction"]:get() )
    else 
        return utility:closestPlayer(pointers["combat_aim_assist_fov"]:get())[pointers["combat_aimassist_bodypartselected"]:get()].Position
                     
    end 
end 
 

    local window = library:New({name = "Qw hub"})
 
     local combat_page = window:Page({name = "Combat", size = 100}) 
     local Visuals_page = window:Page({name = "Visuals", size = 100}) 
     local settings_page = window:Page({name = "Settings", side = "Left", size = 100}) 
    
     local aim_assist_section = combat_page:Section({Name = "Aim Assistance"}) 
     local menu_section = settings_page:Section({name = "Menu"}) 
     local Menu_colors = settings_page:Section({name = "UI"})
     local Esp_multisection,espsettings_multisection = Visuals_page:MultiSection({side = "Left", sections = {"Esp", "Settings"}})
     
    aim_assist_section:Toggle({pointer = "combat_aim_assist_enabled", Name = "Enabled"}):Keybind({pointer = "combat_aim_assist_aimbind", Default = Enum.UserInputType.MouseButton2, KeybindName = "Aim Assist", Mode = "Hold"})
    aim_assist_section:Slider({pointer = "combat_aim_assist_aimsmoothness", Name = "Smooth", Min = 1, Max = 30, Default = 100, Decimals = 0.1})
    aim_assist_section:Toggle({pointer = "combat_aim_assist_ShowFov", Name = "Show FOV"}):Colorpicker({Name = "Fov Circle", pointer = "combat_aim_assist_FovCirclecolor", Default = Color3.fromRGB(255,255,255)})
    aim_assist_section:Slider({pointer = "combat_aim_assist_fov", Name = "FOV", Min = 1, Max = 500, Default = 100, Decimals = 1})
    
    aim_assist_section:Dropdown({pointer = "combat_aimassist_bodypartselected", Name = "BodyPart", Options = {"Head", "HumanoidRootPart"}})
    aim_assist_section:Toggle({pointer = "combat_aim_assist_predictionenabled", Name = "Prediction"})
    aim_assist_section:Slider({pointer = "combat_aim_assist_prediction", Name = "Prediction amount", Min = 1, Max = 30, Default = 100, Decimals = 0.1})

    Esp_multisection:Toggle({pointer = "Visuals_espmultisection_espEnabled", Name = "Enabled", callback = function(bool)
        espLibrary.options.enabled = bool
    end})
    local boxesespenabled = Esp_multisection:Toggle({pointer = "Visuals_espmultisection_BoxesEnabled", Name = "Box", callback = function(bool)
        espLibrary.options.boxes = bool
    end})
    boxesespenabled:Colorpicker({pointer = "Visuals_espmultisection_BoxesColor",  Name = "Box Color", Default = Color3.fromRGB(255,255,255), callback = function(Color)
         espLibrary.options.boxesColor = Color
        
    end})
    local Namesespcolor = Esp_multisection:Toggle({pointer = "Visuals_espmultisection_nameEnabled", Name = "Name", callback = function(bool)
        espLibrary.options.names = bool
    end})
    Namesespcolor:Colorpicker({pointer = "Visuals_espmultisection_namesColor",  Name = "name Color",Default = Color3.fromRGB(255,255,255), callback = function(Color)
         espLibrary.options.nameColor = Color
        
    end})
    
    local offscreenind = Esp_multisection:Toggle({pointer = "Visuals_espmultisection_ovaEnabled", Name = "OFfscreen arrows",  callback = function(bool)
        espLibrary.options.outOfViewArrows = bool
    end})
    offscreenind:Colorpicker({pointer = "Visuals_espmultisection_ovaColor",  Name = "OutOfViewArrows Color",Default = Color3.fromRGB(255,255,255),  callback = function(Color)
         espLibrary.options.outOfViewArrowsColor = Color
        
    end})
    local ChamsColor = Esp_multisection:Toggle({pointer = "Visuals_espmultisection_chamsEnabled", Name = "Chams",  callback = function(bool)
        espLibrary.options.chams = bool
    end})
    ChamsColor:Colorpicker({pointer = "Visuals_espmultisection_chamsColor",  Name = "Fill Color", Default = Color3.fromRGB(255,1,1), callback = function(Color)
         espLibrary.options.chamsFillColor = Color
        
    end})
    ChamsColor:Colorpicker({pointer = "Visuals_espmultisection_chamscolor2",  Name = "Outline Color",Default = Color3.fromRGB(255,255,255),  callback = function(Color)
         espLibrary.options.chamsOutlineColor = Color
        
    end})
         menu_section:Keybind({pointer = "settings_bind", name = "Bind", default = Enum.KeyCode.RightShift, callback = function(boolean)
         window.uibind = boolean
         end})
 
         menu_section:Toggle({pointer = "settings_Watermark", name = "Watermark", callback = function(boolean)
         window.watermark:Update("Visible", boolean)
         end})
         menu_section:Toggle({pointer = "settings__keybind_list", name = "Keybind List", callback = function(boolean)
         window.keybindslist:Update("Visible", boolean)
         end})

         Menu_colors:Dropdown({pointer = "settings_selectedtheme", name = "Themes", default = "Default", Options = {"Default", "Abyss", "AimWare", "np.rip","BubbleGum","Dracula", "Dracula blue", "plaguecheat", "Neko", "Spotify", "BBot", "Tokyo Night", "Gamesense","Fatality","Twitch", "Neverlose"}})
         Menu_colors:Button({name = "Select", callback = function()
                  if pointers["settings_selectedtheme"]:get() == "Neko" then
              library:UpdateColor("lightcontrast", Color3.fromRGB(18,18,18))
              library:UpdateColor("Accent", Color3.fromRGB(226, 30, 112))
              library:UpdateColor("darkcontrast", Color3.fromRGB(25, 25, 25))
                library:UpdateColor("inline", pointers["settings_inline"]:get())                
                library:UpdateColor("outline", pointers["settings_outline"]:get())
 elseif pointers["settings_selectedtheme"]:get() == "BubbleGum" then
                      library:UpdateColor("Accent", Color3.fromRGB(169, 83, 245))
                        library:UpdateColor("lightcontrast", Color3.fromRGB(22, 12, 46))
                        library:UpdateColor("darkcontrast", Color3.fromRGB(17, 8, 31))
                        library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
                        library:UpdateColor("inline", Color3.fromRGB(46, 46, 46))
                                            elseif pointers["settings_selectedtheme"]:get() == "AimWare" then
                        library:UpdateColor("Accent", Color3.fromRGB(250, 47, 47))
                        library:UpdateColor("lightcontrast", Color3.fromRGB(41, 40, 40))
                        library:UpdateColor("darkcontrast", Color3.fromRGB(38, 38, 38))
                        library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
                        library:UpdateColor("inline", Color3.fromRGB(46, 46, 46))
                    elseif pointers["settings_selectedtheme"]:get() == "np.rip" then
                        library:UpdateColor("Accent", Color3.fromRGB(242, 150, 92))
                        library:UpdateColor("lightcontrast", Color3.fromRGB(22, 12, 46))
                        library:UpdateColor("darkcontrast", Color3.fromRGB(17, 8, 31))
                        library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
                        library:UpdateColor("inline", Color3.fromRGB(46, 46, 46))
                    elseif pointers["settings_selectedtheme"]:get() == "Abyss" then
                        library:UpdateColor("Accent", Color3.fromRGB(81, 72, 115))
                        library:UpdateColor("lightcontrast", Color3.fromRGB(41, 41, 41))
                        library:UpdateColor("darkcontrast", Color3.fromRGB(31, 30, 30))
                        library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
                        library:UpdateColor("inline", Color3.fromRGB(50, 50, 50))
                    elseif pointers["settings_selectedtheme"]:get() == "Slime" then
                        
                           library:UpdateColor("Accent", Color3.fromRGB(64, 247, 141))
                        library:UpdateColor("lightcontrast", Color3.fromRGB(22, 12, 46))
                        library:UpdateColor("darkcontrast", Color3.fromRGB(17, 8, 31))
                        library:UpdateColor("outline", Color3.fromRGB(0, 0, 0))
                        library:UpdateColor("inline", Color3.fromRGB(46, 46, 46))
                        
            elseif pointers["settings_selectedtheme"]:get() == "Default" then 
              library:UpdateColor("Accent", pointers["settings_accent"]:get())
              library:UpdateColor("lightcontrast", pointers["settings_lightcontrast"]:get())                
              library:UpdateColor("darkcontrast", pointers["settings_darkcontrast"]:get())
                library:UpdateColor("inline", pointers["settings_inline"]:get())                
                library:UpdateColor("outline", pointers["settings_outline"]:get())
                elseif pointers["settings_selectedtheme"]:get() == "plaguecheat" then 
              library:UpdateColor("Accent", Color3.fromRGB(84, 122, 181))
              library:UpdateColor("lightcontrast", Color3.new(0.0829829,0.0797523,0.0797523))                
              library:UpdateColor("darkcontrast", Color3.fromRGB(18,18,18))
              library:UpdateColor("inline", pointers["settings_inline"]:get())                
         
          elseif pointers["settings_selectedtheme"]:get() == "Neverlose" then 
              library:UpdateColor("lightcontrast",Color3.fromHSV(0.5526315569877625,0.6847826242446899,0.13742689788341523))
              library:UpdateColor("darkcontrast",Color3.fromHSV(0.652046799659729,0.6630434989929199,0.10818713158369065))
              library:UpdateColor("Accent", Color3.fromHSV(0.5584795475006104,0.8586955666542053,0.9912280440330505))
                library:UpdateColor("inline", pointers["settings_inline"]:get())                
                library:UpdateColor("outline", pointers["settings_outline"]:get())                

          elseif pointers["settings_selectedtheme"]:get() == "Dracula" then 
              library:UpdateColor("lightcontrast",Color3.fromHex("2a2333"))
              library:UpdateColor("darkcontrast",Color3.fromHex("221b27"))
              library:UpdateColor("Accent", Color3.fromHex("8262a5"))
                library:UpdateColor("inline", pointers["settings_inline"]:get())                
                library:UpdateColor("outline", pointers["settings_outline"]:get())
                 elseif pointers["settings_selectedtheme"]:get() == "Dracula blue" then 
              library:UpdateColor("lightcontrast",Color3.fromHex("232533"))
              library:UpdateColor("darkcontrast",Color3.fromHex("1b1c27"))
              library:UpdateColor("Accent", Color3.fromHex("6271a5"))
                library:UpdateColor("inline", pointers["settings_inline"]:get())                
                library:UpdateColor("outline", pointers["settings_outline"]:get())
          elseif pointers["settings_selectedtheme"]:get() == "BBot" then 

              library:UpdateColor("lightcontrast",Color3.fromHex('232323'))
              library:UpdateColor("Accent", Color3.fromHex('7e48a3')) 
              library:UpdateColor("darkcontrast", Color3.fromRGB(22, 22, 22))
                library:UpdateColor("inline", pointers["settings_inline"]:get())                
                library:UpdateColor("outline", pointers["settings_outline"]:get())
          elseif pointers["settings_selectedtheme"]:get() == "Spotify" then 
              library:UpdateColor("lightcontrast", Color3.fromRGB(18,18,18))
              library:UpdateColor("Accent", Color3.new(0.0993174,0.90584,0.278489))                
              library:UpdateColor("darkcontrast", Color3.fromRGB(25, 25, 25))
                library:UpdateColor("inline", pointers["settings_inline"]:get())                
                library:UpdateColor("outline", pointers["settings_outline"]:get())
          elseif pointers["settings_selectedtheme"]:get() == "Gamesense" then 
              library:UpdateColor("lightcontrast", Color3.fromRGB(18,18,18))
              library:UpdateColor("Accent", Color3.fromRGB(147,184,26))    
              library:UpdateColor("darkcontrast", Color3.fromRGB(25, 25, 25))
                library:UpdateColor("inline", pointers["settings_inline"]:get())                
                library:UpdateColor("outline", pointers["settings_outline"]:get())
          elseif pointers["settings_selectedtheme"]:get() == "Twitch" then 
              library:UpdateColor("lightcontrast", Color3.fromRGB(14,14,14))
              library:UpdateColor("Accent", Color3.fromRGB(169,112,255))   
              library:UpdateColor("darkcontrast", Color3.fromRGB(17,17,17))
                library:UpdateColor("inline", pointers["settings_inline"]:get())                
                library:UpdateColor("outline", pointers["settings_outline"]:get())
          elseif pointers["settings_selectedtheme"]:get() == "Tokyo Night" then 
              library:UpdateColor("lightcontrast", Color3.fromRGB(22,22,31))
              library:UpdateColor("Accent", Color3.fromRGB(103,89,179))
              library:UpdateColor("darkcontrast", Color3.fromRGB(22,22,31))
                library:UpdateColor("inline", pointers["settings_inline"]:get())                
                library:UpdateColor("outline", pointers["settings_outline"]:get())
              elseif pointers["settings_selectedtheme"]:get() == "Fatality" then 
              library:UpdateColor("lightcontrast", Color3.fromRGB(25,19,53))
              library:UpdateColor("Accent", Color3.fromRGB(197,7,83))                        
              library:UpdateColor("darkcontrast", Color3.fromRGB(25, 25, 25))
                library:UpdateColor("inline", pointers["settings_inline"]:get())                
                library:UpdateColor("outline", pointers["settings_outline"]:get())

              end 
             end
         })
         Menu_colors:Toggle({pointer = "settings_rainbowAccent", name = "Rainbow accent"})
         Menu_colors:Colorpicker({pointer = "settings_accent", name = "Accent", default = Color3.fromRGB(255,135,255), callback = function(Color)
              library:UpdateColor("Accent", Color)
           end})
         Menu_colors:Colorpicker({pointer = "settings_darkcontrast", name = "dark contrast", default =  Color3.fromRGB(25, 25, 25), callback = function(Color)
              library:UpdateColor("darkcontrast", Color)
              end})
         Menu_colors:Colorpicker({pointer = "settings_lightcontrast", name = "light contrast", default = Color3.fromRGB(30, 30, 30), callback = function(Color)
              library:UpdateColor("lightcontrast", Color)
              end})
         Menu_colors:Colorpicker({pointer = "settings_outline", name = "outline", default = Color3.fromRGB(0, 0, 0), callback = function(Color)
              library:UpdateColor("outline", Color)
              end})
         Menu_colors:Colorpicker({pointer = "settings_inline", name = "inline", default =  Color3.fromRGB(50, 50, 50), callback = function(Color)
              library:UpdateColor("inline", Color)
              end})
         Menu_colors:Colorpicker({pointer = "settings_textcolor", name = "text color", default = Color3.fromRGB(255, 255, 255), callback = function(Color)
              library:UpdateColor("textcolor", Color)
          end})  
         Menu_colors:Colorpicker({pointer = "settings_cursoroutline", name = "cursor outline ", default = Color3.fromRGB(10,10,10), callback = function(Color)
              library:UpdateColor("cursoroutline", Color)
          end})
             
        local config_section = settings_page:Section({name = "Configuration", side = "Right"}) do
 
                local current_list = {}
             local function update_config_list()
                 local list = {}
                 for idx, file in ipairs(listfiles("Qw/configs")) do
                     local file_name = file:gsub("Qw/configs\\", ""):gsub(".txt", "")
                     list[#list + 1] = file_name
                 end
 
                 local is_new = #list ~= #current_list
                 if not is_new then
                     for idx, file in ipairs(list) do
                         if file ~= current_list[idx] then
                             is_new = true
                             break
                         end
                     end
                 end
 
                 if is_new then
                     current_list = list
                     pointers["settings_cfg_list"]:UpdateList(list, false, true)
                 end
             end
 
           
             config_section:Listbox({pointer = "settings_cfg_list"})
               config_section:Textbox({pointer = "settings_cfgname", placeholder = "Config Name", text = "", middle = true, reset_on_focus = false})
             config_section:Button({name = "Create", callback = function()
                     local config_name = pointers["settings_cfgname"]:get()
                     if config_name == "" or isfile("Qw/configs/" .. config_name .. ".txt") then
                         return
                     end
 
                     writefile("Qw/configs/" .. config_name .. ".txt", "")
                     update_config_list()
                 end})
 
             config_section:Button({name = "Load", confirmation = true, callback = function()
                     local selected_config = pointers["settings_cfg_list"]:get()[1][1]
                     if selected_config then
                         window:LoadConfig(readfile("Qw/configs/" .. selected_config .. ".txt"))
                     end
                 end})
             config_section:Button({name = "Save", confirmation = true, callback = function()
                     local selected_config = pointers["settings_cfg_list"]:get()[1][1]
                     if selected_config then
                         writefile("Qw/configs/" .. selected_config .. ".txt", window:GetConfig())
                     end
                 end})
             config_section:Button({name = "Delete", confirmation = true, callback = function()
                     local selected_config = pointers["settings_cfg_list"]:get()[1][1]
                     if selected_config then
                         delfile("Qw/configs/" .. selected_config .. ".txt")
                         update_config_list()
                     end
                 end})
 
              update_config_list()
         
        end 
local Line_onplr = drawingNew("Line")
local FOv_circle = drawingNew("Circle")
        
            runService.RenderStepped:Connect(function()
                if pointers["settings_rainbowAccent"]:get() then 
                    library:UpdateColor("Accent", Color3.fromHSV((tick() % 5 / 5), 1, 1))
                end 
                
                if pointers["combat_aim_assist_enabled"]:get() and pointers["combat_aim_assist_aimbind"]:is_active() then 
                    if utility:closestPlayer(pointers["combat_aim_assist_fov"]:get()) and utility:closestPlayer(pointers["combat_aim_assist_fov"]:get()) ~= nil then 
                        local Targetposition = (currentCamera.WorldToViewportPoint(currentCamera, utility:GetPlrposition() ))
                        local getmouseposition = userInputService:GetMouseLocation();

                        mousemoverel((Targetposition.X - getmouseposition.X) / pointers["combat_aim_assist_aimsmoothness"]:get(), (Targetposition.Y - getmouseposition.Y) / pointers["combat_aim_assist_aimsmoothness"]:get() )
                        end 
                end 
                if pointers["combat_aim_assist_ShowFov"]:get() then 
                    
    FOv_circle.Position = userInputService:GetMouseLocation()
    FOv_circle.Color = Color3.fromRGB(255,255,255)--pointers["combat_aim_assist_FovCirclecolor"]:get()
    FOv_circle.Visible = true 
    FOv_circle.Thickness = 1 
    FOv_circle.Radius = pointers["combat_aim_assist_fov"]:get()
    else 
    FOv_circle.Visible = false 
                    end 
            end)
            
            wait(1)
          window:Initialize()
          espLibrary:Load()
             --[[
    game:GetService("RunService").RenderStepped:Connect(function()
       if combat_page.open == true then 
        
        end 
        end)
        
        ]] 
   
 
