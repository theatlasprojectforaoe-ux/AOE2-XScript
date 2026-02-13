/* --- HEADERS --- */

/* --- CONSTANTS --- */
// Unit IDs
int hw_cUnitWolf = 126;
int hw_cUnitJaguar = 812;
int hw_cUnitSnowLeopard = 1251;
int hw_cUnitBear = 486;
int hw_cUnitKomodo = 1137;
int hw_cUnitTiger = 1135;
int hw_cUnitLion = 1029;
int hw_cUnitMonk = 125;
int hw_cUnitMuleCart = 1759;
int hw_cUnitScoutCavalry = 448;
int hw_cUnitSheep = 594;
int hw_cUnitCow = 705;
int hw_cUnitLlama = 833;
int hw_cUnitWaterBuffalo = 1142;
int hw_cUnitVillager = 83;
int hw_cUnitVillagerFemale = 293;
int hw_cUnitHawk = 96;
int hw_cUnitEagleScout = 751;
int hw_cUnitCamelScout = 1755;
int hw_cUnitLegionary = 1795; // Legionary (Romans)

// Effect and Object IDs
int hw_cEffectSpawnUnit = 7;   // Effect: Spawn Unit (Correct ID is 7, not 102)
int hw_cModResource = 6;   // Effect: Modify Resource
int hw_cMulAttribute = 5;  // Effect: Multiply Attribute

// Resource IDs
int hw_cFood = 0;
int hw_cWood = 1;
int hw_cStone = 2;
int hw_cGold = 3;
int hw_cAttrAdd = 1;       // Attribute: Add
int hw_cAttrMoveSpeed = 5; // Attribute: Move Speed
int hw_cAttrPierceArmor = 9; // Attribute: Pierce Armor
int hw_cTownCenter = 109;  // Unit: Town Center

// Civilization IDs
int hw_cCivBritons = 1;
int hw_cCivFranks = 2;
int hw_cCivGoths = 3;
int hw_cCivTeutons = 4;
int hw_cCivJapanese = 5;
int hw_cCivChinese = 6;
int hw_cCivByzantines = 7;
int hw_cCivPersians = 8;
int hw_cCivSaracens = 9;
int hw_cCivTurks = 10;
int hw_cCivVikings = 11;
int hw_cCivMongols = 12;
int hw_cCivCelts = 13;
int hw_cCivSpanish = 14;
int hw_cCivAztecs = 15;
int hw_cCivMayans = 16;
int hw_cCivHuns = 17;
int hw_cCivKoreans = 18;
int hw_cCivItalians = 19;
int hw_cCivHindustanis = 20;
int hw_cCivIncas = 21;
int hw_cCivMagyars = 22;
int hw_cCivSlavs = 23;
int hw_cCivPortuguese = 24;
int hw_cCivEthiopians = 25;
int hw_cCivMalians = 26;
int hw_cCivBerbers = 27;
int hw_cCivKhmer = 28;
int hw_cCivMalay = 29;
int hw_cCivBurmese = 30;
int hw_cCivVietnamese = 31;
int hw_cCivBulgarians = 32;
int hw_cCivTatars = 33;
int hw_cCivCumans = 34;
int hw_cCivLithuanians = 35;
int hw_cCivBurgundians = 36;
int hw_cCivSicilians = 37;
int hw_cCivPoles = 38;
int hw_cCivBohemians = 39;
int hw_cCivDravidians = 40;
int hw_cCivBengalis = 41;
int hw_cCivGurjaras = 42;
int hw_cCivRomans = 43;
int hw_cCivArmenians = 44;
int hw_cCivGeorgians = 45;
int hw_cUnitStateAlive = 2;

/* --- GLOBAL VARIABLES --- */
// Array to track if starting resources have been granted. Index corresponds to player ID.
int hw_resDoneArray = -1; // Will be initialized in main()
int hw_petsDoneArray = -1; // Track if pets have been spawned
int hw_testudoActiveArray = -1; // Track if Testudo is active for player

