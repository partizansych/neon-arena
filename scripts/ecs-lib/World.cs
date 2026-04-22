using System;
using System.Collections.Generic;

namespace MyECS.Core;

public delegate void EntityAction<T1, T2>(in Entity entity, ref T1 c1, ref T2 c2);

public class World(int maxEntities)
{
    private static ushort worldCount = 0;

    private readonly ushort worldId = ++worldCount;
    private readonly Dictionary<Type, IComponentStore> components = [];

    private readonly ushort[] generations = new ushort[maxEntities];
    private readonly Stack<int> freeIds = [];
    private int _entitiesCount = 0;

    public bool IsAlive(in Entity entity)
    {
        return entity.WorldId == worldId && entity.Generation == generations[entity.Id];
    }

    public Entity CreateEntity<T>(in T component) where T : struct
    {
        int id = freeIds.Count > 0 ? freeIds.Pop() : _entitiesCount++;
        var entity = new Entity(id, generations[id], worldId);
        AddComponent(entity, component);
        return entity;
    }

    public void DestroyEntity(in Entity entity)
    {
        if (!IsAlive(entity)) return;
        foreach (var store in components.Values) store.Remove(entity);
        generations[entity.Id]++;
        freeIds.Push(entity.Id);
    }

    public void AddComponent<T>(in Entity entity, in T component) where T : struct
    {
        if (!IsAlive(entity)) return;

        var store = GetStore<T>();
        store.Add(entity, component);
    }

    public void SetComponent<T>(in Entity entity, T component) where T : struct
    {
        if (!IsAlive(entity)) return;

        var store = GetStore<T>();
        store.Set(entity, component);
    }

    public bool HasComponent<T>(in Entity entity) where T : struct
    {
        if (!IsAlive(entity)) return false;

        var store = GetStore<T>();
        return store.Has(entity);
    }

    public ref T GetComponent<T>(in Entity entity) where T : struct
    {
        if (!IsAlive(entity)) throw new Exception();

        var store = GetStore<T>();
        return ref store.Get(entity);
    }

    public void Query<T1, T2>(EntityAction<T1, T2> action) where T1 : struct where T2 : struct
    {
        var store1 = GetStore<T1>();
        var store2 = GetStore<T2>();

        if (store1.Count <= store2.Count)
        {
            for (int i = 0; i < store1.Count; i++)
            {
                var entity = store1.GetEntityAtDenseIndex(i);
                if (!store2.Has(entity)) continue;
                action(entity, ref store1.Get(entity), ref store2.Get(entity));
            }
        }
        else
        {
            for (int i = 0; i < store2.Count; i++)
            {
                var entity = store2.GetEntityAtDenseIndex(i);
                if (!store1.Has(entity)) continue;
                action(entity, ref store1.Get(entity), ref store2.Get(entity));
            }
        }
    }

    internal ComponentStore<T> GetStore<T>() where T : struct
    {
        var type = typeof(T);
        if (!components.TryGetValue(type, out var store))
        {
            store = new ComponentStore<T>(maxEntities);
            components[type] = store;
        }
        return (ComponentStore<T>)store;
    }
}
