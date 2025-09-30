class Toby_WeaponsMenuItem : Toby_BaseMarkerOptionMenuItem
{
    override bool Activate()
    {
        Menu.MenuSound("menu/choose");

        EventHandler.SendNetworkEvent("Toby_SelectWeapon:"..command);

        CloseAllMenus();

        return true;
    }
}
