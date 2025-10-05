class Toby_WeaponSlotItemCollection : Toby_SortableCollection
{
    Array<Toby_WeaponSlotItem> collection;

    static Toby_WeaponSlotItemCollection Create()
    {
        return new("Toby_WeaponSlotItemCollection");
    }

    int Size()
    {
        return collection.Size();
    }

    void AddItem(int slot, int priority, class<Weapon> type)
    {
        collection.push(Toby_WeaponSlotItem.Create(slot, priority, type));
    }

    override Object GetObject(int arrayPos)
    {
        if (arrayPos < 0 || arrayPos >= collection.Size()) { return null; }

        return collection[arrayPos];
    }

    override void SetObject(int arrayPos, Object item)
    {
        if (arrayPos < 0 || arrayPos >= collection.Size()) { return; }

        collection[arrayPos] = (Toby_WeaponSlotItem)(item);
    }

    override int Compare(int arrayPos, int pivotPos)
    {
        if (arrayPos < 0 || arrayPos >= collection.Size()) { return 1; };
        if (pivotPos < 0 || pivotPos >= collection.Size()) { return -1; };
        if (collection[arrayPos] == null) { return 0; }
        if (collection[pivotPos] == null) { return 0; }

        if (collection[arrayPos].slot < collection[pivotPos].slot)
        {
            return -1;
        }
        if (collection[arrayPos].slot > collection[pivotPos].slot)
        {
            return 1;
        }
        if (collection[arrayPos].priority < collection[pivotPos].priority)
        {
            return 1;
        }
        if (collection[arrayPos].priority > collection[pivotPos].priority)
        {
            return -1;
        }
        return 0;
    }
}
