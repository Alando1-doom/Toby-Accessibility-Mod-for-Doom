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
            string label = item.GetTag();
            string command = item.GetClassName();
            mDesc.mItems.Push(new("Toby_ItemsMenuItem").Init(label, command));
        }
    }
}
