local player = game:GetService("Players").LocalPlayer
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "QuirkChangerUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 450) -- Aumentei a altura para 450
frame.Position = UDim2.new(0.5, -150, 0.5, -225)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Fechar botão (X) no canto superior direito
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
closeBtn.BorderSizePixel = 0
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.ZIndex = 2
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.Text = "Trash Trait Sniper"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.LayoutOrder = 0
title.Parent = frame

-- Scroll Frame para as quirks
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "ScrollingFrame"
scrollingFrame.Size = UDim2.new(1, -12, 0, 300) -- Aumentei a altura para 300
scrollingFrame.Position = UDim2.new(0, 6, 0, 40)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ClipsDescendants = true -- Importante para cortar elementos fora da tela
scrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
scrollingFrame.Parent = frame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 4)
uiListLayout.Parent = scrollingFrame

-- Quirk list
local quirks = {
    "Glitched", "Avatar", "Overlord", "Shinigami", "Entrepreneur", "All Seeing", "Demi God", "Cosmic", "Diamond", "Vulture", "Juggernaut", "Elemental Master", "Hyper Speed", "Golden", "Eagle Eye", "Sturdy 3", "Accelerate 3", "Scoped 3", "Shining", "Sturdy 2", "Accelerate 2", "Scoped 2", "Sturdy 1", "Accelerate 1", "Scoped 1"
}

local quirksPermitidas = {}

local function toggleQuirk(btn, quirk)
    if quirksPermitidas[quirk] then
        quirksPermitidas[quirk] = nil
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    else
        quirksPermitidas[quirk] = true
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end

for _, quirk in ipairs(quirks) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30) -- Altura fixa de 30px
    btn.Text = quirk
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.TextXAlignment = Enum.TextXAlignment.Center -- Centraliza o texto
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.LayoutOrder = 1
    btn.Parent = scrollingFrame

    btn.MouseButton1Click:Connect(function()
        toggleQuirk(btn, quirk)
    end)
end

-- Input field
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -12, 0, 30)
inputBox.Position = UDim2.new(0, 6, 0, 350)
inputBox.PlaceholderText = "Max trys"
inputBox.Text = ""
inputBox.Font = Enum.Font.SourceSans
inputBox.TextSize = 16
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
inputBox.ClearTextOnFocus = false
inputBox.LayoutOrder = 2
inputBox.Parent = frame

-- Start button
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(1, -12, 0, 35)
startBtn.Position = UDim2.new(0, 6, 0, 390)
startBtn.Text = "Start"
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.Font = Enum.Font.SourceSansBold
startBtn.TextSize = 18
startBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
startBtn.LayoutOrder = 3
startBtn.Parent = frame

-- Função para pressionar botão de troca
local function pressionarBotaoTrocar()
    local success, err = pcall(function()
        local quirksGui = player:WaitForChild("PlayerGui"):WaitForChild("Quirks")
        local frame = quirksGui:WaitForChild("Frame"):WaitForChild("Frame")
        local botaoFrame = frame:GetChildren()[6]:WaitForChild("Frame")
        local botao = botaoFrame:GetChildren()[3]

        if botao and botao:IsA("TextButton") then
            GuiService.SelectedObject = botao
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            print("🔁 Tentando trocar quirk...")
        end
    end)

    if not success then
        warn("Erro ao pressionar botão: " .. tostring(err))
    end
end

-- Verificar quirk atual
local function verificarQuirkAtual()
    local quirksGui = player:WaitForChild("PlayerGui"):WaitForChild("Quirks")
    local baseFrame = quirksGui:WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("Frame")
    local elementos = baseFrame:GetChildren()

    for _, candidato in ipairs(elementos) do
        if candidato:IsA("Frame") then
            local ok, result = pcall(function()
                local frame1 = candidato:GetChildren()[3]
                local frame2 = frame1:GetChildren()[3]
                local frame3 = frame2:GetChildren()[4]
                local textLabel = frame3:FindFirstChild("TextLabel")

                if textLabel and textLabel:IsA("TextLabel") and textLabel.Visible then
                    local quirk = textLabel.Text
                    print("🔍 Quirk atual: " .. quirk)
                    return quirk
                end
            end)

            if ok and result then
                return result
            end
        end
    end
end

-- Loop de troca
local function iniciarTrocas(maxTentativas)
    task.spawn(function()
        for i = 1, maxTentativas do
            local atual = verificarQuirkAtual()

            if atual and quirksPermitidas[atual] then
                print("✅ Encontrou quirk permitida: " .. atual)
                break
            else
                print("⛔ Quirk '" .. tostring(atual) .. "' não permitida. Tentativa " .. i)
                pressionarBotaoTrocar()
                task.wait(0.1)
            end
        end
    end)
end

-- Botão Start
startBtn.MouseButton1Click:Connect(function()
    local tentativas = tonumber(inputBox.Text)

    -- Validação do número de tentativas
    if not tentativas or tentativas <= 0 then
        StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "Insert a valid number of trys.",
            Duration = 3
        })
        return
    end

    -- Validação de pelo menos uma quirk selecionada
    if not next(quirksPermitidas) then
        StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "Select at least 1 trait to snipe.",
            Duration = 3
        })
        return
    end

    -- Inicia as trocas
    iniciarTrocas(tentativas)
end)
