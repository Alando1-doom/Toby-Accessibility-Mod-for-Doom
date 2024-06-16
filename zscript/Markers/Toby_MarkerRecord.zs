class Toby_MarkerRecord
{
    int id;
    ZS_Marker_Base markerActor;
    string markerDescription;

    static Toby_MarkerRecord Create(int id, ZS_Marker_Base a, string description)
    {
        Toby_MarkerRecord record = new("Toby_MarkerRecord");
        record.id = id;
        record.markerActor = a;
        record.markerDescription = description;
        return record;
    }
}
