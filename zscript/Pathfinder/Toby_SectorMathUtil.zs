class Toby_SectorMathUtil
{
    static bool IntersectsSectorBoundary(vector2 pos1, vector2 pos2)
    {
        Sector pos1Sector = level.PointInSector(pos1);
        Sector pos2Sector = level.PointInSector(pos2);
        if (pos1Sector.Index() != pos1Sector.Index()) { return true; }
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
                if (pos1Sector == pos2Sector && l.frontSector == l.backSector && (!Toby_LineSegmentIntersectionUtil.IsBlocking(l)))
                {
                    continue;
                }
                return true;
            }
        }
        return false;
    }

    static bool IsInSameSector(Vector3 pos1, Vector3 pos2)
    {
        return Level.PointInSector(pos1.xy).Index() == Level.PointInSector(pos2.xy).Index();
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
}
