class ZS_MarkerHandler : EventHandler
{
    int maxPlayers;
    Array<Toby_MarkerRecordContainer> recordContainers;
    Toby_MarkerDatabase db;

    override void OnRegister()
    {
        Toby_Logger.Message("ZS_MarkerHandler registered!", "Toby_Developer");
    }

    override void WorldLoaded(WorldEvent e)
    {
        maxPlayers = 8;
        int i = 0;
        for (i = 0; i < maxPlayers; i++)
        {
            Actor playerActor = players[i].mo;
            Toby_MarkerRecordContainer recordContainer = Toby_MarkerRecordContainer.Create();
            recordContainers.push(recordContainer);
        }

        for (i = 0; i < maxPlayers; i++)
        {
            PlayerInfo player = players[i];
            if (!player) { continue; }
            Actor playerActor = players[i].mo;
            if (!playerActor) { continue; }

            recordContainers[i].AddMarker("Toby_Marker_LevelStart", playerActor.pos, "Level start");
        }

        db = Toby_MarkerDatabase.Create();

        db.AddItem("Toby_Marker_1", "Marker 1", "marker/marker1", "marker/undo1");
        db.AddItem("Toby_Marker_2", "Marker 2", "marker/marker2", "marker/undo2");
        db.AddItem("Toby_Marker_3", "Marker 3", "marker/marker3", "marker/undo3");
        db.AddItem("Toby_Marker_4", "Marker 4", "marker/marker4", "marker/undo4");
        db.AddItem("Toby_Marker_5", "Marker 5", "marker/marker5", "marker/undo5");
        db.AddItem("Toby_Marker_6", "Marker 6", "marker/marker6", "marker/undo6");
        db.AddItem("Toby_Marker_7", "Marker 7", "marker/marker7", "marker/undo7");
        db.AddItem("Toby_Marker_8", "Marker 8", "marker/marker8", "marker/undo8");
        db.AddItem("Toby_Marker_9", "Marker 9", "marker/marker9", "marker/undo9");
        db.AddItem("Toby_Marker_10", "Marker 10", "marker/marker10", "marker/undo10");
    }

    override void NetworkProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[e.Player];
        if (!player) { return; }
        Actor playerActor = players[e.Player].mo;
        if (!playerActor) { return; }

        int maxRemovalDistance = CVar.GetCVar("zs_em_MaxDistance", player).GetInt();

        Array<String> eventAndArgument;
        e.Name.split(eventAndArgument, ":", TOK_KEEPEMPTY);

        if (eventAndArgument[0] == "ZS_PlaceMarker" && IsMarkerInWhitelist(eventAndArgument[1]))
        {
            recordContainers[e.Player].AddMarker(eventAndArgument[1], playerActor.pos, eventAndArgument[1]);
        }
        if (eventAndArgument[0] == "ZS_RemoveMarker")
        {
            recordContainers[e.Player].RemoveMarker(eventAndArgument[1].ToInt());
        }
    }

    bool IsMarkerInWhitelist(String markerClassName)
    {
        Toby_MarkerDatabaseItem item = db.GetItemByClassName(markerClassName);
        if (!item) { return false; }
        return true;
    }

    ui void PlayUndoSound(string markerClassName)
    {
        Toby_MarkerDatabaseItem item = db.GetItemByClassName(markerClassName);
        if (!item) { return; }
        S_StartSound(item.removedSound, CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
    }

    ui void PlayPlaceSound(string markerClassName)
    {
        Toby_MarkerDatabaseItem item = db.GetItemByClassName(markerClassName);
        if (!item) { return; }
        S_StartSound(item.placedSound, CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
    }

    ui void DisplayMarkerPlacedMessage(string markerClassName)
    {
        Toby_MarkerDatabaseItem item = db.GetItemByClassName(markerClassName);
        if (!item) { return; }
        Console.MidPrint(SmallFont, item.description.." Placed");
    }

    ui void DisplayMarkerRemovedMessage(string markerClassName)
    {
        Toby_MarkerDatabaseItem item = db.GetItemByClassName(markerClassName);
        if (!item) { return; }
        Console.MidPrint(SmallFont, item.description.." Removed");
    }

    int Modulo(int a, int b)
    {
        return int(((a % b) + b) % b);
    }

    ui static ZS_MarkerHandler GetInstanceUi()
    {
        return ZS_MarkerHandler(EventHandler.Find("ZS_MarkerHandler"));
    }

    play static ZS_MarkerHandler GetInstancePlay()
    {
        return ZS_MarkerHandler(EventHandler.Find("ZS_MarkerHandler"));
    }
}
