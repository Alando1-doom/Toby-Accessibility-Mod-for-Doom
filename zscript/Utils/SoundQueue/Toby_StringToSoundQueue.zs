class Toby_StringToSoundQueue
{
    Toby_SoundQueue soundQueue;

    static Toby_StringToSoundQueue Create()
    {
        Toby_StringToSoundQueue numberToSoundQueue = new("Toby_StringToSoundQueue");
        numberToSoundQueue.soundQueue = new("Toby_SoundQueue");
        return numberToSoundQueue;
    }

    void Reset()
    {
        soundQueue = new("Toby_SoundQueue");
    }

    Toby_SoundQueue CreateQueueFromText(string text)
    {
        Reset();
        ConvertAndAddToQueue(text);
        return soundQueue;
    }

    Toby_SoundQueue CreateQueueFromKeybind(string text)
    {
        Reset();
        string keySoundName = GetKeySoundName(text);
        if (keySoundName.Length() > 0)
        {
            soundQueue.AddSound(GetKeySoundName(text), -1);
        }
        //TODO: Remove this "else" after correct key sound is returned
        else
        {
            ConvertAndAddToQueue(text);
        }
        return soundQueue;
    }

    private string GetKeySoundName(string text)
    {
        if (text.Length() == 1)
        {
            string character = text.MakeLower();
            return GetCharSoundName(character);
        }
        else
        {
            return "";
            //TODO: Get sounds for all keys and sound for "Key not assigned"
        }
    }

    private void ConvertAndAddToQueue(string text)
    {
        for (int i = 0; i < text.Length(); i++)
        {
            string character = text.Mid(i, 1).MakeLower();
            soundQueue.AddSound(GetCharSoundName(character), -1);
        }
    }

    private void ConvertAndAddToQueueReverse(string text)
    {
        for (int i = text.Length()-1; i >= 0; i--)
        {
            string character = text.Mid(i, 1).MakeLower();
            soundQueue.UnshiftSound(GetCharSoundName(character), -1);
        }
    }

    private string GetCharSoundName(string character)
    {
        string characterSoundName = "alphabet/Space";
        if (character == " ") characterSoundName = "alphabet/Space";
        if (character == "a") characterSoundName = "alphabet/A";
        if (character == "b") characterSoundName = "alphabet/B";
        if (character == "c") characterSoundName = "alphabet/C";
        if (character == "d") characterSoundName = "alphabet/D";
        if (character == "e") characterSoundName = "alphabet/E";
        if (character == "f") characterSoundName = "alphabet/F";
        if (character == "g") characterSoundName = "alphabet/G";
        if (character == "h") characterSoundName = "alphabet/H";
        if (character == "i") characterSoundName = "alphabet/I";
        if (character == "j") characterSoundName = "alphabet/J";
        if (character == "k") characterSoundName = "alphabet/K";
        if (character == "l") characterSoundName = "alphabet/L";
        if (character == "m") characterSoundName = "alphabet/M";
        if (character == "n") characterSoundName = "alphabet/N";
        if (character == "o") characterSoundName = "alphabet/O";
        if (character == "p") characterSoundName = "alphabet/P";
        if (character == "q") characterSoundName = "alphabet/Q";
        if (character == "r") characterSoundName = "alphabet/R";
        if (character == "s") characterSoundName = "alphabet/S";
        if (character == "t") characterSoundName = "alphabet/T";
        if (character == "u") characterSoundName = "alphabet/U";
        if (character == "v") characterSoundName = "alphabet/V";
        if (character == "w") characterSoundName = "alphabet/W";
        if (character == "x") characterSoundName = "alphabet/X";
        if (character == "y") characterSoundName = "alphabet/Y";
        if (character == "z") characterSoundName = "alphabet/Z";
        if (character == "0") characterSoundName = "numbers/000";
        if (character == "1") characterSoundName = "numbers/001";
        if (character == "2") characterSoundName = "numbers/002";
        if (character == "3") characterSoundName = "numbers/003";
        if (character == "4") characterSoundName = "numbers/004";
        if (character == "5") characterSoundName = "numbers/005";
        if (character == "6") characterSoundName = "numbers/006";
        if (character == "7") characterSoundName = "numbers/007";
        if (character == "8") characterSoundName = "numbers/008";
        if (character == "9") characterSoundName = "numbers/009";
        return characterSoundName;
    }
}
