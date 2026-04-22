using Arch.Core;
using Arch.System;

namespace NeonArena.migrating.ecs.systems
{
    public class RenderSync(World world) : BaseSystem<World, float>(world)
    {
        private readonly QueryDescription query = new QueryDescription()
            .WithAll<Position, GodotRef>();

        public override void Update(in float t)
        {
            World.Query(query, (ref Position pos, ref GodotRef rf) =>
            {
                if (rf.Node != null && !rf.Node.IsQueuedForDeletion())
                    rf.Node.GlobalPosition = pos.Value;
            });
        }
    }
}