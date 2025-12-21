class Toby_MarkerDestinationCollection : Toby_SortableCollection
{
    Array<Toby_MarkerDestinationItem> collection;

    static Toby_MarkerDestinationCollection Create()
    {
        return new("Toby_MarkerDestinationCollection");
    }

    int Size()
    {
        return collection.Size();
    }

    void AddItem(Vector3 coordinates, Actor playerActor, double pathLength, Actor destinationActor = null)
    {
        collection.push(Toby_MarkerDestinationItem.Create(coordinates, playerActor, pathLength, destinationActor));
    }

    override Object GetObject(int arrayPos)
    {
        if (arrayPos < 0 || arrayPos >= collection.Size()) { return null; }

        return collection[arrayPos];
    }

    override void SetObject(int arrayPos, Object item)
    {
        if (arrayPos < 0 || arrayPos >= collection.Size()) { return; }

        collection[arrayPos] = (Toby_MarkerDestinationItem)(item);
    }

    override int Compare(int arrayPos, int pivotPos)
    {
        if (arrayPos < 0 || arrayPos >= collection.Size()) { return 1; };
        if (pivotPos < 0 || pivotPos >= collection.Size()) { return -1; };
        if (collection[arrayPos] == null) { return 0; }
        if (collection[pivotPos] == null) { return 0; }

        if (collection[arrayPos].distance < collection[pivotPos].distance)
        {
            return -1;
        }
        if (collection[arrayPos].distance > collection[pivotPos].distance)
        {
            return 1;
        }
        return 0;
    }
}
