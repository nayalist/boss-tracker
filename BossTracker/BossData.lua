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
-- Plain strings still work (display only until you add ids).

BossTracker_BossData = {
  ---------------------------------------------------------------------------
  -- Wrath of the Lich King (Raids)
  ---------------------------------------------------------------------------
  ["Naxxramas"] = {
    { name = "Anub'Rekhan", id = 15956 },
    { name = "Grand Widow Faerlina", id = 15953 },
    { name = "Maexxna", id = 15952 },
    { name = "Noth the Plaguebringer", id = 15954 },
    { name = "Heigan the Unclean", id = 15936 },
    { name = "Loatheb", id = 16011 },
    { name = "Patchwerk", id = 16028 },
    { name = "Grobbulus", id = 15931 },
    { name = "Gluth", id = 15932 },
    { name = "Thaddius", id = 15928 },
    { name = "Instructor Razuvious", id = 16061 },
    { name = "Gothik the Harvester", id = 16060 },
    { name = "The Four Horsemen", ids = { 16063, 30549, 16064, 16065 }, all = true },
    { name = "Sapphiron", id = 15989 },
    { name = "Kel'Thuzad", id = 15990 },
  },
  ["The Obsidian Sanctum"] = {
    { name = "Sartharion", id = 28860 },
  },
  ["The Eye of Eternity"] = {
    { name = "Malygos", id = 28859 },
  },
  ["Ulduar"] = {
    { name = "Flame Leviathan", id = 33113 },
    { name = "Ignis the Furnace Master", id = 33118 },
    { name = "Razorscale", id = 33186 },
    { name = "XT-002 Deconstructor", id = 33293 },
    { name = "The Assembly of Iron", ids = { 32867, 32927, 32857 }, all = true },
    { name = "Kologarn", id = 32930 },
    { name = "Auriaya", id = 33515 },
    { name = "Hodir", completeOnYell = "I... I am released from his grasp... at last." },
    { name = "Thorim", completeOnYell = "Stay your arms! I yield!" },
    { name = "Freya", completeOnYell = "His hold on me dissipates. I can see clearly once more. Thank you, heroes." },
    { name = "Mimiron", completeOnYell = "It would appear that I've made a slight miscalculation. I allowed my mind to be corrupted by the fiend in the prison, overriding my primary directive. All systems seem to be functional now. Clear." },
    { name = "General Vezax", id = 33271 },
    { name = "Yogg-Saron", id = 33288 },
    { name = "Algalon the Observer", completeOnYell = "I have seen worlds bathed in the Makers' flames, their denizens fading without as much as a whimper. Entire planetary systems born and razed in the time that it takes your mortal hearts to beat once. Yet all throughout, my own heart devoid of emotion... of empathy. I. Have. Felt. Nothing. A million-million lives wasted. Had they all held within them your tenacity? Had they all loved life as you do?" },
  },
  ["Trial of the Crusader"] = {
    { name = "Northrend Beasts", id = 34797 },
    { name = "Lord Jaraxxus", id = 34780 },
    { name = "Faction Champions", completeOnYell = { "GLORY TO THE ALLIANCE!", "That was just a taste of what the future brings. FOR THE HORDE!" } },
    { name = "Twin Val'kyr", id = 34497 },
    { name = "Anub'arak", id = 34564 },
  },
  ["Onyxia's Lair"] = {
    { name = "Onyxia", id = 10184 },
  },
  ["Icecrown Citadel"] = {
    { name = "Lord Marrowgar", id = 36612 },
    { name = "Lady Deathwhisper", id = 36855 },
    { name = "Gunship Battle", completeOnYell = { "Don't say I didn't warn ya, scoundrels! Onward, brothers and sisters!", "The Alliance falter. Onward to the Lich King!"} },
    { name = "Deathbringer Saurfang", id = 37813 },
    { name = "Festergut", id = 36626 },
    { name = "Rotface", id = 36627 },
    { name = "Professor Putricide", id = 36678 },
    { name = "Blood Prince Council", ids = { 37970, 37972, 37973 }, all = true },
    { name = "Blood-Queen Lana'thel", id = 37955 },
    { name = "Valithria Dreamwalker", completeOnSpellId = 71189 },
    { name = "Sindragosa", id = 36853 },
    { name = "The Lich King", id = 36597 },
  },
  ["The Ruby Sanctum"] = {
    { name = "Baltharus the Warborn", id = 39751 },
    { name = "Saviana Ragefire", id = 39747 },
    { name = "General Zarithrian", id = 39746 },
    { name = "Halion", id = 39863 },
  },
  ["Vault of Archavon"] = {
    { name = "Archavon the Stone Watcher", id = 31125 },
    { name = "Emalon the Storm Watcher", id = 33993 },
    { name = "Koralon the Flame Watcher", id = 35013 },
    { name = "Toravon the Ice Watcher", id = 38433 },
  },

  ---------------------------------------------------------------------------
  -- Wrath of the Lich King (Dungeons)
  ---------------------------------------------------------------------------
  ["Utgarde Keep"] = {
    { name = "Prince Keleseth", id = 23953 },
    { name = "Skarvald the Constructor and Dalronn the Controller", ids = { 24200, 24201 }, all = true },
    { name = "Ingvar the Plunderer", id = 23954 },
  },
  ["Utgarde Pinnacle"] = {
    { name = "Svala Sorrowgrave", completeOnYell = "Nooo! I did not come this far... to..." },
    { name = "Gortok Palehoof", id = 26687 },
    { name = "Skadi the Ruthless", id = 26693 },
    { name = "King Ymiron", id = 26861 },
  },
  ["The Nexus"] = {
    { name = "Commander Stoutbeard/Commander Kolurg", ids = { 26796, 26798 }, any = true },
    { name = "Grand Magus Telestra", id = 26731 },
    { name = "Anomalus", id = 26763 },
    { name = "Ormorok the Tree-Shaper", id = 26794 },
    { name = "Keristrasza", id = 26723 },
  },
  ["The Oculus"] = {
    { name = "Drakos the Interrogator", id = 27654 },
    { name = "Varos Cloudstrider", id = 27447 },
    { name = "Mage-Lord Urom", id = 27655 },
    { name = "Ley-Guardian Eregos", id = 27656 },
  },
  ["Azjol-Nerub"] = {
    { name = "Krik'thir the Gatewatcher", id = 28684 },
    { name = "Hadronox", id = 28921 },
    { name = "Anub'arak", id = 29120 },
  },
  ["Ahn'kahet: The Old Kingdom"] = {
    { name = "Elder Nadox", id = 29309 },
    { name = "Prince Taldaram", id = 29308 },
    { name = "Jedoga Shadowseeker", id = 29310 },
    { name = "Herald Volazj", id = 29311 },
    { name = "Amanitar", id = 30258 },
  },
  ["Drak'Tharon Keep"] = {
    { name = "Trollgore", id = 26630 },
    { name = "Novos the Summoner", id = 26631 },
    { name = "King Dred", id = 27483 },
    { name = "The Prophet Tharon'ja", id = 26632 },
  },
  ["Gundrak"] = {
    { name = "Slad'ran", id = 29304 },
    { name = "Drakkari Colossus", id = 29307 },
    { name = "Moorabi", id = 29305 },
    { name = "Eck the Ferocious", id = 29932 },
    { name = "Gal'darah", id = 29306 },
  },
  ["Halls of Stone"] = {
    { name = "Krystallus", id = 27977 },
    { name = "Maiden of Grief", id = 27975 },
    { name = "The Tribunal of Ages", completeOnYell = "Purge? No no no no no.. where did I-- Aha, this should do the trick..." },
    { name = "Sjonnir the Ironshaper", id = 27978 },
  },
  ["Halls of Lightning"] = {
    { name = "General Bjarngrim", id = 28586 },
    { name = "Volkhan", id = 28587 },
    { name = "Ionar", id = 28546 },
    { name = "Loken", id = 28923 },
  },
  -- we list every possible spawn + Cyanigosa; kills still match via UNIT_DIED npc ids.
  ["The Violet Hold"] = {
    { name = "Erekem", id = 29315 },
    { name = "Moragg", id = 29316 },
    { name = "Ichoron", id = 29313 },
    { name = "Xevozz", id = 29266 },
    { name = "Lavanthor", id = 29312 },
    { name = "Zuramat the Obliterator", id = 29314 },
    { name = "Cyanigosa", id = 31134 },
  },
  ["The Culling of Stratholme"] = {
    { name = "Meathook", id = 26529 },
    { name = "Salramm the Fleshcrafter", id = 26530 },
    { name = "Chrono-Lord Epoch", id = 26532 },
    { name = "Mal'Ganis", completeOnYell = "Your journey has just begun, young prince. Gather your forces and meet me in the arctic land of Northrend. It is there that we shall settle the score between us. It is there that your true destiny will unfold." },
  },
  -- Yell strings: DeadlyBossMods/DBM-Dungeons DBM-Party-WotLK localization.en.lua (mods 634, 636, 635) — DBM killMsgs[msg] exact match.
  ["Trial of the Champion"] = {
    {
      name = "Grand Champions",
      completeOnYell = "Well fought! Your next challenge comes from the Crusade's own ranks. You will be tested against their considerable prowess.",
    },
    {
      name = "Argent Champion",
      completeOnYell = {
        "Excellent work!",
        "I yield! I submit. Excellent work. May I run away now?",
      },
    },
    { name = "The Black Knight", id = 35451, multiKill = 3 },
  },
  ["The Forge of Souls"] = {
    { name = "Bronjahm", id = 36497 },
    { name = "Devourer of Souls", id = 36502 },
  },
  ["Pit of Saron"] = {
    { name = "Forgemaster Garfrost", id = 36494 },
    { name = "Ick and Krick", id = 36476 },
    { name = "Scourgelord Tyrannus", id = 36658 },
  },
  ["Halls of Reflection"] = {
    { name = "Falric", id = 38112 },
    { name = "Marwyn", id = 38113 },
    { name = "Escape from Arthas", completeOnYell = "FIRE! FIRE!" },
  },

  ---------------------------------------------------------------------------
  -- The Burning Crusade (Dungeons — normal & heroic share the same zone name)
  ---------------------------------------------------------------------------
  ["Hellfire Citadel: Ramparts"] = {
    { name = "Watchkeeper Gargolmar", id = 17306 },
    { name = "Omor the Unscarred", id = 17308 },
    { name = "Vazruden & Nazan", ids = { 17537, 17536 }, all = true },
  },
  ["Hellfire Citadel: The Blood Furnace"] = {
    { name = "The Maker", id = 17381 },
    { name = "Broggok", id = 17380 },
    { name = "Keli'dan the Breaker", id = 17377 },
  },
  ["Coilfang: The Slave Pens"] = {
    { name = "Mennu the Betrayer", id = 17941 },
    { name = "Rokmar the Crackler", id = 17991 },
    { name = "Quagmirran", id = 17942 },
  },
  ["Coilfang: The Underbog"] = {
    { name = "Hungarfen", id = 17770 },
    { name = "Ghaz'an", id = 18105 },
    { name = "Swamplord Musel'ek", id = 17826 },
    { name = "The Black Stalker", id = 17882 },
  },
  ["Auchindoun: Mana-Tombs"] = {
    { name = "Pandemonius", id = 18341 },
    { name = "Tavarok", id = 18343 },
    { name = "Nexus-Prince Shaffar", id = 18344 },
    { name = "Yor", id = 22930 },
  },
  ["Auchindoun: Auchenai Crypts"] = {
    { name = "Shirrak the Dead Watcher", id = 18371 },
    { name = "Exarch Maladaar", id = 18373 },
  },
  ["Auchindoun: Sethekk Halls"] = {
    { name = "Darkweaver Syth", id = 18472 },
    { name = "Anzu", id = 23035 },
    { name = "Talon King Ikiss", id = 18473 },
  },
  ["Auchindoun: Shadow Labyrinth"] = {
    { name = "Ambassador Hellmaw", id = 18731 },
    { name = "Blackheart the Inciter", id = 18667 },
    { name = "Grandmaster Vorpil", id = 18732 },
    { name = "Murmur", id = 18708 },
  },
  ["Hellfire Citadel: The Shattered Halls"] = {
    { name = "Grand Warlock Nethekurse", id = 16807 },
    { name = "Blood Guard Porung", id = 20923 },
    { name = "Warbringer O'mrogg", id = 16809 },
    { name = "Warchief Kargath Bladefist", id = 16808 },
  },
  ["Coilfang: The Steamvault"] = {
    { name = "Hydromancer Thespia", id = 17797 },
    { name = "Mekgineer Steamrigger", id = 17796 },
    { name = "Warlord Kalithresh", id = 17798 },
  },
  ["Tempest Keep: The Botanica"] = {
    { name = "Commander Sarannis", id = 17976 },
    { name = "High Botanist Freywinn", id = 17975 },
    { name = "Thorngrin the Tender", id = 17978 },
    { name = "Laj", id = 17980 },
    { name = "Warp Splinter", id = 17977 },
  },
  ["Tempest Keep: The Mechanar"] = {
    { name = "Gatewatcher Gyro-Kill", id = 19218 },
    { name = "Gatewatcher Iron-Hand", id = 19710 },
    { name = "Mechano-Lord Capacitus", id = 19219 },
    { name = "Nethermancer Sepethrea", id = 19221 },
    { name = "Pathaleon the Calculator", id = 19220 },
  },
  ["Tempest Keep: The Arcatraz"] = {
    { name = "Zereketh the Unbound", id = 20870 },
    { name = "Dalliah the Doomsayer", id = 20885 },
    { name = "Wrath-Scryer Soccothrates", id = 20886 },
    { name = "Harbinger Skyriss", id = 20912 },
  },
  ["The Escape From Durnholde"] = {
    { name = "Lieutenant Drake", id = 17848 },
    { name = "Captain Skarloc", id = 17862 },
    { name = "Epoch Hunter", id = 18096 },
  },
  ["Opening of the Dark Portal"] = {
    { name = "Chrono Lord Deja", id = 17879 },
    { name = "Temporus", id = 17880 },
    { name = "Aeonus", id = 17881 },
  },
  ["Magister's Terrace"] = {
    { name = "Selin Fireheart", id = 24723 },
    { name = "Vexallus", id = 24744 },
    { name = "Priestess Delrissa", id = 24560 },
    { name = "Kael'thas Sunstrider", id = 24664 },
  },

  ---------------------------------------------------------------------------
  -- The Burning Crusade (Raids)
  ---------------------------------------------------------------------------
  ["Karazhan"] = {
    { name = "Attumen the Huntsman", id = 15550 },
    { name = "Moroes", id = 15687 },
    { name = "Maiden of Virtue", id = 16457 },
    { name = "Opera Hall", ids = { 17521, 18168, 17533, 17534 }, any = true },
    { name = "The Curator", id = 15691 },
    { name = "Terestian Illhoof", id = 15688 },
    { name = "Shade of Aran", id = 16524 },
    { name = "Netherspite", id = 15689 },
    { name = "Chess Event", completeOnEmote = { "The halls of Karazhan shake, as the curse binding the doors of the Gamesman's Hall is lifted." } },
    { name = "Prince Malchezaar", id = 15690 },
    { name = "Nightbane", id = 17225 },
  },
  ["Gruul's Lair"] = {
    { name = "High King Maulgar", id = 18831 },
    { name = "Gruul the Dragonkiller", id = 19044 },
  },
  ["Magtheridon's Lair"] = {
    { name = "Magtheridon", id = 17257 },
  },
  ["Coilfang: Serpentshrine Cavern"] = {
    { name = "Hydross the Unstable", id = 21216 },
    { name = "The Lurker Below", id = 21217 },
    { name = "Leotheras the Blind", id = 21215 },
    { name = "Fathom-Lord Karathress", id = 21214 },
    { name = "Morogrim Tidewalker", id = 21213 },
    { name = "Lady Vashj", id = 21212 },
  },
  ["Tempest Keep"] = {
    { name = "Al'ar", id = 19514 },
    { name = "Void Reaver", id = 19516 },
    { name = "High Astromancer Solarian", id = 18805 },
    { name = "Kael'thas Sunstrider", id = 19622 },
  },
  ["The Battle for Mount Hyjal"] = {
    { name = "Rage Winterchill", id = 17767 },
    { name = "Anetheron", id = 17808 },
    { name = "Kaz'rogal", id = 17888 },
    { name = "Azgalor", id = 17842 },
    { name = "Archimonde", id = 17968 },
  },
  ["Black Temple"] = {
    { name = "High Warlord Naj'entus", id = 22887 },
    { name = "Supremus", id = 22898 },
    { name = "Shade of Akama", id = 22841 },
    { name = "Teron Gorefiend", id = 22871 },
    { name = "Gurtogg Bloodboil", id = 22948 },
    { name = "Reliquary of Souls", id = 23420 },
    { name = "Mother Shahraz", id = 22947 },
    { name = "The Illidari Council", ids = { 22949, 22950, 22951, 22952 }, all = true },
    { name = "Illidan Stormrage", id = 22917 },
  },
  ["The Sunwell"] = {
    { name = "Kalecgos", id = 24892 },
    { name = "Brutallus", id = 24882 },
    { name = "Felmyst", id = 25038 },
    { name = "Eredar Twins", ids = { 25165, 25166 }, all = true },
    { name = "M'uru", id = 25840 },
    { name = "Kil'jaeden", id = 25315 },
  },
  ["Zul'Aman"] = {
    { name = "Nalorakk", id = 23576 },
    { name = "Akil'zon", id = 23574 },
    { name = "Jan'alai", id = 23578 },
    { name = "Halazzi", id = 23577 },
    { name = "Hex Lord Malacrass", id = 24239 },
    { name = "Zul'jin", id = 23863 },
  },

  ---------------------------------------------------------------------------
  -- Classic (common raids - extend as needed)
  ---------------------------------------------------------------------------
  ["Molten Core"] = {
    { name = "Lucifron", id = 12118 },
    { name = "Magmadar", id = 11982 },
    { name = "Gehennas", id = 12259 },
    { name = "Garr", id = 12057 },
    { name = "Baron Geddon", id = 12056 },
    { name = "Shazzrah", id = 12264 },
    { name = "Sulfuron Harbinger", id = 12098 },
    { name = "Golemagg the Incinerator", id = 11988 },
    { name = "Majordomo Executus", completeOnYell = { "Brashly, you have come to wrest the secrets of the Living Flame! You will soon regret the recklessness of your quest." }},
    { name = "Ragnaros", id = 11502 },
  },
  ["Blackwing Lair"] = {
    { name = "Razorgore the Untamed", id = 12435 },
    { name = "Vaelastrasz the Corrupt", id = 13020 },
    { name = "Broodlord Lashlayer", id = 12017 },
    { name = "Firemaw", id = 11983 },
    { name = "Ebonroc", id = 14601 },
    { name = "Flamegor", id = 11981 },
    { name = "Chromaggus", id = 14020 },
    { name = "Nefarian", id = 11583 },
  },
  ["Zul'Gurub"] = {
    { name = "High Priest Venoxis", id = 14507 },
    { name = "High Priestess Jeklik", id = 14517 },
    { name = "High Priestess Mar'li", id = 14510 },
    { name = "High Priest Thekal", id = 14509 },
    { name = "High Priestess Arlokk", id = 14515 },
    { name = "Hakkar", id = 14834 },
    { name = "Bloodlord Mandokir", id = 11382 },
    { name = "Jin'do the Hexxer", id = 11380 },
    { name = "Gahz'ranka", id = 15114 },
  },
  ["Ruins of Ahn'Qiraj"] = {
    { name = "Kurinnaxx", id = 15348 },
    { name = "General Rajaxx", id = 15341 },
    { name = "Moam", id = 15340 },
    { name = "Buru the Gorger", id = 15370 },
    { name = "Ayamiss the Hunter", id = 15369 },
    { name = "Ossirian the Unscarred", id = 15339 },
  },
  ["Ahn'Qiraj Temple"] = {
    { name = "The Prophet Skeram", id = 15263 },
    { name = "Bug Trio", ids = { 15543, 15544, 15511 }, all = true },
    { name = "Battleguard Sartura", id = 15516 },
    { name = "Fankriss the Unyielding", id = 15510 },
    { name = "Viscidus", id = 15299 },
    { name = "Princess Huhuran", id = 15509 },
    { name = "Twin Emperors", ids = { 15275, 15276 }, all = true },
    { name = "Ouro", id = 15517 },
    { name = "C'Thun", id = 15727 },
    
    
  },

  ---------------------------------------------------------------------------
  -- Classic (all 5-man dungeons)
  ---------------------------------------------------------------------------
  ["Ragefire Chasm"] = {
    { name = "Oggleflint", id = 11517 },
    { name = "Taragaman the Hungerer", id = 11520 },
    { name = "Jergosh the Invoker", id = 11518 },
    { name = "Bazzalan", id = 11519 },
  },
  ["Wailing Caverns"] = {
    { name = "Lady Anacondra", id = 3671 },
    { name = "Lord Cobrahn", id = 3669 },
    { name = "Kresh", id = 3653 },
    { name = "Lord Pythas", id = 3670 },
    { name = "Skum", id = 3674 },
    { name = "Lord Serpentis", id = 3673 },
    { name = "Verdan the Everliving", id = 5775 },
    { name = "Mutanus the Devourer", id = 3654 },
  },
  ["Deadmines"] = {
    { name = "Rhahk'Zor", id = 644 },
    { name = "Sneed", id = 643 },
    { name = "Gilnid", id = 1763 },
    { name = "Mr. Smite", id = 646 },
    { name = "Captain Greenskin", id = 647 },
    { name = "Edwin VanCleef", id = 639 },
    { name = "Cookie", id = 645 },
  },
  ["Shadowfang Keep"] = {
    { name = "Rethilgore", id = 3914 },
    { name = "Razorclaw the Butcher", id = 3886 },
    { name = "Baron Silverlaine", id = 3887 },
    { name = "Commander Springvale", id = 4278 },
    { name = "Odo the Blindwatcher", id = 4279 },
    { name = "Fenrus the Devourer", id = 4274 },
    { name = "Wolf Master Nandos", id = 3927 },
    { name = "Archmage Arugal", id = 4275 },
  },
  ["Stormwind Stockade"] = {
    { name = "Targorr the Dread", id = 1696 },
    { name = "Kam Deepfury", id = 1666 },
    { name = "Bruegal Ironknuckle", id = 1720 },
    { name = "Hamhock", id = 1717 },
    { name = "Bazil Thredd", id = 1716 },
    { name = "Dextren Ward", id = 1663 },
  },
  ["Blackfathom Deeps"] = {
    { name = "Ghamoo-ra", id = 4887 },
    { name = "Lady Sarevess", id = 4831 },
    { name = "Gelihast", id = 6243 },
    { name = "Lorgus Jett", id = 12902 },
    { name = "Old Serra'kis", id = 4830 },
    { name = "Twilight Lord Kelris", id = 4832 },
    { name = "Aku'mai", id = 4829 },
  },
  ["Gnomeregan"] = {
    { name = "Grubbis", id = 7361 },
    { name = "Viscous Fallout", id = 7079 },
    { name = "Electrocutioner 6000", id = 6235 },
    { name = "Crowd Pummeler 9-60", id = 6229 },
    { name = "Mekgineer Thermaplugg", id = 7800 },
  },
  ["Razorfen Kraul"] = {
    { name = "Aggem Thorncurse", id = 4424 },
    { name = "Death Speaker Jargba", id = 4428 },
    { name = "Overlord Ramtusk", id = 4420 },
    { name = "Agathelos the Raging", id = 4422 },
    { name = "Charlga Razorflank", id = 4421 },
  },
  ["Razorfen Downs"] = {
    { name = "Tuten'kash", id = 7355 },
    { name = "Mordresh Fire Eye", id = 7357 },
    { name = "Glutton", id = 8567 },
    { name = "Amnennar the Coldbringer", id = 7358 },
  },
  ["Uldaman"] = {
    { name = "Revelosh", id = 6910 },
    { name = "The Lost Dwarves", ids = { 6906, 6907, 6908 }, all = true, hideIfAlliance = true },
    { name = "Ironaya", id = 7228 },
    { name = "Obsidian Sentinel", id = 7023 },
    { name = "Ancient Stone Keeper", id = 7206 },
    { name = "Galgann Firehammer", id = 7291 },
    { name = "Grimlok", id = 4854 },
    { name = "Archaedas", id = 2748 },
  },
  ["Zul'Farrak"] = {
    { name = "Antu'sul", id = 8127 },
    { name = "Theka the Martyr", id = 7272 },
    { name = "Witch Doctor Zum'rah", id = 7271 },
    { name = "Nekrum Gutchewer and Shadowpriest Sezz'ziz", ids = { 7796, 7275 }, all = true },
    { name = "Sergeant Bly", id = 7604 },
    { name = "Chief Ukorz Sandscalp and Ruuzlu", ids = { 7267, 7797 }, all = true },
    { name = "Hydromancer Velratha", id = 7795 },
    { name = "Gahz'rilla", id = 7273 },
  },
  ["Maraudon"] = {
    { name = "Noxxion", id = 13282 },
    { name = "Razorlash", id = 12258 },
    { name = "Lord Vyletongue", id = 12236 },
    { name = "Celebras the Cursed", id = 12225 },
    { name = "Landslide", id = 12203 },
    { name = "Tinkerer Gizlock", id = 13601 },
    { name = "Rotgrip", id = 13596 },
    { name = "Princess Theradras", id = 12201 },
  },
  ["Sunken Temple"] = {
    { name = "Jammal'an the Prophet and Ogom the Wretched", ids = { 5710, 5711 }, all = true },
    { name = "Dreamscythe and Weaver", ids = { 5721, 5720 }, all = true },
    { name = "Morphaz and Hazzas", ids = { 5719, 5722 }, all = true },
    { name = "Shade of Eranikus", id = 5709 },
    { name = "Avatar of Hakkar", id = 8443 },
    { name = "Atal'alarion", id = 8580 },
  },
  ["Blackrock Depths"] = {
    { name = "High Interrogator Gerstahn", id = 9018 },
    { name = "Lord Roccor", id = 9025 },
    { name = "Houndmaster Grebmar", id = 9319 },
    { name = "Ring of Law", ids = { 9027, 9028, 9029, 9030, 9031, 9032 }, any = true },
    { name = "Pyromancer Loregrain", id = 9024 },
    { name = "Warder Stilgiss and Verek", ids = { 9041, 9042 }, all = true },
    { name = "Lord Incendius", id = 9017 },
    { name = "Fineous Darkvire", id = 9056 },
    { name = "Bael'Gar", id = 9016 },
    { name = "General Angerforge", id = 9033 },
    { name = "Golem Lord Argelmach", id = 8983 },
    { name = "Hurley Blackbreath", id = 9537 },
    { name = "Plugger Spazzring", id = 9499 },
    { name = "Phalanx", id = 9502 },
    { name = "Ambassador Flamelash", id = 9156 },
    { name = "The Seven", ids = { 9034, 9035, 9036, 9037, 9038, 9039, 9040 }, all = true },
    { name = "Magmus", id = 9938 },
    { name = "Emperor Dagran Thaurissan", id = 9019 },
  },
  ["Stratholme"] = {
    { name = "The Unforgiven", id = 10516 },
    { name = "Hearthsinger Forresten", id = 10558 },
    { name = "Timmy the Cruel", id = 10808 },
    { name = "Cannon Master Willey", id = 10997 },
    { name = "Archivist Galford", id = 10811 },
    { name = "Balnazzar", id = 10813 },
    { name = "Baroness Anastari", id = 10436 },
    { name = "Nerub'enkan", id = 10437 },
    { name = "Maleki the Pallid", id = 10438 },
    { name = "Magistrate Barthilas", id = 10435 },
    { name = "Ramstein the Gorger", id = 10439 },
    { name = "Baron Rivendare", id = 10440 },
  },
  ["Scholomance"] = {
    { name = "Kirtonos the Herald", id = 10506 },
    { name = "Jandice Barov", id = 10503 },
    { name = "Rattlegore", id = 11622 },
    { name = "Vectus and Marduk Blackpool", ids = { 10433, 10432 }, all = true },
    { name = "Ras Frostwhisper", id = 10508 },
    { name = "Instructor Malicia", id = 10505 },
    { name = "Doctor Theolen Krastinov", id = 11261 },
    { name = "Lorekeeper Polkelt", id = 10901 },
    { name = "The Ravenian", id = 10507 },
    { name = "Lord Alexei Barov", id = 10504 },
    { name = "Lady Illucia Barov", id = 10502 },
    { name = "Darkmaster Gandling", id = 1853 },
  },
  ["Blackrock Spire"] = {
    -- Lower Blackrock Spire (LBRS)
    { name = "Highlord Omokk", id = 9196 },
    { name = "Shadow Hunter Vosh'gajin", id = 9236 },
    { name = "War Master Voone", id = 9237 },
    { name = "Mother Smolderweb", id = 10596 },
    { name = "Urok Doomhowl", id = 10584 },
    { name = "Quartermaster Zigris", id = 9736 },
    { name = "Halycon", id = 10220 },
    { name = "Gizrul the Slavener", id = 10268 },
    { name = "Overlord Wyrmthalak", id = 9568 },
    -- Upper Blackrock Spire (UBRS)
    { name = "Pyroguard Emberseer", id = 9816 },
    { name = "Solakar Flamewreath", id = 10264 },
    { name = "Goraluk Anvilcrack", id = 10899 },
    { name = "Warchief Rend Blackhand", id = 10429 },
    { name = "The Beast", id = 10430 },
    { name = "General Drakkisath", id = 10363 },
  },
}

