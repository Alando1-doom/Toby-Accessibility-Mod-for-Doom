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
    }

    ui MenuStateChanges DetectChanges(Toby_MenuState otherState)
    {
        if (menuClass == "null"
            && menuName == "null"
            && otherState.menuClass != "null"
            && otherState.menuName != "null")
        {
                console.printf("Menu dismissed");
                return MenuDismissed;
        }

        if (otherState.menuClass != menuClass || otherState.menuName != menuName)
        {
            console.printf("Menu changed");
            console.printf("Class: "..otherState.menuClass.." -> "..menuClass);
            console.printf("Name: "..otherState.menuName.." -> "..menuName);
            return MenuChanged;
        }

        if (otherState.mItemListSelectableString != mItemListSelectableString
            || otherState.mItemListTextString != mItemListTextString
            || otherState.mItemListTextStringLocalized != mItemListTextStringLocalized
            || otherState.mItemListPatchString != mItemListPatchString
            || otherState.mItemOptionName != mItemOptionName
            || otherState.mItemOptionNameLocalized != mItemOptionNameLocalized)
        {
            console.printf("Option changed");
            console.printf("mItemListTextString: "..otherState.mItemListTextString.." -> "..mItemListTextString);
            console.printf("mItemListTextStringLocalized: "..otherState.mItemListTextStringLocalized.." -> "..mItemListTextStringLocalized);
            console.printf("mItemListPatchString: "..otherState.mItemListPatchString.." -> "..mItemListPatchString);
            console.printf("mItemOptionName: "..otherState.mItemOptionName.." -> "..mItemOptionName);
            console.printf("mItemOptionNameLocalized: "..otherState.mItemOptionNameLocalized.." -> "..mItemOptionNameLocalized);
            return OptionChanged;
        }
        if (otherState.mItemOptionValue != mItemOptionValue
            || otherState.mItemOptionValueLocalized != mItemOptionValueLocalized)
        {
            console.printf("Value changed");
            console.printf("mItemOptionValue: "..otherState.mItemOptionValue.." -> "..mItemOptionValue);
            console.printf("mItemOptionValueLocalized: "..otherState.mItemOptionValueLocalized.." -> "..mItemOptionValueLocalized);
            return OptionValueChanged;
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
    }

    ui void UpdateMenuState(Menu m)
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

        menuClass = m.GetClassName();

        mList = ListMenu(m);
        mOption = OptionMenu(m);
        mLoadSave = LoadSaveMenu(m);

        ListMenuItem menuItem = null;
        if (mLoadSave)
        {
            //TODO: Fix LoadSave menu
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
    };
}
