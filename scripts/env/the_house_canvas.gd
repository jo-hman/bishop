# TheHouseCanvas.gd
class_name TheHouseCanvas
extends CanvasLayer

@onready var sprite_2d: Sprite2D = $env/Sprite2D

func fade_in() -> void:
	show()
	sprite_2d.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(sprite_2d, "modulate:a", 1.0, 0.5)

func fade_out(on_finished: Callable = Callable()) -> void:
	var tween = create_tween()
	tween.tween_property(sprite_2d, "modulate:a", 0.0, 0.5)
	tween.finished.connect(func ():
		hide()
		if on_finished.is_valid():
			on_finished.call()
	)
