class Toby_MenuOutputBySoundBindings
{
    ui Dictionary menuStateAsDictionary;
    Toby_SoundBindingsContainer menuSoundBindingsContainer;

    ui static Toby_MenuOutputBySoundBindings Create(Toby_SoundBindingsContainer menuSoundBindingsContainer)
    {
        Toby_MenuOutputBySoundBindings strategy = new("Toby_MenuOutputBySoundBindings");
        strategy.menuSoundBindingsContainer = menuSoundBindingsContainer;
        strategy.menuStateAsDictionary = Dictionary.Create();
        return strategy;
    }

    ui void Output(Toby_MenuState currentState, Toby_MenuState previousState, int detectedChange)
    {
        if (detectedChange == Toby_MenuState.NoChanges) { return; }

        if ((currentState.menuClass == "Toby_ItemsMenu" || currentState.menuClass == "Toby_WeaponsMenu")
            && (previousState.menuClass == "Toby_ItemsMenu" || previousState.menuClass == "Toby_WeaponsMenu")
            && detectedChange == Toby_MenuState.OptionChanged
        )
        {
            HandleMenuItemWithQueue(currentState);
            return;
        }

        if (
            ((currentState.menuClass == "Toby_MarkerExplorationUnexploredMenu")
            || (currentState.menuClass == "Toby_MarkerExplorationNonInteractedMenu")
            || (currentState.menuClass == "Toby_MarkerExplorationKeysMenu")
            || (currentState.menuClass == "Toby_MarkerExplorationPickupsMenu")
            || (currentState.menuClass == "Toby_MarkerExplorationTeleportersMenu"))
            &&
            ((previousState.menuClass == "Toby_MarkerExplorationUnexploredMenu")
            || (previousState.menuClass == "Toby_MarkerExplorationNonInteractedMenu")
            || (previousState.menuClass == "Toby_MarkerExplorationKeysMenu")
            || (previousState.menuClass == "Toby_MarkerExplorationPickupsMenu")
            || (previousState.menuClass == "Toby_MarkerExplorationTeleportersMenu"))
            && detectedChange == Toby_MenuState.OptionChanged
        )
        {
            HandleMarkerExplorationMenus(currentState);
            return;
        }
        if (currentState.menuClass == "Toby_MarkerExplorationMenuLegacy"
            && previousState.menuClass == "Toby_MarkerExplorationMenuLegacy"
            && detectedChange == Toby_MenuState.OptionChanged
        )
        {
            HandleMarkerExplorationMenuLegacy(currentState);
            return;
        }

        if (detectedChange > 0
            && detectedChange != Toby_MenuState.SaveSlotChanged
            && detectedChange != Toby_MenuState.KeyPressed)
        {
            FindAndPlayDictionaryEntryForEvent(currentState, previousState, detectedChange);
            return;
        }
        //Basic save load handling
        else if (detectedChange == Toby_MenuState.SaveSlotChanged)
        {
            HandleSaveSlotChangedEvent(currentState);
        }
        //Left and Right handling
        else if (detectedChange == Toby_MenuState.KeyPressed)
        {
            Toby_Logger.Message("Is slider: "..currentState.isSlider, "Toby_Developer_ControlType");
            Toby_Logger.Message("Is field: "..currentState.isField, "Toby_Developer_ControlType");
            Toby_Logger.Message("Is option: "..currentState.isOption, "Toby_Developer_ControlType");
            Toby_Logger.Message("Is control: "..currentState.isControl, "Toby_Developer_ControlType");
            Toby_Logger.Message("Is saveLoad: "..currentState.isSaveLoad, "Toby_Developer_ControlType");
            if (currentState.lastKeyPressed == UiEvent.Key_Left || currentState.lastKeyPressed == UiEvent.Key_Right)
            {
                HandleLeftRightKeyPress(currentState);
            }
        }
    }

