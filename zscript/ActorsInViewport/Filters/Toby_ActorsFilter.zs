class Toby_ActorsFilter abstract
{
    string name;
    Array<Actor> category;

    virtual void ResetFilter()
    {
        category.Clear();
    }

    void Filter(Actor actorToFilter)
    {
        if (CheckCondition(actorToFilter))
        {
            category.push(actorToFilter);
        }
    }

    abstract bool CheckCondition(Actor actorToFilter);
}
