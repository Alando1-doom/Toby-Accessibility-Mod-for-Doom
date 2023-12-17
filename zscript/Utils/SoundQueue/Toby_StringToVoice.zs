//Will be obsoleted by Toby_StringToSoundQueue and removed

class Toby_StringToVoice ui
{
    ui static void ConvertAndAddToQueue(string text)
    {
        for (int i = 0; i < text.Length(); i++)
        {
            string character = text.Mid(i, 1).MakeLower();
            Toby_SoundQueueStaticHandler.AddSound(GetCharSoundName(character), -1);
        }
    }

    ui static void ConvertAndAddToQueueReverse(string text)
    {
        for (int i = text.Length()-1; i >= 0; i--)
        {
            string character = text.Mid(i, 1).MakeLower();
            Toby_SoundQueueStaticHandler.UnshiftSound(GetCharSoundName(character), -1);
        }
    }

    ui static string GetCharSoundName(string character)
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
