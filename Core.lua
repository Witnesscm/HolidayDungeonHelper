local _, ns = ...
local Addon = ns.Addon

local timeToWait = 3

function Addon:QueueDungeon(dungeonID)
	if self.db.profile.allRoles then
		SetLFGRoles(true, true, true, true)
	end

	if self.db.profile.autoQueue then
		_G.LFDQueueFrame.type = dungeonID
		_G.LFDQueueFrameFindGroupButton:Click()
	end
end

function Addon:AutoEnterDungeon()
	if not Addon.dungeonID then return end

	_G.LFGDungeonReadyDialog:HookScript("OnShow", function(self)
		if _G.LFGDungeonReadyPopup.dungeonID and _G.LFGDungeonReadyPopup.dungeonID == Addon.dungeonID then
			self.enterButton:Click()
		end
	end)
end

function Addon:OnEnable()
	C_Timer.After(timeToWait, function()
		for i = 1, GetNumRandomDungeons() do
			local id = GetLFGRandomDungeonInfo(i)
			if id and ns.HolidayDungeons[id] then
				self.dungeonID = id
				break
			end
		end

		if not self.dungeonID then
			return
		end

		local info = ns.HolidayDungeons[self.dungeonID]

		if not self.db.profile[info.name] then return end

		local doneToday = GetLFGDungeonRewards(self.dungeonID)
		if not doneToday then
			local rewardID = select(6, GetLFGDungeonRewardInfo(self.dungeonID, 1))
			if rewardID and rewardID == info.rewardID then
				self:QueueDungeon(self.dungeonID)
				self:AutoEnterDungeon()
				self:RegisterEvent("LFG_COMPLETION_REWARD")
			end
		end
	end)
end

function Addon:LFG_COMPLETION_REWARD(event)
	if self.db.profile.autoLeave then
		local delay = self.db.profile.autoLeaveDelay

		C_Timer.After(delay, function()
			C_PartyInfo.LeaveParty()
		end)
	end

	self:UnregisterEvent(event)
end