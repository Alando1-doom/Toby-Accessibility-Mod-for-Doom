class Toby_PathfinderThinker : Thinker
{
    Toby_Pathfinder pf;
    Toby_PathfinderFollower pfFollower;
    Actor receivingActor;

    static Toby_PathfinderThinker Create(Toby_Pathfinder pf, Toby_PathfinderFollower pfFollower, Actor receivingActor)
    {
        Toby_PathfinderThinker pfThinker = new("Toby_PathfinderThinker");
        pfThinker.receivingActor = receivingActor;
        pfThinker.pf = pf;
        pfThinker.pfFollower = pfFollower;
        return pfThinker;
    }

    void FindPath(Vector3 start, Vector3 end)
    {
        pf.StartPathfinding(start, end);
        pfFollower.StartFollowingPath();
    }

    override void Tick()
    {
        pf.FindPath();
        pfFollower.UpdateCurrentPathNode(receivingActor);
    }
}
