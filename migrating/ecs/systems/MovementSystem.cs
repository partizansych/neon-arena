using Arch.Core;
using Arch.System;

namespace NeonArena.migrating.ecs.systems
{
    public class MovementSystem(World world) : BaseSystem<World, float>(world)
    {
        private readonly QueryDescription query = new QueryDescription()
            .WithAll<Position, Velocity>();

        public override void Update(in float t)
        {
            var delta = t;

            World.Query(query, (ref Position pos, ref Velocity vel) =>
            {
                pos.Value += vel.Value * delta;
            });
        }
    }
}