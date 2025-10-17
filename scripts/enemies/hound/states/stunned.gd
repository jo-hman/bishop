extends EnemyState

@export var chase_state: EnemyState
var stun_timer := 0.0
@export var stun_duration := 2.0

func enter(delta_accumulated: float) -> void:
	super.enter(delta_accumulated)
	stun_timer = 0.0
	parent.velocity = Vector2.ZERO
	print("Enemy is stunned")

func process_physics(delta: float) -> EnemyState:
	stun_timer += delta
	parent.velocity = Vector2.ZERO

	if stun_timer >= stun_duration:
		print("Enemy recovers from stun")
		return chase_state

	return null
