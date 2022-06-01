class NumberToVoice ui
{
    ui static void ConvertFloatAndAddToQueue(float number)
    {
        string numberAsString = ""..number;
        //Console.Printf("numberAsString: "..numberAsString);
        int dotPlace = numberAsString.IndexOf(".", 0);
        string firstPart = numberAsString.Mid(0, dotPlace);
        //Console.Printf("firstPart: "..firstPart);
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
            //Console.Printf("numberAsString: "..numberAsString);   
            //Console.Printf("power: "..power);   
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
                    SoundQueue.UnshiftSound("fvox/000", -1); //ZERO
                    return;
                }
            }
            //Console.Printf("numberSegment 2: "..numberSegment);
            UnshiftTripleDigits(numberSegment, lastDigits);
        } while (lastDigits == false);
        if (hasMinus)
        {
            SoundQueue.UnshiftSound("fvox/minus", -1); //Minus
        }
    }

    ui static void UnshiftPowers(int digit)
    {
        if (digit == 1) SoundQueue.UnshiftSound("fvox/thousand", -1); //thousand
        if (digit == 2) SoundQueue.UnshiftSound("fvox/million", -1); //million
        if (digit == 3) SoundQueue.UnshiftSound("fvox/billion", -1); //billion
        if (digit == 4) SoundQueue.UnshiftSound("fvox/trillion", -1); //trillion
    }

    ui static void UnshiftSingleDigitToQueue(string digit)
    {
        if (digit == "0") SoundQueue.UnshiftSound("fvox/000", -1);
        if (digit == "1") SoundQueue.UnshiftSound("fvox/001", -1);
        if (digit == "2") SoundQueue.UnshiftSound("fvox/002", -1);
        if (digit == "3") SoundQueue.UnshiftSound("fvox/003", -1);
        if (digit == "4") SoundQueue.UnshiftSound("fvox/004", -1);
        if (digit == "5") SoundQueue.UnshiftSound("fvox/005", -1);
        if (digit == "6") SoundQueue.UnshiftSound("fvox/006", -1);
        if (digit == "7") SoundQueue.UnshiftSound("fvox/007", -1);
        if (digit == "8") SoundQueue.UnshiftSound("fvox/008", -1);
        if (digit == "9") SoundQueue.UnshiftSound("fvox/009", -1);
    }

    ui static void AddSingleDigitToQueue(string digit)
    {
        if (digit == "0") SoundQueue.AddSound("fvox/000", -1);
        if (digit == "1") SoundQueue.AddSound("fvox/001", -1);
        if (digit == "2") SoundQueue.AddSound("fvox/002", -1);
        if (digit == "3") SoundQueue.AddSound("fvox/003", -1);
        if (digit == "4") SoundQueue.AddSound("fvox/004", -1);
        if (digit == "5") SoundQueue.AddSound("fvox/005", -1);
        if (digit == "6") SoundQueue.AddSound("fvox/006", -1);
        if (digit == "7") SoundQueue.AddSound("fvox/007", -1);
        if (digit == "8") SoundQueue.AddSound("fvox/008", -1);
        if (digit == "9") SoundQueue.AddSound("fvox/009", -1);
    }

    ui static void UnshiftDoubleDigits(string doubleDigits)
    {
        if (doubleDigits == "10") SoundQueue.UnshiftSound("fvox/010", -1);
        if (doubleDigits == "11") SoundQueue.UnshiftSound("fvox/011", -1);
        if (doubleDigits == "12") SoundQueue.UnshiftSound("fvox/012", -1);
        if (doubleDigits == "13") SoundQueue.UnshiftSound("fvox/013", -1);
        if (doubleDigits == "14") SoundQueue.UnshiftSound("fvox/014", -1);
        if (doubleDigits == "15") SoundQueue.UnshiftSound("fvox/015", -1);
        if (doubleDigits == "16") SoundQueue.UnshiftSound("fvox/016", -1);
        if (doubleDigits == "17") SoundQueue.UnshiftSound("fvox/017", -1);
        if (doubleDigits == "18") SoundQueue.UnshiftSound("fvox/018", -1);
        if (doubleDigits == "19") SoundQueue.UnshiftSound("fvox/019", -1);
        if (doubleDigits == "20") SoundQueue.UnshiftSound("fvox/020", -1);
        if (doubleDigits == "30") SoundQueue.UnshiftSound("fvox/030", -1);
        if (doubleDigits == "40") SoundQueue.UnshiftSound("fvox/040", -1);
        if (doubleDigits == "50") SoundQueue.UnshiftSound("fvox/050", -1);
        if (doubleDigits == "60") SoundQueue.UnshiftSound("fvox/060", -1);
        if (doubleDigits == "70") SoundQueue.UnshiftSound("fvox/070", -1);
        if (doubleDigits == "80") SoundQueue.UnshiftSound("fvox/080", -1);
        if (doubleDigits == "90") SoundQueue.UnshiftSound("fvox/090", -1);
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
}