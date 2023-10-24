class Toby_ActorFilterRemains: Toby_ActorFilter
{
    static Toby_ActorFilterRemains Create(string name)
    {
        Toby_ActorFilterRemains filter = new("Toby_ActorFilterRemains");
        filter.name = name;
        return filter;
    }

    override bool CheckCondition(Actor actorToFilter)
    {
        return actorToFilter.health <= 0;
    }
}
