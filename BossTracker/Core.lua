--[[
  BossTracker — main window (3.3.5a)
  Boss kill detection: NPC id from UNIT_DIED destGUID (Koality-of-Life style).
  Trial of the Champion: optional completeOnYell matches DBM RegisterKill("yell", L.YellCombatEnd) — full-line equality on CHAT_MSG_MONSTER_YELL (see DBM-Dungeons DBM-Party-WotLK localization + onMonsterMessage killMsgs[msg]).
  See BossData.lua for per-boss id / ids / completeOnSpellId / completeOnYell.
]]

local frame = CreateFrame("Frame", "BossTrackerMainFrame", UIParent)
frame:SetFrameStrata("MEDIUM")
frame:SetFrameLevel(20)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
frame:SetWidth(320)
frame:SetMovable(true)

frame:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
  tile = true,
  tileSize = 32,
  edgeSize = 32,
  insets = { left = 11, right = 12, top = 12, bottom = 11 },
})
frame:SetBackdropColor(0, 0, 0, 0.85)

local TITLE_H = 28
local TITLE_BAR_TOP_INSET = 8
local GAP_TITLE_TO_BOSS = 10
local PAD_Y = 12
local LINE_STEP = 16

local titleBar = CreateFrame("Frame", nil, frame)
titleBar:SetHeight(TITLE_H)
titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -8)

local pinBtn = CreateFrame("Button", nil, titleBar, "UIPanelButtonTemplate")
pinBtn:SetWidth(70)
pinBtn:SetHeight(22)
pinBtn:SetPoint("RIGHT", titleBar, "RIGHT", 0, 0)

local resizeHandle = CreateFrame("Frame", nil, frame)
resizeHandle:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
resizeHandle:SetWidth(20)
resizeHandle:SetHeight(20)
resizeHandle:EnableMouse(true)

local resizeLine = resizeHandle:CreateTexture(nil, "OVERLAY")
resizeLine:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
resizeLine:SetWidth(10)
resizeLine:SetHeight(10)
resizeLine:SetPoint("BOTTOMRIGHT", resizeHandle, "BOTTOMRIGHT", -5, 5)
local x = 0.1 * 10 / 17
resizeLine:SetTexCoord(0.05 - x, 0.5, 0.05, 0.5 + x, 0.05, 0.5 - x, 0.5 + x, 0.5)

local timerText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
timerText:SetPoint("RIGHT", pinBtn, "LEFT", -8, 0)
timerText:SetText("00:00")

local titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetJustifyH("LEFT")
titleText:SetPoint("LEFT", titleBar, "LEFT", 4, 0)
titleText:SetPoint("RIGHT", timerText, "LEFT", -8, 0)
titleText:SetText("")

local bossArea = CreateFrame("Frame", nil, frame)
bossArea:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, -GAP_TITLE_TO_BOSS)
bossArea:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 8, PAD_Y)
bossArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, PAD_Y)

-- [i] = { name = FontString, time = FontString }
local bossRows = {}

-- [npcId] = { kind = "single"|"multi"|"phaseKill", name = string, allIds = table?, multiKill = number?, all = bool?, any = bool? }
local npcLookup = {}
local npcLookupInstance = nil
-- [bossDisplayName] = true
local defeatedNames = {}
-- [bossDisplayName] = elapsed seconds when first defeated (for sort + MM:SS display)
local defeatElapsedAt = {}
-- indices into BossTracker_BossData instance list: killed first by timer, then unkilled in raid order
local displayOrder = {}
-- [bossDisplayName] = { [npcId] = true, ... } for multi-kill rows
local multikillDead = {}
-- [boss display name] = count; same NPC id, multiple deaths (Trial of the Champion: The Black Knight)
local phaseKillCounts = {}
-- Instance run timer (must be declared before MarkBossDefeated so the closure sees this local, not a nil global)
local timerStart = nil
local timerPausedAt = nil
-- Scarlet Monastery only: last wing we resolved from subzone; kept through generic hallways until leaving instance.
local smPinnedWingIndex = nil
-- Dire Maul only: last wing we resolved from subzone; kept through generic hallways until leaving instance.
local dmPinnedWingIndex = nil

