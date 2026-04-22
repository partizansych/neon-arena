using MyECS.Core;

namespace NeonArena.scripts
{
    public class MovementSystem(World world) : SystemBase(world)
    {
        public override void Update(float delta)
        {
            World.Query((in Entity entity, ref Position pos, ref Velocity vel) =>
            {
                pos.Value += vel.Value * delta;
            });
        }
    }
}