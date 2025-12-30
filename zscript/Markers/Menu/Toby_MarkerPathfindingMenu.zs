class Toby_MarkerPathfindingMenu : OptionMenu
{
    override void Init(Menu parent, OptionMenuDescriptor desc)
    {
        Super.Init(parent, desc);
        mDesc.mItems.Clear();
        mDesc.mSelectedItem = -1;

        mDesc.mItems.Push(new("Toby_MarkerPathfindingOptionMenuItem").Init("Stop pathfinding", "Toby_ResetPathfindingCommand"));

        Toby_MarkerHandler handler = Toby_MarkerHandler.GetInstanceUi();
        for (uint i = 0; i < handler.recordContainers[consoleplayer].records.Size(); i++) {
            string description = handler.recordContainers[consoleplayer].records[i].markerDescription;
            int markerId = handler.recordContainers[consoleplayer].records[i].id;
            mDesc.mItems.Push(new("Toby_MarkerPathfindingOptionMenuItem").Init(description, ""..markerId));
        }
    }
}
