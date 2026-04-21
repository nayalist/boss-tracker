-- BossTracker Boss Database (3.3.5a)
-- Maps GetInstanceInfo() instance name -> ordered list of bosses.
--
-- Notes:
-- - Instance names are locale-sensitive. This file uses EN-US names (common on private servers).
-- - If your client/server uses another locale, rename keys to match GetInstanceInfo().
--
-- Table entries may use (WotLK / TBC / Classic):
--   { name = "...", id = <npc id> } — single NPC death (UNIT_DIED, GUID -> id)
--   { name = "...", ids = { ... }, all = true } — council; all ids must die (default if any is false)
--   { name = "...", ids = { ... }, any = true } — any listed id (e.g. Gunship, VH normal/heroic pairs)
--   { name = "...", completeOnSpellId = <id> } — Valithria-style (no boss death)
--   { name = "...", completeOnYell = "..." or { "...", ... } } — full yell line equals string (after stripping |c/|r); same strings as DBM RegisterKill("yell", L.YellCombatEnd) in DBM-Party-WotLK localization.en.lua
--   { name = "...", completeOnEmote = "..." or { "...", ... } } — full emote line equals string from CHAT_MSG_MONSTER_EMOTE / CHAT_MSG_RAID_BOSS_EMOTE / CHAT_MSG_TEXT_EMOTE (same normalization as completeOnYell)
--   { name = "...", hideIfAlliance = true } — hide row for Alliance characters
--   { name = "...", id = <npc id>, multiKill = N } — same NPC id must die N times (e.g. The Black Knight phases)
--   { name = "...", search = "..." } — optional; server NPC name for .findnpc (defaults can match name)
-- Plain strings still work (display only until you add ids).

