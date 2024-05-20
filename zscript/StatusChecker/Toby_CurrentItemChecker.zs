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
}
