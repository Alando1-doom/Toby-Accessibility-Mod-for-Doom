class Toby_ItemsMenu : OptionMenu
{
    override void Init(Menu parent, OptionMenuDescriptor desc)
    {
        Super.Init(parent, desc);
        mDesc.mItems.Clear();
        mDesc.mSelectedItem = -1;
        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        for (Inventory item = playerActor.inv; item; item = item.inv)
        {
            if (!item) { continue; }
            if (!item.bInvBar) { continue; }
            string label = Toby_CurrentItemChecker.GetInventoryItemInfoString(item);
            string command = item.GetClassName();
            Toby_ItemsMenuItem menuItem = (Toby_ItemsMenuItem)(new("Toby_ItemsMenuItem").Init(label, command));

            Toby_SoundBindingsLoaderStaticHandler bindings = Toby_SoundBindingsLoaderStaticHandler.GetInstance();
            Toby_SoundQueue queue = Toby_SelectionNarrator.GetItemSoundQueue(
                command,
                item.amount,
                bindings.itemsSoundBindingsContainer
            );
            menuItem.SetSoundQueue(queue);
            mDesc.mItems.Push(menuItem);
        }
    }
}
