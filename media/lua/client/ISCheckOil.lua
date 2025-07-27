require "TimedActions/ISBaseTimedAction"

ISCheckOil = ISBaseTimedAction:derive("ISCheckOil")

function ISCheckOil:isValid()
	return true;
end

function ISCheckOil:waitToStart()
	self.character:faceThisObject(self.vehicle)
	return self.character:shouldBeTurning()
end

function ISCheckOil:update()
	self.character:faceThisObject(self.vehicle)
end

function ISCheckOil:start()
	self:setActionAnim("VehicleWorkOnMid")
end

function ISCheckOil:stop()
	ISBaseTimedAction.stop(self)
end

function ISCheckOil:perform()
	ISBaseTimedAction.perform(self)
	self.vehicle:getPartById("Engine"):getModData().hasCheckedOilLevel = true
end

function ISCheckOil:new(character, part, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.vehicle = part:getVehicle()
	o.part = part
	o.maxTime = time
	o.jobType = getText("IGUI_CheckingOilLevel")
	return o
end