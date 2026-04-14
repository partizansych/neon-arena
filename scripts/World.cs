using System;
using System.Collections.Generic;

namespace NeonArena.scripts
{
	// 3. Мир (Registry)
	public class World
	{
		private readonly int _maxEntities;
		private readonly bool[] _alive;
		private readonly int[] _freeList;
		private int _freeHead;
		private readonly Dictionary<Type, object> _storages = [];

		public World(int maxEntities)
		{
			_maxEntities = maxEntities;
			_alive = new bool[maxEntities];
			_freeList = new int[maxEntities];

			// Инициализируем стек: [0, 1, 2, ..., N]
			for (int i = 0; i < maxEntities; i++)
				_freeList[i] = i;
			_freeHead = maxEntities;
		}

		public bool[] GetAliveArray() => _alive;

		public ComponentStorage<T> GetStorage<T>() where T : struct
		{
			var type = typeof(T);
			if (!_storages.TryGetValue(type, out var storage))
			{
				storage = new ComponentStorage<T>(_maxEntities);
				_storages[type] = storage;
			}
			return (ComponentStorage<T>)storage;
		}

		public bool IsAlive(int id)
		{
			return id >= 0 && id < _maxEntities && _alive[id];
		}

		public int Create()
		{
			if (_freeHead == 0)
				throw new InvalidOperationException("Pool exhausted");

			int id = _freeList[--_freeHead]; // Pop
			_alive[id] = true;
			return id;
		}

		public void Destroy(int id)
		{
			if (!_alive[id])
				return;
			_alive[id] = false;

			foreach (var storage in _storages.Values)
				if (storage is IComponentStorage s)
					s.Clear(id);

			_freeList[_freeHead++] = id; // Push
		}
	}
}