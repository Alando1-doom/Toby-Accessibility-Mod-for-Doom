class Toby_MapAnnouncementEntry
{
    string checksum;
    string soundToPlay;
    int levelStartPlaybackDelay;

    static Toby_MapAnnouncementEntry Create(string checksum, string soundToPlay, int levelStartPlaybackDelay)
    {
        Toby_MapAnnouncementEntry entry = new("Toby_MapAnnouncementEntry");
        entry.checksum = checksum;
        entry.soundToPlay = soundToPlay;
        entry.levelStartPlaybackDelay = levelStartPlaybackDelay;

        return entry;
    }
}
