using Arch.Core;
using Arch.System;
using Godot;
using NeonArena.scripts.ecs.systems;

public partial class VampireSurvivors : Node
{
	[Export]
	public Node Player;

	[Export]
	public Node Enemy;

	private readonly World _world = World.Create();
	private Group<float> _physics_systems;

	public override void _Ready()
	{
		// _world.Create

		_physics_systems = new Group<float>(
			"Systems",
			new UpdatePositionByVelocity(_world),
			new ChasePlayer(_world),
			new SyncPositionWithGodot(_world)
		);
	}


	public override void _PhysicsProcess(double delta)
	{
		_physics_systems.Update((float)delta);
	}

}