-- Scarlet Monastery: one instance name for all wings (Graveyard / Library / Armory / Cathedral).
-- Core.lua picks bosses by GetSubZoneText() matching one of `match` (Koality-of-Life style).
BossTracker_ScarletMonasteryWings = {
  {
    match = { "Graveyard", "Chamber of Atonement", "Forlorn Cloister", "Honor's Tomb" },
    bosses = {
      { name = "Interrogator Vishas", id = 3983 },
      { name = "Bloodmage Thalnos", id = 4543 },
    },
  },
  {
    match = { "Library", "Huntsman's Cloister", "Gallery of Treasures", "Athenaeum" },
    bosses = {
      { name = "Houndmaster Loksey", id = 3974 },
      { name = "Arcanist Doan", id = 6487 },
    },
  },
  {
    match = { "Training Grounds", "Footman's Armory", "Crusader's Armory", "Hall of Champions" },
    bosses = {
      { name = "Herod", id = 3975 },
    },
  },
  {
    match = { "Cathedral", "Chapel Gardens", "Crusader's Chapel" },
    bosses = {
      { name = "High Inquisitor Fairbanks", id = 4542 },
      { name = "Scarlet Commander Mograine", id = 3976 },
      { name = "High Inquisitor Whitemane", id = 3977 },
    },
  },
}

