using Godot;

namespace NeonArena.scripts
{
	public struct Position(Vector2 value) { public Vector2 Value = value; }
	public struct Velocity(Vector2 value) { public Vector2 Value = value; }
	public struct IsPlayer { }
}