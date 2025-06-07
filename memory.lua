
function doCheckbox(mem, address, name, value, original, type)
    address = bit.band(address, 0x1fffff)
    local pointer = mem + address
    pointer = ffi.cast(type, pointer)
    local changed
    local check
    local tempvalue = pointer[0]
    if tempvalue == original then check = false end
    if tempvalue == value then check = true else check = false end
    changed, check = imgui.Checkbox(name, check)
    if changed then
        if check then pointer[0] = value else pointer[0] = original end
    end
end

function forceCheckbox(mem, address, name, off, on, check, type)
    address = bit.band(address, 0x1fffff)
    local pointer = mem + address
    pointer = ffi.cast(type, pointer)
    local changed
    changed, check = imgui.Checkbox(name, check)
    --if changed then
    if check then pointer[0] = on else pointer[0] = off end
    return check
end

-- Declare a helper function with the following arguments:
--   mem: the ffi object representing the base pointer into the main RAM
--   address: the address of the uint32_t to monitor and mutate
--   name: the label to display in the UI
--   min, max: the minimum and maximum values of the slider
function doSliderInt(mem, address, name, min, max, type)
    address = bit.band(address, 0x1fffff)
    local pointer = mem + address
    pointer = ffi.cast(type, pointer)
    local value = pointer[0]
    local changed
    changed, value = imgui.SliderInt(name, value, min, max, '%d')
    if changed then pointer[0] = value end
end

function readValue(mem, address, type)
    address = bit.band(address, 0x1fffff)
    local pointer = mem + address
    pointer = ffi.cast(type, pointer)
    local value = pointer[0]
    return value
end

function setValue(mem, address, value, type)
    address = bit.band(address, 0x1fffff)
    local pointer = mem + address
    pointer = ffi.cast(type, pointer)
    pointer[0] = value
end

function checkValue(mem, address, value, type)
    local tempvalue = readValue(mem, address, type)
    if tempvalue == value then
        check = true
    end
    return check
end

function readPointerValue(mem, pointerAddress, valueType)
    -- Read the address stored at pointerAddress
    local addr = bit.band(pointerAddress, 0x1fffff)
    local ptrToAddress = mem + addr
    ptrToAddress = ffi.cast("uint32_t*", ptrToAddress)
    local targetAddress = ptrToAddress[0]  -- e.g. 0x80123456

    -- Read the value at the pointed-to address
    local finalAddr = bit.band(targetAddress, 0x1fffff)
    local finalPointer = mem + finalAddr
    finalPointer = ffi.cast(valueType, finalPointer)
    return targetAddress, finalPointer[0]
end
