class Toby_ExplorationPathfinder
{
    Actor explorer;
    Toby_ExplorationTracker tracker;
    Toby_IntegerSet sectorOpenList;
    Toby_IntegerSet sectorClosedList;
    Array<int> sectorWeights;
    Array<int> sectorPath;
    int firstVisitedSector;

    play static Toby_ExplorationPathfinder Create(Actor explorer, Toby_ExplorationTracker tracker)
    {
        Toby_ExplorationPathfinder epf = new("Toby_ExplorationPathfinder");
        epf.explorer = explorer;
        epf.tracker = tracker;
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
            // console.printf("Exploration pathfinder: failed to find explored area");
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
                // console.printf("Exploration pathfinder: failed to construct sector path");
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
}
