using System.Collections.Generic;
using Arch.Core;
using Arch.Core.Extensions;
using Arch.System;
using CommunityToolkit.HighPerformance;
using Godot;
using NeonArena.migrating;
using NeonArena.migrating.ecs;
using NeonArena.migrating.ecs.systems;

public partial class Main : Node
{
    [Export] private Node2D testNode;

    private readonly World world = World.Create();
    private Group<float> processSystems;

    private Entity entity;
    private SpatialGrid grid = new(2000, 2000, 100, 500);
    private List<int> buffer = [100];

    public override void _Ready()
    {
        entity = world.Create(
            new Position(testNode.GlobalPosition),
            // new Velocity(Vector2.FromAngle(45) * 150),
            new Health(100f),
            new GodotRef(testNode)
        );

        processSystems = new Group<float>("process",
            new MovementSystem(world),
            new UpdateGrid(world, grid),
            new MarkDead(world),
            new DestroyDead(world),
            new RenderSync(world)
        );
    }

    public override void _Process(double delta)
    {
        if (Input.IsMouseButtonPressed(MouseButton.Left))
        {
            if (world.IsAlive(entity))
                if (!entity.Has<IsDead>())
                    world.Add(entity, new IsDead());
        }

        processSystems.Update((float)delta);


        GD.Print(grid.Query(Vector2.Zero, 100, buffer.AsSpan()));
        grid.Clear();
        buffer.Clear();
    }
}
