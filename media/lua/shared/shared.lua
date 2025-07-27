EngineOil = {}

--- Get the engine oil level from a vehicle.
---@param vehicle BaseVehicle The vehicle in which the engine oil is retrieved.
---@return number OilLevel Returns the oil level or 0.
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

--- Set vehicles engine oil level.
---@param vehicle BaseVehicle The vehicle in which the engines oil level is set.
---@param oilLevel number The value in which the oil level for the engine is going to be set to.
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