local function NormalizeBossEntry(entry)
  if type(entry) == "string" then
    return { name = entry, id = nil, ids = nil }
  end
  return entry
end

-- WotLK 3.3.5 creature GUID -> NPC id (same layout as Koality-of-Life)
local function ExtractNPCIDFromGUID(guid)
  if not guid then
    return nil
  end
  local guidStr = tostring(guid)
  if guidStr:sub(1, 2) == "0x" then
    guidStr = guidStr:sub(3)
  end
  if #guidStr >= 10 then
    local npcIdHex = guidStr:sub(7, 10)
    return tonumber(npcIdHex, 16)
  end
  return nil
end

-- Blizzard layout uses hideCaster; some builds omit it — try both.
local function GetDestGUIDFromCombatLog(...)
  local g8 = select(8, ...)
  if type(g8) == "string" and g8:sub(1, 2) == "0x" then
    return g8
  end
  local g6 = select(6, ...)
  if type(g6) == "string" and g6:sub(1, 2) == "0x" then
    return g6
  end
  return g8
end

local function ClearDetectionState()
  npcLookupInstance = nil
  smPinnedWingIndex = nil
  dmPinnedWingIndex = nil
  wipe(npcLookup)
  wipe(defeatedNames)
  wipe(defeatElapsedAt)
  wipe(multikillDead)
  wipe(phaseKillCounts)
end

local function GetScarletMonasteryWingIndex()
  local wings = BossTracker_ScarletMonasteryWings
  if not wings then
    return nil
  end
  local sub = GetSubZoneText()
  if not sub or sub == "" then
    return nil
  end
  for i, wing in ipairs(wings) do
    for _, m in ipairs(wing.match) do
      if m == sub then
        return i
      end
    end
  end
  return nil
end

-- When subzone matches a wing, pin that wing. When it is generic (e.g. "Scarlet Monastery" in hallways), keep the pin
-- so the list does not jump back to all seven bosses. Pin clears in ClearDetectionState (leave instance).
local function GetEffectiveScarletWingIndex()
  local idx = GetScarletMonasteryWingIndex()
  if idx then
    smPinnedWingIndex = idx
  end
  return smPinnedWingIndex
end

local function GetDireMaulWingIndex()
  local wings = BossTracker_DireMaulWings
  if not wings then
    return nil
  end
  local sub = GetSubZoneText()
  if not sub or sub == "" then
    return nil
  end
  for i, wing in ipairs(wings) do
    for _, m in ipairs(wing.match) do
      if m == sub then
        return i
      end
    end
  end
  return nil
end

local function GetEffectiveDireMaulWingIndex()
  local idx = GetDireMaulWingIndex()
  if idx then
    dmPinnedWingIndex = idx
  end
  return dmPinnedWingIndex
end

local function FilterBossListForPlayer(baseList)
  if not baseList then
    return nil
  end
  if UnitFactionGroup("player") ~= "Alliance" then
    return baseList
  end
  local needsFilter = false
  for _, raw in ipairs(baseList) do
    local e = NormalizeBossEntry(raw)
    if e.hideIfAlliance then
      needsFilter = true
      break
    end
  end
  if not needsFilter then
    return baseList
  end
  local filtered = {}
  for _, raw in ipairs(baseList) do
    local e = NormalizeBossEntry(raw)
    if not e.hideIfAlliance then
      table.insert(filtered, raw)
    end
  end
  return filtered
end

local function GetActiveBossList(instanceName)
  if not BossTracker_BossData or not instanceName then
    return nil
  end
  if instanceName ~= "Scarlet Monastery" and instanceName ~= "Dire Maul" then
    return FilterBossListForPlayer(BossTracker_BossData[instanceName])
  end
  if instanceName == "Scarlet Monastery" then
    local smEffective = GetEffectiveScarletWingIndex()
    if smEffective and BossTracker_ScarletMonasteryWings and BossTracker_ScarletMonasteryWings[smEffective] then
      return FilterBossListForPlayer(BossTracker_ScarletMonasteryWings[smEffective].bosses)
    end
    return FilterBossListForPlayer(BossTracker_ScarletMonasteryMerged)
  end
  local dmEffective = GetEffectiveDireMaulWingIndex()
  if dmEffective and BossTracker_DireMaulWings and BossTracker_DireMaulWings[dmEffective] then
    return FilterBossListForPlayer(BossTracker_DireMaulWings[dmEffective].bosses)
  end
  return FilterBossListForPlayer(BossTracker_DireMaulMerged)
