using Arch.Core;
using Arch.System;

namespace NeonArena.migrating.ecs.systems
{
    public class UpdateGrid(World world, SpatialGrid grid) : BaseSystem<World, float>(world)
    {
        private readonly SpatialGrid gr = grid;

        private readonly QueryDescription q = new QueryDescription()
            .WithAll<Position>();

        public override void Update(in float t)
        {
            World.Query(q, (Entity entity, ref Position pos) =>
            {
                gr.Insert(entity.Id, pos.Value);
            });
        }
    }
}