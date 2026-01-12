class Toby_SectorMathUtil
{
    static bool IntersectsSectorBoundary(vector2 pos1, vector2 pos2)
    {
        if (!Toby_SectorMathUtil.IsInSameSectorVector2(pos1, pos2)) { return true; }
        Sector pos1Sector = level.PointInSector(pos1);
        for (int i = 0; i < pos1Sector.lines.Size(); i++)
        {
            Line l = pos1Sector.lines[i];
            bool linesIntersect = Toby_LineSegmentIntersectionUtil.DoIntersect(
                l.v1.p,
                l.v2.p,
                pos1,
                pos2);
            if (linesIntersect)
            {
                if (Toby_SectorMathUtil.IntersectsSameSectorNonBlockingLine(pos1, pos2, l))
                {
                    continue;
                }
                return true;
            }
        }
        return false;
    }

    static bool IntersectsSameSectorNonBlockingLine(vector2 pos1, vector2 pos2, Line l)
    {
        Sector pos1Sector = level.PointInSector(pos1);
        Sector pos2Sector = level.PointInSector(pos2);
        bool isSameSector = pos1Sector.Index() == pos2Sector.Index();
        if (!l.frontSector) { return false; }
        if (!l.backSector) { return false; }
        bool isSameFrontAndBack = l.frontSector.Index() == l.backSector.Index();
        return isSameSector && isSameFrontAndBack && (!Toby_LineSegmentIntersectionUtil.IsBlocking(l));
    }

    static bool IsInSameSector(Vector3 pos1, Vector3 pos2)
    {
        Sector pos1Sector = level.PointInSector(pos1.xy);
        Sector pos2Sector = level.PointInSector(pos2.xy);
        return pos1Sector.Index() == pos2Sector.Index();
    }

    static bool IsInSameSectorVector2(Vector2 pos1, Vector2 pos2)
    {
        Sector pos1Sector = level.PointInSector(pos1);
        Sector pos2Sector = level.PointInSector(pos2);
        return pos1Sector.Index() == pos2Sector.Index();
    }

    static int GetWindowFloor(Sector sectorA, Sector sectorB)
    {
        return Max(sectorA.CenterFloor(), sectorB.CenterFloor());
    }

    static int GetWindowSize(Sector sectorA, Sector sectorB)
    {
        int maxFloor = GetWindowFloor(sectorA, sectorB);
        int minCeiling = Min(sectorA.CenterCeiling(), sectorB.CenterCeiling());
        return minCeiling - maxFloor;
    }

    static Sector GetOtherSector(Sector s, Line l)
    {
        if (l.backsector == s)
        {
            return l.frontsector;
        }
        return l.backsector;
    }

    //The idea behind swapSourceAndDestination is that sometimes we need to go from destination to source
    //In such cases we need to swap source and destination for check.
    static bool IsSectorReachableByActor(Sector sourceSector, Line l, Actor a, bool swapSourceAndDestination = false)
    {
        if (!a) { return false; }
        if (!l.frontsector) { return false; }
        if (!l.backsector) { return false; }

        bool isTwoSided = (l.flags & Line.ML_TWOSIDED) == Line.ML_TWOSIDED;
        bool isBlocking = (l.flags & Line.ML_BLOCKING) == Line.ML_BLOCKING;
        if (!isTwoSided) { return false; }
        if (isBlocking) { return false; }

        Sector destinationSector = GetOtherSector(sourceSector, l);

        if (swapSourceAndDestination)
        {
            Sector temp = sourceSector;
            sourceSector = destinationSector;
            destinationSector = temp;
        }

        int floorDifference = destinationSector.CenterFloor() - sourceSector.CenterFloor();
        if (Toby_SectorMathUtil.GetWindowSize(destinationSector, sourceSector) < a.height)
        {
            return false;
        }
        if (floorDifference <= a.MaxStepHeight)
        {
            return true;
        }
        return false;
    }

    static vector2 GetMidlineNormalToSector(Sector targetSector, Line l, double normalLength = 1.0)
    {
        vector2 deltaUnit = l.delta.Unit();
        vector2 normal1 = (-deltaUnit.y, deltaUnit.x);
        vector2 normal2 = (deltaUnit.y, -deltaUnit.x);
        vector2 lineMidpoint = l.v1.p + (l.delta * 0.5);
        vector2 normalPointSingleUnit = lineMidpoint + normal1;
        vector2 normalPoint1 = lineMidpoint + normal1 * normalLength;
        vector2 normalPoint2 = lineMidpoint + normal2 * normalLength;
        if (level.IsPointInLevel((normalPointSingleUnit, targetSector.CenterFloor())) && level.PointInSector(normalPointSingleUnit) == targetSector)
        {
            return normalPoint1;
        }
        else
        {
            return normalPoint2;
        }
    }

    static bool IsPointOnSectorLine(Vector2 point, Sector s)
    {
        bool isPointOnSectorLine = false;
        for (int i = 0; i < s.lines.Size(); i++)
        {
            Line l = s.lines[i];
            isPointOnSectorLine = Toby_LineSegmentIntersectionUtil.IsPointOnLine(point, l);
            if (isPointOnSectorLine)
            {
                break;
            }
        }
        return isPointOnSectorLine;
    }

    // Its kind of a terrible name, just like GetMidlineNormalToSector.
    // This is not a normal. Its a point that sits somewhere along the normal from line towards sector
    // but the actual vector starts at (0, 0) of a map
    // If that makes any sense.
    static Vector2 GetNormal(Sector s, Line l, PlayerPawn playerActor, bool oneUnitToTarget)
    {
        vector2 normal;
        if (oneUnitToTarget)
        {
            normal = Toby_SectorMathUtil.GetMidlineNormalToSector(s, l);
            return normal;
        }
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
            if (Toby_SectorMathUtil.IsPointOnSectorLine(normal, normalSector)) { continue; }
            isInMapBounds = level.IsPointInLevel((normal, normalSector.CenterFloor()));
            if (isInMapBounds) { break; }
        }
        if (!isInMapBounds)
        {
            normal = Toby_SectorMathUtil.GetMidlineNormalToSector(s, l);
        }
        return normal;
    }
}
