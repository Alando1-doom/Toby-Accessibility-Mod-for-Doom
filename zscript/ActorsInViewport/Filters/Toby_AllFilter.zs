class Toby_AllFilter: Toby_ActorsFilter
{
    static Toby_AllFilter Create(string name)
    {
        Toby_AllFilter filter = new("Toby_AllFilter");
        filter.name = name;
        return filter;
    }

    override bool CheckCondition(Actor actorToFilter) { return true; }
}
