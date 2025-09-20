class Toby_ChessboardCoordsChecker
{
    int playerNum;

    bool enabled;

    bool regionUpdated;
    bool zoneUpdated;
    bool cellUpdated;

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
        checker.playerNum = playerNum;

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
            output = output .. "Cell: " .. String.format("%c", cellX + charOffset) .. cellY;
        }
        if (regionUpdated || zoneUpdated || cellUpdated)
        {
            Toby_Logger.ConsoleOutputModeMessage(output);
        }
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
}
