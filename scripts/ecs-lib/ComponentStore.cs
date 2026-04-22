using System;
using System.Runtime.CompilerServices;

namespace MyECS.Core;

public interface IComponentStore
{
    void Remove(Entity entity);
}

public class ComponentStore<T> : IComponentStore where T : struct
{
    private readonly int[] sparse;
    private readonly T[] dense;
    private readonly Entity[] entities;
    private int count;

    public ComponentStore(int maxEntities)
    {
        sparse = new int[maxEntities];
        Array.Fill(sparse, -1);
        dense = new T[maxEntities];
        entities = new Entity[maxEntities];
        count = 0;
    }

    public int Count => count;
    public ReadOnlySpan<T> AsSpan => dense.AsSpan(0, count);
    public Entity GetEntityAtDenseIndex(int index) => entities[index];

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public ref T Get(Entity entity)
    {
        int index = sparse[entity.Id];
        return ref dense[index];
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public bool Has(Entity entity)
    {
        return entity.Id < sparse.Length && sparse[entity.Id] != -1;
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void Set(Entity entity, T component)
    {
        int index = sparse[entity.Id];
        if (index != -1)
            dense[index] = component;
        else
            Add(entity, component);
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void Add(Entity entity, T component)
    {
        if (sparse[entity.Id] != -1) return; // TODO: Выдавать предупреждение

        sparse[entity.Id] = count;
        dense[count] = component;
        entities[count] = entity; // Запоминаем сущность, к которой принадлежит компонент
        count++;
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void Remove(Entity entity)
    {
        int indexToRemove = sparse[entity.Id];
        if (indexToRemove == -1) return;

        int lastIndex = count - 1;
        Entity lastEntity = entities[lastIndex];

        // SWAP: Переносим последний элемент на место удаляемого
        dense[indexToRemove] = dense[lastIndex];
        entities[indexToRemove] = lastEntity;

        // Обновляем указатель в Sparse для перенесенного элемента
        sparse[lastEntity.Id] = indexToRemove;

        // POP: Очищаем данные
        sparse[entity.Id] = -1;
        count--;
    }
}
