--- Creates the dipstick vehicle part.
---@param vehicle BaseVehicle The vehicle in which the dipstick is being attached to.
---@param part VehiclePart The part of the vehicle being added, which is the dipstick.
function Vehicles.Create.Dipstick(vehicle, part)
    VehicleUtils.createPartInventoryItem(part);
end

--- Backup original function
local _Vehicles_Create_Engine = Vehicles.Create.Engine

--- Adding onto existing logic from the original function.
--- Sets a random oil level for the engine at vehicle creation.
---@param vehicle BaseVehicle The vehicle in which the oil level is being set.
---@param part VehiclePart The part of the vehicle being added, which is the engine.
function Vehicles.Create.Engine(vehicle, part)
    _Vehicles_Create_Engine(vehicle, part) -- Call the original function to run the vanilla logic.

    if part and EngineOil.getEngineOilLevel(vehicle) == 0 then
        EngineOil.setEngineOil(vehicle, ZombRandFloat(0, 100))
    end
end

--- Resets the hasCheckedOilLevel boolean so when the player puts the dipstick back in...
--- It doesn't just immediately show the oil level again.
---@param vehicle BaseVehicle The vehicle in which the dipstick is being removed from.
---@param part VehiclePart The part of the vehicle being removed.
---@param chr IsoGameCharacter The character removing the vehicle part.
function Vehicles.UninstallTest.Dipstick(vehicle, part, chr)
    local canDo = Vehicles.UninstallTest.Default(vehicle, part, chr);

    if not canDo then
        return false
    end

    part:getVehicle():getPartById("Engine"):getModData().hasCheckedOilLevel = false

    return true
end