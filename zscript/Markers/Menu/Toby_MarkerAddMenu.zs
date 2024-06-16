class Toby_MarkerAddMenu : OptionMenu
{
    override void Init(Menu parent, OptionMenuDescriptor desc)
    {
        Super.Init(parent, desc);
        mDesc.mItems.Clear();
        mDesc.mSelectedItem = -1;

        Toby_MarkerHandler handler = Toby_MarkerHandler.GetInstanceUi();

        for (uint i = 0; i < handler.db.items.Size(); i++)
        {
            string description = handler.db.items[i].description;
            string actorClassName = handler.db.items[i].actorClassName;
            mDesc.mItems.Push(new("Toby_MarkerAddMenuItem").Init(description, actorClassName));
        }
    }
}
