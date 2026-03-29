class_name DamagePopup extends Control

@export var label: Label

func bind_damage(damage: String) -> void:
	label.text = damage

func _animate() -> void:

	var tween := self.create_tween()

	# --- 1. ПОЯВЛЕНИЕ (Pop & Bounce) ---
	# Pop & Bounce
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.4)\
	.from(Vector2.ZERO)\
	.set_trans(Tween.TRANS_BACK)\
	.set_ease(Tween.EASE_OUT)
	
	# Движение вверх параллельно, но с более мягкой кривой (SINE)
	tween.parallel().tween_property(self, "position:y", -60.0, 0.4)\
	.as_relative()\
	.set_trans(Tween.TRANS_SINE)\
	.set_ease(Tween.EASE_OUT)

	# --- 2. ЗАВИСАНИЕ (Float & Pulse) ---
	for i in 2:
		tween.tween_property(self, "modulate:a", 0.65, 0.2)
		tween.tween_property(self, "modulate:a", 1.0, 0.2)

	# --- 3. ИСЧЕЗНОВЕНИЕ (Fade & Shrink) ---
	# Быстрое исчезновение с ускорением (EASE_IN)
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.2)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)
	# Параллельно убираем прозрачность и чуть подбрасываем вверх (как дым)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.2)
	tween.parallel().tween_property(self, "position:y", -30.0, 0.2).as_relative()
	
	# Удаляем узел
	tween.tween_callback(queue_free)

func _ready() -> void:
	_animate()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		print(position)
