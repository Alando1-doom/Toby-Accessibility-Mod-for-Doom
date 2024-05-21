class Toby_NumberToSoundQueue
{
    Toby_SoundQueue soundQueue;

    static Toby_NumberToSoundQueue Create()
    {
        Toby_NumberToSoundQueue numberToSoundQueue = new("Toby_NumberToSoundQueue");
        numberToSoundQueue.soundQueue = new("Toby_SoundQueue");
        return numberToSoundQueue;
    }

    void Reset()
    {
        soundQueue = new("Toby_SoundQueue");
    }

    Toby_SoundQueue CreateQueueFromInt(int number)
    {
        Reset();
        ConvertAndAddToQueue(number, false);
        return soundQueue;
    }

    Toby_SoundQueue CreateOrdinalQueueFromInt(int number)
    {
        Reset();
        ConvertAndAddToQueue(number, true);
        return soundQueue;
    }

    Toby_SoundQueue CreateQueueFromFloat(float number)
    {
        Reset();
        ConvertFloatAndAddToQueue(number);
        return soundQueue;
    }

    Toby_SoundQueue CreateQueueFromFloatAsString(string numberAsString)
    {
        Reset();
        AddStringNumberToQueue(numberAsString, false);
        return soundQueue;
    }

    private void AddStringNumberToQueue(string numberAsString, bool isOrdinal)
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
            UnshiftSingleDigitToQueue(secondPart.Mid(0, 1), isOrdinal);
            soundQueue.UnshiftSound("numbers/dot", -1);
        }
        else if (secondPart != "0")
        {
            for (int i = secondPart.Length() - 1; i >= 0; i--)
            {
                UnshiftSingleDigitToQueue(secondPart.Mid(i, 1), isOrdinal);
            }
            soundQueue.UnshiftSound("numbers/dot", -1);
        }
        ConvertAndAddToQueue(firstPart.ToInt(), isOrdinal);
    }

    private void ConvertFloatAndAddToQueue(float number)
    {
        string numberAsString = ""..number;
        AddStringNumberToQueue(numberAsString, false);
    }

    private void ConvertAndAddToQueue(int number, bool isOrdinal)
    {
        int power = 0;
        bool hasMinus = false;
        string numberAsString = ""..number;
        if (numberAsString.Mid(0,1) == "-")
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
                    soundQueue.UnshiftSound("numbers/000", -1);
                    return;
                }
            }
            UnshiftTripleDigits(numberSegment, lastDigits, isOrdinal);
        } while (lastDigits == false);
        if (hasMinus)
        {
            soundQueue.UnshiftSound("numbers/minus", -1);
        }
    }

    private void UnshiftPowers(int digit)
    {
        if (digit == 1) soundQueue.UnshiftSound("numbers/thousand", -1);
        if (digit == 2) soundQueue.UnshiftSound("numbers/million", -1);
        if (digit == 3) soundQueue.UnshiftSound("numbers/billion", -1);
        if (digit == 4) soundQueue.UnshiftSound("numbers/trillion", -1);
    }

    private void UnshiftSingleDigitToQueue(string digit, bool isOrdinal)
    {
        soundQueue.UnshiftSound(GetSingleDigitSoundName(digit, isOrdinal), -1);
    }

    private void UnshiftDoubleDigits(string doubleDigits, bool isOrdinal)
    {
        if (!isOrdinal)
        {
            if (doubleDigits == "10") soundQueue.UnshiftSound("numbers/010", -1);
            if (doubleDigits == "11") soundQueue.UnshiftSound("numbers/011", -1);
            if (doubleDigits == "12") soundQueue.UnshiftSound("numbers/012", -1);
            if (doubleDigits == "13") soundQueue.UnshiftSound("numbers/013", -1);
            if (doubleDigits == "14") soundQueue.UnshiftSound("numbers/014", -1);
            if (doubleDigits == "15") soundQueue.UnshiftSound("numbers/015", -1);
            if (doubleDigits == "16") soundQueue.UnshiftSound("numbers/016", -1);
            if (doubleDigits == "17") soundQueue.UnshiftSound("numbers/017", -1);
            if (doubleDigits == "18") soundQueue.UnshiftSound("numbers/018", -1);
            if (doubleDigits == "19") soundQueue.UnshiftSound("numbers/019", -1);
            if (doubleDigits == "20") soundQueue.UnshiftSound("numbers/020", -1);
            if (doubleDigits == "30") soundQueue.UnshiftSound("numbers/030", -1);
            if (doubleDigits == "40") soundQueue.UnshiftSound("numbers/040", -1);
            if (doubleDigits == "50") soundQueue.UnshiftSound("numbers/050", -1);
            if (doubleDigits == "60") soundQueue.UnshiftSound("numbers/060", -1);
            if (doubleDigits == "70") soundQueue.UnshiftSound("numbers/070", -1);
            if (doubleDigits == "80") soundQueue.UnshiftSound("numbers/080", -1);
            if (doubleDigits == "90") soundQueue.UnshiftSound("numbers/090", -1);
        }
        if (isOrdinal)
        {
            if (doubleDigits == "10") soundQueue.UnshiftSound("numbers/10th", -1);
            if (doubleDigits == "11") soundQueue.UnshiftSound("numbers/11th", -1);
            if (doubleDigits == "12") soundQueue.UnshiftSound("numbers/12th", -1);
            if (doubleDigits == "13") soundQueue.UnshiftSound("numbers/13th", -1);
            if (doubleDigits == "14") soundQueue.UnshiftSound("numbers/14th", -1);
            if (doubleDigits == "15") soundQueue.UnshiftSound("numbers/15th", -1);
            if (doubleDigits == "16") soundQueue.UnshiftSound("numbers/16th", -1);
            if (doubleDigits == "17") soundQueue.UnshiftSound("numbers/17th", -1);
            if (doubleDigits == "18") soundQueue.UnshiftSound("numbers/18th", -1);
            if (doubleDigits == "19") soundQueue.UnshiftSound("numbers/19th", -1);
            if (doubleDigits == "20") soundQueue.UnshiftSound("numbers/20th", -1);
            if (doubleDigits == "30") soundQueue.UnshiftSound("numbers/30th", -1);
            if (doubleDigits == "40") soundQueue.UnshiftSound("numbers/40th", -1);
            if (doubleDigits == "50") soundQueue.UnshiftSound("numbers/50th", -1);
            if (doubleDigits == "60") soundQueue.UnshiftSound("numbers/60th", -1);
            if (doubleDigits == "70") soundQueue.UnshiftSound("numbers/70th", -1);
            if (doubleDigits == "80") soundQueue.UnshiftSound("numbers/80th", -1);
            if (doubleDigits == "90") soundQueue.UnshiftSound("numbers/90th", -1);
        }
        if (doubleDigits.Mid(1, 1) != "0" && doubleDigits.Mid(0, 1) != "1")
        {
            UnshiftSingleDigitToQueue(doubleDigits.Mid(1, 1), isOrdinal);
            if (doubleDigits.Mid(0, 1) != "0")
            {
                if (doubleDigits.Mid(0, 1) == "2") soundQueue.UnshiftSound("numbers/020", -1);
                if (doubleDigits.Mid(0, 1) == "3") soundQueue.UnshiftSound("numbers/030", -1);
                if (doubleDigits.Mid(0, 1) == "4") soundQueue.UnshiftSound("numbers/040", -1);
                if (doubleDigits.Mid(0, 1) == "5") soundQueue.UnshiftSound("numbers/050", -1);
                if (doubleDigits.Mid(0, 1) == "6") soundQueue.UnshiftSound("numbers/060", -1);
                if (doubleDigits.Mid(0, 1) == "7") soundQueue.UnshiftSound("numbers/070", -1);
                if (doubleDigits.Mid(0, 1) == "8") soundQueue.UnshiftSound("numbers/080", -1);
                if (doubleDigits.Mid(0, 1) == "9") soundQueue.UnshiftSound("numbers/090", -1);
            }
        }
    }

    private void UnshiftTripleDigits(string tripleDigits, bool lastDigits, bool isOrdinal)
    {
        string doubleDigits = ""..tripleDigits.Mid(1, 1)..tripleDigits.Mid(2, 1);
        if (doubleDigits != "00")
        {
            UnshiftDoubleDigits(doubleDigits, isOrdinal);
            if (!lastDigits)
            {
                soundQueue.UnshiftSound("numbers/and", -1);
            }
        }
        if (tripleDigits.Mid(0, 1) != "0")
        {
            soundQueue.UnshiftSound("numbers/100", -1);
            UnshiftSingleDigitToQueue(tripleDigits.Mid(0, 1), isOrdinal);
        }
    }

    private string GetSingleDigitSoundName(string digit, bool isOrdinal)
    {
        string singleDigitSoundName = "alphabet/Space";
        if (!isOrdinal)
        {
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
        }
        if (isOrdinal)
        {
            if (digit == "0") singleDigitSoundName = "numbers/0th";
            if (digit == "1") singleDigitSoundName = "numbers/1st";
            if (digit == "2") singleDigitSoundName = "numbers/2nd";
            if (digit == "3") singleDigitSoundName = "numbers/3rd";
            if (digit == "4") singleDigitSoundName = "numbers/4th";
            if (digit == "5") singleDigitSoundName = "numbers/5th";
            if (digit == "6") singleDigitSoundName = "numbers/6th";
            if (digit == "7") singleDigitSoundName = "numbers/7th";
            if (digit == "8") singleDigitSoundName = "numbers/8th";
            if (digit == "9") singleDigitSoundName = "numbers/9th";
        }

        return singleDigitSoundName;
    }
}
