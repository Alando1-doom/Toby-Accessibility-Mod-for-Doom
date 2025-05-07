class Toby_PlayerStateChangeHandler: EventHandler
{
    int maxPlayers;
    bool narratedCrouch;

    Array<double> previousCrouchDir;
    Array<double> currentCrouchDir;

    override void OnRegister()
    {
        Toby_Logger.Message("Toby_PlayerStateChangeHandler registered!", "Toby_Developer");
    }

    override void WorldLoaded(WorldEvent e)
    {
        maxPlayers = 8;
        for (int i = 0; i < maxPlayers; i++)
        {
            previousCrouchDir.push(1);
            currentCrouchDir.push(1);
        }

        narratedCrouch = Cvar.GetCvar("Toby_NarratedCrouch", players[consoleplayer]).GetBool();
    }

    override void WorldTick()
    {
        if (level.mapName == "TITLEMAP") { return; }
        DetectAndProcessCrouching();
    }

    private void DetectAndProcessCrouching()
    {
        for (int i = 0; i < maxPlayers; i++)
        {
            if (!players[i].mo) { continue; }

            currentCrouchDir[i] = players[i].CrouchDir;
            if (currentCrouchDir[i] != previousCrouchDir[i] && currentCrouchDir[i] == -1)
            {
                if (narratedCrouch)
                {
                    players[i].mo.A_StartSound("stats/general/crouched", CHAN_AUTO);
                }
                else
                {
                    players[i].mo.A_StartSound("stats/general/crouchednonarration", CHAN_AUTO);
                }
            }
            if (currentCrouchDir[i] != previousCrouchDir[i] && currentCrouchDir[i] == 1)
            {
                if (narratedCrouch)
                {
                    players[i].mo.A_StartSound("stats/general/uncrouched", CHAN_AUTO);
                }
                else
                {
                    players[i].mo.A_StartSound("stats/general/uncrouchednonarration", CHAN_AUTO);
                }
            }
            previousCrouchDir[i] = currentCrouchDir[i];
        }
    }
}
