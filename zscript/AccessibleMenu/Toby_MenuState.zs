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
    }

    ui MenuStateChanges DetectChanges(Toby_MenuState otherState)
    {
        if (menuClass == "null"
            && menuName == "null"
            && otherState.menuClass != "null"
            && otherState.menuName != "null")
        {
                Toby_Logger.Message("EventType : MenuDismissed");
                return MenuDismissed;
        }

        if (otherState.menuClass != menuClass || otherState.menuName != menuName)
        {
            Toby_Logger.Message("EventType : MenuChanged");
            Toby_Logger.Message("PreviousMenuClass : "..otherState.menuClass.." -> CurrentMenuClass : "..menuClass);
            Toby_Logger.Message("PreviousMenuName : "..otherState.menuName.." -> CurrentMenuName : "..menuName);
            return MenuChanged;
        }

        if (otherState.mItemListSelectableString != mItemListSelectableString
            || otherState.mItemListTextString != mItemListTextString
            || otherState.mItemListTextStringLocalized != mItemListTextStringLocalized
            || otherState.mItemListPatchString != mItemListPatchString
            || otherState.mItemOptionName != mItemOptionName
            || otherState.mItemOptionNameLocalized != mItemOptionNameLocalized)
        {
            Toby_Logger.Message("EventType : OptionChanged");
            Toby_Logger.Message("PreviousMenuItemListSelectableString : "..otherState.mItemListSelectableString.." -> CurrentMenuItemListSelectableString : "..mItemListSelectableString);
            Toby_Logger.Message("PreviousMenuItemListTextString : "..otherState.mItemListTextString.." -> CurrentMenuItemListTextString : "..mItemListTextString);
            Toby_Logger.Message("PreviousMenuItemListTextStringLocalized : "..otherState.mItemListTextStringLocalized.." -> CurrentMenuItemListTextStringLocalized : "..mItemListTextStringLocalized);
            Toby_Logger.Message("PreviousMenuItemListPatchString : "..otherState.mItemListPatchString.." -> CurrentMenuItemListPatchString : "..mItemListPatchString);
            Toby_Logger.Message("PreviousMenuItemOptionName : "..otherState.mItemOptionName.." -> CurrentMenuItemOptionName : "..mItemOptionName);
            Toby_Logger.Message("PreviousMenuItemOptionNameLocalized : "..otherState.mItemOptionNameLocalized.." -> CurrentMenuItemOptionNameLocalized : "..mItemOptionNameLocalized);
            return OptionChanged;
        }
        if (otherState.mItemOptionValue != mItemOptionValue
            || otherState.mItemOptionValueLocalized != mItemOptionValueLocalized)
        {
            Toby_Logger.Message("EventType : OptionValueChanged");
            Toby_Logger.Message("PreviousMenuItemOptionValue : "..otherState.mItemOptionValue.." -> CurrentMenuItemOptionValue : "..mItemOptionValue);
            Toby_Logger.Message("PreviousMenuItemOptionValueLocalized : "..otherState.mItemOptionValueLocalized.." -> CurrentMenuItemOptionValueLocalized : "..mItemOptionValueLocalized);
            return OptionValueChanged;
        }

        if (otherState.lastKeyPressed != lastKeyPressed)
        {
            Toby_Logger.Message("EventType : KeyPressed");
            Toby_Logger.Message("PreviousLastKeyPressed : "..otherState.lastKeyPressed.." -> CurrentLastKeyPressed : "..lastKeyPressed);
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

        lastKeyPressed = -1;
        isSlider = false;
        isField = false;
        isOption = false;
        isControl = false;
        isSaveLoad = false;
    }

    ui void UpdateMenuState(Menu m, int keyPressed)
    {
        SetNullState();

        if (m == null) { return; }

        ListMenu mList = null;
        OptionMenu mOption = null;
        LoadSaveMenu mLoadSave = null;

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
    };
}
