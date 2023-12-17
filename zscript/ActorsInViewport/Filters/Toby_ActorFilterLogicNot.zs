class Toby_ActorFilterLogicNot: Toby_ActorFilter
{
    Toby_ActorFilter other;

    static Toby_ActorFilterLogicNot Create(string name, Toby_ActorFilter other)
    {
        Toby_ActorFilterLogicNot filter = new("Toby_ActorFilterLogicNot");
        filter.name = name;
        filter.other = other;
        return filter;
    }

    override bool CheckCondition(Actor actorToFilter)
    {
        return !other.CheckCondition(actorToFilter);
    }
}
