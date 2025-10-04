class Toby_WeaponsMenuItem : Toby_MenuItemWithSoundQueue
{
    override bool Activate()
    {
        Menu.MenuSound("menu/choose");

        EventHandler.SendNetworkEvent("Toby_SelectWeapon:"..command);

        CloseAllMenus();

        return true;
    }
}
