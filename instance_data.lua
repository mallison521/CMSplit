CMSplit.LastBosses = {
  -- TBC
  [543] = "Vazruden the Herald",          -- Hellfire Ramparts
  [542] = "Keli'dan the Breaker",           -- Blood Furnace
  [547] = "Quagmirran",                     -- The Slave Pens
  [546] = "The Black Stalker",              -- The Underbog
  [557] = "Nexus-Prince Shaffar",           -- Mana-Tombs
  [558] = "Exarch Maladaar",                -- Auchenai Crypts
  [556] = "Talon King Ikiss",               -- Sethekk Halls
  [555] = "Murmur",                         -- Shadow Labyrinth
  [554] = "Pathaleon the Calculator",       -- The Mechanar
  [553] = "Warp Splinter",                  -- The Botanica
  [552] = "Harbinger Skyriss",              -- The Arcatraz
  [585] = "Kael'thas Sunstrider",           -- Magisters' Terrace

  -- WotLK
  [574] = "Ingvar the Plunderer",           -- Utgarde Keep
  [576] = "Keristrasza",                    -- The Nexus
  [601] = "Anub'arak",                      -- Azjol-Nerub
  [619] = "Herald Volazj",                  -- Ahn'kahet
  [600] = "King Dred",                      -- Drak'Tharon Keep
  [608] = "Cyanigosa",                      -- Violet Hold
  [604] = "Gal'darah",                      -- Gundrak
  [599] = "Sjonnir The Ironshaper",         -- Halls of Stone
  [602] = "Loken",                          -- Halls of Lightning
  [595] = "Mal'Ganis",                      -- Culling of Stratholme
  [575] = "King Ymiron",                    -- Utgarde Pinnacle
  [578] = "Ley-Guardian Eregos",            -- The Oculus
  [650] = "The Black Knight",               -- Trial of the Champion
  [632] = "Bronjahm",                       -- Forge of Souls
  [658] = "Scourgelord Tyrannus",           -- Pit of Saron
  [668] = "The Lich King",                  -- Halls of Reflection

  -- Cata
  [645] = "Ascendant Lord Obsidius",        -- Blackrock Caverns
  [657] = "High Priestess Azil",            -- Stonecore
  [643] = "Altairus",                       -- Vortex Pinnacle
  [670] = "Erudax",                         -- Grim Batol
  [644] = "Rajh",                           -- Halls of Origination
  [755] = "Siamat",                         -- Lost City of the Tol'vir
  [725] = "Ozumat",                         -- Throne of the Tides
  [33]  = "Lord Godfrey",                   -- Shadowfang Keep (rework)
  [859] = "Daakara",                        -- Zul'Gurub (rework)

  -- MoP
  [960] = "Sha of Doubt",                   -- Temple of the Jade Serpent
  [961] = "Yan-Zhu the Uncasked",           -- Stormstout Brewery
  [959] = "Taran Zhu",                      -- Shado-Pan Monastery
  [962] = "Xin the Weaponmaster",           -- Siege of Niuzao Temple
  [994] = "Xin the Weaponmaster",           -- Mogu'shan Palace
  [1001] = "Flameweaver Koegler",           -- Scarlet Halls
  [1004] = "High Inquisitor Whitemane",     -- Scarlet Monastery
  [1007] = "Darkmaster Gandling",           -- Scholomance
}

