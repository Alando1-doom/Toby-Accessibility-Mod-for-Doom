class Toby_MarkerPathfindingOptionMenuItem : Toby_BaseMarkerOptionMenuItem
{
    override bool Activate()
    {
        Menu.MenuSound("menu/choose");
        EventHandler.SendNetworkEvent("Toby_FindPath:"..command);

        CloseAllMenus();

        return true;
    }
}
