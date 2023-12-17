class Toby_MonthToVoice ui
{
    ui static void ConvertAndAddToQueue(int month)
    {
        Toby_SoundQueueStaticHandler.AddSound(GetMonthSoundName(month), -1);
    }

    ui static void ConvertAndUnshiftToQueue(int month)
    {
        Toby_SoundQueueStaticHandler.UnshiftSound(GetMonthSoundName(month), -1);
    }

    ui static string GetMonthSoundName(int month)
    {
        string monthSoundName = "alphabet/Space";
        if (month == 1) monthSoundName = "month/january";
        if (month == 2) monthSoundName = "month/february";
        if (month == 3) monthSoundName = "month/march";
        if (month == 4) monthSoundName = "month/april";
        if (month == 5) monthSoundName = "month/may";
        if (month == 6) monthSoundName = "month/june";
        if (month == 7) monthSoundName = "month/july";
        if (month == 8) monthSoundName = "month/august";
        if (month == 9) monthSoundName = "month/september";
        if (month == 10) monthSoundName = "month/october";
        if (month == 11) monthSoundName = "month/november";
        if (month == 12) monthSoundName = "month/december";
        return monthSoundName;
    }
}
