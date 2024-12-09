class Toby_LinePair
{
    Vertex sharedVertex;
    Vertex vertex1;
    Vertex vertex2;
    Line line1;
    Line line2;

    static Toby_LinePair Create(Vertex sharedVertex, Vertex vertex1, Vertex vertex2, Line line1, Line line2)
    {
        Toby_LinePair pair = new("Toby_LinePair");
        pair.sharedVertex = sharedVertex;
        pair.vertex1 = vertex1;
        pair.vertex2 = vertex2;
        pair.line1 = line1;
        pair.line2 = line2;
        return pair;
    }
}
