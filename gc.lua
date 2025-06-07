-- Global open flag
myWindowOpen = true
mem = PCSX.getMemPtr()
loadfile("memory.lua")()

function renderCharacterInfo(address, name, isKnight)
    local base_pointer = 0x80146600
    local knight_position_x = readValue(mem, base_pointer, "uint16_t*")
    local knight_position_height = readValue(mem, base_pointer + 2, "uint16_t*")
    local knight_position_y = readValue(mem, base_pointer + 4, "uint16_t*") 
    local pointer_1 = readPointerValue(mem, address + 0x18, "uint16_t*")
    local pointer_2 = readPointerValue(mem, address + 0x20, "uint16_t*")
    local pointer_3 = readPointerValue(mem, address + 0x24, "uint16_t*")
    local pointer_4 = readPointerValue(mem, address + 0x28, "uint16_t*")
    local pointer_5 = readPointerValue(mem, address + 0x2C, "uint16_t*")
 
    local position_x = readValue(mem, address, "uint16_t*")
    local position_height = readValue(mem, address + 2, "uint16_t*")
    local position_y = readValue(mem, address + 4, "uint16_t*")
    local input_enable_disable = readValue(mem, address + 0x12, "uint8_t*")
    local model_id = readValue(mem, address + 0x31, "uint8_t*")
    local direction = readValue(mem, address + 0x0F, "uint8_t*")

    if imgui.CollapsingHeader(name, ImGuiTreeNodeFlags_None) then
        if not isKnight then
            if imgui.Button("Teleport Knight to this position " .. name) then
                setValue(mem, base_pointer, position_x, "uint16_t*")
                setValue(mem, base_pointer + 2, position_height, "uint16_t*")
                setValue(mem, base_pointer + 4, position_y, "uint16_t*")
            end
        end
        if imgui.Button("Set to Knights Position " .. name) then
            setValue(mem, address, knight_position_x, "uint16_t*")
            setValue(mem, address + 2, knight_position_height, "uint16_t*")
            setValue(mem, address + 4, knight_position_y, "uint16_t*")
        end
    if imgui.Button("Open in Memory Editor " .. name) then
        PCSX.GUI.jumpToMemory(address)
    end
    if imgui.Button("Pointer 1" .. name) then
        PCSX.GUI.jumpToMemory(address + 0x18)
    end
    if imgui.Button("Pointer 2" .. name) then
        PCSX.GUI.jumpToMemory(address + 0x20)
    end
    if imgui.Button("Pointer 3" .. name) then
        PCSX.GUI.jumpToMemory(address + 0x24)
    end
    if imgui.Button("Pointer 4" .. name) then
        PCSX.GUI.jumpToMemory(address + 0x28)
    end
    if imgui.Button("Pointer 5" .. name) then
        PCSX.GUI.jumpToMemory(address + 0x2C)
    end
    
    imgui.TextUnformatted(name)
    imgui.TextUnformatted("Rotation: " .. tostring(direction))
    doSliderInt(mem, address, name .. " Position X", 0x0000, 0xFFFF, "uint16_t*")
    doSliderInt(mem, address + 2, name .. " Position Height", 0x0000, 0xFFFF, "uint16_t*")
    doSliderInt(mem, address + 4, name .. " Position Y", 0x0000, 0xFFFF, "uint16_t*")
    doSliderInt(mem, address + 0x0F, name .. " direction", 0x00, 0x0F, "uint8_t*")
    imgui.TextUnformatted("Position X: " .. tostring(position_x))
    imgui.TextUnformatted("Position Height: " .. tostring(position_height))
    imgui.TextUnformatted("Position Y: " .. tostring(position_y))
    imgui.TextUnformatted("Input Enable/Disable: " .. tostring(input_enable_disable))
    imgui.TextUnformatted("Model ID: " .. tostring(model_id))

    local ptr1, val1 = readPointerValue(mem, address + 0x18, "uint16_t*")
    local ptr2, val2 = readPointerValue(mem, address + 0x20, "uint16_t*")
    local ptr3, val3 = readPointerValue(mem, address + 0x24, "uint16_t*")
    local ptr4, val4 = readPointerValue(mem, address + 0x28, "uint16_t*")
    local ptr5, val5 = readPointerValue(mem, address + 0x2C, "uint16_t*")

    if imgui.Button("Go to Pointer 1 " .. name) then
        PCSX.GUI.jumpToMemory(ptr1)
    end
    if imgui.Button("Go to Pointer 2 " .. name) then
        PCSX.GUI.jumpToMemory(ptr2)
    end
    if imgui.Button("Go to Pointer 3 NPC_Coordinates " .. name) then
        PCSX.GUI.jumpToMemory(ptr3)
    end
    if imgui.Button("Go to Pointer 4 NPC_Name_Dialogue " .. name) then
        PCSX.GUI.jumpToMemory(ptr4)
    end
    if imgui.Button("Go to Pointer 5 " .. name) then
        PCSX.GUI.jumpToMemory(ptr5)
    end
    end
end

function characterInfo()
    if (imgui.CollapsingHeader("Character_Structs", ImGuiTreeNodeFlags_None)) then
        local base_pointer = 0x80146600
        local total_npcs_characters = readValue(mem, 0x801fdae4, "uint8_t*") -- Assuming this is the total NPCs count
        local total_npcs_entities = readValue(mem, 0x801fdaec, "uint8_t*") -- Assuming this is the total NPCs count
        imgui.TextUnformatted("Total NPCs Characters: " .. tostring(total_npcs_characters))
        for i = 0, total_npcs_entities do 
            if (i == 0) then
                renderCharacterInfo(base_pointer, "Knight", true)
            else 
                if (i == 2) then
                    imgui.TextUnformatted("Other Characters")
                end
                local character_name = "Character " .. tostring(i)
                local character_address = base_pointer + (i * 0x38) -- Assuming each character struct is 16 bytes
                if (i == 1) then
                    character_name = "Baby"
                end
                renderCharacterInfo(character_address, character_name, false)
            end
            imgui.Separator()
        end
    end
end

function DrawImguiFrame()
    if myWindowOpen then
        -- Pass the open flag by reference (as a return value)
        local isOpen
        isOpen, myWindowOpen = imgui.Begin("Guardians Crusade", myWindowOpen)
        
        if isOpen then
            imgui.TextUnformatted("Click the X to close this window.")
        end
        characterInfo()
        imgui.End()
    end
end