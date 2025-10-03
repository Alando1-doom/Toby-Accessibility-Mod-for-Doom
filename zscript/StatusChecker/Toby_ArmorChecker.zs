class Toby_ArmorChecker
{
    static const string HexenArmorPieceNames[] =
    {
        "Mesh armor",
        "Falcon shield",
        "Platinum helm",
        "Amulet of warding",
        "Natural armor"
    };

    static const string HexenArmorPieceSounds[] =
    {
        "toby/hexenarmorchecker/mesharmor",
        "toby/hexenarmorchecker/falconshield",
        "toby/hexenarmorchecker/platinumhelm",
        "toby/hexenarmorchecker/amuletofwarding",
        "toby/hexenarmorchecker/naturalarmor"
    };

    ui static void CheckArmor(PlayerInfo player, Toby_SoundBindingsContainer armorSoundBindingsContainer)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;

        BasicArmor armor = BasicArmor(playerActor.FindInventory("BasicArmor"));
        HexenArmor hexenArmor = HexenArmor(playerActor.FindInventory("HexenArmor"));
        if (!armor) { return; }
        if (!hexenArmor) { return; }

        if (Toby_ArmorChecker.GetHexenTotalArmorValue(hexenArmor, false) != 0)
        {
            int mode = CVar.GetCVar("Toby_HexenArmorCheckerMode", player).GetInt();
            if (mode == THACM_ONLY_SLOTS)
            {
                Toby_ArmorChecker.CheckHexenArmorOnlySlots(hexenArmor);
                return;
            }
            if (mode == THACM_DETAILED)
            {
                Toby_ArmorChecker.CheckHexenArmorFull(hexenArmor);
                return;
            }
        }

        string soundToPlay = "";
        for (int i = 0; i < armorSoundBindingsContainer.soundBindings.Size(); i++)
        {
            string className = armorSoundBindingsContainer.soundBindings[i].At("ActorClass");
            if (armor.ArmorType == className)
            {
                soundToPlay = armorSoundBindingsContainer.soundBindings[i].At("SoundToPlay");
                break;
            }
        }

        Toby_SoundQueueStaticHandler.AddSound(soundToPlay, -1);
        if (armor.Amount > 0)
        {
            Toby_NumberToSoundQueue numberToSoundQueue = Toby_NumberToSoundQueue.Create();
            Toby_SoundQueueStaticHandler.AddQueue(numberToSoundQueue.CreateQueueFromInt(armor.Amount));
            Toby_SoundQueueStaticHandler.AddSound("stats/general/percent", -1);
        }
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui static void CheckArmorTextOnly(PlayerInfo player)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;

        BasicArmor armor = BasicArmor(playerActor.FindInventory("BasicArmor"));
        HexenArmor hexenArmor = HexenArmor(playerActor.FindInventory("HexenArmor"));
        if (!armor) { return; }
        if (!hexenArmor) { return; }

        if (Toby_ArmorChecker.GetHexenTotalArmorValue(hexenArmor, false) != 0)
        {
            int mode = CVar.GetCVar("Toby_HexenArmorCheckerMode", player).GetInt();
            if (mode == THACM_ONLY_SLOTS)
            {
                Toby_ArmorChecker.CheckHexenArmorOnlySlotsTextOnly(hexenArmor);
                return;
            }
            if (mode == THACM_DETAILED)
            {
                Toby_ArmorChecker.CheckHexenArmorFullTextOnly(hexenArmor);
                return;
            }
        }

        if (armor.Amount > 0)
        {
            class<Actor> cls = armor.ArmorType;
            string textToPrint = GetDefaultByType(cls).GetTag() .. " " .. armor.Amount .. "%";
            Toby_Logger.ConsoleOutputModeMessage(textToPrint);
        }
        else
        {
            string textToPrint = "No armor";
            Toby_Logger.ConsoleOutputModeMessage(textToPrint);
        }
    }

    ui static void CheckHexenArmorFull(HexenArmor hexenArmor)
    {
        Toby_SoundQueueStaticHandler.AddSound("toby/hexenarmorchecker/total", -1);
        int total = Toby_ArmorChecker.GetHexenTotalArmorValue(hexenArmor, true);

        //Total
        Toby_NumberToSoundQueue totalArmorValue = Toby_NumberToSoundQueue.Create();
        Toby_SoundQueueStaticHandler.AddQueue(totalArmorValue.CreateQueueFromInt(total));

        for (uint slot = 0; slot < Toby_ArmorChecker.HexenArmorPieceSounds.Size(); slot++)
        {
            if (hexenArmor.Slots[slot] == 0) { continue; }
            if (slot == 4)
            {
                Toby_SoundQueueStaticHandler.AddSound(Toby_ArmorChecker.HexenArmorPieceSounds[slot], -1);
                Toby_NumberToSoundQueue individualArmorValue = Toby_NumberToSoundQueue.Create();
                Toby_SoundQueueStaticHandler.AddQueue(individualArmorValue.CreateQueueFromInt(Floor(hexenArmor.Slots[slot])));
                continue;
            }
            Toby_SoundQueueStaticHandler.AddSound(Toby_ArmorChecker.HexenArmorPieceSounds[slot], -1);
            Toby_NumberToSoundQueue individualArmorValue = Toby_NumberToSoundQueue.Create();
            Toby_SoundQueueStaticHandler.AddQueue(individualArmorValue.CreateQueueFromInt(Floor(hexenArmor.Slots[slot])));
            Toby_SoundQueueStaticHandler.AddSound("save/of", -1);
            Toby_NumberToSoundQueue individualMaxArmorValue = Toby_NumberToSoundQueue.Create();
            Toby_SoundQueueStaticHandler.AddQueue(individualMaxArmorValue.CreateQueueFromInt(hexenArmor.SlotsIncrement[slot]));
        }
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui static void CheckHexenArmorOnlySlots(HexenArmor hexenArmor)
    {
        Toby_SoundQueueStaticHandler.AddSound("toby/hexenarmorchecker/total", -1);
        int total = Toby_ArmorChecker.GetHexenTotalArmorValue(hexenArmor, true);

        //Total
        Toby_NumberToSoundQueue totalArmorValue = Toby_NumberToSoundQueue.Create();
        Toby_SoundQueueStaticHandler.AddQueue(totalArmorValue.CreateQueueFromInt(total));

        for (uint slot = 0; slot < Toby_ArmorChecker.HexenArmorPieceSounds.Size(); slot++)
        {
            if (hexenArmor.Slots[slot] == 0) { continue; }
            if (slot == 4){ continue; }
            Toby_SoundQueueStaticHandler.AddSound(Toby_ArmorChecker.HexenArmorPieceSounds[slot], -1);
        }
        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }

    ui static void CheckHexenArmorFullTextOnly(HexenArmor hexenArmor)
    {
        string textToPrint = "Total - "..Toby_ArmorChecker.GetHexenTotalArmorValue(hexenArmor, true);
        for (uint slot = 0; slot < Toby_ArmorChecker.HexenArmorPieceNames.Size(); slot++)
        {
            string description = Toby_ArmorChecker.GetSlotDescriptionString(hexenArmor, slot, Toby_ArmorChecker.HexenArmorPieceNames[slot]);
            if (description != "")
            {
                if (textToPrint != "")
                {
                    textToPrint = textToPrint..", ";
                }
                textToPrint = textToPrint..description;
            }
        }
        Toby_Logger.ConsoleOutputModeMessage(textToPrint);
    }

    ui static void CheckHexenArmorOnlySlotsTextOnly(HexenArmor hexenArmor)
    {
        string textToPrint = "Total - "..Toby_ArmorChecker.GetHexenTotalArmorValue(hexenArmor, true);
        for (uint slot = 0; slot < Toby_ArmorChecker.HexenArmorPieceNames.Size(); slot++)
        {
            string description = Toby_ArmorChecker.GetOnlySlotDescriptionString(hexenArmor, slot, Toby_ArmorChecker.HexenArmorPieceNames[slot]);
            if (description != "")
            {
                if (textToPrint != "")
                {
                    textToPrint = textToPrint..", ";
                }
                textToPrint = textToPrint..description;
            }
        }
        Toby_Logger.ConsoleOutputModeMessage(textToPrint);
    }

    ui static int GetHexenTotalArmorValue(HexenArmor hexenArmor, bool includingNatural)
    {
        int sum = 0;
        for (int i = 0; i < 4; i++)
        {
            sum += hexenArmor.Slots[i];
        }
        if (includingNatural)
        {
            sum += hexenArmor.Slots[4];
        }
        return sum;
    }

    ui static string GetSlotDescriptionString(HexenArmor hexenArmor, uint slot, string armorPieceName)
    {
        if (hexenArmor.Slots[slot] == 0) { return ""; }
        if (slot == 4)
        {
            return String.Format("%s - %.0f", armorPieceName, hexenArmor.Slots[slot]);
        }
        return String.Format("%s - %.0f of %.0f", armorPieceName, Floor(hexenArmor.Slots[slot]), hexenArmor.SlotsIncrement[slot]);
    }

    ui static string GetOnlySlotDescriptionString(HexenArmor hexenArmor, uint slot, string armorPieceName)
    {
        if (hexenArmor.Slots[slot] == 0) { return ""; }
        if (slot == 4) { return ""; }
        return armorPieceName;
    }

    ui static void CheckArmorByOutputType(int narrationOutputType, PlayerInfo player, Toby_SoundBindingsContainer armorSoundBindings)
    {
        if (narrationOutputType == TNOT_CONSOLE)
        {
            Toby_ArmorChecker.CheckArmorTextOnly(player);
        }
        else
        {
            Toby_ArmorChecker.CheckArmor(player, armorSoundBindings);
        }
    }
}
