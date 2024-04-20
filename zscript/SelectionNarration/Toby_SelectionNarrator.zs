class Toby_SelectionNarrator
{
    ui static void NarrateWeaponName(
    string weaponName,
    Toby_SoundBindingsContainer weaponsSoundBindings)
    {
        Toby_SoundQueueStaticHandler.Clear();

        for (int i = 0; i < weaponsSoundBindings.soundBindings.Size(); i++)
        {
            string className = weaponsSoundBindings.soundBindings[i].At("ActorClass");
            if (weaponName == className)
            {
                string soundName = weaponsSoundBindings.soundBindings[i].At("SoundToPlay");
                Toby_SoundQueueStaticHandler.AddSound(soundName, -1);
                break;
            }
        }

        Toby_SoundQueueStaticHandler.PlayQueue(0);
    }
}
