class Toby_MarkerDatabase
{
    Array<Toby_MarkerDatabaseItem> items;

    static Toby_MarkerDatabase Create()
    {
        Toby_MarkerDatabase db = new("Toby_MarkerDatabase");
        return db;
    }

    void AddItem(string actorClassName, string description, string placedSound, string removedSound)
    {
        Toby_MarkerDatabaseItem item = Toby_MarkerDatabaseItem.Create(actorClassName, description, placedSound, removedSound);
        items.push(item);
    }

    Toby_MarkerDatabaseItem GetItemByClassName(string actorClassName)
    {
        for (int i = 0; i < items.Size(); i++)
        {
            if (items[i].actorClassName == actorClassName)
            {
                return items[i];
            }
        }
        return null;
    }
}