CMSplit.MedalTimes = {
  -- MoP Official Challenge Mode Times
  [960] = { gold = 15 * 60, silver = 25 * 60, bronze = 45 * 60 }, -- Temple of the Jade Serpent
  [961] = { gold = 12 * 60 + 30, silver = 21 * 60, bronze = 45 * 60 }, -- Stormstout Brewery
  [962] = { gold = 19 * 60, silver = 30 * 60, bronze = 50 * 60 }, -- Siege of Niuzao Temple
  [959] = { gold = 21 * 60, silver = 35 * 60, bronze = 60 * 60 }, -- Shado-Pan Monastery
  [994] = { gold = 14 * 60, silver = 24 * 60, bronze = 45 * 60 }, -- Mogu'shan Palace
  [1001] = { gold = 13 * 60 + 30, silver = 22 * 60, bronze = 45 * 60 }, -- Scarlet Halls
  [1004] = { gold = 13 * 60 + 30, silver = 22 * 60, bronze = 45 * 60 }, -- Scarlet Monastery
  [1007] = { gold = 20 * 60, silver = 33 * 60, bronze = 55 * 60 }, -- Scholomance
  [958] = { gold = 13 * 60 + 30, silver = 22 * 60, bronze = 45 * 60 }, -- Gate of the Setting Sun (assuming 958)

  -- Dummy values for TBC (543–585)
  [543] = { gold = 12 * 60, silver = 18 * 60, bronze = 30 * 60 }, -- Hellfire Ramparts
  [542] = { gold = 1 * 60, silver = 15 * 60, bronze = 20 * 60 }, -- Blood Furnace
  [547] = { gold = 13 * 60, silver = 19 * 60, bronze = 31 * 60 }, -- Slave Pens
  [546] = { gold = 14 * 60, silver = 21 * 60, bronze = 34 * 60 },
  [548] = { gold = 14 * 60, silver = 21 * 60, bronze = 34 * 60 },
  [545] = { gold = 14 * 60, silver = 21 * 60, bronze = 34 * 60 },
  [557] = { gold = 15 * 60, silver = 22 * 60, bronze = 35 * 60 },
  [558] = { gold = 15 * 60, silver = 22 * 60, bronze = 36 * 60 },
  [556] = { gold = 16 * 60, silver = 23 * 60, bronze = 37 * 60 },
  [555] = { gold = 17 * 60, silver = 24 * 60, bronze = 38 * 60 },
  [554] = { gold = 17 * 60, silver = 25 * 60, bronze = 39 * 60 },
  [553] = { gold = 18 * 60, silver = 26 * 60, bronze = 40 * 60 },
  [552] = { gold = 18 * 60, silver = 27 * 60, bronze = 41 * 60 },
  [585] = { gold = 19 * 60, silver = 28 * 60, bronze = 42 * 60 },

  -- Dummy values for WotLK (574–668)
  [574] = { gold = 16 * 60, silver = 24 * 60, bronze = 38 * 60 },
  [576] = { gold = 17 * 60, silver = 25 * 60, bronze = 39 * 60 },
  [601] = { gold = 15 * 60, silver = 22 * 60, bronze = 36 * 60 },
  [619] = { gold = 18 * 60, silver = 27 * 60, bronze = 41 * 60 },
  [600] = { gold = 16 * 60, silver = 24 * 60, bronze = 38 * 60 },
  [608] = { gold = 13 * 60, silver = 20 * 60, bronze = 32 * 60 },
  [604] = { gold = 19 * 60, silver = 28 * 60, bronze = 43 * 60 },
  [599] = { gold = 17 * 60, silver = 25 * 60, bronze = 39 * 60 },
  [602] = { gold = 20 * 60, silver = 30 * 60, bronze = 45 * 60 },
  [595] = { gold = 21 * 60, silver = 31 * 60, bronze = 46 * 60 },
  [575] = { gold = 20 * 60, silver = 30 * 60, bronze = 45 * 60 },
  [578] = { gold = 19 * 60, silver = 28 * 60, bronze = 44 * 60 },
  [650] = { gold = 15 * 60, silver = 23 * 60, bronze = 37 * 60 },
  [632] = { gold = 14 * 60, silver = 22 * 60, bronze = 36 * 60 },
  [658] = { gold = 22 * 60, silver = 33 * 60, bronze = 50 * 60 },
  [668] = { gold = 23 * 60, silver = 35 * 60, bronze = 52 * 60 },

  -- Dummy values for Cata (645–859)
  [645] = { gold = 14 * 60, silver = 21 * 60, bronze = 33 * 60 },
  [657] = { gold = 15 * 60, silver = 22 * 60, bronze = 34 * 60 },
  [643] = { gold = 13 * 60, silver = 20 * 60, bronze = 32 * 60 },
  [670] = { gold = 16 * 60, silver = 24 * 60, bronze = 36 * 60 },
  [644] = { gold = 18 * 60, silver = 26 * 60, bronze = 39 * 60 },
  [755] = { gold = 17 * 60, silver = 25 * 60, bronze = 37 * 60 },
  [725] = { gold = 14 * 60, silver = 21 * 60, bronze = 33 * 60 },
  [33]  = { gold = 15 * 60, silver = 23 * 60, bronze = 35 * 60 },
  [859] = { gold = 18 * 60, silver = 27 * 60, bronze = 40 * 60 },
}
