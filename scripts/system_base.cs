namespace NeonArena.scripts
{
	public abstract class SystemBase
	{
		protected World World { get; private set;}

		public void SetWorld(World world) => World = world;
		public abstract void Update(float delta);
	}
}