end

local function GetNpcLookupCacheKey(instanceName)
  if instanceName == "Scarlet Monastery" then
    local effective = GetEffectiveScarletWingIndex()
    if effective then
      return instanceName .. "#w" .. tostring(effective)
    end
    return instanceName .. "#merge"
  end
  if instanceName == "Dire Maul" then
    local effective = GetEffectiveDireMaulWingIndex()
    if effective then
      return instanceName .. "#w" .. tostring(effective)
    end
    return instanceName .. "#merge"
  end
  return instanceName
end

local function RebuildNpcLookup(cacheKey, list)
  if npcLookupInstance == cacheKey then
    return
  end
  npcLookupInstance = cacheKey
  wipe(npcLookup)
  local data = list
  if not data then
    return
  end
  for _, raw in ipairs(data) do
    local e = NormalizeBossEntry(raw)
    local displayName = e.name
    if type(e.multiKill) == "number" and e.multiKill > 1 and e.id then
      npcLookup[e.id] = { kind = "phaseKill", name = displayName, multiKill = e.multiKill }
    elseif e.id then
      npcLookup[e.id] = { kind = "single", name = displayName }
    end
    if e.ids and #e.ids > 0 then
      local info = {
        kind = "multi",
        name = displayName,
        allIds = e.ids,
        all = e.all ~= false and not e.any,
        any = e.any == true,
      }
      for _, nid in ipairs(e.ids) do
        npcLookup[nid] = info
      end
    end
  end
end

local function FormatElapsed(seconds)
  if not seconds or seconds < 0 then
    seconds = 0
  end
  local m = math.floor(seconds / 60)
  local s = math.floor(seconds % 60)
  return string.format("%02d:%02d", m, s)
end

local function MarkBossDefeated(displayName)
  if defeatedNames[displayName] then
    return
  end
  defeatedNames[displayName] = true
  local elapsed = 0
  if timerPausedAt then
    elapsed = timerPausedAt
  elseif timerStart then
    elapsed = GetTime() - timerStart
  end
  defeatElapsedAt[displayName] = elapsed

  local instanceName = select(1, GetInstanceInfo())
  local list = GetActiveBossList(instanceName)
  if list and #list > 0 then
    local remaining = 0
    for _, raw in ipairs(list) do
      local e = NormalizeBossEntry(raw)
      if not defeatedNames[e.name] then
        remaining = remaining + 1
      end
    end
    if remaining == 0 and timerStart and not timerPausedAt then
      timerPausedAt = elapsed
      frame:SetScript("OnUpdate", nil)
    end
  end
end

-- DBM uses killMsgs[msg] == true on the raw yell (RegisterKill("yell", L.YellCombatEnd)); strip |c/|r so we still match.
local function NormalizeYellText(text)
  if not text then
    return ""
  end
  return tostring(text)
    :gsub("|c%x%x%x%x%x%x%x%x", "")
    :gsub("|r", "")
    :gsub("\226\128\153", "'")
    :gsub("\226\128\152", "'")
end

local function BossListHasYellRules(list)
  if not list then
    return false
  end
  for _, raw in ipairs(list) do
    local e = NormalizeBossEntry(raw)
    if e.completeOnYell then
      return true
    end
  end
  return false
end

local function TryMarkYellComplete(normalizedMsg)
  if not BossTracker_BossData or normalizedMsg == "" then
    return false
  end
  local instanceName = select(1, GetInstanceInfo())
  local list = GetActiveBossList(instanceName)
  if not list or not BossListHasYellRules(list) then
    return false
  end
  local changed = false
  for _, raw in ipairs(list) do
    local e = NormalizeBossEntry(raw)
    local y = e.completeOnYell
    if y then
      local matched = false
      if type(y) == "string" then
        matched = NormalizeYellText(y) == normalizedMsg
      elseif type(y) == "table" then
        for _, p in ipairs(y) do
          if NormalizeYellText(p) == normalizedMsg then
            matched = true
            break
          end
        end
      end
      if matched then
        if not defeatedNames[e.name] then
          MarkBossDefeated(e.name)
          changed = true
        end
      end
    end
  end
  return changed
