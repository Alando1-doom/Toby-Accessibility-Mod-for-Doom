class Toby_MarkerDatabaseItem
{
    string actorClassName;
    string description;
    string placedSound;
    string removedSound;


    static Toby_MarkerDatabaseItem Create(string actorClassName, string description, string placedSound, string removedSound)
    {
        Toby_MarkerDatabaseItem item = new("Toby_MarkerDatabaseItem");
        item.actorClassName = actorClassName;
        item.description = description;
        item.placedSound = placedSound;
        item.removedSound = removedSound;

        return item;
    }
}
