EngineOil = {}

---Get vehicle engine oil level
---@param vehicle BaseVehicle the vehicle to get the oil level
---@return number
function EngineOil.getEngineOilLevel(vehicle)
    vehicle = type(vehicle) == "number" and getVehicleById(vehicle) or vehicle
    if vehicle and instanceof(vehicle, "BaseVehicle") then
        local engine = vehicle:getPartById("Engine")
        if engine then
            local engineData = engine:getModData()
            return engineData.oilLevel or 0
        end
    end
    return 0
end

---Set vehicle engine oil level
---@param vehicle BaseVehicle the vehicle to set the oil level
---@param oilLevel number set the oil level value
function EngineOil.setEngineOil(vehicle, oilLevel)
    vehicle = type(vehicle) == "number" and getVehicleById(vehicle) or vehicle

    if vehicle and instanceof(vehicle, "BaseVehicle") then
        local engine = vehicle:getPartById("Engine")
        if engine then
            local engineData = engine:getModData()
            engineData.oilLevel = oilLevel
        end
    end
end