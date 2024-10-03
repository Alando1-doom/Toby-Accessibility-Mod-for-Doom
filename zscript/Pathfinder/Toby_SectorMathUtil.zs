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
}
