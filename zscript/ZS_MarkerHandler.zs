class ZS_MarkerHandler : EventHandler
{
	Array<String> whiteList;
	int sequentalMarkerSpawnIndex;
	int lastMarkerId;
	String baseMarkerName;

	override void WorldLoaded (WorldEvent e)
	{
		baseMarkerName = "ZS_Marker_Base";
		sequentalMarkerSpawnIndex = 0;
		lastMarkerId = GetLastMarkerId();
	
		whiteList.push("Toby_Marker_1");
		whiteList.push("Toby_Marker_2");
		whiteList.push("Toby_Marker_3");
		whiteList.push("Toby_Marker_4");
		whiteList.push("Toby_Marker_5");
		whiteList.push("Toby_Marker_6");
		whiteList.push("Toby_Marker_7");
		whiteList.push("Toby_Marker_8");
		whiteList.push("Toby_Marker_9");
		whiteList.push("Toby_Marker_10");
	}

	override void NetworkProcess (ConsoleEvent e)
	{
		PlayerInfo player = players[e.Player];
		if (!player) { return; }
		Actor playerActor = players[e.Player].mo;
		if (!playerActor) { return; }
		int maxRemovalDistance = CVar.GetCVar("zs_em_MaxDistance", player).GetInt();
		Array<String> eventAndArgument;		
		//Sorry, this is dirty, but there were no other way to pass a string as an argument -Proydoha
		e.Name.split(eventAndArgument, ":", TOK_KEEPEMPTY);

		if (eventAndArgument[0] == "ZS_PlaceMarker" && IsMarkerInWhitelist(eventAndArgument[1]))
		{
			PlaceMarker(eventAndArgument[1], playerActor);
		}
		if (eventAndArgument[0] == "ZS_RemoveMarker" && (IsMarkerInWhitelist(eventAndArgument[1]) || eventAndArgument[1] == baseMarkerName))
		{
			RemoveNearestMarkerOfType(eventAndArgument[1], playerActor, maxRemovalDistance);
		}
		if (eventAndArgument[0] == "ZS_RemoveAllMarkersOfType" && IsMarkerInWhitelist(eventAndArgument[1]))
		{
			ThinkerIterator MarkerFinder = ThinkerIterator.Create(eventAndArgument[1]);
			Actor mo;
			while (mo = Actor(MarkerFinder.Next()))
			{
				mo.Destroy();
			}
			DisplayAllMarkersOfTypeRemoved(eventAndArgument[1]);
		}
		if (eventAndArgument[0] == "ZS_RemoveAllMarkers")
		{		
			ThinkerIterator MarkerFinder = ThinkerIterator.Create(baseMarkerName);
			Actor mo;
			while (mo = Actor(MarkerFinder.Next()))
			{
				mo.Destroy();
			}
			S_StartSound("marker/cleared", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
			Console.MidPrint(SmallFont, "Map Markers Cleared");
		}
		if (eventAndArgument[0] == "ZS_PlaceNextMarker")
		{
			int markerArrayPos = Modulo(sequentalMarkerSpawnIndex, whiteList.Size());
			PlaceMarker(whiteList[markerArrayPos], playerActor);
			sequentalMarkerSpawnIndex++;
		}
		if (eventAndArgument[0] == "ZS_RemoveLastMarker")
		{
			ZS_Marker_Base lastMarker = GetLastMarker();			
			if (lastMarker)
			{
				string markerClassName = lastMarker.GetClassName();
				lastMarker.Destroy();
				sequentalMarkerSpawnIndex--;
				PlayUndoSound(markerClassName);
				DisplayMarkerRemovedMessage(markerClassName);
			}			
		}
	}
	
	//Prevents ability to spawn anything except markers with sv_cheats 0 by typing
	//netevent ZS_PlaceMarker:<any actor class> in console -Proydoha
	bool IsMarkerInWhitelist(String markerClassName)
	{
		for (int i = 0; i < whiteList.Size(); i++)
		{
			if (whiteList[i] == markerClassName)
			{
				return true;
			}
		}		
		return false;
	}
	
	void PlaceMarker(string markerClassName, Actor player)
	{
		ZS_Marker_Base mo = ZS_Marker_Base(Actor.Spawn(markerClassName, player.pos));
		mo.markerId = lastMarkerId;
		lastMarkerId++;
		PlayPlaceSound(markerClassName);
		DisplayMarkerPlacedMessage(markerClassName);
	}
	
	void RemoveNearestMarkerOfType(string markerClassName, Actor playerActor, int maxRemovalDistance)
	{
		double minDistance = int.Max;
		double distance;
		
		ThinkerIterator MarkerFinder = ThinkerIterator.Create(markerClassName);
		Actor minDistanceActor;
		Actor mo;
		while (mo = Actor(MarkerFinder.Next()))
		{
			distance = ((playerActor.pos.x, playerActor.pos.y) - (mo.pos.x, mo.pos.y)).length();
			if (distance < minDistance)
			{
				minDistance = distance;
				minDistanceActor = mo;
			}
		}
		if (minDistanceActor && (maxRemovalDistance == 0 || minDistance < maxRemovalDistance))
		{
			string mClassName = minDistanceActor.GetClassName();
			minDistanceActor.Destroy();
			PlayUndoSound(mClassName);
			DisplayMarkerRemovedMessage(mClassName);
		}
	}
	
	void PlayUndoSound(string markerClassName)
	{
		if (markerClassName == "Toby_Marker_1")
		{
			S_StartSound("marker/undo1", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_2")
		{
			S_StartSound("marker/undo2", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_3")
		{
			S_StartSound("marker/undo3", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_4")
		{
			S_StartSound("marker/undo4", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_5")
		{
			S_StartSound("marker/undo5", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_6")
		{
			S_StartSound("marker/undo6", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_7")
		{
			S_StartSound("marker/undo7", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_8")
		{
			S_StartSound("marker/undo8", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_9")
		{
			S_StartSound("marker/undo9", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_10")
		{
			S_StartSound("marker/undo10", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
	}
	
	void PlayPlaceSound(string markerClassName)
	{
		if (markerClassName == "Toby_Marker_1")
		{
			S_StartSound("marker/marker1", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_2")
		{
			S_StartSound("marker/marker2", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_3")
		{
			S_StartSound("marker/marker3", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_4")
		{
			S_StartSound("marker/marker4", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_5")
		{
			S_StartSound("marker/marker5", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_6")
		{
			S_StartSound("marker/marker6", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_7")
		{
			S_StartSound("marker/marker7", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_8")
		{
			S_StartSound("marker/marker8", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_9")
		{
			S_StartSound("marker/marker9", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
		if (markerClassName == "Toby_Marker_10")
		{
			S_StartSound("marker/marker10", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
		}
	}
	
	void DisplayMarkerPlacedMessage(string markerClassName)
	{
		if (markerClassName == "Toby_Marker_1")
		{
			Console.MidPrint(SmallFont, "Marker 1 Placed");
		}
		if (markerClassName == "Toby_Marker_2")
		{
			Console.MidPrint(SmallFont, "Marker 2 Placed");
		}
		if (markerClassName == "Toby_Marker_3")
		{
			Console.MidPrint(SmallFont, "Marker 3 Placed");
		}
		if (markerClassName == "Toby_Marker_4")
		{
			Console.MidPrint(SmallFont, "Marker 4 Placed");
		}
		if (markerClassName == "Toby_Marker_5")
		{
			Console.MidPrint(SmallFont, "Marker 5 Placed");
		}
		if (markerClassName == "Toby_Marker_6")
		{
			Console.MidPrint(SmallFont, "Marker 6 Placed");
		}
		if (markerClassName == "Toby_Marker_7")
		{
			Console.MidPrint(SmallFont, "Marker 7 Placed");
		}
		if (markerClassName == "Toby_Marker_8")
		{
			Console.MidPrint(SmallFont, "Marker 8 Placed");
		}
		if (markerClassName == "Toby_Marker_9")
		{
			Console.MidPrint(SmallFont, "Marker 9 Placed");
		}
		if (markerClassName == "Toby_Marker_10")
		{
			Console.MidPrint(SmallFont, "Marker 10 Placed");
		}
	}
	
	void DisplayMarkerRemovedMessage(string markerClassName)
	{
		if (markerClassName == "Toby_Marker_1")
		{
			Console.MidPrint(SmallFont, "Marker 1 Removed");
		}
		if (markerClassName == "Toby_Marker_2")
		{
			Console.MidPrint(SmallFont, "Marker 2 Removed");
		}
		if (markerClassName == "Toby_Marker_3")
		{
			Console.MidPrint(SmallFont, "Marker 3 Removed");
		}
		if (markerClassName == "Toby_Marker_4")
		{
			Console.MidPrint(SmallFont, "Marker 4 Removed");
		}
		if (markerClassName == "Toby_Marker_5")
		{
			Console.MidPrint(SmallFont, "Marker 5 Removed");
		}
		if (markerClassName == "Toby_Marker_6")
		{
			Console.MidPrint(SmallFont, "Marker 6 Removed");
		}
		if (markerClassName == "Toby_Marker_7")
		{
			Console.MidPrint(SmallFont, "Marker 7 Removed");
		}
		if (markerClassName == "Toby_Marker_8")
		{
			Console.MidPrint(SmallFont, "Marker 8 Removed");
		}
		if (markerClassName == "Toby_Marker_9")
		{
			Console.MidPrint(SmallFont, "Marker 9 Removed");
		}
		if (markerClassName == "Toby_Marker_10")
		{
			Console.MidPrint(SmallFont, "Marker 10 Removed");
		}
	}
	
	void DisplayAllMarkersOfTypeRemoved(string markerClassName)
	{
		if (markerClassName == "Toby_Marker_1")
		{
			Console.MidPrint(SmallFont, "All 1 marker removed");
		}
		if (markerClassName == "Toby_Marker_2")
		{
			Console.MidPrint(SmallFont, "All 2 markers removed");
		}
		if (markerClassName == "Toby_Marker_3")
		{
			Console.MidPrint(SmallFont, "All 3 markers removed");
		}
		if (markerClassName == "Toby_Marker_4")
		{
			Console.MidPrint(SmallFont, "All 4 markers removed");
		}
		if (markerClassName == "Toby_Marker_5")
		{
			Console.MidPrint(SmallFont, "All 5 markers removed");
		}
		if (markerClassName == "Toby_Marker_6")
		{
			Console.MidPrint(SmallFont, "All 6 markers removed");
		}
		if (markerClassName == "Toby_Marker_7")
		{
			Console.MidPrint(SmallFont, "All 7 markers removed");
		}
		if (markerClassName == "Toby_Marker_8")
		{
			Console.MidPrint(SmallFont, "All 8 markers removed");
		}
		if (markerClassName == "Toby_Marker_9")
		{
			Console.MidPrint(SmallFont, "All 9 markers removed");
		}
		if (markerClassName == "Toby_Marker_10")
		{
			Console.MidPrint(SmallFont, "All 10 markers removed");
		}
	}
	
	ZS_Marker_Base GetLastMarker()
	{
		ZS_Marker_Base lastMarker = null;
		int lastMarkerId = -1;
		ThinkerIterator MarkerFinder = ThinkerIterator.Create(baseMarkerName);
		ZS_Marker_Base mo;
		while (mo = ZS_Marker_Base(MarkerFinder.Next()))
		{			
			if (mo.markerId > lastMarkerId)
			{
				lastMarkerId = mo.markerId;
				lastMarker = mo;
			}
		}
		
		return lastMarker;
	}
	
	int GetLastMarkerId()
	{
		int lastMarkerId = 0;
		ZS_Marker_Base lastMarker = GetLastMarker();
		if (lastMarker)
		{			
			lastMarkerId = lastMarker.markerId;
		}
		return lastMarkerId;
	}
	
	int Modulo(int a, int b)
	{
		return int(((a % b) + b) % b);
	}
}