BossTracker_BossData = {
  ---------------------------------------------------------------------------
  -- Wrath of the Lich King (Raids)
  ---------------------------------------------------------------------------
  ["Naxxramas"] = {
    { name = "Anub'Rekhan", id = 15956 , search = "Anub'Rekhan"},
    { name = "Grand Widow Faerlina", id = 15953 , search = "Grand Widow Faerlina"},
    { name = "Maexxna", id = 15952 , search = "Maexxna"},
    { name = "Noth the Plaguebringer", id = 15954 , search = "Noth the Plaguebringer"},
    { name = "Heigan the Unclean", id = 15936 , search = "Heigan the Unclean"},
    { name = "Loatheb", id = 16011 , search = "Loatheb"},
    { name = "Patchwerk", id = 16028 , search = "Patchwerk"},
    { name = "Grobbulus", id = 15931 , search = "Grobbulus"},
    { name = "Gluth", id = 15932 , search = "Gluth"},
    { name = "Thaddius", id = 15928 , search = "Thaddius"},
    { name = "Instructor Razuvious", id = 16061 , search = "Instructor Razuvious"},
    { name = "Gothik the Harvester", id = 16060 , search = "Gothik the Harvester"},
    { name = "The Four Horsemen", ids = { 16063, 30549, 16064, 16065 }, all = true , search = "Baron Rivendare"},
    { name = "Sapphiron", id = 15989 , search = "Sapphiron"},
    { name = "Kel'Thuzad", id = 15990 , search = "Kel'Thuzad"},
  },
  ["The Obsidian Sanctum"] = {
    { name = "Sartharion", id = 28860 , search = "Sartharion"},
  },
  ["The Eye of Eternity"] = {
    { name = "Malygos", id = 28859 , search = "Malygos"},
  },
  ["Ulduar"] = {
    { name = "Flame Leviathan", id = 33113 , search = "Flame Leviathan"},
    { name = "Ignis the Furnace Master", id = 33118 , search = "Ignis the Furnace Master"},
    { name = "Razorscale", id = 33186 , search = "Razorscale"},
    { name = "XT-002 Deconstructor", id = 33293 , search = "XT-002 Deconstructor"},
    { name = "The Assembly of Iron", ids = { 32867, 32927, 32857 }, all = true , search = "Steelbreaker"},
    { name = "Kologarn", id = 32930 , search = "Kologarn"},
    { name = "Auriaya", id = 33515 , search = "Auriaya"},
    { name = "Hodir", completeOnYell = "I... I am released from his grasp... at last." , search = "Hodir"},
    { name = "Thorim", completeOnYell = "Stay your arms! I yield!" , search = "Thorim"},
    { name = "Freya", completeOnYell = "His hold on me dissipates. I can see clearly once more. Thank you, heroes." , search = "Freya"},
    { name = "Mimiron", completeOnYell = "It would appear that I've made a slight miscalculation. I allowed my mind to be corrupted by the fiend in the prison, overriding my primary directive. All systems seem to be functional now. Clear." , search = "Mimiron"},
    { name = "General Vezax", id = 33271 , search = "General Vezax"},
    { name = "Yogg-Saron", id = 33288 , search = "Yogg-Saron"},
    { name = "Algalon the Observer", completeOnYell = "I have seen worlds bathed in the Makers' flames, their denizens fading without as much as a whimper. Entire planetary systems born and razed in the time that it takes your mortal hearts to beat once. Yet all throughout, my own heart devoid of emotion... of empathy. I. Have. Felt. Nothing. A million-million lives wasted. Had they all held within them your tenacity? Had they all loved life as you do?" , search = "Algalon the Observer"},
  },
  ["Trial of the Crusader"] = {
    { name = "Northrend Beasts", id = 34797 , search = "Icehowl"},
    { name = "Lord Jaraxxus", id = 34780 , search = "Lord Jaraxxus"},
    { name = "Faction Champions", completeOnYell = { "GLORY TO THE ALLIANCE!", "That was just a taste of what the future brings. FOR THE HORDE!" } , search = "Barrett Ramsey"},
    { name = "Twin Val'kyr", id = 34497 , search = "Fjola Lightbane"},
    { name = "Anub'arak", id = 34564 , search = "Anub'arak"},
  },
  ["Onyxia's Lair"] = {
    { name = "Onyxia", id = 10184 , search = "Onyxia"},
  },
  ["Icecrown Citadel"] = {
    { name = "Lord Marrowgar", id = 36612 , search = "Lord Marrowgar"},
    { name = "Lady Deathwhisper", id = 36855 , search = "Lady Deathwhisper"},
    { name = "Gunship Battle", completeOnYell = { "Don't say I didn't warn ya, scoundrels! Onward, brothers and sisters!", "The Alliance falter. Onward to the Lich King!"} , search = "Muradin Bronzebeard"},
    { name = "Deathbringer Saurfang", id = 37813 , search = "Deathbringer Saurfang"},
    { name = "Festergut", id = 36626 , search = "Festergut"},
    { name = "Rotface", id = 36627 , search = "Rotface"},
    { name = "Professor Putricide", id = 36678 , search = "Professor Putricide"},
    { name = "Blood Prince Council", ids = { 37970, 37972, 37973 }, all = true , search = "Prince Valanar"},
    { name = "Blood-Queen Lana'thel", id = 37955 , search = "Blood-Queen Lana'thel"},
    { name = "Valithria Dreamwalker", completeOnSpellId = 71189 , search = "Valithria Dreamwalker"},
    { name = "Sindragosa", id = 36853 , search = "Sindragosa"},
    { name = "The Lich King", id = 36597 , search = "The Lich King"},
  },
  ["The Ruby Sanctum"] = {
    { name = "Baltharus the Warborn", id = 39751 , search = "Baltharus the Warborn"},
    { name = "Saviana Ragefire", id = 39747 , search = "Saviana Ragefire"},
    { name = "General Zarithrian", id = 39746 , search = "General Zarithrian"},
    { name = "Halion", id = 39863 , search = "Halion"},
  },
  ["Vault of Archavon"] = {
    { name = "Archavon the Stone Watcher", id = 31125 , search = "Archavon the Stone Watcher"},
    { name = "Emalon the Storm Watcher", id = 33993 , search = "Emalon the Storm Watcher"},
    { name = "Koralon the Flame Watcher", id = 35013 , search = "Koralon the Flame Watcher"},
    { name = "Toravon the Ice Watcher", id = 38433 , search = "Toravon the Ice Watcher"},
  },

  ---------------------------------------------------------------------------
  -- Wrath of the Lich King (Dungeons)
  ---------------------------------------------------------------------------
  ["Utgarde Keep"] = {
    { name = "Prince Keleseth", id = 23953 , search = "Prince Keleseth"},
    { name = "Skarvald the Constructor and Dalronn the Controller", ids = { 24200, 24201 }, all = true , search = "Skarvald the Constructor"},
    { name = "Ingvar the Plunderer", id = 23954 , search = "Ingvar the Plunderer"},
  },
  ["Utgarde Pinnacle"] = {
    { name = "Svala Sorrowgrave", completeOnYell = "Nooo! I did not come this far... to..." , search = "Svala Sorrowgrave"},
    { name = "Gortok Palehoof", id = 26687 , search = "Gortok Palehoof"},
    { name = "Skadi the Ruthless", id = 26693 , search = "Skadi the Ruthless"},
    { name = "King Ymiron", id = 26861 , search = "King Ymiron"},
  },
  ["The Nexus"] = {
    { name = "Commander Stoutbeard/Commander Kolurg", ids = { 26796, 26798 }, any = true , search = "Commander Stoutbeard"},
    { name = "Grand Magus Telestra", id = 26731 , search = "Grand Magus Telestra"},
    { name = "Anomalus", id = 26763 , search = "Anomalus"},
    { name = "Ormorok the Tree-Shaper", id = 26794 , search = "Ormorok the Tree-Shaper"},
    { name = "Keristrasza", id = 26723 , search = "Keristrasza"},
  },
  ["The Oculus"] = {
    { name = "Drakos the Interrogator", id = 27654 , search = "Drakos the Interrogator"},
    { name = "Varos Cloudstrider", id = 27447 , search = "Varos Cloudstrider"},
    { name = "Mage-Lord Urom", id = 27655 , search = "Mage-Lord Urom"},
    { name = "Ley-Guardian Eregos", id = 27656 , search = "Ley-Guardian Eregos"},
  },
  ["Azjol-Nerub"] = {
    { name = "Krik'thir the Gatewatcher", id = 28684 , search = "Krik'thir the Gatewatcher"},
    { name = "Hadronox", id = 28921 , search = "Hadronox"},
    { name = "Anub'arak", id = 29120 , search = "Anub'arak"},
  },
  ["Ahn'kahet: The Old Kingdom"] = {
    { name = "Elder Nadox", id = 29309 , search = "Elder Nadox"},
    { name = "Prince Taldaram", id = 29308 , search = "Prince Taldaram"},
    { name = "Jedoga Shadowseeker", id = 29310 , search = "Jedoga Shadowseeker"},
    { name = "Herald Volazj", id = 29311 , search = "Herald Volazj"},
    { name = "Amanitar", id = 30258 , search = "Amanitar"},
  },
  ["Drak'Tharon Keep"] = {
    { name = "Trollgore", id = 26630 , search = "Trollgore"},
    { name = "Novos the Summoner", id = 26631 , search = "Novos the Summoner"},
    { name = "King Dred", id = 27483 , search = "King Dred"},
    { name = "The Prophet Tharon'ja", id = 26632 , search = "The Prophet Tharon'ja"},
  },
  ["Gundrak"] = {
    { name = "Slad'ran", id = 29304 , search = "Slad'ran"},
    { name = "Drakkari Colossus", id = 29307 , search = "Drakkari Colossus"},
    { name = "Moorabi", id = 29305 , search = "Moorabi"},
    { name = "Eck the Ferocious", id = 29932 , search = "Eck the Ferocious"},
    { name = "Gal'darah", id = 29306 , search = "Gal'darah"},
  },
  ["Halls of Stone"] = {
    { name = "Krystallus", id = 27977 , search = "Krystallus"},
    { name = "Maiden of Grief", id = 27975 , search = "Maiden of Grief"},
    { name = "The Tribunal of Ages", completeOnYell = "Purge? No no no no no.. where did I-- Aha, this should do the trick..." , search = "The Tribunal of Ages"},
    { name = "Sjonnir the Ironshaper", id = 27978 , search = "Sjonnir the Ironshaper"},
  },
  ["Halls of Lightning"] = {
    { name = "General Bjarngrim", id = 28586 , search = "General Bjarngrim"},
    { name = "Volkhan", id = 28587 , search = "Volkhan"},
    { name = "Ionar", id = 28546 , search = "Ionar"},
    { name = "Loken", id = 28923 , search = "Loken"},
  },
  -- we list every possible spawn + Cyanigosa; kills still match via UNIT_DIED npc ids.
  ["The Violet Hold"] = {
    { name = "Erekem", id = 29315 , search = "Erekem"},
    { name = "Moragg", id = 29316 , search = "Moragg"},
    { name = "Ichoron", id = 29313 , search = "Ichoron"},
    { name = "Xevozz", id = 29266 , search = "Xevozz"},
    { name = "Lavanthor", id = 29312 , search = "Lavanthor"},
    { name = "Zuramat the Obliterator", id = 29314 , search = "Zuramat the Obliterator"},
    { name = "Cyanigosa", id = 31134 , search = "Cyanigosa"},
  },
  ["The Culling of Stratholme"] = {
    { name = "Meathook", id = 26529 , search = "Meathook"},
    { name = "Salramm the Fleshcrafter", id = 26530 , search = "Salramm the Fleshcrafter"},
    { name = "Chrono-Lord Epoch", id = 26532 , search = "Chrono-Lord Epoch"},
    { name = "Mal'Ganis", completeOnYell = "Your journey has just begun, young prince. Gather your forces and meet me in the arctic land of Northrend. It is there that we shall settle the score between us. It is there that your true destiny will unfold." , search = "Mal'Ganis"},
  },
  -- Yell strings: DeadlyBossMods/DBM-Dungeons DBM-Party-WotLK localization.en.lua (mods 634, 636, 635) — DBM killMsgs[msg] exact match.
  ["Trial of the Champion"] = {
    { name = "Grand Champions", completeOnYell = "Well fought! Your next challenge comes from the Crusade's own ranks. You will be tested against their considerable prowess.", search = "Arelas Brightstar" },
    { name = "Argent Champion", completeOnYell = { "Excellent work!", "I yield! I submit. Excellent work. May I run away now?" }, search = "Eadric the Pure" },
    { name = "The Black Knight", id = 35451, multiKill = 3 , search = "The Black Knight"},
  },
  ["The Forge of Souls"] = {
    { name = "Bronjahm", id = 36497 , search = "Bronjahm"},
    { name = "Devourer of Souls", id = 36502 , search = "Devourer of Souls"},
  },
  ["Pit of Saron"] = {
    { name = "Forgemaster Garfrost", id = 36494 , search = "Forgemaster Garfrost"},
    { name = "Ick and Krick", id = 36476 , search = "Ick"},
    { name = "Scourgelord Tyrannus", id = 36658 , search = "Scourgelord Tyrannus"},
  },
  ["Halls of Reflection"] = {
    { name = "Falric", id = 38112 , search = "Falric"},
    { name = "Marwyn", id = 38113 , search = "Marwyn"},
    { name = "Escape from Arthas", completeOnYell = "FIRE! FIRE!" , search = "The Lich King"},
  },

  ---------------------------------------------------------------------------
  -- The Burning Crusade (Dungeons — normal & heroic share the same zone name)
  ---------------------------------------------------------------------------
  ["Hellfire Citadel: Ramparts"] = {
    { name = "Watchkeeper Gargolmar", id = 17306 , search = "Watchkeeper Gargolmar"},
    { name = "Omor the Unscarred", id = 17308 , search = "Omor the Unscarred"},
    { name = "Vazruden & Nazan", ids = { 17537, 17536 }, all = true , search = "Vazruden"},
  },
  ["Hellfire Citadel: The Blood Furnace"] = {
    { name = "The Maker", id = 17381 , search = "The Maker"},
    { name = "Broggok", id = 17380 , search = "Broggok"},
    { name = "Keli'dan the Breaker", id = 17377 , search = "Keli'dan the Breaker"},
  },
  ["Coilfang: The Slave Pens"] = {
    { name = "Mennu the Betrayer", id = 17941 , search = "Mennu the Betrayer"},
    { name = "Rokmar the Crackler", id = 17991 , search = "Rokmar the Crackler"},
    { name = "Quagmirran", id = 17942 , search = "Quagmirran"},
  },
  ["Coilfang: The Underbog"] = {
    { name = "Hungarfen", id = 17770 , search = "Hungarfen"},
    { name = "Ghaz'an", id = 18105 , search = "Ghaz'an"},
    { name = "Swamplord Musel'ek", id = 17826 , search = "Swamplord Musel'ek"},
    { name = "The Black Stalker", id = 17882 , search = "The Black Stalker"},
  },
  ["Auchindoun: Mana-Tombs"] = {
    { name = "Pandemonius", id = 18341 , search = "Pandemonius"},
    { name = "Tavarok", id = 18343 , search = "Tavarok"},
    { name = "Nexus-Prince Shaffar", id = 18344 , search = "Nexus-Prince Shaffar"},
    { name = "Yor", id = 22930 , search = "Yor"},
  },
  ["Auchindoun: Auchenai Crypts"] = {
    { name = "Shirrak the Dead Watcher", id = 18371 , search = "Shirrak the Dead Watcher"},
    { name = "Exarch Maladaar", id = 18373 , search = "Exarch Maladaar"},
  },
  ["Auchindoun: Sethekk Halls"] = {
    { name = "Darkweaver Syth", id = 18472 , search = "Darkweaver Syth"},
    { name = "Anzu", id = 23035 , search = "Anzu"},
    { name = "Talon King Ikiss", id = 18473 , search = "Talon King Ikiss"},
  },
  ["Auchindoun: Shadow Labyrinth"] = {
    { name = "Ambassador Hellmaw", id = 18731 , search = "Ambassador Hellmaw"},
    { name = "Blackheart the Inciter", id = 18667 , search = "Blackheart the Inciter"},
    { name = "Grandmaster Vorpil", id = 18732 , search = "Grandmaster Vorpil"},
    { name = "Murmur", id = 18708 , search = "Murmur"},
  },
  ["Hellfire Citadel: The Shattered Halls"] = {
    { name = "Grand Warlock Nethekurse", id = 16807 , search = "Grand Warlock Nethekurse"},
    { name = "Blood Guard Porung", id = 20923 , search = "Blood Guard Porung"},
    { name = "Warbringer O'mrogg", id = 16809 , search = "Warbringer O'mrogg"},
    { name = "Warchief Kargath Bladefist", id = 16808 , search = "Warchief Kargath Bladefist"},
  },
  ["Coilfang: The Steamvault"] = {
    { name = "Hydromancer Thespia", id = 17797 , search = "Hydromancer Thespia"},
    { name = "Mekgineer Steamrigger", id = 17796 , search = "Mekgineer Steamrigger"},
    { name = "Warlord Kalithresh", id = 17798 , search = "Warlord Kalithresh"},
  },
  ["Tempest Keep: The Botanica"] = {
    { name = "Commander Sarannis", id = 17976 , search = "Commander Sarannis"},
    { name = "High Botanist Freywinn", id = 17975 , search = "High Botanist Freywinn"},
    { name = "Thorngrin the Tender", id = 17978 , search = "Thorngrin the Tender"},
    { name = "Laj", id = 17980 , search = "Laj"},
    { name = "Warp Splinter", id = 17977 , search = "Warp Splinter"},
  },
  ["Tempest Keep: The Mechanar"] = {
    { name = "Gatewatcher Gyro-Kill", id = 19218 , search = "Gatewatcher Gyro-Kill"},
    { name = "Gatewatcher Iron-Hand", id = 19710 , search = "Gatewatcher Iron-Hand"},
    { name = "Mechano-Lord Capacitus", id = 19219 , search = "Mechano-Lord Capacitus"},
    { name = "Nethermancer Sepethrea", id = 19221 , search = "Nethermancer Sepethrea"},
    { name = "Pathaleon the Calculator", id = 19220 , search = "Pathaleon the Calculator"},
  },
  ["Tempest Keep: The Arcatraz"] = {
    { name = "Zereketh the Unbound", id = 20870 , search = "Zereketh the Unbound"},
    { name = "Dalliah the Doomsayer", id = 20885 , search = "Dalliah the Doomsayer"},
    { name = "Wrath-Scryer Soccothrates", id = 20886 , search = "Wrath-Scryer Soccothrates"},
    { name = "Harbinger Skyriss", id = 20912 , search = "Harbinger Skyriss"},
  },
  ["The Escape From Durnholde"] = {
    { name = "Lieutenant Drake", id = 17848 , search = "Lieutenant Drake"},
    { name = "Captain Skarloc", id = 17862 , search = "Captain Skarloc"},
    { name = "Epoch Hunter", id = 18096 , search = "Epoch Hunter"},
  },
  ["Opening of the Dark Portal"] = {
    { name = "Chrono Lord Deja", id = 17879 , search = "Chrono Lord Deja"},
    { name = "Temporus", id = 17880 , search = "Temporus"},
    { name = "Aeonus", id = 17881 , search = "Aeonus"},
  },
  ["Magister's Terrace"] = {
    { name = "Selin Fireheart", id = 24723 , search = "Selin Fireheart"},
    { name = "Vexallus", id = 24744 , search = "Vexallus"},
    { name = "Priestess Delrissa", id = 24560 , search = "Priestess Delrissa"},
    { name = "Kael'thas Sunstrider", id = 24664 , search = "Kael'thas Sunstrider"},
  },

  ---------------------------------------------------------------------------
  -- The Burning Crusade (Raids)
  ---------------------------------------------------------------------------
  ["Karazhan"] = {
    { name = "Attumen the Huntsman", id = 15550 , search = "Attumen the Huntsman"},
    { name = "Moroes", id = 15687 , search = "Moroes"},
    { name = "Maiden of Virtue", id = 16457 , search = "Maiden of Virtue"},
    { name = "Opera Hall", ids = { 17521, 18168, 17533, 17534 }, any = true , search = "Barnes"},
    { name = "The Curator", id = 15691 , search = "The Curator"},
    { name = "Terestian Illhoof", id = 15688 , search = "Terestian Illhoof"},
    { name = "Shade of Aran", id = 16524 , search = "Shade of Aran"},
    { name = "Netherspite", id = 15689 , search = "Netherspite"},
    { name = "Chess Event", completeOnEmote = { "The halls of Karazhan shake, as the curse binding the doors of the Gamesman's Hall is lifted." } , search = "Echo of Medivh"},
    { name = "Prince Malchezaar", id = 15690 , search = "Prince Malchezaar"},
    { name = "Nightbane", id = 17225 , search = "Nightbane"},
  },
  ["Gruul's Lair"] = {
    { name = "High King Maulgar", id = 18831 , search = "High King Maulgar"},
    { name = "Gruul the Dragonkiller", id = 19044 , search = "Gruul the Dragonkiller"},
  },
  ["Magtheridon's Lair"] = {
    { name = "Magtheridon", id = 17257 , search = "Magtheridon"},
  },
  ["Coilfang: Serpentshrine Cavern"] = {
    { name = "Hydross the Unstable", id = 21216 , search = "Hydross the Unstable"},
    { name = "The Lurker Below", id = 21217 , search = "The Lurker Below"},
    { name = "Leotheras the Blind", id = 21215 , search = "Leotheras the Blind"},
    { name = "Fathom-Lord Karathress", id = 21214 , search = "Fathom-Lord Karathress"},
    { name = "Morogrim Tidewalker", id = 21213 , search = "Morogrim Tidewalker"},
    { name = "Lady Vashj", id = 21212 , search = "Lady Vashj"},
  },
  ["Tempest Keep"] = {
    { name = "Al'ar", id = 19514 , search = "Al'ar"},
    { name = "Void Reaver", id = 19516 , search = "Void Reaver"},
    { name = "High Astromancer Solarian", id = 18805 , search = "High Astromancer Solarian"},
    { name = "Kael'thas Sunstrider", id = 19622 , search = "Kael'thas Sunstrider"},
  },
  ["The Battle for Mount Hyjal"] = {
    { name = "Rage Winterchill", id = 17767 , search = "Rage Winterchill"},
    { name = "Anetheron", id = 17808 , search = "Anetheron"},
    { name = "Kaz'rogal", id = 17888 , search = "Kaz'rogal"},
    { name = "Azgalor", id = 17842 , search = "Azgalor"},
    { name = "Archimonde", id = 17968 , search = "Archimonde"},
  },
  ["Black Temple"] = {
    { name = "High Warlord Naj'entus", id = 22887 , search = "High Warlord Naj'entus"},
    { name = "Supremus", id = 22898 , search = "Supremus"},
    { name = "Shade of Akama", id = 22841 , search = "Shade of Akama"},
    { name = "Teron Gorefiend", id = 22871 , search = "Teron Gorefiend"},
    { name = "Gurtogg Bloodboil", id = 22948 , search = "Gurtogg Bloodboil"},
    { name = "Reliquary of Souls", id = 23420 , search = "Reliquary of Souls"},
    { name = "Mother Shahraz", id = 22947 , search = "Mother Shahraz"},
    { name = "The Illidari Council", ids = { 22949, 22950, 22951, 22952 }, all = true , search = "Lady Malande"},
    { name = "Illidan Stormrage", id = 22917 , search = "Illidan Stormrage"},
  },
  ["The Sunwell"] = {
    { name = "Kalecgos", id = 24892 , search = "Kalecgos"},
    { name = "Brutallus", id = 24882 , search = "Brutallus"},
    { name = "Felmyst", id = 25038 , search = "Felmyst"},
    { name = "Eredar Twins", ids = { 25165, 25166 }, all = true , search = "Alythess"},
    { name = "M'uru", id = 25840 , search = "M'uru"},
    { name = "Kil'jaeden", id = 25315 , search = "Kil'jaeden"},
  },
  ["Zul'Aman"] = {
    { name = "Nalorakk", id = 23576 , search = "Nalorakk"},
    { name = "Akil'zon", id = 23574 , search = "Akil'zon"},
    { name = "Jan'alai", id = 23578 , search = "Jan'alai"},
    { name = "Halazzi", id = 23577 , search = "Halazzi"},
    { name = "Hex Lord Malacrass", id = 24239 , search = "Hex Lord Malacrass"},
    { name = "Zul'jin", id = 23863 , search = "Zul'jin"},
  },

  ---------------------------------------------------------------------------
  -- Classic (common raids - extend as needed)
  ---------------------------------------------------------------------------
  ["Molten Core"] = {
    { name = "Lucifron", id = 12118 , search = "Lucifron"},
    { name = "Magmadar", id = 11982 , search = "Magmadar"},
    { name = "Gehennas", id = 12259 , search = "Gehennas"},
    { name = "Garr", id = 12057 , search = "Garr"},
    { name = "Baron Geddon", id = 12056 , search = "Baron Geddon"},
    { name = "Shazzrah", id = 12264 , search = "Shazzrah"},
    { name = "Sulfuron Harbinger", id = 12098 , search = "Sulfuron Harbinger"},
    { name = "Golemagg the Incinerator", id = 11988 , search = "Golemagg the Incinerator"},
    { name = "Majordomo Executus", completeOnYell = { "Brashly, you have come to wrest the secrets of the Living Flame! You will soon regret the recklessness of your quest." }, search = "Majordomo Executus"},
    { name = "Ragnaros", id = 11502 , search = "Ragnaros"},
  },
  ["Blackwing Lair"] = {
    { name = "Razorgore the Untamed", id = 12435 , search = "Razorgore the Untamed"},
    { name = "Vaelastrasz the Corrupt", id = 13020 , search = "Vaelastrasz the Corrupt"},
    { name = "Broodlord Lashlayer", id = 12017 , search = "Broodlord Lashlayer"},
    { name = "Firemaw", id = 11983 , search = "Firemaw"},
    { name = "Ebonroc", id = 14601 , search = "Ebonroc"},
    { name = "Flamegor", id = 11981 , search = "Flamegor"},
    { name = "Chromaggus", id = 14020 , search = "Chromaggus"},
    { name = "Nefarian", id = 11583 , search = "Nefarian"},
  },
  ["Zul'Gurub"] = {
    { name = "High Priestess Jeklik", id = 14517 , search = "High Priestess Jeklik"},
    { name = "High Priest Venoxis", id = 14507 , search = "High Priest Venoxis"},
    { name = "High Priestess Mar'li", id = 14510 , search = "High Priestess Mar'li"},
    { name = "Bloodlord Mandokir", id = 11382 , search = "Bloodlord Mandokir"},
    { name = "Edge of Madness", ids = { 15083, 15084, 15085, 15082 }, any = true , search = "Renataki"},
    { name = "High Priest Thekal", id = 14509 , search = "High Priest Thekal"},
    { name = "High Priestess Arlokk", id = 14515 , search = "High Priestess Arlokk"},
    { name = "Jin'do the Hexxer", id = 11380 , search = "Jin'do the Hexxer"},
    { name = "Hakkar", id = 14834 , search = "Hakkar"},
    { name = "Gahz'ranka", id = 15114 , search = "Gahz'ranka"},
  },
  ["Ruins of Ahn'Qiraj"] = {
    { name = "Kurinnaxx", id = 15348 , search = "Kurinnaxx"},
    { name = "General Rajaxx", id = 15341 , search = "General Rajaxx"},
    { name = "Moam", id = 15340 , search = "Moam"},
    { name = "Buru the Gorger", id = 15370 , search = "Buru the Gorger"},
    { name = "Ayamiss the Hunter", id = 15369 , search = "Ayamiss the Hunter"},
    { name = "Ossirian the Unscarred", id = 15339 , search = "Ossirian the Unscarred"},
  },
  ["Ahn'Qiraj Temple"] = {
    { name = "The Prophet Skeram", id = 15263 , search = "The Prophet Skeram"},
    { name = "Bug Trio", ids = { 15543, 15544, 15511 }, all = true , search = "Vem"},
    { name = "Battleguard Sartura", id = 15516 , search = "Battleguard Sartura"},
    { name = "Fankriss the Unyielding", id = 15510 , search = "Fankriss the Unyielding"},
    { name = "Viscidus", id = 15299 , search = "Viscidus"},
    { name = "Princess Huhuran", id = 15509 , search = "Princess Huhuran"},
    { name = "Twin Emperors", ids = { 15275, 15276 }, all = true , search = "Vek'lor"},
    { name = "Ouro", id = 15517 , search = "Ouro"},
    { name = "C'Thun", id = 15727 , search = "C'Thun"},
    
    
  },

  ---------------------------------------------------------------------------
  -- Classic (all 5-man dungeons)
  ---------------------------------------------------------------------------
  ["Ragefire Chasm"] = {
    { name = "Oggleflint", id = 11517 , search = "Oggleflint"},
    { name = "Taragaman the Hungerer", id = 11520 , search = "Taragaman the Hungerer"},
    { name = "Jergosh the Invoker", id = 11518 , search = "Jergosh the Invoker"},
    { name = "Bazzalan", id = 11519 , search = "Bazzalan"},
  },
  ["Wailing Caverns"] = {
    { name = "Lady Anacondra", id = 3671 , search = "Lady Anacondra"},
    { name = "Lord Cobrahn", id = 3669 , search = "Lord Cobrahn"},
    { name = "Kresh", id = 3653 , search = "Kresh"},
    { name = "Lord Pythas", id = 3670 , search = "Lord Pythas"},
    { name = "Skum", id = 3674 , search = "Skum"},
    { name = "Lord Serpentis", id = 3673 , search = "Lord Serpentis"},
    { name = "Verdan the Everliving", id = 5775 , search = "Verdan the Everliving"},
    { name = "Mutanus the Devourer", id = 3654 , search = "Mutanus the Devourer"},
  },
  ["Deadmines"] = {
    { name = "Rhahk'Zor", id = 644 , search = "Rhahk'Zor"},
    { name = "Sneed", id = 643 , search = "Sneed"},
    { name = "Gilnid", id = 1763 , search = "Gilnid"},
    { name = "Mr. Smite", id = 646 , search = "Mr. Smite"},
    { name = "Captain Greenskin", id = 647 , search = "Captain Greenskin"},
    { name = "Edwin VanCleef", id = 639 , search = "Edwin VanCleef"},
    { name = "Cookie", id = 645 , search = "Cookie"},
  },
  ["Shadowfang Keep"] = {
    { name = "Rethilgore", id = 3914 , search = "Rethilgore"},
    { name = "Razorclaw the Butcher", id = 3886 , search = "Razorclaw the Butcher"},
    { name = "Baron Silverlaine", id = 3887 , search = "Baron Silverlaine"},
    { name = "Commander Springvale", id = 4278 , search = "Commander Springvale"},
    { name = "Odo the Blindwatcher", id = 4279 , search = "Odo the Blindwatcher"},
    { name = "Fenrus the Devourer", id = 4274 , search = "Fenrus the Devourer"},
    { name = "Wolf Master Nandos", id = 3927 , search = "Wolf Master Nandos"},
    { name = "Archmage Arugal", id = 4275 , search = "Archmage Arugal"},
  },
  ["Stormwind Stockade"] = {
    { name = "Targorr the Dread", id = 1696 , search = "Targorr the Dread"},
    { name = "Kam Deepfury", id = 1666 , search = "Kam Deepfury"},
    { name = "Hamhock", id = 1717 , search = "Hamhock"},
    { name = "Bazil Thredd", id = 1716 , search = "Bazil Thredd"},
    { name = "Dextren Ward", id = 1663 , search = "Dextren Ward"},
  },
  ["Blackfathom Deeps"] = {
    { name = "Ghamoo-ra", id = 4887 , search = "Ghamoo-ra"},
    { name = "Lady Sarevess", id = 4831 , search = "Lady Sarevess"},
    { name = "Gelihast", id = 6243 , search = "Gelihast"},
    { name = "Lorgus Jett", id = 12902 , search = "Lorgus Jett"},
    { name = "Old Serra'kis", id = 4830 , search = "Old Serra'kis"},
    { name = "Twilight Lord Kelris", id = 4832 , search = "Twilight Lord Kelris"},
    { name = "Aku'mai", id = 4829 , search = "Aku'mai"},
  },
  ["Gnomeregan"] = {
    { name = "Grubbis", id = 7361 , search = "Grubbis"},
    { name = "Viscous Fallout", id = 7079 , search = "Viscous Fallout"},
    { name = "Electrocutioner 6000", id = 6235 , search = "Electrocutioner 6000"},
    { name = "Crowd Pummeler 9-60", id = 6229 , search = "Crowd Pummeler 9-60"},
    { name = "Mekgineer Thermaplugg", id = 7800 , search = "Mekgineer Thermaplugg"},
  },
  ["Razorfen Kraul"] = {
    { name = "Aggem Thorncurse", id = 4424 , search = "Aggem Thorncurse"},
    { name = "Death Speaker Jargba", id = 4428 , search = "Death Speaker Jargba"},
    { name = "Overlord Ramtusk", id = 4420 , search = "Overlord Ramtusk"},
    { name = "Agathelos the Raging", id = 4422 , search = "Agathelos the Raging"},
    { name = "Charlga Razorflank", id = 4421 , search = "Charlga Razorflank"},
    { name = "Roogug", id = 6168 , search = "Roogug"},
  },
  ["Razorfen Downs"] = {
    { name = "Tuten'kash", id = 7355 , search = "Tuten'kash"},
    { name = "Mordresh Fire Eye", id = 7357 , search = "Mordresh Fire Eye"},
    { name = "Glutton", id = 8567 , search = "Glutton"},
    { name = "Amnennar the Coldbringer", id = 7358 , search = "Amnennar the Coldbringer"},
  },
  ["Uldaman"] = {
    { name = "Revelosh", id = 6910 , search = "Revelosh"},
    { name = "The Lost Dwarves", ids = { 6906, 6907, 6908 }, all = true, hideIfAlliance = true , search = "Baelog"},
    { name = "Ironaya", id = 7228 , search = "Ironaya"},
    { name = "Obsidian Sentinel", id = 7023 , search = "Obsidian Sentinel"},
    { name = "Ancient Stone Keeper", id = 7206 , search = "Ancient Stone Keeper"},
    { name = "Galgann Firehammer", id = 7291 , search = "Galgann Firehammer"},
    { name = "Grimlok", id = 4854 , search = "Grimlok"},
    { name = "Archaedas", id = 2748 , search = "Archaedas"},
  },
  ["Zul'Farrak"] = {
    { name = "Antu'sul", id = 8127 , search = "Antu'sul"},
    { name = "Theka the Martyr", id = 7272 , search = "Theka the Martyr"},
    { name = "Witch Doctor Zum'rah", id = 7271 , search = "Witch Doctor Zum'rah"},
    { name = "Nekrum Gutchewer and Shadowpriest Sezz'ziz", ids = { 7796, 7275 }, all = true , search = "Nekrum Gutchewer"},
    { name = "Chief Ukorz Sandscalp and Ruuzlu", ids = { 7267, 7797 }, all = true , search = "Ruuzlu"},
    { name = "Hydromancer Velratha", id = 7795 , search = "Hydromancer Velratha"},
    { name = "Gahz'rilla", id = 7273 , search = "Gahz'rilla"},
  },
  ["Maraudon"] = {
    { name = "Noxxion", id = 13282 , search = "Noxxion"},
    { name = "Razorlash", id = 12258 , search = "Razorlash"},
    { name = "Lord Vyletongue", id = 12236 , search = "Lord Vyletongue"},
    { name = "Celebras the Cursed", id = 12225 , search = "Celebras the Cursed"},
    { name = "Landslide", id = 12203 , search = "Landslide"},
    { name = "Tinkerer Gizlock", id = 13601 , search = "Tinkerer Gizlock"},
    { name = "Rotgrip", id = 13596 , search = "Rotgrip"},
    { name = "Princess Theradras", id = 12201 , search = "Princess Theradras"},
  },
  ["Sunken Temple"] = {
    { name = "Jammal'an the Prophet and Ogom the Wretched", ids = { 5710, 5711 }, all = true , search = "Jammal'an the Prophet"},
    { name = "Dreamscythe and Weaver", ids = { 5721, 5720 }, all = true , search = "Weaver"},
    { name = "Morphaz and Hazzas", ids = { 5719, 5722 }, all = true , search = "Morphaz"},
    { name = "Shade of Eranikus", id = 5709 , search = "Shade of Eranikus"},
    { name = "Avatar of Hakkar", id = 8443 , search = "Avatar of Hakkar"},
    { name = "Atal'alarion", id = 8580 , search = "Atal'alarion"},
  },
  ["Blackrock Depths"] = {
    { name = "High Interrogator Gerstahn", id = 9018 , search = "High Interrogator Gerstahn"},
    { name = "Lord Roccor", id = 9025 , search = "Lord Roccor"},
    { name = "Houndmaster Grebmar", id = 9319 , search = "Houndmaster Grebmar"},
    { name = "Ring of Law", ids = { 9027, 9028, 9029, 9030, 9031, 9032 }, any = true , search = "High Justice Grimstone"},
    { name = "Pyromancer Loregrain", id = 9024 , search = "Pyromancer Loregrain"},
    { name = "Bael'Gar", id = 9016 , search = "Bael'Gar"},
    { name = "General Angerforge", id = 9033 , search = "General Angerforge"},
    { name = "Golem Lord Argelmach", id = 8983 , search = "Golem Lord Argelmach"},
    { name = "Ribbly Screwspigot", id = 9543 , search = "Ribbly Screwspigot"},
    { name = "Hurley Blackbreath", id = 9537 , search = "Hurley Blackbreath"},
    { name = "Plugger Spazzring", id = 9499 , search = "Plugger Spazzring"},
    { name = "Phalanx", id = 9502 , search = "Phalanx"},
    { name = "Warder Stilgiss and Verek", ids = { 9041, 9042 }, all = true , search = "Warder Stilgiss"},
    { name = "Lord Incendius", id = 9017 , search = "Lord Incendius"},
    { name = "Fineous Darkvire", id = 9056 , search = "Fineous Darkvire"},    
    { name = "Ambassador Flamelash", id = 9156 , search = "Ambassador Flamelash"},
    { name = "The Seven", ids = { 9034, 9035, 9036, 9037, 9038, 9039, 9040 }, all = true , search = "Hate'rel"},
    { name = "Magmus", id = 9938 , search = "Magmus"},
    { name = "Emperor Dagran Thaurissan", id = 9019 , search = "Emperor Dagran Thaurissan"},
  },
  ["Stratholme"] = {
    { name = "Timmy the Cruel", id = 10808 , search = "Timmy the Cruel"},
    { name = "Malor the Zealous", id = 11032 , search = "Malor the Zealous"},      
    { name = "Cannon Master Willey", id = 10997 , search = "Cannon Master Willey"},
    { name = "Archivist Galford", id = 10811 , search = "Archivist Galford"},
    { name = "Balnazzar", ids = { 10812, 10813 }, any = true, search = "Balnazzar"},
    { name = "The Unforgiven", id = 10516 , search = "The Unforgiven"},
    { name = "Hearthsinger Forresten", id = 10558 , search = "Hearthsinger Forresten"},
    { name = "Magistrate Barthilas", id = 10435 , search = "Magistrate Barthilas"},
    { name = "Nerub'enkan", id = 10437 , search = "Nerub'enkan"},
    { name = "Baroness Anastari", id = 10436 , search = "Baroness Anastari"},
    { name = "Maleki the Pallid", id = 10438 , search = "Maleki the Pallid"},    
    { name = "Ramstein the Gorger", id = 10439 , search = "Ramstein the Gorger"},
    { name = "Baron Rivendare", id = 10440 , search = "Baron Rivendare"},
  },
  ["Scholomance"] = {
    { name = "Kirtonos the Herald", id = 10506 , search = "Kirtonos the Herald"},
    { name = "Jandice Barov", id = 10503 , search = "Jandice Barov"},
    { name = "Rattlegore", id = 11622 , search = "Rattlegore"},
    { name = "Vectus and Marduk Blackpool", ids = { 10433, 10432 }, all = true , search = "Vectus"},
    { name = "Ras Frostwhisper", id = 10508 , search = "Ras Frostwhisper"},
    { name = "Instructor Malicia", id = 10505 , search = "Instructor Malicia"},
    { name = "Doctor Theolen Krastinov", id = 11261 , search = "Doctor Theolen Krastinov"},
    { name = "Lorekeeper Polkelt", id = 10901 , search = "Lorekeeper Polkelt"},
    { name = "The Ravenian", id = 10507 , search = "The Ravenian"},
    { name = "Lord Alexei Barov", id = 10504 , search = "Lord Alexei Barov"},
    { name = "Lady Illucia Barov", id = 10502 , search = "Lady Illucia Barov"},
    { name = "Darkmaster Gandling", id = 1853 , search = "Darkmaster Gandling"},
  },
  ["Blackrock Spire"] = {
    -- Upper Blackrock Spire (UBRS)
    { name = "Pyroguard Emberseer", id = 9816 , search = "Pyroguard Emberseer"},
    { name = "Solakar Flamewreath", id = 10264 , search = "Solakar Flamewreath"},
    { name = "Goraluk Anvilcrack", id = 10899 , search = "Goraluk Anvilcrack"},
    { name = "Warchief Rend Blackhand", id = 10429 , search = "Warchief Rend Blackhand"},
    { name = "The Beast", id = 10430 , search = "The Beast"},
    { name = "General Drakkisath", id = 10363 , search = "General Drakkisath"},
    -- Lower Blackrock Spire (LBRS)
    { name = "Highlord Omokk", id = 9196 , search = "Highlord Omokk"},
    { name = "Shadow Hunter Vosh'gajin", id = 9236 , search = "Shadow Hunter Vosh'gajin"},
    { name = "War Master Voone", id = 9237 , search = "War Master Voone"},
    { name = "Mor Grayhoof", id = 16080 , search = "Mor Grayhoof"},
    { name = "Mother Smolderweb", id = 10596 , search = "Mother Smolderweb"},
    { name = "Urok Doomhowl", id = 10584 , search = "Urok Doomhowl"},
    { name = "Quartermaster Zigris", id = 9736 , search = "Quartermaster Zigris"},
    { name = "Halycon", id = 10220 , search = "Halycon"},
    { name = "Gizrul the Slavener", id = 10268 , search = "Gizrul the Slavener"},
    { name = "Overlord Wyrmthalak", id = 9568 , search = "Overlord Wyrmthalak"},
  },
}

