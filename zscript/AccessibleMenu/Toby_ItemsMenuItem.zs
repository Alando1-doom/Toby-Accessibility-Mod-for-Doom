class Toby_ItemsMenuItem : Toby_MenuItemWithSoundQueue
{
    override bool Activate()
    {
        Menu.MenuSound("menu/choose");

        EventHandler.SendNetworkEvent("Toby_ActivateItem:"..command);

        CloseAllMenus();

        return true;
    }
}
