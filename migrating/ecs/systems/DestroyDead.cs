using Arch.Core;
using Arch.System;

namespace NeonArena.migrating.ecs.systems
{
    public class DestroyDead(World world) : BaseSystem<World, float>(world)
    {
        private readonly QueryDescription q = new QueryDescription()
            .WithAll<IsDead, GodotRef>();

        public override void Update(in float t)
        {
            World.Query(q, (Entity entity, ref GodotRef rf) =>
            {
                rf.Node.QueueFree();
                World.Destroy(entity);
            });
        }
    }
}