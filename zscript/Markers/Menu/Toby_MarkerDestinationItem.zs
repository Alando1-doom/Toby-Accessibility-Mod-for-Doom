class Toby_MarkerDestinationItem
{
    Vector3 coordinates;
    double distance;
    string direction;

    static Toby_MarkerDestinationItem Create(Vector3 coordinates, Actor playerActor)
    {
        Toby_MarkerDestinationItem item = new("Toby_MarkerDestinationItem");

        Array<string> directions;
        directions.push("North");
        directions.push("North-East");
        directions.push("East");
        directions.push("South-East");
        directions.push("South");
        directions.push("South-West");
        directions.push("West");
        directions.push("North-West");

        vector2 compassDirection = coordinates.xy - playerActor.pos.xy;
        double angle = VectorAngle(compassDirection.y, compassDirection.x);
        angle = (angle + 360) % 360;

        int directionIndex = Round(angle / 45) % 8;
        int distance = Round(compassDirection.Length());

        item.coordinates = coordinates;
        item.distance = distance;
        item.direction = directions[directionIndex];
        return item;
    }
}
