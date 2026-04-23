using System;
using Godot;

namespace NeonArena.migrating
{
    public class SpatialGrid
    {
        private readonly int _cellSize;
        private readonly int _cols, _rows;
        private readonly int[] _head;       // Индекс в _next для каждой ячейки (-1 = пусто)
        private readonly int[] _next;       // Связанный список сущностей
        private readonly int[] _entities;   // ID сущностей
        private int _allocPtr;              // Указатель на свободное место в _next/_entities

        public SpatialGrid(int worldWidth, int worldHeight, int cellSize, int maxEntities)
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
            int col = (int)(pos.X / _cellSize);
            int row = (int)(pos.Y / _cellSize);
            if (col < 0 || col >= _cols || row < 0 || row >= _rows) return;

            int cellIndex = row * _cols + col;

            // Вставляем в начало списка ячейки
            _next[_allocPtr] = _head[cellIndex];
            _entities[_allocPtr] = entityId;
            _head[cellIndex] = _allocPtr++;
        }

        // Возвращает количество найденных сущностей (результат пишется в preallocated buffer)
        public int Query(Vector2 center, float radius, Span<int> outBuffer)
        {
            int count = 0;
            int minCol = Math.Max(0, (int)((center.X - radius) / _cellSize));
            int maxCol = Math.Min(_cols - 1, (int)((center.X + radius) / _cellSize));
            int minRow = Math.Max(0, (int)((center.Y - radius) / _cellSize));
            int maxRow = Math.Min(_rows - 1, (int)((center.Y + radius) / _cellSize));

            for (int r = minRow; r <= maxRow; r++)
            {
                for (int c = minCol; c <= maxCol; c++)
                {
                    int head = _head[r * _cols + c];
                    while (head != -1)
                    {
                        if (count < outBuffer.Length)
                            outBuffer[count++] = _entities[head];
                        head = _next[head];
                    }
                }
            }
            return count;
        }
    }
}