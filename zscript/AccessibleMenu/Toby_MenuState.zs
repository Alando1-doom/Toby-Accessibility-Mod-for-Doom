class Toby_MenuState
{
    ui string menuClass;
    ui string menuName;

    ui string mItemListSelectableString;
    ui string mItemListTextString;
    ui string mItemListTextStringLocalized;
    ui string mItemListPatchString;

    ui string mItemOptionName;
    ui string mItemOptionNameLocalized;
    ui string mItemOptionValue;
    ui string mItemOptionValueLocalized;

    ui int lastKeyPressed;
    ui bool isSlider;
    ui bool isField;
    ui bool isOption;
    ui bool isControl;

    ui bool isSaveLoad;
    ui bool isNewSlot;
    ui bool isAutosave;
    ui bool isQuicksave;
    ui string saveLoadValue;
    ui string saveGameDate;
    ui string saveGameMap;
    ui string saveGameTime;
    ui int saveGamesTotal;
    ui int saveGameSlot;


    ui void CopyValuesTo(Toby_MenuState otherState)
    {
        otherState.menuClass = menuClass;
        otherState.menuName = menuName;

        otherState.mItemListSelectableString = mItemListSelectableString;
        otherState.mItemListTextString = mItemListTextString;
        otherState.mItemListTextStringLocalized = mItemListTextStringLocalized;
        otherState.mItemListPatchString = mItemListPatchString;

        otherState.mItemOptionName = mItemOptionName;
        otherState.mItemOptionNameLocalized = mItemOptionNameLocalized;
        otherState.mItemOptionValue = mItemOptionValue;
        otherState.mItemOptionValueLocalized = mItemOptionValueLocalized;

        otherState.lastKeyPressed = lastKeyPressed;
        otherState.isSlider = isSlider;
        otherState.isField = isField;
        otherState.isOption = isOption;
        otherState.isControl = isControl;

        otherState.isSaveLoad = isSaveLoad;
        otherState.isNewSlot = isNewSlot;
        otherState.isQuicksave = isQuicksave;
        otherState.saveLoadValue = saveLoadValue;
        otherState.saveGameDate = saveGameDate;
        otherState.saveGameMap = saveGameMap;
        otherState.saveGameTime = saveGameTime;
        otherState.saveGamesTotal = saveGamesTotal;
        otherState.saveGameSlot = saveGameSlot;
    }

    ui MenuStateChanges DetectChanges(Toby_MenuState otherState)
    {
        if (menuClass == "null"
            && menuName == "null"
            && otherState.menuClass == "ListMenu"
            && otherState.menuName == "Skillmenu")
        {
            Toby_Logger.Message("EventType : GameStarted", "Toby_Developer_MenuEvents");
            return GameStarted;
        }
        //This is kind of a wild assumption
        if (menuClass == "null"
            && menuName == "null"
            && otherState.menuClass == "TextEnterMenu"
            && otherState.menuName == "null")
        {
            Toby_Logger.Message("EventType : GameSaved", "Toby_Developer_MenuEvents");
            return GameSaved;
        }
        if (menuClass == "null"
            && menuName == "null"
            && otherState.menuClass == "LoadMenu"
            && otherState.menuName == "null")
        {
            Toby_Logger.Message("EventType : GameLoaded", "Toby_Developer_MenuEvents");
            return GameLoaded;
        }
        if (menuClass == "null"
            && menuName == "null"
            && (otherState.menuClass != "null" || otherState.menuName != "null"))
        {
                Toby_Logger.Message("EventType : MenuDismissed", "Toby_Developer_MenuEvents");
                return MenuDismissed;
        }

        if (otherState.menuClass != menuClass || otherState.menuName != menuName)
        {
            Toby_Logger.Message("EventType : MenuChanged", "Toby_Developer_MenuEvents");
            Toby_Logger.Message("PreviousMenuClass : "..otherState.menuClass.." -> CurrentMenuClass : "..menuClass, "Toby_Developer_MenuChangedEvents");
            Toby_Logger.Message("PreviousMenuName : "..otherState.menuName.." -> CurrentMenuName : "..menuName, "Toby_Developer_MenuChangedEvents");
            return MenuChanged;
        }

        if (otherState.mItemListSelectableString != mItemListSelectableString
            || otherState.mItemListTextString != mItemListTextString
            || otherState.mItemListTextStringLocalized != mItemListTextStringLocalized
            || otherState.mItemListPatchString != mItemListPatchString
            || otherState.mItemOptionName != mItemOptionName
            || otherState.mItemOptionNameLocalized != mItemOptionNameLocalized)
        {
            Toby_Logger.Message("EventType : OptionChanged", "Toby_Developer_MenuEvents");
            Toby_Logger.Message("PreviousMenuItemListSelectableString : "..otherState.mItemListSelectableString.." -> CurrentMenuItemListSelectableString : "..mItemListSelectableString, "Toby_Developer_OptionChangedEvents");
            Toby_Logger.Message("PreviousMenuItemListTextString : "..otherState.mItemListTextString.." -> CurrentMenuItemListTextString : "..mItemListTextString, "Toby_Developer_OptionChangedEvents");
            Toby_Logger.Message("PreviousMenuItemListTextStringLocalized : "..otherState.mItemListTextStringLocalized.." -> CurrentMenuItemListTextStringLocalized : "..mItemListTextStringLocalized, "Toby_Developer_OptionChangedEvents");
            Toby_Logger.Message("PreviousMenuItemListPatchString : "..otherState.mItemListPatchString.." -> CurrentMenuItemListPatchString : "..mItemListPatchString, "Toby_Developer_OptionChangedEvents");
            Toby_Logger.Message("PreviousMenuItemOptionName : "..otherState.mItemOptionName.." -> CurrentMenuItemOptionName : "..mItemOptionName, "Toby_Developer_OptionChangedEvents");
            Toby_Logger.Message("PreviousMenuItemOptionNameLocalized : "..otherState.mItemOptionNameLocalized.." -> CurrentMenuItemOptionNameLocalized : "..mItemOptionNameLocalized, "Toby_Developer_OptionChangedEvents");
            return OptionChanged;
        }
        if (otherState.mItemOptionValue != mItemOptionValue
            || otherState.mItemOptionValueLocalized != mItemOptionValueLocalized)
        {
            Toby_Logger.Message("EventType : OptionValueChanged", "Toby_Developer_MenuEvents");
            Toby_Logger.Message("PreviousMenuItemOptionValue : "..otherState.mItemOptionValue.." -> CurrentMenuItemOptionValue : "..mItemOptionValue, "Toby_Developer_OptionValueChangedEvents");
            Toby_Logger.Message("PreviousMenuItemOptionValueLocalized : "..otherState.mItemOptionValueLocalized.." -> CurrentMenuItemOptionValueLocalized : "..mItemOptionValueLocalized, "Toby_Developer_OptionValueChangedEvents");
            return OptionValueChanged;
        }

        if (otherState.saveGameSlot != saveGameSlot)
        {
            Toby_Logger.Message("EventType : SaveSlotChanged", "Toby_Developer_MenuEvents");
            Toby_Logger.Message("PreviousIsSaveLoad : "..otherState.isSaveLoad.." -> CurrentIsSaveLoad : "..isSaveLoad, "Toby_Developer_SaveSlotChangedEvents");
            Toby_Logger.Message("PreviousIsNewSlot : "..otherState.isNewSlot.." -> CurrentIsNewSlot : "..isNewSlot, "Toby_Developer_SaveSlotChangedEvents");
            Toby_Logger.Message("PreviousIsQuicksave : "..otherState.isQuicksave.." -> CurrentIsQuicksave : "..isQuicksave, "Toby_Developer_SaveSlotChangedEvents");
            Toby_Logger.Message("PreviousSaveLoadValue : "..otherState.saveLoadValue.." -> CurrentSaveLoadValue : "..saveLoadValue, "Toby_Developer_SaveSlotChangedEvents");
            Toby_Logger.Message("PreviousSaveGameDate : "..otherState.saveGameDate.." -> CurrentSaveGameDate : "..saveGameDate, "Toby_Developer_SaveSlotChangedEvents");
            Toby_Logger.Message("PreviousSaveGameMap : "..otherState.saveGameMap.." -> CurrentSaveGameMap : "..saveGameMap, "Toby_Developer_SaveSlotChangedEvents");
            Toby_Logger.Message("PreviousSaveGameTime : "..otherState.saveGameTime.." -> CurrentSaveGameTime : "..saveGameTime, "Toby_Developer_SaveSlotChangedEvents");
            Toby_Logger.Message("PreviousSaveGamesTotal : "..otherState.saveGamesTotal.." -> CurrentSaveGamesTotal : "..saveGamesTotal, "Toby_Developer_SaveSlotChangedEvents");
            Toby_Logger.Message("PreviousSaveGameSlot : "..otherState.saveGameSlot.." -> CurrentSaveGameSlot : "..saveGameSlot, "Toby_Developer_SaveSlotChangedEvents");
            return SaveSlotChanged;
        }

        if (otherState.lastKeyPressed != lastKeyPressed)
        {
            Toby_Logger.Message("EventType : KeyPressed", "Toby_Developer_MenuEvents");
            Toby_Logger.Message("PreviousLastKeyPressed : "..otherState.lastKeyPressed.." -> CurrentLastKeyPressed : "..lastKeyPressed, "Toby_Developer_KeyPressedEvents");
            return KeyPressed;
        }
        return NoChanges;
    }

    ui void SetNullState()
    {
        menuClass = "null";
        menuName = "null";
        mItemListSelectableString = "null";
        mItemListTextString = "null";
        mItemListTextStringLocalized = "null";
        mItemListPatchString = "null";
        mItemOptionName = "null";
        mItemOptionNameLocalized = "null";
        mItemOptionValue = "null";
        mItemOptionValueLocalized = "null";

        isSaveLoad = false;
        isNewSlot = false;
        isAutosave = false;
        isQuicksave = false;
        saveLoadValue = "null";
        saveGameDate = "null";
        saveGameMap = "null";
        saveGameTime = "null";
        saveGamesTotal = -1;
        saveGameSlot = -1;

        lastKeyPressed = -1;
        isSlider = false;
        isField = false;
        isOption = false;
        isControl = false;
    }

    ui void UpdateMenuState(Menu m, int keyPressed)
    {
        SetNullState();

        if (m == null) { return; }

        ListMenu mList = null;
        OptionMenu mOption = null;
        LoadSaveMenu mLoadSave = null;
        SaveMenu mSaveMenu = null;

        ListMenuItem mItemList = null;
        ListMenuItemSelectable mItemListSelectable = null;
        ListMenuItemTextItem mItemListText = null;
        ListMenuItemPatchItem mItemListPatch = null;

        OptionMenuItem mItemOption = null;
        OptionMenuItemOptionBase mItemOptionBase = null;
        OptionMenuItemControlBase mItemOptionControl = null;
        OptionMenuItemOption mItemOptionOption = null;
        OptionMenuSliderBase mItemOptionSlider = null;
        OptionMenuFieldBase mItemOptionField = null;

        lastKeyPressed = keyPressed;

        menuClass = m.GetClassName();

        mList = ListMenu(m);
        mOption = OptionMenu(m);
        mLoadSave = LoadSaveMenu(m);

        ListMenuItem menuItem = null;
        if (mLoadSave)
        {
            isSaveLoad = true;

            mSaveMenu = SaveMenu(mLoadSave);
            saveGamesTotal = mLoadSave.manager.SavegameCount();
            saveGameSlot = mLoadSave.Selected + 1;
            if (mSaveMenu)
            {
                isSaveLoad = true;
            }
            if (saveGamesTotal > 0)
            {
                SaveGameNode savegame;
                if (mLoadSave.Selected != -1)
                {
                    savegame = mLoadSave.manager.GetSavegame(mLoadSave.Selected);
                }
				if (mLoadSave.Selected == -1)
				{
					saveLoadValue = "null";
				}
				else
				{
					saveLoadValue = savegame.SaveTitle;

                    if (mLoadSave.Selected == 0 && saveLoadValue == "<New Save Game>")
                    {
                        isNewSlot = true;
                    }
                    else if (saveLoadValue.Mid(0, 8) == "Autosave")
                    {
                        isAutosave = true;
                    }
                    else if (saveLoadValue.Mid(0, 9) == "Quicksave")
                    {
                        isQuicksave = true;
                    }
				}
                //This is potentially volatile and may stop working after GZDoom updates
                if (mLoadSave.BrokenSaveComment.Count() == 3)
				{
                    saveGameDate = mLoadSave.BrokenSaveComment.StringAt(0);
                    saveGameMap = mLoadSave.BrokenSaveComment.StringAt(1);
                    saveGameTime = mLoadSave.BrokenSaveComment.StringAt(2);
				}
            }
        }
        else if (mList)
        {
            ListMenuDescriptor mListDesc = mList.mDesc;
            menuName = mListDesc.mMenuName;
            if (mListDesc.mSelectedItem != -1)
            {
                mItemList = mListDesc.mItems[mListDesc.mSelectedItem];
                mItemListSelectable = ListMenuItemSelectable(mItemList);
                mItemListText = ListMenuItemTextItem(mItemList);
                mItemListPatch = ListMenuItemPatchItem(mItemList);
            }
        }
        else if (mOption)
        {
            OptionMenuDescriptor mOptionDesc = mOption.mDesc;
            menuName = mOptionDesc.mMenuName;
            if (mOptionDesc.mSelectedItem != -1)
            {
                mItemOption = mOptionDesc.mItems[mOptionDesc.mSelectedItem];
                mItemOptionBase = OptionMenuItemOptionBase(mItemOption);
                mItemOptionControl = OptionMenuItemControlBase(mItemOption);
                mItemOptionOption = OptionMenuItemOption(mItemOption);
                mItemOptionSlider = OptionMenuSliderBase(mItemOption);
                mItemOptionField = OptionMenuFieldBase(mItemOption);
                if (mItemOptionSlider) { isSlider = true; }
                if (mItemOptionField) { isField = true; }
                if (mItemOptionOption) { isOption = true; }
                if (mItemOptionControl) { isControl = true; }
            }
        }

        if (mItemListText)
        {
            mItemListTextString = mItemListText.mText;
            mItemOptionNameLocalized = Stringtable.Localize(mItemListTextString);
        }
        if (mItemListPatch)
        {
            mItemListPatchString = TexMan.GetName(mItemListPatch.mTexture);
        }
        if (mItemListSelectable)
        {
            mItemListSelectableString = ""..mItemListSelectable.mParam;
        }
        if (mItemOption)
        {
            mItemOptionName = ""..mItemOption.mLabel;
            mItemOptionNameLocalized = Stringtable.Localize(mItemOptionName);
        }

        //Option values:
        if (mItemOptionBase)
        {
            int selection = mItemOptionBase.GetSelection();
            mItemOptionValue = OptionValues.GetText(mItemOptionBase.mValues, selection);
        }
        else if (mItemOptionSlider)
        {
            mItemOptionValue = ""..mItemOptionSlider.GetSliderValue();
        }
        else if (mItemOptionField)
        {
            mItemOptionValue = ""..mItemOptionField.Represent();
        }
        if (mItemOptionValue != "null")
        {
            mItemOptionValueLocalized = StringTable.Localize(mItemOptionValue);
        }
    }

    enum MenuStateChanges
    {
        NoChanges = 0,
        MenuDismissed = 1,
        MenuChanged = 2,
        OptionChanged = 3,
        OptionValueChanged = 4,
        KeyPressed = 5,
        SaveSlotChanged = 6,
        GameStarted = 7,
        GameLoaded = 8,
        GameSaved = 9
    };
}
