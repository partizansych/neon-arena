using System;

namespace MyECS.Core;

public readonly struct Entity(int id, ushort generation, ushort worldId) : IEquatable<Entity>
{
    public static readonly Entity Invalid = new(0, 0, 0);

    internal readonly int Id = id;
    internal readonly ushort Generation = generation;
    internal readonly ushort WorldId = worldId;

    public bool Equals(Entity other) => Id == other.Id && Generation == other.Generation && WorldId == other.WorldId;
    public override bool Equals(object obj) => obj is Entity other && Equals(other);
    public override int GetHashCode() => HashCode.Combine(Id, Generation, WorldId);
    public override string ToString() => $"E:{WorldId}-{Id}[{Generation}]";
    public static bool operator ==(Entity a, Entity b) => a.Equals(b);
    public static bool operator !=(Entity a, Entity b) => !a.Equals(b);
}