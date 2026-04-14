using Arch.Core;
using Arch.System;

namespace NeonArena.scripts.ecs.systems
{
	public class SyncPositionWithGodot(World world) : BaseSystem<World, float>(world)
	{
		private QueryDescription _desc = new QueryDescription().WithAll<GodotRef, Position>();

		public override void Update(in float t)
		{
			World.Query(in _desc, (ref GodotRef gRef, ref Position pos) =>
			{
				gRef.Value.Position = pos.Value;
			});  
		}
	}
}