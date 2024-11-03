class Toby_MarkerExplorationMenuItem : Toby_BaseMarkerOptionMenuItem
{
    override bool Activate()
    {
        Menu.MenuSound("menu/choose");
        console.printf("ACTIVATED!");
        if (command == "Toby_ResetPathfindingCommand")
        {
            EventHandler.SendNetworkEvent("Toby_StopPathfinding");
        }
        else
        {
            EventHandler.SendNetworkEvent("Toby_FindPathExploration:"..command);
        }

        CloseAllMenus();

        return true;
    }
}
