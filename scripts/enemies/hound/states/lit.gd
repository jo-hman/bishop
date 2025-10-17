extends EnemyState

@export var stunned_state: EnemyState
@export var chase_state: EnemyState

# How fast the enemy slows down when lit
const SLOW_RATE := 0.5           # multiplier per second
const MIN_SPEED_MULTIPLIER := 0.2  # slowest speed (20%)
const STUN_TIME_THRESHOLD := 2.0   # seconds being lit before stun

var time_lit := 0.0
var speed_multiplier := 1.0


func enter(delta_accumulated: float) -> void:
	super.enter(delta_accumulated)
	time_lit = 0.0
	speed_multiplier = 1.0
	print("Lit")


func process_physics(delta: float) -> EnemyState:
	if is_hit_with_rays(): # Enemy has access to player rays
		# Increase time being lit
		time_lit += delta

		# Gradually slow down
		speed_multiplier = max(MIN_SPEED_MULTIPLIER, speed_multiplier - SLOW_RATE * delta)
		parent.velocity *= speed_multiplier
		parent.move_and_slide()

		# Become stunned if lit for too long
		if time_lit >= STUN_TIME_THRESHOLD:
			print("Enemy stunned!")
			if stunned_state:
				return stunned_state
	else:
		# If no longer hit by light, return to chase
		return chase_state

	return null
