class Toby_MenuEventProcessor
{
    Toby_SoundBindingsContainer menuSoundBindingsContainer;
    Dictionary menuStateAsDictionary;

    ui void Process(Toby_MenuState currentState, Toby_MenuState previousState, int detectedChange)
    {
        if (detectedChange == Toby_MenuState.NoChanges) { return; }

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

        //Bad case of tight copuling?
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
                Toby_SoundQueueStaticHandler.PlayQueue(0);
                break;
            }
        }
    }

    ui void Init(Toby_SoundBindingsContainer bindings)
    {
        //Bad case of tight copuling?
        menuSoundBindingsContainer = bindings;
    }

    ui void ConvertStatesToDictionary(Toby_MenuState currentState, Toby_MenuState previousState)
    {
        menuStateAsDictionary = Dictionary.Create();
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
                Toby_SoundQueueStaticHandler.UnshiftSound("save/seconds", -1);
                Toby_NumberToVoice.ConvertAndAddToQueue(dateTime.seconds);
                Toby_SoundQueueStaticHandler.UnshiftSound("save/minutes", -1);
                Toby_NumberToVoice.ConvertAndAddToQueue(dateTime.minutes);
                Toby_SoundQueueStaticHandler.UnshiftSound("save/hours", -1);
                Toby_NumberToVoice.ConvertAndAddToQueue(dateTime.hours);
                Toby_SoundQueueStaticHandler.UnshiftSound("alphabet/Space", -1);
                Toby_SoundQueueStaticHandler.UnshiftSound("alphabet/Space", -1);
                Toby_NumberToVoice.ConvertAndAddToQueue(dateTime.year);
                Toby_OrdinalToVoice.ConvertAndAddToQueue(dateTime.day);
                Toby_MonthToVoice.ConvertAndUnshiftToQueue(dateTime.month);
            }
        }
        Toby_SoundQueueStaticHandler.AddQueue(finalSoundQueue);
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }
}
