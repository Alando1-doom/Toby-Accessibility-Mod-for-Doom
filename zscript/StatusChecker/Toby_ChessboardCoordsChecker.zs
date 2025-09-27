class Toby_ChessboardCoordsChecker
{
    int playerNum;

    bool enabled;
    bool toggleTick;

    bool regionUpdated;
    bool zoneUpdated;
    bool cellUpdated;

    int narrationType;

    int cellSize;
    int zoneSize;
    int regionSize;
    int offset;
    int charOffset;

    int regionX;
    int regionY;

    int zoneX;
    int zoneY;

    int cellX;
    int cellY;

    int oldRegionX;
    int oldRegionY;

    int oldZoneX;
    int oldZoneY;

    int oldCellX;
    int oldCellY;

    static Toby_ChessboardCoordsChecker Create(int playerNum)
    {
        Toby_ChessboardCoordsChecker checker = new("Toby_ChessboardCoordsChecker");
        checker.enabled = false;
        checker.regionUpdated = false;
        checker.zoneUpdated = false;
        checker.cellUpdated = false;
        checker.toggleTick = false;
        checker.playerNum = playerNum;
        checker.narrationType = 0;

        checker.cellSize = 256; // 2^8 - 16 cells in a zone - A1 : H8
        checker.zoneSize = 2048; // 2^11 - 16 zones per region - A1 : H8
        checker.regionSize = 16384; // 2^14 - gives us 4 big regions A1 : D4
        checker.offset = 32768; // 2^15 - Half of a map. Doom maps are 2^16 = 65536
        checker.charOffset = 65; // English alphabet in ASCII starts at 65

        return checker;
    }

    void Update()
    {
        PlayerInfo player = players[playerNum];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        regionUpdated = false;
        zoneUpdated = false;
        cellUpdated = false;

        double offsetPosX = playerActor.pos.x + offset;
        double offsetPosY = playerActor.pos.y + offset;

        // Y coordinate is offset by 1 for human-readability. Shifts cells/zones from A0:H7 to A1:H8. Same for regions - A0:D3 to A1:D4.
        regionX = (int)(offsetPosX / regionSize);
        regionY = (int)(offsetPosY / regionSize) + 1;

        zoneX = (int)(Toby_Math.Modulo(offsetPosX, regionSize) / zoneSize);
        zoneY = (int)(Toby_Math.Modulo(offsetPosY, regionSize) / zoneSize) + 1;

        cellX = (int)(Toby_Math.Modulo(offsetPosX, zoneSize) / cellSize);
        cellY = (int)(Toby_Math.Modulo(offsetPosY, zoneSize) / cellSize) + 1;

        if (oldRegionX != regionX || oldRegionY != regionY)
        {
            regionUpdated = true;
        }
        if (oldZoneX != zoneX || oldZoneY != zoneY)
        {
            zoneUpdated = true;
        }
        if (oldCellX != cellX || oldCellY != cellY)
        {
            cellUpdated = true;
        }

        oldRegionX = regionX;
        oldRegionY = regionY;

        oldZoneX = zoneX;
        oldZoneY = zoneY;

        oldCellX = cellX;
        oldCellY = cellY;
    }

    ui void AnnounceUpdates()
    {
        if (!enabled) { return; }
        if (toggleTick)
        {
            toggleTick = false;
            return;
        }
        if (level.MapTime <= 5) { return; } //Prevents from going off when map just started and is on by default

        if (narrationType == TNOT_CONSOLE)
        {
            AnnounceUpdatesTextOnly();
        }
        else
        {
            AnnounceUpdatesVoiced();
        }
    }

    ui void AnnounceUpdatesVoiced()
    {
        if (!(regionUpdated || zoneUpdated || cellUpdated)) { return; }
        Toby_StringToSoundQueue stringQueueBuilder = Toby_StringToSoundQueue.Create();
        if (regionUpdated)
        {
            stringQueueBuilder.Reset();
            Toby_SoundQueueStaticHandler.AddSound("stats/chessboardcoords/region", -1);
            Toby_SoundQueueStaticHandler.AddQueue(stringQueueBuilder.CreateQueueFromText(String.format("%c", regionX + charOffset) .. regionY));
        }
        if (zoneUpdated)
        {
            stringQueueBuilder.Reset();
            Toby_SoundQueueStaticHandler.AddSound("stats/chessboardcoords/zone", -1);
            Toby_SoundQueueStaticHandler.AddQueue(stringQueueBuilder.CreateQueueFromText(String.format("%c", zoneX + charOffset) .. zoneY));
        }
        if (cellUpdated)
        {
            stringQueueBuilder.Reset();
            if (zoneUpdated || regionUpdated)
            {
                Toby_SoundQueueStaticHandler.AddSound("stats/chessboardcoords/cell", -1);
            }
            Toby_SoundQueueStaticHandler.AddQueue(stringQueueBuilder.CreateQueueFromText(String.format("%c", cellX + charOffset) .. cellY));
        }

        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui void AnnounceUpdatesTextOnly()
    {
        string output = "";
        if (regionUpdated)
        {
            output = output .. "Region: " .. String.format("%c", regionX + charOffset) .. regionY .. " ; ";
        }
        if (zoneUpdated)
        {
            output = output .. "Zone: " .. String.format("%c", zoneX + charOffset) .. zoneY .. " ; ";
        }
        if (cellUpdated)
        {
            if (zoneUpdated || regionUpdated)
            {
                output = output .. "Cell: ";
            }
            output = output .. String.format("%c", cellX + charOffset) .. cellY;
        }
        if (regionUpdated || zoneUpdated || cellUpdated)
        {
            Toby_Logger.ConsoleOutputModeMessage(output);
        }
    }

    ui void AnnounceCurrent()
    {
        Toby_StringToSoundQueue stringQueueBuilder = Toby_StringToSoundQueue.Create();
        stringQueueBuilder.Reset();
        Toby_SoundQueueStaticHandler.AddSound("stats/chessboardcoords/region", -1);
        Toby_SoundQueueStaticHandler.AddQueue(stringQueueBuilder.CreateQueueFromText(String.format("%c", regionX + charOffset) .. regionY));
        stringQueueBuilder.Reset();
        Toby_SoundQueueStaticHandler.AddSound("stats/chessboardcoords/zone", -1);
        Toby_SoundQueueStaticHandler.AddQueue(stringQueueBuilder.CreateQueueFromText(String.format("%c", zoneX + charOffset) .. zoneY));
        stringQueueBuilder.Reset();
        Toby_SoundQueueStaticHandler.AddSound("stats/chessboardcoords/cell", -1);
        Toby_SoundQueueStaticHandler.AddQueue(stringQueueBuilder.CreateQueueFromText(String.format("%c", cellX + charOffset) .. cellY));
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui void AnnounceCurrentTextOnly()
    {
        string output = "";
        output = output .. "Region: " .. String.format("%c", regionX + charOffset) .. regionY .. " ; ";
        output = output .. "Zone: " .. String.format("%c", zoneX + charOffset) .. zoneY .. " ; ";
        output = output .. "Cell: ";
        output = output .. String.format("%c", cellX + charOffset) .. cellY;
        Toby_Logger.ConsoleOutputModeMessage(output);
    }

    vector3 ChessboardToWorldCoordinates(string chessboardCoords)
    {
        int regionXParsed = chessboardCoords.ByteAt(0) - charOffset;
        int zoneXParsed   = chessboardCoords.ByteAt(2) - charOffset;
        int cellXParsed   = chessboardCoords.ByteAt(4) - charOffset;

        int regionYParsed = chessboardCoords.CharAt(1).ToInt() - 1;
        int zoneYParsed   = chessboardCoords.CharAt(3).ToInt() - 1;
        int cellYParsed   = chessboardCoords.CharAt(5).ToInt() - 1;

        double offsetPosX =
            regionXParsed * regionSize +
            zoneXParsed * zoneSize +
            cellXParsed * cellSize +
            cellSize / 2.0;

        double offsetPosY =
            regionYParsed * regionSize +
            zoneYParsed * zoneSize +
            cellYParsed * cellSize +
            cellSize / 2.0;

        double globalX = offsetPosX - offset;
        double globalY = offsetPosY - offset;

        return (globalX, globalY, 0);
    }

    ui static void ChessboardCoordsToggleByOutputType(int narrationOutputType, bool enabled)
    {
        if (narrationOutputType == TNOT_CONSOLE)
        {
            if (enabled)
            {
                Toby_Logger.ConsoleOutputModeMessage("Chessboard coordinates enabled");
            }
            else
            {
                Toby_Logger.ConsoleOutputModeMessage("Chessboard coordinates disabled");
            }
        }
        else
        {
            if (enabled)
            {
                Toby_SoundQueueStaticHandler.AddSound("stats/chessboardcoords/enabled", -1);
            }
            else
            {
                Toby_SoundQueueStaticHandler.AddSound("stats/chessboardcoords/disabled", -1);
            }
            Toby_SoundQueueStaticHandler.PlayQueue(0);
        }
    }

    ui void CheckChessboardCoordsByOutputType(int narrationOutputType)
    {
        if (narrationOutputType == TNOT_CONSOLE)
        {
            AnnounceCurrentTextOnly();
        }
        else
        {
            AnnounceCurrent();
        }
    }
}
