class Toby_DistanceFilter: Toby_ActorsFilter
{
    private Actor playerActor;
    private double min;
    private double max;

    static Toby_DistanceFilter Create(string name, Actor playerActor, double min, double max)
    {
        Toby_DistanceFilter filter = new("Toby_DistanceFilter");
        filter.name = name;
        filter.playerActor = playerActor;
        filter.min = min;
        filter.max = max;
        return filter;
    }

    override bool CheckCondition(Actor actorToFilter)
    {
        double distance = (actorToFilter.pos - playerActor.pos).Length();
        bool result = distance > min && distance <= max;
        return result;
    }
}
