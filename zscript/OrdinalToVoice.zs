class OrdinalToVoice ui
{
    ui static void ConvertFloatAndAddToQueue(float number)
    {
        string numberAsString = ""..number;
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
            SoundQueue.UnshiftSound("fvox/dot", -1);
        }
        else if (secondPart != "0")
        {
            for (int i = secondPart.Length() - 1; i >= 0; i--)
            {
                UnshiftSingleDigitToQueue(secondPart.Mid(i, 1));
            }
            SoundQueue.UnshiftSound("fvox/dot", -1);
        }
        ConvertAndAddToQueue(firstPart.ToInt());
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
                    SoundQueue.UnshiftSound("fvox/000", -1);
                    return;
                }
            }
            UnshiftTripleDigits(numberSegment, lastDigits);
        } while (lastDigits == false);
        if (hasMinus)
        {
            SoundQueue.UnshiftSound("fvox/minus", -1);
        }
    }

    ui static void UnshiftPowers(int digit)
    {
        if (digit == 1) SoundQueue.UnshiftSound("fvox/thousand", -1);
        if (digit == 2) SoundQueue.UnshiftSound("fvox/million", -1);
        if (digit == 3) SoundQueue.UnshiftSound("fvox/billion", -1);
        if (digit == 4) SoundQueue.UnshiftSound("fvox/trillion", -1);
    }

    ui static void UnshiftSingleDigitToQueue(string digit)
    {
        SoundQueue.UnshiftSound(GetSingleOrdinalDigitSoundName(digit), -1);
    }

    ui static void AddSingleDigitToQueue(string digit)
    {
        SoundQueue.AddSound(GetSingleOrdinalDigitSoundName(digit), -1);
    }

    ui static void UnshiftDoubleDigits(string doubleDigits)
    {
        if (doubleDigits == "10") SoundQueue.UnshiftSound("numbers/10th", -1);
        if (doubleDigits == "11") SoundQueue.UnshiftSound("numbers/11th", -1);
        if (doubleDigits == "12") SoundQueue.UnshiftSound("numbers/12th", -1);
        if (doubleDigits == "13") SoundQueue.UnshiftSound("numbers/13th", -1);
        if (doubleDigits == "14") SoundQueue.UnshiftSound("numbers/14th", -1);
        if (doubleDigits == "15") SoundQueue.UnshiftSound("numbers/15th", -1);
        if (doubleDigits == "16") SoundQueue.UnshiftSound("numbers/16th", -1);
        if (doubleDigits == "17") SoundQueue.UnshiftSound("numbers/17th", -1);
        if (doubleDigits == "18") SoundQueue.UnshiftSound("numbers/18th", -1);
        if (doubleDigits == "19") SoundQueue.UnshiftSound("numbers/19th", -1);
        if (doubleDigits == "20") SoundQueue.UnshiftSound("numbers/20th", -1);
        if (doubleDigits == "30") SoundQueue.UnshiftSound("numbers/30th", -1);
        if (doubleDigits == "40") SoundQueue.UnshiftSound("numbers/40th", -1);
        if (doubleDigits == "50") SoundQueue.UnshiftSound("numbers/50th", -1);
        if (doubleDigits == "60") SoundQueue.UnshiftSound("numbers/60th", -1);
        if (doubleDigits == "70") SoundQueue.UnshiftSound("numbers/70th", -1);
        if (doubleDigits == "80") SoundQueue.UnshiftSound("numbers/80th", -1);
        if (doubleDigits == "90") SoundQueue.UnshiftSound("numbers/90th", -1);
        if (doubleDigits.Mid(1, 1) != "0" && doubleDigits.Mid(0, 1) != "1")
        {
            UnshiftSingleDigitToQueue(doubleDigits.Mid(1, 1));
            if (doubleDigits.Mid(0, 1) != "0")
            {
                if (doubleDigits.Mid(0, 1) == "2") SoundQueue.UnshiftSound("fvox/020", -1);
                if (doubleDigits.Mid(0, 1) == "3") SoundQueue.UnshiftSound("fvox/030", -1);
                if (doubleDigits.Mid(0, 1) == "4") SoundQueue.UnshiftSound("fvox/040", -1);
                if (doubleDigits.Mid(0, 1) == "5") SoundQueue.UnshiftSound("fvox/050", -1);
                if (doubleDigits.Mid(0, 1) == "6") SoundQueue.UnshiftSound("fvox/060", -1);
                if (doubleDigits.Mid(0, 1) == "7") SoundQueue.UnshiftSound("fvox/070", -1);
                if (doubleDigits.Mid(0, 1) == "8") SoundQueue.UnshiftSound("fvox/080", -1);
                if (doubleDigits.Mid(0, 1) == "9") SoundQueue.UnshiftSound("fvox/090", -1);
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
                SoundQueue.UnshiftSound("fvox/and", -1);
            }
        }
        if (tripleDigits.Mid(0, 1) != "0")
        {
            SoundQueue.UnshiftSound("fvox/100", -1);
            UnshiftSingleDigitToQueue(tripleDigits.Mid(0, 1));
        }
    }

    ui static string GetSingleOrdinalDigitSoundName(string digit)
    {
        string singleOrdinalDigitSoundName ="alphabet/Space";
        if (digit == "0") singleOrdinalDigitSoundName = "numbers/0th";
        if (digit == "1") singleOrdinalDigitSoundName = "numbers/1st";
        if (digit == "2") singleOrdinalDigitSoundName = "numbers/2nd";
        if (digit == "3") singleOrdinalDigitSoundName = "numbers/3rd";
        if (digit == "4") singleOrdinalDigitSoundName = "numbers/4th";
        if (digit == "5") singleOrdinalDigitSoundName = "numbers/5th";
        if (digit == "6") singleOrdinalDigitSoundName = "numbers/6th";
        if (digit == "7") singleOrdinalDigitSoundName = "numbers/7th";
        if (digit == "8") singleOrdinalDigitSoundName = "numbers/8th";
        if (digit == "9") singleOrdinalDigitSoundName = "numbers/9th";
        return singleOrdinalDigitSoundName;
    }
}