end

local function BossListHasEmoteRules(list)
  if not list then
    return false
  end
  for _, raw in ipairs(list) do
    local e = NormalizeBossEntry(raw)
    if e.completeOnEmote then
      return true
    end
  end
  return false
end

local function TryMarkEmoteComplete(normalizedMsg)
  if not BossTracker_BossData or normalizedMsg == "" then
    return false
  end
  local instanceName = select(1, GetInstanceInfo())
  local list = GetActiveBossList(instanceName)
  if not list or not BossListHasEmoteRules(list) then
    return false
  end
  local changed = false
  for _, raw in ipairs(list) do
    local e = NormalizeBossEntry(raw)
    local m = e.completeOnEmote
    if m then
      local matched = false
      if type(m) == "string" then
        matched = NormalizeYellText(m) == normalizedMsg
      elseif type(m) == "table" then
        for _, p in ipairs(m) do
          if NormalizeYellText(p) == normalizedMsg then
            matched = true
            break
          end
        end
      end
      if matched and not defeatedNames[e.name] then
        MarkBossDefeated(e.name)
        changed = true
      end
    end
  end
  return changed
end

local function TryMarkNpcKill(npcId)
  if not npcId then
    return
  end
  local info = npcLookup[npcId]
  if not info then
    return
  end
  if info.kind == "phaseKill" then
    if defeatedNames[info.name] then
      return
    end
    local need = info.multiKill or 1
    phaseKillCounts[info.name] = (phaseKillCounts[info.name] or 0) + 1
    if phaseKillCounts[info.name] >= need then
      MarkBossDefeated(info.name)
    end
    return
  end
  if info.kind == "single" then
    MarkBossDefeated(info.name)
    return
  end
  if info.kind == "multi" then
    local name = info.name
    if info.any then
      MarkBossDefeated(name)
      return
    end
    multikillDead[name] = multikillDead[name] or {}
    multikillDead[name][npcId] = true
    local need = 0
    for _, nid in ipairs(info.allIds) do
      if multikillDead[name][nid] then
        need = need + 1
      end
    end
    if need >= #info.allIds then
      MarkBossDefeated(name)
    end
  end
end

local function GetSpellIdFromCombatLog(...)
  -- Different cores/builds can shift SPELL_* payload indices; probe likely slots.
  for i = 9, 14 do
    local v = select(i, ...)
    if type(v) == "number" then
      return v
    end
    if type(v) == "string" then
      local n = tonumber(v)
      if n then
        return n
      end
    end
  end
  return nil
end

local function TryMarkSpellComplete(spellId)
  if not spellId or not BossTracker_BossData then
    return false
  end
  local instanceName = select(1, GetInstanceInfo())
  local list = GetActiveBossList(instanceName)
  if not list then
    return false
  end
  local changed = false
  for _, raw in ipairs(list) do
    local e = NormalizeBossEntry(raw)
    if e.completeOnSpellId and e.completeOnSpellId == spellId then
      MarkBossDefeated(e.name)
      changed = true
    end
  end
  return changed
end

local function ApplyFrameHeight(bossContentHeight)
  frame:SetHeight(TITLE_BAR_TOP_INSET + TITLE_H + GAP_TITLE_TO_BOSS + bossContentHeight + PAD_Y)
end

-- Defeated rows first, ascending by kill time; then undefeated in original BossData order.
local function BuildDisplayOrder(list)
  local n = #list
  local defeated = {}
  for i = 1, n do
    local e = NormalizeBossEntry(list[i])
    if defeatedNames[e.name] then
      table.insert(defeated, {
        index = i,
        elapsed = defeatElapsedAt[e.name] or 0,
      })
    end
  end
  table.sort(defeated, function(a, b)
    if a.elapsed ~= b.elapsed then
      return a.elapsed < b.elapsed
    end
    return a.index < b.index
  end)
  wipe(displayOrder)
  for _, v in ipairs(defeated) do
    table.insert(displayOrder, v.index)
  end
  for i = 1, n do
    local e = NormalizeBossEntry(list[i])
    if not defeatedNames[e.name] then
      table.insert(displayOrder, i)
    end
  end