/* --- RULES --- */
// RULE 1: Grant Resources (Runs once per player at game start)
rule hw_GrantResources
active
highFrequency
{
    int hw_playerID = 1;

    // Loop through all 8 possible players.
    while(hw_playerID <= 8) {
        
        // Check the states for the current playerID
        bool hw_isResDone = xsArrayGetBool(hw_resDoneArray, hw_playerID);

        // If this player is not done with resources
        if (hw_isResDone == false) {
            int hw_civID = xsGetPlayerCivilization(hw_playerID);
            
            // If civID is 0, the player slot is empty. Mark as done so we don't check again.
            if (hw_civID <= 0) {
                xsArraySetBool(hw_resDoneArray, hw_playerID, true);
            }
            else {
                // Only set context if player exists to avoid crashes on empty slots
                xsSetContextPlayer(hw_playerID);
                    float current_res = 0.0;

                    // Grant Civilization Specific Resources
                    switch(hw_civID) {
                        case hw_cCivBritons: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cGold);
                        xsSetPlayerAttribute(hw_playerID, hw_cGold, current_res + 400.0);
                            break;
                        }
                        case hw_cCivFranks: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 300.0);
                        current_res = xsPlayerAttribute(hw_playerID, hw_cStone);
                        xsSetPlayerAttribute(hw_playerID, hw_cStone, current_res + 200.0);
                            break;
                        }
                        case hw_cCivGoths: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 300.0);
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 250.0);
                            break;
                        }
                        case hw_cCivTeutons: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 250.0);
                        current_res = xsPlayerAttribute(hw_playerID, hw_cStone);
                        xsSetPlayerAttribute(hw_playerID, hw_cStone, current_res + 250.0);
                            break;
                        }
                        case hw_cCivJapanese: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivChinese: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 400.0);
                        current_res = xsPlayerAttribute(hw_playerID, hw_cStone);
                        xsSetPlayerAttribute(hw_playerID, hw_cStone, current_res + 300.0);
                            break;
                        }
                        case hw_cCivByzantines: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cGold);
                        xsSetPlayerAttribute(hw_playerID, hw_cGold, current_res + 350.0);
                        current_res = xsPlayerAttribute(hw_playerID, hw_cStone);
                        xsSetPlayerAttribute(hw_playerID, hw_cStone, current_res + 250.0);
                            break;
                        }
                        case hw_cCivPersians: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivSaracens: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cStone);
                        xsSetPlayerAttribute(hw_playerID, hw_cStone, current_res + 500.0);
                            break;
                        }
                        case hw_cCivTurks: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cGold);
                        xsSetPlayerAttribute(hw_playerID, hw_cGold, current_res + 550.0);
                            break;
                        }
                        case hw_cCivVikings: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivMongols: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivCelts: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivSpanish: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cGold);
                        xsSetPlayerAttribute(hw_playerID, hw_cGold, current_res + 300.0);
                        current_res = xsPlayerAttribute(hw_playerID, hw_cStone);
                        xsSetPlayerAttribute(hw_playerID, hw_cStone, current_res + 250.0);
                            break;
                        }
                        case hw_cCivAztecs: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cGold);
                        xsSetPlayerAttribute(hw_playerID, hw_cGold, current_res + 300.0);
                        current_res = xsPlayerAttribute(hw_playerID, hw_cStone);
                        xsSetPlayerAttribute(hw_playerID, hw_cStone, current_res + 200.0);
                            break;
                        }
                        case hw_cCivMayans: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 300.0);
                        current_res = xsPlayerAttribute(hw_playerID, hw_cStone);
                        xsSetPlayerAttribute(hw_playerID, hw_cStone, current_res + 250.0);
                            break;
                        }
                        case hw_cCivHuns: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 400.0);
                            break;
                        }
                        case hw_cCivKoreans: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cStone);
                        xsSetPlayerAttribute(hw_playerID, hw_cStone, current_res + 500.0);
                            break;
                        }
                        case hw_cCivItalians: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cGold);
                        xsSetPlayerAttribute(hw_playerID, hw_cGold, current_res + 400.0);
                            break;
                        }
                        case hw_cCivHindustanis: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cGold);
                        xsSetPlayerAttribute(hw_playerID, hw_cGold, current_res + 400.0);
                            break;
                        }
                        case hw_cCivIncas: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cStone);
                        xsSetPlayerAttribute(hw_playerID, hw_cStone, current_res + 300.0);
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 200.0);
                            break;
                        }
                        case hw_cCivMagyars: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivSlavs: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivPortuguese: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cGold);
                        xsSetPlayerAttribute(hw_playerID, hw_cGold, current_res + 450.0);
                            break;
                        }
                        case hw_cCivEthiopians: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cGold);
                        xsSetPlayerAttribute(hw_playerID, hw_cGold, current_res + 450.0);
                            break;
                        }
                        case hw_cCivMalians: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivBerbers: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivKhmer: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 500.0);
                            break;
                        }
                        case hw_cCivMalay: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 500.0);
                            break;
                        }
                        case hw_cCivBurmese: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivVietnamese: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivBulgarians: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cStone);
                        xsSetPlayerAttribute(hw_playerID, hw_cStone, current_res + 500.0);
                            break;
                        }
                        case hw_cCivTatars: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 500.0);
                            break;
                        }
                        case hw_cCivCumans: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 500.0);
                            break;
                        }
                        case hw_cCivLithuanians: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivBurgundians: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cGold);
                        xsSetPlayerAttribute(hw_playerID, hw_cGold, current_res + 450.0);
                            break;
                        }
                        case hw_cCivSicilians: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cStone);
                        xsSetPlayerAttribute(hw_playerID, hw_cStone, current_res + 450.0);
                            break;
                        }
                        case hw_cCivPoles: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivBohemians: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cGold);
                        xsSetPlayerAttribute(hw_playerID, hw_cGold, current_res + 450.0);
                            break;
                        }
                        case hw_cCivDravidians: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 400.0);
                            break;
                        }
                        case hw_cCivBengalis: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivGurjaras: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivRomans: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 350.0);
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 350.0);
                        current_res = xsPlayerAttribute(hw_playerID, hw_cGold);
                        xsSetPlayerAttribute(hw_playerID, hw_cGold, current_res + 350.0);
                            break;
                        }
                        case hw_cCivArmenians: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                        xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 450.0);
                            break;
                        }
                        case hw_cCivGeorgians: {
                        current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                        xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 450.0);
                            break;
                        }
                        default: {
                            // Fallback: If no civilization matched, give a generic bonus.
                            current_res = xsPlayerAttribute(hw_playerID, hw_cFood);
                            xsSetPlayerAttribute(hw_playerID, hw_cFood, current_res + 200.0);
                            current_res = xsPlayerAttribute(hw_playerID, hw_cWood);
                            xsSetPlayerAttribute(hw_playerID, hw_cWood, current_res + 200.0);
                            current_res = xsPlayerAttribute(hw_playerID, hw_cGold);
                            xsSetPlayerAttribute(hw_playerID, hw_cGold, current_res + 200.0);
                            break;
                        }
                    }

                    // Mark Resources as done
                    xsArraySetBool(hw_resDoneArray, hw_playerID, true);
            }
        }
        
        hw_playerID = hw_playerID + 1;
    }
    
    // Disable this rule immediately so resources are never granted twice
    xsDisableSelf();
    
    // Enable the pet spawning rule
    xsEnableRule("hw_SpawnPets");
}

