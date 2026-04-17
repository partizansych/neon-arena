using Godot;
using System;

namespace NeonArena.scripts
{
	public partial class EcsNode2D : Node2D
	{
        public int EntityId { get; private set; }
        private World World { get; set; }
	
		private ComponentStorage<Position> _positions;

		public void Bind(int entityId, World world)
		{
			World = world;
			EntityId = entityId;

			_positions = world.GetStorage<Position>();
		}

		public override void _Process(double delta)
		{
			// ОБРАЩАЕТСЯ К МИРУ
			if (!World.IsAlive(EntityId))
			{
				QueueFree();
				return;
			}

			if (_positions.Has[EntityId])
			{
				var globalPos = GlobalPosition;
				var ecsGlobalPos = _positions.Get(EntityId).Value;

				if (globalPos != ecsGlobalPos)
					GlobalPosition = ecsGlobalPos;
			}
		}

		public override void _ExitTree()
		{
			if (World != null && World.IsAlive(EntityId))
				World.Destroy(EntityId);
		}
	}
}