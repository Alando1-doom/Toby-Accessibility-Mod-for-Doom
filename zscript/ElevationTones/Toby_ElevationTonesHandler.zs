class Toby_ElevationTonesHandler : EventHandler
{
    Array<bool> enabled;
    Array<double> previousFloorHeight;
    Array<int> previousSector;
    Array<int> previousSectorHeight;

    int maxPlayers;
    double minHeight;
    double maxHeight;

    Array<string> soundsToPlay;

    override void OnRegister()
    {
        Toby_Logger.Message("Toby_ElevationTonesHandler registered!", "Toby_Developer");
    }

    override void WorldLoaded(WorldEvent e)
    {
        maxPlayers = 8;
        minHeight = int.Max;
        maxHeight = int.Min;
        int i = 0;
        for (i = 0; i < maxPlayers; i++)
        {
            enabled.push(true);
            previousFloorHeight.push(int.Min);
            previousSector.push(0);
            previousSectorHeight.push(0);
        }

        for (int i = 0; i < level.sectors.Size(); i++)
        {
            Sector s = level.sectors[i];
            if (s.CenterFloor() < minHeight)
            {
                minHeight = s.CenterFloor();
            }
            if (s.CenterFloor() > maxHeight)
            {
                maxHeight = s.CenterFloor();
            }
        }

        soundsToPlay.push("toby/elevation/000");
        soundsToPlay.push("toby/elevation/001");
        soundsToPlay.push("toby/elevation/002");
        soundsToPlay.push("toby/elevation/003");
        soundsToPlay.push("toby/elevation/004");
        soundsToPlay.push("toby/elevation/005");
        soundsToPlay.push("toby/elevation/006");
        soundsToPlay.push("toby/elevation/007");
        soundsToPlay.push("toby/elevation/008");
        soundsToPlay.push("toby/elevation/009");
        soundsToPlay.push("toby/elevation/010");
        soundsToPlay.push("toby/elevation/011");
        soundsToPlay.push("toby/elevation/012");
        soundsToPlay.push("toby/elevation/013");
        soundsToPlay.push("toby/elevation/014");
    }

    override void WorldTick()
    {
        for (int i = 0; i < maxPlayers; i++)
        {
            if (!enabled[i]) { continue; }
            Actor playerActor = players[i].mo;
            if (!playerActor) { continue; }

            if (players[i].jumptics != 0 || playerActor.vel.z != 0) { continue; }
            if (playerActor.pos.z == previousFloorHeight[i]) { continue; }

            if (previousFloorHeight[i] != int.Min)
            {
                int previousSoundIndex = GetIndex(previousFloorHeight[i], minHeight, maxHeight, soundsToPlay.Size());
                int soundIndex = GetIndex(playerActor.pos.z, minHeight, maxHeight, soundsToPlay.Size());
                EventHandler.SendInterfaceEvent(i, "Toby_ElevationTone:"..previousSoundIndex..":"..soundIndex);
            }
            previousFloorHeight[i] = playerActor.pos.z;
            previousSector[i] = playerActor.curSector.Index();
            previousSectorHeight[i] = playerActor.curSector.CenterFloor();
        }
    }

    override void InterfaceProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }

        Array<String> eventAndArgument;
        e.Name.split(eventAndArgument, ":", TOK_KEEPEMPTY);
        if (eventAndArgument[0] != "Toby_ElevationTone") { return; }
        Toby_SoundQueueStaticHandler.Clear();
        int previousSound = eventAndArgument[1].ToInt();
        int currentSound = eventAndArgument[2].ToInt();
        Toby_SoundQueueStaticHandler.AddSound(soundsToPlay[previousSound], -1);
        Toby_SoundQueueStaticHandler.AddSound(soundsToPlay[currentSound], -1);
        Toby_SoundQueueStaticHandler.PlayQueue(0);

    }

    int GetIndex(double value, double min, double max, int size)
    {
        double clampedValue = Max(min, Min(max, value));
        double relativePosition = (clampedValue - min) / (max - min);
        int index = Floor(relativePosition * double(size));
        return Min(index, size - 1);
    }
}