end

local function RefreshBossList()
  local instanceName = select(1, GetInstanceInfo())
  local list = GetActiveBossList(instanceName) or {}
  local n = #list

  RebuildNpcLookup(GetNpcLookupCacheKey(instanceName), list)
  BuildDisplayOrder(list)

  for i = n + 1, #bossRows do
    bossRows[i].name:Hide()
    bossRows[i].time:Hide()
  end

  for slot = 1, n do
    local row = bossRows[slot]
    if not row then
      row = {}
      row.name = bossArea:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
      row.name:SetJustifyH("LEFT")
      row.time = bossArea:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
      row.time:SetJustifyH("RIGHT")
      bossRows[slot] = row
    end
    local dataIndex = displayOrder[slot]
    local e = NormalizeBossEntry(list[dataIndex])
    local bossName = e.name
    row.name:SetText(bossName)
    local yFromTop = (slot - 1) * LINE_STEP
    row.time:ClearAllPoints()
    row.name:ClearAllPoints()
    row.time:SetPoint("TOPRIGHT", bossArea, "TOPRIGHT", -4, -yFromTop)
    row.name:SetPoint("TOPLEFT", bossArea, "TOPLEFT", 4, -yFromTop)
    row.name:SetPoint("TOPRIGHT", row.time, "TOPLEFT", -8, 0)
    if defeatedNames[bossName] then
      row.name:SetTextColor(1, 0.2, 0.2)
      row.time:SetTextColor(1, 0.2, 0.2)
      row.time:SetText(FormatElapsed(defeatElapsedAt[bossName] or 0))
    else
      row.name:SetTextColor(1, 1, 0.82)
      row.time:SetTextColor(1, 1, 0.82)
      row.time:SetText("")
    end
    row.name:Show()
    row.time:Show()
  end

  ApplyFrameHeight(n * LINE_STEP)
end

local locked = false

local function UpdatePinButton()
  if locked then
    pinBtn:SetText("Unlock")
  else
    pinBtn:SetText("Lock")
  end
end

local function SetResizeBoundsCompat(target, minW, minH, maxW, maxH)
  if type(target.SetResizeBounds) == "function" then
    target:SetResizeBounds(minW, minH, maxW, maxH)
    return true
  end
  if type(target.SetMinResize) == "function" then
    target:SetMinResize(minW, minH)
  end
  if maxW and maxH and type(target.SetMaxResize) == "function" then
    target:SetMaxResize(maxW, maxH)
  end
  return type(target.SetResizable) == "function" and type(target.StartSizing) == "function"
end

local function UpdateResizeState()
  local canResize = type(frame.SetResizable) == "function" and type(frame.StartSizing) == "function"
  if canResize then
    frame:SetResizable(not locked)
    SetResizeBoundsCompat(frame, 260, 120)
  end
  if not locked and canResize then
    resizeHandle:Show()
  else
    resizeHandle:Hide()
  end
end

pinBtn:SetScript("OnClick", function()
  locked = not locked
  UpdatePinButton()
  UpdateResizeState()
end)

UpdatePinButton()
UpdateResizeState()

titleBar:EnableMouse(true)
titleBar:SetScript("OnMouseDown", function(_, button)
  if locked or button ~= "LeftButton" then
    return
  end
  frame:StartMoving()
end)
titleBar:SetScript("OnMouseUp", function()
  frame:StopMovingOrSizing()
end)

resizeHandle:SetScript("OnMouseDown", function(_, button)
  if locked or button ~= "LeftButton" then
    return
  end
  frame:StartSizing("BOTTOMRIGHT")
end)
resizeHandle:SetScript("OnMouseUp", function()
  frame:StopMovingOrSizing()
end)

