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

        if (chessboardCoords.Size() < maxPlayers) { return; }
        chessboardCoords[e.PlayerNumber].Init(e.PlayerNumber);
    }

    override void WorldLoaded(WorldEvent e)
    {
        maxPlayers = 8;
        for (int i = 0; i < maxPlayers; i++)
        {
            chessboardCoords.push(Toby_ChessboardCoordsChecker.Create(i));
            chessboardCoords[i].Init(i);
        }
    }

    override void UITick()
    {
        if (!isNotFirstRun)
        {
            isNotFirstRun = true;
            bindings = Toby_SoundBindingsLoaderStaticHandler.GetInstance();
        }
        if (chessboardCoords.Size() < maxPlayers) { return; }
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
            Toby_CoordinateChecker.CheckCoordinatesByOutputType(narrationOutputType, player);
        }
        if (e.Name == "Toby_CheckHealthInterface")
        {
            Toby_HealthChecker.CheckHealthByOutputType(narrationOutputType, player);
        }
        if (e.Name == "Toby_CheckArmorInterface")
        {
            Toby_ArmorChecker.CheckArmorByOutputType(narrationOutputType, player, bindings.armorSoundBindingsContainer);
        }
        if (e.Name == "Toby_CheckAmmoInterface")
        {
            Toby_AmmoChecker.CheckAmmoByOutputType(narrationOutputType, player, bindings.weaponsSoundBindingsContainer, bindings.ammoSoundBindingsContainer);
        }
        if (e.Name == "Toby_CheckKeysInterface")
        {
            Toby_KeyChecker.CheckKeysByOutputType(narrationOutputType, player, bindings.keysSoundBindingsContainer);
        }
        if (e.Name == "Toby_CheckCurrentItemInterface")
        {
            Toby_CurrentItemChecker.CheckCurrentItemByOutputType(narrationOutputType, player, bindings.itemsSoundBindingsContainer);
        }
        if (e.Name == "Toby_CheckLevelStatsInterface")
        {
            Toby_LevelStatsChecker.CheckLevelStatsByOutputType(narrationOutputType);
        }
        if (e.Name == "Toby_ChessboardCoordinatesToggleInterface")
        {
            Toby_ChessboardCoordsChecker.ChessboardCoordsToggleByOutputType(narrationOutputType, chessboardCoords[consoleplayer].enabled);
        }
        if (e.Name == "Toby_NoRadiusDmgToggleInterface")
        {
            NoRadiusDmgToggleByOutputType(narrationOutputType, player.mo.bNORADIUSDMG);
        }
        if (e.Name == "Toby_CheckChessboardCoordinatesInterface")
        {
            chessboardCoords[consoleplayer].CheckChessboardCoordsByOutputType(narrationOutputType);
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
            chessboardCoords[e.Player].toggleTick = true;
            EventHandler.SendInterfaceEvent(e.Player, "Toby_ChessboardCoordinatesToggleInterface");
        }
        if (event == "Toby_NoRadiusDmgToggle")
        {
            playerActor.bNORADIUSDMG = !playerActor.bNORADIUSDMG;
            EventHandler.SendInterfaceEvent(e.Player, "Toby_NoRadiusDmgToggleInterface");
        }
        if (event == "Toby_WarpToChessboard")
        {
            if (!chessboardCoords[e.Player]) { return; }
            if (args.Size() < 1 && args.Size() > 1) { return; }
            vector3 chessboardCoords = chessboardCoords[e.Player].ChessboardToWorldCoordinates(args[0]);
            chessboardCoords.z = playerActor.pos.z;
            playerActor.SetOrigin(chessboardCoords, true);
        }
        if (event == "Toby_CheckChessboardCoordinates")
        {
            EventHandler.SendInterfaceEvent(e.Player, "Toby_CheckChessboardCoordinatesInterface");
        }
    }

        ui void NoRadiusDmgToggleByOutputType(int narrationOutputType, bool enabled)
    {
        if (narrationOutputType == TNOT_CONSOLE)
        {
            if (enabled)
            {
                Toby_Logger.ConsoleOutputModeMessage("No Radius Damage enabled");
            }
            else
            {
                Toby_Logger.ConsoleOutputModeMessage("No Radius Damage disabled");
            }
        }
        else
        {
            if (enabled)
            {
                Toby_SoundQueueStaticHandler.AddSound("stats/noradiusdamage/enabled", -1);
            }
            else
            {
                Toby_SoundQueueStaticHandler.AddSound("stats/noradiusdamage/disabled", -1);
            }
            Toby_SoundQueueStaticHandler.PlayQueue(0);
        }
    }
}
