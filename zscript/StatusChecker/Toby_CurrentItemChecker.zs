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
        PlayerPawn playerActor = (PlayerPawn)(player.mo);
        if (!playerActor) { return; }

        Inventory item = playerActor.InvSel;
        if (!item) { return; }
        if (item.amount == 0) { return; }

        string textToPrint = GetInventoryItemInfoString(item);
        Toby_Logger.ConsoleOutputModeMessage(textToPrint);
    }

    ui static string GetInventoryItemInfoString(Inventory item)
    {
        string textToPrint = "";
        if (!item) { return textToPrint; }
        if (item.amount == 0) { return textToPrint; }
        textToPrint = item.GetTag() .. " " .. item.amount;

        return textToPrint;
    }
}
