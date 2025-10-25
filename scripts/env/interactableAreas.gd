extends Node2D

@export var areas: Array[Area2D]

signal some_area_entered(area: Area2D, body: Node2D)
signal some_area_exited(area: Area2D, body: Node2D)

func _ready() -> void:
	for area in areas:
		if area:
			area.body_entered.connect(_on_area_body_entered.bind(area))
			area.body_exited.connect(_on_area_body_exited.bind(area))

func _on_area_body_entered(body: Node2D, area: Area2D) -> void:
	emit_signal("some_area_entered", area, body)

func _on_area_body_exited(body: Node2D, area: Area2D) -> void:
	emit_signal("some_area_exited", area, body)
