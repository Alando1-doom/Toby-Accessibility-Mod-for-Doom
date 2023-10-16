class Toby_ActorsInViewportHandler: EventHandler
{
    Toby_ViewportProjector projector;
    Toby_ActorsInViewportStorage storage;

    override void OnRegister()
    {
        projector = Toby_ViewportProjector.Create();
        storage = Toby_ActorsInViewportStorage.Create();
    }

    override void WorldTick()
    {
        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        projector.PrepareProjection();

        storage.GetActorsThatCanSeePlayer(playerActor);
    }

    override void RenderOverlay(RenderEvent e)
    {
        projector.viewport.FromHud();
        if (!projector.canProject)
        {
            return;
        }

        PlayerInfo player = players[consoleplayer];
        if (!player) { return; }
        Actor playerActor = player.mo;
        if (!playerActor) { return; }

        let oneThird = Screen.GetWidth() / 3;
        let twoThirds = Screen.GetWidth() * 2 / 3;

        let heightOneThird = Screen.GetHeight() / 3;
        let heightTwoThirds = Screen.GetHeight() * 2 / 3;

        PosInfoStorage frontClose = new("PosInfoStorage");
        PosInfoStorage frontMid = new("PosInfoStorage");
        PosInfoStorage frontFar = new("PosInfoStorage");

        PosInfoStorage leftClose = new("PosInfoStorage");
        PosInfoStorage leftMid = new("PosInfoStorage");
        PosInfoStorage leftFar = new("PosInfoStorage");

        PosInfoStorage rigitClose = new("PosInfoStorage");
        PosInfoStorage rigitMid = new("PosInfoStorage");
        PosInfoStorage rigitFar = new("PosInfoStorage");

        projector.projection.CacheResolution();
        projector.projection.CacheFov(player.fov);
        projector.projection.OrientForRenderOverlay(e);
        projector.projection.BeginProjection();

        for (let i = 0; i < storage.actorsThatCanSeePlayer.Size(); i++)
        {
            if (!storage.actorsThatCanSeePlayer[i]) { continue; }
            projector.projection.projectActorPos(storage.actorsThatCanSeePlayer[i], (0,0,0), e.fractic);
            let normalPos = projector.projection.projectToNormal();
            if (!projector.viewport.IsInside(normalPos)) { continue; }
            if (!projector.projection.IsInScreen()) { continue; }
            let screenPos = projector.viewport.SceneToWindow(normalPos);

            let className = storage.actorsThatCanSeePlayer[i].GetClassName();
            double distance = (storage.actorsThatCanSeePlayer[i].pos - playerActor.pos).Length();
            double closeDistance = 200;
            double mediumDistance = 1000;
            if (screenPos.x > twoThirds)
            {
                if (distance < closeDistance)
                {
                    rigitClose.AddName(className);
                }
                else if (distance < mediumDistance)
                {
                    rigitMid.AddName(className);
                }
                else
                {
                    rigitFar.AddName(className);
                }
            }
            else if (screenPos.x > oneThird)
            {
                if (distance < closeDistance)
                {
                    frontClose.AddName(className);
                }
                else if (distance < mediumDistance)
                {
                    frontMid.AddName(className);
                }
                else
                {
                    frontFar.AddName(className);
                }
            }
            else
            {
                if (distance < closeDistance)
                {
                    leftClose.AddName(className);
                }
                else if (distance < mediumDistance)
                {
                    leftMid.AddName(className);
                }
                else
                {
                    leftFar.AddName(className);
                }
            }

            TextureId tex = TexMan.CheckForTexture("STCDROM",TexMan.TYPE_ANY);
            Screen.DrawTexture(tex, false, screenPos.x, screenPos.y);
        }

        double posX = 0;
        double posY = 0;

        posX = twoThirds;
        posY = 0;
        Toby_ViewportOnScreenDebug.DrawText("On your right, up close:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < rigitClose.storage.Size(); k++)
        {
            posY += 15;
            string text = rigitClose.storage[k].name.." - "..rigitClose.storage[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }
        posX = twoThirds;
        posY = heightOneThird;
        Toby_ViewportOnScreenDebug.DrawText("On your right, medium distance:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < rigitMid.storage.Size(); k++)
        {
            posY += 15;
            string text = rigitMid.storage[k].name.." - "..rigitMid.storage[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }
        posX = twoThirds;
        posY = heightTwoThirds;
        Toby_ViewportOnScreenDebug.DrawText("On your right, far away:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < rigitFar.storage.Size(); k++)
        {
            posY += 15;
            string text = rigitFar.storage[k].name.." - "..rigitFar.storage[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }

        posX = oneThird;
        posY = 0;
        Toby_ViewportOnScreenDebug.DrawText("In front of you, up close:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < frontClose.storage.Size(); k++)
        {
            posY += 15;
            string text = frontClose.storage[k].name.." - "..frontClose.storage[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }
        posX = oneThird;
        posY = heightOneThird;
        Toby_ViewportOnScreenDebug.DrawText("In front of you, medium distance:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < frontMid.storage.Size(); k++)
        {
            posY += 15;
            string text = frontMid.storage[k].name.." - "..frontMid.storage[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }
        posX = oneThird;
        posY = heightTwoThirds;
        Toby_ViewportOnScreenDebug.DrawText("In front of you, far away:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < frontFar.storage.Size(); k++)
        {
            posY += 15;
            string text = frontFar.storage[k].name.." - "..frontFar.storage[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }

        posX = 15;
        posY = 0;
        Toby_ViewportOnScreenDebug.DrawText("On your left, up close:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < leftClose.storage.Size(); k++)
        {
            posY += 15;
            string text = leftClose.storage[k].name.." - "..leftClose.storage[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }
        posX = 15;
        posY = heightOneThird;
        Toby_ViewportOnScreenDebug.DrawText("On your left, medium distance:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < leftMid.storage.Size(); k++)
        {
            posY += 15;
            string text = leftMid.storage[k].name.." - "..leftMid.storage[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }
        posX = 15;
        posY = heightTwoThirds;
        Toby_ViewportOnScreenDebug.DrawText("On your left, far away:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < leftFar.storage.Size(); k++)
        {
            posY += 15;
            string text = leftFar.storage[k].name.." - "..leftFar.storage[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }
        Screen.DrawLine(oneThird, 0, oneThird, Screen.GetHeight(), 0xff00ff00);
        Screen.DrawLine(twoThirds, 0, twoThirds, Screen.GetHeight(), 0xff00ff00);
    }
}

class PosInfo
{
    string name;
    int amount;
}

class PosInfoStorage
{
    Array<PosInfo> storage;

    void AddName(string name)
    {
        bool nameFound = false;

        for (let i = 0; i < storage.Size(); i++)
        {
            if (storage[i].name == name)
            {
                nameFound = true;
                storage[i].amount++;
            }
        }
        if (!nameFound)
        {
            PosInfo info = new("PosInfo");
            info.name = name;
            info.amount = 1;
            storage.push(info);
        }
    }
}
