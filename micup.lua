if getgenv().Fluent and getgenv().Fluent.Window then
    pcall(function()
        getgenv().Fluent.Window:Destroy()
    end)
    getgenv().Fluent.Window = nil
end


local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Mic up",
    SubTitle = "by crimzi",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Home = Window:AddTab({ Title = "Home", Icon = "" }),
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Player = Window:AddTab({ Title = "Player", Icon = "" }),
    Info = Window:AddTab({ Title = "Info", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Notification",
        Content = "This is a notification",
        SubContent = "SubContent",
        Duration = 5
    })

    Tabs.Main:AddParagraph({
        Title = "Paragraph",
        Content = "This is a paragraph.\nSecond line!"
    })

    Tabs.Main:AddButton({
        Title = "Button",
        Description = "Very important button",
        Callback = function()
            Window:Dialog({
                Title = "Title",
                Content = "This is a dialog",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            print("Confirmed the dialog.")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cancelled the dialog.")
                        end
                    }
                }
            })
        end
    })

    local Toggle = Tabs.Main:AddToggle("MyToggle", { Title = "Toggle", Default = false })

    Toggle:OnChanged(function()
        print("Toggle changed:", Options.MyToggle.Value)
    end)

    Options.MyToggle:SetValue(false)

    local Slider = Tabs.Main:AddSlider("Slider", {
        Title = "Slider",
        Description = "This is a slider",
        Default = 2,
        Min = 0,
        Max = 5,
        Rounding = 1,
        Callback = function(Value)
            print("Slider was changed:", Value)
        end
    })

    Slider:OnChanged(function(Value)
        print("Slider changed:", Value)
    end)

    Slider:SetValue(3)

    local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
        Title = "Dropdown",
        Values = { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen" },
        Multi = false,
        Default = 1,
    })

    Dropdown:SetValue("four")

    Dropdown:OnChanged(function(Value)
        print("Dropdown changed:", Value)
    end)

    local MultiDropdown = Tabs.Main:AddDropdown("MultiDropdown", {
        Title = "Dropdown",
        Description = "You can select multiple values.",
        Values = { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen" },
        Multi = true,
        Default = { "seven", "twelve" },
    })

    MultiDropdown:SetValue({
        three = true,
        five = true,
        seven = false
    })

    MultiDropdown:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        print("Mutlidropdown changed:", table.concat(Values, ", "))
    end)

    local Colorpicker = Tabs.Main:AddColorpicker("Colorpicker", {
        Title = "Colorpicker",
        Default = Color3.fromRGB(96, 205, 255)
    })

    Colorpicker:OnChanged(function()
        print("Colorpicker changed:", Colorpicker.Value)
    end)

    Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

    local TColorpicker = Tabs.Main:AddColorpicker("TransparencyColorpicker", {
        Title = "Colorpicker",
        Description = "but you can change the transparency.",
        Transparency = 0,
        Default = Color3.fromRGB(96, 205, 255)
    })

    TColorpicker:OnChanged(function()
        print(
            "TColorpicker changed:", TColorpicker.Value,
            "Transparency:", TColorpicker.Transparency
        )
    end)

    local Keybind = Tabs.Main:AddKeybind("Keybind", {
        Title = "KeyBind",
        Mode = "Toggle",
        Default = "LeftControl",
        Callback = function(Value)
            print("Keybind clicked!", Value)
        end,
        ChangedCallback = function(New)
            print("Keybind changed!", New)
        end
    })

    Keybind:OnClick(function()
        print("Keybind clicked:", Keybind:GetState())
    end)

    Keybind:OnChanged(function()
        print("Keybind changed:", Keybind.Value)
    end)

    task.spawn(function()
        while true do
            wait(1)
            local state = Keybind:GetState()
            if state then
                print("Keybind is being held down")
            end
            if Fluent.Unloaded then break end
        end
    end)

    Keybind:SetValue("MB2", "Toggle")

    local Input = Tabs.Main:AddInput("Input", {
        Title = "Input",
        Default = "Default",
        Placeholder = "Placeholder",
        Numeric = false,
        Finished = false,
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })

    Input:OnChanged(function()
        print("Input updated:", Input.Value)
    end)
end

do
    local function getExecutorName()
        if identifyexecutor then
            local success, result = pcall(identifyexecutor)
            if success and type(result) == "string" then
                return result
            end
        elseif getexecutorname then
            local success, result = pcall(getexecutorname)
            if success and type(result) == "string" then
                return result
            end
        end
        return "Unknown"
    end

    local executorName = getExecutorName()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local accountAge = "Unknown"
    local username = "Unknown"
    pcall(function()
        if LocalPlayer then
            username = LocalPlayer.Name
            accountAge = tostring(LocalPlayer.AccountAge) .. " days"
        end
    end)

    local fps = "Unknown"
    pcall(function()
        local RunService = game:GetService("RunService")

        RunService.RenderStepped:Connect(function(frametime)
            fps = 1 / frametime
        end)
    end)

    Tabs.Info:AddParagraph({
        Title = "Player Info",
        Content = "Username: " .. username .. "\nAccount Age: " .. accountAge
    })

    Tabs.Info:AddParagraph({
        Title = "Executor",
        Content = "Detected: " .. executorName
    })

    Tabs.Info:AddParagraph({
        Title = "Performance",
        Content = "FPS: " .. fps
    })

    task.spawn(function()
        while true do
            local paragraph = Tabs.Info:GetParagraphs()[3]
            if paragraph then
                paragraph:SetContent("FPS: " .. fps)
            end
            task.wait(1)
        end
    end)
end

do -- Player tab
    local speedSlider = Tabs.Player:AddSlider("Slider", {
        Title = "Walk Speed",
        Description = "Change your walk speed",
        Default = 16,
        Min = 0,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            local player = game.Players.LocalPlayer
            if player and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = Value
                end
            end
        end
    })

    local function applyWalkSpeedToCharacter(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.WalkSpeed = speedSlider.Value
        end
    end

    local player = game.Players.LocalPlayer
    if player then
        if player.Character then
            applyWalkSpeedToCharacter(player.Character)
        end
        player.CharacterAdded:Connect(applyWalkSpeedToCharacter)
    end

    speedSlider:SetValue(16)

    local cframeSpeedSlider = Tabs.Player:AddSlider("CFrameSpeedValue", {
        Title = "CFrame Speed",
        Description = "Adjust how fast CFrame speed is",
        Default = 2,
        Min = 0,
        Max = 10,
        Rounding = 1,
        Callback = function(Value)
        end
    })

    local runningCFrameSpeed = false
    local cframeConnection

    local cframeToggle = Tabs.Player:AddToggle("CFrameSpeedToggle", {
        Title = "CFrame WalkSpeed",
        Description = "Boosts walk speed using CFrame",
        Default = false,
        Callback = function(state)
            runningCFrameSpeed = state
            if cframeConnection then
                cframeConnection:Disconnect()
                cframeConnection = nil
            end
            if runningCFrameSpeed then
                cframeConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    if not player then return end
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                        local hrp = char.HumanoidRootPart
                        local hum = char.Humanoid
                        if hum.MoveDirection.Magnitude > 0 then
                            hrp.CFrame = hrp.CFrame + (hum.MoveDirection.Unit * cframeSpeedSlider.Value)
                        end
                    end
                end)
            end
        end
    })
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("Crimzi")
SaveManager:SetFolder("Crimzi/mic-up")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Mic Up",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
