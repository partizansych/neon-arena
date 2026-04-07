using System;
using System.Numerics;

namespace NeonArena.scripts
{
	public class SpatialHashGrid
	{
		private readonly int _cellSize;
		private readonly int _cols, _rows;
		private readonly int[] _head;       // Индекс в _next для каждой ячейки (-1 = пусто)
		private readonly int[] _next;       // Связанный список сущностей
		private readonly int[] _entities;   // ID сущностей
		private int _allocPtr;              // Указатель на свободное место в _next/_entities

		public SpatialHashGrid(int worldWidth, int worldHeight, int cellSize, int maxEntities)
		{
			_cellSize = cellSize;
			_cols = worldWidth / cellSize;
			_rows = worldHeight / cellSize;
			_head = new int[_cols * _rows];
			Array.Fill(_head, -1);
			_next = new int[maxEntities];
			_entities = new int[maxEntities];
			_allocPtr = 0;
		}

		public void Clear()
		{
			Array.Fill(_head, -1);
			_allocPtr = 0;
		}

		public void Insert(int entityId, Vector2 pos)
		{
			// 1. В какую клетку попадает?
			int col = (int)(pos.X / _cellSize); // 150 / 64 = 2
			int row = (int)(pos.Y / _cellSize); // 200 / 64 = 3

			// 2. Превращаем 2D-координату клетки в 1D-индекс массива
			int cellIndex = row * _cols + col; // 3 * ширина + 2

			// 3. Берём свободную ячейку в наших массивах
			int slot = _allocPtr++; 

			// 4. Цепляем нового врага к началу списка этой клетки
			_next[slot] = _head[cellIndex];      // "Следующим будет тот, кто уже стоял тут"
			_entities[slot] = entityId;          // "А тут теперь живёт враг №777"
			_head[cellIndex] = slot;             // "Теперь первый в этой клетке — новый слот"
		}

		public int Query(Vector2 center, float radius, Span<int> outBuffer)
		{
			int count = 0;

			// 1. Вычисляем границы клеток, которые пересекает круг поиска
			int minCol = Math.Max(0, (int)((center.X - radius) / 64));
			int maxCol = Math.Min(_cols - 1, (int)((center.X + radius) / 64));
			int minRow = Math.Max(0, (int)((center.Y - radius) / 64));
			int maxRow = Math.Min(_rows - 1, (int)((center.Y + radius) / 64));

			// 2. Проходим только по этим клеткам
			for (int r = minRow; r <= maxRow; r++)
			for (int c = minCol; c <= maxCol; c++)
			{
				// Клетка (2, 3) означает какое-то одно число (например, №32),
				// так как массив клеток одномерный
				int cellIndex = r * _cols + c;
				
				int head = _head[cellIndex]; // Берём "голову" клетки
				
				// 3. Идём по цепочке, пока не упремся в -1
				while (head != -1)
				{
					if (count < outBuffer.Length)
						outBuffer[count++] = _entities[head]; // Кладём ID в буфер
					head = _next[head]; // Переходим к следующему в цепочке
				}
			}

			return count;
		}
	}
}