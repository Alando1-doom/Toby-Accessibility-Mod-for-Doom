class Toby_ActorCounterToSoundQueue
{
    Toby_SoundQueue soundQueue;

    static Toby_ActorCounterToSoundQueue Create()
    {
        Toby_ActorCounterToSoundQueue actorCounterToSoundQueue = new("Toby_ActorCounterToSoundQueue");
        actorCounterToSoundQueue.soundQueue = new("Toby_SoundQueue");
        return actorCounterToSoundQueue;
    }

    private void Reset()
    {
        soundQueue = new("Toby_SoundQueue");
    }

    Toby_SoundQueue CreateQueueFromActorCounter(Toby_ActorsInViewportActorCounter actorCounter, Toby_SoundBindingsContainer bindings)
    {
        Reset();

        Toby_NumberToSoundQueue numberToSoundQueue = Toby_NumberToSoundQueue.Create();

        for (let i = 0; i < actorCounter.namesAndAmounts.Size(); i++)
        {
            int amount = actorCounter.namesAndAmounts[i].amount;
            string classNameToFind = actorCounter.namesAndAmounts[i].name;
            string soundToPlay = GetSoundName(bindings, classNameToFind, amount);
            if (soundToPlay == "") { continue; }

            if (actorCounter.isRemains)
            {
                string remainsOfSound = GetRemainsOfSound(bindings, classNameToFind, amount);
                soundQueue.AddSound(remainsOfSound, -1);
            }

            if (amount > 1)
            {
                soundQueue.AddQueue(numberToSoundQueue.CreateQueueFromInt(amount));
            }
            soundQueue.AddSound(soundToPlay, -1);
        }

        return soundQueue;
    }

    string GetSoundName(Toby_SoundBindingsContainer bindings, string classNameToFind, int amount)
    {
        string soundToPlay = "";
        for (int i = 0; i < bindings.soundBindings.Size(); i++)
        {
            string className = bindings.soundBindings[i].At("ActorClass");
            if (classNameToFind == className)
            {
                if (amount == 1)
                {
                    soundToPlay = bindings.soundBindings[i].At("SoundToPlay");
                }
                else
                {
                    soundToPlay = bindings.soundBindings[i].At("SoundToPlayPlural");
                }
            }
        }
        return soundToPlay;
    }

    //Proydoha: I don't like this. This should be redone
    string GetRemainsOfSound(Toby_SoundBindingsContainer bindings, string classNameToFind, int amount)
    {
        string soundToPlay = "";
        for (int i = 0; i < bindings.soundBindings.Size(); i++)
        {
            string className = bindings.soundBindings[i].At("ActorClass");
            if (classNameToFind == className)
            {
                if (amount == 1)
                {
                    if (bindings.soundBindings[i].At("Article") == "a")
                    {
                        soundToPlay = "toby/actorsinviewport/general/remainsofa";
                    }
                    if (bindings.soundBindings[i].At("Article") == "an")
                    {
                        soundToPlay = "toby/actorsinviewport/general/remainsofan";
                    }
                }
                else
                {
                    soundToPlay = "toby/actorsinviewport/general/remainsof";
                }
            }
        }
        return soundToPlay;
    }
}
