local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small) -- From the original ISVehicleMechanics file.

--- Backup original function
local _ISVehicleMechanics_doPartContextMenu = ISVehicleMechanics.doPartContextMenu

--- Adding onto existing logic from the original function.
---@param part VehiclePart The vehicle part which is right-clicked.
---@param x number
---@param y number
function ISVehicleMechanics:doPartContextMenu(part, x, y)
    _ISVehicleMechanics_doPartContextMenu(self, part, x, y) -- Call the original function to run the vanilla logic.

    local player = getSpecificPlayer(self.playerNum)

    if part:getId() == "Dipstick" and part:getInventoryItem() ~= nil then
        option = self.context:addOption(getText("IGUI_CheckOilLevel"), player, ISVehicleMechanics.onCheckOilLevel, part)
        self:doMenuTooltip(part, option, "takeengineparts");
    end
end

--- Backup original function
local _ISVehicleMechanics_renderPartDetail = ISVehicleMechanics.renderPartDetail

--- Adding onto existing logic from the original function.
---@param part VehiclePart The vehicle part information which is rendered when selected.
function ISVehicleMechanics:renderPartDetail(part)
    -- Store original drawText
    local originalDrawText = self.drawText
    local lastY = nil

    -- Override drawText to track the last Y used
    self.drawText = function(this, text, x, y, r, g, b, a)
        lastY = y
        originalDrawText(this, text, x, y, r, g, b, a)
    end

    _ISVehicleMechanics_renderPartDetail(self, part) -- Call the original function to run the vanilla logic (this will trigger our drawText override).

    -- Restore original drawText
    self.drawText = originalDrawText

    -- Only draw if we know where to start
    if lastY and part:getId() == "Dipstick" then
        local x = self.xCarTexOffset + (self.width - 10 - self.xCarTexOffset) / 2
        local lineHgt = FONT_HGT_SMALL
        local y = lastY + lineHgt -- Continue from last Y

        if part:getInventoryItem() ~= nil then
            local engine = part:getVehicle():getPartById("Engine")

            if engine:getModData().hasCheckedOilLevel == true then
                self:drawText(getText("IGUI_OilLevel") .. ": " .. round(engine:getModData().oilLevel, 2), x, y, 1, 1, 1, 1)
            else
                self:drawText(getText("IGUI_OilLevel") .. ": " .. "?", x, y, 1, 1, 1, 1)
            end
        end
    end
end

--- A duplicate of ISVehicleMechanics.onRepairEngine with a couple modifications.
---@param player IsoGameCharacter The player performing this action.
---@param part VehiclePart The vehicle part on which this action is being performed.
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

    local engine = part:getVehicle():getPartById("Engine")

	if engineCover then
		-- The hood is magically unlocked if any door/window is broken/open/uninstalled.
		-- If the player can get in the vehicle, they can pop the hood, no key required.
		if engineCover:getDoor():isLocked() and VehicleUtils.RequiredKeyNotFound(part, player) then
			ISTimedActionQueue.add(ISUnlockVehicleDoor:new(player, engineCover))
		end
		ISTimedActionQueue.add(ISOpenVehicleDoor:new(player, part:getVehicle(), engineCover))
		engine:getModData().hasCheckedOilLevel = true
		ISTimedActionQueue.add(ISCloseVehicleDoor:new(player, part:getVehicle(), engineCover))
	else
		engine:getModData().hasCheckedOilLevel = true
	end
end