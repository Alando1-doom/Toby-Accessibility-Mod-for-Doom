class Toby_HealthChecker
{
    ui static void CheckHealthLegacy(PlayerInfo player)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;
        Array<Toby_PlayerStatusCondition> conditions;
        conditions.push(Toby_PlayerStatusCondition.Create(0, 0.2, "stat/health/critical"));
        conditions.push(Toby_PlayerStatusCondition.Create(0.2, 0.4, "stat/health/low"));
        conditions.push(Toby_PlayerStatusCondition.Create(0.4, 0.6, "stat/health/poor"));
        conditions.push(Toby_PlayerStatusCondition.Create(0.6, 0.8, "stat/health/avg"));
        conditions.push(Toby_PlayerStatusCondition.Create(0.8, 1.0, "stat/health/good"));
        conditions.push(Toby_PlayerStatusCondition.Create(1.0, double.Max, "stat/health/great"));

        for (int i = 0; i < conditions.Size(); i++)
        {
            if (conditions[i].Evaluate(playerActor.health, playerActor.SpawnHealth()))
            {
                S_StartSound(conditions[i].soundToPlay, CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
                break;
            }
        }
    }

    ui static void CheckHealth(PlayerInfo player)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;
        Toby_SoundQueueStaticHandler.AddSound("stats/general/health", -1);
        Toby_NumberToSoundQueue numberToSoundQueue = Toby_NumberToSoundQueue.Create();
        Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(playerActor.health));
        Toby_SoundQueueStaticHandler.AddSound("stats/general/percent", -1);
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui static void CheckHealthTextOnly(PlayerInfo player)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;

        string textToPrint = "Health " .. playerActor.health .. "%";
        Toby_Logger.ConsoleOutputModeMessage(textToPrint);
    }
}
