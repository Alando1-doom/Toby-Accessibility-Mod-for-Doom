class MonthToVoice ui
{
    ui static void ConvertAndAddToQueue(int month)
    {
        //Switch case?
        if (month == 1) SoundQueue.AddSound("month/january", -1);
        if (month == 2) SoundQueue.AddSound("month/february", -1);
        if (month == 3) SoundQueue.AddSound("month/march", -1);
        if (month == 4) SoundQueue.AddSound("month/april", -1);
        if (month == 5) SoundQueue.AddSound("month/may", -1);
        if (month == 6) SoundQueue.AddSound("month/june", -1);
        if (month == 7) SoundQueue.AddSound("month/july", -1);
        if (month == 8) SoundQueue.AddSound("month/august", -1);
        if (month == 9) SoundQueue.AddSound("month/september", -1);
        if (month == 10) SoundQueue.AddSound("month/october", -1);
        if (month == 11) SoundQueue.AddSound("month/november", -1);
        if (month == 12) SoundQueue.AddSound("month/december", -1);
    }

    ui static void ConvertAndUnshiftToQueue(int month)
    {
        if (month == 1) SoundQueue.UnshiftSound("month/january", -1);
        if (month == 2) SoundQueue.UnshiftSound("month/february", -1);
        if (month == 3) SoundQueue.UnshiftSound("month/march", -1);
        if (month == 4) SoundQueue.UnshiftSound("month/april", -1);
        if (month == 5) SoundQueue.UnshiftSound("month/may", -1);
        if (month == 6) SoundQueue.UnshiftSound("month/june", -1);
        if (month == 7) SoundQueue.UnshiftSound("month/july", -1);
        if (month == 8) SoundQueue.UnshiftSound("month/august", -1);
        if (month == 9) SoundQueue.UnshiftSound("month/september", -1);
        if (month == 10) SoundQueue.UnshiftSound("month/october", -1);
        if (month == 11) SoundQueue.UnshiftSound("month/november", -1);
        if (month == 12) SoundQueue.UnshiftSound("month/december", -1);
    }
}