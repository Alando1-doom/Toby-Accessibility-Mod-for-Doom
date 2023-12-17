class Toby_QueuedSound
{
    string sound;
    int pause;

    static Toby_QueuedSound Create(string sound, int pause)
    {
        Toby_QueuedSound newSound = new("Toby_QueuedSound");
        newSound.sound = sound;
        if (pause >= 0)
        {
            newSound.pause = pause * 1000 / GameTicRate;
        }
        else
        {
            newSound.pause = S_GetLength(sound) * 1000 / GameTicRate;
        }
        return newSound;
    }
}
