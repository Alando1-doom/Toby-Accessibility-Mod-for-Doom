class Toby_LineSegmentIntersectionUtil
{
    //https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/
    static int GetOrientation(Vector2 p, Vector2 q, Vector2 r)
    {
        double orientationValue = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y);
        if (orientationValue == 0) { return 0; } // Collinear
        if (orientationValue > 0) { return 1; } // Clockwise
        return 2; //Counterclockwise
    }

    static bool IsOnSegment(Vector2 p, Vector2 q, Vector2 r)
    {
        return
        (
            q.x <= Max(p.x, r.x) &&
            q.x >= Min(p.x, r.x) &&
            q.y <= Max(p.y, r.y) &&
            q.y >= Min(p.y, r.y)
        );
    }

    static bool DoIntersect(Vector2 p1, Vector2 q1, Vector2 p2, Vector2 q2)
    {
        int o1 = Toby_LineSegmentIntersectionUtil.GetOrientation(p1, q1, p2);
        int o2 = Toby_LineSegmentIntersectionUtil.GetOrientation(p1, q1, q2);
        int o3 = Toby_LineSegmentIntersectionUtil.GetOrientation(p2, q2, p1);
        int o4 = Toby_LineSegmentIntersectionUtil.GetOrientation(p2, q2, q1);

        // General case
        if (o1 != o2 && o3 != o4) { return true; }

        // Special Cases
        // p1, q1, and p2 are collinear and p2 lies on segment p1q1
        if (o1 == 0 && Toby_LineSegmentIntersectionUtil.IsOnSegment(p1, p2, q1)) { return true; }
        // p1, q1, and q2 are collinear and q2 lies on segment p1q1
        if (o2 == 0 && Toby_LineSegmentIntersectionUtil.IsOnSegment(p1, q2, q1)) { return true; }
        // p2, q2, and p1 are collinear and p1 lies on segment p2q2
        if (o3 == 0 && Toby_LineSegmentIntersectionUtil.IsOnSegment(p2, p1, q2)) { return true; }
        // p2, q2, and q1 are collinear and q1 lies on segment p2q2
        if (o4 == 0 && Toby_LineSegmentIntersectionUtil.IsOnSegment(p2, q1, q2)) { return true; }

        return false; // Doesn't fall in any of the above cases
    }

    static bool IsBlocking(Line l)
    {
        if (!l)
        {
            return false;
        }

        return (!(l.flags & Line.ML_TWOSIDED) || l.flags & Line.ML_Blocking || l.flags & Line.ML_Railing || l.flags & Line.ML_3DMidTex);
    }

    static Vector2 ClosestPointOnSegment(Vector2 p, Vector2 a, Vector2 b)
    {
        Vector2 ab = b - a;
        if (ab.Length() == 0) { return a; }
        Vector2 ap = p - a;
        double projectionScalar = (ap dot ab) / (ab.Length() * ab.Length());
        projectionScalar = Clamp(projectionScalar, 0, 1);
        return a + projectionScalar * ab;
    }

    static double GetMinimalDistance(Vector2 p1, Vector2 q1, Vector2 p2, Vector2 q2)
    {
        if (DoIntersect(p1, q1, p2, q2))
        {
            return 0;
        }

        Vector2 closestPoint = ClosestPointOnSegment(p1, p2, q2);
        double minDistance = (p1 - closestPoint).Length();

        closestPoint = ClosestPointOnSegment(q1, p2, q2);
        minDistance = Min(minDistance, (q1 - closestPoint).Length());

        closestPoint = ClosestPointOnSegment(p2, p1, q1);
        minDistance = Min(minDistance, (p2 - closestPoint).Length());

        closestPoint = ClosestPointOnSegment(q2, p1, q1);
        minDistance = Min(minDistance, (q2 - closestPoint).Length());

        return minDistance;
    }
}
