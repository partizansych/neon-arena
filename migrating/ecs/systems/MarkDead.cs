using Arch.Core;
using Arch.Core.Extensions;
using Arch.System;
using Godot;

namespace NeonArena.migrating.ecs.systems
{
    public class MarkDead(World world) : BaseSystem<World, float>(world)
    {
        private readonly QueryDescription q = new QueryDescription()
            .WithAll<Health>().WithNone<IsDead>();

        public override void Update(in float t)
        {
            World.Query(q, (Entity entity, ref Health health) =>
            {
                if (health.Value <= 0f)
                    entity.Set(new IsDead());
            });
        }
    }
}