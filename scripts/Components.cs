using System.Numerics;

namespace NeonArena.scripts
{
	// 1. Компоненты - ТОЛЬКО данные. struct исключает аллокации и улучшает locality
	public struct Position { public Vector2 Value; }
	public struct Velocity { public Vector2 Value; }
}