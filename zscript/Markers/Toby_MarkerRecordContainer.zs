class Toby_MarkerRecordContainer
{
    Array<Toby_MarkerRecord> records;
    int lastId;

    static Toby_MarkerRecordContainer Create()
    {
        Toby_MarkerRecordContainer container = new("Toby_MarkerRecordContainer");
        return container;
    }

    play void AddMarker(class<ZS_Marker_Base> type, Vector3 pos, string description)
    {
        ZS_Marker_Base markerActor = ZS_Marker_Base(Actor.Spawn(type, pos));
        Toby_MarkerRecord record = Toby_MarkerRecord.Create(lastId, markerActor, description);
        records.push(record);
        lastId++;
    }

    play void RemoveMarker(int id)
    {
        int indexToRemove = -1;
        for (int i = 0; i < records.Size(); i++)
        {
            if (records[i].id == id)
            {
                indexToRemove = i;
                break;
            }
        }
        if (indexToRemove < 0)
        {
            return;
        }
        records[indexToRemove].markerActor.Destroy();
        records.Delete(indexToRemove, 1);
    }

    Toby_MarkerRecord GetMarkerById(int id)
    {
        for (int i = 0; i < records.Size(); i++)
        {
            if (records[i].id == id)
            {
                return records[i];
            }
        }
        return null;
    }
}
