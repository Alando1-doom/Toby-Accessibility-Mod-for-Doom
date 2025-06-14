class Toby_StringToSoundQueue
{
    Toby_SoundQueue soundQueue;
    Dictionary nonAlphabetKeys;
    Dictionary alphabetKeys;

    static Toby_StringToSoundQueue Create()
    {
        Toby_StringToSoundQueue stringToSoundQueue = new("Toby_StringToSoundQueue");
        stringToSoundQueue.soundQueue = new("Toby_SoundQueue");

        stringToSoundQueue.nonAlphabetKeys = Dictionary.Create();
        stringToSoundQueue.nonAlphabetKeys.Insert("Escape", "keyboard/escape");
        stringToSoundQueue.nonAlphabetKeys.Insert("F1", "keyboard/f1");
        stringToSoundQueue.nonAlphabetKeys.Insert("F2", "keyboard/f2");
        stringToSoundQueue.nonAlphabetKeys.Insert("F3", "keyboard/f3");
        stringToSoundQueue.nonAlphabetKeys.Insert("F4", "keyboard/f4");
        stringToSoundQueue.nonAlphabetKeys.Insert("F5", "keyboard/f5");
        stringToSoundQueue.nonAlphabetKeys.Insert("F6", "keyboard/f6");
        stringToSoundQueue.nonAlphabetKeys.Insert("F7", "keyboard/f7");
        stringToSoundQueue.nonAlphabetKeys.Insert("F8", "keyboard/f8");
        stringToSoundQueue.nonAlphabetKeys.Insert("F9", "keyboard/f9");
        stringToSoundQueue.nonAlphabetKeys.Insert("F10", "keyboard/f10");
        stringToSoundQueue.nonAlphabetKeys.Insert("F11", "keyboard/f11");
        stringToSoundQueue.nonAlphabetKeys.Insert("F12", "keyboard/f12");
        stringToSoundQueue.nonAlphabetKeys.Insert("SysRq", "keyboard/printscreen");
        stringToSoundQueue.nonAlphabetKeys.Insert("Scroll", "keyboard/scrolllock");
        stringToSoundQueue.nonAlphabetKeys.Insert("Pause", "keyboard/pause");
        stringToSoundQueue.nonAlphabetKeys.Insert("`", "keyboard/tilde");
        stringToSoundQueue.nonAlphabetKeys.Insert("-", "keyboard/minus");
        stringToSoundQueue.nonAlphabetKeys.Insert("=", "keyboard/equals");
        stringToSoundQueue.nonAlphabetKeys.Insert("Backspace", "keyboard/backspace");
        stringToSoundQueue.nonAlphabetKeys.Insert("Tab", "keyboard/tab");
        stringToSoundQueue.nonAlphabetKeys.Insert("CapsLock", "keyboard/capslock");
        stringToSoundQueue.nonAlphabetKeys.Insert("Shift", "keyboard/shift");
        stringToSoundQueue.nonAlphabetKeys.Insert("RShift", "keyboard/shift");
        stringToSoundQueue.nonAlphabetKeys.Insert("Ctrl", "keyboard/control");
        stringToSoundQueue.nonAlphabetKeys.Insert("RCtrl", "keyboard/control");
        stringToSoundQueue.nonAlphabetKeys.Insert("Alt", "keyboard/alt");
        stringToSoundQueue.nonAlphabetKeys.Insert("RAlt", "keyboard/alt");
        stringToSoundQueue.nonAlphabetKeys.Insert("Space", "keyboard/spacebar");
        stringToSoundQueue.nonAlphabetKeys.Insert("Enter", "keyboard/enter");
        stringToSoundQueue.nonAlphabetKeys.Insert("[", "keyboard/openbracket");
        stringToSoundQueue.nonAlphabetKeys.Insert("]", "keyboard/closebracket");
        // For some reason I can't escape backslash
        // stringToSoundQueue.nonAlphabetKeys.Insert("\\", "keyboard/backslash");
        stringToSoundQueue.nonAlphabetKeys.Insert(";", "keyboard/semicolon");
        stringToSoundQueue.nonAlphabetKeys.Insert("'", "keyboard/quote");
        stringToSoundQueue.nonAlphabetKeys.Insert(",", "keyboard/comma");
        stringToSoundQueue.nonAlphabetKeys.Insert(".", "keyboard/period");
        stringToSoundQueue.nonAlphabetKeys.Insert("/", "keyboard/slash");
        stringToSoundQueue.nonAlphabetKeys.Insert("UpArrow", "keyboard/uparrow");
        stringToSoundQueue.nonAlphabetKeys.Insert("DownArrow", "keyboard/downarrow");
        stringToSoundQueue.nonAlphabetKeys.Insert("LeftArrow", "keyboard/leftarrow");
        stringToSoundQueue.nonAlphabetKeys.Insert("RightArrow", "keyboard/rightarrow");
        stringToSoundQueue.nonAlphabetKeys.Insert("Ins", "keyboard/insert");
        stringToSoundQueue.nonAlphabetKeys.Insert("Home", "keyboard/home");
        stringToSoundQueue.nonAlphabetKeys.Insert("Del", "keyboard/delete");
        stringToSoundQueue.nonAlphabetKeys.Insert("End", "keyboard/end");
        stringToSoundQueue.nonAlphabetKeys.Insert("PgUp", "keyboard/pageup");
        stringToSoundQueue.nonAlphabetKeys.Insert("PgDn", "keyboard/pagedown");
        stringToSoundQueue.nonAlphabetKeys.Insert("NumLock", "keyboard/numlock");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP/", "keyboard/kpslash");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP*", "keyboard/kpstar");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP-", "keyboard/kpminus");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP+", "keyboard/kpplus");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP-Enter", "keyboard/kpenter");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP-Equals", "keyboard/kpequals");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP.", "keyboard/kpdecimal");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP0", "keyboard/kp0");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP1", "keyboard/kp1");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP2", "keyboard/kp2");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP3", "keyboard/kp3");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP4", "keyboard/kp4");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP5", "keyboard/kp5");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP6", "keyboard/kp6");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP7", "keyboard/kp7");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP8", "keyboard/kp8");
        stringToSoundQueue.nonAlphabetKeys.Insert("KP9", "keyboard/kp9");

        stringToSoundQueue.nonAlphabetKeys.Insert("Mouse1", "mouse/button1");
        stringToSoundQueue.nonAlphabetKeys.Insert("Mouse2", "mouse/button2");
        stringToSoundQueue.nonAlphabetKeys.Insert("Mouse3", "mouse/button3");
        stringToSoundQueue.nonAlphabetKeys.Insert("Mouse4", "mouse/button4");
        stringToSoundQueue.nonAlphabetKeys.Insert("Mouse5", "mouse/button5");
        stringToSoundQueue.nonAlphabetKeys.Insert("Mouse6", "mouse/button6");
        stringToSoundQueue.nonAlphabetKeys.Insert("Mouse7", "mouse/button7");
        stringToSoundQueue.nonAlphabetKeys.Insert("Mouse8", "mouse/button8");
        stringToSoundQueue.nonAlphabetKeys.Insert("Mouse8", "mouse/button8");
        // There are no mouse button like that
        // stringToSoundQueue.nonAlphabetKeys.Insert("???", "mouse/wheel");
        stringToSoundQueue.nonAlphabetKeys.Insert("MWheelUp", "mouse/wheelup");
        stringToSoundQueue.nonAlphabetKeys.Insert("MWheelDown", "mouse/wheeldown");
        stringToSoundQueue.nonAlphabetKeys.Insert("MWheelRight", "mouse/wheelright");
        stringToSoundQueue.nonAlphabetKeys.Insert("MWheelLeft", "mouse/wheelleft");

        stringToSoundQueue.nonAlphabetKeys.Insert("Joy1", "joy/button1");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy2", "joy/button2");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy3", "joy/button3");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy4", "joy/button4");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy5", "joy/button5");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy6", "joy/button6");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy7", "joy/button7");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy8", "joy/button8");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy9", "joy/button9");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy10", "joy/button10");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy11", "joy/button11");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy12", "joy/button12");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy13", "joy/button13");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy14", "joy/button14");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy15", "joy/button15");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy16", "joy/button16");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy17", "joy/button17");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy18", "joy/button18");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy19", "joy/button19");
        stringToSoundQueue.nonAlphabetKeys.Insert("Joy20", "joy/button20");

        // No idea what those are:
        // stringToSoundQueue.nonAlphabetKeys.Insert("???", "joy/access1");
        // stringToSoundQueue.nonAlphabetKeys.Insert("???", "joy/access2");
        // stringToSoundQueue.nonAlphabetKeys.Insert("???", "joy/access3");
        // stringToSoundQueue.nonAlphabetKeys.Insert("???", "joy/access4");
        // stringToSoundQueue.nonAlphabetKeys.Insert("???", "joy/access5");
        // stringToSoundQueue.nonAlphabetKeys.Insert("???", "joy/access6");
        // stringToSoundQueue.nonAlphabetKeys.Insert("???", "joy/access7");
        // stringToSoundQueue.nonAlphabetKeys.Insert("???", "joy/access8");

        stringToSoundQueue.nonAlphabetKeys.Insert("Axis1Plus", "joy/plus1");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis2Plus", "joy/plus2");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis3Plus", "joy/plus3");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis4Plus", "joy/plus4");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis5Plus", "joy/plus5");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis6Plus", "joy/plus6");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis7Plus", "joy/plus7");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis8Plus", "joy/plus8");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis1Minus", "joy/minus1");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis2Minus", "joy/minus2");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis3Minus", "joy/minus3");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis4Minus", "joy/minus4");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis5Minus", "joy/minus5");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis6Minus", "joy/minus6");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis7Minus", "joy/minus7");
        stringToSoundQueue.nonAlphabetKeys.Insert("Axis8Minus", "joy/minus8");

        stringToSoundQueue.nonAlphabetKeys.Insert("DPadUp", "joy/dpadup");
        stringToSoundQueue.nonAlphabetKeys.Insert("DPadDown", "joy/dpaddown");
        stringToSoundQueue.nonAlphabetKeys.Insert("DPadLeft", "joy/dpadleft");
        stringToSoundQueue.nonAlphabetKeys.Insert("DPadRight", "joy/dpadright");

        stringToSoundQueue.nonAlphabetKeys.Insert("LStickRight", "joy/lstickright");
        stringToSoundQueue.nonAlphabetKeys.Insert("LStickLeft", "joy/lstickleft");
        stringToSoundQueue.nonAlphabetKeys.Insert("LStickDown", "joy/lstickdown");
        stringToSoundQueue.nonAlphabetKeys.Insert("LStickUp", "joy/lstickup");
        stringToSoundQueue.nonAlphabetKeys.Insert("RStickRight", "joy/rstickright");
        stringToSoundQueue.nonAlphabetKeys.Insert("RStickLeft", "joy/rstickleft");
        stringToSoundQueue.nonAlphabetKeys.Insert("RStickDown", "joy/rstickdown");
        stringToSoundQueue.nonAlphabetKeys.Insert("RStickUp", "joy/rstickup");

        stringToSoundQueue.nonAlphabetKeys.Insert("LShoulder", "joy/leftshoulder");
        stringToSoundQueue.nonAlphabetKeys.Insert("RShoulder", "joy/rightshoulder");

        stringToSoundQueue.nonAlphabetKeys.Insert("LThumb", "joy/leftthumb");
        stringToSoundQueue.nonAlphabetKeys.Insert("RThumb", "joy/rightthumb");

        stringToSoundQueue.nonAlphabetKeys.Insert("LTrigger", "joy/lefttrigger");
        stringToSoundQueue.nonAlphabetKeys.Insert("RTrigger", "joy/righttrigger");

        stringToSoundQueue.nonAlphabetKeys.Insert("Pad_A", "joy/pada");
        stringToSoundQueue.nonAlphabetKeys.Insert("Pad_B", "joy/padb");
        stringToSoundQueue.nonAlphabetKeys.Insert("Pad_X", "joy/padx");
        stringToSoundQueue.nonAlphabetKeys.Insert("Pad_Y", "joy/pady");
        stringToSoundQueue.nonAlphabetKeys.Insert("Pad_Start", "joy/padstart");
        stringToSoundQueue.nonAlphabetKeys.Insert("Pad_Back", "joy/padback");

        stringToSoundQueue.nonAlphabetKeys.Insert("Apps", "keyboard/apps");
        stringToSoundQueue.nonAlphabetKeys.Insert("Calculator", "keyboard/calculator");
        stringToSoundQueue.nonAlphabetKeys.Insert("Command", "keyboard/command");
        stringToSoundQueue.nonAlphabetKeys.Insert("Favorites", "keyboard/favorites");
        stringToSoundQueue.nonAlphabetKeys.Insert("Mail", "keyboard/mail");
        stringToSoundQueue.nonAlphabetKeys.Insert("MediaSelect", "keyboard/mediaselect");
        stringToSoundQueue.nonAlphabetKeys.Insert("Mute", "keyboard/mute");
        stringToSoundQueue.nonAlphabetKeys.Insert("MyComputer", "keyboard/mycomp");
        stringToSoundQueue.nonAlphabetKeys.Insert("Play", "keyboard/play");
        stringToSoundQueue.nonAlphabetKeys.Insert("Power", "keyboard/power");
        stringToSoundQueue.nonAlphabetKeys.Insert("PrevTrack", "keyboard/prevtrack");
        stringToSoundQueue.nonAlphabetKeys.Insert("Refresh", "keyboard/refresh");
        stringToSoundQueue.nonAlphabetKeys.Insert("Search", "keyboard/search");
        stringToSoundQueue.nonAlphabetKeys.Insert("Sleep", "keyboard/sleep");
        stringToSoundQueue.nonAlphabetKeys.Insert("Stop", "keyboard/stop");
        stringToSoundQueue.nonAlphabetKeys.Insert("SysRq", "keyboard/sysreq");
        stringToSoundQueue.nonAlphabetKeys.Insert("VolDown", "keyboard/voldown");
        stringToSoundQueue.nonAlphabetKeys.Insert("VolUp", "keyboard/volup");
        stringToSoundQueue.nonAlphabetKeys.Insert("Wake", "keyboard/wake");
        stringToSoundQueue.nonAlphabetKeys.Insert("WebBack", "keyboard/webback");
        stringToSoundQueue.nonAlphabetKeys.Insert("WebForward", "keyboard/webforward");
        stringToSoundQueue.nonAlphabetKeys.Insert("WebHome", "keyboard/webhome");
        stringToSoundQueue.nonAlphabetKeys.Insert("WebStop", "keyboard/webstop");

        stringToSoundQueue.alphabetKeys = Dictionary.Create();
        stringToSoundQueue.alphabetKeys.Insert(" ", "alphabet/Space");
        stringToSoundQueue.alphabetKeys.Insert("a", "alphabet/A");
        stringToSoundQueue.alphabetKeys.Insert("b", "alphabet/B");
        stringToSoundQueue.alphabetKeys.Insert("c", "alphabet/C");
        stringToSoundQueue.alphabetKeys.Insert("d", "alphabet/D");
        stringToSoundQueue.alphabetKeys.Insert("e", "alphabet/E");
        stringToSoundQueue.alphabetKeys.Insert("f", "alphabet/F");
        stringToSoundQueue.alphabetKeys.Insert("g", "alphabet/G");
        stringToSoundQueue.alphabetKeys.Insert("h", "alphabet/H");
        stringToSoundQueue.alphabetKeys.Insert("i", "alphabet/I");
        stringToSoundQueue.alphabetKeys.Insert("j", "alphabet/J");
        stringToSoundQueue.alphabetKeys.Insert("k", "alphabet/K");
        stringToSoundQueue.alphabetKeys.Insert("l", "alphabet/L");
        stringToSoundQueue.alphabetKeys.Insert("m", "alphabet/M");
        stringToSoundQueue.alphabetKeys.Insert("n", "alphabet/N");
        stringToSoundQueue.alphabetKeys.Insert("o", "alphabet/O");
        stringToSoundQueue.alphabetKeys.Insert("p", "alphabet/P");
        stringToSoundQueue.alphabetKeys.Insert("q", "alphabet/Q");
        stringToSoundQueue.alphabetKeys.Insert("r", "alphabet/R");
        stringToSoundQueue.alphabetKeys.Insert("s", "alphabet/S");
        stringToSoundQueue.alphabetKeys.Insert("t", "alphabet/T");
        stringToSoundQueue.alphabetKeys.Insert("u", "alphabet/U");
        stringToSoundQueue.alphabetKeys.Insert("v", "alphabet/V");
        stringToSoundQueue.alphabetKeys.Insert("w", "alphabet/W");
        stringToSoundQueue.alphabetKeys.Insert("x", "alphabet/X");
        stringToSoundQueue.alphabetKeys.Insert("y", "alphabet/Y");
        stringToSoundQueue.alphabetKeys.Insert("z", "alphabet/Z");
        stringToSoundQueue.alphabetKeys.Insert("0", "numbers/000");
        stringToSoundQueue.alphabetKeys.Insert("1", "numbers/001");
        stringToSoundQueue.alphabetKeys.Insert("2", "numbers/002");
        stringToSoundQueue.alphabetKeys.Insert("3", "numbers/003");
        stringToSoundQueue.alphabetKeys.Insert("4", "numbers/004");
        stringToSoundQueue.alphabetKeys.Insert("5", "numbers/005");
        stringToSoundQueue.alphabetKeys.Insert("6", "numbers/006");
        stringToSoundQueue.alphabetKeys.Insert("7", "numbers/007");
        stringToSoundQueue.alphabetKeys.Insert("8", "numbers/008");
        stringToSoundQueue.alphabetKeys.Insert("9", "numbers/009");
        stringToSoundQueue.alphabetKeys.Insert("~", "keyboard/tilde");
        stringToSoundQueue.alphabetKeys.Insert("!", "keyboard/exclamation");
        stringToSoundQueue.alphabetKeys.Insert("@", "keyboard/at");
        stringToSoundQueue.alphabetKeys.Insert("#", "keyboard/pound");
        stringToSoundQueue.alphabetKeys.Insert("$", "keyboard/dollar");
        stringToSoundQueue.alphabetKeys.Insert("%", "keyboard/percent");
        stringToSoundQueue.alphabetKeys.Insert("&", "keyboard/and");
        stringToSoundQueue.alphabetKeys.Insert("*", "keyboard/star");
        stringToSoundQueue.alphabetKeys.Insert("(", "keyboard/openparenthesis");
        stringToSoundQueue.alphabetKeys.Insert(")", "keyboard/closeparenthesis");
        stringToSoundQueue.alphabetKeys.Insert("_", "keyboard/underscore");
        stringToSoundQueue.alphabetKeys.Insert("+", "keyboard/plus");
        stringToSoundQueue.alphabetKeys.Insert("-", "keyboard/minus");
        stringToSoundQueue.alphabetKeys.Insert("=", "keyboard/equals");
        stringToSoundQueue.alphabetKeys.Insert("[", "keyboard/openbracket");
        stringToSoundQueue.alphabetKeys.Insert("]", "keyboard/closebracket");
        // stringToSoundQueue.alphabetKeys.Insert("\\", "keyboard/backslash");
        stringToSoundQueue.alphabetKeys.Insert(":", "keyboard/colon");
        stringToSoundQueue.alphabetKeys.Insert(";", "keyboard/semicolon");
        stringToSoundQueue.alphabetKeys.Insert("'", "keyboard/quote");
        stringToSoundQueue.alphabetKeys.Insert(",", "keyboard/comma");
        stringToSoundQueue.alphabetKeys.Insert(".", "keyboard/period");
        stringToSoundQueue.alphabetKeys.Insert("<", "keyboard/lessthan");
        stringToSoundQueue.alphabetKeys.Insert(">", "keyboard/greaterthan");
        stringToSoundQueue.alphabetKeys.Insert("?", "keyboard/questionmark");
        stringToSoundQueue.alphabetKeys.Insert("/", "keyboard/slash");

        return stringToSoundQueue;
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
        string foundSound = alphabetKeys.At(character);
        if (foundSound == "") { return "alphabet/Space"; }
        return foundSound;
    }

    private string GetNonAlphabetKeySoundName(string keyFromKeybindsMenu)
    {
        string foundSound = nonAlphabetKeys.At(keyFromKeybindsMenu);
        if (foundSound == "") { return "alphabet/Space"; }
        return foundSound;
    }
}
