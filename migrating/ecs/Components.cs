using Godot;

namespace NeonArena.migrating.ecs
{
    public record struct GodotRef(Node2D Node);
    public struct Position(Vector2 value) { public Vector2 Value = value; }
    public struct Velocity(Vector2 value) { public Vector2 Value = value; }
    public struct Speed(float value) { public float Value = value; }
    public struct Health(float value) { public float Value = value; }
    public struct MaxHealth(float value) { public float Value = value; }

    public struct IsDead { }
    public struct IsPlayer { }
    public record struct IsInput { }
}