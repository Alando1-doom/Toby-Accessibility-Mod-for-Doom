class Toby_MenuOutputToConsole
{
    ui static Toby_MenuOutputToConsole Create()
    {
        Toby_MenuOutputToConsole strategy = new("Toby_MenuOutputToConsole");
        return strategy;
    }

    ui void Output(Toby_MenuState currentState, Toby_MenuState previousState, int detectedChange)
    {
        if (detectedChange == Toby_MenuState.NoChanges) { return; }
        if (detectedChange == Toby_MenuState.MenuChanged)
        {
            //Look up database or print menu name
            string menuName = "null";
            if (currentState.menuName != "null")
            {
                menuName = currentState.menuName;
            } else if (currentState.menuClass != "null") {
                menuName = currentState.menuClass;
            }
            Toby_Logger.ConsoleOutputModeMessage(menuName);
            if (currentState.menuItemsCount == 0)
            {
                Toby_Logger.ConsoleOutputModeMessage('No menu items');
            }
            return;
        }
        if (detectedChange == Toby_MenuState.OptionChanged)
        {
            //Look up database or print option item
            string optionName = "null";
            if (currentState.mItemListTextStringLocalized != "null")
            {
                optionName = currentState.mItemListTextStringLocalized;
            } else if (currentState.mItemListPatchString != "null")
            {
                optionName = currentState.mItemListPatchString;
            } else if (currentState.mItemOptionNameLocalized != "null")
            {
                optionName = currentState.mItemOptionNameLocalized;
            }
            Toby_Logger.ConsoleOutputModeMessage(optionName);
            return;
        }
        else if (detectedChange == Toby_MenuState.SaveSlotChanged)
        {
            HandleSaveSlotChangedEvent(currentState);
            return;
        }
        else if (detectedChange == Toby_MenuState.OptionValueChanged)
        {
            Toby_Logger.ConsoleOutputModeMessage(currentState.mItemOptionValueLocalized);
            return;
        }
        else if (detectedChange == Toby_MenuState.ConsoleStateChanged)
        {
            HandleConsoleEvents(currentState, previousState);
            return;
        }
        else if (detectedChange == Toby_MenuState.GameStateChanged)
        {
            if (currentState.gameStatus == 4)
            {
                Toby_Logger.ConsoleOutputModeMessage("Full screen console is opened. Most likely it happened because of an error.");
            }
            return;
        }
        //Left and Right handling
        else if (detectedChange == Toby_MenuState.KeyPressed)
        {
            if (currentState.lastKeyPressed == UiEvent.Key_Left || currentState.lastKeyPressed == UiEvent.Key_Right)
            {
                HandleLeftRightKeyPress(currentState);
            }
        }
    }

    ui void HandleSaveSlotChangedEvent(Toby_MenuState currentState)
    {
        string saveInfo = "";
        if (!CVar.FindCvar("Toby_SkipSlotWord").GetBool())
        {
            saveInfo = saveInfo .. "Slot ";
        }
        saveInfo = saveInfo .. String.format("%d of %d - ", currentState.saveGameSlot, currentState.saveGamesTotal);
        if (currentState.isNewSlot)
        {
            saveInfo = saveInfo .. "New save game";
        }
        else
        {
            saveInfo = saveInfo .. currentState.saveLoadValue;
        }
        Toby_Logger.ConsoleOutputModeMessage(saveInfo);
    }

    ui void HandleLeftRightKeyPress(Toby_MenuState currentState)
    {
        if (currentState.isSaveLoad && currentState.saveGamesTotal > 0)
        {
            HandleLeftRightKeyPressInSaveLoadMenu(currentState);
        }
    }

    ui void HandleLeftRightKeyPressInSaveLoadMenu(Toby_MenuState currentState)
    {
        string saveInfo = "";
        if (currentState.saveGameSlot >= 0 && !currentState.isNewSlot && currentState.lastKeyPressed == UiEvent.Key_Left)
        {
            if (currentState.saveGameDate != "null")
            {
                Toby_SaveGameTime time = Toby_SaveGameUtils.getTime(currentState.saveGameTime);
                Toby_SaveGameMap mapInfo = Toby_SaveGameUtils.getMapInfo(currentState.saveGameMap);

                if (mapInfo.isEpisodic)
                {
                    saveInfo = saveInfo .. String.Format("Episode %d, ", mapInfo.episodeNumber);
                }
                saveInfo = saveInfo .. String.Format("Map %d. Time spent: %d hours, %d minutes, %d seconds", mapInfo.mapNumber, time.hours, time.minutes, time.seconds);
            }
        }
        else if (currentState.saveGameSlot >= 0 && !currentState.isNewSlot && currentState.lastKeyPressed == UiEvent.Key_Right)
        {
            if (currentState.saveGameDate != "null")
            {
                Toby_SaveGameDate dateTime = Toby_SaveGameUtils.getDate(currentState.saveGameDate);
                saveInfo = saveInfo .. String.Format("%d.%d.%d %d hours, %d minutes, %d seconds", dateTime.month, dateTime.day, dateTime.year, dateTime.hours, dateTime.minutes, dateTime.seconds);
            }
        }
        Toby_Logger.ConsoleOutputModeMessage(saveInfo);
    }

    ui void HandleConsoleEvents(Toby_MenuState currentState, Toby_MenuState previousState)
    {
        if (previousState.consoleStatus == 2 && currentState.consoleStatus == 1)
        {
            Toby_Logger.ConsoleOutputModeMessage("Console opened");
            return;
        }
        if (previousState.consoleStatus == 3 && currentState.consoleStatus == 0)
        {
            Toby_Logger.ConsoleOutputModeMessage("Console closed");
            return;
        }
    }
}
