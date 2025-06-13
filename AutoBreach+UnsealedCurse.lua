-- Wait until the game is fully loaded
if not game:IsLoaded() then
    game.Loaded:Wait()
end

wait(5)

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Handle character respawning
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
end)

-- Function to teleport to the breach, fire its prompt, then interact with GUI
local function teleportAndFirePrompt(part)
    if not part:FindFirstChild("Breach") then return false end
    if not part.Breach:FindFirstChild("ProximityPrompt") then return false end
    
    local prompt = part.Breach.ProximityPrompt
    local humanoid = character:FindFirstChild("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then
        print("Character not fully loaded yet")
        return false
    end

    -- Teleport above the breach
    local teleportPosition = part.Position + Vector3.new(0, 3, 0)
    print("Teleporting to Breach in part: " .. part.Name)
    hrp.CFrame = CFrame.new(teleportPosition)
    
    -- Wait for ProximityPrompt to be usable
    task.wait(0.5)
    
    print("Firing ProximityPrompt...")
    fireproximityprompt(prompt)
    print("ProximityPrompt fired successfully!")

    -- Begin GUI selection logic (formerly the first script)
    local success, err = pcall(function()
        local breach = player:WaitForChild("PlayerGui"):WaitForChild("Breach")
        local container = breach:WaitForChild("Frame"):GetChildren()[4]
        local innerFrame = container:WaitForChild("Frame"):WaitForChild("Frame")
        local targetButton = innerFrame:GetChildren()[2]:GetChildren()[5].Frame:FindFirstChild("TextButton")

        if targetButton and targetButton:IsA("TextButton") then
            GuiService.SelectedObject = targetButton
            print("Selected target button:", targetButton.Name)

            -- Simulate pressing Enter
            task.delay(1, function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end)
        else
            warn("Target button not found or not a TextButton")
        end
    end)

    if not success then
        warn("Error accessing GUI:", err)
    end

    return true
end

-- Monitor loop for breaches
local function monitorBreaches()
    print("Breach monitor starting...")

    if not workspace:FindFirstChild("Lobby") then
        print("Waiting for Lobby to load...")
        repeat task.wait(1) until workspace:FindFirstChild("Lobby")
    end

    if not workspace.Lobby:FindFirstChild("Breaches") then
        print("Waiting for Breaches folder to load...")
        repeat task.wait(1) until workspace.Lobby:FindFirstChild("Breaches")
    end

    local breachesFolder = workspace.Lobby.Breaches
    print("Breaches folder found! Monitoring for Breach spawns...")

    while true do
        for _, part in pairs(breachesFolder:GetChildren()) do
            if part:IsA("BasePart") and part:FindFirstChild("Breach") then
                local success = teleportAndFirePrompt(part)
                if success then
                    print("Breach interaction complete! Waiting before next check...")
                    task.wait(10)
                end
            end
        end
        task.wait(1)
    end
end

-- Start the breach monitor
spawn(function()
    if not player.Character then
        character = player.CharacterAdded:Wait()
        task.wait(5)
    end
    monitorBreaches()
end)

-- --------------------------------------------------
-- Parte adicional: Interage com ProximityPrompt no mapa
-- --------------------------------------------------

local function activatePromptInsideMap()
    -- Posição conhecida do Model (fornecida por você)
    local fixedPosition = Vector3.new(-139.88156127929688, -55.84809875488281, 187.75396728515625)

    -- Função principal para ativar o ProximityPrompt dentro do mapa
    local function monitorAndActivatePrompt()
        while true do
            -- Garante que o personagem exista
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")

            -- Verifica se os objetos necessários existem
            local map = workspace:FindFirstChild("Map")
            if not map then
                warn("❌ Pasta 'Map' não encontrada. Tentando novamente em 5 segundos...")
                task.wait(5)
                continue
            end

            local shrine = map:FindFirstChild("Shrine")
            if not shrine then
                warn("❌ Objeto 'Shrine' não encontrado. Tentando novamente em 5 segundos...")
                task.wait(5)
                continue
            end

            local model = shrine:FindFirstChild("Model")
            if not model then
                warn("❌ Model não encontrado. Tentando novamente em 5 segundos...")
                task.wait(5)
                continue
            end

            local prompt = model:FindFirstChild("ProximityPrompt")
            if not prompt then
                warn("❌ ProximityPrompt não encontrado. Tentando novamente em 5 segundos...")
                task.wait(5)
                continue
            end

            print("✅ ProximityPrompt encontrado! Preparando ativação...")

            -- Calcular direção para trás
            local direction = hrp.CFrame.LookVector
            local teleportPosition = fixedPosition - direction * 5 + Vector3.new(0, 3, 0) -- 5 pra trás, 3 pra cima

            print("Teleportando até a posição:", teleportPosition)
            hrp.CFrame = CFrame.new(teleportPosition)

            task.wait(0.5) -- Espera o prompt ficar acessível

            print("Ativando ProximityPrompt...")
            fireproximityprompt(prompt)
            print("✅ ProximityPrompt ativado com sucesso!")

            -- Pausa antes de verificar novamente
            print("Aguardando 10 segundos antes da próxima verificação...\n")
            task.wait(10)
        end
    end

    -- Iniciar o monitoramento em paralelo
    spawn(monitorAndActivatePrompt)
end

-- Chama a função para interagir com o ProximityPrompt no mapa
activatePromptInsideMap()

print("Combined breach monitor + GUI interaction initialized.")