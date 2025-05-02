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
        string soundName = "";
        if (text.Length() == 1)
        {
            string character = text.MakeLower();
            soundName = GetCharSoundName(character);
        }
        if (soundName == "" || soundName == "alphabet/Space")
        {
            soundName = GetNonAlphabetKeySoundName(text);
        }
        return soundName;
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
        if (character == " ") return "alphabet/Space";
        if (character == "a") return "alphabet/A";
        if (character == "b") return "alphabet/B";
        if (character == "c") return "alphabet/C";
        if (character == "d") return "alphabet/D";
        if (character == "e") return "alphabet/E";
        if (character == "f") return "alphabet/F";
        if (character == "g") return "alphabet/G";
        if (character == "h") return "alphabet/H";
        if (character == "i") return "alphabet/I";
        if (character == "j") return "alphabet/J";
        if (character == "k") return "alphabet/K";
        if (character == "l") return "alphabet/L";
        if (character == "m") return "alphabet/M";
        if (character == "n") return "alphabet/N";
        if (character == "o") return "alphabet/O";
        if (character == "p") return "alphabet/P";
        if (character == "q") return "alphabet/Q";
        if (character == "r") return "alphabet/R";
        if (character == "s") return "alphabet/S";
        if (character == "t") return "alphabet/T";
        if (character == "u") return "alphabet/U";
        if (character == "v") return "alphabet/V";
        if (character == "w") return "alphabet/W";
        if (character == "x") return "alphabet/X";
        if (character == "y") return "alphabet/Y";
        if (character == "z") return "alphabet/Z";
        if (character == "0") return "numbers/000";
        if (character == "1") return "numbers/001";
        if (character == "2") return "numbers/002";
        if (character == "3") return "numbers/003";
        if (character == "4") return "numbers/004";
        if (character == "5") return "numbers/005";
        if (character == "6") return "numbers/006";
        if (character == "7") return "numbers/007";
        if (character == "8") return "numbers/008";
        if (character == "9") return "numbers/009";

        if (character == "~") return "keyboard/tilde";
        if (character == "!") return "keyboard/exclamation";
        if (character == "@") return "keyboard/at";
        if (character == "#") return "keyboard/pound";
        if (character == "$") return "keyboard/dollar";
        if (character == "%") return "keyboard/percent";
        if (character == "&") return "keyboard/and";
        if (character == "*") return "keyboard/star";
        if (character == "(") return "keyboard/openparenthesis";
        if (character == ")") return "keyboard/closeparenthesis";
        if (character == "_") return "keyboard/underscore";
        if (character == "+") return "keyboard/plus";
        if (character == "-") return "keyboard/minus";
        if (character == "=") return "keyboard/equals";
        if (character == "[") return "keyboard/openbracket";
        if (character == "]") return "keyboard/closebracket";
        // if (character == "\\") return "keyboard/backslash"; // What? I can't escape backslash? -PR
        if (character == ":") return "keyboard/colon";
        if (character == ";") return "keyboard/semicolon";
        if (character == "'") return "keyboard/quote";
        if (character == "\"") return "keyboard/quote";
        if (character == ",") return "keyboard/comma";
        if (character == ".") return "keyboard/period";
        if (character == "<") return "keyboard/lessthan";
        if (character == ">") return "keyboard/greaterthan";
        if (character == "?") return "keyboard/questionmark";
        if (character == "/") return "keyboard/slash";

        return "alphabet/Space";
    }

    private string GetNonAlphabetKeySoundName(string keyFromKeybindsMenu)
    {
        if (keyFromKeybindsMenu == "Escape") { return "keyboard/escape"; }
        if (keyFromKeybindsMenu == "F1") { return "keyboard/f1"; }
        if (keyFromKeybindsMenu == "F2") { return "keyboard/f2"; }
        if (keyFromKeybindsMenu == "F3") { return "keyboard/f3"; }
        if (keyFromKeybindsMenu == "F4") { return "keyboard/f4"; }
        if (keyFromKeybindsMenu == "F5") { return "keyboard/f5"; }
        if (keyFromKeybindsMenu == "F6") { return "keyboard/f6"; }
        if (keyFromKeybindsMenu == "F7") { return "keyboard/f7"; }
        if (keyFromKeybindsMenu == "F8") { return "keyboard/f8"; }
        if (keyFromKeybindsMenu == "F9") { return "keyboard/f9"; }
        if (keyFromKeybindsMenu == "F10") { return "keyboard/f10"; }
        if (keyFromKeybindsMenu == "F11") { return "keyboard/f11"; }
        if (keyFromKeybindsMenu == "F12") { return "keyboard/f12"; }
        if (keyFromKeybindsMenu == "SysRq") { return "keyboard/printscreen"; }
        if (keyFromKeybindsMenu == "Scroll") { return "keyboard/scrolllock"; }
        if (keyFromKeybindsMenu == "Pause") { return "keyboard/pause"; }
        if (keyFromKeybindsMenu == "`") { return "keyboard/tilde"; }
        if (keyFromKeybindsMenu == "-") { return "keyboard/minus"; }
        if (keyFromKeybindsMenu == "=") { return "keyboard/equals"; }
        if (keyFromKeybindsMenu == "Backspace") { return "keyboard/backspace"; }
        if (keyFromKeybindsMenu == "Tab") { return "keyboard/tab"; }
        if (keyFromKeybindsMenu == "CapsLock") { return "keyboard/capslock"; }
        if (keyFromKeybindsMenu == "Shift") { return "keyboard/shift"; }
        if (keyFromKeybindsMenu == "RShift") { return "keyboard/shift"; } // Should be a separate sound?
        if (keyFromKeybindsMenu == "Ctrl") { return "keyboard/control"; }
        if (keyFromKeybindsMenu == "RCtrl") { return "keyboard/control"; } // Should be a separate sound?
        if (keyFromKeybindsMenu == "Alt") { return "keyboard/alt"; }
        if (keyFromKeybindsMenu == "RAlt") { return "keyboard/alt"; } // Should be a separate sound?
        if (keyFromKeybindsMenu == "Space") { return "keyboard/spacebar"; }
        if (keyFromKeybindsMenu == "Enter") { return "keyboard/enter"; }
        if (keyFromKeybindsMenu == "[") { return "keyboard/openbracket"; }
        if (keyFromKeybindsMenu == "]") { return "keyboard/closebracket"; }
        // if (keyFromKeybindsMenu == "\\") { return "keyboard/backslash"; } // What? I can't escape backslash? -PR
        if (keyFromKeybindsMenu == ";") { return "keyboard/semicolon"; }
        if (keyFromKeybindsMenu == "'") { return "keyboard/quote"; }
        if (keyFromKeybindsMenu == ",") { return "keyboard/comma"; }
        if (keyFromKeybindsMenu == ".") { return "keyboard/period"; }
        if (keyFromKeybindsMenu == "/") { return "keyboard/slash"; }
        if (keyFromKeybindsMenu == "UpArrow") { return "keyboard/uparrow"; }
        if (keyFromKeybindsMenu == "DownArrow") { return "keyboard/downarrow"; }
        if (keyFromKeybindsMenu == "LeftArrow") { return "keyboard/leftarrow"; }
        if (keyFromKeybindsMenu == "RightArrow") { return "keyboard/rightarrow"; }
        if (keyFromKeybindsMenu == "Ins") { return "keyboard/insert"; }
        if (keyFromKeybindsMenu == "Home") { return "keyboard/home"; }
        if (keyFromKeybindsMenu == "Del") { return "keyboard/delete"; }
        if (keyFromKeybindsMenu == "End") { return "keyboard/end"; }
        if (keyFromKeybindsMenu == "PgUp") { return "keyboard/pageup"; }
        if (keyFromKeybindsMenu == "PgDn") { return "keyboard/pagedown"; }
        if (keyFromKeybindsMenu == "NumLock") { return "keyboard/numlock"; }
        if (keyFromKeybindsMenu == "KP/") { return "keyboard/kpslash"; }
        if (keyFromKeybindsMenu == "KP*") { return "keyboard/kpstar"; }
        if (keyFromKeybindsMenu == "KP-") { return "keyboard/kpminus"; }
        if (keyFromKeybindsMenu == "KP+") { return "keyboard/kpplus"; }
        if (keyFromKeybindsMenu == "KP-Enter") { return "keyboard/kpenter"; }
        if (keyFromKeybindsMenu == "KP.") { return "keyboard/kpdecimal"; }
        if (keyFromKeybindsMenu == "KP0") { return "keyboard/kp0"; }
        if (keyFromKeybindsMenu == "KP1") { return "keyboard/kp1"; }
        if (keyFromKeybindsMenu == "KP2") { return "keyboard/kp2"; }
        if (keyFromKeybindsMenu == "KP3") { return "keyboard/kp3"; }
        if (keyFromKeybindsMenu == "KP4") { return "keyboard/kp4"; }
        if (keyFromKeybindsMenu == "KP5") { return "keyboard/kp5"; }
        if (keyFromKeybindsMenu == "KP6") { return "keyboard/kp6"; }
        if (keyFromKeybindsMenu == "KP7") { return "keyboard/kp7"; }
        if (keyFromKeybindsMenu == "KP8") { return "keyboard/kp8"; }
        if (keyFromKeybindsMenu == "KP9") { return "keyboard/kp9"; }

        return "alphabet/Space";
    }
}
