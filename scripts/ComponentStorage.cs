// 2. Хранилище компонентов одного типа
public interface IComponentStorage
{
    void Clear(int index);
}

namespace NeonArena.scripts
{
	public class ComponentStorage<T>(int capacity) : IComponentStorage where T : struct
	{
		public readonly T[] Data = new T[capacity];
		public readonly bool[] Has = new bool[capacity];
		public int Count => Data.Length;

		public ref T Get(int index) => ref Data[index];
		public void Set(int index, T value) { Data[index] = value; Has[index] = true; }
		public void Clear(int index) => Has[index] = false;
	}
}