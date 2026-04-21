--[[
  Rolling 1-hour instance enter log (WoW 3.3.5): one SV row per fresh dungeon/raid enter,
  keyed by server time. Core.lua calls BossTrackerLockout_RecordNewInstanceEnter when
  BossTrackerDB.runs gets a new row for a new instance id.

  Ticker UI: inner plot 120×60 (bottom-left origin). X = rolling hour in 30s columns (newest on
  the right); Y = instance count at that enter (1 px per count, capped at 60). Every 30s we also
  record snapshots (current #enters) so the chart stays a regular time series. One summary line
  above the plot (GameFontNormal default color — same as BossTracker header; no SetTextColor).
]]

local PLOT_W = 120
local PLOT_H = 60
-- One line of GameFontNormal + small gap before the ticker (matches BossTracker title styling).
local LABEL_LINE_H = 14
local GAP_LABEL_TO_PLOT = 4
local BACKDROP_INSET_L, BACKDROP_INSET_R, BACKDROP_INSET_T, BACKDROP_INSET_B = 11, 12, 12, 11

local lockoutFrame
local lockoutLabel
local plotArea
local pixelPool = {}

-- Match Core.lua: GetServerTime() with time() fallback for older clients.
local function GetServerTimeSeconds()
  local gt = _G.GetServerTime
  if type(gt) == "function" then
    return gt()
  end
  if type(time) == "function" then
    return time()
  end
  return GetTime()
end

local function EnsureLockoutDB()
  if type(LockoutTrackerDB) ~= "table" then
    LockoutTrackerDB = {}
  end
  if type(LockoutTrackerDB.enters) ~= "table" then
    LockoutTrackerDB.enters = {}
  end
  if type(LockoutTrackerDB.snapshots) ~= "table" then
    LockoutTrackerDB.snapshots = {}
  end
end

-- ui = { point, relativeTo (global name string), relativePoint, x, y } — persisted with LockoutTrackerDB.
local function SaveLockoutFramePosition()
  if not lockoutFrame then
    return
  end
  local pt, rel, relPt, x, y = lockoutFrame:GetPoint(1)
  if type(pt) ~= "string" then
    return
  end
  EnsureLockoutDB()
  local relName = "UIParent"
  if rel and type(rel.GetName) == "function" then
    local n = rel:GetName()
    if type(n) == "string" and n ~= "" then
      relName = n
    end
  end
  LockoutTrackerDB.ui = type(LockoutTrackerDB.ui) == "table" and LockoutTrackerDB.ui or {}
  LockoutTrackerDB.ui.point = pt
  LockoutTrackerDB.ui.relativeTo = relName
  LockoutTrackerDB.ui.relativePoint = type(relPt) == "string" and relPt or pt
  LockoutTrackerDB.ui.x = type(x) == "number" and x or 0
  LockoutTrackerDB.ui.y = type(y) == "number" and y or 0
end

local function ApplyLockoutFramePosition()
  if not lockoutFrame then
    return false
  end
  EnsureLockoutDB()
  local ui = LockoutTrackerDB.ui
  if type(ui) ~= "table" then
    return false
  end
  local pt = ui.point
  local relName = ui.relativeTo
  local relPt = ui.relativePoint
  local x, y = ui.x, ui.y
  if type(pt) ~= "string" or type(relPt) ~= "string" then
    return false
  end
  if type(x) ~= "number" or type(y) ~= "number" then
    return false
  end
  local rel = UIParent
  if type(relName) == "string" and relName ~= "" then
    local g = _G[relName]
    if g then
      rel = g
    end
  end
  lockoutFrame:ClearAllPoints()
  lockoutFrame:SetPoint(pt, rel, relPt, x, y)
  return true
end

local ONE_HOUR_SEC = 3600
local PRUNE_INTERVAL_SEC = 30
-- One horizontal column per 30s → 120 columns = 3600s.
local TIME_SLOTS = PLOT_W

-- Remove entries whose startServerTime is more than one hour behind now.
local function LockoutTracker_PruneExpiredEntries()
  EnsureLockoutDB()
  local enters = LockoutTrackerDB.enters
  local now = GetServerTimeSeconds()
  for i = #enters, 1, -1 do
    local row = enters[i]
    local t = type(row) == "table" and row.startServerTime
    if type(t) ~= "number" or now - t > ONE_HOUR_SEC then
      table.remove(enters, i)
    end
  end
end

-- 30s chart samples: { startServerTime, count = #enters at sample time } — same 1h prune as enters.
local function LockoutTracker_PruneSnapshots()
  EnsureLockoutDB()
  local snaps = LockoutTrackerDB.snapshots
  local now = GetServerTimeSeconds()
  for i = #snaps, 1, -1 do
    local row = snaps[i]
    local t = type(row) == "table" and row.startServerTime
    if type(t) ~= "number" or now - t > ONE_HOUR_SEC then
      table.remove(snaps, i)
    end
  end
end

local function AcquirePixel(i)
  local t = pixelPool[i]
  if not t then
    t = plotArea:CreateTexture(nil, "OVERLAY")
    t:SetTexture("Interface\\Buttons\\WHITE8X8")
    t:SetVertexColor(1, 1, 1)
    t:SetWidth(1)
    t:SetHeight(1)
    pixelPool[i] = t
  end
  return t
end

-- Bottom-left origin: x grows right (time, newest on the right), y grows up (instance count).
local function PlotOneTickerPoint(used, startTime, countForY, now)
  if type(startTime) ~= "number" or type(countForY) ~= "number" then
    return used
  end
  local age = now - startTime
  if age < 0 or age > ONE_HOUR_SEC then
    return used
  end
  local slotFromLeft = TIME_SLOTS - 1 - math.floor(age / PRUNE_INTERVAL_SEC)
  if slotFromLeft < 0 then
    slotFromLeft = 0
  end
  if slotFromLeft > TIME_SLOTS - 1 then
    slotFromLeft = TIME_SLOTS - 1
  end
  local yPix = countForY - 1
  if yPix < 0 then
    yPix = 0
  end
  if yPix > PLOT_H - 1 then
    yPix = PLOT_H - 1
  end
  used = used + 1
  local tex = AcquirePixel(used)
  tex:ClearAllPoints()
  tex:SetPoint("BOTTOMLEFT", plotArea, "BOTTOMLEFT", slotFromLeft, yPix)
  tex:Show()
  return used
end

local function LockoutTracker_RedrawTicker()
  if not plotArea then
    return
  end
  EnsureLockoutDB()
  local now = GetServerTimeSeconds()
  local enters = LockoutTrackerDB.enters
  local snaps = LockoutTrackerDB.snapshots
  local used = 0

  for i = 1, #enters do
    local row = enters[i]
    if type(row) == "table" and type(row.startServerTime) == "number" and type(row.totalRows) == "number" then
      used = PlotOneTickerPoint(used, row.startServerTime, row.totalRows, now)
    end
  end

  for i = 1, #snaps do
    local row = snaps[i]
    if type(row) == "table" and type(row.startServerTime) == "number" and type(row.count) == "number" then
      used = PlotOneTickerPoint(used, row.startServerTime, row.count, now)
    end
  end

  for j = used + 1, #pixelPool do
    local tex = pixelPool[j]
    if tex then
      tex:Hide()
    end
  end
end

-- appendPeriodicSnapshot: true only from the 30s OnUpdate tick — records current #enters for the chart.
local function LockoutTracker_UpdateDisplay(appendPeriodicSnapshot)
  if not plotArea or not lockoutLabel then
    return
  end
  EnsureLockoutDB()
  LockoutTracker_PruneExpiredEntries()
  LockoutTracker_PruneSnapshots()
  local n = #LockoutTrackerDB.enters
  if appendPeriodicSnapshot then
    table.insert(LockoutTrackerDB.snapshots, {
      startServerTime = GetServerTimeSeconds(),
      count = n,
    })
  end
  lockoutLabel:SetText(string.format("%d instances/hour", n))
  LockoutTracker_RedrawTicker()
end

-- Called from Core.ApplyInstanceRunState when a new BossTrackerDB.runs row is created.
function BossTrackerLockout_RecordNewInstanceEnter(startServerTime)
  EnsureLockoutDB()
  LockoutTracker_PruneExpiredEntries()
  LockoutTracker_PruneSnapshots()
  local enters = LockoutTrackerDB.enters
  local t = type(startServerTime) == "number" and startServerTime or GetServerTimeSeconds()
  table.insert(enters, {
    startServerTime = t,
    totalRows = #enters + 1,
  })
  LockoutTracker_UpdateDisplay(false)
end

-- --- UI (separate from BossTracker main window; always visible) ---
lockoutFrame = CreateFrame("Frame", "BossTrackerLockoutFrame", UIParent)
lockoutFrame:SetFrameStrata("BACKGROUND")
lockoutFrame:SetFrameLevel(2)
local CONTENT_H = LABEL_LINE_H + GAP_LABEL_TO_PLOT + PLOT_H
lockoutFrame:SetWidth(PLOT_W + BACKDROP_INSET_L + BACKDROP_INSET_R)
lockoutFrame:SetHeight(CONTENT_H + BACKDROP_INSET_T + BACKDROP_INSET_B)
if not ApplyLockoutFramePosition() then
  lockoutFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 140)
end
lockoutFrame:SetMovable(true)
lockoutFrame:EnableMouse(true)
lockoutFrame:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
  tile = true,
  tileSize = 32,
  edgeSize = 32,
  insets = { left = 11, right = 12, top = 12, bottom = 11 },
})
lockoutFrame:SetBackdropColor(0, 0, 0, 0.85)

