# TheHouseCanvas.gd
class_name HousePE
extends Node2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var sprite_2d: Sprite2D = $CanvasLayer/Sprite2D

func fade_in() -> void:
	canvas_layer.show()
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


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print('aaaaa')
	if event is InputEventMouseButton and event.pressed:
		print('Clicked')
