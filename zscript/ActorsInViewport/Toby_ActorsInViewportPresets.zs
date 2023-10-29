//Proydoha: All of it is super hardcoded and I don't like it
//This is where I gave up :)

class Toby_ActorsInViewportPresets
{
    static ui void PlayGeneralOverview(Toby_ActorsInViewportStorage storage, Toby_SoundBindingsContainer bindings)
    {
        Toby_SoundQueue queue = new("Toby_SoundQueue");
        queue.AddSound("toby/actorsinviewport/general/generaloverview", -1);

        Toby_ActorCounterToSoundQueue actorCounterToSoundQueue = Toby_ActorCounterToSoundQueue.Create();
        Toby_ActorsInViewportActorCounter allRemains = Toby_ActorsInViewportActorCounter.Create(storage, "All_Remains", true);
        Toby_ActorsInViewportActorCounter allNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "All_NotRemains", false);

        Toby_SoundQueue allNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(allNotRemains, bindings);
        Toby_SoundQueue allRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(allRemains, bindings);

        if (allNotRemainsQueue.isEmpty() && allRemainsQueue.isEmpty())
        {
            queue.AddSound("toby/actorsinviewport/general/nonotableactorsaround", -1);
        }

        queue.AddQueue(allNotRemainsQueue);
        queue.AddQueue(allRemainsQueue);

