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
            int lineId = tracker.unexploredLines.values[i];
            Line l = level.lines[lineId];
            Sector s = tracker.GetExploredOrVisitedSectorForLine(l);
            if (!s) { continue; }
            vector2 normal = Toby_SectorMathUtil.GetMidlineNormalToSector(s, l);
            string description = "Unexplored line: "..lineId;
            string coordinates = normal.x..":"..normal.y..":"..s.CenterFloor();
            mDesc.mItems.Push(new("Toby_MarkerExplorationMenuItem").Init(description, ""..coordinates));
        }

        for (uint i = 0; i < tracker.nonInteractedLines.Size(); i++) {
            int lineId = tracker.nonInteractedLines.values[i];
            Line l = level.lines[lineId];
            Sector s = tracker.GetExploredOrVisitedSectorForLine(l);
            if (!s) { continue; }
            vector2 normal = Toby_SectorMathUtil.GetMidlineNormalToSector(s, l);
            string description = "Non-interacted line: "..lineId;
            string coordinates = normal.x..":"..normal.y..":"..s.CenterFloor();
            mDesc.mItems.Push(new("Toby_MarkerExplorationMenuItem").Init(description, ""..coordinates));
        }
    }

    override bool MenuEvent(int key, bool fromController) {
        return super.MenuEvent(key, fromController);
    }
}
