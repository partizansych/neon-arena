namespace NeonArena.scripts
{
	public class MovementSystem(World world) : SystemBase(world)
	{
        private readonly ComponentStorage<Position> positions = world.GetStorage<Position>();
        private readonly ComponentStorage<Velocity> velocities = world.GetStorage<Velocity>();

		public override void Update(float delta)
		{
			for (int i = 0; i < World.MaxEntities; i++)
            {
                if (World.IsAlive(i) && positions.Has[i] && velocities.Has[i])
                {
                    ref var pos = ref positions.Get(i);
                    ref var vel = ref velocities.Get(i);
                    pos.Value += vel.Value * delta;
                }
            }
		}
	}
}