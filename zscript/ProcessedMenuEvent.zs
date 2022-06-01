class ProcessedMenuEvent
{
    ListMenuItem menuItem;
    ListMenuItemSelectable menuItemSelectable;
    ListMenuItemTextItem textItem;
    ListMenuItemPatchItem patchItem;
    OptionMenuSliderBase sliderItem;
    OptionMenuFieldBase fieldItem;
    OptionMenuItem optionItem;
    OptionMenuItemOptionBase optionItemBase;
    OptionMenuItemControlBase optionControl;
    OptionMenuItemOption optionItemOption;

    string itemId;
    string itemIdLocalized;
    string menuName;
	string parentMenuName;
	string localizedOptionValue;
    int mkey;

    int saveGameSlot;
    int saveGamesTotal;
    string saveGameDate;
    string saveGameMap;
    string saveGameTime;
    bool isAutosave;
    bool isNewSlot;
    bool isSaveMenu;
}