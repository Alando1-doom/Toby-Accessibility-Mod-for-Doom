class Toby_ActorFilterLogicAnd: Toby_ActorFilter
{
    Toby_ActorFilter filterA;
    Toby_ActorFilter filterB;

    static Toby_ActorFilterLogicAnd Create(string name, Toby_ActorFilter filterA, Toby_ActorFilter filterB)
    {
        Toby_ActorFilterLogicAnd filter = new("Toby_ActorFilterLogicAnd");
        filter.name = name;
        filter.filterA = filterA;
        filter.filterB = filterB;

        return filter;
    }

    override bool CheckCondition(Actor actorToFilter)
    {
        bool result = filterA.CheckCondition(actorToFilter) && filterB.CheckCondition(actorToFilter);
        return result;
    }
}
