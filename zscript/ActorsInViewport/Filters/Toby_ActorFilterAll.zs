class Toby_ActorFilterAll: Toby_ActorFilter
{
    static Toby_ActorFilterAll Create(string name)
    {
        Toby_ActorFilterAll filter = new("Toby_ActorFilterAll");
        filter.name = name;
        return filter;
    }

    override bool CheckCondition(Actor actorToFilter) { return true; }
}