    ui void FindAndPlayDictionaryEntryForEvent(Toby_MenuState currentState, Toby_MenuState previousState, int detectedChange)
    {
        ConvertStatesToDictionary(currentState, previousState);
        string eventType = GetEventTypeAsString(detectedChange);

        for (int i = 0; i < menuSoundBindingsContainer.soundBindings.Size(); i++)
        {
            if (menuSoundBindingsContainer.soundBindings[i].At("EventType") != eventType) { continue; }
            bool isCorrectCondition = true;
            DictionaryIterator di = DictionaryIterator.Create(menuSoundBindingsContainer.soundBindings[i]);
            while (di.Next())
            {
                if (di.Key() == "EventType") { continue; }
                if (di.Key() == "SoundToPlay") { continue; }

                if (di.Value() != menuStateAsDictionary.At(di.Key()))
                {
                    isCorrectCondition = false;
                    break;
                }
            }
            if (isCorrectCondition)
            {
                if (CVar.FindCvar("Toby_StopAllSoundsBeforePlayingNewOne").GetBool())
                {
                    System.StopAllSounds();
                }
                Toby_SoundQueueStaticHandler.Clear();
                Toby_SoundQueueStaticHandler.AddSound(menuSoundBindingsContainer.soundBindings[i].At("SoundToPlay"), -1);

                //A bit optimistic but should be enough -P
                if (currentState.menuItemsCount == 0 && detectedChange == Toby_MenuState.MenuChanged)
                {
                    Toby_SoundQueueStaticHandler.AddSound("alphabet/Space", -1);
                    Toby_SoundQueueStaticHandler.AddSound("menusnd/nomenuitems", -1);
                }
                if (currentState.isControl)
                {
                    Toby_SoundQueue keybindSoundQueue = GetKeybindSound(currentState);
                    Toby_SoundQueueStaticHandler.AddQueue(keybindSoundQueue);
                }
                Toby_SoundQueueStaticHandler.PlayQueue(0);
                break;
            }
        }
    }

    ui void ConvertStatesToDictionary(Toby_MenuState currentState, Toby_MenuState previousState)
    {
        menuStateAsDictionary.Insert("CurrentMenuClass", currentState.menuClass);
        menuStateAsDictionary.Insert("PreviousMenuClass", previousState.menuClass);
        menuStateAsDictionary.Insert("CurrentMenuName", currentState.menuName);
        menuStateAsDictionary.Insert("PreviousMenuName", previousState.menuName);

        menuStateAsDictionary.Insert("CurrentMenuItemListSelectableString", currentState.mItemListSelectableString);
        menuStateAsDictionary.Insert("PreviousMenuItemListSelectableString", previousState.mItemListSelectableString);
        menuStateAsDictionary.Insert("CurrentMenuItemListTextString", currentState.mItemListTextString);
        menuStateAsDictionary.Insert("PreviousMenuItemListTextString", previousState.mItemListTextString);
        menuStateAsDictionary.Insert("CurrentMenuItemListTextStringLocalized", currentState.mItemListTextStringLocalized);
        menuStateAsDictionary.Insert("PreviousMenuItemListTextStringLocalized", previousState.mItemListTextStringLocalized);
        menuStateAsDictionary.Insert("CurrentMenuItemListPatchString", currentState.mItemListPatchString);
        menuStateAsDictionary.Insert("PreviousMenuItemListPatchString", previousState.mItemListPatchString);

        menuStateAsDictionary.Insert("CurrentMenuItemOptionName", currentState.mItemOptionName);
        menuStateAsDictionary.Insert("PreviousMenuItemOptionName", previousState.mItemOptionName);
        menuStateAsDictionary.Insert("CurrentMenuItemOptionNameLocalized", currentState.mItemOptionNameLocalized);
        menuStateAsDictionary.Insert("PreviousMenuItemOptionNameLocalized", previousState.mItemOptionNameLocalized);
        menuStateAsDictionary.Insert("CurrentMenuItemOptionValue", currentState.mItemOptionValue);
        menuStateAsDictionary.Insert("PreviousMenuItemOptionValue", previousState.mItemOptionValue);
        menuStateAsDictionary.Insert("CurrentMenuItemOptionValueLocalized", currentState.mItemOptionValueLocalized);
        menuStateAsDictionary.Insert("PreviousMenuItemOptionValueLocalized", previousState.mItemOptionValueLocalized);

        menuStateAsDictionary.Insert("CurrentConsoleState", ""..currentState.consoleStatus);
        menuStateAsDictionary.Insert("PreviousConsoleState", ""..previousState.consoleStatus);
        menuStateAsDictionary.Insert("CurrentGameState", ""..currentState.gameStatus);
        menuStateAsDictionary.Insert("PreviousGameState", ""..previousState.gameStatus);

        //Not need to be exposed
        //menuStateAsDictionary.Insert("CurrentLastKeyPressed", ""..currentState.lastKeyPressed);
        //menuStateAsDictionary.Insert("PreviousLastKeyPressed", ""..previousState.lastKeyPressed);
    }