// RULE 2: Spawn Pets (Waits for valid spawn point)
rule hw_SpawnPets
inactive
highFrequency
{
    int hw_playerID = 1;
    int hw_playersDone = 0;
    int hw_totalPlayers = 0;
    
    // Loop through all 8 possible players.
    while(hw_playerID <= 8) {
        int hw_civID = xsGetPlayerCivilization(hw_playerID);
        
        if (hw_civID > 0) {
            hw_totalPlayers = hw_totalPlayers + 1;
            
            if (xsArrayGetBool(hw_petsDoneArray, hw_playerID) == false) {
            xsSetContextPlayer(hw_playerID);
            
            // Determine wolf type based on Civilization
            int hw_wolfType = hw_cUnitWolf; // Default

            if ( (hw_civID == hw_cCivVikings) || (hw_civID == hw_cCivSlavs) || (hw_civID == hw_cCivLithuanians) ) {
                hw_wolfType = hw_cUnitSnowLeopard;
            }
            else if ( (hw_civID == hw_cCivAztecs) || (hw_civID == hw_cCivMayans) || (hw_civID == hw_cCivIncas) ) {
                hw_wolfType = hw_cUnitJaguar;
            }
            else if ( (hw_civID == hw_cCivHindustanis) || (hw_civID == hw_cCivGurjaras) || (hw_civID == hw_cCivDravidians) || (hw_civID == hw_cCivBengalis) ) {
                hw_wolfType = hw_cUnitTiger;
            }
            else if ( (hw_civID == hw_cCivMalay) || (hw_civID == hw_cCivKhmer) || (hw_civID == hw_cCivVietnamese) || (hw_civID == hw_cCivBurmese) ) {
                hw_wolfType = hw_cUnitKomodo;
            }
            else if ( (hw_civID == hw_cCivSaracens) || (hw_civID == hw_cCivBerbers) || (hw_civID == hw_cCivEthiopians) || (hw_civID == hw_cCivMalians) ) {
                hw_wolfType = hw_cUnitLion;
            }
            else if ( (hw_civID == hw_cCivTeutons) || (hw_civID == hw_cCivGoths) || (hw_civID == hw_cCivHuns) || (hw_civID == hw_cCivMongols) ) {
                hw_wolfType = hw_cUnitBear;
            }
            
            // Attempt to spawn at Town Center first
            if (xsGetObjectCount(hw_playerID, hw_cTownCenter) > 0) {
                    xsEffectAmount(hw_cEffectSpawnUnit, hw_wolfType, hw_cTownCenter, 1.0, hw_playerID);
                    xsArraySetBool(hw_petsDoneArray, hw_playerID, true);
            }
            // Fallback: Villager (Male)
            else if (xsGetObjectCount(hw_playerID, hw_cUnitVillager) > 0) {
                    xsEffectAmount(hw_cEffectSpawnUnit, hw_wolfType, hw_cUnitVillager, 1.0, hw_playerID);
                    xsArraySetBool(hw_petsDoneArray, hw_playerID, true);
            }
            // Fallback: Villager (Female)
            else if (xsGetObjectCount(hw_playerID, hw_cUnitVillagerFemale) > 0) {
                    xsEffectAmount(hw_cEffectSpawnUnit, hw_wolfType, hw_cUnitVillagerFemale, 1.0, hw_playerID);
                    xsArraySetBool(hw_petsDoneArray, hw_playerID, true);
            }
            // Fallback: Scout Cavalry
            else if (xsGetObjectCount(hw_playerID, hw_cUnitScoutCavalry) > 0) {
                    xsEffectAmount(hw_cEffectSpawnUnit, hw_wolfType, hw_cUnitScoutCavalry, 1.0, hw_playerID);
                    xsArraySetBool(hw_petsDoneArray, hw_playerID, true);
            }
            // Fallback: Eagle Scout
            else if (xsGetObjectCount(hw_playerID, hw_cUnitEagleScout) > 0) {
                    xsEffectAmount(hw_cEffectSpawnUnit, hw_wolfType, hw_cUnitEagleScout, 1.0, hw_playerID);
                    xsArraySetBool(hw_petsDoneArray, hw_playerID, true);
            }
            // Fallback: Camel Scout
            else if (xsGetObjectCount(hw_playerID, hw_cUnitCamelScout) > 0) {
                    xsEffectAmount(hw_cEffectSpawnUnit, hw_wolfType, hw_cUnitCamelScout, 1.0, hw_playerID);
                    xsArraySetBool(hw_petsDoneArray, hw_playerID, true);
            }
            // Fallback: Mule Cart
            else if (xsGetObjectCount(hw_playerID, hw_cUnitMuleCart) > 0) {
                    xsEffectAmount(hw_cEffectSpawnUnit, hw_wolfType, hw_cUnitMuleCart, 1.0, hw_playerID);
                    xsArraySetBool(hw_petsDoneArray, hw_playerID, true);
                }
            }
            else {
                hw_playersDone = hw_playersDone + 1;
            }
        }
        
        hw_playerID = hw_playerID + 1;
    }
    
    // Only disable if all active players have received their pets
    if (hw_playersDone >= hw_totalPlayers) {
    xsDisableSelf();
    }
}

