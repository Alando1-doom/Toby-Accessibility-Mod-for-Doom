class MenuEventProcessor ui
{
    ui static void Process(Menu m, int mkey)
    {
        ListMenu list = ListMenu(m);
        OptionMenu option = OptionMenu(m);
        LoadSaveMenu loadsave = LoadSaveMenu(m);
        SaveMenu savem = SaveMenu(m);
		ListMenu parentList = ListMenu(m.mParentMenu);
		OptionMenu parentOption = OptionMenu(m.mParentMenu);

        ListMenuItem menuItem = null;
        ListMenuItemSelectable menuItemSelectable = null;
        ListMenuItemTextItem textItem = null;
        ListMenuItemPatchItem patchItem = null;
        OptionMenuSliderBase sliderItem = null;
        OptionMenuFieldBase fieldItem = null;
        OptionMenuItem optionItem = null;
        OptionMenuItemOptionBase optionItemBase = null;
        OptionMenuItemControlBase optionControl = null;
		OptionMenuItemOption optionItemOption = null;

        string itemId = "";
        string itemIdLocalized = "";
        string menuName = "";
		string parentMenuName = "";
		string localizedOptionValue = "";

        int saveGameSlot = -2;
        int saveGamesTotal = -1;
        string saveGameDate = "";
        string saveGameMap = "";
        string saveGameTime = "";
        bool isAutosave = false;
        bool isNewSlot = false;
        bool isSaveMenu = false;
		
		if (parentList)
		{
				parentMenuName = parentList.mDesc.mMenuName;
		}
		else if (parentOption)
		{
				parentMenuName = parentOption.mDesc.mMenuName;
		}
		
		if (mkey == Menu.MKEY_BACK && parentMenuName == "Mainmenu")
		{
				SoundQueue.AddSound("menu/backup", -1);
		}
        
        if (loadsave)
        {
            saveGamesTotal = loadsave.manager.SavegameCount();
            saveGameSlot = loadsave.Selected + 1;
            if (savem)
            {
                isSaveMenu = true;
            }
            if (saveGamesTotal > 0)
            {
                SaveGameNode savegame = loadsave.manager.GetSavegame(loadsave.Selected);
				if (loadsave.Selected == -1)
				{				
					itemId = "";
				}
				else
				{
					itemId = savegame.SaveTitle;

                    if (loadsave.Selected == 0 && itemId == "<New Save Game>")
                    {
                        isNewSlot = true;
                    }
                    else if (itemId.Mid(0, 8) == "Autosave")
                    {
                        isAutosave = true;
                    }
				}
                //This is potentially volatile and may stop working after GZDoom updates
                if (loadsave.BrokenSaveComment.Count() == 3)
				{
                    saveGameDate = loadsave.BrokenSaveComment.StringAt(0);
                    saveGameMap = loadsave.BrokenSaveComment.StringAt(1);
                    saveGameTime = loadsave.BrokenSaveComment.StringAt(2);
				}
            }
        }
        else if (list)
        {
            ListMenuDescriptor mListDesc = list.mDesc;
            menuName = mListDesc.mMenuName;
            if (mListDesc.mSelectedItem != -1)
            {                
                menuItem = mListDesc.mItems[mListDesc.mSelectedItem];
                menuItemSelectable = ListMenuItemSelectable(menuItem);
                textItem = ListMenuItemTextItem(menuItem);
                patchItem = ListMenuItemPatchItem(menuItem);
            }            
        }
        else if (option)
        {
            OptionMenuDescriptor mOptionDesc = option.mDesc;
            menuName = mOptionDesc.mMenuName;
            if (mOptionDesc.mSelectedItem != -1)
            {                 
                optionItem = mOptionDesc.mItems[mOptionDesc.mSelectedItem];
                optionControl = OptionMenuItemControlBase(optionItem);
                optionItemBase = OptionMenuItemOptionBase(optionItem);
				optionItemOption = OptionMenuItemOption(optionItem);
                sliderItem = OptionMenuSliderBase(optionItem);            
                fieldItem = OptionMenuFieldBase(optionItem);
            }
        }

        if (textItem) 
		{
			itemId = textItem.mText;
		}
		else if (patchItem)
		{
			itemId = TexMan.GetName(patchItem.mTexture);
		}
		else if (menuItemSelectable)
		{
			itemId = ""..menuItemSelectable.mParam;
		}
        else if (optionItem)
        {            
            itemId = ""..optionItem.mLabel;
        }

        itemIdLocalized = Stringtable.Localize(itemId);

        ProcessedMenuEvent processedME = new("ProcessedMenuEvent");

        processedME.menuItem = menuItem;
        processedME.menuItemSelectable = menuItemSelectable;
        processedME.textItem = textItem;
        processedME.patchItem = patchItem;
        processedME.sliderItem = sliderItem;
        processedME.fieldItem = fieldItem;
        processedME.optionItem = optionItem;
        processedME.optionItemBase = optionItemBase;
        processedME.optionControl = optionControl;
        processedME.optionItemOption = optionItemOption;

        processedME.itemId = itemId;
        processedME.itemIdLocalized = itemIdLocalized;
        processedME.menuName = menuName;
	    processedME.parentMenuName = parentMenuName;
	    processedME.localizedOptionValue = localizedOptionValue;
        processedME.mkey = mkey;

        processedME.saveGameSlot = saveGameSlot;
        processedME.saveGamesTotal = saveGamesTotal;
        processedME.saveGameDate = saveGameDate;
        processedME.saveGameMap = saveGameMap;
        processedME.saveGameTime = saveGameTime;
        processedME.isAutosave = isAutosave;
        processedME.isNewSlot = isNewSlot;
        processedME.isSaveMenu = isSaveMenu;

        MenuSoundQueue.Process(processedME);
    }
}