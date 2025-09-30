class Toby_ItemsMenuItem : Toby_BaseMarkerOptionMenuItem
{
    override bool Activate()
    {
        Menu.MenuSound("menu/choose");

        EventHandler.SendNetworkEvent("Toby_ActivateItem:"..command);

        CloseAllMenus();

        return true;
    }
}
