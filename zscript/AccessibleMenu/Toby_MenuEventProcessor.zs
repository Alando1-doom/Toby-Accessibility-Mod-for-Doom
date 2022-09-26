class Toby_MenuEventProcessor
{
    Toby_MenuSoundBindingsContainer menuSoundBindingsContainer;
    Dictionary menuStateAsDictionary;

    ui void Process(Toby_MenuState currentState, Toby_MenuState previousState, int detectedChange)
    {
        if (detectedChange == Toby_MenuState.NoChanges) { return; }

        if (detectedChange > 0 && detectedChange < 5)
        {
            FindAndPlayDictionaryEntryForEvent(currentState, previousState, detectedChange);
            return;
        }
        else if (detectedChange == Toby_MenuState.KeyPressed)
        {
            console.printf("Is slider: "..currentState.isSlider);
            console.printf("Is field: "..currentState.isField);
            console.printf("Is option: "..currentState.isOption);
            console.printf("Is control: "..currentState.isControl);
            console.printf("Is save-load: "..currentState.isSaveLoad);
            if (currentState.lastKeyPressed == UiEvent.Key_Left || currentState.lastKeyPressed == UiEvent.Key_Right)
            {
                if (currentState.isSlider)
                {
                    SoundQueue.Clear();
                    //System.StopAllSounds();
                    NumberToVoice.AddStringNumberToQueue(currentState.mItemOptionValue);
                    SoundQueue.PlayQueue(0);
                    return;
                }
                if (currentState.isField)
                {
                    SoundQueue.Clear();
                    //System.StopAllSounds();
                    StringToVoice.ConvertAndAddToQueueReverse(currentState.mItemOptionValue);
                    SoundQueue.PlayQueue(0);
                    return;
                }
                if (!currentState.isSlider && !currentState.isField
                    && !currentState.isOption && !currentState.isControl)
                {
                    FindAndPlayDictionaryEntryForEvent(currentState, previousState, Toby_MenuState.OptionChanged);
                    return;
                }
            }
        }
    }

    ui void FindAndPlayDictionaryEntryForEvent(Toby_MenuState currentState, Toby_MenuState previousState, int detectedChange)
    {
        ConvertStatesToDictionary(currentState, previousState);
        string eventType = GetEventTypeAsString(detectedChange);

        //Bad case of tight copuling?
        for (int i = 0; i < menuSoundBindingsContainer.menuSoundBindings.Size(); i++)
        {
            if (menuSoundBindingsContainer.menuSoundBindings[i].At("EventType") != eventType) { continue; }
            bool isCorrectCondition = true;
            DictionaryIterator di = DictionaryIterator.Create(menuSoundBindingsContainer.menuSoundBindings[i]);
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
                //System.StopAllSounds();
                SoundQueue.Clear();
                SoundQueue.AddSound(menuSoundBindingsContainer.menuSoundBindings[i].At("SoundToPlay"), -1);
                SoundQueue.PlayQueue(0);
                break;
            }
        }
    }

    ui void Init(Toby_MenuSoundBindingsContainer bindings)
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

        menuStateAsDictionary.Insert("CurrentLastKeyPressed", ""..currentState.lastKeyPressed);
        menuStateAsDictionary.Insert("PreviousLastKeyPressed", ""..previousState.lastKeyPressed);
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
        }
        if (eventType == "Unknown")
        {
            console.printf("Unknown event type. Seems like an error happened.");
        }
        return eventType;
    }
}
