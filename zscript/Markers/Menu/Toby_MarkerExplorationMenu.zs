class Toby_MarkerExplorationMenu : OptionMenu
{
    override void Init(Menu parent, OptionMenuDescriptor desc)
    {
        Super.Init(parent, desc);
        mDesc.mItems.Clear();
        mDesc.mSelectedItem = -1;

        mDesc.mItems.Push(new("Toby_MarkerPathfindingOptionMenuItem").Init("Stop pathfinding", "Toby_ResetPathfindingCommand"));

        Toby_PathfinderHandler handler = Toby_PathfinderHandler.GetInstanceUi();
        Toby_ExplorationTracker tracker = handler.explorationTrackers[consoleplayer];

        for (uint i = 0; i < tracker.unexploredLines.Size(); i++) {
            string description = "Unexplored line: "..tracker.unexploredLines.values[i];
            int lineId = tracker.unexploredLines.values[i];
            mDesc.mItems.Push(new("Toby_MarkerExplorationMenuItem").Init(description, ""..lineId));
        }

        for (uint i = 0; i < tracker.nonInteractedLines.Size(); i++) {
            string description = "Non-interacted line: "..tracker.nonInteractedLines.values[i];
            int lineId = tracker.nonInteractedLines.values[i];
            mDesc.mItems.Push(new("Toby_MarkerExplorationMenuItem").Init(description, ""..lineId));
        }
    }

    override bool MenuEvent(int key, bool fromController) {
        return super.MenuEvent(key, fromController);
    }
}
