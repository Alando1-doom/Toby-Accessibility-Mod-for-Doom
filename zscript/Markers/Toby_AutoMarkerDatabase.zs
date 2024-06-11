class Toby_AutoMarkerDatabase
{
    Array<Toby_AutoMarkerDatabaseItem> items;

    static Toby_AutoMarkerDatabase Create()
    {
        Toby_AutoMarkerDatabase db = new("Toby_AutoMarkerDatabase");
        return db;
    }

    void AddItem(string targetActorName, string markerActorName, string description)
    {
        Toby_AutoMarkerDatabaseItem item = Toby_AutoMarkerDatabaseItem.Create(targetActorName, markerActorName, description);
        items.push(item);
    }
}
