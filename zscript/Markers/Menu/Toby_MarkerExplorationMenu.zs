class Toby_MarkerExplorationMenu : OptionMenu
{
    override void Init(Menu parent, OptionMenuDescriptor desc)
    {
        Super.Init(parent, desc);
        mDesc.mItems.Clear();
        mDesc.mSelectedItem = -1;

        mDesc.mItems.Push(new("Toby_MarkerPathfindingOptionMenuItem").Init("Stop pathfinding", "Toby_ResetPathfindingCommand"));

        Toby_PathfinderHandler handler = Toby_PathfinderHandler.GetInstanceUi();

        for (uint i = 0; i < handler.explorationTrackers[consoleplayer].unexploredLines.Size(); i++) {
            string description = "Unexplored line: "..handler.explorationTrackers[consoleplayer].unexploredLines.values[i];
            int lineId = handler.explorationTrackers[consoleplayer].unexploredLines.values[i];
            mDesc.mItems.Push(new("Toby_MarkerExplorationMenuItem").Init(description, ""..lineId));
        }

        for (uint i = 0; i < handler.explorationTrackers[consoleplayer].nonInteractedLines.Size(); i++) {
            string description = "Non-interacted line: "..handler.explorationTrackers[consoleplayer].nonInteractedLines.values[i];
            int lineId = handler.explorationTrackers[consoleplayer].nonInteractedLines.values[i];
            mDesc.mItems.Push(new("Toby_MarkerExplorationMenuItem").Init(description, ""..lineId));
        }
    }

    override bool MenuEvent(int key, bool fromController) {
        return super.MenuEvent(key, fromController);
    }
}
