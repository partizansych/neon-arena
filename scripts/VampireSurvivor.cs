using Godot;
using MyECS.Core;
using NeonArena.scripts;

public partial class VampireSurvivor : Node
{
    [Export]
    private EcsNode2D testNode;

    private readonly World world = new(100);
    private MovementSystem movementSystem;

    public override void _Ready()
    {
        movementSystem = new MovementSystem(world);

        var entity = world.CreateEntity(new Position());
        world.AddComponent(entity, new Velocity());
        testNode.Bind(entity, world);
    }

    public override void _Process(double delta)
    {
        movementSystem.Update((float)delta);
        world.SetComponent(testNode.Entity, new Velocity(Vector2.Up * 100));
    }
}
