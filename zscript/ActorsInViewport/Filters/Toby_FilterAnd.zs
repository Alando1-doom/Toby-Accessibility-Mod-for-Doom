class Toby_FilterAnd: Toby_ActorsFilter
{
    Toby_ActorsFilter filterA;
    Toby_ActorsFilter filterB;

    static Toby_FilterAnd Create(string name, Toby_ActorsFilter filterA, Toby_ActorsFilter filterB)
    {
        Toby_FilterAnd filter = new("Toby_FilterAnd");
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
