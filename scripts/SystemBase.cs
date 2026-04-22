using MyECS.Core;

namespace NeonArena.scripts
{
	public abstract class SystemBase(World world)
	{
		protected World World { get; private set; } = world;
		public abstract void Update(float delta);
	}
}