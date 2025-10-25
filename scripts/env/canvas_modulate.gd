extends CanvasModulate

@export var start_point: Node2D
@export var middle_point: Node2D
@export var end_point: Node2D

@export var light_color: Color = Color(1, 1, 1, 1)
@export var dark_color: Color = Color(0, 0, 0, 0.6)
@export var fade_speed: float = 2.0

var target_color: Color
var player: Player

func _ready() -> void:
	target_color = light_color

func _process(delta: float) -> void:
	if player:
		var x = player.global_position.x
		var start_x = start_point.global_position.x
		var middle_x = middle_point.global_position.x
		var end_x = end_point.global_position.x

		if x <= start_x:
			target_color = light_color
		elif x < middle_x:
			var t = (x - start_x) / (middle_x - start_x)
			target_color = light_color.lerp(dark_color, t)
		elif x < end_x:
			var t = (x - middle_x) / (end_x - middle_x)
			target_color = dark_color.lerp(light_color, t)
		else:
			target_color = light_color

	color = color.lerp(target_color, delta * fade_speed)

func _on_atmosphere_change_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body

func _on_atmosphere_change_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