-- Scarlet Monastery: one instance name for all wings (Graveyard / Library / Armory / Cathedral).
-- Core.lua resolves wing only via GetCurrentMapDungeonLevel() (1–4 = this table order, WotLK).
BossTracker_ScarletMonasteryWings = {
  {
    bosses = {
      { name = "Interrogator Vishas", id = 3983 , search = "Interrogator Vishas"},
      { name = "Bloodmage Thalnos", id = 4543 , search = "Bloodmage Thalnos"},
    },
  },
  {
    bosses = {
      { name = "Houndmaster Loksey", id = 3974 , search = "Houndmaster Loksey"},
      { name = "Arcanist Doan", id = 6487 , search = "Arcanist Doan"},
    },
  },
  {
    bosses = {
      { name = "Herod", id = 3975 , search = "Herod"},
    },
  },
  {
    bosses = {
      { name = "High Inquisitor Fairbanks", id = 4542 , search = "High Inquisitor Fairbanks"},
      { name = "Scarlet Commander Mograine", id = 3976 , search = "Scarlet Commander Mograine"},
      { name = "High Inquisitor Whitemane", id = 3977 , search = "High Inquisitor Whitemane"},
    },
  },
}

-- Dire Maul: one instance name for three wings. Table order: North, West, East (WotLK map floors 1, 2, 5).
BossTracker_DireMaulWings = {
  {
    bosses = {
      { name = "Guard Mol'dar", id = 14326 , search = "Guard Mol'dar"},
      { name = "Stomper Kreeg", id = 14322 , search = "Stomper Kreeg"},
      { name = "Guard Fengus", id = 14321 , search = "Guard Fengus"},
      { name = "Guard Slip'kik", id = 14323 , search = "Guard Slip'kik"},
      { name = "Captain Kromcrush", id = 14325 , search = "Captain Kromcrush"},
      { name = "King Gordok", id = 11501 , search = "King Gordok"},
    },
  },
  {
    bosses = {
      { name = "Magister Kalendris", id = 11487 , search = "Magister Kalendris"},
      { name = "Illyanna Ravenoak", id = 11488 , search = "Illyanna Ravenoak"},
      { name = "Tendris Warpwood", id = 11489 , search = "Tendris Warpwood"},
      { name = "Immol'thar", id = 11496 , search = "Immol'thar"},
      { name = "Prince Tortheldrin", id = 11486 , search = "Prince Tortheldrin"},
    },
  },
  {
    bosses = {
      { name = "Hydrospawn", id = 13280 , search = "Hydrospawn"},
      { name = "Lethtendris", id = 14327 , search = "Lethtendris"},
      { name = "Zevrim Thornhoof", id = 11490 , search = "Zevrim Thornhoof"},
      { name = "Alzzin the Wildshaper", id = 11492 , search = "Alzzin the Wildshaper"},
    },
  },
}

-- GetCurrentMapDungeonLevel() -> index into BossTracker_DireMaulWings (non-contiguous floors on one area id).
BossTracker_DireMaulDungeonLevelToWingIndex = {
  [1] = 1,
  [2] = 2,
  [5] = 3,
}

-- GetInstanceInfo() name for Violet Hold is inconsistent: some clients return "Violet Hold"
-- without "The", which would leave the boss list empty (no matching key above).
if BossTracker_BossData["The Violet Hold"] then
  BossTracker_BossData["Violet Hold"] = BossTracker_BossData["The Violet Hold"]
end