lockoutLabel = lockoutFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
lockoutLabel:SetJustifyH("CENTER")
lockoutLabel:SetPoint("TOPLEFT", lockoutFrame, "TOPLEFT", BACKDROP_INSET_L, -BACKDROP_INSET_T)
lockoutLabel:SetPoint("TOPRIGHT", lockoutFrame, "TOPRIGHT", -BACKDROP_INSET_R, -BACKDROP_INSET_T)
lockoutLabel:SetHeight(LABEL_LINE_H)
-- Same as BossTracker titleText: inherit GameFontNormal color (no SetTextColor in Core.lua).

plotArea = CreateFrame("Frame", nil, lockoutFrame)
plotArea:SetWidth(PLOT_W)
plotArea:SetPoint("BOTTOMLEFT", lockoutFrame, "BOTTOMLEFT", BACKDROP_INSET_L, BACKDROP_INSET_B)
plotArea:SetPoint("TOPLEFT", lockoutFrame, "TOPLEFT", BACKDROP_INSET_L, -(BACKDROP_INSET_T + LABEL_LINE_H + GAP_LABEL_TO_PLOT))

lockoutFrame:SetScript("OnMouseDown", function(self, button)
  if button == "LeftButton" then
    self:StartMoving()
  end
end)
lockoutFrame:SetScript("OnMouseUp", function(self)
  self:StopMovingOrSizing()
  SaveLockoutFramePosition()
end)
lockoutFrame:RegisterEvent("PLAYER_LOGOUT")
lockoutFrame:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_LOGOUT" then
    SaveLockoutFramePosition()
  end
end)

local pruneTicker = CreateFrame("Frame")
local pruneAccum = 0
pruneTicker:SetScript("OnUpdate", function(_, elapsed)
  pruneAccum = pruneAccum + elapsed
  if pruneAccum >= PRUNE_INTERVAL_SEC then
    pruneAccum = 0
    LockoutTracker_UpdateDisplay(true)
  end
end)

function BossTrackerLockout_ApplyFrameVisibility()
  if not lockoutFrame then
    return
  end
  if type(BossTrackerDB) == "table" and BossTrackerDB.showInstancesPerHourWindow == false then
    lockoutFrame:Hide()
  else
    lockoutFrame:Show()
  end
end

EnsureLockoutDB()
LockoutTracker_UpdateDisplay(false)
BossTrackerLockout_ApplyFrameVisibility()
