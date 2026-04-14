using Arch.Core;
using Arch.System;
using Godot;

namespace NeonArena.scripts.ecs.systems
{
	public class ChasePlayer(World world) : BaseSystem<World, float>(world)
	{
		private QueryDescription _enemies = new QueryDescription().WithAll<Position, Velocity, Speed>().WithNone<IsPlayer>();
		private QueryDescription _players = new QueryDescription().WithAll<Position, IsPlayer>();

		public override void Update(in float t)
		{
			Vector2 playerPos = new();

			World.Query(in _players, (ref Position pos) =>
			{
				playerPos = pos.Value;
			});

			World.Query(in _enemies, (ref Position pos, ref Velocity vel, ref Speed speed) =>
			{
				Vector2 toPlayer = playerPos - pos.Value;
				float distanceSq = toPlayer.LengthSquared();

				if (distanceSq > 0.01f)
				{
					float distance = Mathf.Sqrt(distanceSq);
					Vector2 direction = toPlayer / distance;

					vel.Value = direction * speed.Value;
				}
				else
				{
					vel.Value = Vector2.Zero;
				}
			});  
		}
	}
}