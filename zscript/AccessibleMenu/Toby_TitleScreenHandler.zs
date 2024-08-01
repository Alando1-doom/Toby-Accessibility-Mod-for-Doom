class Toby_TitleScreenHandler : EventHandler
{
    string levelChecksum;
    string titlemapChecksum;
    ui int menuTextureSwitchTimer;
    ui int titlePicTime;
    ui int creditPicTime;
    ui bool showTitlePic;
    ui bool isNotFirstRun;

    override void UITick()
    {
        if (!isNotFirstRun)
        {
            isNotFirstRun = true;
            showTitlePic = true;
            titlePicTime = 15000 / 35;
            creditPicTime = 20000 / 35;
            menuTextureSwitchTimer = titlePicTime;
        }
        HandleMenuTextureTimers();
    }

    override void OnRegister()
    {
        titlemapChecksum = "8596787f9daad2bf1a1b129f6d724619";
    }

    override void WorldLoaded(WorldEvent e)
    {
        levelChecksum = level.GetChecksum();
        Toby_Logger.Message("Map name: "..level.mapName, "Toby_Developer_MapInformation");
        Toby_Logger.Message("Level name: "..level.levelName, "Toby_Developer_MapInformation");
        Toby_Logger.Message("Map checksum: "..levelChecksum, "Toby_Developer_MapInformation");

        if (levelChecksum != titlemapChecksum) { return; }
        if (isUltimateDoom())
        {
            S_ChangeMusic("D_INTRO");
        }
        else
        {
            S_ChangeMusic("D_DM2TTL");
        }
    }

    override void RenderOverlay(RenderEvent e)
    {
        if (levelChecksum != titlemapChecksum) { return; }
        TextureId titlePic = TexMan.CheckForTexture("TITLEPIC");
        TextureId creditPic = TexMan.CheckForTexture("CREDIT");
        if (!titlepic.IsValid())
        {
            titlePic = TexMan.CheckForTexture("TITLE");
        }
        if (showTitlePic)
        {
            DrawMenuTexture(titlePic);
        }
        else
        {
            DrawMenuTexture(creditPic);
        }
    }

    ui void HandleMenuTextureTimers()
    {
        menuTextureSwitchTimer--;
        if (menuTextureSwitchTimer <= 0)
        {
            if (showTitlePic)
            {
                menuTextureSwitchTimer = creditPicTime;
            }
            else
            {
                menuTextureSwitchTimer = titlePicTime;
            }
            showTitlePic = !showTitlePic;
        }
    }

    ui void DrawMenuTexture(TextureId texture)
    {
        int textureWidth;
        int textureHeight;
        [textureWidth, textureHeight] = TexMan.GetSize(texture);
        int screenWidth = Screen.GetWidth();
        int screenHeight = Screen.GetHeight();
        int posX = 0;
        int posY = 0;
        int virtualWidth;
        int virtualHeight;
        float ratio;
        if (textureHeight < screenHeight)
        {
            virtualHeight = screenHeight;
            ratio = float(screenHeight) / float(textureHeight);
            virtualWidth = textureWidth * ratio;
        }
        else
        {
            virtualWidth = screenWidth;
            ratio = float(screenWidth) / float(textureWidth);
            virtualHeight = textureHeight * ratio;
        }

        posX = (screenWidth - virtualWidth) / 2;
        posY = (screenHeight - virtualHeight) / 2;
        Screen.DrawTexture(texture, false, posX, posY, DTA_KeepRatio, false, DTA_DESTWIDTH, virtualWidth, DTA_DESTHEIGHT, virtualHeight);
    }

    //Based on this thread: https://forum.zdoom.org/viewtopic.php?p=1150314
    //I have no idea how it works
    bool isUltimateDoom()
    {
        if (
            Wads.CheckNumForName("E1M1", 0) != -1 &&
            Wads.CheckNumForName("E2M1", 0) != -1 &&
            Wads.CheckNumForName("E2M2", 0) != -1 &&
            Wads.CheckNumForName("E2M3", 0) != -1 &&
            Wads.CheckNumForName("E2M4", 0) != -1 &&
            Wads.CheckNumForName("E2M5", 0) != -1 &&
            Wads.CheckNumForName("E2M6", 0) != -1 &&
            Wads.CheckNumForName("E2M7", 0) != -1 &&
            Wads.CheckNumForName("E2M8", 0) != -1 &&
            Wads.CheckNumForName("E2M9", 0) != -1 &&
            Wads.CheckNumForName("E3M1", 0) != -1 &&
            Wads.CheckNumForName("E3M2", 0) != -1 &&
            Wads.CheckNumForName("E3M3", 0) != -1 &&
            Wads.CheckNumForName("E3M4", 0) != -1 &&
            Wads.CheckNumForName("E3M5", 0) != -1 &&
            Wads.CheckNumForName("E3M6", 0) != -1 &&
            Wads.CheckNumForName("E3M7", 0) != -1 &&
            Wads.CheckNumForName("E3M8", 0) != -1 &&
            Wads.CheckNumForName("E3M9", 0) != -1 &&
            Wads.CheckNumForName("DPHOOF", 0) != -1 &&
            Wads.CheckNumForName("E4M2", 0) != -1
        )
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}