    ui string GetEventTypeAsString(int detectedChange)
    {
        string eventType = "Unknown";
        switch (detectedChange)
        {
            case Toby_MenuState.NoChanges:
                eventType = "NoChanges"; break;
            case Toby_MenuState.MenuDismissed:
                eventType = "MenuDismissed"; break;
            case Toby_MenuState.MenuChanged:
                eventType = "MenuChanged"; break;
            case Toby_MenuState.OptionChanged:
                eventType = "OptionChanged"; break;
            case Toby_MenuState.OptionValueChanged:
                eventType = "OptionValueChanged"; break;
            case Toby_MenuState.KeyPressed:
                eventType = "KeyPressed"; break;
            case Toby_MenuState.SaveSlotChanged:
                eventType = "SaveSlotChanged"; break;
            case Toby_MenuState.GameStarted:
                eventType = "GameStarted"; break;
            case Toby_MenuState.GameLoaded:
                eventType = "GameLoaded"; break;
            case Toby_MenuState.GameSaved:
                eventType = "GameSaved"; break;
            case Toby_MenuState.ConsoleStateChanged:
                eventType = "ConsoleStateChanged"; break;
            case Toby_MenuState.GameStateChanged:
                eventType = "GameStateChanged"; break;
        }
        if (eventType == "Unknown")
        {
            Toby_Logger.Message("Unknown event type. Seems like an error happened.", "Toby_Developer");
        }
        return eventType;
    }

