--[[
  Interface → AddOns → BossTracker: show/hide main window and instances/hour ticker.
  Values live in BossTrackerDB (SavedVariablesPerCharacter); defaults applied in Core EnsureDB().
]]

local panel = CreateFrame("Frame", "BossTrackerOptionsPanel", InterfaceOptionsFramePanelContainer)
panel.name = "BossTracker"
panel:Hide()

local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("BossTracker")

local cbMain = CreateFrame("CheckButton", "BossTrackerOptMain", panel, "InterfaceOptionsCheckButtonTemplate")
cbMain:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
_G[cbMain:GetName() .. "Text"]:SetText("Show boss tracker window in dungeons and raids")

local cbIPH = CreateFrame("CheckButton", "BossTrackerOptIPH", panel, "InterfaceOptionsCheckButtonTemplate")
cbIPH:SetPoint("TOPLEFT", cbMain, "BOTTOMLEFT", 0, -8)
_G[cbIPH:GetName() .. "Text"]:SetText("Show instances per hour window")

local function ApplyClickStateToDB(self, key)
  if type(BossTrackerDB) ~= "table" then
    BossTrackerDB = {}
  end
  local on = self:GetChecked()
  BossTrackerDB[key] = on and true or false
  if type(BossTracker_RefreshOptionsVisibility) == "function" then
    BossTracker_RefreshOptionsVisibility()
  end
end

cbMain:SetScript("OnClick", function(self)
  ApplyClickStateToDB(self, "showMainWindow")
end)

cbIPH:SetScript("OnClick", function(self)
  ApplyClickStateToDB(self, "showInstancesPerHourWindow")
end)

function panel.okay()
end

function panel.cancel()
end

function panel.default()
  if type(BossTrackerDB) ~= "table" then
    BossTrackerDB = {}
  end
  BossTrackerDB.showMainWindow = true
  BossTrackerDB.showInstancesPerHourWindow = true
  cbMain:SetChecked(true)
  cbIPH:SetChecked(true)
  if type(BossTracker_RefreshOptionsVisibility) == "function" then
    BossTracker_RefreshOptionsVisibility()
  end
end

function panel.refresh()
  if type(BossTracker_RefreshOptionsVisibility) == "function" then
    BossTracker_RefreshOptionsVisibility()
  end
  cbMain:SetChecked(type(BossTrackerDB) == "table" and BossTrackerDB.showMainWindow ~= false)
  cbIPH:SetChecked(type(BossTrackerDB) == "table" and BossTrackerDB.showInstancesPerHourWindow ~= false)
end

InterfaceOptions_AddCategory(panel)
