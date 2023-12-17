class Toby_TargetDetectorEntry
{
    string className;
    string soundToPlay;
    int cooldown;

    static Toby_TargetDetectorEntry Create(string className, string soundToPlay, int cooldown)
    {
        Toby_TargetDetectorEntry entry = new("Toby_TargetDetectorEntry");
        entry.className = className;
        entry.soundToPlay = soundToPlay;
        entry.cooldown = cooldown;

        return entry;
    }
}