        Toby_SoundQueueStaticHandler handler = Toby_SoundQueueStaticHandler(StaticEventHandler.Find("Toby_SoundQueueStaticHandler"));
        handler.AddQueue(queue);
        handler.PlayQueue(0);
    }

    static ui void PlayDetailedOverviewByScreenPosition(Toby_ActorsInViewportStorage storage, Toby_SoundBindingsContainer bindings)
    {
        Toby_SoundQueue queue = new("Toby_SoundQueue");

        Toby_ActorCounterToSoundQueue actorCounterToSoundQueue = Toby_ActorCounterToSoundQueue.Create();

        Toby_ActorsInViewportActorCounter leftRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Left_Remains", true);
        Toby_ActorsInViewportActorCounter leftNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Left_NotRemains", false);

        Toby_ActorsInViewportActorCounter frontRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Front_Remains", true);
        Toby_ActorsInViewportActorCounter frontNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Front_NotRemains", false);

        Toby_ActorsInViewportActorCounter rightRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Right_Remains", true);
        Toby_ActorsInViewportActorCounter rightNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Right_NotRemains", false);

        Toby_SoundQueue leftRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(leftRemains, bindings);
        Toby_SoundQueue leftNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(leftNotRemains, bindings);

        Toby_SoundQueue frontRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(frontRemains, bindings);
        Toby_SoundQueue frontNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(frontNotRemains, bindings);

        Toby_SoundQueue rightRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(rightRemains, bindings);
        Toby_SoundQueue rightNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(rightNotRemains, bindings);

        if (leftRemainsQueue.isEmpty()
            && leftNotRemainsQueue.isEmpty()
            && frontRemainsQueue.isEmpty()
            && frontNotRemainsQueue.isEmpty()
            && rightRemainsQueue.isEmpty()
            && rightNotRemainsQueue.isEmpty()
            )
        {
            queue.AddSound("toby/actorsinviewport/general/nonotableactorsaround", -1);
        }

        AddSubQueuePairToQueue(queue, leftNotRemainsQueue, leftRemainsQueue, "toby/actorsinviewport/general/onyourleft");
        AddSubQueuePairToQueue(queue, frontNotRemainsQueue, frontRemainsQueue, "toby/actorsinviewport/general/infrontofyou");
        AddSubQueuePairToQueue(queue, rightNotRemainsQueue, rightRemainsQueue, "toby/actorsinviewport/general/onyourright");

        Toby_SoundQueueStaticHandler handler = Toby_SoundQueueStaticHandler(StaticEventHandler.Find("Toby_SoundQueueStaticHandler"));
        handler.AddQueue(queue);
        handler.PlayQueue(0);
    }

    static ui void PlayDetailedOverviewByDistance(Toby_ActorsInViewportStorage storage, Toby_SoundBindingsContainer bindings)
    {
        Toby_SoundQueue queue = new("Toby_SoundQueue");

        Toby_ActorCounterToSoundQueue actorCounterToSoundQueue = Toby_ActorCounterToSoundQueue.Create();

        Toby_ActorsInViewportActorCounter closeRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Distance_Close_Remains", true);
        Toby_ActorsInViewportActorCounter closeNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Distance_Close_NotRemains", false);

        Toby_ActorsInViewportActorCounter mediumRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Distance_Medium_Remains", true);
        Toby_ActorsInViewportActorCounter mediumNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Distance_Medium_NotRemains", false);

        Toby_ActorsInViewportActorCounter farRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Distance_Far_Remains", true);
        Toby_ActorsInViewportActorCounter farNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Distance_Far_NotRemains", false);

        Toby_SoundQueue closeRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(closeRemains, bindings);
        Toby_SoundQueue closeNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(closeNotRemains, bindings);

        Toby_SoundQueue mediumRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(mediumRemains, bindings);
        Toby_SoundQueue mediumNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(mediumNotRemains, bindings);

        Toby_SoundQueue farRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(farRemains, bindings);
        Toby_SoundQueue farNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(farNotRemains, bindings);

        if (closeRemainsQueue.isEmpty()
            && closeNotRemainsQueue.isEmpty()
            && mediumRemainsQueue.isEmpty()
            && mediumNotRemainsQueue.isEmpty()
            && farRemainsQueue.isEmpty()
            && farNotRemainsQueue.isEmpty()
            )
        {
            queue.AddSound("toby/actorsinviewport/general/nonotableactorsaround", -1);
        }

        AddSubQueuePairToQueue(queue, closeNotRemainsQueue, closeRemainsQueue, "toby/actorsinviewport/general/close");
        AddSubQueuePairToQueue(queue, mediumNotRemainsQueue, mediumRemainsQueue, "toby/actorsinviewport/general/mediumdistance");
        AddSubQueuePairToQueue(queue, farNotRemainsQueue, farRemainsQueue, "toby/actorsinviewport/general/faraway");

        Toby_SoundQueueStaticHandler handler = Toby_SoundQueueStaticHandler(StaticEventHandler.Find("Toby_SoundQueueStaticHandler"));
        handler.AddQueue(queue);
        handler.PlayQueue(0);
    }


    static ui void PlayDetailedOverviewByDistanceAndScreenPosition(Toby_ActorsInViewportStorage storage, Toby_SoundBindingsContainer bindings)
    {
        Toby_SoundQueue queue = new("Toby_SoundQueue");

        Toby_ActorCounterToSoundQueue actorCounterToSoundQueue = Toby_ActorCounterToSoundQueue.Create();

        Toby_ActorsInViewportActorCounter leftCloseRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Left_Distance_Close_Remains", true);
        Toby_ActorsInViewportActorCounter leftCloseNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Left_Distance_Close_NotRemains", false);
        Toby_ActorsInViewportActorCounter leftMediumRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Left_Distance_Medium_Remains", true);
        Toby_ActorsInViewportActorCounter leftMediumNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Left_Distance_Medium_NotRemains", false);
        Toby_ActorsInViewportActorCounter leftFarRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Left_Distance_Far_Remains", true);
        Toby_ActorsInViewportActorCounter leftFarNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Left_Distance_Far_NotRemains", false);

        Toby_ActorsInViewportActorCounter frontCloseRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Front_Distance_Close_Remains", true);
        Toby_ActorsInViewportActorCounter frontCloseNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Front_Distance_Close_NotRemains", false);
        Toby_ActorsInViewportActorCounter frontMediumRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Front_Distance_Medium_Remains", true);
        Toby_ActorsInViewportActorCounter frontMediumNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Front_Distance_Medium_NotRemains", false);
        Toby_ActorsInViewportActorCounter frontFarRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Front_Distance_Far_Remains", true);
        Toby_ActorsInViewportActorCounter frontFarNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Front_Distance_Far_NotRemains", false);

        Toby_ActorsInViewportActorCounter rightCloseRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Right_Distance_Close_Remains", true);
        Toby_ActorsInViewportActorCounter rightCloseNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Right_Distance_Close_NotRemains", false);
        Toby_ActorsInViewportActorCounter rightMediumRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Right_Distance_Medium_Remains", true);
        Toby_ActorsInViewportActorCounter rightMediumNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Right_Distance_Medium_NotRemains", false);
        Toby_ActorsInViewportActorCounter rightFarRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Right_Distance_Far_Remains", true);
        Toby_ActorsInViewportActorCounter rightFarNotRemains = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Right_Distance_Far_NotRemains", false);

        Toby_SoundQueue leftCloseRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(leftCloseRemains, bindings);
        Toby_SoundQueue leftCloseNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(leftCloseNotRemains, bindings);
        Toby_SoundQueue leftMediumRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(leftMediumRemains, bindings);
        Toby_SoundQueue leftMediumNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(leftMediumNotRemains, bindings);
        Toby_SoundQueue leftFarRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(leftFarRemains, bindings);
        Toby_SoundQueue leftFarNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(leftFarNotRemains, bindings);

        Toby_SoundQueue frontCloseRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(frontCloseRemains, bindings);
        Toby_SoundQueue frontCloseNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(frontCloseNotRemains, bindings);
        Toby_SoundQueue frontMediumRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(frontMediumRemains, bindings);
        Toby_SoundQueue frontMediumNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(frontMediumNotRemains, bindings);
        Toby_SoundQueue frontFarRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(frontFarRemains, bindings);
        Toby_SoundQueue frontFarNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(frontFarNotRemains, bindings);

        Toby_SoundQueue rightCloseRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(rightCloseRemains, bindings);
        Toby_SoundQueue rightCloseNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(rightCloseNotRemains, bindings);
        Toby_SoundQueue rightMediumRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(rightMediumRemains, bindings);
        Toby_SoundQueue rightMediumNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(rightMediumNotRemains, bindings);
        Toby_SoundQueue rightFarRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(rightFarRemains, bindings);
        Toby_SoundQueue rightFarNotRemainsQueue = actorCounterToSoundQueue.CreateQueueFromActorCounter(rightFarNotRemains, bindings);

        bool isLeftSideEmpty = leftCloseRemainsQueue.isEmpty()
            && leftCloseNotRemainsQueue.isEmpty()
            && leftMediumRemainsQueue.isEmpty()
            && leftMediumNotRemainsQueue.isEmpty()
            && leftFarRemainsQueue.isEmpty()
            && leftFarNotRemainsQueue.isEmpty();

        bool isFrontSideEmpty = frontCloseRemainsQueue.isEmpty()
            && frontCloseNotRemainsQueue.isEmpty()
            && frontMediumRemainsQueue.isEmpty()
            && frontMediumNotRemainsQueue.isEmpty()
            && frontFarRemainsQueue.isEmpty()
            && frontFarNotRemainsQueue.isEmpty();

        bool isRightSideEmpty = rightCloseRemainsQueue.isEmpty()
            && rightCloseNotRemainsQueue.isEmpty()
            && rightMediumRemainsQueue.isEmpty()
            && rightMediumNotRemainsQueue.isEmpty()
            && rightFarRemainsQueue.isEmpty()
            && rightFarNotRemainsQueue.isEmpty();

        if (isLeftSideEmpty && isFrontSideEmpty && isRightSideEmpty)
        {
            queue.AddSound("toby/actorsinviewport/general/nonotableactorsaround", -1);
        }

        if (!isLeftSideEmpty)
        {
            queue.AddSound("toby/actorsinviewport/general/onyourleft", -1);

            AddSubQueuePairToQueue(queue, leftCloseNotRemainsQueue, leftCloseRemainsQueue, "toby/actorsinviewport/general/close");
            AddSubQueuePairToQueue(queue, leftMediumNotRemainsQueue, leftMediumRemainsQueue, "toby/actorsinviewport/general/mediumdistance");
            AddSubQueuePairToQueue(queue, leftFarNotRemainsQueue, leftFarRemainsQueue, "toby/actorsinviewport/general/faraway");
        }

        if (!isFrontSideEmpty)
        {
            queue.AddSound("toby/actorsinviewport/general/infrontofyou", -1);

            AddSubQueuePairToQueue(queue, frontCloseNotRemainsQueue, frontCloseRemainsQueue, "toby/actorsinviewport/general/close");
            AddSubQueuePairToQueue(queue, frontMediumNotRemainsQueue, frontMediumRemainsQueue, "toby/actorsinviewport/general/mediumdistance");
            AddSubQueuePairToQueue(queue, frontFarNotRemainsQueue, frontFarRemainsQueue, "toby/actorsinviewport/general/faraway");
        }

        if (!isRightSideEmpty)
        {
            queue.AddSound("toby/actorsinviewport/general/onyourright", -1);

            AddSubQueuePairToQueue(queue, rightCloseNotRemainsQueue, rightCloseRemainsQueue, "toby/actorsinviewport/general/close");
            AddSubQueuePairToQueue(queue, rightMediumNotRemainsQueue, rightMediumRemainsQueue, "toby/actorsinviewport/general/mediumdistance");
            AddSubQueuePairToQueue(queue, rightFarNotRemainsQueue, rightFarRemainsQueue, "toby/actorsinviewport/general/faraway");
        }

        Toby_SoundQueueStaticHandler handler = Toby_SoundQueueStaticHandler(StaticEventHandler.Find("Toby_SoundQueueStaticHandler"));
        handler.AddQueue(queue);
        handler.PlayQueue(0);
    }

    static ui void AddSubQueuePairToQueue(
        Toby_SoundQueue queue,
        Toby_SoundQueue subqueueNotRemains,
        Toby_SoundQueue subqueueRemains,
        string soundToPlay)
    {
        if (!subqueueNotRemains.isEmpty() || !subqueueRemains.isEmpty())
        {
            queue.AddSound(soundToPlay, -1);
            queue.AddQueue(subqueueNotRemains);
            queue.AddQueue(subqueueRemains);
        }
    }
}
