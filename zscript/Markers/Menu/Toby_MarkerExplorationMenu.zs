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

        Array<int> addedPointsX;
        Array<int> addedPointsY;
        int ignoreDistance = 16 * 10; //PlayerPawn.radius * 10;

        AddMenuItemsFromSet("Unexplored line: ", tracker, tracker.unexploredLines, ignoreDistance);
        AddMenuItemsFromSet("Non-interacted line: ", tracker, tracker.nonInteractedLines, ignoreDistance);
    }

    void AddMenuItemsFromSet(string descriptionPrefix, Toby_ExplorationTracker tracker, Toby_IntegerSet intSet, int ignoreDistance)
    {
        Array<int> addedPointsX;
        Array<int> addedPointsY;
        for (uint i = 0; i < intSet.Size(); i++) {
            int lineId = intSet.values[i];
            Line l = level.lines[lineId];
            Sector s = tracker.GetExploredOrVisitedSectorForLine(l);
            if (!s) { continue; }
            vector2 normal = Toby_SectorMathUtil.GetMidlineNormalToSector(s, l);
            string description = descriptionPrefix..lineId;
            string coordinates = normal.x..":"..normal.y..":"..s.CenterFloor();

            bool tooClose = false;
            for (uint j = 0; j < addedPointsX.Size(); j++)
            {
                if (((addedPointsX[j], addedPointsY[j]) - (normal.x, normal.y)).Length() < ignoreDistance)
                {
                    console.printf("Ignored");
                    tooClose = true;
                    break;
                };
            }
            if (tooClose) { continue; }
            addedPointsX.Push(normal.x);
            addedPointsY.Push(normal.y);

            mDesc.mItems.Push(new("Toby_MarkerExplorationMenuItem").Init(description, ""..coordinates));
        }

        addedPointsX.Clear();
        addedPointsY.Clear();
    }

    override bool MenuEvent(int key, bool fromController) {
        return super.MenuEvent(key, fromController);
    }
}
