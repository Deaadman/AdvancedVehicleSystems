--- Backup original function
local _Vehicles_Create_Engine = Vehicles.Create.Engine

---Override Vehicles.Create.Engine
--- Set default oil level value at vehicle creation
---@param vehicle BaseVehicle
---@param part VehiclePart
function Vehicles.Create.Engine(vehicle, part)
    _Vehicles_Create_Engine(vehicle, part) -- call original function

    if part and EngineOil.getEngineOilLevel(vehicle) == 0 then
        EngineOil.setEngineOil(vehicle, ZombRandFloat(0, 100))
    end
end

---Override Vehicles.Create.Dipstick
--- Set default oil level value at vehicle creation
---@param vehicle BaseVehicle
---@param part VehiclePart
function Vehicles.Create.Dipstick(vehicle, part)
    VehicleUtils.createPartInventoryItem(part);
end

---Override Vehicles.UninstallTest.Dipstick
--- Set default oil level value at vehicle creation
function Vehicles.UninstallTest.Dipstick(vehicle, part, chr)
	Vehicles.UninstallTest.Default(vehicle, part, chr);
	ISVehicleMechanics.GlobalOilLevel = nil
	return true;
end