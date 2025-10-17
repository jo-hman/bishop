class_name InAirState 
extends State

@export var max_fall_speed: float = 200.0  # Maximum horizontal speed while falling
@export var fall_acceleration: float = 5.0  # Horizontal acceleration while falling

var buffered_jump = true

func disallow_buffered_jump() -> void:
	buffered_jump = false

func handle_horizontal_velocity(movement_axis_speed: float, delta: float):
	if movement_axis_speed != 0:
		parent.animations.flip_h = movement_axis_speed < 0
		parent.velocity.x += movement_axis_speed * fall_acceleration * delta
		# Clamp the velocity to the maximum fall speed
		parent.velocity.x = clamp(parent.velocity.x, -max_fall_speed, max_fall_speed)
