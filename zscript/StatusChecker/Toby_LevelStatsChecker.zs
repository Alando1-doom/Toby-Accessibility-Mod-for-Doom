class Toby_LevelStatsChecker
{
    ui static void CheckLevelStats()
    {
        Toby_NumberToSoundQueue numberToSoundQueue = Toby_NumberToSoundQueue.Create();
        Toby_SoundQueueStaticHandler.Clear();
        Toby_SoundQueueStaticHandler.AddSound("stats/level/secrets", -1);
        Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(level.Found_Secrets));
        numberToSoundQueue.Reset();
        Toby_SoundQueueStaticHandler.AddSound("save/of", -1);
        Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(level.Total_Secrets));
        numberToSoundQueue.Reset();
        Toby_SoundQueueStaticHandler.AddSound("alphabet/Space", -1);

        Toby_SoundQueueStaticHandler.AddSound("stats/level/monsters", -1);
        Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(level.Killed_Monsters));
        numberToSoundQueue.Reset();
        Toby_SoundQueueStaticHandler.AddSound("save/of", -1);
        Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(level.Total_Monsters));
        numberToSoundQueue.Reset();
        Toby_SoundQueueStaticHandler.AddSound("alphabet/Space", -1);

        Toby_SoundQueueStaticHandler.AddSound("stats/level/items", -1);
        Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(level.Found_Items));
        numberToSoundQueue.Reset();
        Toby_SoundQueueStaticHandler.AddSound("save/of", -1);
        Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(level.Total_Items));
        numberToSoundQueue.Reset();
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui static void CheckLevelStatsTextOnly()
    {
        string textToPrint = "Secrets: "..level.Found_Secrets.." of "..level.Total_Secrets.."; "..
            "Monsters: "..level.Killed_Monsters.." of "..level.Total_Monsters.."; "..
            "Items: "..level.Found_Items.." of "..level.Total_Items;
        Toby_Logger.ConsoleOutputModeMessage(textToPrint);

    }

    ui static void CheckLevelStatsByOutputType(int narrationOutputType)
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
}
