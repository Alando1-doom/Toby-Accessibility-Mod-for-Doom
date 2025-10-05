class Toby_WeaponSlotItem
{
    int slot;
    int priority;
    class<Weapon> type;

    static Toby_WeaponSlotItem Create(int slot, int priority, class<Weapon> type)
    {
        Toby_WeaponSlotItem item = new("Toby_WeaponSlotItem");

        item.slot = slot;
        item.priority = priority;
        item.type = type;

        return item;
    }
}
