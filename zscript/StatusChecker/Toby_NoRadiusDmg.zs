class Toby_NoRadiusDmg
{
    play static void NoRadiusDmgInit(int playerNumber)
    {
        PlayerInfo player = players[playerNumber];
        if (!player) { return; }
        if (!player.mo) { return; }
        int enabledForPlayer = Cvar.GetCvar("Toby_NoRadiusDmg_EnabledByDefault", player).GetInt();
        if (enabledForPlayer == TNRDEBD_IGNORE) { return; }
        if (enabledForPlayer == TNRDEBD_DISABLED)
        {
            player.mo.bNORADIUSDMG = false;
        }
        if (enabledForPlayer == TNRDEBD_ENABLED)
        {
            player.mo.bNORADIUSDMG = true;
        }
    }

    play static void Toggle(int playerNumber)
    {
        PlayerInfo player = players[playerNumber];
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;
        playerActor.bNORADIUSDMG = !playerActor.bNORADIUSDMG;
        EventHandler.SendInterfaceEvent(playerNumber, "Toby_NoRadiusDmgToggleInterface");
    }

    ui static void NoRadiusDmgToggleByOutputType(int narrationOutputType, bool enabled)
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
