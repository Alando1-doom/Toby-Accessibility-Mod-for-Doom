//Original ACS implementation by Jarewill

class Toby_PlayerStatusCheckStaticHandler: StaticEventHandler
{
    ui bool isNotFirstRun;

    ui Toby_SoundBindingsLoaderStaticHandler bindings;
    Array<Toby_ChessboardCoordsChecker> chessboardCoords;
    int maxPlayers;

    override void OnRegister()
    {
        Toby_Logger.Message("Toby_PlayerStatusCheckStaticHandler registered!", "Toby_Developer");
        maxPlayers = 8;
    }

    override void PlayerSpawned(PlayerEvent e)
    {
        if (level.mapName == "TITLEMAP") { return; }
        PlayerInfo player = players[e.PlayerNumber];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }
        bool enabledForPlayer = Cvar.GetCvar("Toby_ChessboardCoordinates_EnabledByDefault", player).GetBool();
        chessboardCoords[e.PlayerNumber].enabled = enabledForPlayer;
    }

    override void WorldLoaded(WorldEvent e)
    {
        maxPlayers = 8;
        for (int i = 0; i < maxPlayers; i++)
        {
            chessboardCoords.push(Toby_ChessboardCoordsChecker.Create(i));
        }
    }

    override void UITick()
    {
        if (!isNotFirstRun)
        {
            isNotFirstRun = true;
            bindings = Toby_SoundBindingsLoaderStaticHandler.GetInstance();
        }
        if (chessboardCoords[consoleplayer])
        {
            chessboardCoords[consoleplayer].AnnounceUpdates();
        }
    }

    override void WorldTick()
    {
        for (int i = 0; i < maxPlayers; i++)
        {
            chessboardCoords[i].Update();
        }
    }

    override void InterfaceProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        if (!player.mo) { return; }

        int narrationOutputType = CVar.FindCvar("Toby_NarrationOutputType").GetInt();

        if (e.Name == "Toby_CheckCoordinatesInterface")
        {
            if (narrationOutputType == TNOT_CONSOLE)
            {
                Toby_CoordinateChecker.CheckCoordinatesTextOnly(player);
            }
            else
            {
                Toby_CoordinateChecker.CheckCoordinates(player);
            }
        }
        if (e.Name == "Toby_CheckHealthInterface")
        {
            if (CVar.FindCvar("Toby_UseLegacyHealthChecker").GetBool())
            {
                Toby_HealthChecker.CheckHealthLegacy(player);
            }
            else
            {
                if (narrationOutputType == TNOT_CONSOLE)
                {
                    Toby_HealthChecker.CheckHealthTextOnly(player);
                }
                else
                {
                    Toby_HealthChecker.CheckHealth(player);
                }
            }
        }
        if (e.Name == "Toby_CheckArmorInterface")
        {
            if (narrationOutputType == TNOT_CONSOLE)
            {
                Toby_ArmorChecker.CheckArmorTextOnly(player);
            }
            else
            {
                Toby_ArmorChecker.CheckArmor(player, bindings.armorSoundBindingsContainer);
            }
        }
        if (e.Name == "Toby_CheckAmmoInterface")
        {
            if (CVar.FindCvar("Toby_UseLegacyAmmoChecker").GetBool())
            {
                Toby_AmmoChecker.CheckAmmoLegacy(player);
            }
            else
            {
                if (narrationOutputType == TNOT_CONSOLE)
                {
                    Toby_AmmoChecker.CheckAmmoTextOnly(player);
                }
                else
                {
                    Toby_AmmoChecker.CheckAmmo(player, bindings.weaponsSoundBindingsContainer, bindings.ammoSoundBindingsContainer);
                }
            }
        }
        if (e.Name == "Toby_CheckKeysInterface")
        {
            if (narrationOutputType == TNOT_CONSOLE)
            {
                Toby_KeyChecker.CheckKeysTextOnly(player);
            }
            else
            {
                Toby_KeyChecker.CheckKeys(player, bindings.keysSoundBindingsContainer);
            }
        }
        if (e.Name == "Toby_CheckCurrentItemInterface")
        {
            if (narrationOutputType == TNOT_CONSOLE)
            {
                Toby_CurrentItemChecker.CheckCurrentItemTextOnly(player);
            }
            else
            {
                Toby_CurrentItemChecker.CheckCurrentItem(player, bindings.itemsSoundBindingsContainer);
            }
        }
        if (e.Name == "Toby_CheckLevelStatsInterface")
        {
            if (narrationOutputType == TNOT_CONSOLE)
            {
                Toby_LevelStatsChecker.CheckLevelStatsTextOnly();
            }
            else
            {
                Toby_LevelStatsChecker.CheckLevelStats();
            }
        }
        if (e.Name == "Toby_ChessboardCoordinatesToggleInterface")
        {
            if (narrationOutputType == TNOT_CONSOLE)
            {
                if (chessboardCoords[consoleplayer].enabled)
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
                if (chessboardCoords[consoleplayer].enabled)
                {
                    // enabled
                }
                else
                {
                    // disabled
                }
            }
        }
    }

    //Is this stupid?
    override void NetworkProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[e.Player];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        Array<string> eventAndArguments;
        e.Name.split(eventAndArguments, ":", TOK_KEEPEMPTY);
        if (eventAndArguments.Size() < 1) { return; }
        string event = eventAndArguments[0];
        Array<string> args;
        if (eventAndArguments.Size() > 1)
        {
            for (int i = 1; i < eventAndArguments.Size(); i++)
            {
                args.push(eventAndArguments[i]);
            }
        }

        if (event == "Toby_CheckCoordinates")
        {
            EventHandler.SendInterfaceEvent(e.Player, "Toby_CheckCoordinatesInterface");
        }
        if (event == "Toby_CheckHealth")
        {
            EventHandler.SendInterfaceEvent(e.Player, "Toby_CheckHealthInterface");
        }
        if (event == "Toby_CheckArmor")
        {
            EventHandler.SendInterfaceEvent(e.Player, "Toby_CheckArmorInterface");
        }
        if (event == "Toby_CheckAmmo")
        {
            EventHandler.SendInterfaceEvent(e.Player, "Toby_CheckAmmoInterface");
        }
        if (event == "Toby_CheckKeys")
        {
            EventHandler.SendInterfaceEvent(e.Player, "Toby_CheckKeysInterface");
        }
        if (event == "Toby_CheckCurrentItem")
        {
            EventHandler.SendInterfaceEvent(e.Player, "Toby_CheckCurrentItemInterface");
        }
        if (event == "Toby_CheckLevelStats")
        {
            EventHandler.SendInterfaceEvent(e.Player, "Toby_CheckLevelStatsInterface");
        }
        if (event == "Toby_ChessboardCoordinatesToggle")
        {
            if (!chessboardCoords[e.Player]) { return; }
            chessboardCoords[e.Player].enabled = !chessboardCoords[e.Player].enabled;
            EventHandler.SendInterfaceEvent(e.Player, "Toby_ChessboardCoordinatesToggleInterface");
        }
        if (event == "Toby_WarpToChessboard")
        {
            if (!chessboardCoords[e.Player]) { return; }
            if (args.Size() < 1 && args.Size() > 1) { return; }
            vector3 chessboardCoords = chessboardCoords[e.Player].ChessboardToWorldCoordinates(args[0]);
            chessboardCoords.z = playerActor.pos.z;
            playerActor.SetOrigin(chessboardCoords, true);
        }
    }
}
