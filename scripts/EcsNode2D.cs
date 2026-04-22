using Godot;
using MyECS.Core;

namespace NeonArena.scripts
{
	public partial class EcsNode2D : Node2D
	{
		public Entity Entity { get; private set; }
		private World World { get; set; }

		public void Bind(Entity entity, World world)
		{
			World = world;
			Entity = entity;
		}

		public override void _Process(double delta)
		{
			// ОБРАЩАЕТСЯ К МИРУ
			if (!World.IsAlive(Entity))
			{
				QueueFree();
				return;
			}

			if (World.HasComponent<Position>(Entity))
			{
				var posComp = World.GetComponent<Position>(Entity);
				if (GlobalPosition != posComp.Value)
					GlobalPosition = posComp.Value;
			}
		}

		public override void _ExitTree()
		{
			if (World != null && World.IsAlive(Entity))
				World.DestroyEntity(Entity);
		}
	}
}