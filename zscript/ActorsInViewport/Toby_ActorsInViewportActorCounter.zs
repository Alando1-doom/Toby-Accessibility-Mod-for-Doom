class Toby_ActorsInViewportActorCounter
{
    private Toby_ActorsInViewportStorage storage;
    bool isRemains;
    Array<Toby_NameAndAmount> namesAndAmounts;

    static Toby_ActorsInViewportActorCounter Create(Toby_ActorsInViewportStorage storage, string filterName, bool isRemains)
    {
        Toby_ActorsInViewportActorCounter counter = new("Toby_ActorsInViewportActorCounter");
        counter.storage = storage;
        counter.isRemains = isRemains;
        counter.Count(filterName);
        return counter;
    }

    private void Count(string filterName)
    {
        namesAndAmounts.Clear();
        Toby_ActorFilter filter = storage.GetFilterByName(filterName);
        for (let i = 0; i < filter.category.Size(); i++)
        {
            AddName(filter.category[i].GetClassName());
        }
    }

    private void AddName(string name)
    {
        bool nameFound = false;

        for (let i = 0; i < namesAndAmounts.Size(); i++)
        {
            if (namesAndAmounts[i].name == name)
            {
                nameFound = true;
                namesAndAmounts[i].amount++;
                break;
            }
        }
        if (!nameFound)
        {
            namesAndAmounts.push(Toby_NameAndAmount.Create(name, 1));
        }
    }
}
