class Toby_MarkerRemoveMenuItem : Toby_BaseMarkerOptionMenuItem
{
    override bool Activate()
    {
        Menu.MenuSound("menu/choose");

        ZS_MarkerHandler markerHandler = ZS_MarkerHandler.GetInstanceUi();
        Toby_MarkerRecord record = markerHandler.recordContainers[consoleplayer].GetMarkerById(command.ToInt());
        if (record)
        {
            string actorClassName = record.markerActor.GetClassName();

            markerHandler.PlayUndoSound(actorClassName);
            markerHandler.DisplayMarkerRemovedMessage(actorClassName);
        }

        EventHandler.SendNetworkEvent("ZS_RemoveMarker:"..command);

        CloseAllMenus();

        return true;
    }
}
