using System;
using Godot;

public partial class Arena : Node2D
{
    [Export]
    private Node2D[] spawnpoints;

    public Span<Node2D> GetSpawnpoints()
    {
        return spawnpoints.AsSpan();
    }
}