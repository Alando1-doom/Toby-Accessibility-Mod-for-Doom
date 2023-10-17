class Toby_ActorFilterDistance: Toby_ActorFilter
{
    private Actor playerActor;
    private double min;
    private double max;

    static Toby_ActorFilterDistance Create(string name, Actor playerActor, double min, double max)
    {
        Toby_ActorFilterDistance filter = new("Toby_ActorFilterDistance");
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
