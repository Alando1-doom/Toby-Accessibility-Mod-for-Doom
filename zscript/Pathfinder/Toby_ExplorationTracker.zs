class Toby_ExplorationTracker
{
    Actor explorer;

    Toby_ExplorationDetector detector;
    Toby_SectorMovementDetector sectorMovementDetector;
    Toby_LineInteractionTracker lineInteractionTracker;
    Array<bool> visitedSectors;

    //Explored in this context will mean "Visible and reachable by player"

    Toby_IntegerSet unexploredLines;
    Toby_IntegerSet exploredLines;

    Toby_IntegerSet unexploredSectors;
    Toby_IntegerSet exploredSectors;

    Toby_IntegerSet nonInteractedLines;

    play static Toby_ExplorationTracker Create(
        Actor explorer,
        Toby_SectorMovementDetector sectorMovementDetector,
        Toby_LineInteractionTracker lineInteractionTracker
    )
    {
        Toby_ExplorationTracker tracker = new("Toby_ExplorationTracker");
        tracker.detector = Toby_ExplorationDetector(Actor.Spawn("Toby_ExplorationDetector", (0, 0, 0)));

        tracker.unexploredLines = Toby_IntegerSet.Create();
        tracker.exploredLines = Toby_IntegerSet.Create();
        tracker.unexploredSectors = Toby_IntegerSet.Create();
        tracker.exploredSectors = Toby_IntegerSet.Create();

        tracker.nonInteractedLines = Toby_IntegerSet.Create();

        tracker.explorer = explorer;
        tracker.sectorMovementDetector = sectorMovementDetector;
        tracker.lineInteractionTracker = lineInteractionTracker;

        for (int i = 0; i < level.sectors.Size(); i++)
        {
            tracker.visitedSectors.push(false);
        }

        return tracker;
    }

    play void Update()
    {
        if (!explorer) { return; }
        int curSectorIndex = explorer.curSector.Index();
        if (!visitedSectors[curSectorIndex])
        {
            AddVisitedSector(curSectorIndex);
            AddUnexploredLines(curSectorIndex);
        }

        UpdateExploration();
    }

    play void UpdateNonInteractedLines()
    {
        nonInteractedLines.Clear();
        for (int i = 0; i < visitedSectors.Size(); i++)
        {
            if (!(visitedSectors[i] || exploredSectors.IsInSet(i))) { continue; }
            Sector s = level.sectors[i];
            for (int j = 0; j < s.lines.Size(); j++)
            {
                Line l = s.lines[j];
                if (l.activation != SPAC_Use) { continue; }
                int lineIndex = l.Index();
                if (lineInteractionTracker.interactedLines[lineIndex]) { continue; }

                //If floor and ceiling are flush -> ignore
                if (isLineFlushWithCeiling(l) && isLineFlushWithFloor(l)) { continue; }
                //If floor is flush and ceiling is 4 map units difference -> most likely opened bars / door -> ignore
                if (isLineCeilingDoorLip(l) && isLineFlushWithFloor(l)) { continue; }
                nonInteractedLines.Add(lineIndex);
            }
        }
    }

    play void UpdateExploration()
    {
        UpdateSectorMovementExploration();
        UpdateLineExploration();
        UpdateSectorExploration();
        if (lineInteractionTracker.updated)
        {
            UpdateNonInteractedLines();
        }
    }

    play void UpdateSectorMovementExploration()
    {
        for (int i = 0; i < sectorMovementDetector.sectorsJustStopped.Size(); i++)
        {
            int sectorIndex = sectorMovementDetector.sectorsJustStopped.values[i];
            Sector s = level.sectors[sectorIndex];

            for (int i = 0; i < s.lines.Size(); i++)
            {
                Line l = s.lines[i];

                bool isTwoSided = (l.flags & Line.ML_TWOSIDED) == Line.ML_TWOSIDED;
                bool isBlocking = (l.flags & Line.ML_BLOCKING) == Line.ML_BLOCKING;

                if (!isTwoSided) { continue; }
                if (isBlocking) { continue; }
                if (!l.frontSector) { continue; }
                if (!l.backSector) { continue; }

                int frontIndex = l.frontSector.Index();
                int backIndex = l.backSector.Index();
                bool isExploredOrVisited =
                    exploredSectors.isInSet(frontIndex)
                    || exploredSectors.isInSet(backIndex)
                    || visitedSectors[frontIndex]
                    || visitedSectors[backIndex];
                if (!isExploredOrVisited) { continue; }
                int lineIndex = l.Index();
                if (!isReachable(s, l, explorer)) { continue; }
                unexploredLines.Add(lineIndex);
            }
            UpdateNonInteractedLines();
        }
    }

    play void UpdateSectorExploration()
    {
        for (int i = unexploredSectors.Size() - 1; i >= 0; i--)
        {
            AddUnexploredLines(unexploredSectors.values[i]);
            exploredSectors.Add(unexploredSectors.values[i]);
            unexploredSectors.Remove(unexploredSectors.values[i]);
        }
    }

    play void UpdateLineExploration()
    {
        if (!explorer) { return; }
        int attemptsPerLine = 5; //Ideally should be an odd number
        Array<int> linesToRemove;
        linesToRemove.Clear();
        for (int i = 0; i < unexploredLines.Size(); i++)
        {
            Line l = level.lines[unexploredLines.values[i]];
            int detectorZ = Toby_SectorMathUtil.GetWindowFloor(l.frontsector, l.backsector) + explorer.height;
            double stepSize = l.delta.Length() / attemptsPerLine;
            for (int j = 0; j < attemptsPerLine; j++)
            {
                vector3 attemptPosition = (l.v1.p + l.delta.Unit() * stepSize * j, detectorZ);
                detector.SetXYZ(attemptPosition);
                bool isExplorerVisible = detector.IsVisible(explorer, true);
                if (!isExplorerVisible) { continue; }
                linesToRemove.push(unexploredLines.values[i]);
                AddUnexploredSector(l.frontsector);
                AddUnexploredSector(l.backsector);
                break;
            }
        }

        for (int i = 0; i < linesToRemove.Size(); i++)
        {
            for (int j = unexploredLines.values.Size() - 1; j >= 0; j--)
            {
                if (unexploredLines.values[j] != linesToRemove[i]) { continue; }
                exploredLines.Add(linesToRemove[i]);
                unexploredLines.Remove(unexploredLines.values[j]);
            }
        }
    }

    play void AddUnexploredSector(Sector s)
    {
        int sectorIndex = s.Index();
        if (visitedSectors[sectorIndex]) { return; }
        if (exploredSectors.isInSet(sectorIndex)) { return; }
        unexploredSectors.Add(sectorIndex);
        UpdateNonInteractedLines();
    }

    play void AddVisitedSector(int sectorIndex)
    {
        visitedSectors[sectorIndex] = true;
        unexploredSectors.Remove(sectorIndex);
        exploredSectors.Remove(sectorIndex);
    }

    play void AddUnexploredLines(int sectorIndex)
    {
        Sector s = level.sectors[sectorIndex];
        for (int i = 0; i < s.lines.Size(); i++)
        {
            Line l = s.lines[i];

            bool isTwoSided = (l.flags & Line.ML_TWOSIDED) == Line.ML_TWOSIDED;
            bool isBlocking = (l.flags & Line.ML_BLOCKING) == Line.ML_BLOCKING;
            if (!isTwoSided) { continue; }
            if (isBlocking) { continue; }
            int lineIndex = l.Index();
            if (exploredLines.IsInSet(lineIndex)) { continue; }
            if (!isReachable(s, l, explorer)) { continue; }
            unexploredLines.Add(lineIndex);
        }
    }

    bool isReachable(Sector s, Line l, Actor explorer)
    {
        if (!explorer) { return false; }
        if (!l.frontsector) { return false; }
        if (!l.backsector) { return false; }

        Sector otherSector;
        if (l.backsector == s)
        {
            otherSector = l.frontsector;
        }
        else
        {
            otherSector = l.backsector;
        }

        int floorDifference = otherSector.CenterFloor() - s.CenterFloor();
        if (Toby_SectorMathUtil.GetWindowSize(otherSector, s) < explorer.height)
        {
            return false;
        }
        if (floorDifference <= explorer.MaxStepHeight)
        {
            return true;
        }
        return false;
    }

    bool isLineFlushWithFloor(Line l)
    {
        if (!l.frontsector) { return false; }
        if (!l.backsector) { return false; }

        if (l.frontsector.CenterFloor() == l.backsector.CenterFloor())
        {
            return true;
        }

        return false;
    }

    bool isLineFlushWithCeiling(Line l)
    {
        if (!l.frontsector) { return false; }
        if (!l.backsector) { return false; }

        if (l.frontsector.CenterCeiling() == l.backsector.CenterCeiling())
        {
            return true;
        }

        return false;
    }

    bool isLineCeilingDoorLip(Line l)
    {
        if (!l.frontsector) { return false; }
        if (!l.backsector) { return false; }

        if (Abs(l.frontsector.CenterCeiling() - l.backsector.CenterCeiling()) == 4)
        {
            return true;
        }

        return false;
    }
}
