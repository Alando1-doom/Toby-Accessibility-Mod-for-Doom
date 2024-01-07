class Toby_MonthToSoundQueue
{
    Toby_SoundQueue soundQueue;

    static Toby_MonthToSoundQueue Create()
    {
        Toby_MonthToSoundQueue monthToSoundQueue = new("Toby_MonthToSoundQueue");
        monthToSoundQueue.soundQueue = new("Toby_SoundQueue");
        return monthToSoundQueue;
    }

    Toby_SoundQueue CreateQueueFromMonthNumber(int monthNumber)
    {
        Reset();
        soundQueue.AddSound(GetMonthSoundName(monthNumber), -1);
        return soundQueue;
    }

    private void Reset()
    {
        soundQueue = new("Toby_SoundQueue");
    }

    private string GetMonthSoundName(int monthNumber)
    {
        string monthSoundName = "alphabet/Space";
        if (monthNumber == 1) monthSoundName = "month/january";
        if (monthNumber == 2) monthSoundName = "month/february";
        if (monthNumber == 3) monthSoundName = "month/march";
        if (monthNumber == 4) monthSoundName = "month/april";
        if (monthNumber == 5) monthSoundName = "month/may";
        if (monthNumber == 6) monthSoundName = "month/june";
        if (monthNumber == 7) monthSoundName = "month/july";
        if (monthNumber == 8) monthSoundName = "month/august";
        if (monthNumber == 9) monthSoundName = "month/september";
        if (monthNumber == 10) monthSoundName = "month/october";
        if (monthNumber == 11) monthSoundName = "month/november";
        if (monthNumber == 12) monthSoundName = "month/december";
        return monthSoundName;
    }
}
