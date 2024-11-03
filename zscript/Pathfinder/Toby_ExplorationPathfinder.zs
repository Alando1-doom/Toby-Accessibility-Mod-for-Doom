class Toby_ExplorationPathfinder
{
    Actor explorer;
    Toby_ExplorationTracker tracker;
    Toby_InSectorNodeBuilder inSectorNodeBuilder;
    Toby_IntegerSet sectorOpenList;
    Toby_IntegerSet sectorClosedList;
    Array<int> sectorWeights;
    Array<int> sectorPath;
    int firstVisitedSector;
    Toby_PathfindingNodeContainer explorationNodes;
    Toby_PathfindingNodeContainer mainContainer;

    play static Toby_ExplorationPathfinder Create(
        Actor explorer,
        Toby_ExplorationTracker tracker,
        Toby_InSectorNodeBuilder inSectorNodeBuilder,
        Toby_PathfindingNodeContainer mainContainer
    )
    {
        Toby_ExplorationPathfinder epf = new("Toby_ExplorationPathfinder");
        epf.explorer = explorer;
        epf.tracker = tracker;
        epf.inSectorNodeBuilder = inSectorNodeBuilder;
        epf.mainContainer = mainContainer;
        epf.sectorOpenList = Toby_IntegerSet.Create();
        epf.sectorClosedList = Toby_IntegerSet.Create();
        epf.firstVisitedSector = -1;

        for (int i = 0; i < level.sectors.Size(); i++)
        {
            epf.sectorWeights.push(Int.Max);
        }

        return epf;
    }

    void FindPathFromDestinationToExploredSector(int destinationSectorIndex)
    {
        firstVisitedSector = -1;
        explorationNodes = Toby_PathfindingNodeContainer.Create();
        sectorOpenList.Clear();
        sectorClosedList.Clear();
        ResetSectorWeights();
        sectorWeights[destinationSectorIndex] = 0;
        sectorOpenList.Add(destinationSectorIndex);

        int iteration = 0;
        int maxIterations = 500;
        int sourceSectorIndex = -1;
        while (sourceSectorIndex < 0)
        {
            if (iteration > maxIterations) { break; }

            for (int i = sectorOpenList.Size() - 1; i >= 0; i--)
            {
                int sectorIndex = sectorOpenList.values[i];
                if (tracker.IsVisited(sectorIndex))
                {
                    sourceSectorIndex = sectorIndex;
                }
                AddSectorsToOpenList(sectorIndex);
                sectorOpenList.Remove(sectorIndex);
                sectorClosedList.Add(sectorIndex);
                // console.printf("Open list: ");
                // sectorOpenList.Print();
                // console.printf("Closed list: ");
                // sectorClosedList.Print();
            }

            iteration++;
        }

        if (sourceSectorIndex == -1)
        {
            console.printf("Exploration pathfinder: failed to find explored area");
            return;
        }
        ConstructSectorPath(sourceSectorIndex, destinationSectorIndex);
    }

    void ConstructSectorPath(int sourceSectorIndex, int destinationSectorIndex)
    {
        sectorPath.Clear();
        if (sourceSectorIndex == -1) { return; }
        sectorPath.Push(sourceSectorIndex);
        int currentSectorIndex = sourceSectorIndex;

        int iteration = 0;
        int maxIterations = 500;
        while (currentSectorIndex != destinationSectorIndex)
        {
            if (iteration > maxIterations) { break; }

            Sector s = level.sectors[currentSectorIndex];

            int minWeight = Int.Max;
            int minWeightSectorIndex = -1;
            for (int i = 0; i < s.lines.Size(); i++)
            {
                Line l = s.lines[i];
                Sector other = Toby_SectorMathUtil.GetOtherSector(s, l);
                if (!other) { continue; }
                int otherIndex = other.Index();

                //Unnecessary?
                if (!sectorClosedList.isInSet(otherIndex)) { continue; }

                if (sectorWeights[otherIndex] < minWeight)
                {
                    minWeight = sectorWeights[otherIndex];
                    minWeightSectorIndex = otherIndex;
                }
            }

            if (minWeightSectorIndex == -1)
            {
                console.printf("Exploration pathfinder: failed to construct sector path");
                break;
            }
            currentSectorIndex = minWeightSectorIndex;
            // console.printf("Min weight: "..minWeightSectorIndex.." : "..minWeight);
            sectorPath.Push(minWeightSectorIndex);

            iteration++;
        }

        // string sectorPathString = "Sector path: ";
        // for (int i = 0; i < sectorPath.Size(); i++)
        // {
        //     sectorPathString = sectorPathString..", "..sectorPath[i];
        // }
        // console.printf(sectorPathString);

        CreateConnectionNodes();
    }

    void AddSectorsToOpenList(int sectorIndex)
    {
        Sector s = level.sectors[sectorIndex];
        for (int i = 0; i < s.lines.Size(); i++)
        {
            Line l = s.lines[i];
            bool isReachable = Toby_SectorMathUtil.IsSectorReachableByActor(s, l, explorer, true);
            if (!isReachable) { continue; }
            Sector other = Toby_SectorMathUtil.GetOtherSector(s, l);
            int otherSectorIndex = other.Index();
            bool isExplored = tracker.IsExplored(otherSectorIndex) || tracker.IsVisited(otherSectorIndex);
            if (!isExplored) { continue; }
            if (sectorClosedList.IsInSet(otherSectorIndex)) { continue; }
            sectorOpenList.Add(otherSectorIndex);
            if (sectorWeights[otherSectorIndex] > sectorWeights[sectorIndex])
            {
                sectorWeights[otherSectorIndex] = sectorWeights[sectorIndex] + 1;
            }
        }
    }

    void ResetSectorWeights()
    {
        for (int i = 0; i < sectorWeights.Size(); i++)
        {
            sectorWeights[i] = Int.Max;
        }
    }

    void CreateConnectionNodes()
    {
        if (sectorPath.Size() < 1)
        {
            console.printf("Exploration pathfinder: Less than one sector path nodes");
            return;
        }

        explorationNodes.MergeOtherContainer(inSectorNodeBuilder.GetNodesForSector(sectorPath[sectorPath.Size() - 1]));

        for (int i = 0; i < sectorPath.Size() - 1; i++)
        {
            Sector source = level.sectors[sectorPath[i]];
            Sector destination = level.sectors[sectorPath[i + 1]];

            for (int j = 0; j < source.lines.Size(); j++)
            {
                Line l = source.lines[j];
                bool isValid = IsValidConnection(l, source, destination, explorer);
                if (!isValid) { continue; }
                AddSectorConnectionNodes(l, source, destination);
                break;
            }
            explorationNodes.MergeOtherContainer(inSectorNodeBuilder.GetNodesForSector(source.Index()));
        }
        explorationNodes.MergeOtherContainer(mainContainer);
        explorationNodes.LinkAllNodesInSectors();
    }

    void AddSectorConnectionNodes(Line l, Sector source, Sector destination)
    {
        vector2 normalPoint1 = Toby_SectorMathUtil.GetMidlineNormalToSector(source, l);
        vector2 normalPoint2 = Toby_SectorMathUtil.GetMidlineNormalToSector(destination, l);

        Toby_PathfindingNode node1 = explorationNodes.AddNode((normalPoint1, source.CenterFloor()), l.Index());
        Toby_PathfindingNode node2 = explorationNodes.AddNode((normalPoint2, destination.CenterFloor()), l.Index());
        node1.AddEdge(node2);
    }

    bool IsValidConnection(Line l, Sector source, Sector destination, Actor a)
    {
        if (!((l.frontSector == source && l.backSector == destination)
            || (l.frontSector == destination && l.backSector == source))
        ) { return false; }
        bool isReachable = Toby_SectorMathUtil.IsSectorReachableByActor(source, l, a);
        if (!isReachable) { return false; }

        return true;
    }
}
