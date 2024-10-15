class Toby_MarkerExplorationMenuItem : Toby_BaseMarkerOptionMenuItem
{
    override bool Activate()
    {
        Menu.MenuSound("menu/choose");

        //Exploration pathfinding goes here

        CloseAllMenus();

        return true;
    }
}
