class Toby_ActorFilterVerticalDistance: Toby_ActorFilter
{
    private Actor playerActor;
    private double min;
    private double max;

    static Toby_ActorFilterVerticalDistance Create(string name, Actor playerActor, double min, double max)
    {
        Toby_ActorFilterVerticalDistance filter = new("Toby_ActorFilterVerticalDistance");
        filter.name = name;
        filter.playerActor = playerActor;
        filter.min = min;
        filter.max = max;
        return filter;
    }

    override bool CheckCondition(Actor actorToFilter)
    {
        double distance = actorToFilter.pos.z - playerActor.pos.z;
        bool result = distance > min && distance <= max;
        return result;
    }
}
