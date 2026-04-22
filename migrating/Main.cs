using Arch.Core;
using Arch.Core.Extensions;
using Arch.System;
using Godot;
using NeonArena.migrating.ecs;
using NeonArena.migrating.ecs.systems;

public partial class Main : Node
{
    [Export] private Node2D testNode;

    private readonly World world = World.Create();
    private Group<float> processSystems;

    private Entity entity;

    public override void _Ready()
    {
        entity = world.Create(
            new Position(testNode.GlobalPosition),
            new Velocity(Vector2.FromAngle(45) * 150),
            new Health(100f),
            new GodotRef(testNode)
        );

        processSystems = new Group<float>("process",
            new MovementSystem(world),
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
    }
}
