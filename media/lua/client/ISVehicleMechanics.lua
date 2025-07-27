local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local GlobalOilLevel

local _ISVehicleMechanics_doPartContextMenu = ISVehicleMechanics.doPartContextMenu
---@param part VehiclePart the vehicle to get the oil level
function ISVehicleMechanics:doPartContextMenu(part, x, y)
    _ISVehicleMechanics_doPartContextMenu(self, part, x, y)

    local player = getSpecificPlayer(self.playerNum)

    if part:getId() == "Dipstick" and part:getInventoryItem() ~= nil then
        option = self.context:addOption(getText("IGUI_CheckOil"), player, ISVehicleMechanics.onCheckOilLevel, part)
        self:doMenuTooltip(part, option, "takeengineparts");
    end
end

local _ISVehicleMechanics_renderPartDetail = ISVehicleMechanics.renderPartDetail
function ISVehicleMechanics:renderPartDetail(part)
    -- Store original drawText
    local originalDrawText = self.drawText
    local lastY = nil

    -- Override drawText to track the last Y used
    self.drawText = function(this, text, x, y, r, g, b, a)
        lastY = y
        originalDrawText(this, text, x, y, r, g, b, a)
    end

    -- Call original function (this will trigger our drawText override)
    _ISVehicleMechanics_renderPartDetail(self, part)

    -- Restore original drawText
    self.drawText = originalDrawText

    -- Only draw if we know where to start
    if lastY and part:getId() == "Dipstick" then
        local x = self.xCarTexOffset + (self.width - 10 - self.xCarTexOffset) / 2
        local lineHgt = FONT_HGT_SMALL
        local y = lastY + lineHgt -- Continue from last Y

        if part:getInventoryItem() ~= nil then
            if GlobalOilLevel ~= nil then
                self:drawText(getText("IGUI_OilLevel") .. ": " .. round(GlobalOilLevel, 2), x, y, 1, 1, 1, 1)
            else
                self:drawText(getText("IGUI_OilLevel") .. ": " .. "?", x, y, 1, 1, 1, 1)
            end
        end
    end
end


function ISVehicleMechanics.onCheckOilLevel(player, part)
	if player:getVehicle() then
		ISVehicleMenu.onExit(player)
	end

	ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(player, part:getVehicle(), part:getArea()))

	local engineCover = nil
	local doorPart = part:getVehicle():getPartById("EngineDoor")
	if doorPart and doorPart:getDoor() and not doorPart:getDoor():isOpen() then
		engineCover = doorPart
	end

	if engineCover then
		-- The hood is magically unlocked if any door/window is broken/open/uninstalled.
		-- If the player can get in the vehicle, they can pop the hood, no key required.
		if engineCover:getDoor():isLocked() and VehicleUtils.RequiredKeyNotFound(part, player) then
			ISTimedActionQueue.add(ISUnlockVehicleDoor:new(player, engineCover))
		end
		ISTimedActionQueue.add(ISOpenVehicleDoor:new(player, part:getVehicle(), engineCover))
		GlobalOilLevel = part:getVehicle():getPartById("Engine"):getModData().oilLevel
		ISTimedActionQueue.add(ISCloseVehicleDoor:new(player, part:getVehicle(), engineCover))
	else
		GlobalOilLevel = part:getVehicle():getPartById("Engine"):getModData().oilLevel
	end
end