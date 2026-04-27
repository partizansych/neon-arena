class_name IFrame extends Node
## Часто нужен только из-за сигналов, к которым можно подключить шейдеры

@export var tick_interval: float = 0.05
@export var duration: float = 0.05

signal tick(frame_index: int, elapsed_time: float)
signal finished()

var _frame_index: int = 0
var _accumulator: float = 0.0
var _elapsed_time: float = 0.0
var _is_running: bool = false

func _ready() -> void:
	# Защита от деления на ноль / бесконечного цикла
	if tick_interval <= 0.0:
		push_warning("IFrame: tick_interval должен быть > 0. Установлено минимальное значение 0.001s")
		tick_interval = 0.001

func _process(delta: float) -> void:
	_accumulator += delta
	_elapsed_time += delta
	
	if duration > 0.0 and _elapsed_time >= duration:
		_elapsed_time = duration
		_accumulator = 0.0
		stop()
		finished.emit()
		return

	# Используем 'if' вместо 'while', чтобы пропущенные кадры не вызывали
	# каскадное срабатывание сигнала. Для шейдеров это критично: 
	# лучше пропустить один апдейт, чем вызвать 5 подряд за кадр.
	if _accumulator >= tick_interval:
		_accumulator -= tick_interval
		_frame_index += 1
		tick.emit(_frame_index, _elapsed_time)

func is_running() -> bool:
	return _is_running

## Запуск генерации тиков
func start() -> void:
	if _is_running: return
	reset()
	_is_running = true
	set_process(true)

## Остановка (полностью отключает вызов _process для экономии ресурсов)
func stop() -> void:
	if not _is_running: return
	_is_running = false
	set_process(false)

## Сброс счётчиков. Не останавливает таймер!
func reset() -> void:
	_frame_index = 0
	_accumulator = 0.0
	_elapsed_time = 0.0
