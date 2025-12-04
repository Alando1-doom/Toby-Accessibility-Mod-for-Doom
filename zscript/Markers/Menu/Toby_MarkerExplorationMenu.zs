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

        AddMenuItemsFromSet("Unexplored line - ", tracker, tracker.unexploredLines, ignoreDistance);
        AddMenuItemsFromSet("Non-interacted line - ", tracker, tracker.nonInteractedLines, ignoreDistance, false);
    }

    void AddMenuItemsFromSet(string descriptionPrefix, Toby_ExplorationTracker tracker, Toby_IntegerSet intSet, int ignoreDistance, bool oneUnitToTarget = true)
    {
        Array<int> addedPointsX;
        Array<int> addedPointsY;

        Toby_PathfinderHandler handler = Toby_PathfinderHandler.GetInstanceUi();
        Toby_Pathfinder pathfinder = handler.pathfindersForMenu[consoleplayer];
        Toby_ExplorationPathfinder explorationPathfinder = handler.explorationPathfindersForMenu[consoleplayer];

        for (uint i = 0; i < intSet.Size(); i++) {
            int lineId = intSet.values[i];
            Line l = level.lines[lineId];
            Sector s = tracker.GetExploredOrVisitedSectorForLine(l);
            if (!s) { continue; }

            if (!players[consoleplayer].mo) { continue; }
            PlayerPawn playerActor = players[consoleplayer].mo;

            vector2 normal;
            if (oneUnitToTarget)
            {
                normal = Toby_SectorMathUtil.GetMidlineNormalToSector(s, l);
            }
            else
            {
                // I can't use line trace in UI scope so I'm going to just try few times to get point in map bounds -PR
                int normalPointPlacingAttemptCount = 4;
                bool isInMapBounds = false;
                Sector normalSector;
                for (uint j = 1; j <= normalPointPlacingAttemptCount; j++)
                {
                    double shortenedInteractionRange = double(playerActor.UseRange) / double(j);
                    normal = Toby_SectorMathUtil.GetMidlineNormalToSector(s, l, shortenedInteractionRange);
                    normalSector = level.PointInSector(normal);
                    if (!normalSector) { continue; }
                    isInMapBounds = level.IsPointInLevel((normal, normalSector.CenterFloor()));
                    if (isInMapBounds) { break; }
                }
                if (!isInMapBounds)
                {
                    normal = Toby_SectorMathUtil.GetMidlineNormalToSector(s, l);
                }
            }

            string coordinates = normal.x..":"..normal.y..":"..s.CenterFloor();

            // Deduplication of sorts - if two possible destination points are two close - discard one of them -PR
            bool tooClose = false;
            for (uint j = 0; j < addedPointsX.Size(); j++)
            {
                double distanceToPoint = ((addedPointsX[j], addedPointsY[j]) - (normal.x, normal.y)).Length();
                if (distanceToPoint < ignoreDistance)
                {
                    tooClose = true;
                    break;
                };
            }
            if (tooClose) { continue; }

            vector2 destinationFlat = (normal.x, normal.y);
            vector3 destination = (destinationFlat, s.CenterFloor());
            int destinationSector = level.PointInSector(destinationFlat).Index();
            explorationPathfinder.FindPathFromDestinationToExploredSector(destinationSector);
            pathfinder.StartPathfinding(players[consoleplayer].mo.pos, destination, explorationPathfinder.explorationNodes);
            for (int j = 0; j < 5; j++)
            {
                if (pathfinder.pathFinalized) { break; }
                pathfinder.FindPath();
            }
            if (!pathfinder.pathFinalized) { continue; }

            addedPointsX.Push(normal.x);
            addedPointsY.Push(normal.y);

            Array<string> directions;
            directions.push("North");
            directions.push("North-East");
            directions.push("East");
            directions.push("South-East");
            directions.push("South");
            directions.push("South-West");
            directions.push("West");
            directions.push("North-West");

            vector2 compassDirection = destinationFlat - players[consoleplayer].mo.pos.xy;
            double angle = VectorAngle(compassDirection.y, compassDirection.x);
            angle = (angle + 360) % 360;

            int directionIndex = Round(angle / 45) % 8;
            int distance = Round(compassDirection.Length());

            string description = descriptionPrefix..directions[directionIndex].. " - "..distance;

            mDesc.mItems.Push(new("Toby_MarkerExplorationMenuItem").Init(description, ""..coordinates));
        }

        addedPointsX.Clear();
        addedPointsY.Clear();
    }

    override bool MenuEvent(int key, bool fromController) {
        return super.MenuEvent(key, fromController);
    }
}