local function IsDungeonOrRaid()
  local inInstance, instanceType = IsInInstance()
  if not inInstance then
    return false
  end
  return instanceType == "party" or instanceType == "raid"
end

local inTrackedInstance = false

local function UpdateTimerDisplay()
  if not timerStart then
    timerText:SetText("00:00")
    return
  end
  if timerPausedAt then
    timerText:SetText(FormatElapsed(timerPausedAt))
  else
    timerText:SetText(FormatElapsed(GetTime() - timerStart))
  end
end

local function StartTimerTick()
  frame:SetScript("OnUpdate", function()
    UpdateTimerDisplay()
  end)
end

local function StopTimerTick()
  frame:SetScript("OnUpdate", nil)
end

local function RefreshInstanceTitle()
  local name = select(1, GetInstanceInfo())
  if name and name ~= "" then
    titleText:SetText(name)
  else
    titleText:SetText("Instance")
  end
end

local function OnCombatLogEvent(...)
  if not IsDungeonOrRaid() then
    return
  end
  local ev = select(2, ...)
  if ev == "UNIT_DIED" then
    local guid = GetDestGUIDFromCombatLog(...)
    local npcId = ExtractNPCIDFromGUID(guid)
    TryMarkNpcKill(npcId)
    RefreshBossList()
    return
  end
  if ev == "SPELL_CAST_SUCCESS" or ev == "SPELL_CAST_START" then
    local spellId = GetSpellIdFromCombatLog(...)
    if spellId and TryMarkSpellComplete(spellId) then
      RefreshBossList()
    end
  end
end

local lastTrackedInstanceName = nil

local function UpdateVisibility()
  local now = IsDungeonOrRaid()
  if now then
    local instName = select(1, GetInstanceInfo())
    RefreshInstanceTitle()
    if inTrackedInstance and lastTrackedInstanceName and lastTrackedInstanceName ~= instName then
      ClearDetectionState()
      timerStart = GetTime()
      timerPausedAt = nil
      UpdateTimerDisplay()
    end
    if not inTrackedInstance then
      ClearDetectionState()
      timerStart = GetTime()
      timerPausedAt = nil
      StartTimerTick()
      UpdateTimerDisplay()
    end
    lastTrackedInstanceName = instName
    RefreshBossList()
    frame:Show()
    inTrackedInstance = true
  else
    if inTrackedInstance then
      timerStart = nil
      timerPausedAt = nil
      StopTimerTick()
      timerText:SetText("00:00")
      ClearDetectionState()
    end
    lastTrackedInstanceName = nil
    frame:Hide()
    inTrackedInstance = false
  end
end

local deferFrame = CreateFrame("Frame")
local function DeferUpdateVisibility()
  deferFrame:SetScript("OnUpdate", function(self)
    self:SetScript("OnUpdate", nil)
    UpdateVisibility()
  end)
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:RegisterEvent("ZONE_CHANGED")
eventFrame:RegisterEvent("CHAT_MSG_MONSTER_YELL")
eventFrame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
eventFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
eventFrame:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "PLAYER_ENTERING_WORLD" then
    DeferUpdateVisibility()
  elseif event == "ZONE_CHANGED_NEW_AREA" then
    UpdateVisibility()
  elseif event == "ZONE_CHANGED" then
    local instName = select(1, GetInstanceInfo())
    if IsDungeonOrRaid() and (instName == "Scarlet Monastery" or instName == "Dire Maul") then
      RefreshBossList()
    end
  elseif event == "CHAT_MSG_MONSTER_YELL" then
    if IsDungeonOrRaid() then
      local msg = select(1, ...)
      if msg and TryMarkYellComplete(NormalizeYellText(msg)) then
        RefreshBossList()
      end
    end
  elseif event == "CHAT_MSG_MONSTER_EMOTE" or event == "CHAT_MSG_RAID_BOSS_EMOTE" or event == "CHAT_MSG_TEXT_EMOTE" then
    if IsDungeonOrRaid() then
      local msg = select(1, ...)
      if msg and TryMarkEmoteComplete(NormalizeYellText(msg)) then
        RefreshBossList()
      end
    end
  elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
    OnCombatLogEvent(...)
  end
end)

UpdateVisibility()
