extends EnemyState

@export var chase: EnemyState
@export var detection_range: float = 300.0

func enter(delta_accumulated: float) -> void:
	print("Idle")
	super.enter(delta_accumulated)
	parent.velocity = Vector2.ZERO

func process_physics(delta: float) -> EnemyState:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()

	# Jeśli gracz jest w zasięgu — przejdź do stanu Chase
	if _is_player_in_range():
		return chase

	return null

func _is_player_in_range() -> bool:
	if not parent.target:
		return false

	var distance = parent.global_position.distance_to(parent.target.global_position)
	return distance <= detection_range
