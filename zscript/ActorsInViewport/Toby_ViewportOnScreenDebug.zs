class Toby_ViewportOnScreenDebug
{
    static ui void DrawText(string text, double posX, double posY, int fontColor)
    {
        double scale = 0.5;
        double alpha = 1.0;
        Screen.DrawText(smallFont,
                    fontColor,
                    posX * scale, //x
                    posY * scale, //y
                    text, //text
                    DTA_KeepRatio, //doesn't adjust screen size for DTA_Virtual* if the aspect ratio is not 4:3 (?)
                    true, //???
                    DTA_VirtualWidth, //pretend the canvas is this wide
                    int(scale * Screen.GetWidth()),
                    DTA_VirtualHeight, //pretend the canvas is this tall
                    int(scale * Screen.GetHeight()),
                    DTA_Alpha, //alpha value for translucency
                    alpha
                );
    }

    static ui void DrawDebugInformation(Toby_ActorsInViewportStorage storage)
    {
        Toby_ActorsInViewportActorCounter leftClose = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Left_Distance_Close", false);
        Toby_ActorsInViewportActorCounter leftMid = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Left_Distance_Medium", false);
        Toby_ActorsInViewportActorCounter leftFar = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Left_Distance_Far", false);

        Toby_ActorsInViewportActorCounter frontClose = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Front_Distance_Close", false);
        Toby_ActorsInViewportActorCounter frontMid = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Front_Distance_Medium", false);
        Toby_ActorsInViewportActorCounter frontFar = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Front_Distance_Far", false);

        Toby_ActorsInViewportActorCounter rigitClose = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Right_Distance_Close", false);
        Toby_ActorsInViewportActorCounter rigitMid = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Right_Distance_Medium", false);
        Toby_ActorsInViewportActorCounter rigitFar = Toby_ActorsInViewportActorCounter.Create(storage, "Screen_Right_Distance_Far", false);

        double posX = 0;
        double posY = 0;

        double oneThird = Screen.GetWidth() / 3;
        double twoThirds = Screen.GetWidth() * 2 / 3;
        double heightOneThird = Screen.GetHeight() / 3;
        double heightTwoThirds = Screen.GetHeight() * 2 / 3;
        posX = twoThirds;
        posY = 0;
        Toby_ViewportOnScreenDebug.DrawText("On your right, far away:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < rigitFar.namesAndAmounts.Size(); k++)
        {
            posY += 15;
            string text = rigitFar.namesAndAmounts[k].name.." - "..rigitFar.namesAndAmounts[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }
        posX = twoThirds;
        posY = heightOneThird;
        Toby_ViewportOnScreenDebug.DrawText("On your right, medium distance:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < rigitMid.namesAndAmounts.Size(); k++)
        {
            posY += 15;
            string text = rigitMid.namesAndAmounts[k].name.." - "..rigitMid.namesAndAmounts[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }
        posX = twoThirds;
        posY = heightTwoThirds;
        Toby_ViewportOnScreenDebug.DrawText("On your right, up close:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < rigitClose.namesAndAmounts.Size(); k++)
        {
            posY += 15;
            string text = rigitClose.namesAndAmounts[k].name.." - "..rigitClose.namesAndAmounts[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }

        posX = oneThird;
        posY = 0;
        Toby_ViewportOnScreenDebug.DrawText("In front of you, far away:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < frontFar.namesAndAmounts.Size(); k++)
        {
            posY += 15;
            string text = frontFar.namesAndAmounts[k].name.." - "..frontFar.namesAndAmounts[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }
        posX = oneThird;
        posY = heightOneThird;
        Toby_ViewportOnScreenDebug.DrawText("In front of you, medium distance:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < frontMid.namesAndAmounts.Size(); k++)
        {
            posY += 15;
            string text = frontMid.namesAndAmounts[k].name.." - "..frontMid.namesAndAmounts[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }
        posX = oneThird;
        posY = heightTwoThirds;
        Toby_ViewportOnScreenDebug.DrawText("In front of you, up close:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < frontClose.namesAndAmounts.Size(); k++)
        {
            posY += 15;
            string text = frontClose.namesAndAmounts[k].name.." - "..frontClose.namesAndAmounts[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }

        posX = 15;
        posY = 0;
        Toby_ViewportOnScreenDebug.DrawText("On your left, far away:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < leftFar.namesAndAmounts.Size(); k++)
        {
            posY += 15;
            string text = leftFar.namesAndAmounts[k].name.." - "..leftFar.namesAndAmounts[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }
        posX = 15;
        posY = heightOneThird;
        Toby_ViewportOnScreenDebug.DrawText("On your left, medium distance:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < leftMid.namesAndAmounts.Size(); k++)
        {
            posY += 15;
            string text = leftMid.namesAndAmounts[k].name.." - "..leftMid.namesAndAmounts[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }
        posX = 15;
        posY = heightTwoThirds;
        Toby_ViewportOnScreenDebug.DrawText("On your left, up close:", posX, posY, Font.CR_GREEN);
        for (let k = 0; k < leftClose.namesAndAmounts.Size(); k++)
        {
            posY += 15;
            string text = leftClose.namesAndAmounts[k].name.." - "..leftClose.namesAndAmounts[k].amount;
            Toby_ViewportOnScreenDebug.DrawText(text, posX, posY, Font.CR_GRAY);
        }
        Screen.DrawLine(oneThird, 0, oneThird, Screen.GetHeight(), 0xff00ff00);
        Screen.DrawLine(twoThirds, 0, twoThirds, Screen.GetHeight(), 0xff00ff00);
    }
}
