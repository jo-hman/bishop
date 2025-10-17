extends EnemyState

@export var chase_state: EnemyState


func enter(delta_accumulated: float) -> void:
	super.enter(delta_accumulated)
	
	owner.velocity = Vector2.ZERO
	print("Teleport")

func process_physics(delta: float) -> EnemyState:
	return null

func process_frame(delta: float) -> EnemyState:
	teleport_timer += delta

	if teleport_timer >= teleport_duration:
		return chase_state

	return null

func on_link_reached(details: Dictionary) -> EnemyState:
	
