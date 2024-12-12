class Toby_MarkerHandler : EventHandler
{
    int maxPlayers;
    Array<Toby_MarkerRecordContainer> recordContainers;
    Toby_MarkerDatabase db;
    Toby_AutoMarkerDatabase autoMarkerDb;

    override void OnRegister()
    {
        Toby_Logger.Message("Toby_MarkerHandler registered!", "Toby_Developer");
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

        autoMarkerDb = Toby_AutoMarkerDatabase.Create();
        autoMarkerDb.AddItem("RedKeyChecker_V2", "Toby_Marker_RedKeyDoor", "Red key door");
        autoMarkerDb.AddItem("BlueKeyChecker_V2", "Toby_Marker_BlueKeyDoor", "Blue key door");
        autoMarkerDb.AddItem("YellowKeyChecker_V2", "Toby_Marker_YellowKeyDoor", "Yellow key door");
        autoMarkerDb.AddItem("GreenKeyChecker_V2", "Toby_Marker_GreenKeyDoor", "Green key door"); //Heretic

        autoMarkerDb.AddItem("RedSkullChecker_V2", "Toby_Marker_RedSkullDoor", "Red skull door");
        autoMarkerDb.AddItem("BlueSkullChecker_V2", "Toby_Marker_BlueSkullDoor", "Blue skull door");
        autoMarkerDb.AddItem("YellowSkullChecker_V2", "Toby_Marker_YellowSkullDoor", "Yellow skull door");

        autoMarkerDb.AddItem("3KeyChecker_V2", "Toby_Marker_ThreeKeyDoor", "Three key door");
        autoMarkerDb.AddItem("6KeyChecker_V2", "Toby_Marker_SixKeyDoorDoor", "Six key door");
        autoMarkerDb.AddItem("AnyKeyChecker_V2", "Toby_Marker_AnyKeyDoor", "Any key door");
		
		autoMarkerDb.AddItem("AxeKeyChecker", "Toby_Marker_AxeKey", "Axe Door");
		autoMarkerDb.AddItem("CastleKeyChecker", "Toby_Marker_CastleKey", "Castle Door");
		autoMarkerDb.AddItem("CaveKeyChecker", "Toby_Marker_CaveKey", "Cave Door");
		autoMarkerDb.AddItem("DungeonKeyChecker", "Toby_Marker_DungeonKey", "Dungeon Door");
		autoMarkerDb.AddItem("EmeraldKeyChecker", "Toby_Marker_EmeraldKey", "Emerald Door");
		autoMarkerDb.AddItem("FireKeyChecker", "Toby_Marker_FireKey", "Fire Door");
		autoMarkerDb.AddItem("HornKeyChecker", "Toby_Marker_HornKey", "Horn Door");
		autoMarkerDb.AddItem("RustedKeyChecker", "Toby_Marker_RustedKey", "Rusted Door");
		autoMarkerDb.AddItem("SilverKeyChecker", "Toby_Marker_SilverKey", "Silver Door");
		autoMarkerDb.AddItem("SteelKeyChecker", "Toby_Marker_SteelKey", "Steel Door");
		autoMarkerDb.AddItem("SwampKeyChecker", "Toby_Marker_SwampKey", "Swamp Door");
		autoMarkerDb.AddItem("AllKeyChecker", "Toby_Marker_AllKey", "All Key Door");

        autoMarkerDb.AddItem("ExitBeacon1", "Toby_Marker_Exit", "Exit");
        autoMarkerDb.AddItem("SecretExitBeacon", "Toby_Marker_Secret_Exit", "Secret Exit");
    }

    override void WorldTick()
    {
        AutoPlaceMarkers();
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
            Toby_MarkerDatabaseItem item = db.GetItemByClassName(eventAndArgument[1]);
            if (!item) { return; }
            recordContainers[e.Player].AddMarker(eventAndArgument[1], playerActor.pos, item.description);
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

    ui static Toby_MarkerHandler GetInstanceUi()
    {
        return Toby_MarkerHandler(EventHandler.Find("Toby_MarkerHandler"));
    }

    play static Toby_MarkerHandler GetInstancePlay()
    {
        return Toby_MarkerHandler(EventHandler.Find("Toby_MarkerHandler"));
    }

    private void AutoPlaceMarkers()
    {
        int minDistance = 130;
        int minPlacementDistance = minDistance * 2.5;

        for (int j = 0; j < autoMarkerDb.items.Size(); j++)
        {
            ThinkerIterator actorFinder = ThinkerIterator.Create(autoMarkerDb.items[j].targetActorName);
            Actor foundActor;
            while (foundActor = Actor(actorFinder.Next(true)))
            {
                for (int i = 0; i < maxPlayers; i++)
                {
                    PlayerInfo player = players[i];
                    if (!player) { continue; }
                    Actor playerActor = player.mo;
                    if (!playerActor) { continue; }
                    if (!playerActor.IsVisible(foundActor, true)) { continue; }
                    if ((playerActor.pos - foundActor.pos).length() > minDistance) { continue; }

                    if (SimilarMarkerExists(recordContainers[i], j, foundActor, minPlacementDistance)) { continue; }
                    recordContainers[i].AddMarker(autoMarkerDb.items[j].markerActorName, playerActor.pos, autoMarkerDb.items[j].description);
                }
            }
        }
    }

    private bool SimilarMarkerExists(Toby_MarkerRecordContainer recordContainer, int autoMarkerItemIndex, Actor foundActor, int minPlacementDistance)
    {
        for (int k = 0; k < recordContainer.records.Size(); k++)
        {
            Actor markerActor = recordContainer.records[k].markerActor;
            bool classNameMatch = markerActor.GetClassName() == autoMarkerDb.items[autoMarkerItemIndex].markerActorName;
            bool withinMinPlacementDistance = (markerActor.pos - foundActor.pos).Length() < minPlacementDistance;
            if (classNameMatch && withinMinPlacementDistance)
            {
                return true;
            }
        }
        return false;
    }
}