    ui void HandleSaveSlotChangedEvent(Toby_MenuState currentState)
    {
        Toby_SoundQueueStaticHandler.Clear();

        Toby_SoundQueue finalSoundQueue = Toby_SoundQueue.Create();
        //Option to disable word 'Slot' to shorten time to get more valuable information
        if (!CVar.FindCvar("Toby_SkipSlotWord").GetBool())
        {
            finalSoundQueue.AddSound("save/slot", -1);
        }

        Toby_NumberToSoundQueue saveSlotQueueBuilder = Toby_NumberToSoundQueue.Create();
        finalSoundQueue.AddQueue(saveSlotQueueBuilder.CreateQueueFromInt(currentState.saveGameSlot));

        //Option to disable 'of <total save slots>' to shorten time to get more valuable information
        if (!CVar.FindCVar("Toby_SkipTotalSlots").GetBool())
        {
            finalSoundQueue.AddSound("save/of", -1);

            Toby_NumberToSoundQueue totalSlotsQueueBuilder = Toby_NumberToSoundQueue.Create();
            finalSoundQueue.AddQueue(totalSlotsQueueBuilder.CreateQueueFromInt(currentState.saveGamesTotal));
        }

        if (currentState.isNewSlot)
        {
            finalSoundQueue.AddSound("save/new", -1);
        }
        else if (currentState.isAutosave)
        {
            finalSoundQueue.AddSound("save/autosave", -1);
        }
        else if (currentState.isQuicksave)
        {
            finalSoundQueue.AddSound("save/quicksave", -1);
        }
        else
        {
            Toby_StringToSoundQueue stringQueueBuilder = Toby_StringToSoundQueue.Create();
            finalSoundQueue.AddQueue(stringQueueBuilder.CreateQueueFromText(currentState.saveLoadValue));
        }
        Toby_SoundQueueStaticHandler.AddQueue(finalSoundQueue);
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui void HandleLeftRightKeyPress(Toby_MenuState currentState)
    {
        if (currentState.isSlider)
        {
            HandleLeftRightKeyPressForSlider(currentState);
        }
        if (currentState.isField)
        {
            HandleLeftRightKeyPressForField(currentState);
        }
        if (currentState.isSaveLoad && currentState.saveGamesTotal > 0)
        {
            HandleLeftRightKeyPressInSaveLoadMenu(currentState);
        }
    }

    ui void HandleLeftRightKeyPressForSlider(Toby_MenuState currentState)
    {
        Toby_SoundQueueStaticHandler.Clear();
        Toby_NumberToSoundQueue numberQueueBuilder = Toby_NumberToSoundQueue.Create();
        Toby_SoundQueueStaticHandler.AddQueue(numberQueueBuilder.CreateQueueFromFloatAsString(currentState.mItemOptionValue));
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui void HandleLeftRightKeyPressForField(Toby_MenuState currentState)
    {
        Toby_SoundQueueStaticHandler.Clear();
        Toby_StringToSoundQueue stringQueueBuilder = Toby_StringToSoundQueue.Create();
        Toby_SoundQueueStaticHandler.AddQueue(stringQueueBuilder.CreateQueueFromText(currentState.mItemOptionValue));
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui void HandleLeftRightKeyPressInSaveLoadMenu(Toby_MenuState currentState)
    {
        Toby_SoundQueueStaticHandler.Clear();
        Toby_SoundQueue finalSoundQueue = Toby_SoundQueue.Create();
        Toby_NumberToSoundQueue numberQueueBuilder = Toby_NumberToSoundQueue.Create();
        if (currentState.saveGameSlot >= 0 && !currentState.isNewSlot && currentState.lastKeyPressed == UiEvent.Key_Left)
        {
            if (currentState.saveGameDate != "null")
            {
                Toby_SaveGameTime time = Toby_SaveGameUtils.getTime(currentState.saveGameTime);
                Toby_SaveGameMap mapInfo = Toby_SaveGameUtils.getMapInfo(currentState.saveGameMap);

                //Episode (if any) and map
                if (mapInfo.isEpisodic)
                {
                    finalSoundQueue.AddSound("save/episode", -1);
                    finalSoundQueue.AddQueue(numberQueueBuilder.CreateQueueFromInt(mapInfo.episodeNumber));
                }
                finalSoundQueue.AddSound("save/map", -1);
                finalSoundQueue.AddQueue(numberQueueBuilder.CreateQueueFromInt(mapInfo.mapNumber));

                //Time spent
                finalSoundQueue.AddSound("save/timespent", -1);
                finalSoundQueue.AddSound("alphabet/Space", -1);
                finalSoundQueue.AddQueue(numberQueueBuilder.CreateQueueFromInt(time.hours));
                finalSoundQueue.AddSound("save/hours", -1);
                finalSoundQueue.AddQueue(numberQueueBuilder.CreateQueueFromInt(time.minutes));
                finalSoundQueue.AddSound("save/minutes", -1);
                finalSoundQueue.AddQueue(numberQueueBuilder.CreateQueueFromInt(time.seconds));
                finalSoundQueue.AddSound("save/seconds", -1);
            }
        }
        else if (currentState.saveGameSlot >= 0 && !currentState.isNewSlot && currentState.lastKeyPressed == UiEvent.Key_Right)
        {
            if (currentState.saveGameDate != "null")
            {
                Toby_SaveGameDate dateTime = Toby_SaveGameUtils.getDate(currentState.saveGameDate);
                Toby_MonthToSoundQueue monthToSoundQueueBuilder = Toby_MonthToSoundQueue.Create();
                finalSoundQueue.AddQueue(monthToSoundQueueBuilder.CreateQueueFromMonthNumber(dateTime.month));
                finalSoundQueue.AddQueue(numberQueueBuilder.CreateOrdinalQueueFromInt(dateTime.day));
                finalSoundQueue.AddQueue(numberQueueBuilder.CreateQueueFromInt(dateTime.year));
                finalSoundQueue.AddSound("alphabet/Space", -1);
                finalSoundQueue.AddSound("alphabet/Space", -1);
                finalSoundQueue.AddQueue(numberQueueBuilder.CreateQueueFromInt(dateTime.hours));
                finalSoundQueue.AddSound("save/hours", -1);
                finalSoundQueue.AddQueue(numberQueueBuilder.CreateQueueFromInt(dateTime.minutes));
                finalSoundQueue.AddSound("save/minutes", -1);
                finalSoundQueue.AddQueue(numberQueueBuilder.CreateQueueFromInt(dateTime.seconds));
                finalSoundQueue.AddSound("save/seconds", -1);
            }
        }
        Toby_SoundQueueStaticHandler.AddQueue(finalSoundQueue);
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui void HandleMenuItemWithQueue(Toby_MenuState currentState)
    {
        if (!currentState.soundQueue) { return; }
        Toby_SoundQueueStaticHandler.Clear();
        Toby_SoundQueueStaticHandler.AddQueue(currentState.soundQueue.Clone());
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui void HandleMarkerExplorationMenus(Toby_MenuState currentState)
    {
        if (currentState.mItemOptionNameLocalized == "Stop pathfinding")
        {
            Toby_SoundQueueStaticHandler.AddSound("pathfinder/stoppath", -1);
            Toby_SoundQueueStaticHandler.PlayQueue(0);
            return;
        }
        HandleMenuItemWithQueue(currentState);
    }
    ui void HandleMarkerExplorationMenuLegacy(Toby_MenuState currentState)
    {
        Toby_SoundQueueStaticHandler.Clear();
        if (currentState.mItemOptionNameLocalized == "Stop pathfinding")
        {
            Toby_SoundQueueStaticHandler.AddSound("pathfinder/stoppath", -1);
            Toby_SoundQueueStaticHandler.PlayQueue(0);
            return;
        }
        Array<String> pointOfInterest;
        currentState.mItemOptionNameLocalized.split(pointOfInterest, " - ", TOK_KEEPEMPTY);
        // console.printf(""..currentState.mItemOptionNameLocalized);

        if (pointOfInterest[0] == "Unexplored line")
        {
            Toby_SoundQueueStaticHandler.AddSound("pathfinder/unexplored", -1);
        }
        else if (pointOfInterest[0] == "Non-interacted line")
        {
            Toby_SoundQueueStaticHandler.AddSound("pathfinder/noninteracted", -1);
        }

        Toby_StringToSoundQueue stringSoundQueue = Toby_StringToSoundQueue.Create();
        Toby_SoundQueue directionSoundQueue = stringSoundQueue.CreateQueueFromDirection(pointOfInterest[1]);
        Toby_SoundQueueStaticHandler.AddQueue(directionSoundQueue);

        Toby_NumberToSoundQueue numberQueueBuilder = Toby_NumberToSoundQueue.Create();
        Toby_SoundQueueStaticHandler.AddQueue(numberQueueBuilder.CreateQueueFromInt(pointOfInterest[2].ToInt()));
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui Toby_SoundQueue GetKeybindSound(Toby_MenuState currentState)
    {
        Toby_SoundQueue finalSoundQueue = Toby_SoundQueue.Create();
        finalSoundQueue.AddSound("alphabet/Space", -1);
        Array<String> keys;
        currentState.menuItemKeybindDescription.split(keys, ", ", TOK_SKIPEMPTY);
        for (int i = 0; i < keys.Size(); i++)
        {
            Toby_StringToSoundQueue stringQueueBuilder = Toby_StringToSoundQueue.Create();
            finalSoundQueue.AddQueue(stringQueueBuilder.CreateQueueFromKeybind(keys[i]));
            if (i != keys.Size() - 1)
            {
                finalSoundQueue.AddSound("alphabet/Space", -1);
            }
        }
        return finalSoundQueue;
    }
}
