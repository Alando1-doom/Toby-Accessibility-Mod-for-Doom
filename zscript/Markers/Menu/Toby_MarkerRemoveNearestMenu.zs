class Toby_MarkerRemoveNearestMenu : OptionMenu
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

        Toby_MarkerHandler handler = Toby_MarkerHandler.GetInstanceUi();
        for (uint i = 0; i < handler.recordContainers[consoleplayer].records.Size(); i++) {
            string description = handler.recordContainers[consoleplayer].records[i].markerDescription;
            int markerId = handler.recordContainers[consoleplayer].records[i].id;
            Actor markerActor = handler.recordContainers[consoleplayer].records[i].markerActor;

            if ((markerActor.pos - playerActor.pos).Length() > 200) { continue; };
            mDesc.mItems.Push(new("Toby_MarkerRemoveMenuItem").Init(description, ""..markerId));
        }
    }
}