BossTracker_ScarletMonasteryMerged = {}
do
  local t = BossTracker_ScarletMonasteryMerged
  for _, wing in ipairs(BossTracker_ScarletMonasteryWings) do
    for _, b in ipairs(wing.bosses) do
      table.insert(t, b)
    end
  end
end

-- Dire Maul: one instance name for three wings (East / North / West).
-- Core.lua picks bosses by GetSubZoneText() matching one of `match`.
BossTracker_DireMaulWings = {
  {
    -- East
    match = { "Warpwood Quarter" },
    bosses = {
      { name = "Zevrim Thornhoof", id = 11490 },
      { name = "Hydrospawn", id = 13280 },
      { name = "Lethtendris", id = 14327 },
      { name = "Alzzin the Wildshaper", id = 11492 },
    },
  },
  {
    -- North
    match = { "Halls of Destruction" },
    bosses = {
      { name = "Guard Mol'dar", id = 14326 },
      { name = "Stomper Kreeg", id = 14322 },
      { name = "Guard Fengus", id = 14321 },
      { name = "Guard Slip'kik", id = 14323 },
      { name = "Captain Kromcrush", id = 14325 },
      { name = "King Gordok", id = 11501 },
    },
  },
  {
    -- West
    match = { "Capital Gardens" },
    bosses = {
      { name = "Tendris Warpwood", id = 11489 },
      { name = "Magister Kalendris", id = 11487 },
      { name = "Illyanna Ravenoak", id = 11488 },
      { name = "Immol'thar", id = 11496 },
      { name = "Prince Tortheldrin", id = 11486 },
    },
  },
}

BossTracker_DireMaulMerged = {}
do
  local t = BossTracker_DireMaulMerged
  for _, wing in ipairs(BossTracker_DireMaulWings) do
    for _, b in ipairs(wing.bosses) do
      table.insert(t, b)
    end
  end
end

-- GetInstanceInfo() name for Violet Hold is inconsistent: some clients return "Violet Hold"
-- without "The", which would leave the boss list empty (no matching key above).
if BossTracker_BossData["The Violet Hold"] then
  BossTracker_BossData["Violet Hold"] = BossTracker_BossData["The Violet Hold"]
end

