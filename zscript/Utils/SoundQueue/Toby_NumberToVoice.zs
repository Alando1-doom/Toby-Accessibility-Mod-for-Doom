//Will be obsoleted by Toby_NumberToSoundQueue and removed
class Toby_NumberToVoice ui
{
    ui static void AddStringNumberToQueue(string numberAsString)
    {
        int dotPlace = numberAsString.IndexOf(".", 0);
        string firstPart = numberAsString.Mid(0, dotPlace);
        string secondPart = numberAsString.Mid(dotPlace + 1, numberAsString.Length() - 1);
        secondPart.StripRight("0");
        bool skipZeroAfterDot = true;
        if (secondPart.Length() == 0)
        {
            secondPart = "0";
        }
        if (secondPart == "0" && skipZeroAfterDot == false)
        {
            UnshiftSingleDigitToQueue(secondPart.Mid(0, 1));
            Toby_SoundQueueStaticHandler.UnshiftSound("numbers/dot", -1);
        }
        else if (secondPart != "0")
        {
            for (int i = secondPart.Length() - 1; i >= 0; i--)
            {
                UnshiftSingleDigitToQueue(secondPart.Mid(i, 1));
            }
            Toby_SoundQueueStaticHandler.UnshiftSound("numbers/dot", -1);
        }
        ConvertAndAddToQueue(firstPart.ToInt());
    }

    ui static void ConvertFloatAndAddToQueue(float number)
    {
        string numberAsString = ""..number;
        AddStringNumberToQueue(numberAsString);
    }

    ui static void ConvertAndAddToQueue(int number)
    {
        int power = 0;
        bool hasMinus = false;
        string numberAsString = ""..number;
        if (numberAsString.Mid(1,1) == "-")
        {
            numberAsString = numberAsString.Mid(1, numberAsString.Length() - 1);
            hasMinus = true;
        }
        string numberSegment;
        bool lastDigits = false;
        do
        {
            if (numberAsString.Length() != 0)
            {
                UnshiftPowers(power);
            }
            if (numberAsString.Length() >= 3)
            {
                numberSegment = ""..numberAsString.Mid(numberAsString.Length() - 3, 3);
                numberAsString = ""..numberAsString.Mid(0, numberAsString.Length() - 3);
                power++;
            }
            else
            {
                lastDigits = true;
                numberSegment = numberAsString;
                if (numberSegment.Length() < 2)
                {
                    numberSegment = "00"..numberSegment;
                }
                if (numberSegment.Length() < 3)
                {
                    numberSegment = "0"..numberSegment;
                }
                if (numberSegment == "000" && power == 0)
                {
                    Toby_SoundQueueStaticHandler.UnshiftSound("numbers/000", -1);
                    return;
                }
            }
            UnshiftTripleDigits(numberSegment, lastDigits);
        } while (lastDigits == false);
        if (hasMinus)
        {
            Toby_SoundQueueStaticHandler.UnshiftSound("numbers/minus", -1);
        }
    }

    ui static void UnshiftPowers(int digit)
    {
        if (digit == 1) Toby_SoundQueueStaticHandler.UnshiftSound("numbers/thousand", -1);
        if (digit == 2) Toby_SoundQueueStaticHandler.UnshiftSound("numbers/million", -1);
        if (digit == 3) Toby_SoundQueueStaticHandler.UnshiftSound("numbers/billion", -1);
        if (digit == 4) Toby_SoundQueueStaticHandler.UnshiftSound("numbers/trillion", -1);
    }

    ui static void UnshiftSingleDigitToQueue(string digit)
    {
        Toby_SoundQueueStaticHandler.UnshiftSound(GetSingleDigitSoundName(digit), -1);
    }

    ui static void AddSingleDigitToQueue(string digit)
    {
        Toby_SoundQueueStaticHandler.AddSound(GetSingleDigitSoundName(digit), -1);
    }

    ui static void UnshiftDoubleDigits(string doubleDigits)
    {
        if (doubleDigits == "10") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/010", -1);
        if (doubleDigits == "11") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/011", -1);
        if (doubleDigits == "12") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/012", -1);
        if (doubleDigits == "13") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/013", -1);
        if (doubleDigits == "14") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/014", -1);
        if (doubleDigits == "15") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/015", -1);
        if (doubleDigits == "16") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/016", -1);
        if (doubleDigits == "17") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/017", -1);
        if (doubleDigits == "18") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/018", -1);
        if (doubleDigits == "19") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/019", -1);
        if (doubleDigits == "20") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/020", -1);
        if (doubleDigits == "30") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/030", -1);
        if (doubleDigits == "40") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/040", -1);
        if (doubleDigits == "50") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/050", -1);
        if (doubleDigits == "60") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/060", -1);
        if (doubleDigits == "70") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/070", -1);
        if (doubleDigits == "80") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/080", -1);
        if (doubleDigits == "90") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/090", -1);
        if (doubleDigits.Mid(1, 1) != "0" && doubleDigits.Mid(0, 1) != "1")
        {
            UnshiftSingleDigitToQueue(doubleDigits.Mid(1, 1));
            if (doubleDigits.Mid(0, 1) != "0")
            {
                if (doubleDigits.Mid(0, 1) == "2") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/020", -1);
                if (doubleDigits.Mid(0, 1) == "3") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/030", -1);
                if (doubleDigits.Mid(0, 1) == "4") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/040", -1);
                if (doubleDigits.Mid(0, 1) == "5") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/050", -1);
                if (doubleDigits.Mid(0, 1) == "6") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/060", -1);
                if (doubleDigits.Mid(0, 1) == "7") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/070", -1);
                if (doubleDigits.Mid(0, 1) == "8") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/080", -1);
                if (doubleDigits.Mid(0, 1) == "9") Toby_SoundQueueStaticHandler.UnshiftSound("numbers/090", -1);
            }
        }
    }

    ui static void UnshiftTripleDigits(string tripleDigits, bool lastDigits)
    {
        string doubleDigits = ""..tripleDigits.Mid(1, 1)..tripleDigits.Mid(2, 1);
        if (doubleDigits != "00")
        {
            UnshiftDoubleDigits(doubleDigits);
            if (!lastDigits)
            {
                Toby_SoundQueueStaticHandler.UnshiftSound("numbers/and", -1);
            }
        }
        if (tripleDigits.Mid(0, 1) != "0")
        {
            Toby_SoundQueueStaticHandler.UnshiftSound("numbers/100", -1);
            UnshiftSingleDigitToQueue(tripleDigits.Mid(0, 1));
        }
    }

    ui static string GetSingleDigitSoundName(string digit)
    {
        string singleDigitSoundName = "alphabet/Space";
        if (digit == "0") singleDigitSoundName = "numbers/000";
        if (digit == "1") singleDigitSoundName = "numbers/001";
        if (digit == "2") singleDigitSoundName = "numbers/002";
        if (digit == "3") singleDigitSoundName = "numbers/003";
        if (digit == "4") singleDigitSoundName = "numbers/004";
        if (digit == "5") singleDigitSoundName = "numbers/005";
        if (digit == "6") singleDigitSoundName = "numbers/006";
        if (digit == "7") singleDigitSoundName = "numbers/007";
        if (digit == "8") singleDigitSoundName = "numbers/008";
        if (digit == "9") singleDigitSoundName = "numbers/009";
        return singleDigitSoundName;
    }
}
