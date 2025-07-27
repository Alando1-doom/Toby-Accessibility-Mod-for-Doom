class Toby_SoundBindingsContainer
{
    Array<Dictionary> soundBindings;

    static ui Toby_SoundBindingsContainer Create(string lumpName)
    {
        Toby_SoundBindingsContainer container = new("Toby_SoundBindingsContainer");
        Array<String> splitTokens;
        int lump = -1;
        while ((lump = Toby_WadsUtils.FindLump(lumpName, lump + 1)) != -1)
        {
            Toby_Logger.Message("Lump ["..lump.."] has full name '"..Wads.GetLumpFullName(lump).."'", "Toby_Developer");
            string lumpContent = Wads.ReadLump(lump);
            splitTokens.Clear();
            lumpContent.Split(splitTokens, "\n", TOK_SKIPEMPTY);

            for (int i = 0; i < splitTokens.Size(); i++)
            {
                //Failsafe
                //{"a":"b"}
                //9 chars long, can't be smaller
                if (splitTokens[i].Length() < 9) { continue; }

                //Dumb check for commented line
                if (splitTokens[i].IndexOf("//") == 0) { continue; }

                //Replace sounds if exactly the same condition definition already exists:
                Dictionary soundBinding = Dictionary.FromString(splitTokens[i]);
                int newSoundBindingSize = Toby_SoundBindingsContainer.GetDictionarySize(soundBinding);
                bool sameConditionFound = false;
                for (int j = 0; j < container.soundBindings.Size(); j++)
                {
                    int existingBindingSize = Toby_SoundBindingsContainer.GetDictionarySize(container.soundBindings[j]);
                    if (newSoundBindingSize != existingBindingSize)
                    {
                        continue;
                    }
                    DictionaryIterator di = DictionaryIterator.Create(container.soundBindings[j]);
                    bool sameCondition = true;
                    while (di.Next())
                    {
                        if (di.Key() == "SoundToPlay") { continue; }
                        if (soundBinding.At(di.Key()) == "")
                        {
                            sameCondition = false;
                            break;
                        }
                        if (soundBinding.At(di.Key()) != di.Value())
                        {
                            sameCondition = false;
                            break;
                        }
                    }
                    if (sameCondition)
                    {
                        container.soundBindings[j] = soundBinding;
                        sameConditionFound = true;
                        break;
                    }
                }
                if (!sameConditionFound)
                {
                    container.soundBindings.push(soundBinding);
                }
            }
            Toby_Logger.Message("Sound bindings added: "..container.soundBindings.Size(), "Toby_Developer");
        }
        return container;
    }

    static ui int GetDictionarySize(Dictionary d)
    {
        int size = 0;
        DictionaryIterator di = DictionaryIterator.Create(d);
        while (di.Next())
        {
            size++;
        }
        return size;
    }
}
