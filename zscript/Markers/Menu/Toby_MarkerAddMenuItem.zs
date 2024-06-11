class Toby_MarkerAddMenuItem : Toby_BaseMarkerOptionMenuItem
{
    override bool Activate()
    {
        Menu.MenuSound("menu/choose");

        ZS_MarkerHandler markerHandler = ZS_MarkerHandler.GetInstanceUi();
        markerHandler.PlayPlaceSound(command);
        markerHandler.DisplayMarkerPlacedMessage(command);

        EventHandler.SendNetworkEvent("ZS_PlaceMarker:"..command);

        CloseAllMenus();

        return true;
    }
}
