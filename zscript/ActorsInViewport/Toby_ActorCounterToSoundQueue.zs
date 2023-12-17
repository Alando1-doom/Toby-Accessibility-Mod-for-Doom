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
            string soundToPlay = "";
            if (actorCounter.namesAndAmounts[i].countKill)
            {
                soundToPlay = GetGenericMonsterName(amount, actorCounter.namesAndAmounts[i].maxHp);
            }
            string toPlay = GetSoundName(bindings, classNameToFind, amount);
            if (toPlay != "")
            {
                soundToPlay = toPlay;
            }

            if (soundToPlay == "") { continue; }

            if (actorCounter.isRemains)
            {
                string remainsOfSound = GetGenericRemainsSound(amount);
                string remainsToPlay = GetRemainsOfSound(bindings, classNameToFind, amount);
                if (remainsToPlay != "") { remainsOfSound = remainsToPlay; }
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

    string GetGenericMonsterName(int amount, int maxHp)
    {
        if (maxHp < 300)
        {
            if (amount == 1)
            {
                return "toby/actorsinviewport/monsters/lowtiermon";
            }
            return "toby/actorsinviewport/monsters/lowtiermons";
        }
        if (maxHp < 3000)
        {
            if (amount == 1)
            {
                return "toby/actorsinviewport/monsters/midtiermon";
            }
            return "toby/actorsinviewport/monsters/midtiermons";
        }
        if (amount == 1)
        {
            return "toby/actorsinviewport/monsters/hightiermon";
        }
        return "toby/actorsinviewport/monsters/hightiermons";
    }

    string GetGenericRemainsSound(int amount)
    {
        if (amount == 1)
        {
            return "toby/actorsinviewport/general/remainsofa";
        }
        return "toby/actorsinviewport/general/remainsof";
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
