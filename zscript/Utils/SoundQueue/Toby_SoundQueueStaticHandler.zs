class Toby_SoundQueueStaticHandler : StaticEventHandler
{
    ui Array<Toby_QueuedSound> queue;
    ui int waitTime;
    ui bool playing;

    override void UiTick()
    {
        if (queue.Size() == 0)
        {
            return;
        }
        if (playing)
        {
            if (waitTime > 0)
            {
                waitTime--;
            }
            else
            {
                if (!queue[0])
                {
                    playing = false;
                    return;
                }
                S_StartSound(queue[0].sound, CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE);
                waitTime = queue[0].pause;
                queue[0].Destroy();
                queue.Delete(0, 1);
                if (queue.Size() == 0)
                {
                    playing = false;
                }
            }
        }
    }

    ui static void Clear()
    {
        Toby_SoundQueueStaticHandler handler = Toby_SoundQueueStaticHandler(StaticEventHandler.Find("Toby_SoundQueueStaticHandler"));
        for (int i = 0; i < handler.queue.Size(); i++)
        {
            if (!handler.queue[i]) { continue; }
            handler.queue[i].Destroy();
        }
        handler.queue.Clear();
    }

    ui static void AddSound(string sound, int pause)
    {
        Toby_SoundQueueStaticHandler handler = Toby_SoundQueueStaticHandler(StaticEventHandler.Find("Toby_SoundQueueStaticHandler"));
        handler.queue.push(Toby_QueuedSound.Create(sound, pause));
    }

    ui static void UnshiftSound(string sound, int pause)
    {
        Toby_SoundQueueStaticHandler handler = Toby_SoundQueueStaticHandler(StaticEventHandler.Find("Toby_SoundQueueStaticHandler"));
        handler.queue.Insert(0, Toby_QueuedSound.Create(sound, pause));
    }

    ui static void AddQueue(Toby_SoundQueue soundQueue)
    {
        Toby_SoundQueueStaticHandler handler = Toby_SoundQueueStaticHandler(StaticEventHandler.Find("Toby_SoundQueueStaticHandler"));
        for (int i = 0; i < soundQueue.queue.Size(); i++)
        {
            handler.queue.push(soundQueue.queue[i]);
        }
    }

    ui static void PlayQueue(int initialPause)
    {
        Toby_SoundQueueStaticHandler handler = Toby_SoundQueueStaticHandler(StaticEventHandler.Find("Toby_SoundQueueStaticHandler"));
        handler.waitTime = initialPause * 1000 / GameTicRate;
        handler.playing = true;
    }
}