// RULE 3: Legionary Formation (Keep Formation)
// Forces Legionaries to Stand Ground stance to simulate discipline
rule hw_LegionaryDiscipline
active
minInterval 5
{
    int hw_playerID = 1;
    while(hw_playerID <= 8) {
        if (xsGetPlayerCivilization(hw_playerID) == hw_cCivRomans) {
            // Reset formation spacing to 0 to keep them tight
            // Note: This is a best-effort simulation as direct formation control is limited
            xsEffectAmount(hw_cModResource, hw_cUnitLegionary, 44, 0.0, hw_playerID); // 44 = Blast Attack Level (often unused, safe placeholder)
        }
        hw_playerID = hw_playerID + 1;
    }
}

// RULE 4: Testudo Formation (Stats Modifier)
// Applies Testudo stats to Roman Legionaries: -50% Speed, +10 Pierce Armor
rule hw_TestudoFormation
active
minInterval 3
{
    int hw_playerID = 1;
    while(hw_playerID <= 8) {
        if (xsGetPlayerCivilization(hw_playerID) == hw_cCivRomans) {
            xsSetContextPlayer(hw_playerID);
            
            // Check current state
            bool isActive = xsArrayGetBool(hw_testudoActiveArray, hw_playerID);

            if (isActive == false) {
                // Activate Testudo: -50% Speed, +10 Pierce Armor
                xsEffectAmount(hw_cMulAttribute, hw_cUnitLegionary, hw_cAttrMoveSpeed, 0.5, hw_playerID);
                xsEffectAmount(hw_cAttrAdd, hw_cUnitLegionary, hw_cAttrPierceArmor, 10.0, hw_playerID);
                xsArraySetBool(hw_testudoActiveArray, hw_playerID, true);
            } else {
                // Deactivate Testudo: Reset Speed (x2.0), Reset Armor (-10)
                xsEffectAmount(hw_cMulAttribute, hw_cUnitLegionary, hw_cAttrMoveSpeed, 2.0, hw_playerID);
                // Note: Adding negative value to subtract
                xsEffectAmount(hw_cAttrAdd, hw_cUnitLegionary, hw_cAttrPierceArmor, (0.0 - 10.0), hw_playerID);
                xsArraySetBool(hw_testudoActiveArray, hw_playerID, false);
            }
        }
        hw_playerID = hw_playerID + 1;
    }
}

/* --- MAIN --- */
// The main() function is executed when the map is generated.
void main() {
    // Initialize the global array for tracking resource grants.
    // Array is size 9 (for players 1-8, index 0 is unused).
    // All values are initialized to false.
    hw_resDoneArray = xsArrayCreateBool(9, false, "resDone");
    hw_petsDoneArray = xsArrayCreateBool(9, false, "petsDone");
    hw_testudoActiveArray = xsArrayCreateBool(9, false, "testudoActive");
}