local ADDON, ns = ...
local Addon = LibStub("AceAddon-3.0"):NewAddon(ADDON, "AceEvent-3.0")

local L = {}
setmetatable(L, {
	__index = function(self, key) return key end
})

ns.Addon = Addon
ns.L = L
ns.Version = GetAddOnMetadata(ADDON, "Version")

_G[ADDON] = ns

local defaults = {
	profile = {
		autoQueue = true,
		allRoles = true,
		autoConfirm = true,
		autoLeave = true,
		autoLeaveDelay = 10,
	}
}

function Addon:OnInitialize()
	for _, info in pairs(ns.HolidayDungeons) do
		defaults.profile[info.name] = true
	end

	self.db = LibStub("AceDB-3.0"):New("HolidayDungeonHelperDB", defaults, true)
end

function Addon:Print(...)
	_G.DEFAULT_CHAT_FRAME:AddMessage("|cff99ccff"..ADDON..":|r " .. format(...))
end

function Addon:Error(...)
	_G.UIErrorsFrame:AddMessage("|cff99ccff"..format(...).."|r ")
end