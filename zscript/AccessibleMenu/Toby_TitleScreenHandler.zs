class Toby_TitleScreenHandler : EventHandler
{
    string levelChecksum;

    override void WorldLoaded(WorldEvent e)
    {
        levelChecksum = level.GetChecksum();
        Toby_Logger.Message("Map name: "..level.mapName, "Toby_Developer_MapInformation");
        Toby_Logger.Message("Level name: "..level.levelName, "Toby_Developer_MapInformation");
        Toby_Logger.Message("Map checksum: "..levelChecksum, "Toby_Developer_MapInformation");
    }

    override void RenderOverlay(RenderEvent e)
    {
        string titlemapChecksum = "8596787f9daad2bf1a1b129f6d724619";
        if (levelChecksum != titlemapChecksum) { return; }
        TextureId titlePic = TexMan.CheckForTexture("TITLEPIC");
        if (!titlepic.IsValid())
        {
            titlePic = TexMan.CheckForTexture("TITLE");
        }
        int titlePicWidth;
        int titlePicHeight;
        [titlePicWidth, titlePicHeight] = TexMan.GetSize(titlePic);
        int screenWidth = Screen.GetWidth();
        int screenHeight = Screen.GetHeight();
        int posX = 0;
        int posY = 0;
        int virtualWidth;
        int virtualHeight;
        float ratio;
        if (titlePicHeight < screenHeight)
        {
            virtualHeight = screenHeight;
            ratio = float(screenHeight) / float(titlePicHeight);
            virtualWidth = titlePicWidth * ratio;
        }
        else
        {
            virtualWidth = screenWidth;
            ratio = float(screenWidth) / float(titlePicWidth);
            virtualHeight = titlePicHeight * ratio;
        }

        posX = (screenWidth - virtualWidth) / 2;
        posY = (screenHeight - virtualHeight) / 2;
        Screen.DrawTexture(titlePic, false, posX, posY, DTA_KeepRatio, false, DTA_DESTWIDTH, virtualWidth, DTA_DESTHEIGHT, virtualHeight);
    }
}
