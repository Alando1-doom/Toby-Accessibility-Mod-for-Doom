class StringToVoice ui
{
    ui static void ConvertAndAddToQueue(string text)
    {
        for (int i = 0; i < text.Length(); i++)
        {
            string letter = text.Mid(i, 1).MakeLower();
            if (letter == "a") SoundQueue.AddSound("alphabet/A", -1);
            if (letter == "b") SoundQueue.AddSound("alphabet/B", -1);
            if (letter == "c") SoundQueue.AddSound("alphabet/C", -1);
            if (letter == "d") SoundQueue.AddSound("alphabet/D", -1);
            if (letter == "e") SoundQueue.AddSound("alphabet/E", -1);
            if (letter == "f") SoundQueue.AddSound("alphabet/F", -1);
            if (letter == "g") SoundQueue.AddSound("alphabet/G", -1);
            if (letter == "h") SoundQueue.AddSound("alphabet/H", -1);
            if (letter == "i") SoundQueue.AddSound("alphabet/I", -1);
            if (letter == "j") SoundQueue.AddSound("alphabet/J", -1);
            if (letter == "k") SoundQueue.AddSound("alphabet/K", -1);
            if (letter == "l") SoundQueue.AddSound("alphabet/L", -1);
            if (letter == "m") SoundQueue.AddSound("alphabet/M", -1);
            if (letter == "n") SoundQueue.AddSound("alphabet/N", -1);
            if (letter == "o") SoundQueue.AddSound("alphabet/O", -1);
            if (letter == "p") SoundQueue.AddSound("alphabet/P", -1);
            if (letter == "q") SoundQueue.AddSound("alphabet/Q", -1);
            if (letter == "r") SoundQueue.AddSound("alphabet/R", -1);
            if (letter == "s") SoundQueue.AddSound("alphabet/S", -1);
            if (letter == "t") SoundQueue.AddSound("alphabet/T", -1);
            if (letter == "u") SoundQueue.AddSound("alphabet/U", -1);
            if (letter == "v") SoundQueue.AddSound("alphabet/V", -1);
            if (letter == "w") SoundQueue.AddSound("alphabet/W", -1);
            if (letter == "x") SoundQueue.AddSound("alphabet/X", -1);
            if (letter == "y") SoundQueue.AddSound("alphabet/Y", -1);
            if (letter == "z") SoundQueue.AddSound("alphabet/Z", -1);
            if (letter == " ") SoundQueue.AddSound("alphabet/Space", -1);
			if (letter == "0") SoundQueue.AddSound("numbers/000", -1);
			if (letter == "1") SoundQueue.AddSound("numbers/001", -1);
			if (letter == "2") SoundQueue.AddSound("numbers/002", -1);
			if (letter == "3") SoundQueue.AddSound("numbers/003", -1);
			if (letter == "4") SoundQueue.AddSound("numbers/004", -1);
			if (letter == "5") SoundQueue.AddSound("numbers/005", -1);
			if (letter == "6") SoundQueue.AddSound("numbers/006", -1);
			if (letter == "7") SoundQueue.AddSound("numbers/007", -1);
			if (letter == "8") SoundQueue.AddSound("numbers/008", -1);
			if (letter == "9") SoundQueue.AddSound("numbers/009", -1);
        }
    }

    ui static void ConvertAndAddToQueueReverse(string text)
    {
        for (int i = text.Length()-1; i >= 0; i--)
        {
            string letter = text.Mid(i, 1).MakeLower();
            if (letter == "a") SoundQueue.UnshiftSound("alphabet/A", -1);
            if (letter == "b") SoundQueue.UnshiftSound("alphabet/B", -1);
            if (letter == "c") SoundQueue.UnshiftSound("alphabet/C", -1);
            if (letter == "d") SoundQueue.UnshiftSound("alphabet/D", -1);
            if (letter == "e") SoundQueue.UnshiftSound("alphabet/E", -1);
            if (letter == "f") SoundQueue.UnshiftSound("alphabet/F", -1);
            if (letter == "g") SoundQueue.UnshiftSound("alphabet/G", -1);
            if (letter == "h") SoundQueue.UnshiftSound("alphabet/H", -1);
            if (letter == "i") SoundQueue.UnshiftSound("alphabet/I", -1);
            if (letter == "j") SoundQueue.UnshiftSound("alphabet/J", -1);
            if (letter == "k") SoundQueue.UnshiftSound("alphabet/K", -1);
            if (letter == "l") SoundQueue.UnshiftSound("alphabet/L", -1);
            if (letter == "m") SoundQueue.UnshiftSound("alphabet/M", -1);
            if (letter == "n") SoundQueue.UnshiftSound("alphabet/N", -1);
            if (letter == "o") SoundQueue.UnshiftSound("alphabet/O", -1);
            if (letter == "p") SoundQueue.UnshiftSound("alphabet/P", -1);
            if (letter == "q") SoundQueue.UnshiftSound("alphabet/Q", -1);
            if (letter == "r") SoundQueue.UnshiftSound("alphabet/R", -1);
            if (letter == "s") SoundQueue.UnshiftSound("alphabet/S", -1);
            if (letter == "t") SoundQueue.UnshiftSound("alphabet/T", -1);
            if (letter == "u") SoundQueue.UnshiftSound("alphabet/U", -1);
            if (letter == "v") SoundQueue.UnshiftSound("alphabet/V", -1);
            if (letter == "w") SoundQueue.UnshiftSound("alphabet/W", -1);
            if (letter == "x") SoundQueue.UnshiftSound("alphabet/X", -1);
            if (letter == "y") SoundQueue.UnshiftSound("alphabet/Y", -1);
            if (letter == "z") SoundQueue.UnshiftSound("alphabet/Z", -1);
            if (letter == " ") SoundQueue.UnshiftSound("alphabet/Space", -1);
			if (letter == "0") SoundQueue.UnshiftSound("numbers/000", -1);
			if (letter == "1") SoundQueue.UnshiftSound("numbers/001", -1);
			if (letter == "2") SoundQueue.UnshiftSound("numbers/002", -1);
			if (letter == "3") SoundQueue.UnshiftSound("numbers/003", -1);
			if (letter == "4") SoundQueue.UnshiftSound("numbers/004", -1);
			if (letter == "5") SoundQueue.UnshiftSound("numbers/005", -1);
			if (letter == "6") SoundQueue.UnshiftSound("numbers/006", -1);
			if (letter == "7") SoundQueue.UnshiftSound("numbers/007", -1);
			if (letter == "8") SoundQueue.UnshiftSound("numbers/008", -1);
			if (letter == "9") SoundQueue.UnshiftSound("numbers/009", -1);
        }
    }
}
