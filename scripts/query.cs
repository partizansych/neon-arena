namespace NeonArena.scripts
{
	public delegate void EntityAction1<T1>(int id, ref T1 c1);
	public delegate void EntityAction2<T1, T2>(int id, ref T1 c1, ref T2 c2);
	public delegate void EntityAction3<T1, T2, T3>(int id, ref T1 c1, ref T2 c2, ref T3 c3);

	public readonly struct Query<T1, T2> where T1 : struct where T2 : struct
	{
		private readonly bool[] _alive;
		private readonly T1[] _d1; private readonly bool[] _h1;
		private readonly T2[] _d2; private readonly bool[] _h2;
		private readonly int _max;

		public Query(World world)
		{
			_alive = world.GetAliveArray();

			var s1 = world.GetStorage<T1>();
			_d1 = s1.Data; _h1 = s1.Has;

			var s2 = world.GetStorage<T2>();
			_d2 = s2.Data; _h2 = s2.Has;

			_max = s1.Count; // Все хранилища имеют одинаковую ёмкость
		}

		public void ForEach(EntityAction2<T1, T2> action)
		{
			// Горячий цикл: JIT полностью заинлайнит делегат в Release-сборке
			for (int i = 0; i < _max; i++)
			{
				// Одна проверка вместо трёх отдельных
				if (!_alive[i] || !_h1[i] || !_h2[i]) continue;

				// Передаём ссылки, копии компонентов НЕ создаются
				action(i, ref _d1[i], ref _d2[i]);
			}
		}
	}

}