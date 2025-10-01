class Toby_MenuItemWithSoundQueue : Toby_BaseMenuItem
{
    Toby_SoundQueue queue;

    void SetSoundQueue(Toby_SoundQueue q)
    {
        queue = q;
    }

    Toby_SoundQueue GetSoundQueue()
    {
        return queue;
    }
}
