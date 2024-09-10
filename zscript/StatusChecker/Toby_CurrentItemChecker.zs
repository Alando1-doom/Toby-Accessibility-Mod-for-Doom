class Toby_CurrentItemChecker
{
    ui static void CheckCurrentItem(PlayerInfo player, Toby_SoundBindingsContainer bindings)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        string currentItem = "";
        int amount = 0;
        if (!player.mo.InvSel) { return; }
        Inventory inv = player.mo.InvSel;
        currentItem = inv.GetClassName();
        amount = inv.amount;
        Toby_SelectionNarrator.NarrateItemName(currentItem, amount, bindings);
    }

    ui static void CheckCurrentItemTextOnly(PlayerInfo player)
    {
        if (!player) { return; }
        if (!player.mo) { return; }
        Actor playerActor = player.mo;

        string currentItem = "";
        int amount = 0;
        if (!player.mo.InvSel) { return; }
        Inventory inv = player.mo.InvSel;
        currentItem = inv.GetTag();
        amount = inv.amount;
        if (amount == 0) { return; }
        string textToPrint = "" .. currentItem .. " " .. inv.amount;
        Toby_Logger.ConsoleOutputModeMessage(textToPrint);
    }
}
