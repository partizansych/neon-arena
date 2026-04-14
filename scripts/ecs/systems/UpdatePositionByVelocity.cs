using Arch.Core;
using Arch.System;

namespace NeonArena.scripts.ecs.systems
{
	public class UpdatePositionByVelocity(World world) : BaseSystem<World, float>(world)
	{
		private QueryDescription _desc = new QueryDescription().WithAll<Position, Velocity>();

		public override void Update(in float t)
		{
			float delta = t;
			World.Query(in _desc, (ref Position pos, ref Velocity vel) =>
			{
				pos.Value += vel.Value * delta;
			});  
		}
	}
}