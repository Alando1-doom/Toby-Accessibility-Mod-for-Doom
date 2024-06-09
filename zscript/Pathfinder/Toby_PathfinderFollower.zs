class Toby_PathfinderFollower
{
    Toby_Pathfinder pf;
    int currentPathNode;
    bool destinationReached;

    static Toby_PathfinderFollower Create(Toby_Pathfinder pf)
    {
        Toby_PathfinderFollower follower = new("Toby_PathfinderFollower");
        follower.currentPathNode = 0;
        follower.destinationReached = true;
        follower.pf = pf;
        return follower;
    }

    void StartFollowingPath()
    {
        currentPathNode = 0;
        destinationReached = false;
    }

    bool IsOnPath(Actor a, int distance = 50)
    {
        if (pf.path.Size() < 2)
        {
            return false;
        }
        bool onPath = false;
        for (int i = 0; i < pf.path.Size() - 1; i++)
        {
            int actualDistance = pf.GetDistanceToEdge(
                pf.path[i].pos.xy,
                pf.path[i+1].pos.xy,
                a.pos.xy
            );

            if (actualDistance < distance)
            {
                onPath = true;
                break;
            }
        }
        if (onPath)
        {
            return true;
        }
        return false;
    }

    Toby_PathfindingNode GetCurrentPathNode()
    {
        if (!pf.pathFinalized)
        {
            return null;
        }
        if (currentPathNode >= pf.path.Size())
        {
            return null;
        }
        return pf.path[currentPathNode];
    }

    bool IsCurrentPathNodeReached(Actor a, int range = 50)
    {
        if (!pf.pathFinalized) { return false; }
        Toby_PathfindingNode node = GetCurrentPathNode();
        if (!node) { return false; }
        if (!a) { return false; }
        if ((a.pos.xy - node.pos.xy).Length() < range)
        {
            return true;
        }
        return false;
    }

    void UpdateCurrentPathNode(Actor a, int range = 50)
    {
        if (destinationReached) { return; }
        if (!pf.pathFinalized) { return; }
        if (!a) { return; }
        bool nodeReached = IsCurrentPathNodeReached(a, range);
        if (!nodeReached) { return; }
        bool isLastNode = currentPathNode == pf.path.Size() - 1;
        if (isLastNode)
        {
            destinationReached = true;
        }
        currentPathNode++;
    }
}
