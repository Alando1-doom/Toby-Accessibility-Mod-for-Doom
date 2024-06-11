class Toby_AutoMarkerDatabaseItem
{
    string targetActorName;
    string markerActorName;
    string description;

    static Toby_AutoMarkerDatabaseItem Create(string targetActorName, string markerActorName, string description)
    {
        Toby_AutoMarkerDatabaseItem item = new("Toby_AutoMarkerDatabaseItem");
        item.targetActorName = targetActorName;
        item.markerActorName = markerActorName;
        item.description = description;

        return item;
    }
}
