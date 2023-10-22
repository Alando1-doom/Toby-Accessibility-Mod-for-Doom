class Toby_SoundQueue
{
    Array<Toby_QueuedSound> queue;

    static Toby_SoundQueue Create()
    {
        Toby_SoundQueue soundQueue = new("Toby_SoundQueue");
        return soundQueue;
    }

    void Clear()
    {
        queue.Clear();
    }

    void AddSound(string sound, int pause)
    {
        queue.push(Toby_QueuedSound.Create(sound, pause));
    }

    void UnshiftSound(string sound, int pause)
    {
        queue.Insert(0, Toby_QueuedSound.Create(sound, pause));
    }

    void AddQueue(Toby_SoundQueue otherQueue)
    {
        queue.Append(otherQueue.queue);
    }

    void UnshiftQueue(Toby_SoundQueue otherQueue)
    {
        Array<Toby_QueuedSound> tempQueue;
        tempQueue.Copy(queue);
        queue.Copy(otherQueue.queue);
        queue.Append(tempQueue);
        tempQueue.Clear();
    }
}
